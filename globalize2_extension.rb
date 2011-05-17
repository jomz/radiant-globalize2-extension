# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

module I18n

  def self.lang
    config.lang
  end

  def self.lang=(value)
    config.lang = (value)
  end

  class Config
    # The only configuration value that is not global and scoped to thread is :locale.
    # It defaults to the default_locale.
    def lang
      @lang ||= default_locale
    end

    # Sets the current locale pseudo-globally, i.e. in the Thread.current hash.
    def lang=(lang)
      @lang = lang.to_sym rescue nil

    end
  end
end

class Globalize2Extension < Radiant::Extension
  version "0.1"
  description "Translate content in Radiant CMS using the Globalize2 Rails plugin."
  url "http://blog.aissac.ro/radiant/globalize2-extension/"

  GLOBALIZABLE_CONTENT = {

    Page     => [:title, :slug, :breadcrumb],
    PagePart => [:content],
    Layout   => [:content],
    Snippet  => [:content],
    PageField  => [:content]
  }
  
  def self.default_language
    @@default_language ||= Radiant::Config['globalize.default_language'].blank? ? "en" : Radiant::Config['globalize.default_language']
  end
  
  def self.languages
    @@languages ||= Radiant::Config['globalize.languages'].blank? ? [] : Radiant::Config['globalize.languages'].split(",").map(&:to_s)
  end
  
  def self.locales
    @@locales ||= [default_language, *languages].map(&:to_s)
  end
  
  def activate
    require 'i18n/backend/fallbacks'
    I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)

    admin.page.edit.add :form, 'admin/shared/change_locale', :before => 'edit_page_parts'
    admin.snippet.edit.add :form, 'admin/shared/change_locale', :before => 'edit_content'
    admin.layout.edit.add :form, 'admin/shared/change_locale', :before => 'edit_content'
    
    admin.page.index.add :top, 'admin/shared/change_locale_admin'
    admin.layout.index.add :top, 'admin/shared/change_locale_admin'
    admin.snippet.index.add :top, 'admin/shared/change_locale_admin'
    
    admin.page.index.add :sitemap_head, 'admin/shared/globalize_th'
    admin.page.index.add :node, 'admin/shared/globalize_td'
    
    I18n.default_locale = Globalize2Extension.default_language
    
    ApplicationController.send(:include, Globalize2::ApplicationControllerExtensions)
    Admin::ResourceController.send(:include, Globalize2::ApplicationControllerExtensions)
    Admin::PagesController.send(:include, Globalize2::ApplicationControllerExtensions)
    Admin::PagesController.send(:include, Globalize2::PagesControllerExtensions)
    Admin::PagesController.send(:include, Globalize2::ApplicationControllerExtensions)
    Admin::LayoutsController.send(:include, Globalize2::ApplicationControllerExtensions )
    Admin::SnippetsController.send(:include, Globalize2::ApplicationControllerExtensions)

    SiteController.send(:include, Globalize2::SiteControllerExtensions)

    GLOBALIZABLE_CONTENT.each do |model, columns|
      model.send(:translates, *columns)
      #p model.ancestors
    end

    Page.send(:include, Globalize2::GlobalizeTags)

    Page.class_eval {
      
      #extend Globalize2::PageExtensions::ClassMethods
      include  Globalize2::PageExtensions::InstanceMethods
    }

    #Page.send(:include, Globalize2::PageExtensions)
    PagePart.send(:include, Globalize2::PagePartExtensions)

    #compatibility
    CopyMove::Model.send(:include, Globalize2::Compatibility::CopyMove::CopyMoveModelExtensions) if defined?(CopyMoveExtension)
    ArchivePage.send(:include, Globalize2::Compatibility::Archive::ArchivePageExtensions) if defined?(ArchiveExtension)
    #ArchivePage.send(:include, Globalize2::GlobalizeTags) if defined?(ArchiveExtension)
    Page.send(:include, Globalize2::Compatibility::Vhost::PageExtensions) if defined?(VhostExtension)

    if defined?(PaginateExtension)
      Page.send(:include, Globalize2::Compatibility::Paginate::GlobalizeTags)
      Page.send(:include, Globalize2::Compatibility::Paginate::PageExtensions)
    end
  end
  
  def deactivate
  end
  
end
