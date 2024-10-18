# main code to test Trains from
require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'
require_relative 'instance_counter'
require_relative 'validation'
require_relative 'accessors'

# Main application class
class App
  include Accessors
  attr_reader :my_train, :my_route, :stations

  def initialize
    @stations = []
    @trains = []
    @my_route = nil
    @my_train = nil
  end

  # public method to show menu and start to interact with trains, stations and routes
  def run
    puts 'You entered modeling behavior system for trains, stations and routes. Please selecte an option to execute: '

    loop do
      print_menu
      option = gets.chomp.to_i
      break if option == 6

      menu_actions(option)
    end
  end

  private

  attr_writer :my_train, :my_route, :stations

  # private method to print the menu
  def print_menu
    puts
    puts '1. Create a Station'
    puts '2. Create a Route'
    puts '3. Create a Train'
    puts '4. Get Stations info'
    puts '5. Get Trains info'
    puts '6. Exit'
    puts
  end

  # private method to executed selected action
  def menu_actions(option)
    case option
    when 1 then create_stations
    when 2 then create_routes
    when 3 then create_trains
    when 4 then stations_info
    when 5 then trains_info
    else
      puts 'Unknown option was selected!'
    end
  end

  # private method to create stations
  def create_stations
    print 'Please enter a name for a station: '
    station_name = gets.chomp

    stations.push(Station.new(station_name))

    puts "Created stations: #{stations}"
  rescue ArgumentError => e
    puts 'Please review the errors and try to create a station once again!'
    puts "Error message: #{e.message}"

    retry
  end

  # private method to create routes
  def create_routes
    puts 'Please create at least Start and End stations before you will create a route and add stations to it!' if stations.empty? || stations.length < 2
    return create_stations if stations.empty? || stations.length < 2

    @my_route = Route.new(nil, nil)
    print 'Route was created, do you want to add stations to it? type y/n: '
    answer = gets.chomp
    add_stations = ['y', 'yes'].include?(answer.downcase)

    my_route.stations = Array.new(stations) if add_stations
    raise ArgumentError.new('At least Start and End stations should be created before Route could be created!') unless my_route.valid?

    @stations = [] if add_stations
  rescue ArgumentError => e
    puts 'Please review the errors and try to create a route once again:'
    puts "Error message: #{e.message}"
  end

  # private method to create trains
  def create_trains
    puts 'Please create at least one route before creating a train!' if my_route.nil?
    return if my_route.nil?

    puts 'Please enter a type of train you want to create(cargo or passenger): '
    train_type = gets.chomp.to_sym

    puts 'Please enter a train number: '
    number = gets.chomp

    @my_train = train_type == :cargo ? CargoTrain.new(number) : PassengerTrain.new(number)
    my_train.add_route(my_route)

    puts 'Train was created and assigned to route, you could proceed with moving train between stations'
  rescue ArgumentError => e
    puts 'Please review the errors and try to create a train once again!'
    puts "Error message: #{e.message}"

    retry
  ensure
    unless my_train.nil?
      @trains << my_train
      add_wagons
      move_trains
    end
  end

  # private method to add wagons
  def add_wagons
    loop do
      puts 'Please select an option to add or remove wagons from train:'
      puts
      puts '1. Add wagon'
      puts '2. Remove wagon'
      puts '3. Exit'
      puts
      wagon_option = gets.chomp.to_i

      case wagon_option
      when 1 then add_wagon
      when 2 then my_train.remove_wagon
      when 3
        break
      else
        puts 'Unknown option was selected!'
      end
    end
  end

  # private method to add wagons
  def add_wagon
    puts 'How many wagons do you want to add?'
    wagon_count = gets.chomp.to_i

    wagon_count.times do |index|
      print "Please enter #{index} cargo wagon volume: " if my_train.type == :cargo
      print "Please enter #{index} }passenger wagon size: " if my_train.type == :passenger
      wagon_size = gets.chomp.to_i

      my_train.add_wagon(my_train.type == :cargo ? CargoWagon.new(wagon_size) : PassengerWagon.new(wagon_size))
    end
  end

  # private method to move trains between stations
  def move_trains
    loop do
      puts 'Please select an option to move train between stations:'
      puts
      puts '1. Move forward'
      puts '2. Move backward'
      puts '3. Exit'
      puts
      move_option = gets.chomp.to_i

      case move_option
      when 1 then my_train.move_forward
      when 2 then my_train.move_backward
      when 3
        break
      else
        puts 'Unknown option was selected!'
      end
    end
  end

  def stations_info
    puts 'No stations creaetd yet!' if stations.empty?
    puts stations
  end

  def trains_info
    puts 'No trains created yet!' if @trains.empty?
    puts @trains
  end
end
