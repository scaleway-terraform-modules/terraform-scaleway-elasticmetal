module "elasticmetal" {
  source = "../.."

  name       = "my-server"
  project_id = "your-project-id"
  zone       = "fr-par-2"
  tags       = ["Env:Test"]

  bootstrap_ssh_key_name        = "my-bootstrap-key"
  bootstrap_ssh_key_secret_path = "/MY_PROJECT/MY_SERVER/SYSTEM_KEY"
}