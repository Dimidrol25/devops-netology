### Домашнее задание к занятию "7.5. Основы golang"

## Задача 1.

```
dimidrol@netology:~$ wget https://go.dev/dl/go1.19.1.linux-amd64.tar.gz  
dimidrol@netology:~$ sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf ~/go1.19.1.linux-amd64.tar.gz
dimidrol@netology:~$ export PATH=$PATH:/usr/local/go/bin
dimidrol@netology:~$ go version
go version go1.19.1 linux/amd64
```

## Задача 2.  

1. Напишите программу для перевода метров в футы.  
```
package main

import "fmt"

func main() {
    fmt.Print("Введите количество метров: ")
    var input float64
    fmt.Scanf("%f", &input)

    output := input * 3.28084

    fmt.Println(output, "футов")
}

```

```
dimidrol@netology:~/GO$ go run program1.go
Введите количество метров: 10
32.8084 футов
```

2. Напишите программу, которая найдет наименьший элемент в любом заданном списке:
```
package main

import "fmt"

func main() {
        x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17}
        current := 0
        fmt.Println ("Список значений : ", x)
        for i, value := range x {
                if (i == 0) {
                        current = value
                } else {
                    if (value < current){
                        current = value
                        }
                }
        }
        fmt.Println("Минимальное число : ", current)
}
```

```
dimidrol@netology:~/GO$ go run program1.go
Список значений :  [48 96 86 68 57 82 63 70 37 34 83 27 19 97 9 17]
Минимальное число :  9
```

3. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3.
```
package main
        import "fmt"

        func main() {
                for i := 1; i <= 100; i++ {
                        if (i%3) == 0 {
                                fmt.Print(i, " ")
                        }
                }
        fmt.Print("\n")
        }
```

```
dimidrol@netology:~/GO$ go run program4.go
3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60 63 66 69 72 75 78 81 84 87 90 93 96 99
```
