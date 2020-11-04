data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com/"
}

resource "helm_release" "l3moni-factorio" {

  name  = "l3moni-factorio"
  chart = "stable/factorio"


  values = [
    file("values.yaml")
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