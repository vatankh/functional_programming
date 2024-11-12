defmodule PalindromeTail do
  def largest_palindrome_product do
    find_palindrome(999, 999, 0)
  end

  defp find_palindrome(a, b, max) when a >= 100 do
    product = a * b
    if palindrome?(product) and product > max do
      find_palindrome(a, b - 1, product)
    else
      if b > 100 do
        find_palindrome(a, b - 1, max)
      else
        find_palindrome(a - 1, 999, max)
      end
    end
  end

  defp find_palindrome(_, _, max), do: max

  def palindrome?(n) do
    str = Integer.to_string(n)
    str == String.reverse(str)
  end
end