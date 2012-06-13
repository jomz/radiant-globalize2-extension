class UnremoveTranslatedAttributes < ActiveRecord::Migration
  def self.globalizable_content
    Globalize2Extension::GLOBALIZABLE_CONTENT
  end
  
  def self.up
    add_column :pages, :title, :string
    add_column :pages, :slug, :string, :limit => 100
    add_column :pages, :breadcrumb, :string, :limit => 160
    
    add_column :page_parts, :content, :text, :limit => 1048575
    add_column :layouts, :content, :text
    add_column :snippets, :content, :text
    # Auto-copy translations from *_translations tables
  end

  def self.down
    globalizable_content.each do |model, columns|
      columns.each do |column|
        remove_column model.table_name, column
      end
    end
  end
end
