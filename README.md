
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


---
