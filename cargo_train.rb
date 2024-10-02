# class CargoTrain declaration
class CargoTrain < Train
  def initialize(init_number)
    super(init_number, :cargo)
  end
end
