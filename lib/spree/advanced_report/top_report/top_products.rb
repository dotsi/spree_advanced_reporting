# encoding: utf-8
class Spree::AdvancedReport::TopReport::TopProducts < Spree::AdvancedReport::TopReport
  def name
    "Najbolje prodajani izdelki"
  end

  def description
    "Najbolje prodajani izdelki po prometu"
  end

  def initialize(params, limit)
    super(params)

    orders.each do |order|
      order.line_items.each do |li|
        if !li.product.nil?
          data[li.product.id] ||= {
            :name => li.product.name.to_s,
            :revenue => 0,
            :units => 0
          }
          data[li.product.id][:revenue] += li.quantity*li.price 
          data[li.product.id][:units] += li.quantity
        end
      end
    end

    self.ruportdata = Table(%w[name Kosi Promet])
    data.inject({}) { |h, (k, v) | h[k] = v[:revenue]; h }.sort { |a, b| a[1] <=> b [1] }.reverse[0..limit].each do |k, v|
      ruportdata << { "name" => data[k][:name], "Kosi" => data[k][:units], "Promet" => data[k][:revenue] } 
    end
    ruportdata.replace_column("Promet") { |r| "$%0.2f" % r.Promet }
    ruportdata.rename_column("name", "Izdelek")
  end
end
