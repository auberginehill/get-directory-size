<#
Get-DirectorySize.ps1
#>


# The -Paths parameter (i.e. $Paths on line 15) with an alias called "-Path" is defined as a string and inserting an extra [] tells PowerShell that multiple values may follow, usually separated by commas.


[CmdletBinding()]
Param (
    [Parameter(ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true,
      HelpMessage='Which folder, directory or path would you like to target? Please enter a valid file system path to a directory (a full path name of a directory (a.k.a. a folder) i.e. folder path such as C:\Windows). If the path name includes space characters, please add quotation marks around the path name. The -Path parameter accepts a collection of path names (separated by comma) and also takes an array of strings for paths to query.')]
    [Alias("Path")]
	[string[]]$Paths = "$env:temp",
	[string]$ReportPath = "$env:temp",
    [string]$Sort = "Size",
    [switch]$Descending,
    [switch]$Recurse
)




Begin {


    # Establish some common variables
    $computer = $env:COMPUTERNAME
    $start_time = Get-Date
    $number_of_paths = $Paths.Count
    $descending_switch = @{Descending = $Descending}
    $recurse_switch = @{Recurse = $Recurse}
    $empty_line = ""
    $result_list = @()
    [System.Collections.ArrayList]$results = $result_list
    $titles = @()
    $skipped = @()
    $skipped_path_names = @()
    [int[]]$steps = @()
    [int[]]$loop = @()


    # Reset the counters (important!)
    $total_size = 0
    $number_of_directories = 0
    $x = 0
    $num_invalid_paths = 0


    # Extra parameters for $Sort which could be used after ValidateSetAttribute               # Credit: Martin Pugh: "Get-FolderSizes"
    Switch ($Sort)  {
        "size"      { $Sort = "raw_size";Break }
        "average"   { $Sort = "Average File Size (B)";Break }
        "written"   { $Sort = "Written Ago (h)";Break }
        "age"       { $Sort = "Age (Days)";Break }
        "read"      { $Sort = "Read ago (h)";Break }
        "created"   { $Sort = "Created on";Break }
        "changed"   { $Sort = "Last Updated";Break }
        "updated"   { $Sort = "Last Updated";Break }
        "last"      { $Sort = "Last Updated";Break }
    } # switch


    # A function to add folder properties
    Function Add-FolderObject {
    	Param (
    		$subdirectory
    	)


        # Some owner queries may fail, so excluding those errors
        $owner = Try {

                    (Get-Acl $subdirectory.FullName -ErrorAction SilentlyContinue).Owner

                } Catch {

                    # Fill in the Owner with a set value
                    "Not enough rights to query the Owner of the directory."

                } # Catch


        # The failure message "Measure-Object : Property "Length" cannot be found in any object(s) input" when querying folders with empty subfolders is suppressed with -ErrorAction SilentlyContinue...
        $size_bytes = (Get-ChildItem $subdirectory.FullName -Force -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
        $file_count = ( @(Get-ChildItem $subdirectory.FullName @recurse_switch -Force -ErrorAction SilentlyContinue | Where-Object { $_.PSIsContainer -eq $false})).Count
        $folder_count = ( @(Get-ChildItem $subdirectory.FullName @recurse_switch -Force -ErrorAction SilentlyContinue | Where-Object { $_.PSIsContainer -eq $true })).Count
        $write = (Convert-ElapsedTime((Get-Date) - ($subdirectory.LastWriteTime)))
        $read = (Convert-ElapsedTime((Get-Date) - ($subdirectory.LastAccessTime)))
        $average_file_size = If ($file_count -gt 0) { [Math]::Round((($size_bytes) / $file_count),0) } Else { $continue = $true}


            $obj_folder = New-Object PSObject -Property @{

                    'Age (Days)'                = (New-TimeSpan -Start $subdirectory.LastWriteTime).Days
                    'Attributes'                = $subdirectory.Attributes
                    'Average File Size'         = ConvertBytes($average_file_size)
                    'Average File Size (B)'     = $average_file_size
                    'BaseName'                  = $subdirectory.BaseName
                    'Created on'                = $subdirectory.CreationTime
                    'Creation Time'             = $subdirectory.CreationTime
                    'Creation Time (UTC)'       = $subdirectory.CreationTimeUtc
                    'Directory'                 = $subdirectory.FullName
                    'Exists'                    = $subdirectory.Exists
                    'Extension'                 = $subdirectory.Extension
                    'Files'                     = $file_count
                    'Subfolders'                = $folder_count
                    'Folder Name'               = $subdirectory.FullName
                    'Is ReadOnly'               = $subdirectory.IsReadOnly
                    'Last AccessTime'           = $subdirectory.LastAccessTime
                    'Last AccessTime (UTC)'     = $subdirectory.LastAccessTimeUtc
                    'Last Updated'              = $subdirectory.LastWriteTime
                    'Last WriteTime'            = $subdirectory.LastWriteTime
                    'Last WriteTime (UTC)'      = $subdirectory.LastWriteTimeUtc
                    'Name'                      = $subdirectory.Name
                    'Owner'                     = $owner
                    'Parent'                    = $subdirectory.Parent
                    'Read'                      = [string]$read + ' ago'
                    'Read ago (h)'              = [Math]::Round(((New-TimeSpan -Start $subdirectory.LastAccessTime).TotalHours), 0)
                    'PS Is Container'           = $subdirectory.PSIsContainer
                    'PSChildName'               = $subdirectory.PSChildName
                    'PSDrive'                   = $subdirectory.PSDrive
                    'PSParentPath'              = $subdirectory.PSParentPath
                    'PSPath'                    = $subdirectory.PSPath
                    'PSProvider'                = $subdirectory.PSProvider
                    'raw_size'                  = $size_bytes
                    'Root'                      = $subdirectory.Root
                    'Size'                      = ConvertBytes($size_bytes)
                    'VersionInfo'               = $subdirectory.VersionInfo
                    'Written'                   = [string]$write + ' ago'
                    'Written Ago (h)'           = [Math]::Round(((New-TimeSpan -Start $subdirectory.LastWriteTime).TotalHours), 0)

            } # New-Object


        Return $obj_folder

    } # function (Add-FolderObject)




    # Function used to convert bytes to MB or GB or TB                                            # Credit: clayman2: "Disk Space"
    function ConvertBytes {
        Param (
            $size
        )
        If ($size -eq $null) {
            [string]'0 KB'
        } ElseIf ($size -eq 0) {
            [string]'0 KB'
        } ElseIf ($size -lt 1MB) {
            $folder_size = $size / 1KB
            $folder_size = [Math]::Round($folder_size, 0)
            [string]$folder_size + ' KB'
        } ElseIf ($size -lt 1GB) {
            $folder_size = $size / 1MB
            $folder_size = [Math]::Round($folder_size, 1)
            [string]$folder_size + ' MB'
        } ElseIf ($size -lt 1TB) {
            $folder_size = $size / 1GB
            $folder_size = [Math]::Round($folder_size, 1)
            [string]$folder_size + ' GB'
        } Else {
            $folder_size = $size / 1TB
            $folder_size = [Math]::Round($folder_size, 1)
            [string]$folder_size + ' TB'
        } # else
    } # function (ConvertBytes)




    # Function used to convert numerical elapsed time values to text
    function Convert-ElapsedTime {
        Param (
            $elapsed
        )
        If ($elapsed.Days -ge 2) {
            $elapsed_result = [string]$elapsed.Days + ' days ' + $elapsed.Hours + ' h'
        } ElseIf ($elapsed.Days -gt 0) {
            $elapsed_result = [string]$elapsed.Days + ' day ' + $elapsed.Hours + ' h'
        } ElseIf ($elapsed.Hours -gt 0) {
            $elapsed_result = [string]$elapsed.Hours + ' h ' + $elapsed.Minutes + ' min'
        } ElseIf ($elapsed.Minutes -gt 0) {
            $elapsed_result = [string]$elapsed.Minutes + ' min ' + $elapsed.Seconds + ' sec'
        } ElseIf ($elapsed.Seconds -gt 0) {
            $elapsed_result = [string]$elapsed.Seconds + ' sec'
        } Else {
            $elapsed_result = [string]''
        } # else (if)

            If ($elapsed_result.Contains("0 h")) {
                $elapsed_result = $elapsed_result.Replace("0 h","")
                } If ($elapsed_result.Contains("0 min")) {
                    $elapsed_result = $elapsed_result.Replace("0 min","")
                    } If ($elapsed_result.Contains("0 sec")) {
                    $elapsed_result = $elapsed_result.Replace("0 sec","")
            } # if ($elapsed_result: first)

    Return $elapsed_result

    } # function (Convert-ElapsedTime)




    # A function for creating alternating rows in HTML documents                              # Credit: Martin Pugh: "Get-FolderSizes"
    Function Set-AlternatingRows {
        [CmdletBinding()]
        Param (
            [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
            [object[]]$lines,

            [Parameter(Mandatory=$true)]
            [string]$CSS_even_class,

            [Parameter(Mandatory=$true)]
            [string]$CSS_odd_class
        )
        Begin {
            $class_name = $CSS_even_class
        } # Begin

        Process {
            ForEach ($line in $lines) {

                $line = $line.Replace("<tr>","<tr class=""$class_name"">")

                If ($class_name -eq $CSS_even_class) {
                    $class_name = $CSS_odd_class
                } Else {
                    $class_name = $CSS_even_class
                } # Else

                Return $line

            } # ForEach
        } # Process

    } # function (Set-AlternatingRows)




    # Set the progress bar variables
    $path_activity      = "Retrieving Folder Properties on $computer"
    $path_id            = 1 # For using more than one progress bar

    $folder_activity    = " "
    $folder_status      = "Folders Found: $x"
    $folder_id          = 2 # For using more than one progress bar
    $folder_task        = "Currently Processing: Setting the initial search parameters..." # A description of the current operation, which is set at the beginning of each of the steps that increments the progress bar.


    # Start the progress bars
    Write-Progress -Id $path_id -Activity $path_activity -Status "Step $($steps.Count) of $($number_of_paths * 3)" -CurrentOperation $path -PercentComplete 0
    Write-Progress -Id $folder_id -Activity $folder_activity -Status $folder_status -CurrentOperation $folder_task -PercentComplete 0


    Write-Verbose "$(Get-Date -Format HH:mm:ss): The script begins..."


} # begin




Process {

    ForEach ($path in $Paths) {

    # Increment the loop counter
    $loop += 1

        # In the second loop and onwards
        If ($loop.Count -ge 2) {

            $y = $number_of_directories

            # Reset the lower progress bar
            $folder_status = "Folders Found: 0 (Total: $number_of_directories)"
            $folder_task = "Currently Processing: Initiating the loop number $($loop.Count)"
            Write-Progress -Id $folder_id -Activity $folder_activity -Status $folder_status -CurrentOperation $folder_task -PercentComplete 0

        } Else {
            $continue = $true
        }


    <#
     __
    /_ |
     | |
     | |
     | |
     |_|

    #>  # (Step 1): Test if the path exists

        # Increment the step counter and update the upper progress bar
        $steps += 1
        Write-Progress -Id $path_id -Activity $path_activity -Status "Step $($steps.Count) of $($number_of_paths * 3)" -CurrentOperation $path -PercentComplete -1


        If ((Test-Path $path) -eq $false) {

            $invalid_path_was_found = $true

            # Increment the error counter
            $num_invalid_paths++

            # Display an error message in console
            $empty_line | Out-String
            Write-Warning "'$path' doesn't seem to be a valid path name."
            $empty_line | Out-String
            Write-Verbose "Please consider checking that the path '$path' was typed correctly and that it is a valid file system path, which points to a directory. If the path contains space characters, please add quotation marks around the path name." -verbose
            $empty_line | Out-String
            Write-Verbose "Which folder, directory or path would you like to target? Please enter a valid file system path to a directory (a full path name of a directory a.k.a. a full path name of a folder (i.e. folder path such as C:\Windows)) after the -Path parameter. The -Path parameter accepts a collection of path names (separated by comma) and also takes an array of strings for paths to query."
            $empty_line | Out-String
            $skip_text_2 = "Skipping '$path' from the results."
            Write-Output $skip_text


                # Add the path as an object (with properties) to a collection of skipped paths
                $skipped += $obj_skipped = New-Object -TypeName PSCustomObject -Property @{

                            'Skipped Path Names'    = $path
                            'Owner'                 = ""
                            'Created on'            = ""
                            'Last Updated'          = ""
                            'Size'                  = "-"
                            'Error'                 = "The path was not found on $computer."
                            'raw_size'              = 0

                    } # New-Object


            # Add the path name to a list of failed path names
            $skipped_path_names += $path

            # Add the path name to title
            $titles += $path

            # Return to top of the program loop (ForEach $path) and skip just this iteration of the loop.
            Continue

        } Else {

            # Resolve path (if path is specified as relative)
            $path = Resolve-Path -Path $path

        } # else (if)




    <#
    ___
   |__ \
      ) |
     / /
    / /_
   |____|

    #>  # (Step 2): Get the properties of the path (user inputted starting directory root path)

        Write-Verbose "$(Get-Date -Format HH:mm:ss): Now working on $path..."

        # Increment the step counter and the counter of total number of directories and update the upper progress bar
        $steps += 1
        $number_of_directories++
        Write-Progress -Id $path_id -Activity $path_activity -Status "Step $($steps.Count) of $($number_of_paths * 3)" -CurrentOperation $path -PercentComplete -1

        # Update the lower progress bar
        $folder_status = "Folders Found: 0 (Total: $number_of_directories)"
        $folder_task = "Currently Processing: Working on $path, folder properties enumeration ongoing..."
        Write-Progress -Id $folder_id -Activity $folder_activity -Status $folder_status -CurrentOperation $folder_task -PercentComplete 0

        # Get the path (user inputted starting directory root path) as an item and define its properties
        $root = Get-Item -Path $path -Force
        $root_properties = Add-FolderObject $root

        # Add the size of the path (starting directory root path) to the total size
        $total_size += $root_properties.raw_size

        # Add the path properties (starting directory root path) to the final report
        $null = $results.Add($root_properties)

        # Add the path name to the title row
        $titles += $path




    <#
    ____
   |___ \
     __) |
    |__ <
    ___) |
   |____/

    #>  # (Step 3): Loop through all the subfolders and enumerate the sub-directories according to the recurse-preference parameter

        # Increment the step counter and update the upper progress bar
        $steps += 1
        Write-Progress -Id $path_id -Activity $path_activity -Status "Step $($steps.Count) of $($number_of_paths * 3)" -CurrentOperation $path -PercentComplete -1

        $subfolders = Get-ChildItem $path @recurse_switch -Force -ErrorAction SilentlyContinue | Where-Object { $_.PSIsContainer -eq $true }
        $subfolder_paths = $subfolders | Select-Object -ExpandProperty FullName

        # Find all subdirectories and enumerate the results
        ForEach ($folder in $subfolders) {


            # Increment the counters and update the lower progress bar
            $number_of_directories++
            $x++
            $folder_status = "Folders Found: $($x - $y + ($loop.Count) - 1) (Total: $number_of_directories)"
            $folder_task = "Currently Processing: $folder"
            Write-Progress -Id $folder_id -Activity $folder_activity -Status $folder_status -CurrentOperation $folder_task -PercentComplete (( ($x - $y + ($loop.Count) - 2) / $subfolder_paths.Count) * 100)

            # Add the subdirectory properties to the final report
            $folder_properties = Add-FolderObject $folder
            $null = $results.Add($folder_properties)


        } # ForEach subfolder

    } # ForEach path

} # Process




