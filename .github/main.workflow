workflow "Scan on push" {
  resolves = ["Secret Scan"]
  on = "push"
}

action "Secret Scan" {
  uses = "max/secret-scan@1.0.0"
}
