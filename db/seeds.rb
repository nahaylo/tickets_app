# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

['Waiting for Staff Response', 'Waiting for Customer', 'On Hold', 'Cancelled', 'Completed'].each do |status|
  Status.create(title: status)
end
