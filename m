Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D042816C2
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388037AbgJBPia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:38:30 -0400
Received: from mail-il1-f206.google.com ([209.85.166.206]:35309 "EHLO
        mail-il1-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387893AbgJBPiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:38:20 -0400
Received: by mail-il1-f206.google.com with SMTP id f10so1434370ilq.2
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 08:38:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=JmQQuAcGK0f8l/l7fmY64agtLz6hNPgTEZpUuG1yxiU=;
        b=OQj7PmKE/PH45xsiuVGvbr6tK6BKK9vpStYWhYU1lZzHehrNaa1aoTAMBpyeibXJnz
         1GKdyGxI8REZNMwYvInkkoWoQbmaTaHB804p7jF9PKCGIMX9iQavaTwbATVZEou7ysvX
         SWUC7LgvVzShIZF2378Xu3sZCwW/5LHkLiSAyEfiWmnAUIH7gwhqjUc1M86N4c+NNjY0
         SDO2Rhdgg2Z1F4cds4UiHSZgq/5cbecNB8e/MUJKNqh+3d80nJwqllUy73c8e2L/gTuo
         MJSp+3G9tc1JIV0e8DthWZEd+1aQ/lhL3T4HYPgBS+xjgyoqseK1q/9GHmO9EEjUlW8B
         QdTg==
X-Gm-Message-State: AOAM5320Q4K5qoN3ZskZ3vqQzRQ+Vxp6wqDbszFTnWSoSEhkQ6dF1Sti
        TJRAuGNmSgF5xBEJ1fnU8N4qVw9yJ+l1Pwp+5H5J5W6gvUQB
X-Google-Smtp-Source: ABdhPJwRmObuMC9itRcX34av64HD85wugaMGA7DmCEg2SUPIGA0UZq/xVUp49l0b08j7tNPmJZrHTuAQP6EzWKdto5pJIhAVoIY1
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2c48:: with SMTP id x8mr2468609iov.152.1601653098284;
 Fri, 02 Oct 2020 08:38:18 -0700 (PDT)
Date:   Fri, 02 Oct 2020 08:38:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fa10d905b0b1eb89@google.com>
Subject: WARNING in drv_bss_info_changed
From:   syzbot <syzbot+4cf3e4e092f2f4120a52@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fcadab74 Merge tag 'drm-fixes-2020-10-01-1' of git://anong..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14846d83900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=89ab6a0c48f30b49
dashboard link: https://syzkaller.appspot.com/bug?extid=4cf3e4e092f2f4120a52
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145eb667900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15422c1f900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4cf3e4e092f2f4120a52@syzkaller.appspotmail.com

syz-executor686 uses obsolete (PF_INET,SOCK_PACKET)
------------[ cut here ]------------
wlan0: Failed check-sdata-in-driver check, flags: 0x4
WARNING: CPU: 0 PID: 6917 at net/mac80211/driver-ops.h:172 drv_bss_info_changed+0x560/0x660 net/mac80211/driver-ops.h:172
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 6917 Comm: syz-executor686 Not tainted 5.9.0-rc7-syzkaller #0
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
RIP: 0010:drv_bss_info_changed+0x560/0x660 net/mac80211/driver-ops.h:172
Code: ab 40 06 00 00 48 85 ed 0f 84 99 00 00 00 e8 a7 3e b8 f9 e8 a2 3e b8 f9 44 89 fa 48 89 ee 48 c7 c7 40 dd 5e 89 e8 12 7c 88 f9 <0f> 0b e9 6b fd ff ff e8 84 3e b8 f9 0f 0b e9 ac fc ff ff e8 38 14
RSP: 0018:ffffc900054875c0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff888088990c00 RCX: 0000000000000000
RDX: ffff8880918184c0 RSI: ffffffff815f59d5 RDI: fffff52000a90eaa
RBP: ffff888088990000 R08: 0000000000000001 R09: ffff8880ae4318e7
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000002000000
R13: ffff888088991e10 R14: 0000000000000000 R15: 0000000000000004
 ieee80211_bss_info_change_notify+0x9a/0xc0 net/mac80211/main.c:210
 ieee80211_set_mcast_rate+0x37/0x40 net/mac80211/cfg.c:2453
 rdev_set_mcast_rate net/wireless/rdev-ops.h:1212 [inline]
 nl80211_set_mcast_rate+0x387/0x6c0 net/wireless/nl80211.c:9911
 genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
 genl_rcv_msg+0x61d/0x980 net/netlink/genetlink.c:731
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
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
RIP: 0033:0x442039
Code: e8 ac 00 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffff85406a8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000442039
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000002000000000 R09: 0000002000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000032
R13: 0000000000000000 R14: 000000000000000c R15: 0000000000000004
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
