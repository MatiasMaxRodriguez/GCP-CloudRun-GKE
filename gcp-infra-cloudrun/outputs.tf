# Output global en la raíz para ver la URL final en la consola al terminar
output "url_de_la_app" {
  value       = module.compute.app_url
  description = "Entrá acá para probar tu app Node.js"
}

output "ruta_del_repositorio" {
  value       = module.compute.repository_url
  description = "Usá esta ruta para taggear y subir tu imagen Docker"
}