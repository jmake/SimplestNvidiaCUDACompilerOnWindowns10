
function SETUP_CUDART 
{
      echo "SETUP_CUDART ..."
      
      $url="https://developer.download.nvidia.com/compute/cuda/redist/cuda_cudart/windows-x86_64/cuda_cudart-windows-x86_64-11.5.50-archive.zip"
      $output="cudart.zip"
      Invoke-WebRequest -Uri $url -OutFile $output
      Expand-Archive $output
      cd cudart\cuda_cudart-windows-x86_64-11.5.50-archive
      ls 
      
      [Environment]::SetEnvironmentVariable("CUDART_PATH","${PWD}")
      cd ${HOME}
}


function SETUP_NVCC
{ 
      echo "SETUP_NVCC ..."
      
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
      cd ${HOME}
}

function CL_SETUP
{
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


$RELEASE=11.5.50
SETUP_CUDART
SETUP_NVCC
CL_SETUP

New-Item -ItemType Directory BUILD
Set-Location BUILD


$env:CUDART_PATH
$env:NVCC
&$env:NVCC --version 

