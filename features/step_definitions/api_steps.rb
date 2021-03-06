require 'minitest/autorun'
require 'rest_client'
require 'json'


incident1 = Hash.new
incident1["description"] = "it's bad, real bad too bad very bad. I can't"
incident1["severity"] = 3
incident1["location"] = "42.3601, 71.0589"
incident1["created_at"] = "1999-12-31 11:59:59"


incident2 = Hash.new
incident2["description"] = "it's bad, real bad too bad very bad"
incident2["severity"] = 3
incident2["location"] = "42.3601, 71.0589"
incident2["created_at"] = "1999-12-31 11:59:59"

bad_data = Hash.new
bad_data["description"] = 2
bad_data["severity"] = "apple"
bad_data["location"] = 124
bad_data["created_at"] = "yesterday"

When /^I add an incident report to the database$/ do
  response = RestClient.post("api.dirt.frontfish.net/incidents/new",
             {
              "description" => incident1["description"],
              "severity" => incident1["severity"],
              "location" => incident1["location"],
              "created_at" => incident1["created_at"]
              }
  )
  $data = JSON.parse response.body
end

When /^I add (\d+) incident reports to the database$/ do |num_inc|
  $data_array = Array.new(num_inc.to_i)
    num_inc.to_i.times do |index|

      response = RestClient.post("api.dirt.frontfish.net/incidents/new",

                                 {
                                     "description" => incident2["description"],
                                     "severity" => incident2["severity"],
                                     "location" => incident2["location"],
                                     "created_at" => incident2["created_at"]
                                 }
      )
    $data_array[index] = JSON.parse response.body
    end
end


Then /^I can retrieve the incident from the database$/ do
  response = RestClient.get("api.dirt.frontfish.net/incidents/#{$data["id"]}")
  $data = JSON.parse response.body
  assert $data['description']  == incident1["description"]
  assert $data['severity']  == incident1["severity"]
  assert $data['status'] == 0
  assert $data['user_id'] == 1

end


Then /^I can retrieve all (\d+) incident reports from the database$/ do |num_inc|
  num_inc.to_i.times do |index|
    response = RestClient.get("api.dirt.frontfish.net/incidents/#{$data_array[index]["id"]}")
    assert $data_array[index]['description']  == incident2["description"]
    assert $data_array[index]['severity']  == incident2["severity"]
    assert $data_array[index]['status'] == 0
    assert $data_array[index]['user_id'] == 1
  end
end

Then /^The incident report entry is returned$/ do
  assert $data['description']  == incident1["description"]
  assert $data['severity']  == incident1["severity"]
  assert $data['status'] == 0
  assert $data['user_id'] == 1
end

When /^I attempt to add an incident with extraneous data$/ do

end


Then /^I receive the error message ("[^"]*")$/ do |error_msg|
  assert $data  == error_msg
end



When /^I add an incident with inappropriate (.*) value$/ do |bad_param|

  case bad_param

    when "date"
      response = RestClient.post("api.dirt.frontfish.net/incidents/new",
                                 {
                                     "description" => incident1["description"],
                                     "severity" => incident1["severity"],
                                     "location" => incident1["location"],
                                     "created_at" => bad_data["created_at"]
                                 }
      )
      $data = response.body
    when "description"
      response = RestClient.post("api.dirt.frontfish.net/incidents/new",
                                 {
                                     "description" => bad_data["description"],
                                     "severity" => incident1["severity"],
                                     "location" => incident1["location"],
                                     "created_at" => incident1["created_at"]
                                 }
      )
      $data = response.body

    when "location"
      response = RestClient.post("api.dirt.frontfish.net/incidents/new",
                                 {
                                     "description" => incident1["description"],
                                     "severity" => incident1["severity"],
                                     "location" => bad_data["location"],
                                     "created_at" => incident1["created_at"]
                                 }
      )
      $data = response.body
    when "severity"
      response = RestClient.post("api.dirt.frontfish.net/incidents/new",
                                 {
                                     "description" => incident1["description"],
                                     "severity" => bad_data["severity"],
                                     "location" => incident1["location"],
                                     "created_at" => incident1["created_at"]
                                 }
      )
      $data = response.body

  end
end

When /^I attempt to give an incident an inappropriate (.*) value$/ do |bad_param|

end

When /^I attempt to add an incident with extraneous data do$/ do

end


