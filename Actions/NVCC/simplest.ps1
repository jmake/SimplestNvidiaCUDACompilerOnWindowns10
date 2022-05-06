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


function SETUP_CUDART
{ 
  wget "https://developer.download.nvidia.com/compute/cuda/redist/cuda_cudart/linux-x86_64/cuda_cudart-linux-x86_64-${RELEASE}-archive.tar.xz"

  rm cuda_cudart-linux-x86_64-${RELEASE}-archive
  tar -xf cuda_cudart-linux-x86_64-${RELEASE}-archive.tar.xz
}


New-Item -ItemType Directory BUILD
Set-Location BUILD

wget https://developer.download.nvidia.com/compute/cuda/redist/cuda_nvcc/linux-x86_64/cuda_nvcc-linux-x86_64-1.5.50-archive.tar.xz

$RELEASE=11.5.50
$WGET="https://developer.download.nvidia.com/compute/cuda/redist/cuda_nvcc/linux-x86_64/cuda_nvcc-linux-x86_64-${RELEASE}-archive.tar.xz"
echo "https://developer.download.nvidia.com/compute/cuda/redist/cuda_cudart/linux-x86_64/cuda_cudart-linux-x86_64-$RELEASE-archive.tar.xz"
echo $WGET 
wget $WGET 

SETUP_CUDART