End {


    # Close the progress bars and try to avoid dividing with a zero when calculating the -PercentComplete
    $path_activity      = "Retrieving folder attributes on $computer"
    $folder_status      = "Folders Found: $x"
    $folder_task        = "Finished retrieving folders."
    Write-Progress -Id $path_id -Activity $path_activity -Status "Step $($steps.Count) of $($number_of_paths * 3)" -PercentComplete 100 -Completed
    Write-Progress -Id $folder_id -Activity $folder_activity -Status $folder_status -CurrentOperation $folder_task -PercentComplete 100 -Completed


    # Display a summary in console
    $total_size_in_text = ConvertBytes $total_size


                # Catch the Owner-anomalities and notify the user. This final round of enumeration (without another ForEach loop) should probably be done earlier for best results (speed).
                ForEach ($result in $results) {

                        If (($result | Select-Object -ExpandProperty Owner) -like ("*enough rights to query the Owner of*")) {

                                $invalid_path_was_found = $true
                                Write-Verbose "Didn't have enough rights to query the Owner of $result"

                                # Increment the error counter
                                $num_invalid_paths++


                                    # Add the path as an object (with properties) to a collection of skipped paths
                                    $skipped += $obj_skipped = New-Object -TypeName PSCustomObject -Property @{

                                                'Skipped Path Names'    = $result | Select-Object -ExpandProperty Directory
                                                'Owner'                 = ""
                                                'Created on'            = $result | Select-Object -ExpandProperty 'Created on'
                                                'Last Updated'          = $result | Select-Object -ExpandProperty 'Last Updated'
                                                'Size'                  = "-"
                                                'Error'                 = "Not enough rights to query the Owner of the directory."
                                                'raw_size'              = 0

                                        } # New-Object

                        } Else {
                            $continue = $true
                        } # else (if)

                } # foreach


        If (($invalid_path_was_found) -ne $true) {
            $enumeration_went_succesfully = $true
            $stats_text = "Total $number_of_directories folders ($total_size_in_text) processed at '$($titles -join ", ")'"
        } Else {
            $enumeration_went_succesfully = $false

            # Display the skipped path names in console
            $empty_line | Out-String
            $skipped.PSObject.TypeNames.Insert(0,"Skipped Path Names")
            $skipped_selection = $skipped | Select-Object 'Skipped Path Names','Size','Error' | Sort-Object 'Skipped Path Names'
            $skipped_selection | Format-Table -auto

            If ($num_invalid_paths -gt 1) {
                $stats_text = "Total $number_of_directories folders ($total_size_in_text) processed. There were $num_invalid_paths skipped path names."
            } Else {
                $stats_text = "Total $number_of_directories folders ($total_size_in_text) processed. One path name was skipped."
            } # else

        } # else

    $empty_line | Out-String
    Write-Output $stats_text
    $empty_line | Out-String


    # Display some results in a pop-up window (Out-GridView) - about 2/3 fits to the pop-up window
    $results.PSObject.TypeNames.Insert(0,"Processed Directories")
    $results_selection = $results | Select-Object 'Directory','Owner','Size','raw_size','Files','Subfolders','Average File Size','Average File Size (B)','Written','Written Ago (h)','Age (Days)','Read','Read ago (h)','Created on','Last Updated','BaseName','PSChildName','Last AccessTime','Last WriteTime','Creation Time','Extension','Is ReadOnly','Exists','PS Is Container','Attributes','VersionInfo','Folder Name','Name','Parent','Root','PSParentPath','PSPath','PSProvider','Last WriteTime (UTC)','Creation Time (UTC)','Last AccessTime (UTC)','PSDrive'
    $results_selection | Sort-Object 'raw_size','Files','Subfolders' -Descending | Out-GridView


    # Write all the results to a CSV-file
    If ($results_selection -ne $null) {
        $results_selection | Export-Csv $ReportPath\directory_size.csv -Delimiter ';' -NoTypeInformation -Encoding UTF8
    } Else {
        $continue = $true
    }


    # Find out how long the script took to complete and try to avoid dividing with a zero when displaying speeds and rates
    $end_time = Get-Date
    $runtime = ($end_time) - ($start_time)

        If ($runtime.Days -ge 2) {
            $runtime_result = [string]$runtime.Days + ' days ' + $runtime.Hours + ' h ' + $runtime.Minutes + ' min'
        } ElseIf ($runtime.Days -gt 0) {
            $runtime_result = [string]$runtime.Days + ' day ' + $runtime.Hours + ' h ' + $runtime.Minutes + ' min'
        } ElseIf ($runtime.Hours -gt 0) {
            $runtime_result = [string]$runtime.Hours + ' h ' + $runtime.Minutes + ' min'
        } ElseIf ($runtime.Minutes -gt 0) {
            $runtime_result = [string]$runtime.Minutes + ' min ' + $runtime.Seconds + ' sec'
        } ElseIf ($runtime.Seconds -gt 0) {
            $runtime_result = [string]$runtime.Seconds + ' sec'
        } ElseIf ($runtime.Milliseconds -gt 1) {
            $runtime_result = [string]$runtime.Milliseconds + ' milliseconds'
        } ElseIf ($runtime.Milliseconds -eq 1) {
            $runtime_result = [string]$runtime.Milliseconds + ' millisecond'
        } ElseIf (($runtime.Milliseconds -gt 0) -and ($runtime.Milliseconds -lt 1)) {
            $runtime_result = [string]$runtime.Milliseconds + ' milliseconds'
        } Else {
            $runtime_result = [string]''
        } # else (if)


            If ($runtime_result.Contains("0 h")) {
                $runtime_result = $runtime_result.Replace("0 h","")
                } If ($runtime_result.Contains("0 min")) {
                    $runtime_result = $runtime_result.Replace("0 min","")
                    } If ($runtime_result.Contains("0 sec")) {
                    $runtime_result = $runtime_result.Replace("0 sec","")
            } # if ($runtime_result: first)


            If (($runtime.TotalMilliseconds) -gt 0) {
                $speed = [Math]::Round(($number_of_directories / $runtime.TotalSeconds),1)
                $rate =  ConvertBytes ($total_size / $runtime.TotalSeconds)
            } Else {
                $speed = 0
                $rate = 0
            } # else


    # Display the runtime in console
    $runtime_text = "The directories were enumerated in $runtime_result (at the rate: $speed folders ($rate) / second)."
    Write-Output $runtime_text
    $empty_line | Out-String




# [Start Option A]




    # (Option A): Create a HTML final report                                                  # Credit: Martin Pugh: "Get-FolderSizes"

    # Define the HTML header
    # In the CSS style section .even and .odd apply to the custom function Set-AlternatingRows (Outlook ignores "nth-child" definitions in CSS).
    # So after defining the custom function Set-AlternatingRows the .odd and .even are specified in the CSS style section.
    # After ConvertTo-Html has outputted to a pipeline Set-AlternatingRows is then allowed to change lines (from "<tr>" to "<tr class='$class_name'>") in the source code at hand.
    # To improve the formatting of HTML code in Visual Studio Code, press Shift + Alt + F and the selected area will be reformatted.

    $header = @"
<style>
    table {
        border-width: 1px;
        border-style: solid;
        border-color: black;
        border-collapse: collapse;
    }

    th {
        border-width: 1px;
        padding: 3px;
        border-style: solid;
        border-color: black;
        background-color: #6495ED;
    }

    td {
        border-width: 1px;
        padding: 3px;
        border-style: solid;
        border-color: black;
    }

    .odd {
        background-color: #ffffff;
    }

    .even {
        background-color: #dddddd;
    }
</style>
<title>
    Directory Size of "$path"
</title>
"@

    $total_size = ConvertBytes $total_size

    $pre = "<h1>Directory Size Report</h1><h3>Listing the contents of ""$($titles -join ", ")"" on $computer</h3>"
    $post = "<h3><p>Total Number of Folders Processed: $number_of_directories<br />Skipped: $($skipped.Count)<br />Total Space Used:  $total_size</p></h3>Generated: $(Get-Date -Format g)"


            # Bypass the user defined sort options, if folder or file sizes or amounts are involved, so that always report largest files and folders first, and those which have the most content inside
            If ($Sort -eq "raw_size") {
                $sort_command = { Sort-Object -property @{Expression="raw_size";Descending=$true}, @{Expression="Files";Descending=$true}, @{Expression="Subfolders";Descending=$true}, @{Expression="Directory";Descending=$false} }
            } ElseIf ($Sort -eq "Average File Size") {
                $sort_command = { Sort-Object -property @{Expression="Average File Size (B)";Descending=$true}, @{Expression="Files";Descending=$true}, @{Expression="Subfolders";Descending=$true}, @{Expression="Directory";Descending=$false} }
            } ElseIf ($Sort -eq "Average File Size (B)") {
                $sort_command = { Sort-Object -property @{Expression="Average File Size (B)";Descending=$true}, @{Expression="Files";Descending=$true}, @{Expression="Subfolders";Descending=$true}, @{Expression="Directory";Descending=$false} }
            } ElseIf ($Sort -eq "Files") {
                $sort_command = { Sort-Object -property @{Expression="Files";Descending=$true}, @{Expression="Subfolders";Descending=$true}, @{Expression="raw_size";Descending=$true}, @{Expression="Directory";Descending=$false} }
            } ElseIf ($Sort -eq "Subfolders") {
                $sort_command = { Sort-Object -property @{Expression="Subfolders";Descending=$true}, @{Expression="Files";Descending=$true}, @{Expression="raw_size";Descending=$true}, @{Expression="Directory";Descending=$false} }
            } Else {
                $sort_command = { Sort-Object -property $Sort -Descending:$Descending }
            } #  Else


    # Create the report and save the it to a file
    $HTML = $results | Select-Object 'Directory','Owner','Size','raw_size','Files','Subfolders','Average File Size','Average File Size (B)','Written','Written Ago (h)','Age (Days)','Read','Read ago (h)','Created on','Last Updated','Folder Name' | Invoke-Command -ScriptBlock $sort_command | ConvertTo-Html -PreContent $pre -PostContent $post -Head $header -As Table | Set-AlternatingRows -CSS_even_class even -CSS_odd_class odd | Out-File $ReportPath\directory_size.html


    # Display the report in the default browser
    # & $ReportPath\directory_size.html
    Start-Process -FilePath "$ReportPath\directory_size.html" | Out-Null




# [End Option A]
# [Start Option B]








# [End Option B]


    Write-Verbose "$(Get-Date -Format HH:mm:ss): Script completed."


} # End




