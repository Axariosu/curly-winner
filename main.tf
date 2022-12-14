resource "random_id" "random" {
  keepers = {
    uuid = uuid()
  }
  byte_length = 8
}

resource "null_resource" "trigger" {
  triggers = {
    random = random_id.random.hex
  }
  provisioner "local-exec" {
    command = "/bin/bash break.sh"
  }
}

resource "null_resource" "depends_on_test" {
  depends_on = [
    null_resource.trigger
  ]
  provisioner "local-exec" {
    command = "/bin/bash close_change.sh"
    environment = {
      snow_instance = var.snow_instance
      username      = var.username
      password      = var.password
      client_id     = var.client_id
      client_secret = var.client_secret
      test          = "test"
    }
  }
}