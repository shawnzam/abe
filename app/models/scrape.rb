class Scrape < ActiveRecord::Base
  attr_accessible :title
  attr_accessible  :result_f, :links_f
  # attr_accessor :results_f_file_name
  has_attached_file :links_f
  has_attached_file :result_f



def scrape

  @divider = "----------------------------------------\n"
  @results = []
  if links_f
    CSV.foreach(links_f.path) do |row|
      makeResult("http://#{row[2]}")
    end
  end

  filename = "file-#{self.id}-out.csv"
  column_names = @results.first.keys
  csvString =CSV.generate do |csv|
    csv << column_names
    @results.each do |x|
        csv << x.values
      end
    end
    File.write(filename, csvString)
    # foo = File.open(File.expand_path(filename))
    # puts csvString
    
    self.result_f = File.open(File.expand_path(filename))
    self.save
    DoneMailer.done(self).deliver

    # puts "#{@divider}Done!\nA result file has been written to #{File.expand_path(filename)}"
end

  def makeResult(url)
    puts "#{@divider}Parsing #{url}"
    page = Nokogiri::HTML(open(url))
    #check if data is present
    if page.at_css(".result-data").nil?
      puts "#{url} has no results"
      return false
    end
    result_count = page.css('.pagerange').text.scan(/(\d*) Results/)[0] rescue nil
    puts "Found #{result_count[0]} results"
    terms = page.css("#pageTitleHeader").text
    result_details = page.css(".result")
    puts "Scraping #{result_details.size} results from front page"
    result_details.each do |r|
      result = {}
      result[:search_url] = url
      result[:total_results] = result_count[0]
      r.at_css('.title').nil? ? result[:title] = nil : result[:title] = r.css(".title")[0].css('a')[0]['title'] 
      r.at_css('.bookseller').nil? ? result[:bookseller]  =nil : result[:bookseller] = r.css(".bookseller")[0].css('a')[0]['title']
      r.at_css('.isbn').nil? ? isbn1 = nil : isbn1 = r.css(".isbn")[0].css('a')[0]['title'] rescue nil 
      r.at_css('.isbn').nil? ? isbn2 = nil : isbn2 = r.css(".isbn")[0].css('a')[1]['title'] rescue nil 
      r.at_css('.quantity').nil? ? result[:quantity_available] = nil : result[:quantity_available] = r.css(".quantity")[0].text.scan(/Quantity Available: (\d)*/)[0][0]
      r.css(".item-price").each do |p|
        r.at_css(".price").nil? ?result[:price] = nil : result[:price] = p.css(".price").text
      end
      r.css(".shipping").each do |p|
        r.at_css(".price").nil? ? result[:shipping_price] = nil : result[:shipping_price] = p.css(".price").text
      end
       r.at_css("p").nil? ? result[:description] = nil : result[:description] = r.css("p").text
      # page.css(".result-description p").each do |d|
      #   result[:description] = d.text
      # end
      @results << result
    end
  end

  handle_asynchronously :scrape
end
