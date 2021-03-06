#requires -Version 2

########################################################
# Code Generated By: Milan Bozic, Control Esc Ltd. v1.0
########################################################

#Connect to MSOL service
$LiveCred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic -AllowRedirection
Import-PSSession $Session

#Generated Form Function
function GenerateForm {

#region Import the Assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
#endregion

#region Generated Form Objects
$form1 = New-Object System.Windows.Forms.Form
$groupBox2 = New-Object System.Windows.Forms.GroupBox
$checkBoxWhatif = New-Object System.Windows.Forms.CheckBox
$radioButtonRemoveMbxPermission = New-Object System.Windows.Forms.RadioButton
$radioButtonAddMbxPermission = New-Object System.Windows.Forms.RadioButton
$buttonRun = New-Object System.Windows.Forms.Button
$groupBox1 = New-Object System.Windows.Forms.GroupBox
$radioButtonDeny = New-Object System.Windows.Forms.RadioButton
$radioButtonAllow = New-Object System.Windows.Forms.RadioButton
$textBoxUser = New-Object System.Windows.Forms.TextBox
$label5 = New-Object System.Windows.Forms.Label
$comboBoxAccessRights = New-Object System.Windows.Forms.ComboBox
$label4 = New-Object System.Windows.Forms.Label
$textboxMailboxFilter = New-Object System.Windows.Forms.TextBox
$label3 = New-Object System.Windows.Forms.Label
$groupBox3 = New-Object System.Windows.Forms.GroupBox
$label2 = New-Object System.Windows.Forms.Label
$label1 = New-Object System.Windows.Forms.Label
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
#endregion Generated Form Objects

#Form Actions
$handler_form1_Load= 
{
	#Verify the connection between Windows PowerShell and Office 365
	$existingSession = Get-PSSession -Verbose:$false | Where-Object {$_.ConfigurationName -eq "Microsoft.Exchange"}
	if ($existingSession -ne $null) {
		$form1.Text = $Messages.FormTextConnected
		$textboxMailboxFilter.Enabled = $true
		$textBoxUser.Enabled = $true
	}
}

$handler_buttonRun_Click= 
{
	#Verify the parameters
	$rawParams = @{}
	$rawParams.Add("MailboxFilter",$textboxMailboxFilter.Text)
	$rawParams.Add("User",$textboxUser.Text)
	$rawParams.Add("AccessRights",$comboBoxAccessRights.Text)
	foreach ($rawParam in $rawParams.GetEnumerator()) {
		if ([System.String]::IsNullOrEmpty($rawParam.Value)) {
			if ($existingSession -ne $null) {
				$errorMsgCaption = $Messages.InvalidParamsCaption
				$errorMsg = $Messages.InvalidParamsMessage
				$errorMsg = $errorMsg -replace "Placeholder01",$($rawParam.Name)
				[System.Windows.Forms.MessageBox]::Show($errorMsg,$errorMsgCaption,"OK","Error")			
				$verifiedParams = $false
				break			
			}
		} else {
			$verifiedParams = $true
		}
	}
			#Try to get mailboxes by using specified filter
			Try
			{
				$mailboxes = Get-Mailbox -Filter $rawParams["MailboxFilter"] -ResultSize unlimited
			}
			Catch
			{
				Write-Error $Error[0]
			}
			#Begin to modify mailbox permission
			if ($mailboxes -ne $null) {
				$user = $rawParams["User"]
				$accessRights = $rawParams["AccessRights"]
				if ($radioButtonAllow.Checked) {
					$cmdParams = "-User $user -AccessRights $accessRights"
				} else {
					$cmdParams = "-User $user -AccessRights $accessRights -Deny"
				}
				foreach ($mailbox in $mailboxes) {
					if ($checkBoxWhatif.Checked) {
						if ($radioButtonAddMbxPermission.Checked) {
							$outputMsg = $Messages.InvokingCommand
							$outputMsg = $outputMsg -replace "Placeholder01","Add-MailboxPermission -Identity $($mailbox.Alias) $cmdParams -Whatif"
							Write-Host $outputMsg
							Invoke-Expression -Command "Add-MailboxPermission -Identity $($mailbox.Alias) $cmdParams -Whatif"
						} else {
							$outputMsg = $Messages.InvokingCommand
							$outputMsg = $outputMsg -replace "Placeholder01","Remove-MailboxPermission -Identity $($mailbox.Alias) $cmdParams -Whatif"
							Write-Host $outputMsg						
							Invoke-Expression -Command "Remove-MailboxPermission -Identity $($mailbox.Alias) $cmdParams -Whatif"
						}
					} else {
						if ($radioButtonAddMbxPermission.Checked) {
							$outputMsg = $Messages.InvokingCommand
							$outputMsg = $outputMsg -replace "Placeholder01","Add-MailboxPermission -Identity $($mailbox.Alias) $cmdParams"
							Write-Host $outputMsg
							Invoke-Expression -Command "Add-MailboxPermission -Identity $($mailbox.Alias) $cmdParams"
						} else {
							$outputMsg = $Messages.InvokingCommand
							$outputMsg = $outputMsg -replace "Placeholder01","Remove-MailboxPermission -Identity $($mailbox.Alias) $cmdParams -Confirm:`$false"
							Write-Host $outputMsg						
							Invoke-Expression -Command "Remove-MailboxPermission -Identity $($mailbox.Alias) $cmdParams -Confirm:`$false"
						}
					}
				}
				if (-not $checkBoxWhatif.Checked){
					#Reset GUI objects to initial state
					$textboxMailboxFilter.Text = ""
					$textBoxUser.Text = ""
					$comboBoxAccessRights.ResetText()
					$radioButtonAllow.Checked = $true
					$radioButtonAddMbxPermission.Checked = $true
					$checkBoxWhatif.Checked = $true
				}
			}
}

$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
	$form1.WindowState = $InitialFormWindowState
}

