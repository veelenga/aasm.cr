module AASM

  class AASMException < Exception
  end

  class NoSuchEventException < AASMException
    def initialize(event_name)
      super "Event '#{event_name}' does not exist."
    end
  end

  class EventAlreadyDefinedException < AASMException
    def initialize(event_name)
      super "Event '#{event_name}' already defined."
    end
  end

  class NoSuchStateException < AASMException
    def initialize(state_name)
      super "State '#{state_name}' does not exist."
    end
  end

  class StateAlreadyDefinedException < AASMException
    def initialize(state_name)
      super "State '#{state_name}' already defined."
    end
  end

  class UnableToChangeState < AASMException
    def initialize(from, to)
      super "Unable to change state from '#{from}' to '#{to}'"
    end
  end
end
