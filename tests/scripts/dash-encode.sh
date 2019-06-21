#!/bin/sh

#these tests demonstrate how to use gpac to produce a DASH session with encoding / rescaling
#note that in the video encoding tests, we force intra refresh every second, this matches the default dash duration

test_begin "dash-encode-single-v"
if [ $test_skip = 0 ] ; then

#load a video source, decode + resize it , encode it and and dash the result
do_test "$GPAC -i $MEDIA_DIR/auxiliary_files/enst_video.h264:FID=1 ffsws:osize=512x512:SID=1 @ enc:c=avc:fintra=1 @ -o $TEMP_DIR/file.mpd:profile=live"

do_hash_test $TEMP_DIR/file.mpd "mpd"
do_hash_test $TEMP_DIR/enst_video_dashinit.mp4 "init-v"

#we don't want to test encoder result so hash the inspect timing and sap
myinspect=$TEMP_DIR/inspect.txt
do_test "$GPAC -i $TEMP_DIR/file.mpd inspect:allp:interleave=false:fmt=%pn%-%dts%-%cts%-%sap%%lf%:log=$myinspect"
do_hash_test $myinspect "inspect"

fi

test_end

test_begin "dash-encode-single-a"
if [ $test_skip = 0 ] ; then

#load an audio source, decode it , encode it and dash the result
do_test "$GPAC -i $MEDIA_DIR/auxiliary_files/count_english.mp3 @ enc:c=aac @ -o $TEMP_DIR/file.mpd:profile=live"

do_hash_test $TEMP_DIR/file.mpd "mpd"
do_hash_test $TEMP_DIR/count_english_dashinit.mp4 "init-a"

#we don't want to test encoder result so hash the inspect timing and sap
myinspect=$TEMP_DIR/inspect.txt
do_test "$GPAC -i $TEMP_DIR/file.mpd inspect:allp:interleave=false:fmt=%pn%-%dts%-%cts%-%sap%%lf%:log=$myinspect"
do_hash_test $myinspect "inspect"

fi

test_end

test_begin "dash-encode-vv"
if [ $test_skip = 0 ] ; then

#load a source, decode it , resize+encode in two resolutions and dash the result
do_test "$GPAC -i $MEDIA_DIR/auxiliary_files/enst_video.h264:FID=1 ffsws:osize=512x512:SID=1 @ enc:c=avc:fintra=1:FID=EV1 ffsws:osize=256x256:SID=1 @ enc:c=avc:fintra=1:FID=EV2 -o $TEMP_DIR/file.mpd:profile=live:SID=EV1,EV2 -graph"

do_hash_test $TEMP_DIR/file.mpd "mpd"
do_hash_test $TEMP_DIR/enst_video_dashinit_rep1.mp4 "init-v1"
do_hash_test $TEMP_DIR/enst_video_dashinit_rep2.mp4 "init-v2"

#we don't want to test encoder result so hash the inspect timing and sap
myinspect=$TEMP_DIR/inspect.txt
do_test "$GPAC -i $TEMP_DIR/file.mpd inspect:allp:interleave=false:fmt=%pn%-%dts%-%cts%-%sap%%lf%:log=$myinspect"
do_hash_test $myinspect "inspect"

fi

test_end


test_begin "dash-encode-avv"
if [ $test_skip = 0 ] ; then

#load a video MP3G-4part2 source, decode it , resize+encode in AVC in two resolutions
#load a an audio MP3 source, decode + encode in AAC
#dash the result
do_test "$GPAC -i $MEDIA_DIR/auxiliary_files/count_video.cmp:FID=1 ffsws:osize=512x512:SID=1 @ enc:c=avc:fintra=1:FID=EV1 ffsws:osize=256x256:SID=1 @ enc:c=avc:fintra=1:FID=EV2 -i $MEDIA_DIR/auxiliary_files/count_english.mp3:FID=2  @ enc:c=aac:FID=EA -o $TEMP_DIR/file.mpd:profile=live:SID=EV1,EV2,EA -graph -blacklist=vtbdec"

do_hash_test $TEMP_DIR/file.mpd "mpd"
do_hash_test $TEMP_DIR/count_video_dashinit_rep1.mp4 "init-v1"
do_hash_test $TEMP_DIR/count_video_dashinit_rep2.mp4 "init-v2"
do_hash_test $TEMP_DIR/count_english_dashinit.mp4 "init-a"

#we don't want to test encoder result so hash the inspect timing and sap
myinspect=$TEMP_DIR/inspect.txt
do_test "$GPAC -i $TEMP_DIR/file.mpd inspect:allp:interleave=false:fmt=%pn%-%dts%-%cts%-%sap%%lf%:log=$myinspect"
do_hash_test $myinspect "inspect"

fi

test_end

