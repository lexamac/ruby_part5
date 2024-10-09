require_relative 'manufacturer'

# class Wagon declaration
class Wagon
  include Manufacturer

  attr_accessor :type

  def initialize(type)
    @type = type

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
    raise 'Type can\'t be nil' if @type.nil?
    raise 'Type should be cargo or passwnger only' unless VALID_TYPES.include?(@type)

    true
  end
end
