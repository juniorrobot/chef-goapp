define :golang_deploy_config_and_monit do
  # application_name
  # golang_application_settings
  # hostname
  # deploy_to
  # env_vars
  # monit_conf_dir
  # group
  # user

  service 'monit' do
    action :nothing
  end

  template "#{params[:deploy_to]}/shared/config/env.properties" do
    source  'env.properties.erb'
    mode    '0660'
    owner    params[:user]
    group    params[:group]
    variables(
      :application_name => params[:application_name],
      :deploy_path      => params[:deploy_to],
      :env_vars         => params[:env_vars]
    )
  end
  
  template "#{params[:deploy_to]}/current/golang-#{params[:application_name]}-server-daemon" do
    source   'golang-server-daemon.erb'
    owner    'root'
    group    'root'
    mode     '0751'
    variables(
      :pid_file         => params[:golang_application_settings][:pid_file],
      :release_path     => "#{params[:deploy_to]}/current",
      :application_name => params[:application_name],
      :config_file      => params[:golang_application_settings][:config_file],
      :output_file      => params[:golang_application_settings][:output_file]
    )
  end
  
  template "#{params[:monit_conf_dir]}/golang_#{params[:application_name]}_server.monitrc" do
    source  'golang_server.monitrc.erb'
    owner   'root'
    group   'root'
    mode    '0644'
    variables(
      :application_name => params[:application_name],
      :release_path     => "#{params[:deploy_to]}/current",
      :port             => params[:env_vars]['PORT']
    )
    notifies :restart, resources(:service => 'monit'), :immediately
  end
end
