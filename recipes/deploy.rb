
node[:deploy].each do |application, _|
  if node[:deploy][application][:application_type] != 'golang'
    Chef::Log.debug("Skipping golang::deploy for application #{application} as it is not set as a golang app")
    next
  end
  
  golang_deploy_dir do
    user    node[:deploy][application][:user]
    group   node[:deploy][application][:group]
    path    node[:deploy][application][:deploy_to]
  end

  golang_scm do
    deploy_data   node[:deploy][application]
    app           application
    go_get?       node[:golang][application][:auto_go_get_on_deploy]
    go_build?     node[:golang][application][:auto_go_build_on_deploy]
    gopath        "#{node[:deploy][application][:deploy_to]}/current/build"
  end

  golang_deploy_config_and_monit do
    application_name             application
    hostname                     node[:hostname]
    basicauth_users              node[:golang][application][:basicauth_users]
    golang_application_settings  node[:golang][application]
    deploy_to                    node[:deploy][application][:deploy_to]
    env_vars                     node[:golang][application][:env]
    monit_conf_dir               node[:monit][:conf_dir]
    group                        node[:deploy][application][:group]
    user                         node[:deploy][application][:user]
    service_realm                node[:golang][application][:service_realm]
  end

  ruby_block "restart golang application #{application}" do
    block do
      Chef::Log.info("restart golang app server via: #{node[:golang][application][:restart_server_command]}")
      Chef::Log.info(`#{node[:golang][application][:restart_server_command]}`)
      $? == 0
    end
  end
end
