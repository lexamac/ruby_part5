# class CargoWagon declaration
class CargoWagon < Wagon
  def initialize(total_volume)
    super(:cargo, total_volume)
  end

  def take_volume(volume)
    take_capactiy(volume)
  end
end
