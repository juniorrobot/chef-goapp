include_recipe 'golang::deploy'

node[:deploy].each do |application, _|
  if node[:deploy][application][:application_type] != 'golang'
    Chef::Log.debug("Skipping golang::undeploy for application #{application} as it is not set as a golang app")
    next
  end

  ruby_block "stop golang application #{application}" do
    block do
      Chef::Log.info("stop golang application via: #{node[:golang][application][:stop_server_command]}")
      Chef::Log.info(`#{node[:golang][application][:stop_server_command]}`)
      $? == 0
    end
  end

  file "#{node[:monit][:conf_dir]}/golang_#{application}_server.monitrc" do
    action :delete
    only_if do
      ::File.exists?("#{node[:monit][:conf_dir]}/golang_#{application}_server.monitrc")
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
