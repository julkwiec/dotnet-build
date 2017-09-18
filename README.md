# What is this?
This is a very opinionated base .NET Core build image. It's based on `microsoft/dotnet:2-sdk-jessie` and includes the following features:
* Mono (incl. F# support)
* Powershell Core
* Preloaded Paket cache (netcoreapp 2.0 + asp.net core)

# Why should I use this image?
This image is intended to be used with Docker multi-stage builds as a build container.
Thanks to Mono and Powershell you can use most scripts and tools that you could use on Windows machine like FAKE or Paket.

The Paket cache is populated with basic .NET Core framework libraries - see the [paket.dependencies](paket.dependencies) file.
