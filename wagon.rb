require_relative 'manufacturer'

# class Wagon declaration
class Wagon
  include Manufacturer

  attr_reader :type, :number

  VALID_TYPES = [:cargo, :passenger]

  def initialize(type)
    @type = type
    @number = rand(100..999)

    validate!
  end

  # public method to validate wagons data
  def valid?
    validate!
  rescue
    false
  end

  protected

  def validate!
    raise ArgumentError.new('Type can\'t be nil') if @type.nil?
    raise ArgumentError.new('Type should be cargo or passwnger only') unless VALID_TYPES.include?(@type)

    true
  end
end
