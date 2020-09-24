Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FF3276D4E
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 11:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgIXJ1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 05:27:05 -0400
Received: from mail-io1-f77.google.com ([209.85.166.77]:43735 "EHLO
        mail-io1-f77.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727405AbgIXJ0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 05:26:30 -0400
Received: by mail-io1-f77.google.com with SMTP id b73so1935020iof.10
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 02:26:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=0j+21c+DQEGyv8+YfTh2XFRv26AfNd/g9NxPn8tyeGM=;
        b=c/NnC6GudCPEz/NOV7L/h82GfaL2UIj2cDDfrcg/MmHwj5xMzt9MHOeK4/Oy6QHuq+
         8yzkX90Z0RbFYrHNtVkf/nABfcif1xCXhlp2eqs9GZzIgysphD/kmA/+xbrqZt+jauqP
         eyGWXQOYkj+we9UDrYmcn4cWJ0a6TM+wl5A/5epbIob/iLURxttljwytSIr7CQDTY3gm
         BqbMza5HpBoftgGn7ySV1WSyWuB2aeE2qoXgBI+goxVDHjaoziess+CrTX387Zwx7MBm
         ptXKYrmqP22amhjotri5aO0eFXqlzGj9DxIdMjna1+Ys6FsoHVjjTRfh96X402D9oLuQ
         0TmA==
X-Gm-Message-State: AOAM533vEzWC7jAbeteK9W3kzRXsFLrE3PGlgjnpzJ9Z4CHwIpHAuqhq
        WXvJ44LuUjKGCtTMjUnJ91twc+j+S618meTAMFJec5qRQrT5
X-Google-Smtp-Source: ABdhPJxoICtWyO3FtjAwdEqjUFruLN+WepBvCdFwTSxtlAWaaMjwekbWiuFmqw0e5stUZKMnxXhnOsK2azHPEekQFNsdjhpYCASI
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1381:: with SMTP id w1mr2933256jad.34.1600939589413;
 Thu, 24 Sep 2020 02:26:29 -0700 (PDT)
Date:   Thu, 24 Sep 2020 02:26:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000088b1f405b00bcbb8@google.com>
Subject: WARNING in __cfg80211_ibss_joined (2)
From:   syzbot <syzbot+7f064ba1704c2466e36d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    eff48dde Merge tag 'trace-v5.9-rc5' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1665b19b900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5f4c828c9e3cef97
dashboard link: https://syzkaller.appspot.com/bug?extid=7f064ba1704c2466e36d
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7f064ba1704c2466e36d@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 29877 at net/wireless/ibss.c:36 __cfg80211_ibss_joined+0x487/0x520 net/wireless/ibss.c:36
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 29877 Comm: kworker/u4:3 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: cfg80211 cfg80211_event_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x382/0x7fb kernel/panic.c:231
 __warn.cold+0x20/0x4b kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:__cfg80211_ibss_joined+0x487/0x520 net/wireless/ibss.c:36
Code: 0f 0b e9 0c fe ff ff e8 77 54 06 fa e9 41 fc ff ff e8 4d 54 06 fa e9 7d fc ff ff e8 63 54 06 fa e9 0d ff ff ff e8 e9 84 c5 f9 <0f> 0b e9 7e fc ff ff e8 dd 84 c5 f9 0f 0b e8 56 54 06 fa e9 e4 fb
RSP: 0018:ffffc900177c7bc8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88809a2d0c10 RCX: ffffffff815b7ea2
RDX: ffff888097302400 RSI: ffffffff87b0b957 RDI: 0000000000000000
RBP: ffff88809a2d0000 R08: 0000000000000001 R09: ffffffff8d0b7a3f
R10: fffffbfff1a16f47 R11: 0000000000000000 R12: 1ffff92002ef8f7b
R13: ffff888000085a18 R14: 0000000000000000 R15: 0000000000000006
 cfg80211_process_wdev_events+0x3de/0x5b0 net/wireless/util.c:910
 cfg80211_process_rdev_events+0x6e/0x100 net/wireless/util.c:936
 cfg80211_event_work+0x1a/0x20 net/wireless/core.c:320
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
