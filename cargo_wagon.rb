# class CargoWagon declaration
class CargoWagon < Wagon
  attr_reader :free_volume, :taken_volume, :total_volume

  def initialize(total_volume)
    super(:cargo)

    @total_volume = total_volume
    @free_volume = total_volume
    @taken_volume = 0
  end

  def take_volume(volume)
    validate_volume!(volume)

    @free_volume -= volume
    @taken_volume += volume
  end

  private

  def validate_volume!(volume)
    raise 'There is no free volume!' if free_volume.zero?
    raise "Free volume is not enough to be taken with #{volume} space!" if volume > free_volume
  end
end
