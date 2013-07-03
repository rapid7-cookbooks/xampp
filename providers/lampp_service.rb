require 'chef/mixin/shell_out'

# NOTE: If a user specific lampp_service 'security' without a block it
# should still start due to it's unique syntax.
action :nothing do
  if resource.service.eql? 'security'
    security
  end
end

# NOTE: These actions are simple because action :restart must be able to use
# start/stop.
#
# REVIEW: Should we just create two lampp_service resources for stop and start?
action :restart { stop and start }
action :start { start }
action :stop { stop }

# Helper Methods #
def security
  shellout!('service lampp security')
end

def start
  if valid_action? :start
    shellout!("service lampp start#{resource.service}")
  elsif resource.service.eql? 'security'
    security
  end
end

def stop
  if valid_action? :stop
    shellout!("service lampp stop#{resource.service}")
  end
end

def valid_action?(action_name)
  services = %w{apache ftp mysql ssl}

  if resource.services.eql?('security') && !action_name.eql?(:start)
    warning = <<-desc
      You can't use `action :#{action_name}` in a lampp_service[security] block.
    desc
  end

  if warning
    log warning { level :warn }
    log "Valid lampp services are: #{services - 'security'}" { level :warn }
  end

  services.include? resource.service
end
