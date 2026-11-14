# frozen_string_literal: true

module Decidim
  module TaxonomyPosts
    class PostsController < Decidim::ApplicationController
      include Decidim::TranslatableAttributes

      helper Decidim::PaginateHelper
      helper Decidim::TranslationsHelper
      helper_method :root_taxonomy, :taxonomy, :posts

      def index
        raise ActionController::RoutingError, "Not Found" unless taxonomy
      end

      private

      def root_taxonomy
        @root_taxonomy ||= find_by_slug(
          Decidim::Taxonomy.where(organization: current_organization, parent_id: nil),
          params[:root_slug]
        )
      end

      def taxonomy
        return unless root_taxonomy

        @taxonomy ||= find_by_slug(tree.reject { |t| t.id == root_taxonomy.id }, params[:item_slug])
      end

      # Todos los nodos del árbol de la taxonomía raíz (máx. 3 niveles),
      # recorriendo parent_id en memoria.
      def tree
        @tree ||= begin
          all = Decidim::Taxonomy.where(organization: current_organization).to_a
          ids = [root_taxonomy.id]
          loop do
            children = all.select { |t| ids.include?(t.parent_id) && ids.exclude?(t.id) }.map(&:id)
            break if children.empty?

            ids.concat(children)
          end
          all.select { |t| ids.include?(t.id) }
        end
      end

      # Elemento seleccionado + todos sus descendientes.
      def taxonomy_ids
        ids = [taxonomy.id]
        loop do
          children = tree.select { |t| ids.include?(t.parent_id) && ids.exclude?(t.id) }.map(&:id)
          break if children.empty?

          ids.concat(children)
        end
        ids
      end

      def posts
        @posts ||= PostsByTaxonomy.new(current_organization, taxonomy_ids)
                                  .query
                                  .page(params[:page])
                                  .per(12)
      end

      # Coincide por nombre "parametrizado" en el idioma actual (o por id numérico).
      def find_by_slug(records, slug)
        records.find do |record|
          record.id.to_s == slug || translated_attribute(record.name).to_s.parameterize == slug.to_s.parameterize
        end
      end
    end
  end
end
