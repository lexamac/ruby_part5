# class Route declaration
class Route
  attr_accessor :stations
  attr_reader :start_station, :end_station

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
  end

  # public method to add additional station to route
  def add_station(station)
    stations.insert(-2, station)
  end

  # public method to remove stations from route
  def remvoe_station
    stations.delete_at(-2) if @stations.length > 2
  end

  # public method to get info about first station
  def first_station
    stations.first
  end

  # public method to get info about las station
  def last_station
    stations.last
  end
end
