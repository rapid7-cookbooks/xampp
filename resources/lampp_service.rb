actions :nothing, :restart, :start, :stop

attribute :service, :kind_of => String, :name_attribute => true

default_action :nothing
