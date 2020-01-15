require 'gosu'

module ZOrder
  BACKGROUND, STARS, PLAYER, UI = *0..3
  BACKGROUND, WEEDS, PLAYER, UI = *0..3
end

class Tutorial < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "My Awesome Space Game"

    @background_image = Gosu::Image.new("images/space.png", :tileable => true)

    @player = Player.new
    @player.warp(320, 240)

    @star_anim = Gosu::Image.load_tiles("images/star.png", 25, 25) #スターイメージ
    @weed = Gosu::Image.load_tiles("images/weed.png", 25, 25)
    @stars = Array.new
    @weeds = Array.new

    @font = Gosu::Font.new(20)

  end

  def update
    if Gosu.button_down? Gosu::KbLeft or Gosu::button_down? Gosu::GpLeft
      @player.turn_left
    end

    if Gosu.button_down? Gosu::KbRight or Gosu::button_down? Gosu::GpRight
      @player.turn_right
    end

    if Gosu.button_down? Gosu::KbUp or Gosu::button_down? Gosu::GpButton0
      @player.accelerate
    end
    @player.move
    @player.collect_stars(@stars)
    @player.collect_weeds(@weeds)

    if rand(100) < 4 and @stars.size < 25
      @stars.push(Star.new(@star_anim))
    end

    if rand(1000) < 1 and @weeds.size < 25
      @weeds.push(Weed.new(@weed))
    end
  end

  def draw
    @player.draw
    @background_image.draw(0, 0, ZOrder::BACKGROUND)
    @stars.each { |star| star.draw }
    @weeds.each { |weed| weed.draw }
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    else
      super
    end
  end
  
end


# メインプレイヤー Class
class Player
  attr_reader :score

  def initialize
    @image = Gosu::Image.new("images/starfighter.bmp")
    @beep = Gosu::Sample.new("images/beep.wav")
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
  end

  def warp(x,y)
    @x, @y = x, y
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def accelerate #加速
    @vel_x += Gosu.offset_x(@angle, 0.5)
    @vel_y += Gosu.offset_y(@angle, 0.5)
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 640
    @y %= 480
    
    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def draw
     @image.draw_rot(@x, @y, 1, @angle)
  end

  def score
    @score
  end

  def collect_stars(stars)
    stars.reject! do |star|
      if Gosu.distance(@x, @y, star.x, star.y) < 35
        @score += 10
        @beep.play
        true
      else
        false
      end
    end
  end

  def collect_weeds(weeds)
    weeds.reject! do |weed|
      if Gosu.distance(@x, @y, weed.x, weed.y) < 35
        @score += 80000
        @beep.play
        true
      else
        false
      end
    end
  end
end

# スターアニメーション

class Star
  attr_reader :x, :y

  def initialize(animation)
    @animation = animation
    @color = Gosu::Color::BLACK.dup
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
    @x = rand * 640
    @y = rand * 480
  end

  def draw  
    img = @animation[Gosu.milliseconds / 100 % @animation.size] #回転速度
    img.draw(@x - img.width / 2.0, @y - img.height / 2.0,
        ZOrder::STARS, 1, 1, @color, :add)
  end

end

# weed

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

Tutorial.new.show