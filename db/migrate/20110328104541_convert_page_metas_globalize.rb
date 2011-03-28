class ConvertPageMetasGlobalize < ActiveRecord::Migration
  def self.up
# use this migration on radiant ~ 1.0.0

#    remove_index :page_fields, [:page_id, :name, :content]
#    add_index :page_fields, :page_id
#
#    I18n.locale = Radiant::Config['globalize.default_language']
#    Page.all.each do |page|
#      page.fields.create(:name => 'Keywords', :content => page.keywords)
#      page.fields.create(:name => 'Description', :content => page.description)
#    end
#
#
#    Radiant::Config['globalize.languages'].split(",").map(&:to_s).each do |lang|
#      I18n.locale = lang.to_sym
#      Page.all.each do |page|
#        ['Keywords','Description'].each do |field|
#          field_obj = page.fields.find_by_name(field)
#          field_obj.content = page.send(field.downcase)
#          field_obj.save!
#        end
#      end
#    end
#
#    remove_column :page_translations, :keywords
#    remove_column :page_translations, :description
  end

  def self.down
  end
end
