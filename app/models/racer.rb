class Racer
	attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs

	def initialize(params={})
		# Test whether the hash is coming from a web page [:id]
		# or from a MongoDB query [:_id] and assign the value to whichever is non-nil
		@id=params[:_id].nil? ? params[:id] : params[:_id].to_s
		@number=params[:number].to_i
		@first_name=params[:first_name]
		@last_name=params[:last_name]
		@gender=params[:gender]
		@group=params[:group]
		@secs=params[:secs].to_i
	end

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

	# Must handle when id is either a string or BSON::ObjectId
	def self.find id
		_id = id.instance_of?(String) ?  BSON::ObjectId.from_string(id) : id
		result=collection
			.find(:_id=>_id)
			.first
		return result.nil? ? nil : Racer.new(result)
	end

	def save 
		result=self.class.collection
			.insert_one(
				_id:@id,
				number:@number,
				first_name:@first_name,
				last_name:@last_name,
				gender:@gender,
				group:@group,
				secs:@secs)
		@id=result.inserted_id.to_s
	end

	def update(params)
		@number=params[:number].to_i
		@first_name=params[:first_name]
		@last_name=params[:last_name]
		@gender=params[:gender]
		@group=params[:group]
		@secs=params[:secs].to_i
		params.slice!(:number, :first_name, :last_name, :gender, :group, :secs)
		self.class.collection
			.find({ _id: BSON::ObjectId.from_string(@id) })
			.replace_one(params)
	end

  def destroy
    self.class.collection
			.find({ _id: BSON::ObjectId.from_string(@id) })
			.delete_one   
  end
end
