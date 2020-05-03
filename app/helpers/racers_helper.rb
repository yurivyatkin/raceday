module RacersHelper
  # Our Racer.all method returns a collection of hashes
  # and not a collection of Racer instances
  # so that lazy loading can take place
  def toRacer(value)
    return value.is_a?(Racer) ? value : Racer.new(value)
  end
end
