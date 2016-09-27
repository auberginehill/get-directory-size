<!-- Visual Studio Code: For a more comfortable reading experience, use the key combination Ctrl + Shift + V
     Visual Studio Code: To crop the tailing end space characters out, please use the key combination Ctrl + Shift + X
     Visual Studio Code: To improve the formatting of HTML code, press Shift + Alt + F and the selected area will be reformatted in a html file.


   _____      _          _____  _               _                    _____ _
  / ____|    | |        |  __ \(_)             | |                  / ____(_)
 | |  __  ___| |_ ______| |  | |_ _ __ ___  ___| |_ ___  _ __ _   _| (___  _ _______
 | | |_ |/ _ \ __|______| |  | | | '__/ _ \/ __| __/ _ \| '__| | | |\___ \| |_  / _ \
 | |__| |  __/ |_       | |__| | | | |  __/ (__| || (_) | |  | |_| |____) | |/ /  __/
  \_____|\___|\__|      |_____/|_|_|  \___|\___|\__\___/|_|   \__, |_____/|_/___\___|
                                                               __/ |
                                                              |___/                                  -->


## Get-DirectorySize.ps1

<table>
   <tr>
      <td style="padding:6px"><strong>OS:</strong></td>
      <td style="padding:6px">Windows</td>
   </tr>
   <tr>
      <td style="padding:6px"><strong>Type:</strong></td>
      <td style="padding:6px">A Windows PowerShell script</td>
   </tr>
   <tr>
      <td style="padding:6px"><strong>Language:</strong></td>
      <td style="padding:6px">Windows PowerShell</td>
   </tr>
   <tr>
      <td style="padding:6px"><strong>Description:</strong></td>
      <td style="padding:6px">Get-DirectorySize returns the size of a directory or directories (paths) specificed by a parameter called <code>-Path</code> and reports the sizes of the first level of folders (i.e. the listing is similar to the common "<code>dir</code>" command, but the size of the folders is shown in the results and the listing of files is omitted).
      <br />
      <br />To query recursively (i.e. including all sub-directories of the sub-directories and their sub-directories as well and also all other successive sub-directories) a parameter <code>-Recurse</code> may be added to the query command.
      <br />
      <br />To effectively use Get-DirectorySize, a path, paths or path names to a directory should be specified (with the <code>-Path</code> parameter), as by default, only <code>$env:temp</code> gets searched. The paths should be valid file system paths to a directory (a full path name of a directory (i.e. folder path such as <code>C:\Windows</code>)). In case the path name includes space characters, quotation marks around the path name are mandatory. The <code>-Path</code> parameter accepts a collection of path names (separated by comma) and also takes an array of strings for paths to query.
      <br />
      <br />The directories are queried extensively, a wide array of properties, such as Directory, Owner, Size, Relative Size (Size (%)), raw_size, File Count, Subfolder Count, Average File Size, Average File Size (B), Written, Written Ago (h), Age (Days), Read, Read ago (h), Created on, Last Updated, BaseName, PSChildName, Last AccessTime, Last WriteTime, Creation Time, Extension, Is ReadOnly, Exists, PS Is Container, Attributes, VersionInfo, Folder Name, Name, Parent, Root, PSParentPath, PSPath, PSProvider, Last WriteTime (UTC), Creation Time (UTC), Last AccessTime (UTC), PSDrive, Volume Available Free Space (B), Volume Type, Volume Free, Volume Free (%), Volume Is Ready, Volume Label, Volume Name, Volume Root Directory, Volume Total Size, Volume Total Free Space (B), Volume Total Size (B), Volume Used, Volume Used (%) and Volume is leveraged from the directories totaling over 50 headers / columns. The full report is written to a CSV-file, about 1/2 of the data is displayed in a sortable pop-up window (Out-GridView) and a Directory Size Report (as a HTML file) with the essential information is invoked in the default browser.
      <br />
      <br />The <code>-ReportPath</code> parameter defines where the files are saved. The default save location of the HTML Directory Size Report (<code>directory_size.html</code>) and the adjacent CSV-file (<code>directory_size.csv</code>) is <code>$env:temp</code>, which points to the current temporary file location, which is set in the system (– for more information, please see the Notes section).
      <br />
      <br />While the parameters <code>-Path</code>, <code>-Recurse</code> and <code>-ReportPath</code> (along with the <code>-Audio</code> parameter(, which emits an audible beep after the query is finished)) modify holistically the behavior of Get-DirectorySize, the other parameters <code>-Sort</code> and <code>-Descending</code> toggle how and in which way the data is displayed in the HTML Directory Size Report. The usage and behavior of each parameter is discussed in further detail below. This script is based on Martin Pugh's PowerShell script "<a href="https://community.spiceworks.com/scripts/show/1738-Get-DirectorySize">Get-FolderSizes</a>".</td>
   </tr>
   <tr>
      <td style="padding:6px"><strong>Homepage:</strong></td>
      <td style="padding:6px"><a href="https://github.com/auberginehill/get-directory-size">https://github.com/auberginehill/get-directory-size</a>
                              <br />Short URL: <a href="http://tinyurl.com/jjl9wng">http://tinyurl.com/jjl9wng</a></td>
   </tr>
   <tr>
      <td style="padding:6px"><strong>Version:</strong></td>
      <td style="padding:6px">1.2</td>
   </tr>
   <tr>
        <td style="padding:6px"><strong>Sources:</strong></td>
        <td style="padding:6px">
            <table>
                <tr>
                    <td style="padding:6px">Emojis:</td>
                    <td style="padding:6px"><a href="https://api.github.com/emojis">https://api.github.com/emojis</a></td>
                </tr>
                <tr>
                    <td style="padding:6px">Martin Pugh:</td>
                    <td style="padding:6px"><a href="https://community.spiceworks.com/scripts/show/1738-get-foldersizes">Get-FolderSizes</a></td>
                </tr>
                <tr>
                    <td style="padding:6px">Joel Reed:</td>
                    <td style="padding:6px"><a href="http://2012sg.poshcode.org/4950">Get-DirectorySize</a></td>
                </tr>
                <tr>
                    <td style="padding:6px">Brian:</td>
                    <td style="padding:6px"><a href="http://brianbunke.com/?p=59">Making PowerShell Emails Pretty</a></td>
                </tr>
                <tr>
                    <td style="padding:6px">clayman2:</td>
                    <td style="padding:6px"><a href="http://powershell.com/cs/media/p/7476.aspx">DiskSpace</a> (or one of the <a href="https://web.archive.org/web/20150721184135/http://powershell.com/cs/media/p/7476.aspx">archive.org versions</a>)</td>
                </tr>
                <tr>
                    <td style="padding:6px">Tobias Weltner:</td>
                    <td style="padding:6px"><a href="http://powershell.com/cs/media/p/7476.aspx">PowerTips Monthly Volume 2: Arrays and Hash Tables</a> (or one of the <a href="https://web.archive.org/web/20150714100009/http://powershell.com/cs/media/p/24814.aspx">archive.org versions</a>)</td>
                </tr>
                <tr>
                    <td style="padding:6px">Microsoft TechNet:</td>
                    <td style="padding:6px"><a href="https://technet.microsoft.com/en-us/library/hh849719.aspx">Invoke-Command</a></td>
                </tr>
                <tr>
                    <td style="padding:6px">Microsoft TechNet:</td>
                    <td style="padding:6px"><a href="https://technet.microsoft.com/en-us/library/hh849912.aspx">Sort-Object</a></td>
                </tr>
            </table>
        </td>
   </tr>
   <tr>
      <td style="padding:6px"><strong>Downloads:</strong></td>
      <td style="padding:6px">For instance <a href="https://raw.githubusercontent.com/auberginehill/get-directory-size/master/Get-DirectorySize.ps1">Get-DirectorySize.ps1</a>. Or <a href="https://github.com/auberginehill/get-directory-size/archive/master.zip">everything as a .zip-file</a>.</td>
   </tr>
</table>




### Screenshot

<img class="screenshot" title="screenshot" alt="screenshot" height="100%" width="100%" src="https://raw.githubusercontent.com/auberginehill/get-directory-size/master/Get-DirectorySize.png">




### Parameters

<table>
    <tr>
        <th>:triangular_ruler:</th>
        <td style="padding:6px">
            <ul>
                <li>
                    <h5>Parameter <code>-Path</code></h5>
                    <p>as an alias of <code>-Paths</code>. The <code>-Path</code> parameter determines the starting point of the directory size analyzation. The <code>-Path</code> parameter also accepts a collection of path names (separated by a comma). It's not always mandatory to write <code>-Path</code> in the query command to invoke the <code>-Path</code> parameter, as is shown in the Examples below, since Get-DirectorySize is trying to decipher the inputted queries as good as it is machinely possible within a 60 KB size limit.</p>
                    <p>The paths should be valid file system paths to a directory (a full path name of a directory (i.e. folder path such as <code>C:\Windows</code>)). In case the path name includes space characters, please add quotation marks around the path name. If a collection of path names is defined for the <code>-Path</code> parameter, please separate the individual path names with a comma. The <code>-Path</code> parameter also takes an array of strings for paths to query and objects could be piped to this parameter, too. If no path is defined in the query <code>$env:temp</code> gets searched.</p>
                </li>
            </ul>
        </td>
    </tr>
    <tr>
        <th></th>
        <td style="padding:6px">
            <ul>
                <p>
                    <li>
                        <h5>Parameter <code>-ReportPath</code></h5>
                        <p>Specifies where the HTML Directory Size Report and the adjacent CSV-file is to be saved. The default save location is <code>$env:temp</code>, which points to the current temporary file location, which is set in the system. The default <code>-ReportPath</code> save location is defined at line 16 with the $ReportPath variable. For usage, please see the Examples below and for more information about <code>$env:temp</code>, please see the Notes section below.</p>
                    </li>
                </p>
                <p>
                    <li>
                        <h5>Parameter <code>-Sort</code></h5>
                        <p>Specifies which column is the primary sort column in the HTML Directory Size Report. Only one column may be selected in one query as the primary column. If <code>-Sort</code> parameter is not defined, Get-DirectorySize will try to sort by Size.</p>
                        <p>Even when the <code>-Sort</code> parameter is used, Get-DirectorySize acts partially indepently in the background and is actively trying to sort values automatically, so that numerical values would be sorted as descending as default while text based columns would be sorted as ascending as default. By any means with any command or parameter combination will Get-DirectorySize probably not agree to sorting size in the HTML Directory Size Report as ascending, so effectively the <code>-Descending</code> parameter is almost exclusively left as a toggle for the text based columns.</p>
                        <p>In the HTML Directory Size Report all the headers are sortable (with the query commands) and some headers have aliases, too. Valid <code>-Sort</code> values are listed below along with the default order (descending or ascending). Please also see the Examples section for further usage examples. </p>
                        <ol>
                            <h4>Valid <code>-Sort</code> values:</h4>
                            <p>
                                <table>
                                    <tr>
                                        <td rowspan="2" style="padding:6px"><strong>Value</strong></td>
                                        <td rowspan="2" style="padding:6px"><strong>Sort Behavior</strong></td>
                                        <td colspan="2" align="center" style="padding:6px;"><strong>Default Order</strong></td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><strong>Descending</strong></td>
                                        <td style="padding:6px"><strong>Ascending</strong></td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>Directory</code></td>
                                        <td style="padding:6px">Sort by Directory</td>
                                        <td align="center" style="padding:6px">(param)</td>
                                        <td align="center" style="padding:6px">Ascending</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>Owner</code></td>
                                        <td style="padding:6px">Sort by Owner</td>
                                        <td align="center" style="padding:6px">(param)</td>
                                        <td align="center" style="padding:6px">Ascending</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>Size</code></td>
                                        <td style="padding:6px">Sort by raw_size</td>
                                        <td align="center" style="padding:6px">Descending</td>
                                        <td align="center" style="padding:6px">-</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>"Size (%)"</code></td>
                                        <td style="padding:6px">Sort by Size (%)</td>
                                        <td align="center" style="padding:6px">Descending</td>
                                        <td align="center" style="padding:6px">-</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>raw_size</code></td>
                                        <td style="padding:6px">Sort by raw_size</td>
                                        <td align="center" style="padding:6px">Descending</td>
                                        <td align="center" style="padding:6px">-</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>Files</code></td>
                                        <td style="padding:6px">Sort by Files</td>
                                        <td align="center" style="padding:6px">Descending</td>
                                        <td align="center" style="padding:6px">-</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>Subfolders</code></td>
                                        <td style="padding:6px">Sort by Subfolders</td>
                                        <td align="center" style="padding:6px">Descending</td>
                                        <td align="center" style="padding:6px">-</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>"Average File Size"</code></td>
                                        <td style="padding:6px">Sort by Average File Size (B)</td>
                                        <td align="center" style="padding:6px">Descending</td>
                                        <td align="center" style="padding:6px">-</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>"Average File Size (B)"</code></td>
                                        <td style="padding:6px">Sort by Average File Size (B)</td>
                                        <td align="center" style="padding:6px">Descending</td>
                                        <td align="center" style="padding:6px">-</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>Average</code></td>
                                        <td style="padding:6px">Sort by Average File Size (B)</td>
                                        <td align="center" style="padding:6px">Descending</td>
                                        <td align="center" style="padding:6px">-</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>"Written Ago (h)"</code></td>
                                        <td style="padding:6px">Sort by Written Ago (h)</td>
                                        <td align="center" style="padding:6px">(param)</td>
                                        <td align="center" style="padding:6px">Ascending</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>Written</code></td>
                                        <td style="padding:6px">Sort by Written Ago (h)</td>
                                        <td align="center" style="padding:6px">(param)</td>
                                        <td align="center" style="padding:6px">Ascending</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>"Age (Days)"</code></td>
                                        <td style="padding:6px">Sort by Age (Days)</td>
                                        <td align="center" style="padding:6px">(param)</td>
                                        <td align="center" style="padding:6px">Ascending</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>Age</code></td>
                                        <td style="padding:6px">Sort by Age (Days)</td>
                                        <td align="center" style="padding:6px">(param)</td>
                                        <td align="center" style="padding:6px">Ascending</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>"Read ago (h)"</code></td>
                                        <td style="padding:6px">Sort by Read ago (h)</td>
                                        <td align="center" style="padding:6px">(param)</td>
                                        <td align="center" style="padding:6px">Ascending</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>Read</code></td>
                                        <td style="padding:6px">Sort by Read ago (h)</td>
                                        <td align="center" style="padding:6px">(param)</td>
                                        <td align="center" style="padding:6px">Ascending</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>"Created on"</code></td>
                                        <td style="padding:6px">Sort by Created on</td>
                                        <td align="center" style="padding:6px">(param)</td>
                                        <td align="center" style="padding:6px">Ascending</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>Created</code></td>
                                        <td style="padding:6px">Sort by Created on</td>
                                        <td align="center" style="padding:6px">(param)</td>
                                        <td align="center" style="padding:6px">Ascending</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>"Last Updated"</code></td>
                                        <td style="padding:6px">Sort by Last Updated</td>
                                        <td align="center" style="padding:6px">(param)</td>
                                        <td align="center" style="padding:6px">Ascending</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>Updated</code></td>
                                        <td style="padding:6px">Sort by Last Updated</td>
                                        <td align="center" style="padding:6px">(param)</td>
                                        <td align="center" style="padding:6px">Ascending</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>Changed</code></td>
                                        <td style="padding:6px">Sort by Last Updated</td>
                                        <td align="center" style="padding:6px">(param)</td>
                                        <td align="center" style="padding:6px">Ascending</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>Last</code></td>
                                        <td style="padding:6px">Sort by Last Updated</td>
                                        <td align="center" style="padding:6px">(param)</td>
                                        <td align="center" style="padding:6px">Ascending</td>
                                    </tr>
                                    <tr>
                                        <td style="padding:6px"><code>"Folder Name"</code></td>
                                        <td style="padding:6px">Sort by Folder Name</td>
                                        <td align="center" style="padding:6px">(param)</td>
                                        <td align="center" style="padding:6px">Ascending</td>
                                    </tr>
                                </table>
                                <p>In the table above, (param) depicts the usage of the <code>-Descending</code> parameter.</p>
                            </p>
                        </ol>
                    </li>
                </p>
                <p>
                    <li>
                        <h5>Parameter <code>-Descending</code></h5>
                        <p>A switch to control how directories get sorted in the HTML Directory Size Report. Please see the <code>-Sort</code> parameter above for further details. By default Get-DirectorySize tries to sort number based values in an descending order and text based values in an ascending order. By adding the <code>-Descending</code> parameter to the query the prevalent ascending sort order may be reversed in the cases, which are listed in the table above and marked with (param).</p>
                    </li>
                </p>
                <p>
                    <li>
                        <h5>Parameter <code>-Recurse</code></h5>
                        <p>If the <code>-Recurse</code> parameter is added to the query command, also each and every sub-folder in any level, no matter how deep in the directory structure or behind how many sub-folders, is included individually to the report. While the <code>-Recurse</code> parameter can be used for reporting the size of all sub-folders on every sub-level, it may have an impact on how long the script actually runs.
                        <br />
                        <br />Please note, that even when the <code>-Recurse</code> parameter is not used, and despite its toll to the performance of the script (speed), Get-DirectorySize will try to query some data, such as the overall size of the folder, recursively. This is intended action and is one of the key elements and main characteristics of Get-DirectorySize. The total size of a folder cannot be known, if all of the content is not known. The file count and subfolder count will, however, follow the path of the <code>-Recurse</code> parameter. Furthermore, since the Average File Size depends on the number of files found, the reported average file size of a folder may differ drastically depending on whether the <code>-Recurse</code> parameter was used or not.</p>
                    </li>
                    
                      <li>
                        <h5>Parameter <code>-Audio</code></h5>
                        <p>If this parameter is used in the query command, an audible beep will occur after the directory size enumeration is finished.</p>
                    </li>
                </p>
            </ul>
        </td>
    </tr>
</table>




### Outputs

<table>
    <tr>
        <th>:arrow_right:</th>
        <td style="padding:6px">
            <ul>
                <li>Generates an HTML Directory Size Report and an adjacent CSV-file in a specified Report Path (<code>$ReportPath = "$env:temp"</code> at line 16), which is user-settable with the <code>-ReportPath</code> parameter. Skipped path names, if any, are reported in console. Also displays performance related information about the query process in console after the query has finished. In addition to that... </li>
            </ul>
        </td>
    </tr>
    <tr>
        <th></th>
        <td style="padding:6px">
            <ul>
                <p>
                    <li>One pop-up window "<code>$results_selection</code>" (Out-GridView) with sortable headers (with a click):</li>
                </p>
                <ol>
                    <p>
                        <table>
                            <tr>
                                <td style="padding:6px"><strong>Name</strong></td>
                                <td style="padding:6px"><strong>Description</strong></td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$results_selection</code></a></td>
                                <td style="padding:6px">Displays 1/2 of the full data set</td>
                            </tr>
                        </table>
                    </p>
                </ol>
                <p>
                    <li>And also the aforementioned HTML-file "Directory Size Report" and CSV-file at <code>$ReportPath</code>. The HTML-file "Directory Size Report" is opened automatically in the default browser after the query is finished.</li>
                </p>
                <ol>
                    <p>
                        <table>
                            <tr>
                                <td style="padding:6px"><strong>Path</strong></td>
                                <td style="padding:6px"><strong>Type</strong></td>
                                <td style="padding:6px"><strong>Name</strong></td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\directory_size.html</code></td>
                                <td style="padding:6px">HTML-file</td>
                                <td style="padding:6px"><code>directory_size.html</code></td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\directory_size.csv</code></td>
                                <td style="padding:6px">CSV-file</td>
                                <td style="padding:6px"><code>directory_size.csv</code></td>
                            </tr>
                        </table>
                    </p>
                </ol>
            </ul>
        </td>
    </tr>
</table>




### Notes

<table>
    <tr>
        <th>:warning:</th>
        <td style="padding:6px">
            <ul>
                <li>Please note that all the parameters can be used in one query command and that each of the parameters can be "tab completed" before typing them fully (by pressing the <code>[tab]</code> key).</li>
            </ul>
        </td>
    </tr>
    <tr>
        <th></th>
        <td style="padding:6px">
            <ul>
                <p>
                    <li>Please note that the default search location is defined at line 15 for the <code>-Path</code> parameter (as an alias of <code>-Paths</code>) with the <code>$Paths</code> variable. </li>
                </p>
                <p>
                    <li>Please also note that the two files are created in a directory, which is end-user settable in each query command with the <code>-ReportPath</code> parameter. The default save location is defined with the <code>$ReportPath</code> variable (at line 16). The <code>$env:temp</code> variable points to the current temp folder. The default value of the <code>$env:temp</code> variable is <code>C:\Users\&lt;username&gt;\AppData\Local\Temp</code> (i.e. each user account has their own separate temp folder at path <code>%USERPROFILE%\AppData\Local\Temp</code>). To see the current temp path, for instance a command
                    <br />
                    <br /><code>[System.IO.Path]::GetTempPath()</code>
                    <br />
                    <br />may be used at the PowerShell prompt window <code>[PS>]</code>. To change the temp folder for instance to <code>C:\Temp</code>, please, for example, follow the instructions at <a href="http://www.eightforums.com/tutorials/23500-temporary-files-folder-change-location-windows.html">Temporary Files Folder - Change Location in Windows</a>, which in essence are something along the lines:
                        <ol>
                           <li>Right click on Computer and click on Properties (or select Start → Control Panel → System). In the resulting window with the basic information about the computer...</li>
                           <li>Click on Advanced system settings on the left panel and select Advanced tab on the resulting pop-up window.</li>
                           <li>Click on the button near the bottom labeled Environment Variables.</li>
                           <li>In the topmost section labeled User variables both TMP and TEMP may be seen. Each different login account is assigned its own temporary locations. These values can be changed by double clicking a value or by highlighting a value and selecting Edit. The specified path will be used by Windows and many other programs for temporary files. It's advisable to set the same value (a directory path) for both TMP and TEMP.</li>
                           <li>Any running programs need to be restarted for the new values to take effect. In fact, probably also Windows itself needs to be restarted for it to begin using the new values for its own temporary files.</li>
                        </ol>
                    </li>
                </p>
            </ul>
        </td>
    </tr>
</table>




### Examples

<table>
    <tr>
        <th>:book:</th>
        <td style="padding:6px">To open this code in Windows PowerShell, for instance:</td>
   </tr>
   <tr>
        <th></th>
        <td style="padding:6px">
            <ol>
                <p>
                    <li><code>./Get-DirectorySize</code><br />
                    Run the script. Please notice to insert <code>./</code> or <code>.\</code> before the script name. Uses the default location (<code>$env:temp</code>) for 'listing the contents of' and for storing the generated two files. Lists the folders, which are found on the first level (i.e. search is done nonrecursively, similarly to a common command "<code>dir</code>", for example). The output in the CSV file includes nearly 40 columns of data with each processed folder name as a row, the Out-GridView has about 1/2 of the data and, in essence, the generated HTML Directory Size Report is a summary table with the most relevant information. The HTML Directory Size Report is sorted by Size and ordered as descending as default (the default order for text based columns is ascending).</li>
                </p>
                <p>
                    <li><code>help ./Get-DirectorySize -Full</code><br />
                    Display the help file.</li>
                </p>
                <p>
                    <li><code>./Get-DirectorySize -Path "C:\Windows" -ReportPath "C:\Scripts"</code><br />
                    Run the script and report on all folders in <code>C:\Windows</code>. Save the HTML Directory Size Report and the adjacent CSV-file to <code>C:\Scripts</code>. The output is sorted, as per default, on the raw_size property in an descending order, displaying the largest directories on top and the smallest directories at the bottom.</li>
                </p>
                <p>
                    <li><code>./Get-DirectorySize "C:\dc01","D:\dc04","E:\chiore"</code><br />
                    Run the script and report on all folders, which are found in <code>C:\dc01</code>, <code>D:\dc04</code> and <code>E:\chiore</code>. Please note that the -Path is not mandatory in this example, but it could be included, too, and the quotation marks can be left out since the path names don't contain any space characters (<code>./Get-DirectorySize -Path C:\dc01, D:\dc04, E:\chiore</code>).</li>
                </p>
                <p>
                    <li><code>./Get-DirectorySize -Path E:\chiore -Sort Directory -Descending</code><br />
                    Run the script and report on all the folders in <code>E:\chiore</code>. Sort the data based on the "Directory" column and arrange the rows in the HTML Directory Size Report as descending so that last alphabets come to the top and first alphabets will be at the bottom. To sort the same query in an ascending order the <code>-Descending</code> parameter may be left out from the query command (<code>./Get-DirectorySize -Path E:\chiore -Sort Directory</code>). The sort column name is case-insensitive (as is most of the PowerShell), and since the path name doesn't contain any space characters, it doesn't need to be enveloped with quotation marks. Actually the <code>-Path</code> parameter may be left out from the query command, too, since, for example,
                    <br />
                    <br /><code>./get-directorysize e:\cHIORe -sort directory -descending</code>
                    <br />
                    <br />is the exact same query command in nature.</li>
                </p>
                <p>
                    <li><code>./Get-DirectorySize -Path C:\Users\Dropbox -Recurse -Audio</code><br />
                    Will output a size calculation of <code>C:\Users\Dropbox</code> and include all enclosed sub-directories of the sub-directories of the sub-directories and their sub-directories as well (the search is done recursively). The output is sorted, as per default, on the raw_size property in an descending order, displaying the largest directories on top and the smallest directories at the bottom. After the the script has finished its work, an audible "bell" sound is evoked. Due to the partial automation in Get-DirectorySize, this is the same command as
                    <br />
                    <br /><code>./Get-DirectorySize -Path C:\Users\Dropbox -Sort size -Descending -Recurse -Audio</code>
                    <br />
                    <br />in essence.</li>
                </p>
                <p>
                    <li><code>./Get-DirectorySize -Path C:\Windows -ReportPath C:\Scripts -Sort owner -Descending -Recurse</code><br />
                    Run the script and list recursively all the folders in <code>C:\Windows</code>, so that all sub-folders will get enumerated individually, too. Sort the data in the HTML Directory Size Report by the column name Owner in a descending order, and save the HTML Directory Size Report to <code>C:\Scripts</code>. Please note, that -Path can be omitted in this example, because
                    <br />
                    <br /><code>./Get-DirectorySize C:\Windows -ReportPath C:\Scripts -Sort owner -Descending -Recurse</code>
                    <br />
                    <br />will result in the exact same outcome.</li>
                </p>
                <p>
                    <li><p><code>Set-ExecutionPolicy remotesigned</code><br />
                    This command is altering the Windows PowerShell rights to enable script execution. Windows PowerShell has to be run with elevated rights (run as an administrator) to actually be able to change the script execution properties. The default value is "<code>Set-ExecutionPolicy restricted</code>".</p>
                        <p>Parameters:
                                <ol>
                                    <table>
                                        <tr>
                                            <td style="padding:6px"><code>Restricted</code></td>
                                            <td style="padding:6px">Does not load configuration files or run scripts. Restricted is the default execution policy.</td>
                                        </tr>
                                        <tr>
                                            <td style="padding:6px"><code>AllSigned</code></td>
                                            <td style="padding:6px">Requires that all scripts and configuration files be signed by a trusted publisher, including scripts that you write on the local computer.</td>
                                        </tr>
                                        <tr>
                                            <td style="padding:6px"><code>RemoteSigned</code></td>
                                            <td style="padding:6px">Requires that all scripts and configuration files downloaded from the Internet be signed by a trusted publisher.</td>
                                        </tr>
                                        <tr>
                                            <td style="padding:6px"><code>Unrestricted</code></td>
                                            <td style="padding:6px">Loads all configuration files and runs all scripts. If you run an unsigned script that was downloaded from the Internet, you are prompted for permission before it runs.</td>
                                        </tr>
                                        <tr>
                                            <td style="padding:6px"><code>Bypass</code></td>
                                            <td style="padding:6px">Nothing is blocked and there are no warnings or prompts.</td>
                                        </tr>
                                        <tr>
                                            <td style="padding:6px"><code>Undefined</code></td>
                                            <td style="padding:6px">Removes the currently assigned execution policy from the current scope. This parameter will not remove an execution policy that is set in a Group Policy scope.</td>
                                        </tr>
                                    </table>
                                </ol>
                        </p>
                    <p>For more information, please type "<code>help Set-ExecutionPolicy -Full</code>" or visit <a href="https://technet.microsoft.com/en-us/library/hh849812.aspx">Set-ExecutionPolicy</a>.</p>
                    </li>
                </p>
                <p>
                    <li><code>New-Item -ItemType File -Path C:\Temp\Get-DirectorySize.ps1</code><br />
                    Creates an empty ps1-file to the <code>C:\Temp</code> directory. The <code>New-Item</code> cmdlet has an inherent <code>-NoClobber</code> mode built into it, so that the procedure will halt, if overwriting (replacing the contents) of an existing file is about to happen. Overwriting a file with the <code>New-Item</code> cmdlet requires using the <code>Force</code>.<br />
                    For more information, please type "<code>help New-Item -Full</code>".</li>
                </p>
            </ol>
        </td>
    </tr>
</table>




### Contributing

<p>Find a bug? Have a feature request? Here is how you can contribute to this project:</p>

 <table>
   <tr>
      <th><img class="emoji" title="contributing" alt="contributing" height="28" width="28" align="absmiddle" src="https://assets-cdn.github.com/images/icons/emoji/unicode/1f33f.png"></th>
      <td style="padding:6px"><strong>Bugs:</strong></td>
      <td style="padding:6px"><a href="https://github.com/auberginehill/get-directory-size/issues">Submit bugs</a> and help us verify fixes.</td>
   </tr>
   <tr>
      <th rowspan="2"></th>
      <td style="padding:6px"><strong>Feature Requests:</strong></td>
      <td style="padding:6px">Feature request can be submitted by <a href="https://github.com/auberginehill/get-directory-size/issues">creating an Issue</a>.</td>
   </tr>
   <tr>
      <td style="padding:6px"><strong>Edit Source Files:</strong></td>
      <td style="padding:6px"><a href="https://github.com/auberginehill/get-directory-size/pulls">Submit pull requests</a> for bug fixes and features and discuss existing proposals.</td>
   </tr>
 </table>




### www

<table>
    <tr>
        <th><img class="emoji" title="www" alt="www" height="28" width="28" align="absmiddle" src="https://assets-cdn.github.com/images/icons/emoji/unicode/1f310.png"></th>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-directory-size">Script Homepage</a></td>
    </tr>
    <tr>
        <th rowspan="14"></th>
        <td style="padding:6px">Martin Pugh: <a href="https://community.spiceworks.com/scripts/show/1738-get-foldersizes">Get-FolderSizes</a></td>
    </tr>
    <tr>
        <td style="padding:6px">Joel Reed: <a href="http://2012sg.poshcode.org/4950">Get-DirectorySize</a></td>
    </tr>
    <tr>
        <td style="padding:6px">Brian: <a href="http://brianbunke.com/?p=59">Making PowerShell Emails Pretty</a></td>
    </tr>
    <tr>
        <td style="padding:6px">clayman2: <a href="http://powershell.com/cs/media/p/7476.aspx">DiskSpace</a> (or one of the <a href="https://web.archive.org/web/20150721184135/http://powershell.com/cs/media/p/7476.aspx">archive.org versions</a>)</td>
    </tr>
     <tr>
        <td style="padding:6px">Tobias Weltner: <a href="http://powershell.com/cs/media/p/7476.aspx">PowerTips Monthly Volume 2: Arrays and Hash Tables</a> (or one of the <a href="https://web.archive.org/web/20150714100009/http://powershell.com/cs/media/p/24814.aspx">archive.org versions</a>)</td>
      </tr>
    <tr>
        <td style="padding:6px"><a href="https://technet.microsoft.com/en-us/library/hh849719.aspx">Invoke-Command</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://technet.microsoft.com/en-us/library/hh849912.aspx">Sort-Object</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://technet.microsoft.com/en-us/magazine/hh360993.aspx">Windows PowerShell: Build a Better Function</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://msdn.microsoft.com/en-us/library/ms714434(v=vs.85).aspx">ValidateSet Attribute Declaration</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://technet.microsoft.com/en-us/library/hh847743.aspx">about_Functions_Advanced_Parameters</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="http://social.technet.microsoft.com/wiki/contents/articles/15994.powershell-advanced-function-parameter-attributes.aspx">PowerShell: Advanced Function Parameter Attributes</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://technet.microsoft.com/en-us/library/ee692803.aspx">Working with Hash Tables</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="http://www.techrepublic.com/blog/10-things/10-powershell-commands-every-windows-admin-should-know/">10 PowerShell commands every Windows admin should know</a></td>
    </tr>
    <tr>
        <td style="padding:6px">ASCII Art: <a href="http://www.figlet.org/">http://www.figlet.org/</a> and <a href="http://www.network-science.de/ascii/">ASCII Art Text Generator</a></td>
    </tr>
</table>




### Related scripts

 <table>
    <tr>
        <th><img class="emoji" title="www" alt="www" height="28" width="28" align="absmiddle" src="https://assets-cdn.github.com/images/icons/emoji/unicode/0023-20e3.png"></th>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-battery-info">Get-BatteryInfo</a></td>
    </tr>
    <tr>
        <th rowspan="7"></th>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-computer-info">Get-ComputerInfo</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-installed-programs">Get-InstalledPrograms</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-installed-windows-updates">Get-InstalledWindowsUpdates</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-ram-info">Get-RAMInfo</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://gist.github.com/auberginehill/eb07d0c781c09ea868123bf519374ee8">Get-TimeDifference</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-unused-drive-letters">Get-UnusedDriveLetters</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/update-adobe-flash-player">Update-AdobeFlashPlayer</a></td>
    </tr>
</table>
