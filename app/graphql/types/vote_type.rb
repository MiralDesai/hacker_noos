Types::VoteType = GraphQL::ObjectType.define do
  name 'Vote'

  field :id, types.Int
  field :user, -> { Types::UserType }
  field :link, -> { Types::LinkType }
end
