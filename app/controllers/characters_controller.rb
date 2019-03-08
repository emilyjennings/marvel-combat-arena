class CharactersController < ApplicationController
  def play
    #shows the player a form to enter character names and a seed number
  end

  #Spent time here wondering if I should use the marvel_api gem with Faraday, but decided it had last been updated 3-5 years ago and I may run into issues, taking precious time away from making this app which was due in 3 days.

  def character_play
    if params[:character_one].empty? || params[:character_two].empty? || params[:num].empty?
      @error = "You need to enter all parameters for this game to work."
      render 'play'
    else
      public_key = ENV['marvel_public_key']
      private_key = ENV['marvel_private_key']
      timestamp = DateTime.now.to_s
      hash = Digest::MD5.hexdigest( "#{timestamp}#{private_key}#{public_key}" )
      #I spent a fair amount of time looking at the Marvel API documentation to figure out how they wanted the hash digested, and even get help at the meetup I went to during this project on the MD5 digest
      #I looked at other repos on github that had used the Marvel API to see how they called it as well
      #Below, you'll see the two characters chosen by the players and that they're found in the Marvel universe via the API request and then this makes it possible to put their details in the views

      begin
      @resp_one = Faraday.get 'http://gateway.marvel.com/v1/public/characters' do |req|
        req.params['ts'] = timestamp
        req.params['apikey'] = public_key
        req.params['hash'] = hash
        req.params['name'] = params[:character_one]
      end

      character_one = JSON.parse(@resp_one.body)

      @resp_two = Faraday.get 'http://gateway.marvel.com/v1/public/characters' do |req|
        req.params['ts'] = timestamp
        req.params['apikey'] = public_key
        req.params['hash'] = hash
        req.params['name'] = params[:character_two]
      end

      character_two = JSON.parse(@resp_two.body)

      #This was hard to make error messages because if someone tries to find a character name that isn't in the database, it's still a response code of 200. I left this here for cases when it just isn't 200, but made a new error system below.

      #index to identify the word in sequence in the description
      index = params[:num].to_i - 1

      if character_one["code"] != 200
        @error = "This didn't work"
        render 'play'
      elsif character_two["code"] != 200
        @error = "This didn't work"
        render 'play'
      elsif character_two.empty? || character_one.empty?
        @error = "One of these characters is not spelled right or doesn't exist."
        render 'play'
      elsif @resp_one.success? && @resp_two.success?
        @character_one = character_one['data']['results']
        @character_two = character_two['data']['results']
        #I want to refactor this later so the winner shows on another page by redirect, but for now all of that is happening here.
        #I think it would be better to have that somehow delayed so you see who's battling first then click another button to get the winner.
        #Error cases for when the character isn't found are handled below
        if @character_one.blank? || @character_two.blank? || first_comic_blank?(@character_one) || first_comic_blank?(@character_two)
          #Some characters have a blank description. The last major roadblock in this project was that some of the Marvel Universe characters didn't contain descriptions, therefore the game wouldn't be able to compare their words according to the seeded params.
          #I decided to make it so if this happens, the first listed comic's title length is compared instead of the description.
          #For those edge cases who have nothing listed under them like 'S.H.E.I.L.D.', or have no comics listed, I just threw an error for the user. I could maybe instead take the params and decide the winner based on that, but it seems like the players would catch on!
          @error = "Try again with different characters, that didn't seem to work."
          render 'play'
        elsif desc_blank?(@character_one) || desc_blank?(@character_two)
          if comic_split(@character_two)[index].nil? || comic_split(@character_one)[index].nil?
            @error = "Try again with different characters."
          else
            #This edge case means that sometimes the Hulk or Spider-Man might not win! Exciting. Try "Gamora" against the Hulk and Gamora wins!
            @word_one = comic_split(@character_one)[index]
            @word_two = comic_split(@character_two)[index]
          end
          render 'play'
        elsif @character_one && @character_two
          @word_one = desc_split(@character_one)[index]
          #To compare the word length at that index of the description as it's split into an array
          @all_words_one = @character_one[0]['description'].split(' ')
          #To compare the whole descriptions to see if the magic words are present (below)
          @word_two = desc_split(@character_two)[index]
          @all_words_two = @word_two = @character_two[0]['description'].split(' ')
          @two_magic = @all_words_two.include?("Gamma") || @all_words_two.include?("Radioactive") || @all_words_two.include?("gamma") || @all_words_two.include?("radioactive")
          @one_magic = @all_words_one.include?("Gamma") || @all_words_one.include?("Radioactive") || @all_words_one.include?("gamma") || @all_words_one.include?("radioactive")
          render 'play'
        else
          @error = "Sorry, please try again with different inputs."
          render 'play'
        end
          #Both characters are identified! The play view is rendered with the proper info/images
          #I decided to compare the word_one and word_two variables in the view for the winner, but I think I could easily put those conditional statements here
      else
        @error = "That didn't work, try again"
        render 'play'
      end
      #An error message in case there's a timeout
      rescue Faraday::ConnectionFailed
        @error = "There was a timeout. Please try again."
      rescue Faraday::Response::RaiseError
        @error = "There was a problem finding that. Please try again."
      end

    end
  end

  def one_player_mode_play
    @computer_choice = ["iron man", "hulk", "wasp"]
    @user = current_user
    # public_key = ENV['marvel_public_key']
    # private_key = ENV['marvel_private_key']
    # timestamp = DateTime.now.to_s
    # hash = Digest::MD5.hexdigest( "#{timestamp}#{private_key}#{public_key}" )
    #
    # begin
    # @resp_one = Faraday.get 'http://gateway.marvel.com/v1/public/characters' do |req|
    #   req.params['ts'] = timestamp
    #   req.params['apikey'] = public_key
    #   req.params['hash'] = hash
    #   req.params['name'] =  @computer_choice.sample
    # end
    #
    # character_one = JSON.parse(@resp_one.body)
  end

  def one_player_mode

  end

  def index
    #This is just a rendering with a search form for someone to enter the first few letters of a character to find them
  end

  def searchByLetter
    public_key = ENV['marvel_public_key']
    private_key = ENV['marvel_private_key']
    timestamp = DateTime.now.to_s
    hash = Digest::MD5.hexdigest( "#{timestamp}#{private_key}#{public_key}" )

    if !params[:letter].blank?
      @resp = Faraday.get 'http://gateway.marvel.com/v1/public/characters' do |req|
        req.params['ts'] = timestamp
        req.params['apikey'] = public_key
        req.params['hash'] = hash
        req.params['nameStartsWith'] = params[:letter]
        #The Marvel API is cool because it allows this kind of a search with an incomplete spelling of a character name.
      end

      characters = JSON.parse(@resp.body)
      @characters = characters['data']['results']
    else
      @error = "Sorry you need to enter at least one letter"
    end
    #Renders the page again with the search results. For some reason if there's a lot of results, it only will load the first 20. The API has set that as the limit. That's why this search form is so important so people can find the characters they want.
    render 'index'
  end


end
