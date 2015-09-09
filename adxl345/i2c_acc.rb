
require "./I2C.rb"


scale_multiplier    = 0.004

bus_address         = 0x53
data_format         = 0x31
power_ctl           = 0x2D
range_16g           = 0x03
measure             = 0x08

class ADXL345 < I2C

  def avetimes time , ave
    bus_address = 0x53
    scale_multiplier = 0.004
    data1 = 0
    data2 = 0
    data3 = 0
    ave.times do
      data1 = data1 + i2c_get_ADXL345(bus_address, 0x32)
      data2 = data2 + i2c_get_ADXL345(bus_address, 0x34)
      data3 = data3 + i2c_get_ADXL345(bus_address, 0x37)
    end
    print (Time.new - time)
    print ", "
    print ((data1/ave) * scale_multiplier)
    print ", "
    print ((data2/ave) * scale_multiplier)
    print ", "
    puts ((data3/ave) * scale_multiplier)
  end

  def i2c_get_ADXL345(sle_adr , mem_adr)
    h =  `sudo i2cget -y #{@bus_adr} #{ sle_adr} #{mem_adr}`
    l =  `sudo i2cget -y #{@bus_adr} #{ sle_adr} #{mem_adr - 1}`
    return signed_word2d(str_word2d h ,l).to_i
  end
end

  cs = ADXL345.new(1)

  cs.i2c_init(bus_address, power_ctl, measure)

  time = Time.now
  30.times do
    cs.avetimes(time,2)
  end
