# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
require 'json'

def seed_user
  (1..4).each do
    User.create(user_name: Faker::Name.name)
  end
end

def seed_location
  directories = [
    'db/Dataset/user1/**/*.json',
    'db/Dataset/user2/**/*.json',
    'db/Dataset/user3/**/*.json',
    'db/Dataset/user4/**/*.json',
  ]
  User.all.each_with_index do |user, index|
    Dir.glob(directories[index%4]) do |rb_filename|
      data_hash = JSON.parse(File.read(rb_filename))
      data_hash['timelineObjects'].each do |object|
        if object['placeVisit']
          location = object['placeVisit']['location']
          start_time = DateTime.strptime(object['placeVisit']['duration']['start_time'] || object['placeVisit']['duration']['startTimestampMs'],'%Q')
          end_time = DateTime.strptime(object['placeVisit']['duration']['end_time'] || object['placeVisit']['duration']['endTimestampMs'],'%Q')
          user.locations.create(
            latitude: location['latitudeE7'],
            longitude: location['longitudeE7'],
            place_id: location['placeId'],
            address: location['address'],
            location_name: location['name'],
            semantic_type: location['semanticType'],
            confidence: location['locationConfidence'],
            start_time: start_time,
            end_time: end_time,
          )
          puts "Locations Count: #{Location.count}"
        end
      end
    end
  end
end

seed_user
seed_location