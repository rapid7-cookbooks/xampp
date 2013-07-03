require 'chef/mixin/shell_out'

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
  start
end

action :stop do
  stop
end

# Helper Methods #
def security
  shellout!('service lampp security')

  new_resource.update_by_last_action(true)
end

def start
  if valid_action? :start
    shellout!("service lampp start#{new_resource.service}")
    new_resource.update_by_last_action(true)
    return true
  elsif new_resource.service.eql? 'security'
    return security
  end

  new_resource.update_by_last_action(false)
end

def stop
  if valid_action? :stop
    shellout!("service lampp stop#{new_resource.service}")
    new_resource.update_by_last_action(true)
    return true
  end

  new_resource.update_by_last_action(false)
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
