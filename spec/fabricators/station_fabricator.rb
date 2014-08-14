Fabricator(:station) do
  name { Faker::Address.city }
end