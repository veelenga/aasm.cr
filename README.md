# aasm.cr [![Build Status](https://travis-ci.org/veelenga/aasm.cr.svg?branch=master)](https://travis-ci.org/veelenga/aasm.cr)

Easy to use finite state machine for Crystal classes.

## Usage

Adding a state machine is as simple as including `AASM` module and overwriting `act_as_state_machine` method
where you can start defining **states** and **events** with their **transitions**:

```crystal
class Transaction
  include AASM

  def act_as_state_machine
    aasm.state :pending, initial: true
    aasm.state :active,  enter: -> { puts "Just got activated" }
    aasm.state :completed

    aasm.event :activate do |e|
      e.transitions from: :pending, to: :active
    end

    aasm.event :complete do |e|
      e.transitions from: :active, to: :completed
    end
  end
end

t = Transaction.new.tap &.act_as_state_machine
t.state          #=> :pending
t.next_state     #=> :active
t.fire :activate # Just got activated
t.state          #=> :active
t.next_state     #=> :completed
```

## Contributing

1. Fork it ( https://github.com/veelenga/aasm/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
