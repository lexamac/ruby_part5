# module Validation to validate attributes
module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(attr_name, validation_type, *validation_arg)
      @attrs ||= []
      @attrs << { name: attr_name, type: validation_type, arg: validation_arg }
    end
  end

  module InstanceMethods
    def valid?
      validate!
    end

    private

    def validate!
      self.class.instance_variable_get('@attrs').each do |attr|
        name = attr[:name]
        value = instance_variable_get("@#{attr}")
        arg = attr[:arg][0]
        type = attr[:type]
        send "validate_#{type}", name, value, arg
      end
    end

    def validate_presence(attr_name, attr_value, _)
      raise "#{attr_name} should be presented." unless attr_value
    end

    def validate_format(attr_name, attr_value, regex_arg)
      raise "Format of #{attr_name} should be #{regex_arg}" unless attr_value =~ regex
    end

    def validate_type(attr_name, attr_value, type_arg)
      raise "#{attr_name}: #{attr_value} should be #{type_arg}." unless attr_value.instance_of?(type_arg)
    end

    def validate_include(attr_name, attr_value, type_arg)
      raise "#{attr_name}: #{attr_value} should be in #{type_arg} values." unless type_arg.include?(attr_value)
    end

    def validate_positive(attr_name, attr_value, _)
      raise "#{attr_name}: #{attr_value} should be positive." unless attr_value.positive?
    end

    def validate_length(attr_name, attr_value, length_arg)
      raise "#{attr_name} should be at least #{length_arg} symbols!" unless attr_value.length >= length_arg
    end
  end
end
