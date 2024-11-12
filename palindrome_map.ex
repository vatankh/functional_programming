defmodule PalindromeMap do
  def largest_palindrome_product do
    generate_products()
    |> filter_palindromes()
    |> find_max()
  end

  # 1. Generation of the sequence of products using Enum.map/2 to create pairs of products
  defp generate_products do
    100..999
    |> Enum.flat_map(fn a ->
      Enum.map(100..999, fn b -> a * b end)
    end)
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
