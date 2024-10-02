# class Station declaration
class Station
  attr_reader :trains, :name

  def initialize(name)
    @name = name
    @trains = []
  end

  # public method to list of trains for the provided type
  def trains_by_type(type)
    trains.filter { |train| train.type == type }
  end

  # public method to add train to the station
  def add_train(train)
    trains << train
  end

  # public theod to remove(send) train from station
  def send_train
    trains.shift unless trains.empty?
  end
end
