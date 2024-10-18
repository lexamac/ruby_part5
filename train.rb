require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'validation'

# class Train declaration
class Train
  include Manufacturer
  include InstanceCounter
  include Validation

  attr_reader :speed, :type, :number

  NUMBER_FORMAT = /^[a-z\d]{3}-?[a-z\d]{2}$/i.freeze
  VALID_TYPES = [:cargo, :passenger]

  validate :number, :presence
  validate :number, :length,  6
  validate :number, :format,  NUMBER_FORMAT
  validate :type,   :include, VALID_TYPES
  validate :speed,  :positive

  def self.find(number)
    @@all_trains ||= []
    (@@all_trains.filter { |item| item.number == number })[0] # to return nil per requirements
  end

  def initialize(number, type)
    @number = number
    @type = type
    @speed = 0

    validate!

    @route = Route.new(nil, nil)
    @wagons = []

    @@all_trains ||= []
    @@all_trains << self

    register_instance
  end

  # public method to validate trains data
  def valid?
    validate!
  rescue
    false
  end

  # public method to speed up train
  def increase_speed
    speed += 1
  end

  # public method to stop train
  def stop
    speed = 0
  end

  # public method to add wagons to train
  def add_wagon(wagon)
    puts 'Train must be stopped before wagons could be added!' unless speed.zero?
    return unless speed.zero?

    puts 'Invalid type of wagon for this kind of Train!' unless type == wagon.type
    return unless type == wagon.type

    @wagons << wagon
  end

  # public method to remove wagons from train
  def remove_wagon
    puts 'Train must be stopped before wagons could be removed' unless speed.zero?
    return unless speed.positive?

    @wagons.pop

    puts "Wagon was removed, train has #{@wagons.length} wagons now."
  end

  # public method to get wagons count
  def wagons_count
    @wagons.length
  end

  # public method to iterate over wagons
  def each_wagon
    @wagons.each do |wagon|
      yield(wagon)
    end
  end

  # public method to string
  def to_s
    puts "Train Number: #{number}, Type: #{type.to_s}, Speed: #{speed}"
    puts "Wagons Count: #{wagons_count}"
    each_wagon do |wagon|
      puts
      puts "Wagon Number: #{wagon.number}"
      puts "Wagon Type: #{wagon.type}"
      puts "Free volume #{wagon.free_volume}, Taken volume: #{wagon.taken_volume}" if wagon.type == :cargo
      puts "Free seats #{wagon.free_seats}, Taken seats: #{wagon.taken_seats}" if wagon.type == :passenger
      puts
    end
  end

  # public method to set Route
  def add_route(route)
    raise ArgumentError.new('Route can\'t be nil') if route.nil?

    @route = route

    @station_position = 0
    current_station.add_train(self)

    puts "Route was assigned to Train # #{number}."
  end

  # public method to move train backward
  def move_forward
    return if @route.nil? || @route.end_station == current_station

    current_station.send_train
    puts "Train #{number} depatured from sation #{current_station.name}"
    @station_position += 1
    current_station.add_train(self)
    puts "Train #{number} arrived to sation #{current_station.name}"
  end

  # public method to move train forward
  def move_backward
    return if @route.nil? || @route.start_station == current_station

    current_station.send_train
    puts "Train #{number} depatured from sation #{current_station.name}"
    @station_position -= 1
    current_station.add_train(self)
    puts "Train #{number} arrived to sation #{current_station.name}"
  end

  protected

  # none public method for internal use to get current station info
  def current_station
    @route.stations[@station_position]
  end

  # none public method for internal use to get next station info
  def next_station
    @route.stations[@station_position + 1]
  end

  # none public method for internal use to get previous station info
  def previous_station
    @route.stations[@station_position - 1]
  end
end
