module Globalize2
  module PagePartExtensions
    def self.included(base)
      base.alias_method_chain :content, :globalize
    end

    def clone
      new_page_part = super
      translations.each do |t|
        new_page_part.translations << t.clone
      end
      new_page_part
    end
    
    def content_with_globalize
      I18n.with_locale(Globalize2Extension.content_locale) do
        content_without_globalize
      end
    end
  end
end