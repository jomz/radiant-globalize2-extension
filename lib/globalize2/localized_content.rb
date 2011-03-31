module Globalize2::LocalizedContent
  def localized_content_for *fields
    fields.each do |field|
      class_eval %{
        def #{field}_with_localized_content
          I18n.with_locale(Globalize2Extension.content_locale) do
            #{field}_without_localized_content
          end
        end
      }

      alias_method_chain field, :localized_content
    end
  end
end