require "nayyar/version"
require "yaml"
require "nayyar/state"

module Nayyar
  @@states = nil
  @@pcode_index = []

  def self.states
  	self.load_states
  	@@states
  end

  def self.state_with_pcode!(pcode)
  	self.load_states
  	if state = self.state_with_pcode(pcode)
  		state
  	else
  		raise Nayyar::InvalidPcodeError;
  	end
  end

  def self.state_with_pcode(pcode)
  	self.load_states
  	(index = @@pcode_index.index(pcode)) && @@states[index]
  end

  def self.load_states
  	unless @@states
  		data = YAML.load_file(File.join(File.dirname(__FILE__), 'data', 'states.yml'))
  		@@states = data.map do |state|
  			state = Nayyar::State.new(state)
  			@@pcode_index << state.pcode
  			state
  		end
  	end
  end
end

class Nayyar::InvalidPcodeError < StandardError; end;