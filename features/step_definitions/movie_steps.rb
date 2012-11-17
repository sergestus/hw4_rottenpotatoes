Given /the following movies exist/ do |movies_table|
        movies_table.hashes.each do |movie|
                Movie.create!(movie)
        end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /the director of "(.*)" should be "(.*)"/ do |title, director|
  Movie.find_by_title(title) == director
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
#  ensure that that e1 occurs before e2.
#  page.content  is the entire content of the page as a string.
        assert false, "Unimplmemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

Given /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
        ratings = rating_list.split(", ")
        ratings.each do |rating|
                if uncheck then
                        uncheck("ratings_#{rating}")
                else
                        check("ratings_#{rating}")
                end
        end
end

#When /^I follow (.*)$/ do |pressed|
#        click_link(pressed)
#end

Then /I should see "'(.*)' has no director info"/ do |title|
  Movie.find_by_title(title).director.empty?
  end

Then /I should see all the movies/ do
        assert all("table#movies tbody tr").count == 10
        end

Then /I shouldn't see any movies/ do
        printf all("table#movies tbody tr").to_s
        printf all("table#movies tbody tr").count.to_s
        assert all("table#movies tbody tr").count == 0
end

Then /I should(n't)? see: (.*)/ do |not_present, title_list|
        titles = title_list.split(", ")
        titles.each do |title|
                #if page.respond_to? :should
                #        if not_present then
                #               page.should have_content(title) == false
                #        else
                #               page.should have_content(title)
                #        end
                #else
                        if not_present then
                                assert page.has_content?(title) == false
                        else
                                assert page.has_content?(title)
                        end
                
                #end
        end
end

module Enumerable
  def sorted?
    each_cons(2).all? { |a, b| (a <=> b) <= 0 }
  end
end


Then /^the movies should be sorted by (.+)$/ do |sort_field|
        col_index = case sort_field
        when "title" then 0
        when "release_date" then 2
        else raise ArgumentError
        end
        
        values = all("table#movies tbody tr").collect { 
                |row| 
                row.all("td")[col_index].text 
        }
        
        assert values.sorted?
end

