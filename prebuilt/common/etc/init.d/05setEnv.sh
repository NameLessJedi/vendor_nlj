#!/system/bin/sh -x
# 2011-01-13 Firerat
# check /cache size and set dexopt-data-only if too 'small'

# setup busybox aliases
alias mount="busybox mount"
alias grep="busybox grep"
alias sed="busybox sed"
alias install="busybox install"
alias printf="busybox printf"
alias awk="busybox awk"
alias mv="busybox mv"
alias du="busybox du"
alias df="busybox df"

# capture args
me="$0"
OPT="$1"

# total dex seems to be approx the same size as total apks
# all a bit rough
ignorelist=`find /system -name "*.odex" -exec basename {} .odex \;|awk '{printf "|"$0}'|sed s/\|//`

if [ "$ignorelist" = "" ];
then
    ignorelist=NoMatches
fi

MinCacheSize=$(du -c `find /system/ -name "*.apk" -o -name "*.jar"`|grep -vE "$ignorelist"|awk '$2 == "total" {printf $1*1229}')

# 1229 and not 1024, to give some play room

# get cache size ( bytes ) from /proc/mtd
CacheSizeBytes=$(printf %d `awk '/cache/ {print "0x"$2}' /proc/mtd`)
# we have assumed cache is either empty, or already has dex on it
mountsystem ()
{
mount -o $1,remount /system
return
}
Exit ()
{
# make sure system is ro before exiting
sync
mountsystem ro
# hmm, not working all that well, something is locking system in rw mode O_O;
exit
}
System_dex_loc () {
SetSystemDexLoc ()
{
# clean build.prop(s)
for prop in $(ls /system/*prop);do
    if [ "$(grep -q "dalvik.vm.dexopt-data-only" ${prop};echo $?)" = "0" ];
    then
        mountsystem rw
        sed '/dalvik.vm.dexopt-data-only/ d' -i ${prop}
    fi
setprop dalvik.vm.dexopt-data-only $1
done
# make sure dirs exist
for rootdir in data cache;do
    if [ ! -d "/${rootdir}/dalvik-cache" ];
    then
        install -m 771 -o 1000 -g 1000 -d /${rootdir}/dalvik-cache
    fi
done
return
}

TestCacheSize ()
{
if [ "$CacheSizeBytes" -lt "$MinCacheSize" ];
then
    log -p e -t `basename $me` "system dex to be kept on /data"
    SetSystemDexLoc 1
else
    log -p e -t `basename $me` "system dex to be kept on /cache"
    SetSystemDexLoc null
fi
return
}

TestCacheSize
# TODO add logcat spew
# TODO add in vendor/app dex
# if for instance gapps go to vendor, then their dex may fit cache
# will require additional code in frameworks/base
return
}

download_cache_loc () {
    # Script for setting download cache location
avail ()
{
partition=`echo $1|sed s/[^a-zA-Z0-9]//g`
eval ${partition}_free=$(df |sed 's/^\ /\/dev\/fake/'|awk '$NF == "/'$1'" {printf $4}')
# the dev fake thing is a quick hack to get round vold mounts
# needed so the download_cache loc doesnt get screwed if someone plays about with this script
# i.e. they are setting ddb 
eval checkzero=\$${partition}_free
echo $partition $checkzero
if [ "$checkzero" = "" ];
then
    eval ${partition}_free="0"
fi
}
for partition in data cache ;do
    avail $partition
done
#prioritise the sd-ext ( if avialable )
# only use data if cache is too small
minDLCache=`expr 50 \* 1024` # 50mb , max market d/l is currently 50mb
#TODO check is sysdex will be going to cache
if [ "$cache_free" -lt "$minDLCache" -a "$data_free" -gt "`expr $cache_free \* 2`" -o "$data_free" -gt "`expr $minDLCache \* 2`" ];
then
    AltDownloadCache="/data/download"
    # TODO Factor in the 10% 'reserve'
else
    AltDownloadCache=""
    setprop env.download_cache ""
    return
fi

# wtf? for some reason the shell ain't picking up the env
DOWNLOAD_CACHE=$(awk '$1 == "export" && $2 == "DOWNLOAD_CACHE" {print $3}' /init.rc)

for dir in $DOWNLOAD_CACHE $AltDownloadCache;do
    if [ ! -e "$dir" ];
    then
        install -m 771 -o 1000 -g 2001 -d $dir
    fi
done
if [ "$DOWNLOAD_CACHE" != "" -a "$DOWNLOAD_CACHE" != "$AltDownloadCache" ];
then
    mount -o bind $AltDownloadCache $DOWNLOAD_CACHE
    echo "download cache location = $AltDownloadCache"
fi
return
}
System_dex_loc
download_cache_loc
Exit
