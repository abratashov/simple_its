# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Department.create!( name: 'DevTeam' )
Department.create!( name: 'QATeam' )
Department.create!( name: 'AdminTeam' )

Status.create!( name: 'Waiting for Staff Response' )
Status.create!( name: 'Waiting for Customer' )
Status.create!( name: 'On Hold' )
Status.create!( name: 'Cancelled' )
Status.create!( name: 'Completed' )

