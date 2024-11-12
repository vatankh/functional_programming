
# Лабораторная работа № 1

**Студент:** Ватан Хатиб

**Задачи по варианту:** Problem 4 (Largest Palindrome Product)

### Цель

Освоение базовых приемов и абстракций функционального программирования: функции, поток управления и поток данных, сопоставление с образцом, рекурсия, свёртка, отображение, работа с функциями как с данными, списки. Решение задач проекта Эйлер с использованием Elixir и функционального стиля программирования.

## Задача 4: Largest Palindrome Product

### Условие

Найти наибольший палиндром, который является произведением двух трёхзначных чисел.

---

### Решения

#### 1. Монолитная реализация с использованием хвостовой рекурсии

```elixir
defmodule Palindrome do
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

  defp palindrome?(n) do
    str = Integer.to_string(n)
    str == String.reverse(str)
  end
end
```

**Механизм работы:**
- Функция `find_palindrome/3` запускается с двумя исходными числами `a = 999` и `b = 999`.
- На каждой итерации перемножаются `a` и `b`, и проверяется, является ли их произведение палиндромом (через вспомогательную функцию `palindrome?/1`).
- Если произведение палиндромно и больше текущего максимального найденного (`max`), оно становится новым значением `max`.
- Переменная `b` уменьшается на 1 при каждом шаге, пока не достигнет 100. Когда `b = 100`, `a` уменьшается на 1, а `b` снова становится 999.
- Хвостовая рекурсия позволяет эффективно находить результат, сводя вычисления к минимально необходимым шагам, благодаря отсутствию накопления промежуточных результатов.

#### 2. Монолитная реализация с обычной рекурсией

```elixir
defmodule Palindrome do
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

  defp palindrome?(n) do
    str = Integer.to_string(n)
    str == String.reverse(str)
  end
end
```

**Механизм работы:**
- `find_palindrome/3` запускается с `a = 999` и `b = 999`.
- На каждой итерации вычисляется `product = a * b` и проверяется, является ли это число палиндромом с помощью `palindrome?/1`.
- Если `product` — палиндром и больше текущего `max`, оно становится новым значением `max`.
- Переменная `b` уменьшается, пока не достигнет 100. Когда `b = 100`, `a` уменьшается на 1, а `b` снова становится 999.
- Используется обычная (не хвостовая) рекурсия: после каждого рекурсивного вызова `find_palindrome/3` выполняется операция `max(max_of_rest, new_max)`.
- Это предотвращает оптимизацию хвостовой рекурсии, сохраняя каждый вызов в стеке и приводя к накоплению промежуточных результатов.


#### 3. Модульная реализация с использованием reduce и filter + работа со спец. синтаксисом для циклов

```elixir
defmodule Palindrome do
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
  defp palindrome?(n) do
    str = Integer.to_string(n)
    str == String.reverse(str)
  end
end
```

**Механизм работы:**
- Модуль `Palindrome` состоит из трёх функций, которые последовательно выполняют генерацию последовательности, фильтрацию и свёртку.
- `generate_products/0` создает список всех возможных произведений двух 3-значных чисел (от 100 до 999) с использованием списочного включения (`for a <- 100..999, b <- 100..999, do: a * b`), что также удовлетворяет Требование 4 о специальном синтаксисе для циклов.
- `filter_palindromes/1` принимает список произведений и фильтрует его, оставляя только палиндромы. Для этого используется `Enum.filter/2` и вспомогательная функция `palindrome?/1`, которая проверяет, является ли число палиндромом.
- `find_max/1` принимает отфильтрованный список палиндромов и находит максимальное значение с помощью `Enum.reduce/3`, где функция `&max/2` используется для сравнения элементов, а начальное значение аккумулятора — `0`.
- Данная реализация модульная и разделяет генерацию последовательности, фильтрацию и свёртку, что делает код более читаемым и легким для поддержки.



#### 4. Использование отображения (map) для генерации последовательности

```elixir
defmodule Palindrome do
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
  defp palindrome?(n) do
    str = Integer.to_string(n)
    str == String.reverse(str)
  end
end
```

**Механизм работы:**

- Модуль `Palindrome` состоит из трёх функций, которые выполняют генерацию последовательности, фильтрацию и свёртку.
- `generate_products/0` создает список всех возможных произведений двух 3-значных чисел (от 100 до 999) с помощью функции отображения (`Enum.map/2`). 
  - Сначала создаётся диапазон чисел `100..999`, и для каждого числа `a` в этом диапазоне применяется `Enum.flat_map`, где происходит вложенное отображение (`Enum.map`) для всех `b` в диапазоне `100..999`.
  - Для каждой пары чисел `a` и `b` вычисляется произведение `a * b`, и результат добавляется в плоский список всех произведений.
