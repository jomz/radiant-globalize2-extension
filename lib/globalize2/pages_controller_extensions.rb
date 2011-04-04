module Globalize2
  module PagesControllerExtensions
    def self.included(base)
      base.class_eval do
        before_filter :reset_locale, :only => [:new]
      end
    end
    
    def reset_locale
      Globalize2Extension.content_locale = session[:content_locale] = Globalize2Extension.default_language
    end
  end
end