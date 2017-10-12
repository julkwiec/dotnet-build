# Supported Linux amd64 tags
- [`jessie-mono-stable` (*Dockerfile*)](https://github.com/julkwiec/dotnet-mono-powershell-build/blob/master/jessie/mono-stable/Dockerfile)
- [`jessie-mono-beta` (*Dockerfile*)](https://github.com/julkwiec/dotnet-mono-powershell-build/blob/master/jessie/mono-beta/Dockerfile)
- [`jessie-mono-alpha` (*Dockerfile*)](https://github.com/julkwiec/dotnet-mono-powershell-build/blob/master/jessie/mono-alpha/Dockerfile)
- [`stretch-mono-stable` (*Dockerfile*)](https://github.com/julkwiec/dotnet-mono-powershell-build/blob/master/stretch/mono-stable/Dockerfile)
- [`stretch-mono-beta` (*Dockerfile*)](https://github.com/julkwiec/dotnet-mono-powershell-build/blob/master/stretch/mono-beta/Dockerfile)
- [`stretch-mono-alpha` (*Dockerfile*)](https://github.com/julkwiec/dotnet-mono-powershell-build/blob/master/stretch/mono-alpha/Dockerfile)

# What is this?
This is a very opinionated base .NET Core build image. It's based on `microsoft/dotnet` and includes the following features:
- Mono (incl. F# support)
- Powershell Core
- Preloaded NuGet & Paket cache (netcoreapp 2.0 + asp.net core)

# Why should I use this image?
This image is intended to be used with Docker multi-stage builds as a build container.
Thanks to Mono and Powershell you can use most scripts and tools that you could use on Windows machine like [FAKE](https://github.com/fsharp/FAKE) or [Paket](https://github.com/fsprojects/Paket).

The NuGet cache is populated with basic .NET Core framework libraries - see the [paket.dependencies](https://github.com/julkwiec/dotnet-mono-powershell-build/blob/master/paket.dependencies) file.
