include_recipe 'golang'

node[:deploy].each do |application, _|
  if node[:deploy][application][:application_type] != 'golang'
    Chef::Log.debug("Skipping golang::deploy for application #{application} as it is not set as a golang app")
    next
  end
  
  golang_user_and_group do
    user    node[:deploy][application][:user]
    group   node[:deploy][application][:group]
    home    node[:deploy][application][:home]
    shell   node[:deploy][application][:shell]
  end
  
  golang_deploy_dir do
    user    node[:deploy][application][:user]
    group   node[:deploy][application][:group]
    path    node[:deploy][application][:deploy_to]
  end
  
end
