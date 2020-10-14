Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED6928E039
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 14:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730870AbgJNMBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 08:01:41 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:40099 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730852AbgJNMBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 08:01:25 -0400
Received: by mail-il1-f198.google.com with SMTP id w12so2177898ilj.7
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 05:01:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=lmIzmeZ6JEWQDgHZewUQdQ9dPptB1ZZcDqf5FZlF1bk=;
        b=dpKvoVZT6qR4qUGMqkfMndCgtVZvNX+wzp7QsvI6y6o3Rm3CtQv9joLQTyfRUXQT7/
         YBjjSRccD3fxc11+NOZLW8KSK8MhsbQ/imEHkK1c2ls/ECv9NEOTRrtA1KiiA2uwBZo9
         RRURW9QLAq+emQIC4hTb1w9D6dypPO0agFmF9yXHOFYlQgHULo2sCuDGxRPxo7lVR6Dh
         YZ9fH1KHEIRxWyYSKQdBYyipAenZv2YM1Qzx7cnDM8R5nh3x0gj4fnFkHbSlZpsSJPlv
         Ul+4mwo+Pbm/ZNUAzupv17TuQzOmxfKTAsvIBcyG5fsL2iEtva/xQ/jkUKNOPFTwAnKn
         6tuw==
X-Gm-Message-State: AOAM532usnYl6QTb5xMOXy2ju3S0QPZE0E64SfhMCDLOX/8lLFDbIrW4
        OB9Kp5BKG1tbb0+3S8dJa1QG2mUGmyHd/Ech1GqSHb+KqXc4
X-Google-Smtp-Source: ABdhPJwxwXpsyf+M34H12D2yHMek4dY1NS12qdkhRRVdenzAcTt5OFh2KYuHi+95LbnQEReIraQpf/x7N1z+T+WSv8Fs+3mNy73h
MIME-Version: 1.0
X-Received: by 2002:a05:6638:606:: with SMTP id g6mr2893807jar.0.1602676884566;
 Wed, 14 Oct 2020 05:01:24 -0700 (PDT)
Date:   Wed, 14 Oct 2020 05:01:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000064f6cd05b1a04a2c@google.com>
Subject: WARNING in __rate_control_send_low
From:   syzbot <syzbot+fdc5123366fb9c3fdc6d@syzkaller.appspotmail.com>
To:     clang-built-linux@googlegroups.com, davem@davemloft.net,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    bbf5c979 Linux 5.9
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12dc474f900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3d8333c88fe898d7
dashboard link: https://syzkaller.appspot.com/bug?extid=fdc5123366fb9c3fdc6d
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fdc5123366fb9c3fdc6d@syzkaller.appspotmail.com

------------[ cut here ]------------
no supported rates for sta (null) (0xffffffff, band 0) in rate_mask 0xfff with flags 0x20
WARNING: CPU: 1 PID: 169 at net/mac80211/rate.c:349 __rate_control_send_low+0x4eb/0x5e0 net/mac80211/rate.c:349
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 169 Comm: kworker/u4:5 Not tainted 5.9.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy9 ieee80211_scan_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x382/0x7fb kernel/panic.c:231
 __warn.cold+0x20/0x4b kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:__rate_control_send_low+0x4eb/0x5e0 net/mac80211/rate.c:349
Code: 14 48 89 44 24 08 e8 d4 8d b0 f9 44 8b 44 24 24 45 89 e9 44 89 e1 48 8b 74 24 08 44 89 f2 48 c7 c7 40 24 5f 89 e8 b7 ca 80 f9 <0f> 0b e9 e0 fd ff ff e8 a9 8d b0 f9 41 83 cd 10 e9 02 fc ff ff e8
RSP: 0018:ffffc900013f7688 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff88801e243468 RCX: 0000000000000000
RDX: ffff8880a884e100 RSI: ffffffff815f5a55 RDI: fffff5200027eec3
RBP: ffff88805f373148 R08: 0000000000000001 R09: ffff8880ae5318e7
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000020 R14: 00000000ffffffff R15: 0000000000000090
 rate_control_send_low+0x261/0x610 net/mac80211/rate.c:374
 rate_control_get_rate+0x1b9/0x5a0 net/mac80211/rate.c:887
 ieee80211_tx_h_rate_ctrl+0xa0f/0x1660 net/mac80211/tx.c:749
 invoke_tx_handlers_early+0xaf3/0x25e0 net/mac80211/tx.c:1784
 ieee80211_tx+0x250/0x430 net/mac80211/tx.c:1926
 ieee80211_xmit+0x2dd/0x3b0 net/mac80211/tx.c:2015
 __ieee80211_tx_skb_tid_band+0x20a/0x290 net/mac80211/tx.c:5351
 ieee80211_tx_skb_tid_band net/mac80211/ieee80211_i.h:1986 [inline]
 ieee80211_send_scan_probe_req net/mac80211/scan.c:610 [inline]
 ieee80211_scan_state_send_probe+0x39f/0x910 net/mac80211/scan.c:638
 ieee80211_scan_work+0x6df/0x19e0 net/mac80211/scan.c:1071
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
