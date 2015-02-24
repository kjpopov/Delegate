#!/usr/bin/env ruby

class Module

  def delegate(*methods)
    # Pop options hash from arg array
    options = methods.pop
    # If options hash is not available and also the :to option
    # is not available than raise an error
    unless options.is_a?(Hash) && to = options[:to]
      raise ArgumentError, "Target needed. Please give an options hash and a :to key in the end. Example: delegate :first_name, :last_name, to: :'@user'."
    end
 
    # Check if :to option is followed by syntax rules for method names 
    if options[:prefix] == true && options[:to].to_s =~ /^[^a-z_]/
      raise ArgumentError, "Can only automatically set the delegation prefix when delegating to a method."
    end
 
    # Giving real prefix value in the line below
    prefix = options[:prefix] && "#{options[:prefix] == true ? to : options[:prefix]}_"
 
   # And finaly some magic is used here :) 
    methods.each do |method|
      module_eval("def #{prefix}#{method}(*args, &block)\n#{to}.__send__(#{method.inspect}, *args, &block)\nend\n", "(__DELEGATION__)", 1)
    end
  end

end

# Applying the examples from the task but with fixed missing 'r' in the 'fist_name' ;-)

User = Struct.new(:first_name, :last_name)

class Invoce

  delegate :first_name, :last_name, to: :'@user'

  def initialize(user)
    @user = user
  end
end

user = User.new 'Genadi', 'Samokovarov'

invoice = Invoce.new(user)

# Adding p to actualy print the results

p invoice.first_name #=> "Genadi"
p invoice.last_name #=> "Samokovarov"

