Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9AB3BC3BC
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 23:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhGEVm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 17:42:56 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:42640 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbhGEVm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 17:42:56 -0400
Received: by mail-io1-f72.google.com with SMTP id v21-20020a5d90550000b0290439ea50822eso14268882ioq.9
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 14:40:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Bya+A1ArCfRSts2kxXyTudtZPvkvITvsGjxiasufUy8=;
        b=OeLP5rKzv3etUDr20suSgQkIDnO7/5grNI/iXk57LfcI0kagxvXUgYNCTC91VXou9S
         YRuBMujDjdGMJLULi8tKU68ZNSz9GQkSxG4dHMywwCWkVxN12Q7kP8fyD0Y51pGg/Cgu
         1r+4vj2pjvhOtxPNQ2rdBTQvVT4WRrN4bueiWNkkhevpQhW5TChM3BR3ujQbtg9WBcWa
         k/tcUlnUotZxdquwbodIO+8AC+C/GUMD2gNn7Heb5rAfq/mI0u386J/mvyjiOoCD6ln9
         rSAAvaDjPOnarEFfUQjVvBd3gWGwlklxM3YSTMjTRQPZpFnKHKTqftpLl1+3tmUPbQn2
         8rTQ==
X-Gm-Message-State: AOAM5319d1BJKVP7T8opI8LbMyUJNzdPIfVX+upoJfDDqbSw2k5Xxrv0
        7Sx+msRGyyQIaTG2OFvosV82214VMFU/IdplyHTb0U4B9Tmn
X-Google-Smtp-Source: ABdhPJzJotoOYyQbVdK0XWps1OmU2DrbHGQiA7nGiIsC5xMHvDRSer+Y8i9+cQggEQvs4HlY+FQl7KB6f5jThoBC4V16bXHKuULb
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:512:: with SMTP id d18mr12103123ils.192.1625521217680;
 Mon, 05 Jul 2021 14:40:17 -0700 (PDT)
Date:   Mon, 05 Jul 2021 14:40:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c1388a05c6672697@google.com>
Subject: [syzbot] net boot error: general protection fault in ptp_clock_register
From:   syzbot <syzbot+54923d81929c37649359@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6ff63a15 net: marvell: always set skb_shared_info in mvnet..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=12ea06c4300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=26b64b13fcecb7e1
dashboard link: https://syzkaller.appspot.com/bug?extid=54923d81929c37649359

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+54923d81929c37649359@syzkaller.appspotmail.com

