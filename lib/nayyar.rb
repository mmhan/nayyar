require "nayyar/version"
require "yaml"
require "nayyar/state"

module Nayyar
  @@states = nil
  @@pcode_index = []
  @@iso_index = []
  @@alpha3_index = []

  def self.states
  	self.load_states
  	@@states
  end

  def self.state_with(query)
    self.load_states
    key = self.get_key(query)
    (index = class_variable_get("@@#{key}_index").index(query[key])) && @@states[index]
  end

  def self.state_with!(query)
    if state = self.state_with(query)
      state
    else
      key = self.get_key(query)
      raise Nayyar::StateNotFound.new("Cannot find State with given #{key}: #{query[key]}")
    end
  end

  def self.state_with_pcode(pcode)
    self.state_with(pcode: pcode)
  end

  def self.state_with_pcode!(pcode)
    self.state_with!(pcode: pcode)
  end

  def self.state_with_iso(iso)
    self.state_with(iso: iso)
  end
  def self.state_with_iso!(iso)
    self.state_with!(iso: iso)
  end

  def self.state_with_alpha3(alpha3)
    self.state_with(alpha3: alpha3)
  end
  def self.state_with_alpha3!(alpha3)
    self.state_with!(alpha3: alpha3)
  end


  def self.get_key(data)
    keys = data.keys
    if keys.length != 1 || %w(pcode iso alpha3).none? { |key| key.to_sym == keys.first }
      raise ArgumentError.new("`state_with` accepts only one of pcode, iso or alpha3 as argument. None provided")
    end
    keys.first
  end

  protected
    def self.load_states
    	unless @@states
    		data = YAML.load_file(File.join(File.dirname(__FILE__), 'data', 'states.yml'))
    		@@states = data.map do |state|
    			state = Nayyar::State.new(state)
    			@@pcode_index << state.pcode
          @@iso_index << state.iso
          @@alpha3_index << state.alpha3
    			state
    		end
    	end
    end
end


class Nayyar::StateNotFound < StandardError; end;