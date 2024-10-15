require_relative 'manufacturer'

# class Wagon declaration
class Wagon
  include Manufacturer

  attr_reader :type, :number, :total_capacity, :used_capacity

  VALID_TYPES = [:cargo, :passenger]

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

  def validate!
    raise ArgumentError.new('Type can\'t be nil') if type.nil?
    raise ArgumentError.new('Type should be cargo or passwnger only') unless VALID_TYPES.include?(type)
    raise ArgumentError.new('Capacity can\'t be empty') if total_capacity.nil? || total_capacity.zero? || total_capacity.negative?

    true
  end
end
