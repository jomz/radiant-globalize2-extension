module Globalize2
  module GlobalizedFieldsControllerExtension
    def self.included base
      base.prepend_before_filter :set_content_locale
    end


    def update
      I18n.with_locale(Globalize2Extension.content_locale) do
        model.update_attributes!(params[model_symbol])
      end
      
      response_for :update
    end
    
    def create
      I18n.with_locale(Globalize2Extension.content_locale) do
        model.update_attributes!(params[model_symbol])
      end
      
      response_for :create
    end

    private
    def set_content_locale
      Globalize2Extension.content_locale = params[:content_locale] || session[:content_locale] || Globalize2Extension.default_language
      session[:content_locale] = params[:content_locale] if params[:content_locale]
    end
  end
end