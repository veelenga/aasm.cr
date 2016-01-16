# aasm.cr

Easy to use state machine for Crystal.

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  aasm:
    github: veelenga/aasm.cr
```

## Usage

```crystal
require "aasm"

class Transaction
  include AASM

  def act_as_state_machine
    aasm.state :pending, initial: true
    aasm.state :active,  enter: -> { puts "Just got activated" }
    aasm.state :completed

    aasm.event :activate do |t|
      t.transitions from: :pending, to: :active
    end

    aasm.event :complete do |t|
      t.transitions from: :pending, to: :active
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
