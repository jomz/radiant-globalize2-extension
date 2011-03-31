module Globalize2
  module PagePartExtensions
    def self.included(base)
      base.class_eval do
        extend Globalize2::LocalizedContent
        
        localized_content_for :content
      end
    end

    def clone
      new_page_part = super
      translations.each do |t|
        new_page_part.translations << t.clone
      end
      new_page_part
    end
  end
end