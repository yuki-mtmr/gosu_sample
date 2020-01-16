class Weed
  attr_reader :x, :y

  def initialize(animation)
    @animation = animation
    @x = rand * 640
    @y = rand * 480
  end

  def draw  
    img = @animation[Gosu.milliseconds / 100 % @animation.size] #回転速度
    img.draw(@x - img.width / 2.0, @y - img.height / 2.0,
        ZOrder::WEEDS, 1, 1)
  end

end