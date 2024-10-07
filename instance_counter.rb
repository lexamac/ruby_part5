# module for instance counting
module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  # module with class methods
  module ClassMethods
    def instances
      @instances ||= 0
    end

    def register_instance
      @instances ||= 0
      @instances += 1
    end
  end

  # module with instance methods
  module InstanceMethods
    private

    def register_instance
      self.class.register_instance
    end
  end
end
