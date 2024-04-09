#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["NitroBoostMatchmakingService.Web/NitroBoostMatchmakingService.Web.csproj", "NitroBoostMatchmakingService.Web/"]
COPY ["NitroBoostMatchmakingService.Core/NitroBoostMatchmakingService.Core.csproj", "NitroBoostMatchmakingService.Core/"]
COPY ["NitroBoostMatchmakingService.Data/NitroBoostMatchmakingService.Data.csproj", "NitroBoostMatchmakingService.Data/"]
COPY ["NitroBoostMatchmakingService.Shared/NitroBoostMatchmakingService.Shared.csproj", "NitroBoostMatchmakingService.Shared/"]
RUN dotnet restore "NitroBoostMatchmakingService.Web/NitroBoostMatchmakingService.Web.csproj"
COPY . .
WORKDIR "/src/NitroBoostMatchmakingService.Web"
RUN dotnet build "NitroBoostMatchmakingService.Web.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "NitroBoostMatchmakingService.Web.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "NitroBoostMatchmakingService.Web.dll"]