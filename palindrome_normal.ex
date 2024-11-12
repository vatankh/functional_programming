defmodule PalindromeNormal do
  def largest_palindrome_product do
    find_palindrome(999, 999, 0)
  end

  defp find_palindrome(a, b, max) when a >= 100 do
    product = a * b
    new_max =
      if palindrome?(product) and product > max do
        product
      else
        max
      end

    if b > 100 do
      max_of_rest = find_palindrome(a, b - 1, new_max)
      max(max_of_rest, new_max)  # Operation after recursion
    else
      max_of_rest = find_palindrome(a - 1, 999, new_max)
      max(max_of_rest, new_max)  # Operation after recursion
    end
  end

  defp find_palindrome(_, _, max), do: max

  def palindrome?(n) do
    str = Integer.to_string(n)
    str == String.reverse(str)
  end
end