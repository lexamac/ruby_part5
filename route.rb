require_relative 'instance_counter'

# class Route declaration
class Route
  include InstanceCounter

  attr_accessor :stations
  attr_reader :start_station, :end_station

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
    @stations.compact!

    register_instance
  end

  # public method to validate routes data
  def valid?
    validate!
  rescue
    false
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

  protected

  def validate!
    raise 'At least Start and End Stations should be created before Route could be created!' if @stations.compact.empty?
    raise 'At least Start and End Stations should be created before Route could be created!' if @stations.length < 2

    true
  end
end
