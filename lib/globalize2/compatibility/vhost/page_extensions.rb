module Globalize2::Compatibility
  module Vhost::PageExtensions
    def self.included(base)
      base.validate.delete_if { |v|
        (v.options[:scope].is_a?(Array)) ? v.options[:scope].include?("site_id") : false 
      }
    end
  end
end