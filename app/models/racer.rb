class Racer
  attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs

  # convenience method for access to client in console
  def self.mongo_client
    Mongoid::Clients.default
  end

  # convenience method for access to zips collection
  def self.collection
    self.mongo_client['racers']
  end

  def self.all(prototype={}, sort={:number=>1}, offset=0, limit=nil)
    result=collection.find(prototype)
      .sort(sort)
      .skip(offset)

    result=result.limit(limit) if !limit.nil?

    return result
  end
end
