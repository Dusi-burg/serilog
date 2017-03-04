#!/bin/bash
export DOTNET_INSTALL_DIR="$PWD/.dotnetcli"
DotnetCliVersion=${CLI_VERSION:="1.0.0-rc4-004771"}
install_script_url=https://raw.githubusercontent.com/dotnet/cli/rel/1.0.0/scripts/obtain/dotnet-install.sh
curl -sSL $install_script_url | bash /dev/stdin --version "$DotnetCliVersion" --install-dir "$DOTNET_INSTALL_DIR"
export PATH="$DOTNET_INSTALL_DIR:$PATH"

dotnet --info
dotnet restore

for path in src/**/*.csproj; do
    dotnet build -c Release ${path}
done

for path in test/**/*.csproj; do
    dotnet build -f netcoreapp1.0 -c Release ${path}
    dotnet test -f netcoreapp1.0  -c Release ${path}
done

for path in test/Serilog.PerformanceTests/Serilog.PerformanceTests.csproj; do
    dotnet build -f netcoreapp1.0 -c Release ${path}
done
