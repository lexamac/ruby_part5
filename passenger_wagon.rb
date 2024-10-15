# class PassengerWagon declaration
class PassengerWagon < Wagon
  def initialize(total_seats)
    super(:passenger, total_seats)
  end

  def take_seat
    total_capacity(1)
  end
end
