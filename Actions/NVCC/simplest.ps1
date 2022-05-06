
function CUDART_SETUP 
{
      echo "CUDART_SETUP ..."
      
      $url="https://developer.download.nvidia.com/compute/cuda/redist/cuda_cudart/windows-x86_64/cuda_cudart-windows-x86_64-11.5.50-archive.zip"
      $output="cudart.zip"
      Invoke-WebRequest -Uri $url -OutFile $output
      Expand-Archive $output
      cd cudart\cuda_cudart-windows-x86_64-11.5.50-archive
      ls 
      
      [Environment]::SetEnvironmentVariable("CUDA_PATH","${PWD}")
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
      
      [Environment]::SetEnvironmentVariable("CUDACXX_PATH","${PWD}")
      [Environment]::SetEnvironmentVariable("CUDACXX","${PWD}\nvcc.exe")
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
      cmd /s /c " ""$VSTOOLS""  -arch=x64 -host_arch=x64 $args && set" | where { $_ -match '(\w+)=(.*)' } | 
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

cmake.exe --version 
ninja.exe --version 


New-Item -ItemType Directory BUILD
Set-Location BUILD

$env:CUDA_PATH
$env:CUDACXX
&$env:CUDACXX --version 

## 2. COMPILATION
## 2.A. SIMPLEST  
&$env:CUDACXX -o simplest.exe ../simplest.cu -I"$env:CUDA_PATH/include" -L"$env:CUDA_PATH/lib"
.\simplest.exe
rm simplest.exe 


## 2.C. FANCIEST (https://www.collinsdictionary.com/dictionary/english/fanciest) 
cmake.exe .. -G Ninja -DCMAKE_CUDA_ARCHITECTURES="native"

#ninja.exe
#ctest.exe


