require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe '#update_quality' do

    it 'does not change the name of item' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality()
      validate_properties(items[0], 'foo', -1, 0)
    end

    it 'should degrade twice as fast after selling date' do
      items = [Item.new('foo', -1, 40)]
      GildedRose.new(items).update_quality()
      validate_properties(items[0], 'foo', -2, 38)
    end

    it 'should increase quality of Aged Brie and decrease sell_in value' do
      items = [Item.new('Aged Brie', 5, 6)]
      GildedRose.new(items).update_quality()
      validate_properties(items[0], 'Aged Brie', 4, 7)
    end

    it 'should not increase quality over 50' do
      items = [Item.new('Aged Brie', 5, 50)]
      GildedRose.new(items).update_quality()
      validate_properties(items[0], 'Aged Brie', 4, 50)
    end

    it 'should decrease quality of Elixir of the Mongoose' do
      items = [Item.new('Elixir of the Mongoose', 5, 7)]
      GildedRose.new(items).update_quality()
      validate_properties(items[0], 'Elixir of the Mongoose', 4, 6)
    end

    it 'should not set quality to negative' do
      items = [Item.new('Elixir of the Mongoose', 5, 0)]
      GildedRose.new(items).update_quality()
      validate_properties(items[0], 'Elixir of the Mongoose', 4, 0)
    end

    context 'Legendary items' do
      it 'should not change quality of Sulfuras' do
        items = [Item.new('Sulfuras, Hand of Ragnaros', 10, 80)]
        GildedRose.new(items).update_quality()
        validate_properties(items[0], 'Sulfuras, Hand of Ragnaros', 10, 80)
      end
    end

    context 'Backstage passes' do
      it 'should increase quality as nomal when days greater than 10' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 15, 20)]
        GildedRose.new(items).update_quality()
        validate_properties(items[0], 'Backstage passes to a TAFKAL80ETC concert', 14, 21)
      end

      it 'should increase quality by 2 when 10 days' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 20)]
        GildedRose.new(items).update_quality()
        validate_properties(items[0], 'Backstage passes to a TAFKAL80ETC concert', 9, 22)
      end

      it 'should increase quality by 2 when less than 10 days' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 9, 20)]
        GildedRose.new(items).update_quality()
        validate_properties(items[0], 'Backstage passes to a TAFKAL80ETC concert', 8, 22)
      end

      it 'should increase quality by 3 when 5 days or less' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 20)]
        GildedRose.new(items).update_quality()
        validate_properties(items[0], 'Backstage passes to a TAFKAL80ETC concert', 4, 23)
      end

      it 'should increase quality by 3 when less than 5 days' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 4, 20)]
        GildedRose.new(items).update_quality()
        validate_properties(items[0], 'Backstage passes to a TAFKAL80ETC concert', 3, 23)
      end

      it 'should drop quality to Zero after concert' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 20)]
        GildedRose.new(items).update_quality()
        validate_properties(items[0], 'Backstage passes to a TAFKAL80ETC concert', -1, 0)
      end
    end

    context 'Conjured items' do
      it 'should degrade twice fast' do
        items = [Item.new('Conjured Mana Cake', 3, 6)]
        GildedRose.new(items).update_quality()
        validate_properties(items[0], 'Conjured Mana Cake', 2, 4)
      end

      it 'should degrade not get quality lower than zero' do
        items = [Item.new('Conjured Mana Cake', 3, 0)]
        GildedRose.new(items).update_quality()
        validate_properties(items[0], 'Conjured Mana Cake', 2, 0)
      end
    end
  end
end

def validate_properties item, expected_name, expected_sell_in, expected_quality
  expect(item.name).to eq expected_name
  expect(item.sell_in).to eq expected_sell_in
  expect(item.quality).to eq expected_quality
end
