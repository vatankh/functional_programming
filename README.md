
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


#### 3. Модульная реализация с использованием reduce и filter

```elixir
defmodule Palindrome do
  def largest_palindrome_product do
    for a <- 100..999, b <- 100..999, into: [] do
      a * b
    end
    |> Enum.filter(&palindrome?/1)
    |> Enum.max()
  end

  defp palindrome?(n) do
    str = Integer.to_string(n)
    str == String.reverse(str)
  end
end
```

**Механизм работы:**
- Генерируется список всех произведений для чисел `a` и `b` от 100 до 999.
- Сначала создается список всех произведений с помощью `for`, который является встроенным средством для генерации последовательностей.
- Далее с помощью `Enum.filter` отфильтровываются только палиндромные числа.
- `Enum.max` находит наибольший элемент среди отфильтрованных палиндромов.
- Такая реализация легко читается, поскольку этапы генерации, фильтрации и нахождения максимума разделены, но требует значительного объема памяти для хранения всех произведений.


#### 4. Использование отображения (map) для генерации последовательности

```elixir
defmodule Palindrome do
  def largest_palindrome_product do
    Enum.map(100..999, fn a ->
      Enum.map(100..999, fn b -> a * b end)
    end)
    |> List.flatten()
    |> Enum.filter(&palindrome?/1)
    |> Enum.max()
  end

  defp palindrome?(n) do
    str = Integer.to_string(n)
    str == String.reverse(str)
  end
end
```

**Механизм работы:**
- Используется `Enum.map` для создания списка всех произведений чисел от 100 до 999.
- Каждый результат `Enum.map` для `b` вложен в ещё один `Enum.map` по `a`, после чего результат объединяется в один список с помощью `List.flatten`.
- Как и в предыдущей реализации, отфильтровываются только палиндромы, после чего выбирается наибольший.
- Эта реализация наглядно показывает работу `map` для построения сложной последовательности, но менее оптимальна из-за создания вложенных списков.

---
