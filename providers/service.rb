require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

# NOTE: If a user specific lampp_service 'security' without a block it
# should still start due to it's unique syntax.
action :nothing do
  if new_resource.service.eql? 'security'
    security
  end
end

# NOTE: These actions are simple because action :restart must be able to use
# start/stop.
#
# REVIEW: Should we just create two lampp_service new_resources for stop and start?
action :restart do
  stop and start
end

action :start do
  success = start
  new_resource.updated_by_last_action(success)
end

action :stop do
  success = stop
  new_resource.updated_by_last_action(success)
end

# Helper Methods #
def security
  shell_out!('service lampp security')
  new_resource.updated_by_last_action(true)
end

def start
  if valid_action? :start
    shell_out!("service lampp start#{new_resource.service}")
    new_resource.updated_by_last_action(true)
  elsif new_resource.service.eql? 'security'
    security
  end
end

def stop
  if valid_action? :stop
    shell_out!("service lampp stop#{new_resource.service}")
    new_resource.updated_by_last_action(true)
  end
end

def valid_action?(action_name)
  services = %w{apache ftp mysql ssl}

  if new_resource.service.eql?('security') && !action_name.eql?(:start)
    warning = <<-desc
      You can't use `action :#{action_name}` in a lampp_service[security] block.
    desc
  end

  if warning
    warning << " Valid lampp services are: #{services - 'security'}"

    log warning do
      level :warn
    end
  end

  services.include? new_resource.service
end
