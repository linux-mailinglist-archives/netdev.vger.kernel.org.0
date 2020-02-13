Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2899715C918
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 18:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgBMREO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 12:04:14 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:33851 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727877AbgBMREN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 12:04:13 -0500
Received: by mail-io1-f71.google.com with SMTP id n26so4707538ioj.1
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 09:04:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=wu4DsXWHKTCz3A8YgQEqq7+svRyFUgePn4mAPcXVvZs=;
        b=k41+4gnuY1EIDxMnaNFw9h4vMp+884WtuYd04R6apcQX6ucoq1woBvr+IBZ7Tk07Et
         yy7/CyXb5o/CKFE4Bs/GvZTxXoT7zUFZeRvAvTEMUWcXFeJ5hnHI9pBGF2KyBnZFs6i5
         E1Mntf6y+RVmM12mEKMxtTHRevq+ohBEYIjjcdYsj1C3e8TmpQ7cqmFNCji5uxez6Kif
         C0gGSqjC1ILX3F8h7Q3upvZHSoPJ/9gNpu6IdEEJMSP88Zwjty2VIitSGX7Xsjk+vKVM
         MLxrMsKct1Xqrj9qHFn8+ZhkC+k3EZn8jPREoemn1z8UkcDoPUvGCyxTK8mUdhKuqvfW
         Cm4w==
X-Gm-Message-State: APjAAAUX8TzXhbovLs43JBV2gITzUnRVtRUajjOAHD86SbGYRu0SlB3D
        LF3H1HBNJjDWKalWPA88PiLnMZZG2GlWylq8I1Tnjy9F9zgK
X-Google-Smtp-Source: APXvYqz6dn5wLs6c6DD619vuL6aE7pu08H8Je+AeL04q/9HdoUnqb124oBIMLG8C9XFGlXp62uBOqpYiH1e0nM27N1EAgHV1STvR
MIME-Version: 1.0
X-Received: by 2002:a5d:9b94:: with SMTP id r20mr22396389iom.140.1581613453406;
 Thu, 13 Feb 2020 09:04:13 -0800 (PST)
Date:   Thu, 13 Feb 2020 09:04:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000ffb36059e7814fb@google.com>
Subject: WARNING in __cfg80211_ibss_joined
From:   syzbot <syzbot+a37200cd4a9a4d86c52f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    fdfa3a67 Merge tag 'scsi-misc' of git://git.kernel.org/pub..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13ac434ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=71f1d0a1df5278ab
dashboard link: https://syzkaller.appspot.com/bug?extid=a37200cd4a9a4d86c52f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a37200cd4a9a4d86c52f@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 607 at net/wireless/ibss.c:36 __cfg80211_ibss_joined+0x509/0x5b0 net/wireless/ibss.c:36
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 607 Comm: kworker/u4:10 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: cfg80211 cfg80211_event_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x3e kernel/panic.c:582
 report_bug+0x289/0x300 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
 do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:__cfg80211_ibss_joined+0x509/0x5b0 net/wireless/ibss.c:36
Code: 0f 0b e9 f3 fd ff ff e8 e5 3f 3d fa e9 dc fb ff ff e8 9b 3f 3d fa e9 18 fc ff ff e8 d1 3f 3d fa e9 08 ff ff ff e8 47 9a fe f9 <0f> 0b e9 19 fc ff ff e8 3b 9a fe f9 0f 0b e8 d4 3f 3d fa e9 7e fb
RSP: 0018:ffffc90001d77bb0 EFLAGS: 00010293
RAX: ffff8880a7f843c0 RBX: ffff888058c3cb90 RCX: 0000000000000006
RDX: 0000000000000000 RSI: ffffffff8776e2b9 RDI: ffff8880a7f84c54
RBP: ffffc90001d77c60 R08: 1ffffffff16a2f77 R09: fffffbfff16a2f78
R10: fffffbfff16a2f77 R11: ffffffff8b517bbf R12: ffff888058c3c000
R13: 1ffff920003aef7a R14: ffff8880a84ba118 R15: 0000000000000000
 cfg80211_process_wdev_events+0x3fe/0x5b0 net/wireless/util.c:885
 cfg80211_process_rdev_events+0x75/0x100 net/wireless/util.c:911
 cfg80211_event_work+0x1e/0x30 net/wireless/core.c:320
 process_one_work+0xa05/0x17a0 kernel/workqueue.c:2264
 worker_thread+0x98/0xe40 kernel/workqueue.c:2410
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
