VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} ScriptEditor 
   Caption         =   "ScriptEditor"
   ClientHeight    =   9465.001
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   9645.001
   OleObjectBlob   =   "ScriptEditor.frx":0000
   StartUpPosition =   1  '所屬視窗中央
End
Attribute VB_Name = "ScriptEditor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False


Private Sub add_Click()
Dim selected As Boolean
    selected = False
    casenamestate = False
    QuitAPP = False
    
    For i = 0 To CommandList.ListCount - 1
    
        If CommandList.selected(i) = True Then
                
                For k = 0 To StepList.ListCount - 1
                    
                    If CommandList.List(i) = StepList.List(k) Then
                    
                        If StepList.List(k) = "CaseName" Then
                            casenamestate = True
                            x = MsgBox("CaseName已存在", 0 + 64, "Message")
                            Exit For
                        ElseIf StepList.List(k) = "QuitAPP" Then
                            QuitAPP = True
                            x = MsgBox("QuitAPP已存在", 0 + 64, "Message")
                            Exit For
                        End If
                        
                    End If

                Next k
            
                For j = 0 To StepList.ListCount - 1
                
                    If StepList.selected(j) = True Then
                        selected = True
                        Exit For
                    End If
    
                Next j
                
                If selected = True Then
                    If StepList.List(j) <> "CaseName" Then
                        StepList.AddItem CommandList.List(i), j
                        StepList.selected(j + 1) = True
                        'Exit For
                    End If
                Else
                    StepList.AddItem CommandList.List(i), StepList.ListCount - 1
                    'Exit For
                End If
        End If
 
    Next i
End Sub

Private Sub APP_Click()
    CommandList.clear
    j = 2
    Do
        CommandList.AddItem (Sheets("CommandCode").Cells(j, "B"))

    j = j + 1
    Loop Until Sheets("CommandCode").Cells(j, "B") = ""
End Sub

Private Sub cancelSelect_Click()
    For j = 0 To StepList.ListCount - 1
    
        StepList.selected(j) = False
    
    Next j
End Sub

Private Sub CaseBox_Change()
    
    j = 1
    Do
        If Sheets(ScriptBox.Text).Cells(j, "B") = CaseBox.Text Then
            
            i = j
            StepList.clear
            Do
                StepList.AddItem (Sheets(ScriptBox.Text).Cells(i, "A").Value)

                i = i + 1
            Loop Until Sheets(ScriptBox.Text).Cells(i, "A").Value = "CaseName" Or Sheets(ScriptBox.Text).Cells(i, "A").Value = ""
            
            Exit Do
        End If
        
        
    j = j + 1
    Loop Until Sheets(ScriptBox.Text).Cells(j, "A") = ""
    

End Sub

Private Sub CheckBox1_Change()

    If CheckBox1.Value = True Then
        StepList.clear
        StepList.AddItem ("CaseName")
        StepList.AddItem ("QuitAPP")
        CaseBox.Visible = False
        CaseName.Visible = True
        CaseName.Text = ""
        
    
        start_row = Sheets("T1_TestScript").Cells(Sheets("T1_TestScript").Rows.Count, 1).End(xlUp).row
    Else
        StepList.clear
        CaseBox.Visible = True
        CaseName.Visible = False
        CaseName.Text = ""
        
    End If


    
End Sub


Private Sub clear_Click()
    StepList.clear
    StepList.AddItem ("CaseName")
    StepList.AddItem ("QuitAPP")
End Sub

Private Sub ClearElement_Click()
    CommandList.clear
    j = 2
    Do
        CommandList.AddItem (Sheets("CommandCode").Cells(j, "E"))

    j = j + 1
    Loop Until Sheets("CommandCode").Cells(j, "E") = ""
End Sub

Private Sub Click_Click()
    CommandList.clear
    j = 2
    Do
        CommandList.AddItem (Sheets("CommandCode").Cells(j, "C"))

    j = j + 1
    Loop Until Sheets("CommandCode").Cells(j, "C") = ""
End Sub

Private Sub CommandList_Change()
For i = 0 To CommandList.ListCount - 1
    
        If CommandList.selected(i) = True Then
        
        j = 2
        Do
            
            If CommandList.List(i) = Sheets("說明").Cells(j, "A") Then
                    
                    x = Mid(Sheets("說明").Cells(j, "A").NoteText, 12, Len(Sheets("說明").Cells(j, "A").NoteText) - 12 + 1)
                    Exit Do
            End If
            
            j = j + 1
        Loop Until Sheets("說明").Cells(j, "A") = ""
            
            Command.Caption = "Command:" + CommandList.List(i) + vbNewLine + x
            Exit For
        
        End If
        
    Next i
End Sub



