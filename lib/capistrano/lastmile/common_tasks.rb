# =========================================================================
# These are helper methods that will be available to your recipes.
# =========================================================================

##
# Runs a remote bash if condition and returns (ruby) true/false.
#
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
def pass_prompt(msg)
  puts "\n\n"
  Capistrano::CLI.password_prompt(msg)
end

##
# Print an informative message with asterisks.
#
def inform(message)
  puts "#{'*' * (message.length + 4)}"
  puts "* #{message} *"
  puts "#{'*' * (message.length + 4)}"
end

##
# Prints a block warning with enough whitespace and within a column width.
#
def block_warn(msg, inner_width=70)
  puts "\n#{'*' * (inner_width + 4)}"
  msg.each { |l| puts "* #{l.lstrip.rstrip.ljust(inner_width, " ")} *" }
  puts "#{'*' * (inner_width + 4)}\n\n\n"
end
