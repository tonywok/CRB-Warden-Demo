require 'digest/sha1'

class User
  attr_accessor :api_token, :email, :requests

  def self.collection
    @collection = WardenDemo::DATABASE.collection("#{self.to_s.downcase}s")
  end

  def self.generate_token_for(email)
    api_token = Digest::SHA1.hexdigest("email#{Time.now}")
  end

  def self.find_by_api_token(token)
    collection.find({api_token: token}).first
  end

  def self.inc_number_of_requests(user)
    val = user["num_requests"] += 1
    collection.update({'_id' => user['_id']}, {'$set' => {'num_requests' => val}})
  end

end
