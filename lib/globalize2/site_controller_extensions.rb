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
        Globalize2Extension.content_locale = I18n.locale = @locale.to_sym
      end
    end
    
    def find_page_with_globalize(url)
      if Globalize2Extension.locales.size > 1 && url[/css|js/].nil?
        url = '/' + I18n.locale.to_s + '/' + url
      end
      find_page_without_globalize(url)
    end
  end
end