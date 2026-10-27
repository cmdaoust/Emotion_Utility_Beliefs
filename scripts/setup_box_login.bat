@echo off
rem One-time setup: saves the Box SFTP login (encrypted) for this Windows user.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup_box_login.ps1"
