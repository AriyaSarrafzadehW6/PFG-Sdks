package main

import (
	"fmt"

	"github.com/persiafava/persiafava-go/persiafava"
)

func main() {
	// روش اول: نام کاربری و رمز عبور
	client := persiafava.NewClient("USERNAME", "PASSWORD")

	// روش دوم (پیشنهادی): فقط با API Key از پنل
	// client := persiafava.NewClientWithApiKey("YOUR_API_KEY")

	result, err := client.Send("09123456789", "3000569999", "سلام! این یک پیام آزمایشی از SDK پرشیا فاواست.", "", "", "")
	if err != nil {
		fmt.Println("خطا:", err)
		return
	}
	fmt.Println(result)
}
