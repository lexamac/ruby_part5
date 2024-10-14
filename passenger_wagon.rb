# class PassengerWagon declaration
class PassengerWagon < Wagon
  attr_reader :free_seats, :taken_seats, :total_seats

  def initialize(total_seats)
    super(:passenger)

    @total_seats = total_seats
    @total_seats = total_seats
    @taken_seats = 0
  end

  def take_seat
    validate_seats!

    @free_seats -= 1
    @taken_seats += 1
  end

  private

  def validate_seats!
    raise 'You can\'t take a seat anymore, there is no free seats!' if free_seats.zero?
  end
end
