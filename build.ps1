function Exec
{
    [CmdletBinding()] param(
        [Parameter(Position=0,Mandatory=1)][scriptblock]$cmd,
        [Parameter(Position=1,Mandatory=0)][string]$errorMessage = ($msgs.error_bad_command -f $cmd)
    )
    & $cmd
    if ($lastexitcode -ne 0) {
        throw ("Exec: " + $errorMessage)
    }
}

if(Test-Path .\artifacts) { Remove-Item .\artifacts -Force -Recurse }

exec { & dotnet restore }

exec { & dotnet build .\src\OdeToCode.UseNodeModules -c Release }

pushd .\test\OdeToCode.UseNodeModules.Tests\
exec { & dotnet test -c Release }
popd

exec { & dotnet pack .\src\OdeToCode.UseNodeModules -c Release -o .\artifacts }
