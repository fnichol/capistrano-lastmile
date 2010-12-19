Capistrano::Lastmile.load do
 
  # =========================================================================
  # These are helper methods that will be available to your recipes.
  # =========================================================================

  def disabled?(recipe)
    exists?("use_#{recipe}") && send("use_#{recipe}") == false
  end

  def lm_cset(name, *args, &block)
    set(name, *args, &block) unless exists?(name)
  end

  ##
  # Runs a remote bash if condition and returns (ruby) true/false.
  #
  # @param [String] expr  a shell expression that can evaluate to true/false
  # @return [true,false] whether or not the remote expression was true or false
  def cmd_if(expr)
    r = capture %{[[ #{expr} ]] && echo true || echo false}
    if r.to_s =~ /true/
      true
    else
      false
    end
  end

  ##
  # Prompts for a password and returns input.
  #
  # @param [String] msg  the message to be asked at the password prompt
  # @return [String, nil] the password
  def pass_prompt(msg)
    puts "\n\n"
    Capistrano::CLI.password_prompt(msg)
  end

  ##
  # Print an informative message with asterisks.
  #
  # @param [String] message  the message to display
  def inform(message)
    puts "#{'*' * (message.length + 4)}"
    puts "* #{message} *"
    puts "#{'*' * (message.length + 4)}"
  end

  ##
  # Prints a block warning with enough whitespace and within a column width.
  #
  # @param [String] msg  the message to display
  # @param [Integer] inner_width  width of inner width of text block
  def block_warn(msg, inner_width=70)
    puts "\n#{'*' * (inner_width + 4)}"
    msg.each { |l| puts "* #{l.lstrip.rstrip.ljust(inner_width, " ")} *" }
    puts "#{'*' * (inner_width + 4)}\n\n\n"
  end
end
