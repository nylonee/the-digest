# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Source.create(name: "The Guardian")
Source.create(name: "The SBS")
Source.create(name: "The Sydney Morning Herald")
Source.create(name: "The New York Times", keyword: "science")
Source.create(name: "The New York Times", keyword: "singer")
Source.create(name: "The New York Times", keyword: "fashion")


