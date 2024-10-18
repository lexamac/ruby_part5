require_relative 'instance_counter'

# class Station declaration
class Station
  include InstanceCounter
  include Validation

  attr_reader :trains, :name

  validate :name, :presence
  validate :name, :length,  6

  def self.all
    @@all_stations ||= []
  end

  def initialize(name)
    @name = name
    @trains = []

    validate!

    @@all_stations ||= []
    @@all_stations << self

    register_instance
  end

  # public method to validate stations data
  def valid?
    validate!
  rescue
    false
  end

  # public method to list of trains for the provided type
  def trains_by_type(type)
    trains.filter { |train| train.type == type }
  end

  # public method to add train to the station
  def add_train(train)
    trains << train
  end

  # public method to remove(send) train from station
  def send_train
    trains.shift unless trains.empty?
  end

  # public method to iterate over trains
  def each_train
    trains.each do |train|
      yield(train)
    end
  end

  # public method to string
  def to_s
    puts "Station Name: #{name}"
    puts "Trains on station = #{trains.length} :"
    each_train do |train|
      puts
      puts "Train Number: #{train.number}"
      puts "Train Type: #{train.type}"
      puts "Wagons Count: #{train.wagons_count}"
      puts
    end
  end
end
