#!/usr/bin/ruby
# author: Bjoern Jeschke
require 'json'
class NumberOfFleetEngineers
  
  def initialize(input)
    @input_array = input
  end
  
  def start()
    puts "Hello!"
#     puts @input_array
     
    scooters = @input_array[0]
    c = @input_array[1]
    p = @input_array[2]
#     puts "scooters:#{scooters} C:#{c} P:#{p}"
    if scooters.nil?
      help
    else
#     puts scooters[0]
    # Reformating input
      if scooters.include? "scooters"
        scooters_list = scooters.split(":")[1][1..-2].split(",").map(&:to_i)
  #       puts scooters_list
      else
        scooters_list = scooters[1..-2].split(",").map(&:to_i)
      end
      if c[0] == "C"
        c = c.split(":")[1].to_i
      else
        c = c.to_i
      end
      if p[0] == "P"
        p = p.split(":")[1].to_i
      else
        p = p.to_i
      end

      if @input_array.size != 3
        puts "Wrong number of arguments, there must be 3"
        help
      elsif scooters_list.empty? or scooters_list.size() > 100
        puts "the scooter list should have between 1 and 100 entrys"
      elsif scooters_list.any? {|x|  x > 1000 or x < 0 }
        puts "the elements in the scooter list should be between 0 and 1000"
      elsif 1 > c or c > 999
        puts "C is not between 1 and 999"
      elsif 1 > p or p > 1000  
        puts "P is not between 1 and 1000"
      else
  #       Run main programm but catch errors
        begin
          calculate_engineers(scooters_list,c,p)
        rescue Exception => msg
          puts "Error: #{msg}"
          help()
        end
      end
    end
  end
  
  # Main calculation
  def calculate_engineers(scooters_list,c,p)
    puts "scooters:#{scooters_list} C:#{c} P:#{p}"
    answer_list = []
    # calculation by brute force 
    # for each district assume that the FM works there and calculate the number of FE needed with that assumption
    # save this in a list 
    # return the min of that list
    for i in 0 ... scooters_list.size()
      answer_list[i] = 0
      # district scooters minus workload of manager
      # the current district where the manager works cannot have a negative value
      current_district = [scooters_list[i].to_i - c, 0].max
      for j in 0 ... scooters_list.size()
        if i == j
          answer_list[i] += (current_district/p.to_f).ceil
        else
          answer_list[i] += (scooters_list[j].to_i/p.to_f).ceil
        end
      end
    end
    puts "fleet_engineers: #{answer_list.min}"
  end
  
  # help method
  def help()
    puts "The syntax is:\n ruby number_of_fleet_engineers.rb []scooters C P"
    puts "Please call for example:\n ruby number_of_fleet_engineers.rb [15,10] 12 5"
    puts "or: \n ruby number_of_fleet_engineers.rb scooters:[15,10] C:12 P:5"
    puts "note that the order of the args must always be scooters C P"
  end
  
end

object = NumberOfFleetEngineers.new(ARGV)
object.start()
