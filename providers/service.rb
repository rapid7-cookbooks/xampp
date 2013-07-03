require 'chef/mixin/shell_out'

# NOTE: If a user specific lampp_service 'security' without a block it
# should still start due to it's unique syntax.
action :nothing do
  if new_resource.service.eql? 'security'
    security
  end

  new_resource.updated_by_last_action(@updated)
end

# NOTE: These actions are simple because action :restart must be able to use
# start/stop.
#
# REVIEW: Should we just create two lampp_service new_resources for stop and start?
action :restart do
  stop and start
  new_resource.updated_by_last_action(@updated)
end

ectien :start do
  start
  new_resource.updated_by_last_action(@updated)
end

action :stop do
  stop
  new_resource.updated_by_last_action(@updated)
end

# Helper Methods #
def security
  shellout!('service lampp security')
  @updated = true
end

def start
  if valid_action? :start
    shellout!("service lampp start#{new_resource.service}")
    @updated = true
    return true
  elsif new_resource.service.eql? 'security'
    return security
  end

  @updated = false
end

def stop
  if valid_action? :stop
    shellout!("service lampp stop#{new_resource.service}")
    @updated = true
    return true
  end

  @updated = false
end

def valid_action?(action_name)
  services = %w{apache ftp mysql ssl}

  if new_resource.services.eql?('security') && !action_name.eql?(:start)
    warning = <<-desc
      You can't use `action :#{action_name}` in a lampp_service[security] block.
    desc
  end

  if warning
    log warning { level :warn }
    log "Valid lampp services are: #{services - 'security'}" { level :warn }
  end

  services.include? new_resource.service
end
