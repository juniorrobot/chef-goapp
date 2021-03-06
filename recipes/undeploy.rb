include_recipe 'goapp::deploy'

node[:deploy].each do |application, _|
  if node[:deploy][application][:application_type] != 'goapp' || ( node[:deploy][application][:layers] && ( node[:deploy][application][:layers] & node[:opsworks][:instance][:layers] ).count == 0 )
    Chef::Log.debug("Skipping goapp::undeploy for application #{application} as it is not set as a goapp app for #{application} - restricted to layers: #{node[:deploy][application][:layers] || '<any>'}")
    next
  end

  ruby_block "stop goapp application #{application}" do
    block do
      Chef::Log.info("stop goapp application via: #{node[:goapp][application][:stop_server_command]}")
      Chef::Log.info(`#{node[:goapp][application][:stop_server_command]}`)
      $? == 0
    end
  end

  file "#{node[:monit][:conf_dir]}/goapp_#{application}_server.monitrc" do
    action :delete
    only_if do
      ::File.exists?("#{node[:monit][:conf_dir]}/goapp_#{application}_server.monitrc")
    end
  end

  directory "#{node[:deploy][application][:deploy_to]}" do
    recursive true
    action :delete

    only_if do
      ::File.exists?("#{node[:deploy][application][:deploy_to]}")
    end
  end
end
