class Hangman
    attr_accessor :secret_word, :encrypted_word, :lives, :incorrect_guesses
    def initialize
        @secret_word = get_secret_word
        @encrypted_word = encrypt_word(@secret_word)
        @lives = 6
        @incorrect_guesses = []
    end

    def get_secret_word
        dictionary = File.open("dictionary.txt", "r") {|file| file.read}
        dictionary = dictionary.split("\r\n").select {|word| word.length>=5 && word.length <=12}
        dictionary[rand(dictionary.length - 1)].downcase
    end

    def encrypt_word(word)
        word.split("").map {|letter| "_"}
    end

    def check_guess(letter)
        if !@secret_word.include?(letter) && !@incorrect_guesses.include?(letter)
            @incorrect_guesses << letter
            @lives -= 1
        end
    end

    def decrypt_word(letter)
        indexes = @secret_word.split("").each_index.select {|i| @secret_word[i] == letter}
        indexes.each {|i| @encrypted_word[i] = letter}
    end
end