# [End of Line]


<#

   ____        _   _
  / __ \      | | (_)
 | |  | |_ __ | |_ _  ___  _ __  ___
 | |  | | '_ \| __| |/ _ \| '_ \/ __|
 | |__| | |_) | |_| | (_) | | | \__ \
  \____/| .__/ \__|_|\___/|_| |_|___/
        | |
        |_|




     /\
    /  \
   / /\ \
  / ____ \
 /_/    \_\





  ____
 |  _ \
 | |_) |
 |  _ <
 | |_) |
 |____/

    # (Option B) Send the Directory Size Report as an HTML-formatted email                    # Credit: Brian: "Making PowerShell Emails Pretty"

    # Define the email settings
    $email_server = "email.server.com"
    $email_from = "email.address@somewhere.com"
    $email_to = "email.address@somewhere.com"


    # Convert date to a string and use it in the email subject field
    $current_date = Get-Date
    $subject_date = $current_date.ToString('yyyy-MM-dd')
    $email_subject = "Directory Size of '$path' " + $subject_date


    # Define the CSS style for the email message
    # @" "@ is a quote block, allowing more "" inside without breaking
    # In the CSS style section .even and .odd apply to the custom function Set-AlternatingRows (Outlook ignores "nth-child" definitions in CSS).
    # So after defining the custom function Set-AlternatingRows the .odd and .even are specified in the CSS style section.
    # After ConvertTo-Html has outputted its strut Set-AlternatingRows is then allowed to change lines (from "<tr>" to "<tr class='$class_name'>") in the source code at hand.
    # To improve the formatting of HTML code in Visual Studio Code, press Shift + Alt + F and the selected area will be reformatted.
    # http://thesurlyadmin.com/2013/01/21/how-to-create-html-reports/


    # Define CSS with a file
    $header = Get-Content "\\SERVER1\Share\css.txt"


    # Define "CSS" manually
    $header = @"
