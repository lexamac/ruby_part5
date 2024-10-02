# class PassengerTrain declaration
class PassengerTrain < Train
  def initialize(init_number)
    super(init_number, :passenger)
  end
end