Private Sub CreateCase_Click()

    If CheckBox1.Value = True And CaseName.Text <> "" Then
        
        start_row = Sheets(ScriptBox.Text).Cells(Sheets(ScriptBox.Text).Rows.Count, 1).End(xlUp).row + 1
        Sheets(ScriptBox.Text).Cells(start_row, "B") = CaseName.Value
        original_startRow = start_row
        Call importNewStep_2(original_startRow)
        Call importDataFiled(start_row)
        Call Classification_TestCase
        x = MsgBox("Done.", 0 + 64, "Message")
    
    ElseIf CheckBox1.Value = True And CaseName.Text = "" Then
        
         x = MsgBox("請填入Case名稱", 0 + 16, "Error")
    
    ElseIf CheckBox1.Value = False Then
    
        If ScriptBox.Text <> "" And CaseBox.Text <> "" Then
        
            'x = getOldStepData()
            
            startRow = deleteOldStep()
            original_startRow = startRow
            Call importNewStep(original_startRow)
            Call importDataFiled(startRow)
            x = MsgBox("Done.", 0 + 64, "Message")
        
        ElseIf ScriptBox.Text = "" And CaseBox.Text = "" Then
            
            x = MsgBox("請選擇Script及Case", 0 + 16, "Error")
            
        ElseIf ScriptBox.Text = "" Then
            
             x = MsgBox("請選擇Script名稱", 0 + 16, "Error")
            
        ElseIf CaseBox.Text = "" Then
            
             x = MsgBox("請選擇Case名稱", 0 + 16, "Error")
        
        
        End If
    End If
End Sub

Function deleteOldStep()

    i = 1
    Do
        If Sheets(ScriptBox.Text).Cells(i, "B") = CaseBox.Text Then
            Sheets(ScriptBox.Text).Select
            j = i + 1
            Do
            
                Rows(j).Select
                Selection.delete Shift:=xlUp
                
            Loop Until Sheets(ScriptBox.Text).Cells(j, "A") = "QuitAPP"
            Exit Do
        End If
        
        i = i + 1
    Loop Until Sheets(ScriptBox.Text).Cells(i, "A") = ""
    
    deleteOldStep = j

End Function

Sub importNewStep(starRow)
   
    Sheets(ScriptBox.Text).Select
    
    For j = 1 To StepList.ListCount - 2
    
        Rows(starRow).Select
        Selection.Insert Shift:=xlDown, CopyOrigin:=xlFormatFromLeftOrAbove
        
        Sheets(ScriptBox.Text).Cells(starRow, 1) = StepList.List(j)
        starRow = starRow + 1
        
    Next j
          
End Sub

Sub importNewStep_2(starRow)
   
    Sheets(ScriptBox.Text).Select
    
    For j = 0 To StepList.ListCount - 1
    
        'Rows(starRow).Select
        'Selection.Insert Shift:=xlDown, CopyOrigin:=xlFormatFromLeftOrAbove
        
        Sheets(ScriptBox.Text).Cells(starRow, 1) = StepList.List(j)
        starRow = starRow + 1
        
    Next j
          
End Sub
Sub importDataFiled(startj)


    x = ScriptBox.Text
    Sheets(ScriptBox.Text).Select
    j = startj
    'j = Sheets(scriptname.Text).Cells(Sheets(scriptname.Text).Rows.Count, 1).End(xlUp).row
    Do
        i = 3
        Do
            If Sheets(ScriptBox.Text).Cells(j, "A") = Sheets("說明").Cells(i, "A") Then
                
                k = 2
                Do Until Sheets("說明").Cells(i, k) = ""
                    
                    Sheets(ScriptBox.Text).Cells(j, k).Select
                    Call line
                    k = k + 1
                Loop
                Exit Do
            End If
            i = i + 1
        Loop Until Sheets("說明").Cells(i, "A") = ""
    
        j = j + 1
    Loop Until Sheets(ScriptBox.Text).Cells(j, "A") = ""
    
End Sub
Function getOldStepData()
    Dim stepArray()
    i = 1
    Do
        If Sheets(ScriptBox.Text).Cells(1, "B") = CaseBox.Text Then
            
            j = i + 1: Index = 0
            Do
                k = 1
                Do
                    ReDim Preserve stepArray(Index)
                    stepArray(Index) = Sheets(ScriptBox.Text).Cells(j, k).Text
                    k = k + 1
                    Index = Index + 1
                Loop Until Sheets(ScriptBox.Text).Cells(j, k) = ""
            
                j = j + 1
            Loop Until Sheets(ScriptBox.Text).Cells(j, "A").Value = "CaseName" Or Sheets(ScriptBox.Text).Cells(j, "A").Value = ""
            Exit Do
        End If
    
    
        i = i + 1
    Loop Until Sheets(ScriptBox.Text).Cells(i, "A") = ""

    getOldStepData = stepArray()


End Function

