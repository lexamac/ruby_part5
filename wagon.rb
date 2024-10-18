require_relative 'manufacturer'
require_relative 'validation'

# class Wagon declaration
class Wagon
  include Manufacturer
  include Validation

  attr_reader :type, :number, :total_capacity, :used_capacity

  VALID_TYPES = [:cargo, :passenger]

  validate :number,         :presence
  validate :include,        :type,    VALID_TYPES
  validate :total_capacity, :positive

  def initialize(type, capacity)
    @type = type
    @number = rand(100..999)
    @total_capacity = capacity
    @used_capacity = 0

    validate!
  end

  def free_capacity
    total_capacity - used_capacity
  end

  # public method to validate wagons data
  def valid?
    validate!
  rescue
    false
  end

  protected

  def take_capactiy(capacity)
    validate_capacity!(capacity)

    @used_capacity += capacity
  end

  def validate_capacity!(capacity)
    raise 'There is no enough capacity' if used_capacity == total_capacity
    raise "Free capacity is not enough to be taken with #{capacity} space!" if capacity > free_capacity
  end
end