#----------------------------------------------
#region Generated Form Code
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 291
$System_Drawing_Size.Width = 594
$form1.ClientSize = $System_Drawing_Size
$form1.DataBindings.DefaultDataSourceUpdateMode = 0
$form1.FormBorderStyle = 1
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = -15
$System_Drawing_Point.Y = -134
$form1.Location = $System_Drawing_Point
$form1.MaximizeBox = $False
$form1.Name = "form1"
$form1.Text = "Modify Office 365 Mailbox Permission"
$form1.add_Load($handler_form1_Load)

$groupBox2.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 203
$groupBox2.Location = $System_Drawing_Point
$groupBox2.Name = "groupBox2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 50
$System_Drawing_Size.Width = 570
$groupBox2.Size = $System_Drawing_Size
$groupBox2.TabIndex = 27
$groupBox2.TabStop = $False
$groupBox2.Text = "Operation"

$form1.Controls.Add($groupBox2)
$checkBoxWhatif.AutoSize = $True

$checkBoxWhatif.Checked = $True
$checkBoxWhatif.CheckState = 1
$checkBoxWhatif.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 348
$System_Drawing_Point.Y = 20
$checkBoxWhatif.Location = $System_Drawing_Point
$checkBoxWhatif.Name = "checkBoxWhatif"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 17
$System_Drawing_Size.Width = 60
$checkBoxWhatif.Size = $System_Drawing_Size
$checkBoxWhatif.TabIndex = 10
$checkBoxWhatif.Text = "-Whatif"
$checkBoxWhatif.UseVisualStyleBackColor = $True

$groupBox2.Controls.Add($checkBoxWhatif)

$radioButtonRemoveMbxPermission.AutoSize = $True