- `filter_palindromes/1` принимает список произведений и фильтрует его, оставляя только палиндромы. Для этого используется `Enum.filter/2` и вспомогательная функция `palindrome?/1`, которая проверяет, является ли число палиндромом.
- `find_max/1` принимает отфильтрованный список палиндромов и находит максимальное значение с помощью `Enum.reduce/3`, где функция `&max/2` используется для сравнения элементов, а начальное значение аккумулятора — `0`.
- Данная реализация использует функцию отображения (map) для генерации последовательности произведений и сохраняет модульную структуру для разделения задач генерации, фильтрации и свёртки.

#### 5.работа с бесконечными списками

```elixir
defmodule Palindrome do
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
  defp palindrome?(n) do
    str = Integer.to_string(n)
    str == String.reverse(str)
  end
end
```
**Механизм работы:**

- Модуль `Palindrome` использует ленивые коллекции `Stream` для создания последовательности произведений и фильтрации палиндромов.
- `generate_products/0` создает ленивую последовательность всех возможных произведений двух 3-значных чисел с помощью `Stream.flat_map/2` и `Stream.map/2`:
  - `Stream.flat_map(100..999, fn a -> ... end)` проходит по каждому числу `a` в диапазоне `100..999`.
  - Для каждого `a`, `Stream.map(100..999, fn b -> a * b end)` вычисляет произведение `a * b` лениво, создавая поток значений, которые вычисляются по мере необходимости.
- `Stream.filter(&palindrome?/1)` фильтрует ленивую последовательность, оставляя только числа-палиндромы.
- `Enum.max/1` находит максимальный палиндром среди отфильтрованных значений. Этот вызов завершает вычисление ленивой последовательности, так как он вынуждает обработать весь поток до получения максимального значения.
- Использование `Stream` позволяет оптимизировать память и вычисления, так как значения генерируются и фильтруются только по мере необходимости, что подходит для работы с потенциально бесконечными списками.

#### 6.реализация на традиционном языке программирования python

```python
def is_palindrome(n):
    str_n = str(n)
    return str_n == str_n[::-1]

def largest_palindrome_product():
    max_palindrome = 0
    for a in range(999, 99, -1):
        for b in range(a, 99, -1):  # Start b from a to avoid redundant calculations
            product = a * b
            if product <= max_palindrome:
                break  # No need to continue if product is already smaller than max_palindrome
            if is_palindrome(product):
                max_palindrome = product
    return max_palindrome

# Main execution
if __name__ == "__main__":
    print("Largest palindrome product:", largest_palindrome_product())
```

**Механизм работы и сравнение с общей реализацией на Elixir:**

- Python-реализация использует вложенные циклы `for`, чтобы пройти по всем возможным произведениям двух 3-значных чисел (от 999 до 100). 
- Внутренний цикл начинается от текущего значения `a`, чтобы избежать дублирующихся пар (например, `(a, b)` и `(b, a)`).
- Для каждого произведения выполняется проверка на палиндром с помощью функции `is_palindrome`, которая сравнивает строковое представление числа с его реверсией.
- Если произведение больше текущего максимального палиндрома, оно сохраняется как новый максимум. Внутренний цикл прерывается (`break`), если произведение становится меньше уже найденного максимума, что улучшает производительность.

**Сравнение с общей реализацией на Elixir:**
- В базовой реализации на Elixir используются модули `Enum` и `for`-компрехеншн для генерации, фильтрации и свёртки последовательностей, без ленивых вычислений.
- В Python-реализации мы используем условие `break` для оптимизации работы внутреннего цикла, что позволяет избежать вычислений, когда произведение меньше текущего максимума. В Elixir этого эффекта можно достичь с использованием фильтров и функции `Enum.reduce`.
- В целом, Elixir предоставляет более декларативный подход, где функции `Enum.map`, `Enum.filter` и `Enum.reduce` позволяют обрабатывать последовательности функционально. Python использует более императивный подход с явными циклами, в то время как Elixir-код более компактный за счёт функций высшего порядка.

## Задача 27: Quadratic Primes

### Условие

