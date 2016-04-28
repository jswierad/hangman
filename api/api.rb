# Start a new game
post '/games' do
    words = ["terraform", "devops", "ruby"]
    i = Random.rand(0...words.length)
    g = Game.create(word: words[i])
    g.to_json 
end

# Return JSON with all games (including guessed letters)
get '/games' do
    @games = Game.map{ |g| [g, g.letters] }
    @games.to_json
end

# Return JSON for a given game id
get '/games/:id' do
    g = Game.get(params[:id])
    if g.nil?
        halt 404
    end
    g.get_json
end

# Register a letter for the game
post '/games/:id' do
    r = request.body.read.split("char=")
    # Invalid payload
    if (r.length != 2)
        halt 400
    end

    letter = r[1]
    # Continue only if provided payload is valid
    if (letter != nil and letter.length == 1 and letter =~ /[a-z]/)
        g = Game.get(params[:id])
        if g.nil?   
            halt 404
        end

        # game is finished, do not register letters
        if ( g.status != 0 )
            halt 400
        end    

        g.tries_left -= 1
        g.register_letter(letter)

        # You won!
        unless g.check_letters.include? "."
            g.status = 1
        end

        # last try; sorry, but you lost.
        if ( g.tries_left == 0 and g.status != 1 )                 
            g.status = 2
        end 

        g.save
        status 200
    else
        halt 400
    end
end
