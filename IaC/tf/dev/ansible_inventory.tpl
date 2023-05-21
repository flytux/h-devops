[webserver]
%{ for instance_name, instance_info in webserver_instances ~}
${instance_info.private_ip}  #${instance_name}(instance_info.id)
%{ endfor ~}

[solution]
%{ for instance_name, instance_info in solution_instances ~}
${instance_info.private_ip}  #${instance_name}(instance_info.id)
%{ endfor ~}
