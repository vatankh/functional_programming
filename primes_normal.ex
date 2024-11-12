defmodule QuadraticPrimesNormal do
  # Monolithic function to find the product of coefficients for the best prime-generating formula
  def find_best_coefficients do
    is_prime = fn n ->
      if n <= 1 do
        false
      else
        upper_bound = :math.sqrt(n) |> round
        Enum.all?(2..upper_bound, fn i -> rem(n, i) != 0 end)
      end
    end

    find_best_coefficients_rec(-999, -1000, 0, 0, 0, is_prime)
  end

  defp find_best_coefficients_rec(a, b, max_count, best_a, best_b, is_prime) when a <= 999 do
    count = count_consecutive_primes(a, b, 0, is_prime)

    {new_best_a, new_best_b, new_max_count} =
      if count > max_count do
        {a, b, count}
      else
        {best_a, best_b, max_count}
      end

    next_a = if b < 1000, do: a, else: a + 1
    next_b = if b < 1000, do: b + 1, else: -1000
    find_best_coefficients_rec(next_a, next_b, new_max_count, new_best_a, new_best_b, is_prime)
  end

  defp find_best_coefficients_rec(_, _, _, best_a, best_b, _), do: best_a * best_b

  defp count_consecutive_primes(a, b, n, is_prime) do
    formula_result = n * n + a * n + b

    if is_prime.(formula_result) do
      1 + count_consecutive_primes(a, b, n + 1, is_prime)
    else
      0
    end
  end
end

# Running the function to get the product of best coefficients
result = QuadraticPrimesNormal.find_best_coefficients()
IO.puts("Product of coefficients a and b that produce the maximum number of primes: #{result}")