<style>
    body {
        font-family: "Calibri";
        font-size: 9pt;
        color: #4C607B;
    }

    table {
        border-width: 1px;
        border-style: solid;
        border-color: black;
        border-collapse: collapse;
    }

    th,
    td {
        border: 1px solid #e57300;
        border-collapse: collapse;
        padding: 5px;
    }

    th {
        font-size: 1.2em;
        text-align: left;
        background-color: #003366;
        color: #ffffff;
    }

    td {
        color: #000000;

    }

    .even {
        background-color: #ffffff;
    }

    .odd {
        background-color: #bfbfbf;
    }
</style>
<title>
    Directory Sizes for "$path"
</title>
"@

    $total_size = ConvertBytes $total_size

    $pre = "<h1>Directory Size Report</h1><h3>Listing the contents of ""$($titles -join ", ")"" on $computer</h3>"
    $post = "<h3><p>Total Number of Folders Processed: $number_of_directories<br />Skipped: $($skipped.Count)<br />Total Space Used:  $total_size</p></h3>Generated: $(Get-Date -Format g)"


            # Bypass the user defined sort options, if folder or file sizes or amounts are involved, so that always report largest files and folders first, and those which have the most content inside
            If ($Sort -eq "raw_size") {
                $sort_command = { Sort-Object -property @{Expression="raw_size";Descending=$true}, @{Expression="Files";Descending=$true}, @{Expression="Subfolders";Descending=$true}, @{Expression="Directory";Descending=$false} }
            } ElseIf ($Sort -eq "Average File Size") {
                $sort_command = { Sort-Object -property @{Expression="Average File Size (B)";Descending=$true}, @{Expression="Files";Descending=$true}, @{Expression="Subfolders";Descending=$true}, @{Expression="Directory";Descending=$false} }
            } ElseIf ($Sort -eq "Average File Size (B)") {
                $sort_command = { Sort-Object -property @{Expression="Average File Size (B)";Descending=$true}, @{Expression="Files";Descending=$true}, @{Expression="Subfolders";Descending=$true}, @{Expression="Directory";Descending=$false} }
            } ElseIf ($Sort -eq "Files") {
                $sort_command = { Sort-Object -property @{Expression="Files";Descending=$true}, @{Expression="Subfolders";Descending=$true}, @{Expression="raw_size";Descending=$true}, @{Expression="Directory";Descending=$false} }
            } ElseIf ($Sort -eq "Subfolders") {
                $sort_command = { Sort-Object -property @{Expression="Subfolders";Descending=$true}, @{Expression="Files";Descending=$true}, @{Expression="raw_size";Descending=$true}, @{Expression="Directory";Descending=$false} }
            } Else {
                $sort_command = { Sort-Object -property $Sort -Descending:$Descending }
            } #  Else


    # Use the Directory Size final Report object as a email message body
    $body = $results | Select-Object 'Directory','Owner','Size','raw_size','Files','Subfolders','Average File Size','Average File Size (B)','Written','Written Ago (h)','Age (Days)','Read','Read ago (h)','Created on','Last Updated','Folder Name' | Invoke-Command -ScriptBlock $sort_command | ConvertTo-Html -PreContent $pre -PostContent $post -Head $header -As Table | Set-AlternatingRows -CSS_even_class even -CSS_odd_class odd | Out-String


    # Send the email
    Send-MailMessage -From $email_from -To $email_to -Subject $email_subject -Body $body -BodyAsHtml -SmtpServer $email_server



   _____
  / ____|
 | (___   ___  _   _ _ __ ___ ___
  \___ \ / _ \| | | | '__/ __/ _ \
  ____) | (_) | |_| | | | (_|  __/
 |_____/ \___/ \__,_|_|  \___\___|


https://community.spiceworks.com/scripts/show/1738-Get-DirectorySize                          # Martin Pugh: "Get-FolderSizes"
http://2012sg.poshcode.org/4950                                                               # Joel Reed: "Get-DirectorySize"
http://brianbunke.com/?p=59                                                                   # Brian: "Making PowerShell Emails Pretty"
http://powershell.com/cs/media/p/7476.aspx                                                    # clayman2: "Disk Space"
https://technet.microsoft.com/en-us/library/hh849719.aspx                                     # Invoke-Command
https://technet.microsoft.com/en-us/library/hh849912.aspx                                     # Sort-Object



  _    _      _
 | |  | |    | |
 | |__| | ___| |_ __
 |  __  |/ _ \ | '_ \
 | |  | |  __/ | |_) |
 |_|  |_|\___|_| .__/
               | |
               |_|
#>

<#

.SYNOPSIS
Retrieves the folder sizes in a specified directory or directories.

.DESCRIPTION
Get-DirectorySize returns the size of a directory or directories (paths) specificed
by a parameter called -Path and reports the sizes of the first level of folders (i.e.
the listing is similar to the common "dir" command, but the size of the folders is
shown in the results and the listing of files is omitted).

To query recursively (i.e. including all sub-directories of the sub-directories and
their sub-directories as well and also all other successive sub-directories) a
parameter -Recurse may be added to the query command.

To effectively use Get-DirectorySize, a path, paths or path names to a directory
should be specified (with the -Path parameter), as by default, only $env:temp
gets searched. The paths should be valid file system paths to a directory (a full
path name of a directory (i.e. folder path such as C:\Windows)). In case the path
name includes space characters, quotation marks around the path name are mandatory.
The -Path parameter accepts a collection of path names (separated by comma) and
also takes an array of strings for paths to query.

The directories are queried extensively, a wide array of properties, such as
Directory, Owner, Size, raw_size, Files, Subfolders, Average File Size, Average
File Size (B), Written, Written Ago (h), Age (Days), Read, Read ago (h), Created on,
Last Updated, BaseName, PSChildName, Last AccessTime, Last WriteTime, Creation Time,
Extension, Is ReadOnly, Exists, PS Is Container, Attributes, VersionInfo, Folder
Name, Name, Parent, Root, PSParentPath, PSPath, PSProvider, Last WriteTime (UTC),
Creation Time (UTC), Last AccessTime (UTC) and PSDrive is leveraged from the
directories totaling nearly 40 headers / columns. The full report is written to
a CSV-file, about 2/3 of the data is displayed in a sortable pop-up window
(Out-GridView) and a Directory Size Report (as a HTML file) with the essential
information is invoked in the default browser.

The -ReportPath parameter defines where the files are saved. The default save
location of the HTML Directory Size Report (directory_size.html) and the adjacent
CSV-file (directory_size.csv) is $env:temp, which points to the current temporary
file location, which is set in the system (- for more information, please see
the Notes section).

While the parameters -Path, -Recurse and -ReportPath modify holistically the
behavior of Get-DirectorySize, the other parameters -Sort and -Descending toggle
how and in which way the data is displayed in the HTML Directory Size Report.
The usage and behavior of each parameter is discussed in further detail below.
This script is based on Martin Pugh's PowerShell script "Get-FolderSizes"
(https://community.spiceworks.com/scripts/show/1738-Get-DirectorySize).

.PARAMETER Path
as an alias of -Paths. The -Path parameter determines the starting point of the
directory size analyzation. The -Path parameter also accepts a collection of path
names (separated by a comma). It's not always mandatory to write -Path in the query
command to invoke the -Path parameter, as is shown in the Examples below, since
Get-DirectorySize is trying to decipher the inputted queries as good as it is
machinely possible within a 60 KB size limit.

The paths should be valid file system paths to a directory (a full path name of a
directory (i.e. folder path such as C:\Windows)). In case the path name includes
space characters,  please add quotation marks around the path name. If a collection
of path names is defined for the -Path parameter, please separate the individual
path names with a comma. The -Path parameter also takes an array of strings for
paths to query and objects could be piped to this parameter, too. If no path is
defined in the query $env:temp gets searched.

.PARAMETER ReportPath
Specifies where the HTML Directory Size Report and the adjacent CSV-file is to be
saved. The default file location is $env:temp, which points to the current temporary
file location, which is set in the system. The default -ReportPath save location is
defined at line 16. For usage, please see the Examples below and for more information
about $env:temp, please see the Notes section below.

.PARAMETER Sort
Specifies which column is the primary sort column in the HTML Directory Size Report.
Only one column may be selected in one query as the primary column. If -Sort
parameter is not defined, Get-DirectorySize will try to sort by Size.

Even when the -Sort parameter is used, Get-DirectorySize acts partially indepently
in the background and is actively trying to sort values automatically, so that
numerical values would be sorted as descending as default while text based columns
would be sorted as ascending as default. By any means with any command or parameter
combination will Get-DirectorySize probably not agree to sorting size as ascending,
so effectively the -Descending parameter is almost exclusively left as a toggle for
the text based columns.

In the HTML Directory Size Report all the headers are sortable (with the query
commands) and some headers have aliases, too. Valid -Sort values are listed below
along with the default order (descending or ascending). Please also see the Examples
section for further usage examples.


    Valid -Sort values:

                                                                  Default Order
    Value                   Sort Behavior                   Descending  /  Ascending
    -----                   -------------                   ------------------------
    Directory               Sort by Directory                (param)       Ascending
    Owner                   Sort by Owner                    (param)       Ascending
    Size                    Sort by raw_size                Descending         -
    raw_size                Sort by raw_size                Descending         -
    Files                   Sort by Files                   Descending         -
    Subfolders              Sort by Subfolders              Descending         -
    "Average File Size"     Sort by Average File Size (B)   Descending         -
    "Average File Size (B)" Sort by Average File Size (B)   Descending         -
    Average                 Sort by Average File Size (B)   Descending         -
    "Written Ago (h)"       Sort by Written Ago (h)          (param)       Ascending
    Written                 Sort by Written Ago (h)          (param)       Ascending
    'Age (Days)'            Sort by Age (Days)               (param)       Ascending
    Age                     Sort by Age (Days)               (param)       Ascending
    "Read ago (h)"          Sort by Read ago (h)             (param)       Ascending
    Read                    Sort by Read ago (h)             (param)       Ascending
    "Created on"            Sort by Created on               (param)       Ascending
    Created                 Sort by Created on               (param)       Ascending
    "Last Updated"          Sort by Last Updated             (param)       Ascending
    Updated                 Sort by Last Updated             (param)       Ascending
    Changed                 Sort by Last Updated             (param)       Ascending
    Last                    Sort by Last Updated             (param)       Ascending
    "Folder Name"           Sort by Folder Name              (param)       Ascending


In the table above, (param) depicts the usage of the -Descending parameter.

.PARAMETER Descending
A switch to control how directories get sorted in the HTML Directory Size Report.
Please see the -Sort parameter above for further details. By default
Get-DirectorySize tries to sort number based values in an descending order and text
based values in an ascending order. By adding the -Descending parameter to the query
the prevalent ascending sort order may be reversed in the cases, which are listed in
the table above and marked with (param).

.PARAMETER Recurse
If the -Recurse parameter is added to the query command, also each and every
sub-folder in any level, no matter how deep in the directory structure or behind how
many sub-folders, is included individually to the report. While the -Recurse
parameter can be used for reporting the size of all sub-folders on every sub-level,
it may have an impact on how long the script actually runs.

Please note, that even when the -Recurse parameter is not used, and despite its toll
to the performance of the script (speed), Get-DirectorySize will try to query some
data, such as the overall file size of the folder, recursively. This is intended
action and is one of the key elements and main characteristics of Get-DirectorySize.
The total size of a folder cannot be known, if all of the content is not known.
The file count and subfolder count will, however, follow the path of the -Recurse
parameter. Furthermore, since the Average File Size depends on the number of files
found, the reported average file size of a folder may differ drastically depending
on whether the -Recurse parameter was used or not.

.OUTPUTS
Generates an HTML Directory Size Report and an adjacent CSV-file in a specified
Report Path ($ReportPath = "$env:temp" at line 16), which is user-settable with
the -ReportPath parameter. Also displays performance related information about the
query process in console after the query has finished. In addition to that...


One pop-up window "$results_selection" (Out-GridView) with sortable headers (with a click):

        Name                                Description
        ----                                -----------
        $results_selection                  Displays 2/3 of the full data set


And also the aforementioned HTML-file "Directory Size Report" and CSV-file at
$ReportPath. The HTML-file "Directory Size Report" is opened automatically in the
default browser after the query is finished.

$env:temp\directory_size.html           : HTML-file          : directory_size.html
$env:temp\directory_size.csv            : CSV-file           : directory_size.csv

.NOTES
Please note that all the parameters can be used in one query command.

Please note that the default search location is defined at line 15 for the -Path
parameter (as an alias of -Paths) with the $Paths variable.

Please also note that the two files are created in a directory, which is end-user
settable in each query command with the -ReportPath parameter. The default save
location is defined with the $ReportPath variable (at line 16). The $env:temp
variable points to the current temp folder. The default value of the $env:temp
variable is C:\Users\<username>\AppData\Local\Temp (i.e. each user account has their
own separate temp folder at path %USERPROFILE%\AppData\Local\Temp). To see the
current temp path, for instance a command

    [System.IO.Path]::GetTempPath()

may be used at the PowerShell prompt window [PS>]. To change the temp folder for
instance to C:\Temp, please, for example, follow the instructions at
http://www.eightforums.com/tutorials/23500-temporary-files-folder-change-location-windows.html

    Homepage:           https://github.com/auberginehill/get-directory-size
                        Short URL: http://tinyurl.com/jjl9wng
    Version:            1.1

.EXAMPLE
./Get-DirectorySize

Run the script. Please notice to insert ./ or .\ before the script name.
Uses the default location ($env:temp) for 'listing the contents of' and for storing
the generated two files. Lists the folders, which are found on the first level (i.e.
search is done nonrecursively, similarly to a common command "dir", for example).
The output in the CSV file includes nearly 40 columns of data with each processed
folder name as a row, the Out-GridView has about 2/3 of the data and, in essence,
the generated HTML Directory Size Report is a summary table with the most relevant
information. The HTML Directory Size Report is sorted by Size and ordered as
descending as default (the default order for text based columns is ascending).

.EXAMPLE
help ./Get-DirectorySize -Full
Display the help file.

.EXAMPLE
./Get-DirectorySize -Path "C:\Windows" -ReportPath "C:\Scripts"

Run the script and report on all folders in C:\Windows. Save the
HTML Directory Size Report and the adjacent CSV-file to C:\Scripts.
The output is sorted, as per default, on the raw_size property in an descending
order, displaying the largest directories on top and the smallest directories
at the bottom.

.EXAMPLE
./Get-DirectorySize "C:\dc01","D:\dc04","E:\chiore"

Run the script and report on all folders, which are found in C:\dc01,
D:\dc04 and E:\chiore. Please note that the -Path is not mandatory in this
example, but it could be included, too, and the quotation marks can be left out
since the path names don't contain any space characters
(./Get-DirectorySize -Path C:\dc01, D:\dc04, E:\chiore).

.EXAMPLE
./Get-DirectorySize -Path E:\chiore -Sort "Folder Name" -Descending

Run the script and report on all the folders in E:\chiore. Sort the data based on
the "Folder Name" column and arrange the rows in the HTML Directory Size Report as
descending so that last alphabets come to the top and first alphabets will be at the
bottom. To sort the same query in an ascending order the -Descending parameter may
be left out from the query command (./Get-DirectorySize -Path E:\chiore -Sort "Folder Name").

.EXAMPLE
./Get-DirectorySize -Path C:\Users\Dropbox -Recurse

Will output a size calculation of C:\Users\Dropbox and include all enclosed
sub-directories of the sub-directories of the sub-directories and their
sub-directories as well (the search is done recursively). The output is sorted, as
per default, on the raw_size property in an descending order, displaying the largest
directories on top and the smallest directories at the bottom. Due to the
partial automation in Get-DirectorySize, this is the same command as

    ./Get-DirectorySize -Path C:\Users\Dropbox -Sort size -Descending -Recurse

in essence.

.EXAMPLE
./Get-DirectorySize -Path C:\Windows -ReportPath C:\Scripts -Sort owner -Descending -Recurse

Run the script and list recursively all the folders in C:\Windows, so that all
sub-folders will get enumerated individually, too. Sort the data in the HTML
Directory Size Report by the column name Owner in a descending order, and save the
HTML Directory Size Report to C:\Scripts. Please note, that -Path can be omitted
in this example, because

    ./Get-DirectorySize C:\Windows -ReportPath C:\Scripts -Sort owner -Descending -Recurse

will result in the exact same outcome.

.EXAMPLE
Set-ExecutionPolicy remotesigned
This command is altering the Windows PowerShell rights to enable script execution. Windows PowerShell
has to be run with elevated rights (run as an administrator) to actually be able to change the script
execution properties. The default value is "Set-ExecutionPolicy restricted".


    Parameters:

    Restricted      Does not load configuration files or run scripts. Restricted is the default
                    execution policy.

    AllSigned       Requires that all scripts and configuration files be signed by a trusted
                    publisher, including scripts that you write on the local computer.

    RemoteSigned    Requires that all scripts and configuration files downloaded from the Internet
                    be signed by a trusted publisher.

    Unrestricted    Loads all configuration files and runs all scripts. If you run an unsigned
                    script that was downloaded from the Internet, you are prompted for permission
                    before it runs.

    Bypass          Nothing is blocked and there are no warnings or prompts.

    Undefined       Removes the currently assigned execution policy from the current scope.
                    This parameter will not remove an execution policy that is set in a Group
                    Policy scope.


For more information, please type "help Set-ExecutionPolicy -Full" or visit
https://technet.microsoft.com/en-us/library/hh849812.aspx.

.EXAMPLE
New-Item -ItemType File -Path C:\Temp\Get-DirectorySize.ps1
Creates an empty ps1-file to the C:\Temp directory. The New-Item cmdlet has an inherent -NoClobber mode
built into it, so that the procedure will halt, if overwriting (replacing the contents) of an existing
file is about to happen. Overwriting a file with the New-Item cmdlet requires using the Force.
For more information, please type "help New-Item -Full".

.LINK
https://community.spiceworks.com/scripts/show/1738-Get-DirectorySize
http://2012sg.poshcode.org/4950
http://brianbunke.com/?p=59
http://powershell.com/cs/media/p/7476.aspx
https://technet.microsoft.com/en-us/magazine/hh360993.aspx
https://msdn.microsoft.com/en-us/library/ms714434(v=vs.85).aspx
https://technet.microsoft.com/en-us/library/hh847743.aspx
https://technet.microsoft.com/en-us/library/hh849719.aspx
https://technet.microsoft.com/en-us/library/hh849912.aspx
http://social.technet.microsoft.com/wiki/contents/articles/15994.powershell-advanced-function-parameter-attributes.aspx
http://www.techrepublic.com/blog/10-things/10-powershell-commands-every-windows-admin-should-know/

#>
