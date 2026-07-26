from setuptools import setup, find_packages

setup(
    name='persiafava-sms-sdk',
    version='1.0.0',
    description="کلاینت رسمی Python برای وب‌سرویس پیامک پرشیا فاوا (REST API)",
    packages=find_packages(),
    install_requires=['requests>=2.20.0'],
    python_requires='>=3.6',
    license='MIT',
    url='https://sms.persiafava.com',
)
