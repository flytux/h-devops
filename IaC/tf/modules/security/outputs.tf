
output "list-server-acg" {
  value = {
    for list in ncloud_access_control_group.instance-acg :
    list.name => list.id
  }
}
