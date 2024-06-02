FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["Webinar.App/Webinar.App.csproj", "Webinar.App/"]
RUN dotnet restore "Webinar.App/Webinar.App.csproj"
COPY . .
WORKDIR "/src/Webinar.App"
RUN dotnet build "Webinar.App.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Webinar.App.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Webinar.App.dll"]
