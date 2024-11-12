defmodule QuadraticPrimesModule do
  # Проверка, является ли число простым
  def is_prime(n) when n <= 1, do: false
  def is_prime(n) do
    upper_bound = :math.sqrt(n) |> round
    Enum.all?(2..upper_bound, fn i -> rem(n, i) != 0 end)
  end

  # Генерация последовательности результатов формулы для заданных `a` и `b`
  def generate_sequence(a, b) do
    Stream.iterate(0, &(&1 + 1))
    |> Stream.map(fn n -> n * n + a * n + b end)
  end

  # Фильтрация последовательности, оставляя только простые числа
  def filter_primes(sequence) do
    Stream.take_while(sequence, &is_prime/1)
    |> Enum.to_list()  # Convert stream to list for counting and manipulation
  end

  # Свертка для нахождения лучших коэффициентов
  def find_best_coefficients do
    coefficients = for a <- -999..999, b <- -1000..1000, do: {a, b}

    Enum.reduce(coefficients, {0, 0, 0}, fn {a, b}, {best_a, best_b, max_count} ->
      count = a |> generate_sequence(b) |> filter_primes() |> Enum.count()

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
result = QuadraticPrimesModule.find_best_coefficients()
IO.puts("Product of coefficients a and b that produce the maximum number of primes: #{result}")
