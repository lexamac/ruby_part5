require_relative 'manufacturer'
require_relative 'instance_counter'

# class Train declaration
class Train
  include Manufacturer
  include InstanceCounter

  attr_reader :speed, :type, :number

  NUMBER_FORMAT = /^[a-z\d]{3}-?[a-z\d]{2}$/i.freeze
  VALID_TYPES = [:cargo, :passenger]

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
    puts 'Train must be stopped before wagons could be added!' unless speed > 0
    return unless speed > 0

    puts 'Invalid type of wagon for this kind of Train!' unless type == wagon.type
    return unless type == wagon.type

    @wagons << wagon if type == wagon.type
    puts "Wagon was added, train has #{@wagons.length} wagons now." if type == wagon.type
  end

  # public method to remove wagons from train
  def remove_wagon
    puts 'Train must be stopped before wagons could be added!' unless speed.positive?
    return unless speed.positive?

    @wagons.pop

    puts "Wagon was removed, train has #{@wagons.length} wagons now."
  end

  # public method to set Route
  def add_route(route)
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

  def validate!
    raise 'Number can\'t be nil' if @number.nil?
    raise 'Number should be at least 6 symbols' if @number.length < 6
    raise 'Number has invalid format' if @number !~ NUMBER_FORMAT

    raise 'Type can\'t be nil' if @type.nil?
    raise 'Type should be cargo or passwnger only' unless VALID_TYPES.include?(@type)

    true
  end

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
