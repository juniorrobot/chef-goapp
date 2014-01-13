include_recipe 'golang::deploy'

node[:deploy].each do |application, _|
  if node[:deploy][application][:application_type] != 'golang'
    Chef::Log.debug("Skipping deploy::golang_restart for application #{application} as it is not set as a golang app")
    next
  end
  
  ruby_block "restart golang application #{application}" do
    block do
      Chef::Log.info("restart golang application #{application} via: #{node[:golang][application][:restart_server_command]}")
      Chef::Log.info(`#{node[:golang][application][:restart_server_command]}`)
      $? == 0
    end
  end

end
