# PersiaFava SMS SDKs

Official SDKs for the PersiaFava SMS REST API.

This repository includes client libraries for multiple languages so you can send messages, check delivery status, manage contacts, work with labels and keywords, and use other parts of the PersiaFava SMS platform without dealing with raw HTTP requests yourself.

## Available SDKs

| Directory | Language | Install |
| --- | --- | --- |
| `persiafava-php/` | PHP 7.2+ | `composer require persiafava/sms-sdk` |
| `persiafava-node/` | Node.js | `npm install persiafava-sms-sdk` |
| `persiafava-python/` | Python 3.6+ | `pip install persiafava-sms-sdk` |
| `persiafava-dotnet/` | C# / .NET 6+ | `dotnet add package PersiaFava.Sms.Sdk` |
| `persiafava-java/` | Java 11+ | Maven package |
| `persiafava-go/` | Go 1.20+ | `go get github.com/persiafava/persiafava-go` |
| `persiafava-ruby/` | Ruby 2.6+ | `gem install persiafava-sms-sdk` |

## Features

All SDKs are built around the same core API capabilities, including:

- Sending SMS
- Checking delivery status
- Reading inbound messages
- Fetching account information
- Managing contact groups and contacts
- Working with labels and keywords
- Creating one-time login links

## Authentication

The clients support two authentication styles:

1. Username and password
2. API key

API key authentication is recommended for most projects.

## Error Handling

The SDKs follow a similar error model across languages:

- `ApiException`: the request reached the API, but the API returned an error
- `HttpException` / `HttpRequestException`: the request could not be completed because of a network or transport issue

Exact class names may vary slightly depending on the language.

## Getting Started

Each SDK directory includes its own README and example files with language-specific usage.

Typical setup looks like this:

1. Install the package for your language
2. Create a client with your credentials or API key
3. Call the method you need
4. Handle API and HTTP errors as needed

## Repository Layout

- `persiafava-php/` — PHP package
- `persiafava-node/` — Node.js package
- `persiafava-python/` — Python package
- `persiafava-dotnet/` — .NET package
- `persiafava-java/` — Java package
- `persiafava-go/` — Go package
- `persiafava-ruby/` — Ruby package

## License

Ariya.Sarrafzadeh — © PersiaFava
