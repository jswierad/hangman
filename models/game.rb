class Game
    include DataMapper::Resource
    property :id,           Serial
    property :status,       Integer,    :default => 0
    property :word,         String
    property :tries_left,   Integer,    :default => 11
    has n,   :letters

    def check_letters
        word = ""
        letters = []
        self.letters.each do |l|
            letters << l.letter
        end

        self.word.split('').each do |s|
            if ( letters.include? s )
                word << s
            else
                word << "."
            end
        end  
        return word
    end

    def register_letter(letter) 
        l = Letter.create(letter: letter)
        self.letters << l
    end

    def get_json
        status = ["busy", "success", "fail"]
        game_json = Hash.new()

        game_json["tries_left"] = self.tries_left
        game_json["status"] = status[self.status]
        game_json["word"] = self.check_letters

        return JSON.generate(game_json)
    end


end    

class Letter
    include DataMapper::Resource
    property :id,           Serial
    property :letter,       String
end
