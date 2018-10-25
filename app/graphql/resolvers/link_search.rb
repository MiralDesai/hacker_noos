require 'search_object/plugin/graphql'

class Resolvers::LinkSearch
  include SearchObject.module(:graphql)

  scope { Link.all }

  type types[Types::LinkType]

  LinkFilter = GraphQL::InputObjectType.define do
    name 'LinkFilter'

    argument :OR, -> { types[LinkFilter] }
    argument :description_contains, types.String
    argument :url_contains, types.String
  end

  option :filter, type: LinkFilter, with: :apply_filter
  option :first, type: types.Int, with: :apply_first
  option :skip, type: types.Int, with: :apply_skip

  def apply_filter(scope, value)
    branches = normalise_filters(value).reduce { |a,b| a.or(b) }
    scope.merge branches
  end

  def normalise_filters(value, branches=[])
    scope = Link.all
    scope = scope.where('description LIKE ?', "%#{value['description_contains']}%") if value['description_contains'].present?
    scope = scope.where('url LIKE ?', "%#{value['url_contains']}%") if value['url_contains'].present?

    branches << scope

    value['OR'].reduce(branches) { |s, v| normalise_filters(v, s) } if value['OR'].present?

    branches
  end

  def apply_first(scope, value)
    scope.limit(value)
  end

  def apply_skip(scope, value)
    scope.offset(value)
  end

end
