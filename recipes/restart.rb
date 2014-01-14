include_recipe 'goapp::deploy'

node[:deploy].each do |application, _|
  if node[:deploy][application][:application_type] != 'goapp' || ( node[:deploy][application][:layers] && ( node[:deploy][application][:layers] & node[:opsworks][:instance][:layers] ).count == 0 )
    Chef::Log.debug("Skipping goapp::restart for application #{application} as it is not set as a goapp app for #{application} - restricted to layers: #{node[:deploy][application][:layers] || '<any>'}")
    next
  end
  
  ruby_block "restart goapp application #{application}" do
    block do
      Chef::Log.info("restart goapp application #{application} via: #{node[:goapp][application][:restart_server_command]}")
      Chef::Log.info(`#{node[:goapp][application][:restart_server_command]}`)
      $? == 0
    end
  end

end