vivid-013: V4L2 capture device registered as swradio13
vivid-013: V4L2 receiver device registered as radio26
vivid-013: V4L2 transmitter device registered as radio27
vivid-013: V4L2 metadata capture device registered as video57
vivid-013: V4L2 metadata output device registered as video58
vivid-013: V4L2 touch capture device registered as v4l-touch13
vivid-014: using single planar format API
vivid-014: CEC adapter cec28 registered for HDMI input 0
vivid-014: V4L2 capture device registered as video59
vivid-014: CEC adapter cec29 registered for HDMI output 0
vivid-014: V4L2 output device registered as video60
vivid-014: V4L2 capture device registered as vbi28, supports raw and sliced VBI
vivid-014: V4L2 output device registered as vbi29, supports raw and sliced VBI
vivid-014: V4L2 capture device registered as swradio14
vivid-014: V4L2 receiver device registered as radio28
vivid-014: V4L2 transmitter device registered as radio29
vivid-014: V4L2 metadata capture device registered as video61
vivid-014: V4L2 metadata output device registered as video62
vivid-014: V4L2 touch capture device registered as v4l-touch14
vivid-015: using multiplanar format API
vivid-015: CEC adapter cec30 registered for HDMI input 0
vivid-015: V4L2 capture device registered as video63
vivid-015: CEC adapter cec31 registered for HDMI output 0
vivid-015: V4L2 output device registered as video64
vivid-015: V4L2 capture device registered as vbi30, supports raw and sliced VBI
vivid-015: V4L2 output device registered as vbi31, supports raw and sliced VBI
vivid-015: V4L2 capture device registered as swradio15
vivid-015: V4L2 receiver device registered as radio30
vivid-015: V4L2 transmitter device registered as radio31
vivid-015: V4L2 metadata capture device registered as video65
vivid-015: V4L2 metadata output device registered as video66
vivid-015: V4L2 touch capture device registered as v4l-touch15
vim2m vim2m.0: Device registered as /dev/video0
vicodec vicodec.0: Device 'stateful-encoder' registered as /dev/video68
vicodec vicodec.0: Device 'stateful-decoder' registered as /dev/video69
vicodec vicodec.0: Device 'stateless-decoder' registered as /dev/video70
dvbdev: DVB: registering new adapter (dvb_vidtv_bridge)
i2c i2c-0: DVB: registering adapter 0 frontend 0 (Dummy demod for DVB-T/T2/C/S/S2)...
dvbdev: dvb_create_media_entity: media entity 'Dummy demod for DVB-T/T2/C/S/S2' registered.
dvbdev: dvb_create_media_entity: media entity 'dvb-demux' registered.
vidtv vidtv.0: Successfully initialized vidtv!
usbcore: registered new interface driver radioshark
usbcore: registered new interface driver radioshark2
usbcore: registered new interface driver dsbr100
usbcore: registered new interface driver radio-si470x
usbcore: registered new interface driver radio-usb-si4713
usbcore: registered new interface driver radio-mr800
usbcore: registered new interface driver radio-keene
usbcore: registered new interface driver radio-ma901
usbcore: registered new interface driver radio-raremono
general protection fault, probably for non-canonical address 0xdffffc0000000097: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000004b8-0x00000000000004bf]
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ptp_clock_register+0x5b1/0xce0 drivers/ptp/ptp_clock.c:239
Code: 0f 85 38 06 00 00 4d 89 a7 10 01 00 00 e8 f7 9c 51 fb 49 8d bd b8 04 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 35 06 00 00 4d 8b bd b8 04 00 00 4d 85 ff 74 51
RSP: 0000:ffffc90000c67cc8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 1ffff9200018cf9f RCX: 0000000000000000
RDX: 0000000000000097 RSI: ffffffff8623e789 RDI: 00000000000004b8
RBP: ffffffff90d082a8 R08: ffff8881478e0648 R09: 0000000000000000
R10: ffffed1028f1c329 R11: 0000000000000000 R12: ffff8881478e0000
R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff90d082a8
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000be8e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ptp_kvm_init+0xe5/0x11b drivers/ptp/ptp_kvm_common.c:148
 do_one_initcall+0x103/0x650 init/main.c:1246
 do_initcall_level init/main.c:1319 [inline]
 do_initcalls init/main.c:1335 [inline]
 do_basic_setup init/main.c:1355 [inline]
 kernel_init_freeable+0x6b8/0x741 init/main.c:1557
 kernel_init+0x1a/0x1d0 init/main.c:1449
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Modules linked in:
---[ end trace 4ffcc7041c5c4e30 ]---
RIP: 0010:ptp_clock_register+0x5b1/0xce0 drivers/ptp/ptp_clock.c:239
Code: 0f 85 38 06 00 00 4d 89 a7 10 01 00 00 e8 f7 9c 51 fb 49 8d bd b8 04 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 35 06 00 00 4d 8b bd b8 04 00 00 4d 85 ff 74 51
RSP: 0000:ffffc90000c67cc8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 1ffff9200018cf9f RCX: 0000000000000000
RDX: 0000000000000097 RSI: ffffffff8623e789 RDI: 00000000000004b8
RBP: ffffffff90d082a8 R08: ffff8881478e0648 R09: 0000000000000000
R10: ffffed1028f1c329 R11: 0000000000000000 R12: ffff8881478e0000
R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff90d082a8
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000be8e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
