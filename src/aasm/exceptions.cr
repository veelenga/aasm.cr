module AASM
  class NoSuchEventException < Exception
    def initialize(event_name)
      super "Event '#{event_name}' does not exist."
    end
  end

  class EventAlreadyDefinedException < Exception
    def initialize(event_name)
      super "Event '#{event_name}' already defined."
    end
  end

  class NoSuchStateException < Exception
    def initialize(state_name)
      super "State '#{state_name}' does not exist."
    end
  end

  class StateAlreadyDefinedException < Exception
    def initialize(state_name)
      super "State '#{state_name}' already defined."
    end
  end
end
