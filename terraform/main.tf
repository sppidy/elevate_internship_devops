
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "ssh://root@ghostpxe-docker"
}

resource "docker_image" "spidy_app" {
  name         = "ghostpxe-docker:5000/spidy-elevatelabs-task2:latest"
  keep_locally = false
}

resource "docker_container" "spidy_container" {
  name  = "spidy-elevatelabs-task2-app"
  image = docker_image.spidy_app.name

  ports {
    internal = 10101
    external = 8181
  }

  restart = "unless-stopped"
}

