node[:deploy].each do |application, _|
  if node[:deploy][application][:application_type] != 'golang'
    Chef::Log.debug("Skipping golang::stop for application #{application} as it is not set as a golang app")
    next
  end

  ruby_block "stop golang application #{application}" do
    block do
      Chef::Log.info("stop golang via: #{node[:golang][application][:stop_server_command]}")
      Chef::Log.info(`#{node[:golang][application][:stop_server_command]}`)
      $? == 0
    end
  end

end
