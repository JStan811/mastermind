# frozen_string_literal: true

module Mastermind
  # this contains the logic of the game
  class Game
    def initialize(codemaker, codebreaker, code_board, guess_board, feedback_board)
      @codemaker = codemaker
      @codebreaker = codebreaker
      @code_board = code_board
      @guess_board = guess_board
      @feedback_board = feedback_board
      @round_count = 12
      @color_count = 6
      @duplicates_allowed = false
      @blanks_allowed = false
    end

    # rubocop:disable Layout/LineLength
    # possible methods: handle turn, check and declare winner/loser, keep score, feedback engine (decide feedback, set feedback, display feedback), play game (prompt maker for code -> prompt breaker for guess -> collect guess -> run feedback engine -> check for winner. if none, continue -> if after 12th round no win, declare loser -> new game?)
    # rubocop:enable Layout/LineLength

    def play_game
      puts 'Welcome to Mastermind.'
      # decide maker and breaker (right now this is always the same)
      # prompt maker for code
      # collect_maker_code # if the human is codemaker
      computer_generate_code # if the computer is codemaker
      puts 'The Codemaker has selected their code.'
      loop_through_turns
      # after 12, if still no win, declare loss
      puts 'Game over.'
      # new game?
    end

    private

    def computer_generate_code
      @code_board.state.map! do
        # check if random_color exists in array to avoid duplicates
        random_color = rand(1..6)
        random_color = rand(1..6) while @code_board.state.include?(random_color.to_s)
        random_color.to_s #convert to strings b/c currently guess board is strings. Needed for feedback engine to work
      end
    end

    def collect_maker_code
      # prompt maker for code
      puts 'Codemaker, place a peg (1-6) in position 1. No duplicates or blanks.'
      color1 = gets.chomp
      puts 'Codemaker, place a peg (1-6) in position 2. No duplicates or blanks.'
      color2 = gets.chomp
      puts 'Codemaker, place a peg (1-6) in position 3. No duplicates or blanks.'
      color3 = gets.chomp
      puts 'Codemaker, place a peg (1-6) in position 4. No duplicates or blanks.'
      color4 = gets.chomp
      @codemaker.make_code(@code_board, color1, color2, color3, color4)

      # print state for debugging (may be replaced by display)
      puts "Code Board: #{@code_board.state}"
      puts ''
    end

    def collect_breaker_guess_string
      # prompt breaker for guess
      puts 'Codebreaker, enter your guess as a string of four numbers (1-6). For example, 1234.'
      guess = gets.chomp
      guess_array = guess.split('')
      @codebreaker.make_guess(@guess_board, guess_array[0], guess_array[1], guess_array[2], guess_array[3])

      # print state for debugging (may be replaced by display)
      puts "Guess Board: #{@guess_board.state}"
      puts ''
    end

    def collect_breaker_guess
      # prompt breaker for guess
      puts 'Codebreaker, place a peg (1-6) in position 1. No duplicates or blanks.'
      color1 = gets.chomp
      puts 'Codebreaker, place a peg (1-6) in position 2. No duplicates or blanks.'
      color2 = gets.chomp
      puts 'Codebreaker, place a peg (1-6) in position 3. No duplicates or blanks.'
      color3 = gets.chomp
      puts 'Codebreaker, place a peg (1-6) in position 4. No duplicates or blanks.'
      color4 = gets.chomp
      @codebreaker.make_guess(@guess_board, color1, color2, color3, color4)

      # print state for debugging (may be replaced by display)
      puts "Guess Board: #{@guess_board.state}"
      puts ''
    end

    def check_win?
      # evaluate guess board - does guess == code?
      # if yes, return true
      @guess_board.state == @code_board.state
    end

    def feedback_engine
      # compare guess board and code board
      # loop through guess board and check each position with corresponding position of code board, noting which are the same and updating feedback board
      # then loop through guess board, checking if color exists anywhere in code board and updating feedback board
      @guess_board.state.each_with_index do |guess_color, index|
        @code_board.state.each do |code_color|
          @feedback_board.state[index] = 'White' if guess_color == code_color # should replace = 'White' with place_peg method
        end

        @feedback_board.state[index] = 'Black' if guess_color == @code_board.state[index] # should replace = 'Black' with place_peg method
      end

      # print state for debugging (may be replaced by display)
      puts "Feedback Board: #{@feedback_board.state}"
      puts ''
    end

    def loop_through_turns
      for i in 1..@round_count
        @feedback_board.reset # reset feedback_board
        collect_breaker_guess_string
        if check_win?
          puts "Code Board: #{@code_board.state}"
          puts 'Codebreaker, you win!'
          break
        end
        if i == 12
          puts "Code Board: #{@code_board.state}"
          puts "You lose."
          break
        end
        feedback_engine
      end
    end
  end
end
