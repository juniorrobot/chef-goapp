include_attribute "golang::configure"

node[:deploy].each do |application, _|
  
  if node[:deploy][application][:environment] && node[:deploy][application][:environment]["HOME"] && node[:deploy][application][:env]
    default[:golang][application][:env] = {"HOME" => node[:deploy][application][:environment]["HOME"]}.merge(node[:deploy][application][:env])
  elsif node[:deploy][application][:environment] && node[:deploy][application][:environment]["HOME"]
    default[:golang][application][:env] = {"HOME" => node[:deploy][application][:environment]["HOME"]}
  elsif node[:deploy][application][:env]
    default[:golang][application][:env] = node[:deploy][application][:env]
  end
  
  default[:golang][application][:restart_server_command] = "monit restart golang_#{application}_server"
  default[:golang][application][:stop_server_command] = "monit stop golang_#{application}_server"
  
  default[:golang][application][:config_file] = "#{node[:deploy][application][:deploy_to]}/shared/config/env.json"
  default[:golang][application][:pid_file] = "#{node[:deploy][application][:deploy_to]}/shared/pids/nutty.pid"
  default[:golang][application][:output_file] = "#{node[:deploy][application][:deploy_to]}/shared/log/nutty.log"
end