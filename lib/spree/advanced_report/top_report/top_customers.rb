# encoding: utf-8
class Spree::AdvancedReport::TopReport::TopCustomers < Spree::AdvancedReport::TopReport
  def name
    "Top stranke"
  end

  def description
    "Najboljše stranke po skupnem prometu"
  end

  def initialize(params, limit)
    super(params)

    orders.each do |order|
      if order.user
        data[order.user.id] ||= {
          :email => order.user.email,
          :revenue => 0,
          :units => 0
        }
        data[order.user.id][:revenue] += revenue(order)
        data[order.user.id][:units] += units(order)
      end
    end

    self.ruportdata = Table(%w[email Enote Promet])
    data.inject({}) { |h, (k, v) | h[k] = v[:revenue]; h }.sort { |a, b| a[1] <=> b [1] }.reverse[0..limit].each do |k, v|
      ruportdata << { "email" => data[k][:email], "Enote" => data[k][:units], "Promet" => data[k][:revenue] } 
    end
    ruportdata.replace_column("Promet") { |r| "$%0.2f" % r.Promet }
    ruportdata.rename_column("email", "Email stranke")
  end
end
