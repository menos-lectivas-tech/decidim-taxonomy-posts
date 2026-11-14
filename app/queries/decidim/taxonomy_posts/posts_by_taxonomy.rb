# frozen_string_literal: true

module Decidim
  module TaxonomyPosts
    # Entradas de blog (publicadas) de cualquier asamblea pública que tengan
    # asignado directamente alguno de los taxonomy_ids indicados.
    class PostsByTaxonomy < Decidim::Query
      def initialize(organization, taxonomy_ids)
        @organization = organization
        @taxonomy_ids = taxonomy_ids
      end

      def query
        assemblies = Decidim::Assembly.public_spaces.where(organization: @organization)

        components = Decidim::Component.published.where(
          manifest_name: "blogs",
          participatory_space_type: "Decidim::Assembly",
          participatory_space_id: assemblies.select(:id)
        )

        Decidim::Blogs::Post.where(id: post_ids)
                            .where(decidim_component_id: components.select(:id))
                            .published
                            .not_hidden
                            .includes(:component)
                            .order(published_at: :desc)
      end

      private

      # Las entradas se relacionan con la taxonomía a través de decidim_taxonomizations.
      def post_ids
        Decidim::Taxonomization.where(
          taxonomy_id: @taxonomy_ids,
          taxonomizable_type: "Decidim::Blogs::Post"
        ).select(:taxonomizable_id)
      end
    end
  end
end
