class Product < ApplicationRecord
  has_many :reviews, :dependent => :destroy

  validates_presence_of :title, :price

  private

  def self.handle_product(url)
    product_number = url.split('/')[-1]
    browser = Watir::Browser.new

    begin
      browser.goto("https://www.walmart.com/reviews/product/#{product_number}")
      product_title = browser.element(:css, '.prod-ProductTitle.no-margin.product-title.heading-a[itemprop="name"]').text
      product_price = browser.element(:css, '[itemprop="price"]').attribute_value('content')
      product = Product.first_or_create(title: product_title)
      product.price = product_price
      product.save

      btn_number = 2
      next_page = browser.button(:class => '', :text => btn_number.to_s)

      while next_page.exists? do
        browser.elements(:css, '.review').each do |review|
          rev_title = review.element(:css, '[itemprop="name"]').text
          rev_date = review.element(:css, '.review-submissionTime.text-right').text
          rev_author = review.element(:css, '[itemprop="author"]').text
          rev_comment = review.element(:css, '.review-description.margin-top div div div').text
          new_record = {title: rev_title, date: rev_date, author: rev_author, comment: rev_comment, product_id: product.id}

          Review.create(new_record) unless Review.where(new_record).exists?
        end

        next_page.click
        browser.button(:class => 'active', :text => btn_number.to_s).wait_until_present
        btn_number += 1
        next_page = browser.button(:class => '', :value => btn_number.to_s)
        browser.wait 1
      end

      browser.close if browser
    end
  rescue => e
    
  end
end
