package main

import (
	"fmt"
)

type Vector2D struct {
	X, Y float64
}

func (v Vector2D) Add(u Vector2D ) Vector2D {
	return Vector2D{v.X + u.X, v.Y + u.Y}
}

func (v Vector2D) Dot(u Vector2D) float64 {
	return v.X*u.X + v.Y*u.Y
}

func (v Vector2D) Normal() Vector2D {
	return Vector2D{-v.Y, v.X}
}

func main() {
    fmt.Println("Hello, world")
    p := Vector2D{
        X:2,
        Y:3,
    }
 
    q := Vector2D{
        X:4,
        Y:4,
    }
    
    var w Vector2D
    w = p.Add(q)
    p.
    
    fmt.Printf("Result: %f, %f\n", w.X, w.Y)
}