# Backup and restore Google Chrome sessions

There are simply Linux shell scripts for backup and restore of crashed Google Chrome and its user's _lost_ windows and tabs in them. This may be useful in case if Chrome's original restore operation didn't succeed. By restoring the Chrome sessions this low-level way you will get all windows (with their given _names_) and tabs in them, including the tabs groupping.

## Install

Download two scripts from this git repository: `google-chrome-backup.sh` and `google-chrome-restore.sh`.

Copy the scripts to your user home directory.
```bash
cp google-chrome-backup.sh ~/
cp google-chrome-restore.sh ~/

```

Setup the shell to run backup on each login of your user - add to your `.profile` file:
```bash
# Personal Chrome sessions backup
~/google-chrome-backup.sh

``` 

Run first backup manually by executing the script `google-chrome-backup.sh`.

Scripts tested on the official Chrome Version 115.0.

## How it works

The scripts idea is based on [this user approach](https://support.google.com/chrome/thread/81479649?hl=en&msgid=98191223) from the Chrome community.

Chrome keeps its sessions stored in `~/.config/google-chrome/Default/Sessions` folder on Linux. So we copy them on each user login into our own backup folder, into  `~/backup/google-chrome/Default/backup-1/Sessions`. This work done by the `google-chrome-backup.sh` script invoked by bash's `.profile`. The script maintains last 5 backups, by rotating them in folders from `backup-1` - the latest one, to `backup-5` - the oldest respectively.

The restore script `google-chrome-restore.sh` will preserve the Chrome current sessions into `~/.config/google-chrome/Default/Sessions.prev` folder and restore the latest backup from `~/backup/google-chrome/Default/backup-1/Sessions`.

## In case of Chrome crash

### First rely on Chrome itself

A first thing to do after your Chrome crashed - try restore it by starting it again and apply for previous session restoration popup. In most of cases, it will do the job.

But if it hasn't for any reason, just be careful __to do not start it again__, instead go to Chrome's sessions folder in `~/.config/google-chrome/Default/Sessions` and remove manually the most fresh `Session_xxx` file. Then start the browser again. 

If it restores your windows and tabs then you already set and problem is solved. If this didn't happen, may be you have tried to start the Chrome several times or something else prevented it, then proceed with the backup restoration as described below.

### Try the restore script

If your Chrome didn't restore your windows/tabs and doesn't propose to do this at a next start, you need to restore the previous session from the backups made by this script. 

First, __ensure Chrome browser isn't running for your user__! Close all Chrome windows, shutdown all its processes!

On Linux/Unix you may run shell commands to find and then *kill* your Chrome stuff:
```bash
$ ps -A | grep chrome
  609 tty2     00:00:27 chrome
  618 ?        00:00:00 chrome_crashpad
  620 ?        00:00:00 chrome_crashpad
  626 tty2     00:00:00 chrome
  631 tty2     00:00:00 chrome
....
$ kill -KILL 609
``` 

> [!IMPORTANT] 
> You may need check several times to shutdown all Chrome processes.
> It's crucially important to restore (by the script or manually) only against the fully stopped browser!

Use the restore script by simply invoking it `google-chrome-restore.sh`. It will replace the Chrome sessions with one copied on your user last login. 

Next, start the Chrome and check if your windows/tabs can be restored. This may happen automatically or the browser will ask to do so. If not restored, close the browser and apply the step described for Chrome's way above: go to Chrome's sessions folder in `~/.config/google-chrome/Default/Sessions` and remove manually the most fresh `Session_xxx` file. 

Then start the browser again - your stuff can be restored after this. But if not, then try luck with older backups manually.

### Manually copy older backups
 
If for any reason, the lost windows/pages unable to restored from the latest backup (`backup-1` folder), then try manually to copy the sessions from the older backup folders (`backup-2`, `backup-3` etc).

### If nothing helped...

Chrome has History with your [latest tabs](https://blog.google/products/chrome/restore-browser-tabs/) closed (see in the menu with three dots), you may restore each tabs set from there. Window _names will not be restored_, but tabs groups will. This is better of losing everything.

## Cautions

Several things to consider:

1. If Chrome crashed but you didn't restored your stuff immediatelly (or recently), and continue to use the browser. Then each next user login will create a backup of this new Chrome state (without your tabs) and the older backup (with your windows/tabs) will rotate and soon will be removed as obsolete. You will not be able to restore your stuff after that.
2. Chrome sessions backups may be space consuming, do not need to maintain them to many. The backup script maintain 5 last backups by default. You may modify it to 10 or like that, but larger history hardly useful.
3. Chrome may change its internal folder structure/naming and this solution will stop to work.
4. The backup/restore scripts report to the system logs facts of their execution. You may explore the system journal to find those logs. 
