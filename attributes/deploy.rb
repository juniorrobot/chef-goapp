include_attribute "goapp::configure"

node[:deploy].each do |application, _|
  
  if node[:deploy][application][:environment] && node[:deploy][application][:environment]["HOME"] && node[:deploy][application][:env]
    default[:goapp][application][:env] = {"HOME" => node[:deploy][application][:environment]["HOME"]}.merge(node[:deploy][application][:env])
  elsif node[:deploy][application][:environment] && node[:deploy][application][:environment]["HOME"]
    default[:goapp][application][:env] = {"HOME" => node[:deploy][application][:environment]["HOME"]}
  elsif node[:deploy][application][:env]
    default[:goapp][application][:env] = node[:deploy][application][:env]
  end
  
  default[:goapp][application][:restart_server_command] = "monit restart goapp_#{application}_server"
  default[:goapp][application][:stop_server_command] = "monit stop goapp_#{application}_server"
  
  default[:goapp][application][:config_file] = "#{node[:deploy][application][:deploy_to]}/shared/config/env.properties"
  default[:goapp][application][:pid_file] = "#{node[:deploy][application][:deploy_to]}/shared/pids/goapp.pid"
  default[:goapp][application][:output_file] = "#{node[:deploy][application][:deploy_to]}/shared/log/goapp.log"
end