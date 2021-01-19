Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4742FBE30
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 18:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbhASRrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 12:47:24 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:44530 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391647AbhASRk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 12:40:56 -0500
Received: by mail-io1-f69.google.com with SMTP id e12so12668186ioh.11
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 09:40:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cz+TyUAdSvRaaR7wt0B3euj1+FtE/JPqehIJ2K4wFxI=;
        b=Y5faQOKKr28oX0LaR0MEj/fqVKiDUs4crwVQXVceYgU3gQxe8o+4mXZNwQAm7oi001
         lQMu+1W45qfXiVLN9DHSqJ0qKIIY2Iaz8HeoL7O2akfIf1mO3J7s7+a7Yl714uh3hAdq
         Hc1GdBZ8nXxUwIu5/LBNS60gmuyB6zC/JcMX97Z8Zz2h3hHHAWY33eqM5HXWGr0tvVqU
         OePdFe/sw30QaMOsNggMoSI8+UEvfyApQYELXIo7bifVwqDdX+i26J0I2rU2c0Vwxg9e
         Kp1RU4b63xeKU7oHGRnQod9NINBHz/FNbG3zwf8+6mHDxEvDW/rBxLeFHQ/xgIKhdaHW
         CtZw==
X-Gm-Message-State: AOAM531WTac2n69Q4x6SXA5bagRmUIHf18TF9yDDJh5i7WM17QH+eNQl
        G//usOWM/HEfYDExjHEOsL0Cbdyz2ngdQ6NwKue16sRi1Ku3
X-Google-Smtp-Source: ABdhPJwlc+pZ9ZKO5apRJCpOHaEETxebGPE+1ywptP03q7TAFkDD2MsfFXq3OJiJKgmCn346FiZgeNF7pFQ6Mw8wNF7tnjaJ8vul
MIME-Version: 1.0
X-Received: by 2002:a92:b503:: with SMTP id f3mr4214202ile.123.1611078015449;
 Tue, 19 Jan 2021 09:40:15 -0800 (PST)
Date:   Tue, 19 Jan 2021 09:40:15 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d1018c05b944543e@google.com>
Subject: WARNING in cfg80211_bss_update
From:   syzbot <syzbot+95c52e652a2fac1fcdf5@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    66c55602 skbuff: back tiny skbs with kmalloc() in __netdev..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=121bf89f500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c60c9ff9cc916cbc
dashboard link: https://syzkaller.appspot.com/bug?extid=95c52e652a2fac1fcdf5
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+95c52e652a2fac1fcdf5@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 25700 at net/wireless/scan.c:1565 cfg80211_combine_bsses net/wireless/scan.c:1565 [inline]
WARNING: CPU: 1 PID: 25700 at net/wireless/scan.c:1565 cfg80211_bss_update+0x16cd/0x1c60 net/wireless/scan.c:1746
Modules linked in:
CPU: 1 PID: 25700 Comm: kworker/u4:15 Not tainted 5.11.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy12 ieee80211_iface_work
RIP: 0010:cfg80211_combine_bsses net/wireless/scan.c:1565 [inline]
RIP: 0010:cfg80211_bss_update+0x16cd/0x1c60 net/wireless/scan.c:1746
Code: 00 48 c7 c7 20 8c 61 8a c6 05 88 7d b9 04 01 e8 a7 15 83 00 e9 27 ff ff ff e8 8f f0 3c f9 0f 0b e9 c2 f4 ff ff e8 83 f0 3c f9 <0f> 0b 4c 89 f7 e8 89 be 8c fb 31 ff 89 c6 88 44 24 70 e8 ec f6 3c
RSP: 0000:ffffc90002e46f50 EFLAGS: 00010212
RAX: 00000000000026ce RBX: 0000000000000001 RCX: ffffc90015d60000
RDX: 0000000000040000 RSI: ffffffff8835d93d RDI: 0000000000000003
RBP: ffff88802f58fc00 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff8835d08d R11: 0000000000000000 R12: ffff888022182c68
R13: 0000000000000005 R14: ffff88802f58fc10 R15: ffff888022182c00
FS:  0000000000000000(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2ee27000 CR3: 00000000144e2000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 cfg80211_inform_single_bss_frame_data+0x6e2/0xe90 net/wireless/scan.c:2400
 cfg80211_inform_bss_frame_data+0xa7/0xb10 net/wireless/scan.c:2433
 ieee80211_bss_info_update+0x3ce/0xb20 net/mac80211/scan.c:190
 ieee80211_rx_bss_info net/mac80211/ibss.c:1126 [inline]
 ieee80211_rx_mgmt_probe_beacon+0xccd/0x16b0 net/mac80211/ibss.c:1615
 ieee80211_ibss_rx_queued_mgmt+0xe3e/0x1870 net/mac80211/ibss.c:1642
 ieee80211_iface_work+0x761/0x9e0 net/mac80211/iface.c:1423
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