Найти произведение коэффициентов \( a \) и \( b \) для квадратного выражения \( n^2 + an + b \), которое генерирует наибольшее количество последовательных простых чисел для значений \( n \), начиная с \( n = 0 \).

---

### Решения

#### 1. Монолитная реализация с использованием хвостовой рекурсии

```elixir
defmodule QuadraticPrimes do
  # Monolithic function to find the product of coefficients for the best prime-generating formula
  def find_best_coefficients do
    # Helper function defined inside to check primality
    is_prime = fn n ->
      if n <= 1 do
        false
      else
        upper_bound = :math.sqrt(n) |> round
        Enum.all?(2..upper_bound, fn i -> rem(n, i) != 0 end)
      end
    end

    # Tail-recursive loop to iterate over possible values of a and b
    find_best_coefficients_rec(-999, -1000, 0, 0, 0, is_prime)
  end

  defp find_best_coefficients_rec(a, b, max_count, best_a, best_b, is_prime) when a <= 999 and b <= 1000 do
    # Counting consecutive primes produced by n^2 + a*n + b for the current values of a and b
    count_consecutive_primes = fn a, b ->
      count_consecutive_primes_rec(a, b, 0, is_prime)
    end

    count = count_consecutive_primes.(a, b)

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

  defp count_consecutive_primes_rec(a, b, n, is_prime) do
    formula_result = n * n + a * n + b

    if is_prime.(formula_result) do
      count_consecutive_primes_rec(a, b, n + 1, is_prime)
    else
      n
    end
  end
end

# Running the function to get the product of best coefficients
result = QuadraticPrimes.find_best_coefficients()
IO.puts("Product of coefficients a and b that produce the maximum number of primes: #{result}")
```

**Механизм работы:**

- `find_best_coefficients/0` запускает основной процесс, определяя анонимные функции `is_prime` для проверки простоты числа и `count_consecutive_primes` для подсчета последовательных простых чисел, сгенерированных формулой.

1. **Проверка простоты числа**:
   - `is_prime` проверяет, является ли число `n` простым, путем деления на числа от 2 до округленного квадратного корня `n`. Если `n` делится на любое из них, оно не является простым.

2. **Подсчет последовательных простых чисел**:
   - `count_consecutive_primes` рекурсивно вычисляет, сколько последовательных значений `n` дают простое число при использовании формулы `n^2 + a*n + b`.

3. **Поиск лучших коэффициентов**:
   - `find_best_coefficients_rec/6` перебирает все значения `a` и `b` в диапазоне -999 до 999 для `a` и -1000 до 1000 для `b`.
   - Для каждой пары коэффициентов вызывает `count_consecutive_primes` и обновляет `best_a`, `best_b`, и `max_count`, если найдено большее количество последовательных простых чисел.

4. **Завершение**:
   - После проверки всех значений `a` и `b`, функция возвращает произведение `best_a * best_b`, соответствующее максимальному количеству последовательных простых чисел.


#### 2. Монолитная реализация с обычной рекурсией
```elixir
defmodule QuadraticPrimes do
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

  defp find_best_coefficients_rec(_, _, max_count, best_a, best_b, _), do: best_a * best_b

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
result = QuadraticPrimes.find_best_coefficients()
IO.puts("Product of coefficients a and b that produce the maximum number of primes: #{result}")
```

**Механизм работы:**

- Основная функция `find_best_coefficients/0` запускает процесс поиска наилучших коэффициентов, включая анонимную функцию `is_prime` для проверки простоты числа и рекурсивную функцию `find_best_coefficients_rec` для поиска значений `a` и `b`.

1. **Проверка простоты числа**:
   - `is_prime` проверяет, является ли число `n` простым, путем деления на числа от 2 до округленного квадратного корня `n`.

2. **Подсчет последовательных простых чисел**:
   - `count_consecutive_primes/4` рекурсивно вычисляет количество последовательных простых чисел, генерируемых формулой `n^2 + a*n + b`. Если результат является простым, функция добавляет 1 к результату и вызывает саму себя с `n + 1`.

3. **Поиск лучших коэффициентов**:
   - `find_best_coefficients_rec/6` выполняет рекурсивный перебор всех значений `a` и `b` в пределах `-999 ≤ a ≤ 999` и `-1000 ≤ b ≤ 1000`.
   - Для каждой пары коэффициентов вычисляется количество последовательных простых чисел с помощью `count_consecutive_primes`. Если найдено большее количество последовательных простых чисел, чем текущее максимальное, обновляются переменные `best_a`, `best_b` и `max_count`.

