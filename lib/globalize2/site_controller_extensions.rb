module Globalize2
  module SiteControllerExtensions
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :find_page, :globalize
        before_filter :set_locale
      end
    end


    module InstanceMethods
      def set_locale
        @locale = params[:locale] || Globalize2Extension.default_language
        I18n.locale = @locale.to_sym
      end
    end
    
    def find_page_with_globalize(url)
      globalized_url = '/' + I18n.locale.to_s + '/' + url
      find_page_without_globalize(globalized_url)
    end
  end
end