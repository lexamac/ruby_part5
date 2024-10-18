# module Accessors do define accessors methods
module Accessors
  def attr_accessor_with_history(*attrs)
    attrs.each do |attr|
      raise ArgumentError.new('Only Symbols could be provided as attributes') unless attr.is_a?(Symbol)

      define_method(attr) { instance_variable_get("@#{attr}") }
      define_method("#{attr}_history") { instance_variable_get("@#{attr}_history") }
      define_method("#{attr}=") do |value|
        instance_variable_set("@#{attr}", value)
        instance_variable_set("@#{attr}_history", []) unless instance_variable_get("@#{attr}_history")
        instance_variable_get("@#{attr}_history") << value
      end
    end
  end

  def strong_attr_accessor(attr, attr_class)
    raise ArgumentError.new('Only Symbols could be provided as attributes') unless attr.is_a?(Symbol)

    define_method(attr) { instance_variable_get("@#{attr}") }
    define_method("#{attr}=") do |value|
      raise ArgumentError.new("Value type must be of #{attr_class} type.") unless value.is_a?(attr_class)

      instance_variable_set("@#{attr}", value)
    end
  end
end
