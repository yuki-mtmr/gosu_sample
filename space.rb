require 'gosu'
require_relative 'player'
require_relative 'star'
require_relative 'weed'

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


Tutorial.new.show