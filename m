Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBD528B597
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 15:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbgJLNKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 09:10:25 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:45912 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730366AbgJLNKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 09:10:21 -0400
Received: by mail-il1-f199.google.com with SMTP id b4so4066113ilf.12
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 06:10:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ruwn0zWSDaveXQu6Bcr4bLcjDOKEK9RynywhL1QC2Qg=;
        b=IHS04TCtV4V9rA+/ZMIVsd8MrsX1yNM9MiNfltb8TPlAYGpTBUknwI0z1r65QGZP6q
         6TwgY7DFGHX6FwBefoiwwin0pOj/QlwlVuk/BGcrzxUsGRGigAYWksr+wZe2GrnzZJlG
         kwdza4nzjEVwh0ARg1Uye32BqFEAekrGSNcxegea1J23e/FROU/HbA2Dh+NGb9kbWdyw
         oeqDbMhCzocQEDbHnqo02hO3IKRddPAnUlckw5PrjylPzEG1jETJ8Zw1nqZfmnng8YhE
         qNCPkWQCDgsaY/YuvesMHMhODe7WNfOFbm6cCt7R2s/UrWZ4amIiwejzgCJq+B1O+J0D
         +bew==
X-Gm-Message-State: AOAM532HCrt1QRLKYlLsuBR5XlPKMfxCZXHgB1mtrhH9rPkCuKCIy9Yg
        Fk/FguDzDtnGn+EdZPxTHNVeW90nmyVhkrFX9i9yHuwelBnC
X-Google-Smtp-Source: ABdhPJwmKooF3mW5HGZXnz4Rm3mU4ZTSfXWKxE4Poiu/CjP+vqINI5mpk8mKyzMp+MZurJWuwLNoE6X/phPpgu5xmv52HhVIm87x
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:d45:: with SMTP id h5mr9473108ilj.307.1602508220977;
 Mon, 12 Oct 2020 06:10:20 -0700 (PDT)
Date:   Mon, 12 Oct 2020 06:10:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000042d83305b1790599@google.com>
Subject: WARNING in ieee80211_get_sband
From:   syzbot <syzbot+7716dbc401d9a437890d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    036dfd83 selftests: mptcp: interpret \n as a new line
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13d4d817900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8ad9ecfafd94317b
dashboard link: https://syzkaller.appspot.com/bug?extid=7716dbc401d9a437890d
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16755e58500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=162b6700500000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=113dd700500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=133dd700500000
console output: https://syzkaller.appspot.com/x/log.txt?x=153dd700500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7716dbc401d9a437890d@syzkaller.appspotmail.com

device wlan0 entered promiscuous mode
------------[ cut here ]------------
WARNING: CPU: 1 PID: 6905 at net/mac80211/ieee80211_i.h:1460 ieee80211_get_sband+0x2e3/0x3e0 net/mac80211/ieee80211_i.h:1460
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 6905 Comm: syz-executor526 Not tainted 5.9.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x382/0x7fb kernel/panic.c:231
 __warn.cold+0x20/0x4b kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:ieee80211_get_sband+0x2e3/0x3e0 net/mac80211/ieee80211_i.h:1460
Code: f9 48 c7 c2 e0 5f 61 89 be 7b 02 00 00 48 c7 c7 40 60 61 89 c6 05 b6 fb 80 03 01 e8 3c a2 85 f9 e9 b8 fd ff ff e8 cd ac 9f f9 <0f> 0b e8 46 75 60 00 31 ff 89 c3 89 c6 e8 1b a9 9f f9 85 db 74 19
RSP: 0018:ffffc900056573d8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff87d6db35
RDX: ffff8880a6a2a180 RSI: ffffffff87d6dbb3 RDI: 0000000000000005
RBP: ffff88809ec40c80 R08: 0000000000000001 R09: ffffffff8d1119e7
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88809ecccc00 R14: ffff88809ec40c80 R15: ffffc9000565751c
 sta_apply_parameters+0x4e/0x1dc0 net/mac80211/cfg.c:1451
 ieee80211_add_station+0x320/0x660 net/mac80211/cfg.c:1678
 rdev_add_station net/wireless/rdev-ops.h:190 [inline]
 nl80211_new_station+0xdce/0x1420 net/wireless/nl80211.c:6571
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2489
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x446309
Code: e8 bc b5 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 8b 0f fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f4a00236d98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc78 RCX: 0000000000446309
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 000000000000000a
RBP: 00000000006dbc70 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc7c
R13: 0000000000000000 R14: 000000306e616c77 R15: 0000000000660006
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
