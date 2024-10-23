# module Validation to validate attributes
module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  def self.inherited(subclass)
    subclass.extend ClassMethods
  end

  module ClassMethods
    def validate(attr_name, validation_type, *validation_arg)
      @attrs ||= []
      @attrs << { attr_name: attr_name, attr_type: validation_type, attr_args: validation_arg }
    end
  end

  module InstanceMethods
    def valid?
      validate!
    end

    private

    def validate!
      if self.class.superclass == Object
        source_class = self.class
      else
        source_class = self.class.superclass
      end

      source_class.instance_variable_get('@attrs').each do |attr|
        name = attr[:attr_name]
        value = instance_variable_get("@#{name}")
        arg = attr[:attr_args][0]
        type = attr[:attr_type]
        send "validate_#{type}", name, value, arg
      end
    end

    def validate_presence(attr_name, attr_value, _)
      raise ArgumentError.new("#{attr_name} should be presented.") unless attr_value
    end

    def validate_format(attr_name, attr_value, regex_arg)
      raise ArgumentError.new("Format of #{attr_name} should be #{regex_arg}") unless attr_value =~ regex_arg
    end

    def validate_type(attr_name, attr_value, type_arg)
      raise ArgumentError.new("#{attr_name}: #{attr_value} should be #{type_arg}.") unless attr_value.instance_of?(type_arg)
    end

    def validate_include(attr_name, attr_value, type_arg)
      raise ArgumentError.new("#{attr_name}: #{attr_value} should be in #{type_arg} values.") unless type_arg.include?(attr_value)
    end

    def validate_positive(attr_name, attr_value, _)
      raise ArgumentError.new("#{attr_name}: #{attr_value} should be positive.") unless attr_value.zero? || attr_value.positive?
    end

    def validate_length(attr_name, attr_value, length_arg)
      raise ArgumentError.new("#{attr_name} should be at least #{length_arg} symbols!") unless attr_value.length >= length_arg
    end
  end
end
