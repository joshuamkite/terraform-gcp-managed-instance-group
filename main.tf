resource "google_compute_instance_group_manager" "this" {
  name               = var.name
  base_instance_name = "instance"
  zone               = var.zone
  version {
    instance_template = google_compute_instance_template.this.id
  }

  target_size = 1

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_autoscaler" "this" {
  name   = var.name
  zone   = google_compute_instance_group_manager.this.zone
  target = google_compute_instance_group_manager.this.id

  autoscaling_policy {
    max_replicas = 5
    min_replicas = 1

    cpu_utilization {
      target = 0.6
    }
  }
}



resource "google_compute_instance_template" "this" {
  name         = var.name
  machine_type = var.machine_type

  disk {
    auto_delete  = true
    boot         = true
    source_image = "debian-cloud/debian-12"
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    echo "Running startup script..."
    apt-get update
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
    echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
EOT

  tags = ["http-server"]
}

resource "google_compute_backend_service" "this" {
  name                  = var.name
  protocol              = "HTTP"
  health_checks         = [google_compute_http_health_check.this.self_link]
  load_balancing_scheme = "EXTERNAL"

  backend {
    group = google_compute_instance_group_manager.this.instance_group
  }
}

resource "google_compute_http_health_check" "this" {
  name                = "http-health-check"
  request_path        = "/"
  port                = 80
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2 # Increase this to avoid flapping
  unhealthy_threshold = 2 # Set a minimum threshold for unhealthiness
}

resource "google_compute_url_map" "this" {
  name            = var.name
  default_service = google_compute_backend_service.this.self_link
}

resource "google_compute_target_http_proxy" "this" {
  name    = var.name
  url_map = google_compute_url_map.this.self_link
}

resource "google_compute_global_forwarding_rule" "this" {
  name                  = var.name
  target                = google_compute_target_http_proxy.this.self_link
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL"
}

resource "google_compute_firewall" "allow_health_check" {
  name    = "allow-health-check"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"] # Allow HTTP health check traffic
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"] # IP ranges for GCP health checks
  target_tags   = ["http-server"]
}


output "ip" {
  value = google_compute_global_forwarding_rule.this.ip_address
}
