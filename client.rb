require 'rest-client'  # => true
require 'json'         # => true
require 'time'         # => true

class RestExample
  def self.url=(url)
    @url = url        # => "http://localhost:3000"
  end
  def self.url
    @url              # => "http://localhost:3000", "http://localhost:3000", "http://localhost:3000"
  end

  class User
    attr_accessor :id, :name, :age, :created_at, :updated_at  # => nil
    def self.all
      path        = RestExample.url + "/users.json"         # => "http://localhost:3000/users.json"
      json        = RestClient.get path                       # => "[{\"id\":2,\"name\":\"Mike\",\"age\":1,\"url\":\"http://localhost:3000/users/2.json\"},{\"id\":3,\"name\":\"Cilian\",\"age\":121,\"url\":\"http://localhost:3000/users/3.json\"}]"
      users_array = JSON.parse json                           # => [{"id"=>2, "name"=>"Mike", "age"=>1, "url"=>"http://localhost:3000/users/2.json"}, {"id"=>3, "name"=>"Cilian", "age"=>121, "url"=>"http://localhost:3000/users/3.json"}]
      users_array.map do |user_data|                          # => [{"id"=>2, "name"=>"Mike", "age"=>1, "url"=>"http://localhost:3000/users/2.json"}, {"id"=>3, "name"=>"Cilian", "age"=>121, "url"=>"http://localhost:3000/users/3.json"}]
        new user_data                                         # => #<RestExample::User:0x007fdb03b29b30 @id=2, @age=1, @name="Mike">, #<RestExample::User:0x007fdb03b29518 @id=3, @age=121, @name="Cilian">
      end                                                     # => [#<RestExample::User:0x007fdb03b29b30 @id=2, @age=1, @name="Mike">, #<RestExample::User:0x007fdb03b29518 @id=3, @age=121, @name="Cilian">]
    end

    def self.find(id)
      path      = RestExample.url + "/users/#{id}.json"                                                                 # => "http://localhost:3000/users/2.json"
      json      = RestClient.get path                                                                                     # => "{\"id\":2,\"name\":\"Not Mike\",\"age\":1,\"created_at\":\"2014-03-27T17:50:26.876Z\",\"updated_at\":\"2014-03-27T20:18:46.072Z\"}"
      user_hash = JSON.parse json                                                                                         # => {"id"=>2, "name"=>"Not Mike", "age"=>1, "created_at"=>"2014-03-27T17:50:26.876Z", "updated_at"=>"2014-03-27T20:18:46.072Z"}
      new user_hash                                                                                                       # => #<RestExample::User:0x007fdb03b68678 @id=2, @age=1, @name="Not Mike", @created_at=#<DateTime: 2014-03-27T17:50:26+00:00 ((2456744j,64226s,876000000n),+0s,2299161j)>, @updated_at=#<DateTime: ...
    end
    def initialize(attributes)
      self.id         = attributes['id']                                                                                  # => 2, 2, 3
      self.age        = attributes['age']                                                                                 # => 1, 1, 121
      self.name       = attributes['name']                                                                                # => "Not Mike", "Mike", "Cilian"
      self.created_at = DateTime.parse attributes['created_at'] if attributes['created_at']                               # => #<DateTime: 2014-03-27T17:50:26+00:00 ((2456744j,64226s,876000000n),+0s,2299161j)>, nil, nil
      self.updated_at = DateTime.parse attributes['updated_at'] if attributes['updated_at']                               # => #<DateTime: 2014-03-27T20:18:46+00:00 ((2456744j,73126s,72000000n),+0s,2299161j)>, nil, nil
    end
    def save
      path   = RestExample.url + "/users/#{id}.json"                                                                    # => "http://localhost:3000/users/2.json"
      result = RestClient.put path, user: {id: id, age: age, name: name, created_at: created_at, updated_at: updated_at}  # => ""
      (200...300).include? result.code                                                                                    # => true
    end
  end
end

RestExample.url = "http://localhost:3000"  # => "http://localhost:3000"

user = RestExample::User.find 2  # => #<RestExample::User:0x007fdb03b68678 @id=2, @age=1, @name="Not Mike", @created_at=#<DateTime: 2014-03-27T17:50:26+00:00 ((2456744j,64226s,876000000n),+0s,2299161j)>, @updated_at=#<DateTime: ...

user.id          # => 2
user.name        # => "Not Mike"
user.age         # => 1
user.created_at  # => #<DateTime: 2014-03-27T17:50:26+00:00 ((2456744j,64226s,876000000n),+0s,2299161j)>
user.updated_at  # => #<DateTime: 2014-03-27T20:18:46+00:00 ((2456744j,73126s,72000000n),+0s,2299161j)>

user.name = 'Mike'  # => "Mike"
user.save           # => true



RestExample::User.all.each do |user|  # => [#<RestExample::User:0x007fdb03b29b30 @id=2, @age=1, @name="Mike">, #<RestExample::User:0x007fdb03b29518 @id=3, @age=121, @name="Cilian">]

  user.name  # => "Mike", "Cilian"
  user.age   # => 1, 121
end          # => [#<RestExample::User:0x007fdb03b29b30 @id=2, @age=1, @name="Mike">, #<RestExample::User:0x007fdb03b29518 @id=3, @age=121, @name="Cilian">]

