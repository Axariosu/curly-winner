resource "random_id" "random" {
  keepers = {
    uuid = uuid()
  }
  byte_length = 8
}

resource "null_resource" "close_servicenow_change" {
  triggers = {
    random = random_id.random.hex
  }
  provisioner "local-exec" {
    command = "/bin/bash close_change23.sh"
    environment = {
      snow_instance = var.snow_instance
      username      = var.username
      password      = var.password
      client_id     = var.client_id
      client_secret = var.client_secret
    }
  }
}
