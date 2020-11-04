resource "helm_release" "l3moni-factorio" {

  name  = "l3moni-factorio"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart = "stable/factorio"
  version = "1.0.0"

  values = [
    "${file("values.yaml")}"
  ]

  set {
    name  = "username"
    value = "l3moni"
  }

  set {
    name  = "password"
    value = "s4l4s4n4"
  }
}