$radioButtonRemoveMbxPermission.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 162
$System_Drawing_Point.Y = 19
$radioButtonRemoveMbxPermission.Location = $System_Drawing_Point
$radioButtonRemoveMbxPermission.Name = "radioButtonRemoveMbxPermission"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 17
$System_Drawing_Size.Width = 157
$radioButtonRemoveMbxPermission.Size = $System_Drawing_Size
$radioButtonRemoveMbxPermission.TabIndex = 9
$radioButtonRemoveMbxPermission.Text = "Remove Mailbox Permission"
$radioButtonRemoveMbxPermission.UseVisualStyleBackColor = $True

$groupBox2.Controls.Add($radioButtonRemoveMbxPermission)

$radioButtonAddMbxPermission.AutoSize = $True

$radioButtonAddMbxPermission.Checked = $True
$radioButtonAddMbxPermission.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 8
$System_Drawing_Point.Y = 19
$radioButtonAddMbxPermission.Location = $System_Drawing_Point
$radioButtonAddMbxPermission.Name = "radioButtonAddMbxPermission"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 17
$System_Drawing_Size.Width = 136
$radioButtonAddMbxPermission.Size = $System_Drawing_Size
$radioButtonAddMbxPermission.TabIndex = 8
$radioButtonAddMbxPermission.TabStop = $True
$radioButtonAddMbxPermission.Text = "Add Mailbox Permission"
$radioButtonAddMbxPermission.UseVisualStyleBackColor = $True

$groupBox2.Controls.Add($radioButtonAddMbxPermission)

$buttonRun.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 256
$System_Drawing_Point.Y = 259
$buttonRun.Location = $System_Drawing_Point
$buttonRun.Name = "buttonRun"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 75
$buttonRun.Size = $System_Drawing_Size
$buttonRun.TabIndex = 11
$buttonRun.Text = "Run"
$buttonRun.UseVisualStyleBackColor = $True
$buttonRun.add_Click($handler_buttonRun_Click)

$form1.Controls.Add($buttonRun)

$groupBox1.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 91
$groupBox1.Location = $System_Drawing_Point
$groupBox1.Name = "groupBox2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 106
$System_Drawing_Size.Width = 570
$groupBox1.Size = $System_Drawing_Size
$groupBox1.TabIndex = 23
$groupBox1.TabStop = $False
$groupBox1.Text = "Parameters"

$form1.Controls.Add($groupBox1)

$radioButtonDeny.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 458
$System_Drawing_Point.Y = 72
$radioButtonDeny.Location = $System_Drawing_Point
$radioButtonDeny.Name = "radioButtonDeny"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 104
$radioButtonDeny.Size = $System_Drawing_Size
$radioButtonDeny.TabIndex = 7
$radioButtonDeny.Text = "Deny"
$radioButtonDeny.UseVisualStyleBackColor = $True

$groupBox1.Controls.Add($radioButtonDeny)

$radioButtonAllow.Checked = $True
$radioButtonAllow.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 348
$System_Drawing_Point.Y = 72
$radioButtonAllow.Location = $System_Drawing_Point
$radioButtonAllow.Name = "radioButtonAllow"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 104
$radioButtonAllow.Size = $System_Drawing_Size
$radioButtonAllow.TabIndex = 6
$radioButtonAllow.TabStop = $True
$radioButtonAllow.Text = "Allow"
$radioButtonAllow.UseVisualStyleBackColor = $True

$groupBox1.Controls.Add($radioButtonAllow)

$textBoxUser.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 87
$System_Drawing_Point.Y = 46
$textBoxUser.Location = $System_Drawing_Point
$textBoxUser.Name = "textBoxUser"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 475
$textBoxUser.Size = $System_Drawing_Size
$textBoxUser.TabIndex = 4

$groupBox1.Controls.Add($textBoxUser)

$label5.AutoSize = $True
$label5.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 7
$System_Drawing_Point.Y = 75
$label5.Location = $System_Drawing_Point
$label5.Name = "label5"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 13
$System_Drawing_Size.Width = 78
$label5.Size = $System_Drawing_Size
$label5.TabIndex = 26
$label5.Text = "Access Rights:"

