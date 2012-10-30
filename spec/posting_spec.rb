require 'fakeweb'
require 'nokogiri'
require 'open-uri'
require "sqlite3"
require "rspec"
require "./lib/posting.rb"




describe Posting do
  let(:posting) { Posting.new("http://sfbay.craigslist.org/pen/apa/3372916109.html") }
  before :each do
    apartment_result = File.read("spec/fixtures/craigslist_sample_listing.html")
    FakeWeb.register_uri(:get, "http://sfbay.craigslist.org/pen/apa/3372916109.html", :body => apartment_result)
    #@doc = Nokogiri::HTML(open('http://sfbay.craigslist.org/pen/apa/3372916109.html'))
  end

  context ".initialize" do
    # before :each do
    #       @posting = Posting.new("http://sfbay.craigslist.org/pen/apa/3372916109.html")
    #     end
    it "initializes with title of posting" do
      posting.title.should include("THANKSGIVING IN TAHOE -- Wonderful house/location, hot tub, sleeps 10+")
    end

    it "initializes the location" do
      posting.location.should eq("SF bay area")
    end

    it "initializes the date posted" do
      posting.date.should eq("2012-10-29, 11:19AM PDT")
    end

    it "initializes the price" do
     posting.price.should eq("300")
    end

    #it "has a category"

  end

   context "#save" do
     before :each do
       @database = SQLite3::Database.new("test.db")
       @database.execute("DROP TABLE IF EXISTS postings;")
       create_table = <<-eos
       CREATE TABLE postings (id INTEGER PRIMARY KEY AUTOINCREMENT,
            title VARCHAR NOT NULL,
            url VARCHAR NOT NULL,
            price INTEGER,
            location TEXT NOT NULL);
            eos
       @database.execute(create_table)
     end

     it "saves the posting and its attributes to the database" do

       posting.add_db(@database)
       posting.save

       puts @database.execute("SELECT * FROM postings").inspect
       @database.execute("SELECT * FROM postings").length.should eq(1)

     end
   end
  #
  #  context "#load" do
  #    it "loads the posting from the database"
  #  end

end

