class ApiException(Exception):
    """سرور پاسخ داد اما نتیجه (result) درخواست False بود (اعتبار ناکافی، پارامتر نامعتبر و ...)."""
    pass


class HttpException(Exception):
    """اصلاً امکان برقراری ارتباط با سرور پرشیا فاوا وجود نداشت (قطعی شبکه، تایم‌اوت و ...)."""
    pass
