
function CUDART_SETUP 
{
      echo "CUDART_SETUP ..."
      
      $url="https://developer.download.nvidia.com/compute/cuda/redist/cuda_cudart/windows-x86_64/cuda_cudart-windows-x86_64-11.5.50-archive.zip"
      $output="cudart.zip"
      Invoke-WebRequest -Uri $url -OutFile $output
      Expand-Archive $output
      cd cudart\cuda_cudart-windows-x86_64-11.5.50-archive
      ls 
      
      [Environment]::SetEnvironmentVariable("CUDART_PATH","${PWD}")
      cd ..
      cd .. 
}


function NVCC_SETUP
{ 
      echo "NVCC_SETUP ..."
      
      $url="https://developer.download.nvidia.com/compute/cuda/redist/cuda_nvcc/windows-x86_64/cuda_nvcc-windows-x86_64-11.5.50-archive.zip"
      $output="nvcc.zip"
      Invoke-WebRequest -Uri $url -OutFile $output
      Expand-Archive $output
      cd nvcc
      cd cuda_nvcc-windows-x86_64-11.5.50-archive
      cd bin
      .\nvcc.exe --version 
      
      [Environment]::SetEnvironmentVariable("NVCC_PATH","${PWD}")
      [Environment]::SetEnvironmentVariable("NVCC","${PWD}\nvcc.exe")
      cd ..
      cd .. 
      cd ..
}

function CL_SETUP
{
  echo "CL_SETUP ..."
   
  $VSWHERE="C:\ProgramData\Chocolatey\bin\vswhere.exe"

  $VSTOOLS = &($VSWHERE) -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
  Write-Output "[VSTOOLS]:'$VSTOOLS' "

  if($VSTOOLS) 
  {
    $VSTOOLS = join-path $VSTOOLS 'Common7\Tools\vsdevcmd.bat'
    if (test-path $VSTOOLS) 
    {
      cmd /s /c """$VSTOOLS"" $args && set" | where { $_ -match '(\w+)=(.*)' } | 
      foreach{$null = new-item -force -path "Env:\$($Matches[1])" -value $Matches[2] }
    }
  }
  
  cl.exe 
}

## 1. SETUP ...
$RELEASE=11.5.50
CUDART_SETUP
NVCC_SETUP
CL_SETUP

New-Item -ItemType Directory BUILD
Set-Location BUILD

$env:CUDART_PATH
$env:NVCC
&$env:NVCC --version 

## 2. COMPILATION
## 2.A. SIMPLEST  
&$env:NVCC -o smallest.exe ../smallest.cu -I"$env:CUDART_PATH/include" -L"$env:CUDART_PATH/lib"
.\smallest.exe
rm smallest.exe 


cmake.exe --version 

