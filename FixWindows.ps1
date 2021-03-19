    Add-Type -AssemblyName PresentationCore, PresentationFramework

$Xaml = @"
    <Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" Width="275" Height="402.918" Name="FixWindows">
    <Grid>
        <Button Content="CHKDSK" HorizontalAlignment="Left" Margin="10,42,0,0" VerticalAlignment="Top" Width="75" Name="Bchkdsk"/>
        <Button Content="SFC" HorizontalAlignment="Left" Margin="93,42,0,0" VerticalAlignment="Top" Width="75" Name="Bsfc"/>
        <Button Content="DISM FIX" HorizontalAlignment="Left" Margin="176,284,0,0" VerticalAlignment="Top" Width="75" Name="Bdism"/>
        <Button Content="DNS" HorizontalAlignment="Left" Margin="10,96,0,0" VerticalAlignment="Top" Width="75" Name="Bdns"/>
        <Button Content="DHCP" HorizontalAlignment="Left" Margin="93,96,0,0" VerticalAlignment="Top" Width="75" Name="Bdhcp"/>
        <Button Content="NetSock" HorizontalAlignment="Left" Margin="176,96,0,0" VerticalAlignment="Top" Width="75" Name="Bnetsock"/>
        <Button Content="Crystal Disk" HorizontalAlignment="Left" Margin="176,42,0,0" VerticalAlignment="Top" Width="75" Name="Bcrystal"/>
        <Button Content="MemTest" HorizontalAlignment="Left" Margin="93,149,0,0" VerticalAlignment="Top" Width="75" Name="Bmemtest"/>
        <Button Content="Update" HorizontalAlignment="Left" Margin="176,149,0,0" VerticalAlignment="Top" Width="75" Name="Bupdate"/>
        <Label Content="Version de windows" HorizontalAlignment="Left" Margin="10,253,0,0" VerticalAlignment="Top"/>
        <Button Content="Office" HorizontalAlignment="Left" Margin="10,149,0,0" VerticalAlignment="Top" Width="75" Name="Boffice"/>
        <ComboBox HorizontalAlignment="Left" Margin="10,284,0,0" VerticalAlignment="Top" Width="120" Name="CBversion"/>
        <Button Content="DISM CHECK" HorizontalAlignment="Left" Margin="51,215,0,0" VerticalAlignment="Top" Width="75" Name="Bdismcheck"/>
        <Button Content="DISM REST" HorizontalAlignment="Left" Margin="135,215,0,0" VerticalAlignment="Top" Width="75" Name="Bdismrest"/>
    </Grid>
</Window>
"@


#-------------------------------------------------------------#
#----Control Event Handlers-----------------------------------#
#-------------------------------------------------------------#

function Fchkdsk(){
Repair-Volume -DriveLetter C -Scan
}

function Fsfc(){
Start-Process powershell {sfc /scannow;pause}
}

function Fdism(){
$WimSource=$CBversion.SelectedItem
Start-Process powershell {DISM /Online /Cleanup-Image /RestoreHealth /Source:$WimSource.wim;pause}}

function Fdns(){
Start-Process powershell {ipconfig /flushdns;pause}}

function Fdhcp(){
start-Process powershell {ipconfig /release;
ipconfig /renew;pause}}

function Fnetsock(){
start-Process powershell {netsh winsock reset;
netsh int ip reset;pause}}

function Fcrystal(){
if ([Environment]::Is64BitOperatingSystem -eq $True){start DiskInfo64.exe}
else {start DiskInfo32.exe}
}

function Fmemtest(){
start mdsched}

function Fupdate(){
start ResetWU.bat}

function Fdismcheck(){
start-Process powershell {DISM /Online /Cleanup-Image /CheckHealth;pause}}

function Fdismrest(){
start-Process powershell {Dism /Online /Cleanup-Image /RestoreHealth;pause}}

function Fdebug(){
$WimSource=$CBversion.SelectedItem
Write-Host $WimSource}

function Foffice(){
start SetupProd_OffScrub.exe}




#-------------------------------------------------------------#
#----Script Execution-----------------------------------------#
#-------------------------------------------------------------#



$Window = [Windows.Markup.XamlReader]::Parse($Xaml)

[xml]$xml = $Xaml

$xml.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name $_.Name -Value $Window.FindName($_.Name) }

$Bchkdsk.Add_Click({Fchkdsk $this $_})
$Bsfc.Add_Click({Fsfc $this $_})
$Bdism.Add_Click({Fdism $this $_})
$Bdns.Add_Click({Fdns $this $_})
$Bdhcp.Add_Click({Fdhcp $this $_})
$Bnetsock.Add_Click({Fnetsock $this $_})
$Bcrystal.Add_Click({Fcrystal $this $_})
$Bmemtest.Add_Click({Fmemtest $this $_})
$Bupdate.Add_Click({Fupdate $this $_})
$Bdismcheck.Add_Click({Fdismcheck $this $_})
$Bdismrest.Add_Click({Fdismrest $this $_})
$Boffice.add_Click({Foffice $this $_})
[void]$CBversion.Items.add("1903")
[void]$CBversion.Items.add("1909")
[void]$CBversion.Items.add("2004")
[void]$CBversion.Items.add("20h2")

[Void]$Window.ShowDialog()