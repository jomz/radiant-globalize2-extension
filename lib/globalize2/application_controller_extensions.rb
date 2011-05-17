module Globalize2
  module ApplicationControllerExtensions
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        before_filter :set_locale
      end
    end

    module InstanceMethods
      def set_locale
        @locale = params[:locale] || session[:locale] || Globalize2Extension.default_language
        @lang = params[:lang] || session[:lang] || Globalize2Extension.default_language

        session[:locale] = @locale
        I18n.locale = @locale.to_sym
        session[:lang] = @lang
        I18n.lang = @lang.to_sym
      end
      
      def reset_locale
        unless I18n.locale.to_s == Globalize2Extension.default_language
          locale = Globalize2Extension.default_language
          session[:locale] = locale
          I18n.locale = locale.to_sym
          flash.now[:notice] = "The locale has been changed to default."
        end
      end
    end
  end
end