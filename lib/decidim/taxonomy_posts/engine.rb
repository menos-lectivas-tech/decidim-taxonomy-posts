# frozen_string_literal: true

module Decidim
  module TaxonomyPosts
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::TaxonomyPosts

      routes do
        # El prefijo de idioma es opcional: /es/taxonomies/... y /taxonomies/... funcionan.
        # Decidim::LocaleSwitcher ya lee params[:locale].
        scope "(:locale)", locale: /[a-z]{2}(-[A-Z]{2})?/ do
          get "taxonomies/:root_slug/:item_slug", to: "posts#index", as: :taxonomy_posts
        end
      end

      initializer "decidim_taxonomy_posts.mount_routes", before: :add_routing_paths do
        Decidim::Core::Engine.routes.append do
          mount Decidim::TaxonomyPosts::Engine => "/"
        end
      end
    end
  end
end
