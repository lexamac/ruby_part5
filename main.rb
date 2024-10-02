# main code to test Trains from
require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

stations = []
my_route = nil
my_train = nil

puts 'You entered modeling behavior system for trains, stations and routes. Please selecte an option to execute: '

loop do
  puts
  puts '1. Create a Station'
  puts '2. Create a Route'
  puts '3. Create a Train'
  puts '4. Exit'
  puts
  option = gets.chomp.to_i

  case option
  when 1
    print 'Please enter a name for a station: '
    station_name = gets.chomp

    stations << Station.new(station_name)

    puts "Created stations: #{stations}"
  when 2
    puts 'Please create stations before you will create a route and add stations to it!' if stations.empty?
    next if stations.empty?

    my_route = Route.new(nil, nil)
    print 'Route was created, do you want to add stations to it? type y/n: '
    answer = gets.chomp
    add_stations = ['y', 'yes'].include?(answer.downcase)

    my_route.stations = Array.new(stations) if add_stations
    stations = [] if add_stations
  when 3
    puts 'Please create at least one route before creating a train!' if my_route.nil?
    next if my_route.nil?

    puts 'Please enter a type of train you want to create(cargo or passenger): '
    train_type = gets.chomp.to_sym

    puts 'Please enter a train number: '
    number = gets.chomp

    my_train = train_type == :cargo ? CargoTrain.new(number) : PassengerTrain.new(number)
    my_train.add_route(my_route)

    puts 'Train was created and assigned to route, you could proceed with moving train between stations'
    loop do
      puts 'Please select an option to move train between stations:'
      puts '1. Move forward'
      puts '2. Move backward'
      puts '3. Exit'
      move_option = gets.chomp.to_i

      case move_option
      when 1
        my_train.move_forward
      when 2
        my_train.move_backward
      when 3
        break
      else
        puts 'Unknown option was selected!'
      end
    end
  when 4
    break
  else
    puts 'Unknown option was selected!'
  end
end
