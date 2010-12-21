class Admin
  attr_accessor :username, :password

  def self.collection
    @collection = WardenDemo::DATABASE.collection("#{self.to_s.downcase}s")
  end

  def self.authenticate(username, password)
    collection.find({username: username, password: password}).first
  end

  def self.seed
    unless collection.find({username: "admin"}).first
      collection.insert({username: "admin", password: "password"})
    end
  end

end