$groupBox1.Controls.Add($label5)

$comboBoxAccessRights.DataBindings.DefaultDataSourceUpdateMode = 0
$comboBoxAccessRights.DropDownHeight = 110
$comboBoxAccessRights.DropDownStyle = 2
$comboBoxAccessRights.DropDownWidth = 190
$comboBoxAccessRights.FormattingEnabled = $True
$comboBoxAccessRights.IntegralHeight = $False
$comboBoxAccessRights.Items.Add("")|Out-Null
$comboBoxAccessRights.Items.Add("FullAccess")|Out-Null
$comboBoxAccessRights.Items.Add("ExternalAccount")|Out-Null
$comboBoxAccessRights.Items.Add("DeleteItem")|Out-Null
$comboBoxAccessRights.Items.Add("ReadPermission")|Out-Null
$comboBoxAccessRights.Items.Add("ChangePermission")|Out-Null
$comboBoxAccessRights.Items.Add("ChangeOwner")|Out-Null
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 87
$System_Drawing_Point.Y = 72
$comboBoxAccessRights.Location = $System_Drawing_Point
$comboBoxAccessRights.Name = "comboBoxAccessRights"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 21
$System_Drawing_Size.Width = 232
$comboBoxAccessRights.Size = $System_Drawing_Size
$comboBoxAccessRights.TabIndex = 5

$groupBox1.Controls.Add($comboBoxAccessRights)

$label4.AutoSize = $True
$label4.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 7
$System_Drawing_Point.Y = 49
$label4.Location = $System_Drawing_Point
$label4.Name = "label4"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 13
$System_Drawing_Size.Width = 32
$label4.Size = $System_Drawing_Size
$label4.TabIndex = 25
$label4.Text = "User (Alias):"

$groupBox1.Controls.Add($label4)

$textboxMailboxFilter.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 87
$System_Drawing_Point.Y = 19
$textboxMailboxFilter.Location = $System_Drawing_Point
$textboxMailboxFilter.Name = "textboxMailboxFilter"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 475
$textboxMailboxFilter.Size = $System_Drawing_Size
$textboxMailboxFilter.TabIndex = 3

$groupBox1.Controls.Add($textboxMailboxFilter)

$label3.AutoSize = $True
$label3.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 7
$System_Drawing_Point.Y = 22
$label3.Location = $System_Drawing_Point
$label3.Name = "label3"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 13
$System_Drawing_Size.Width = 71
$label3.Size = $System_Drawing_Size
$label3.TabIndex = 24
$label3.Text = "Mailbox Filter:"

$groupBox1.Controls.Add($label3)

$groupBox3.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 12
$groupBox3.Location = $System_Drawing_Point
$groupBox3.Name = "groupBox3"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 73
$System_Drawing_Size.Width = 570
$groupBox3.Size = $System_Drawing_Size
$groupBox3.TabIndex = 20
$groupBox3.TabStop = $False
$groupBox3.Text = "Office 365 administration"

$form1.Controls.Add($groupBox3)

$label2.AutoSize = $True
$label2.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 6
$System_Drawing_Point.Y = 41
$label2.Location = $System_Drawing_Point
$label2.Name = "label2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 75
$label2.Size = $System_Drawing_Size
$label2.TabIndex = 22
$label2.Text = "Control Esc Ltd."

$groupBox3.Controls.Add($label2)

$label1.AutoSize = $True
$label1.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 6
$System_Drawing_Point.Y = 19
$label1.Location = $System_Drawing_Point
$label1.Name = "label1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 15
$System_Drawing_Size.Width = 75
$label1.Size = $System_Drawing_Size
$label1.TabIndex = 21
$label1.Text = "Ownership:"

$groupBox3.Controls.Add($label1)

#endregion Generated Form Code

#Show the Form
$form1.ShowDialog()| Out-Null

} #End Function

#Call the Function
GenerateForm
