package main

import (
	"fmt"

	"github.com/persiafava/persiafava-go/persiafava"
)

func main() {
	// روش اول: نام کاربری و رمز عبور
	client := persiafava.NewClientWithApiKey("YOUR_API_KEY")

	result, err := client.SendSMS([]string{"09123456789"}, "3000569999", "سلام! این یک پیام آزمایشی از SDK پرشیا فاواست.")
	if err != nil {
		fmt.Println("خطا:", err)
		return
	}
	fmt.Println(result)
}
