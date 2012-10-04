require 'sunspot'
require 'mongomapper'
require 'sunspot/rails'

# == Examples:
#
# class Post
#   include MongoMapper::Document
#   field :title
# 
#   include Sunspot::MongoMapper
#   searchable do
#     text :title
#   end
# end
#
module Sunspot
  module MongoMapper
    def self.included(base)
      base.class_eval do
        extend Sunspot::Rails::Searchable::ActsAsMethods
        Sunspot::Adapters::DataAccessor.register(DataAccessor, base)
        Sunspot::Adapters::InstanceAdapter.register(InstanceAdapter, base)
      end
    end

    class InstanceAdapter < Sunspot::Adapters::InstanceAdapter
      def id
        @instance.id
      end
    end

    class DataAccessor < Sunspot::Adapters::DataAccessor
      def load(id)
        criteria(id).first
      end

      def load_all(ids)
        criteria(ids)
      end

      private

      def criteria(id)
        @clazz.criteria.id(id)
      end
    end
  end
end