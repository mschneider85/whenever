# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10.times do
  Survey.last.participations.create
end

Participation.all.each do |participation|
  Survey.last.fields.each do |field|
    participation.answers.create_with(text: 'asdasd'.chars.sample(4).join).find_or_create_by(field: field)
  end
end
