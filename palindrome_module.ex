defmodule PalindromeModule do
  # Main function that coordinates the modular solution
  def largest_palindrome_product do
    generate_products()
    |> filter_palindromes()
    |> find_max()
  end

  # 1. Generation of the sequence of products using Enum.map/2 and a comprehension
  defp generate_products do
    for a <- 100..999, b <- 100..999, do: a * b
  end

  # 2. Filtering to keep only palindromic numbers using Enum.filter/2
  defp filter_palindromes(products) do
    Enum.filter(products, &palindrome?/1)
  end

  # 3. Finding the maximum palindrome using Enum.reduce/3
  defp find_max(palindromes) do
    Enum.reduce(palindromes, 0, &max/2)
  end

  # Helper function to check if a number is a palindrome
  def palindrome?(n) do
    str = Integer.to_string(n)
    str == String.reverse(str)
  end
end
