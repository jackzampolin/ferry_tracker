class Hex
  class << self
    def to_hex(array)
      array.map do |num|
        num.to_s(16)
      end
    end

    def steps(num_steps)
      step_size = (255/num_steps).round
      range = 255 + step_size
      step_size = (range/num_steps).round
      output = Array.new(num_steps)
      output = output.each_index.map do |index|
        (index*step_size).abs
      end
      output[-1] = 255
      to_hex(output)
    end


    def check_value(value)
      if value == '0'
        '00'
      else
        value
      end
    end

    def create_colors(ar1,ar3)
      ar1.each_index.map do |index|
        red = check_value(ar1[index])
        blue = check_value(ar3[index])
        "#" + "#{red}#{'00'}#{blue}"
      end
    end

    def to_upcase(array)
      array.map do |string|
        string.chars.map(&:upcase).join('')
      end
    end

    def colors(num_steps)
      red = steps(num_steps)
      blue = steps(num_steps).reverse
      to_upcase(create_colors(red,blue))
    end
  end
end