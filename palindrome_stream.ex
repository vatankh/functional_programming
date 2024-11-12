defmodule PalindromeStream do
  # Main function that coordinates the solution using lazy streams
  def largest_palindrome_product do
    generate_products()
    |> Stream.filter(&palindrome?/1)
    |> Enum.max()
  end

  # Generate products lazily with Stream
  defp generate_products do
    Stream.flat_map(100..999, fn a ->
      Stream.map(100..999, fn b -> a * b end)
    end)
  end

  # Helper function to check if a number is a palindrome
  def palindrome?(n) do
    str = Integer.to_string(n)
    str == String.reverse(str)
  end
end
