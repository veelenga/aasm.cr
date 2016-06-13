# aasm.cr [![Build Status](https://travis-ci.org/veelenga/aasm.cr.svg?branch=master)](https://travis-ci.org/veelenga/aasm.cr)

Aasm stands for **"Acts As State Machine"** which means that some abstract object can act as a [finite state machine](https://en.wikipedia.org/wiki/Finite-state_machine) and can be in one of a finite number of states at a time; can change one state to another when initiated by a triggering event.

## Getting Started

Adding a state machine to a Crystal class is as simple as including `AASM` module and writing `act_as_state_machine` method where you can define **states** and **events** with their **transitions**:

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

### States

State can be defined using `aasm.state` method passing the name and options:

```crystal
aasm.state :passive, initial: true
```

#### State options

Currently state supports the following options:

  - `initial` : `Bool` **optional** - indicates whether this state is initial or not. If initial state not specified, first one will be considered as initial
  - `guard` : `(-> Bool)` **optional** - a callback, that gets evaluated once state is getting entered. State will not enter if guard returns false
  - `enter` : `(-> Nil)` **optional** - a hook, that gets evaluated once state entered.

### Events

Event can be defined using `aasm.state` method passing the name and a block with transitions:

```crystal
aasm.event :delete do |e|
  e.transitions from: :active, to: :deleted
end
``` 

Event has to be defined after state definition. In other case `NoSuchStateException` will be raise.

#### Event options

Currently event supports the following options:

  - `before` : `(->)` **optional** - a callback, that gets evaluated once before changing a state
  - `after` : `(->)` **optional** - a callback, that gets evaluated once after changing a state.

### Transitions

Transition can be defined on event with `transitions` method passing options:

```crystal
aasm.event :complete do |e|
  e.transitions from: [:pending, :active], to: :deleted
end
```

#### Transition options

Currently transition supports the following options:

  - `from` : `(Symbol | Array(Symbol))` **required** - state (or states) from which state of state machine can be changed when event fired
  - `to` : `Symbol` **required** - state to which state of state machine will change when event fired.

## More examples

### One state machine (circular)

```crystal
class CircularStateMachine
  include AASM

  def act_as_state_machine
    aasm.state :started

    aasm.event :restart do |e|
      e.transitions from: :started, to: :started
    end
  end
end
```

### Two states machine

```crystal
class TwoStateMachine
  include AASM

  def act_as_state_machine
    assm.state :active
    aasm.state :deleted

    aasm.event :delete do |e|
      e.transitions from: :active, to: :deleted
    end
  end
end
```

### Three states machine

```crystal
class ThreeStatesMachine
  include AASM

  def act_as_state_machine
    aasm.state :pending, initial: true
    aasm.state :active
    aasm.state :completed

    aasm.event :activate do |e|
      e.transitions from: :pending, to: :active
    end
    aasm.event :complete do |e|
      e.before { puts "completing..." }
      e.after  { puts "completed" }
      e.transitions from: [:active, :pending], to: :completed
    end
  end
end
```
