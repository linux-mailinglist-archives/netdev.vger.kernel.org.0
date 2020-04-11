Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F141A4E34
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 07:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgDKFkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 01:40:14 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:41202 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgDKFkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 01:40:14 -0400
Received: by mail-io1-f71.google.com with SMTP id p20so4230208iob.8
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 22:40:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=8JDQ5U8UVLv002wFo+eytZYgTb48Ga4EUOnZfo48eJ0=;
        b=i6256R0sakV70XBmXrSRB5VQ1qgyPZ9VyyAFeRRjPf4122i4ABJqw1wEm1kPxh3Ers
         7BTjVXtsG+rt+f0YICWjf4CjP9WMP6Q82DmhrSxGsaUIdkhudRObW7isel+QvXDz/XzJ
         8Q4Wfxc7gfcI+oKpEjcxjKm9Gl+yyUVdiyQjzdRVI631yZ5Nf/rRN0SL4d5ESY9vTkyA
         gyg77z/jxMwojqw1PVjwKyX6+oyWAXztH6Pw96hZsXFn59mxpcero2k/CCjsbpcq3Mgg
         ShFB9HakCyxc+C6E8kg9V4h6YJ953v2lBn1wvjfG/JeE4ZMD77nGUm+RnrrfbymmBxK2
         OVFg==
X-Gm-Message-State: AGi0PuberkSkwYMN2u0JNpgoxR2kHE5NRb6d6ycKh95iNVlLmBNIjW+m
        4WAKhtcKzPDtbmj66PAQzbtEeHAo9E83+9Wg9myYX6MpJ0G0
X-Google-Smtp-Source: APiQypJcxw8RNRO8vv7uAUFgyV0CIt7YmvDKpA2ROqAQGhaCG5xd//xXmcDbnpQ7pHv7zL9kHxTDVKU2mWvOf36ta/5F3p9Ce2pN
MIME-Version: 1.0
X-Received: by 2002:a92:d08e:: with SMTP id h14mr306982ilh.208.1586583614152;
 Fri, 10 Apr 2020 22:40:14 -0700 (PDT)
Date:   Fri, 10 Apr 2020 22:40:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ba65ba05a2fd48d9@google.com>
Subject: kernel BUG at net/core/dev.c:LINE! (3)
From:   syzbot <syzbot+af23e7f3e0a7e10c8b67@syzkaller.appspotmail.com>
To:     andy@greyhouse.net, davem@davemloft.net, j.vosburgh@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vfalico@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    aa81700c macsec: fix NULL dereference in macsec_upd_offloa..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=14f97c9fe00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c1e98458335a7d1
dashboard link: https://syzkaller.appspot.com/bug?extid=af23e7f3e0a7e10c8b67
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+af23e7f3e0a7e10c8b67@syzkaller.appspotmail.com

bond11 (unregistering): Released all slaves
bond10 (unregistering): Released all slaves
bond9 (unregistering): Released all slaves
bond8 (unregistering): (slave xfrm1): Releasing backup interface
bond8 (unregistering): Destroying bond
------------[ cut here ]------------
kernel BUG at net/core/dev.c:8797!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 208 Comm: kworker/u4:6 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:rollback_registered_many+0x2b3/0xe70 net/core/dev.c:8797
Code: 48 89 e8 48 c1 e8 03 42 80 3c 30 00 0f 85 19 0b 00 00 48 b8 22 01 00 00 00 00 ad de 48 89 43 70 e9 bc fe ff ff e8 cd 57 62 fb <0f> 0b 4c 8d 7b 68 48 8d 6b 70 eb a5 e8 bc 57 62 fb 49 8b 04 24 48
RSP: 0018:ffffc90000e27718 EFLAGS: 00010293
RAX: ffff8880a933a340 RBX: ffff888088188000 RCX: ffffffff86109040
RDX: 0000000000000000 RSI: ffffffff86109193 RDI: 0000000000000001
RBP: ffff888088188068 R08: ffff8880a933a340 R09: fffffbfff14accf1
R10: fffffbfff14accf0 R11: ffffffff8a566787 R12: ffffc90000e27860
R13: ffffc90000e277f8 R14: dffffc0000000000 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbfa2811000 CR3: 0000000093d8c000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 rollback_registered+0xf2/0x1c0 net/core/dev.c:8871
 unregister_netdevice_queue net/core/dev.c:9967 [inline]
 unregister_netdevice_queue+0x1d7/0x2b0 net/core/dev.c:9960
 unregister_netdevice include/linux/netdevice.h:2725 [inline]
 bond_release_and_destroy drivers/net/bonding/bond_main.c:2091 [inline]
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3164 [inline]
 bond_netdev_event.cold+0xd1/0x128 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 rollback_registered_many+0x75c/0xe70 net/core/dev.c:8826
 unregister_netdevice_many.part.0+0x16/0x1e0 net/core/dev.c:9986
 unregister_netdevice_many net/core/dev.c:9985 [inline]
 default_device_exit_batch+0x311/0x3d0 net/core/dev.c:10469
 ops_exit_list.isra.0+0x103/0x150 net/core/net_namespace.c:189
 cleanup_net+0x511/0xa50 net/core/net_namespace.c:603
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace 8b2af7c1d8b87378 ]---
RIP: 0010:rollback_registered_many+0x2b3/0xe70 net/core/dev.c:8797
Code: 48 89 e8 48 c1 e8 03 42 80 3c 30 00 0f 85 19 0b 00 00 48 b8 22 01 00 00 00 00 ad de 48 89 43 70 e9 bc fe ff ff e8 cd 57 62 fb <0f> 0b 4c 8d 7b 68 48 8d 6b 70 eb a5 e8 bc 57 62 fb 49 8b 04 24 48
RSP: 0018:ffffc90000e27718 EFLAGS: 00010293
RAX: ffff8880a933a340 RBX: ffff888088188000 RCX: ffffffff86109040
RDX: 0000000000000000 RSI: ffffffff86109193 RDI: 0000000000000001
RBP: ffff888088188068 R08: ffff8880a933a340 R09: fffffbfff14accf1
R10: fffffbfff14accf0 R11: ffffffff8a566787 R12: ffffc90000e27860
R13: ffffc90000e277f8 R14: dffffc0000000000 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbfa2816028 CR3: 0000000093d8c000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
