require 'gosu'
require_relative 'player'
require_relative 'star'
require_relative 'weed'

module ZOrder
  BACKGROUND, STARS, PLAYER, UI = *0..3
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
    @visible = 0
    @playing = true
    @font = Gosu::Font.new(20)
    @start_time = 0

  end

  def update
    if @playing
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
      @visible -= 1
      @visible = 50 if @visible < -10 && rand < 0.01
      @time_left = (60 - ((Gosu.milliseconds - @start_time) / 1000))
      @playing = false if @time_left < 1
    end
  end

  def draw
    @player.draw
    @background_image.draw(0, 0, ZOrder::BACKGROUND)
    @stars.each { |star| star.draw }
    if @visible > 0
      @weeds.each { |weed| weed.draw }
    end
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    @font.draw(@time_left.to_s, 600, 10, 2)

    unless @playing
      @font.draw("Game Over!!!", 260, 200, 3)
      @visible = 20
      @time_left = 0
      @font.draw("スペースキーでゲーム再開", 210, 250, 3)
    end
  end

  def button_down(id)
    if @playing
    else
      if (id == Gosu::KbEscape)
        close
      elsif (id == Gosu::KbSpace)
        @playing = true
        @visible = -10
        @start_time = Gosu.milliseconds
        @player.score = 0
      end
    end
  end
  
end


Tutorial.new.show