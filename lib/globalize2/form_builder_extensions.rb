module Globalize2
  module FormBuilderExtensions
    def self.included(base)    
      base.alias_method_chain :text_field, :globalize
      base.alias_method_chain :text_area,  :globalize
    end
    
    def text_field_with_globalize(method, options = {})
      Rails.logger.debug "FormBuilder: text_field_with_globalize"
      options[:value] = options[:value] || I18n.with_locale(Globalize2Extension.content_locale) { object && object.send(method) }
      text_field_without_globalize(method, options)
    end
    
    def text_area_with_globalize(method, options = {})
      options[:value] = options[:value] || I18n.with_locale(Globalize2Extension.content_locale) { object && object.send(method) }
      text_area_without_globalize(method, options)
    end
  end
end

ActionView::Helpers::FormBuilder.send(:include, Globalize2::FormBuilderExtensions)