4. **Завершение**:
   - Когда все комбинации `a` и `b` проверены, функция возвращает произведение коэффициентов `best_a * best_b`, которые генерируют максимальное количество последовательных простых чисел.

- **Отличие обычной рекурсии**: В этой реализации рекурсия не является хвостовой, поскольку функция `count_consecutive_primes/4` добавляет 1 к результату рекурсивного вызова, прежде чем вернуть его. Это создает цепочку вызовов, накапливая промежуточные результаты, что отличает её от хвостовой рекурсии.


#### 3. Модульная реализация с использованием reduce и filter + работа с бесконечными списками

```elixir
defmodule QuadraticPrimes do
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
result = QuadraticPrimes.find_best_coefficients()
IO.puts("Product of coefficients a and b that produce the maximum number of primes: #{result}")
```

**Механизм работы:**

- Реализация разделена на три этапа: генерация последовательности, фильтрация простых чисел и свёртка для поиска наилучших коэффициентов, обеспечивая модульность и гибкость кода.

1. **Проверка простоты числа**:
   - `is_prime/1` определяет, является ли число простым, проверяя его делимость на числа от 2 до округленного квадратного корня `n`.

2. **Генерация последовательности**:
   - `generate_sequence/2` создаёт бесконечный поток значений, сгенерированных формулой `n^2 + a*n + b` для заданных коэффициентов `a` и `b`, используя `Stream.iterate`. Это позволяет обрабатывать бесконечные списки без создания всех значений сразу.

3. **Фильтрация последовательности**:
   - `filter_primes/1` отбирает только простые числа из потока, пока результат остаётся простым, используя `Stream.take_while`. Затем результат преобразуется в список для удобного подсчёта.

4. **Поиск лучших коэффициентов**:
   - `find_best_coefficients/0` перебирает все пары `(a, b)` с помощью `Enum.reduce`, генерируя и фильтруя последовательности для каждой пары и обновляя максимальную длину последовательности простых чисел, если найдены лучшие коэффициенты.

5. **Завершение**:
   - Функция возвращает произведение `best_a * best_b`, соответствующее коэффициентам, которые дают максимальную последовательность простых чисел.

- **Работа с бесконечными списками**: Благодаря `Stream.iterate`, код обрабатывает значения по мере необходимости, поддерживая работу с бесконечными последовательностями.


#### 4. Использование отображения (map) для генерации последовательности + работа со спец. синтаксисом для циклов

```elixir
defmodule QuadraticPrimes do
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
result = QuadraticPrimes.find_best_coefficients()
IO.puts("Product of coefficients a and b that produce the maximum number of primes: #{result}")
```

**Механизм работы:**

- Реализация использует `map` для генерации значений, а также специальный синтаксис `for` для циклов, что делает код выразительным и эффективным.

1. **Проверка простоты числа (is_prime)**:
   - `is_prime/1` проверяет, является ли число простым, с помощью делимости на числа до округленного квадратного корня `n`.

2. **Генерация последовательности с помощью `map` (generate_sequence_with_map)**:
   - Функция применяет формулу `n^2 + a*n + b` к значениям `n` с помощью `Enum.map`, создавая последовательность для заданных коэффициентов `a` и `b`.

3. **Подсчёт последовательных простых чисел (count_consecutive_primes)**:
   - `count_consecutive_primes/1` фильтрует только начальные простые значения последовательности с `Enum.take_while` и считает их количество.

4. **Поиск наилучших коэффициентов с использованием `for` (find_best_coefficients)**:
   - С помощью специального синтаксиса `for` создаются все комбинации `(a, b)` в диапазонах `-999..999` и `-1000..1000`.
   - `Enum.reduce` обрабатывает пары `(a, b)`, считает длину последовательности и обновляет лучшие коэффициенты, если найдена более длинная последовательность.

5. **Завершение**:
   - Возвращается произведение коэффициентов `best_a * best_b`, которые генерируют максимальную последовательность простых чисел.

- **Использование map и for**: `map` применяется для генерации значений, а `for` создаёт список коэффициентов, что удовлетворяет требованиям использования отображения и специального синтаксиса циклов.

#### 6.реализация на традиционном языке программирования python

