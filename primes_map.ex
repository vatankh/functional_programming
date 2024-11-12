defmodule QuadraticPrimesMap do
  # Проверка простоты числа
  def is_prime(n) when n <= 1, do: false
  def is_prime(n) do
    upper_bound = :math.sqrt(n) |> round
    Enum.all?(2..upper_bound, fn i -> rem(n, i) != 0 end)
  end

  # Генерация последовательности при помощи отображения (map)
  def generate_sequence_with_map(a, b) do
    0..1000  # Arbitrary large range to generate enough values
    |> Enum.map(fn n -> n * n + a * n + b end)
  end

  # Подсчёт последовательных простых чисел в последовательности
  def count_consecutive_primes(sequence) do
    sequence
    |> Enum.take_while(&is_prime/1)
    |> Enum.count()
  end

  # Поиск наилучших коэффициентов
  def find_best_coefficients do
    coefficients = for a <- -999..999, b <- -1000..1000, do: {a, b}

    Enum.reduce(coefficients, {0, 0, 0}, fn {a, b}, {best_a, best_b, max_count} ->
      count = a |> generate_sequence_with_map(b) |> count_consecutive_primes()

      if count > max_count do
        {a, b, count}
      else
        {best_a, best_b, max_count}
      end
    end)
    |> then(fn {best_a, best_b, _max_count} -> best_a * best_b end)
  end
end

# Running the function to get the product of best coefficients
result = QuadraticPrimesMap.find_best_coefficients()
IO.puts("Product of coefficients a and b that produce the maximum number of primes: #{result}")