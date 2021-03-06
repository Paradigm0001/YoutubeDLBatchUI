@echo off
youtube-dl.exe -U >nul 2>&1
setlocal enabledelayedexpansion
set VERBOSE_STATE=Disabled
title Youtube Video Downloader GUI
if not exist "%CD%\credit" (
	echo This application was not created by me
	echo:
	echo This is just a simple GUI for it, you can find the original at: https://youtube-dl.org/
	pause
	echo Paradigm#0001 on discord>credit
	cls
)
:menu
mode 75, 10
echo 1. Download Youtube video
echo 2. Download Youtube audio
echo 3. Download audio and subtitles
echo 4. Toggle Debug mode [Currently !VERBOSE_STATE!]
echo 5. Manual mode
echo:
echo:
echo 8. Open Output folder
echo 9. Display help [Opens external text editor]
choice /c 123456789 /n /m "Select an option: "
cls
if %ERRORLEVEL%==1 (
	echo [To save to default dir; input nothing][Default save dir below:]
    echo "%CD%\output"
    echo:
	if not defined SAVE_DIR set SAVE_DIR=./output
    set /p SAVE_DIR="Please enter a save directory: "    
    cls
	set /p VIDEO_URL="Please insert video URL: "
	mode 75, 50
	youtube-dl.exe -i %VERBOSE% -w --geo-bypass --yes-playlist --age-limit 25 -o "!SAVE_DIR!/%%(title)s.%%(ext)s" --console-title !VIDEO_URL!
	pause
	mode 75, 11
	title Youtube Video Downloader GUI
	goto menu
) else if %ERRORLEVEL%==2 (
    :audio_download
	set AUDIO_pass=0
    echo [Type "list" for a list of accepted formats]
    set /p FORMAT="Enter the desired format: "
    if /i !FORMAT!==list (
    	cls
    	echo Accepted formats [Highest quallity to lowest]:
        echo [Type "Best" to auto-select best format]
    	echo aac
    	echo flac
    	echo wav
    	echo m4a
    	echo opus
    	echo vorbis^[OGG^]
    	echo mp3
    	pause
    	cls
    	set FORMAT=
    	goto audio_download
    )
    if /i !FORMAT!==best (
    	set AUDIO_pass=1
		set FORMAT=flac
    ) else if /i !FORMAT!==aac (
    	set AUDIO_pass=1
    ) else if /i !FORMAT!==flac (
    	set AUDIO_pass=1
    ) else if /i !FORMAT!==wav (
    	set AUDIO_pass=1
    ) else if /i !FORMAT!==m4a (
    	set AUDIO_pass=1
    ) else if /i !FORMAT!==opus (
    	set AUDIO_pass=1
    ) else if /i !FORMAT!==vorbis (
    	set AUDIO_pass=1
    ) else if /i !FORMAT!==mp3 (
    	set AUDIO_pass=1
    )
    if !AUDIO_pass!==1 (
    	goto :AUDIO_pass
    )
    cls & echo Invalid format selected & pause & cls & goto audio_download
    :AUDIO_pass
    set "FORMAT=--audio-format !FORMAT!"
    cls
    set /p Audio_Quallity="Enter audio quallity [0 to 9; 0 best, 9 worse]: "
    cls
    echo [To save to default dir; input nothing][Default save dir below:]
    echo "%CD%\output"
    echo:
    if not defined SAVE_DIR set SAVE_DIR=./output
    set /p SAVE_DIR="Please enter a save directory: "    
    cls
    set /p VIDEO_URL="Please insert video URL: "
    mode 75, 50
    youtube-dl.exe -x -i !VERBOSE! --ffmpeg-location "%cd%\FFmpeg\bin\ffmpeg.exe" !FORMAT! --audio-quality !Audio_Quallity! !SUBTITLES! -w -o "!SAVE_DIR!/%%(title)s.%%(ext)s" --ignore-config --geo-bypass --yes-playlist --age-limit 25 --console-title !VIDEO_URL!
    set FORMAT=
	set Audio_Quallity=
	set SAVE_DIR=
	set VIDEO_URL=
	set SUBTITLES=
	mode 75, 11
    title Youtube Video Downloader GUI          
    goto menu
) else if %ERRORLEVEL%==3 (
	set "SUBTITLES=--write-sub --sub-format srt"
	goto audio_download
) else if %ERRORLEVEL%==4 (
	if %VERBOSE_STATE%==Disabled (
		set "VERBOSE=-v" & set "VERBOSE_STATE=Enabled"
	) else set "VERBOSE=" & set "VERBOSE_STATE=Disabled"
	goto menu
) else if %ERRORLEVEL%==5 (
    :MANUAL_download
    echo [Type "Help" to display help [Opens external text editor]
    echo [Type "Menu" to return to main menu]
    set /p MANUAL="Enter arguements and a video URL: "
    if /i !MANUAL!==help (
        youtube-dl.exe -h>>temp.txt
	    start temp.txt
	    ping 127.0.0.1 -n 2 >nul
	    del temp.txt
        cls & goto MANUAL_download
    )
    if /i !MANUAL!==menu cls & goto menu
    youtube-dl.exe !VERBOSE! --ffmpeg-location "%cd%\FFmpeg\bin\ffmpeg.exe" !MANUAL!
    echo:
    :MANUAL_download_error
    echo 1. Return to menu
    echo 2. Return to manual mode
    choice /c 12 /n /m "Select an option: "
    cls
    if !ERRORLEVEL!==1 (
        goto menu    
    ) else goto MANUAL_download
) else if %ERRORLEVEL%==8 (
    start "" "%cd%\output"
    goto menu
) else if %ERRORLEVEL%==9 (
	youtube-dl.exe -h>>temp.txt
	start temp.txt
	ping 127.0.0.1 -n 2 >nul
	del temp.txt
	goto menu
)
    