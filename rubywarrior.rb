class Player
  attr_accessor :warrior
  
  def initialize()
    @max_hp=nil
    @current_hp=nil
    @prev_hp=nil
    @hp_history=[]
    @vision=[]
    @direction=:forward
    @directions=[:forward, :backward]
    @reverse_dir=[:backward, :forward]
  end
  
  def play_turn(warrior)
    @max_hp=warrior.health
    self.warrior=warrior
    update
    return warrior.rescue! @direction if warrior.feel(@direction).captive?
    return warrior.attack! @direction if enemy?
    return warrior.rest! if hurt? && !range_shot? && !warrior.look(@direction).any?{|elem| elem.enemy?}
    action = if (critical? && range_shot?)
      look_reverse
    elsif !warrior.look(:forward).any?{|elem| elem.captive?} && warrior.look(:forward).any?{|elem| elem.enemy?} && !warrior.look(:backward).any?{|elem| elem.enemy?} && !warrior.feel.enemy?
      warrior.shoot!
    elsif reverse==true
      warrior.pivot!
    else
      look
    end
  end
  
  def hurt?
    warrior.health<20
  end
  
  def critical?
    warrior.health<10
  end
  
  def enemy?
    warrior.feel(@direction).enemy?
  end
  
  def empty?
    warrior.feel(@direction).empty?
  end
  
  def reverse
    @directions.each do |dir|
      if warrior.feel(dir).wall?
        return true
      else
        return false
      end      
    end
    false
  end
  
  def need_rest?
    warrior.health<@max_hp
  end
  
  def range_shot?
    warrior.health<@prev_hp
  end
  
  def update
    @prev_hp=@current_hp
    @current_hp=warrior.health
    @hp_history<<@current_hp
  end
  
  def look
    @directions.each do |dir|
      if (warrior.feel(dir).stairs?) || (warrior.feel(dir).empty?)
        warrior.walk!(dir)
        return true
      end      
    end
    false
  end
  
  def look_reverse
    @reverse_dir.each do |dir|
      if (warrior.feel(dir).stairs?) || (warrior.feel(dir).empty?)
        warrior.walk!(dir)
        return true
      end      
    end
    false
  end
  
  def turn
    @direction = (@direction == :forward) ? :backward : :forward
  end
  
end
  



