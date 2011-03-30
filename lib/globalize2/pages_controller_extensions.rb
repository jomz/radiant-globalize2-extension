module Globalize2
  module PagesControllerExtensions
    def self.included(base)
      base.class_eval do
        before_filter :reset_locale, :only => [:new]
      end
    end
    
    def reset_locale
      @locale = Globalize2Extension.default_language
      Globalize2Extension.content_locale = I18n.locale = @locale.to_sym
    end
  end
end