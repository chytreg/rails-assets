require "rubygems/indexer"

module RailsAssets
  class ReindexInProgress < Exception; end

  class HackedIndexer < Gem::Indexer
    def build_indicies
      # ----
      # Gem::Specification.dirs = []
      # Gem::Specification.add_specs(*map_gems_to_specs(gem_file_list))
      # ++++
      Gem::Specification.all = map_gems_to_specs(gem_file_list) # This line
      # ----

      build_marshal_gemspecs
      build_modern_indicies if @build_modern

      compress_indicies
    end
  end

  class Reindex
    include Sidekiq::Worker
    sidekiq_options :queue => :reindex

    def perform(force = false)
      index = Index.new

      if force || index.stale?
        puts "Generating index"
        index.with_lock do
          HackedIndexer.new(DATA_DIR).generate_index
          index.generated!
        end
      else
        puts "Index is fresh - skipping"
      end
    end
  end
end
