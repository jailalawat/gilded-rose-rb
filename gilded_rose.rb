require 'byebug'

class GildedRose
  def initialize(items)
    @items = items
  end

  LEGENDARY_ITEMS = ['Sulfuras, Hand of Ragnaros'];

  CONJURED_ITEMS = ['Conjured Mana Cake'];

  
  BACKSTAGE_AND_AGED_BRIE = ['Aged Brie', 'Backstage passes to a TAFKAL80ETC concert'];

  def update_quality()
    @items.each do |item|
      if BACKSTAGE_AND_AGED_BRIE.include?(item.name)
        normal_quality_increase(item)
        backstage_item_quality_increase(item)
      elsif CONJURED_ITEMS.include?(item.name)
        item.quality -= 2 if item.quality > 0
      else
        normal_quality_decrease(item)
      end

      item.sell_in -= 1 unless LEGENDARY_ITEMS.include?(item.name)

      selling_date_passed_checks(item)
    end
  end

  def selling_date_passed_checks item
    return if item.sell_in > 0
    if item.name == 'Aged Brie'
      normal_quality_increase(item)
    elsif item.name == 'Backstage passes to a TAFKAL80ETC concert'
      item.quality -= item.quality
    else
      normal_quality_decrease(item)
    end
  end

  def normal_quality_decrease item
    item.quality -= 1 if !LEGENDARY_ITEMS.include?(item.name) && item.quality > 0
  end

  def normal_quality_increase item
    item.quality += 1 if item.quality < 50
  end

  def backstage_item_quality_increase item
    if item.name == 'Backstage passes to a TAFKAL80ETC concert'
      item.quality += 1 if item.sell_in < 11
      item.quality += 1 if item.sell_in < 6
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