Private Sub delete_Click()

    For i = 0 To StepList.ListCount - 1
    
        If StepList.selected(i) = True Then
            If StepList.List(i) <> "CaseName" And StepList.List(i) <> "QuitAPP" Then
                StepList.RemoveItem (i)
                StepList.selected(i) = False
            End If
            
        End If
    
    Next i
    
End Sub

Private Sub down_Click()
    For i = StepList.ListCount - 1 To 0 Step -1
    
        If StepList.ListIndex <> StepList.ListCount - 1 And StepList.selected(i) = True And StepList.ListIndex <> StepList.ListCount - 2 And StepList.List(i) <> "CaseName" Then
        
            temp = StepList.List(i)
            StepList.RemoveItem (i)
            StepList.AddItem temp, i + 1
            StepList.selected(i + 1) = True
            Exit For
            
        End If
        
    Next i
End Sub

Private Sub Invisibility_Click()
    CommandList.clear
    j = 2
    Do
        CommandList.AddItem (Sheets("CommandCode").Cells(j, "H"))

    j = j + 1
    Loop Until Sheets("CommandCode").Cells(j, "H") = ""
End Sub

Private Sub Others_Click()
    CommandList.clear
    j = 2
    Do
        CommandList.AddItem (Sheets("CommandCode").Cells(j, "K"))

    j = j + 1
    Loop Until Sheets("CommandCode").Cells(j, "K") = ""
End Sub

Private Sub ScriptBox_Change()
    CaseBox.clear
    StepList.clear
    j = 1
    Do
        If Sheets(ScriptBox.Text).Cells(j, "A") = "CaseName" Then
        
          CaseBox.AddItem (Sheets(ScriptBox.Text).Cells(j, "B"))
        
        End If
        
    
    j = j + 1
    Loop Until Sheets(ScriptBox.Text).Cells(j, "A") = ""
        
        
End Sub

Private Sub ScriptBox_Click()
   
    
End Sub

Private Sub SendKey_Click()
    CommandList.clear
    j = 2
    Do
        CommandList.AddItem (Sheets("CommandCode").Cells(j, "D"))

    j = j + 1
    Loop Until Sheets("CommandCode").Cells(j, "D") = ""
End Sub

Private Sub StepList_Change()
 For i = 0 To StepList.ListCount - 1
    
        If StepList.selected(i) = True Then
            
            StepCommand.Caption = "Command:" + StepList.List(i)
            Exit For
        End If
    Next i
End Sub



Private Sub Swipe_Click()
    CommandList.clear
    j = 2
    Do
        CommandList.AddItem (Sheets("CommandCode").Cells(j, "G"))

    j = j + 1
    Loop Until Sheets("CommandCode").Cells(j, "G") = ""
End Sub

Private Sub System_Click()
    CommandList.clear
    j = 2
    Do
        CommandList.AddItem (Sheets("CommandCode").Cells(j, "J"))

    j = j + 1
    Loop Until Sheets("CommandCode").Cells(j, "J") = ""
End Sub

Private Sub up_Click()
    For i = 0 To StepList.ListCount - 1
    
        If StepList.ListIndex > 0 And StepList.selected(i) = True And StepList.ListIndex <> 1 And StepList.List(i) <> "QuitAPP" Then
        
            temp = StepList.List(i)
            StepList.RemoveItem (i)
            StepList.AddItem temp, i - 1
            StepList.selected(i - 1) = True
            Exit For
            
        End If
        
    Next i
End Sub

Private Sub UserForm_Activate()
    ScriptBox.clear
    CaseName.Visible = False
    CaseName.Text = ""
    i = 0
    Do
        If ThisWorkbook.Sheets(i + 1).Visible = True And Right(ThisWorkbook.Sheets(i + 1).Name, 11) = "_TestScript" Then
            ScriptBox.AddItem (ThisWorkbook.Sheets(i + 1).Name)
        End If
    
    i = i + 1
    Loop Until i = ThisWorkbook.Sheets.Count
End Sub

Private Sub Verify_Click()
    CommandList.clear
    j = 2
    Do
        CommandList.AddItem (Sheets("CommandCode").Cells(j, "I"))

    j = j + 1
    Loop Until Sheets("CommandCode").Cells(j, "I") = ""
End Sub

Private Sub Wait_Click()
    CommandList.clear
    j = 2
    Do
        CommandList.AddItem (Sheets("CommandCode").Cells(j, "F"))

    j = j + 1
    Loop Until Sheets("CommandCode").Cells(j, "F") = ""
End Sub
Sub line()
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlDashDot
        .ColorIndex = xlAutomatic
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlDashDot
        .ColorIndex = xlAutomatic
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlDashDot
        .ColorIndex = xlAutomatic
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlDashDot
        .ColorIndex = xlAutomatic
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    Selection.Borders(xlInsideVertical).LineStyle = xlNone
    Selection.Borders(xlInsideHorizontal).LineStyle = xlNone
End Sub
