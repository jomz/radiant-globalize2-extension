module Globalize2
  module FormBuilderExtensions
    def self.included(base)    
      base.alias_method_chain :text_field, :globalize
      base.alias_method_chain :text_area,  :globalize
    end
    
    def text_field_with_globalize(method, options = {})
      text_field_without_globalize(globalized_method_name(object_name,method), options)
    end
    
    def text_area_with_globalize(method, options = {})
      text_area_without_globalize(globalized_method_name(object_name,method), options)
    end

    def globalized_method_name(object_name,method)
      object_class = object_name.to_s.capitalize.constantize rescue nil
      if (object_class.respond_to? :translated_attribute_names) && (object_class.translated_attribute_names.include? method)
        method = "#{method}_#{Globalize2Extension.content_locale}".to_sym
      end
      method
    end
  end
end

ActionView::Helpers::FormBuilder.send(:include, Globalize2::FormBuilderExtensions)