
$var1=@(Read-Host "Enter the nested object")

$var2=Read-Host "Type key"

$var3= $var1 -split'}|{|:'
$key= $var2 -split'/'

$var4=@($var3[1,3,5,6])

for ( $i=0; $i -le ($var4.Length -1); $i +=1 )
{
for ( $j=0; $j -le ($key.Length -1); $j +=1 )
{
if ($var4[$i] -ne $key[$j])
{echo $var4[$i]}
}
}
