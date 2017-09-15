FROM microsoft/dotnet:2-sdk-jessie

SHELL ["/bin/bash", "-c"]

ENV ASPNETCORE_PKG_VERSION 2.0.0
ENV MONO_VERSION 5.2.0.215

# Install Powershell, NuGet and Mono with F# support
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && apt-get update \
    && apt-get install -y --no-install-recommends apt-utils apt-transport-https \
    && echo "deb http://download.mono-project.com/repo/debian jessie/snapshots/$MONO_VERSION main" > /etc/apt/sources.list.d/mono-official.list \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/14.04/prod.list | tee /etc/apt/sources.list.d/microsoft.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates mono-complete ca-certificates-mono fsharp mono-vbnc nuget referenceassemblies-pcl powershell \
    && rm -rf /var/lib/apt/lists/*

# Preload NuGet cache
COPY Warmup.csproj /tmp/warmup/
RUN dotnet restore /tmp/warmup/Warmup.csproj --source https://api.nuget.org/v3/index.json \
    && rm -rf /tmp/warmup/
