Types::UserType = GraphQL::ObjectType.define do
  name 'User'

  field :id, types.Int
  field :email, types.String
  field :name, types.String
  field :votes, -> { types[Types::VoteType] }
end
