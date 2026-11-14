# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)
require "decidim/taxonomy_posts/version"

Gem::Specification.new do |s|
  s.version = Decidim::TaxonomyPosts::VERSION
  s.authors = ["Paco Andŕés", "Claude"]
  s.summary = "List the blog posts from the assemblies associated with a taxonomy item"
  s.description = "A Decidim module for adding the route /taxonomies/:taxonomy/:item for showing the blog entries list."
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/pacoandres/decidim-taxonomy_posts"
  s.name = "decidim-taxonomy_posts"
  s.files = Dir["{app,config,lib}/**/*", "README.md"]
  s.add_dependency "decidim-assemblies", ">= 0.32.0", "< 0.33"
  s.add_dependency "decidim-blogs", ">= 0.32.0", "< 0.33"
  s.add_dependency "decidim-core", ">= 0.32.0", "< 0.33"
end