```python
import math
from itertools import count

# Проверка простоты числа
def is_prime(n):
    if n <= 1:
        return False
    for i in range(2, int(math.sqrt(n)) + 1):
        if n % i == 0:
            return False
    return True

# Генерация последовательности значений для заданных a и b
def generate_sequence(a, b):
    return (n * n + a * n + b for n in count(0))  # Generator for infinite sequence

# Подсчёт последовательных простых чисел в последовательности
def count_consecutive_primes(sequence):
    count = 0
    for value in sequence:
        if is_prime(value):
            count += 1
        else:
            break
    return count

# Поиск наилучших коэффициентов
def find_best_coefficients():
    max_count = 0
    best_a, best_b = 0, 0

    for a in range(-999, 1000):
        for b in range(-1000, 1001):
            sequence = generate_sequence(a, b)
            prime_count = count_consecutive_primes(sequence)

            if prime_count > max_count:
                max_count = prime_count
                best_a, best_b = a, b

    return best_a * best_b
    
if __name__ == '__main__':
    print(find_best_coefficients())
```
**Механизм работы:**

- Python-реализация следует схожему подходу с разделением функций для генерации последовательности, фильтрации простых чисел и поиска лучших коэффициентов.

1. **Проверка простоты числа (is_prime)**:
   - `is_prime(n)` проверяет, является ли число простым, путём деления на числа от 2 до квадратного корня `n`.

2. **Генерация последовательности (generate_sequence)**:
   - `generate_sequence(a, b)` создаёт генератор, который использует формулу `n^2 + a*n + b` для значений `n`, начиная с 0.
   - Бесконечный генератор создаётся с `itertools.count`.

3. **Подсчёт последовательных простых чисел (count_consecutive_primes)**:
   - `count_consecutive_primes(sequence)` проходит по последовательности и считает начальные простые числа до первого непростого числа.

4. **Поиск лучших коэффициентов (find_best_coefficients)**:
   - `find_best_coefficients()` перебирает все пары `(a, b)` в диапазоне и находит наилучшие коэффициенты, генерирующие самую длинную последовательность простых чисел.

5. **Завершение**:
   - Возвращается произведение `best_a * best_b`, соответствующее максимальной последовательности простых чисел.

### Сравнение подходов Elixir и Python:

- **Рекурсия и генерация**: Elixir легко поддерживает рекурсию и ленивые потоки (`Stream`), в то время как Python использует генераторы для ленивой генерации, но без оптимизации хвостовой рекурсии.
  
- **Обработка потоков**: Elixir использует `Stream` для обработки данных, экономя память, Python — генераторы, которые менее оптимизированы для больших объёмов данных.


### Выводы

В лабораторной работе использовались различные приёмы функционального программирования, которые позволили оценить их эффективность и выразительность на примере задач проекта Эйлера.

1. **Хвостовая рекурсия**: Этот метод в Elixir обеспечил высокую эффективность и минимальное использование стека, что особенно важно для задач с большими объёмами вычислений, таких как поиск палиндромов.

2. **Обычная рекурсия**: Рекурсия без оптимизации хвостовых вызовов накапливает стек, что ограничивает её использование в задачах с длинными цепочками вызовов.

3. **Модульность с `reduce` и `filter`**: Использование функций `Enum.reduce` и `Enum.filter` позволило разделить задачи на логические модули, улучшив читаемость и поддержку кода, особенно при работе с длинными последовательностями данных.

4. **Ленивая обработка данных с `Stream`**: Потоки позволили работать с большими последовательностями, генерируя данные "по запросу" и экономя ресурсы.

5. **Отображение (`map`) для генерации данных**: `Enum.map` помог лаконично создавать и преобразовывать данные, что сделало код компактным и выразительным.

6. **Специальный синтаксис для циклов**: Использование `for` упростило работу с комбинациями значений, улучшив читаемость и логичность кода, особенно при создании пар чисел для анализа.

7. **Сравнение с Python**: Python показал себя как гибкий язык, однако его подходы менее выразительны по сравнению с Elixir и требуют дополнительных усилий для реализации ленивых и рекурсивных вычислений.

### Заключение

Лабораторная работа продемонстрировала мощь функционального программирования в Elixir. Хвостовая рекурсия, ленивая обработка и модульность позволили создать оптимизированный и легко поддерживаемый код, раскрывая преимущества функционального подхода.


- **Читаемость и стиль**: Python знаком более широкой аудитории, а Elixir требует понимания функциональной парадигмы, но является более подходящим для задач с потоками и рекурсией.

В целом, Elixir более оптимален для потоковой функциональной обработки, а Python остаётся универсальным для различных стилей программирования.
---
