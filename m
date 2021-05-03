Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADB137109C
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 05:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbhECDBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 23:01:18 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:56143 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbhECDBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 23:01:17 -0400
Received: by mail-io1-f72.google.com with SMTP id c24-20020a5d9a980000b029040db7d17e09so2309393iom.22
        for <netdev@vger.kernel.org>; Sun, 02 May 2021 20:00:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=QsmWOiuqBjacmw1ctaNCjChVXJoRgKeDEkz+C0oyblw=;
        b=Th5J8D8Cl46Z4eO7EhqhAQB1BBYRGuYJj324OJQg+HB0B+sHOt+mrtz6pEqws6JImF
         WCpes7uHWSdxSDfl3fW+Qurr28bKgn9srBXPzdMZdogTAzDEQTvIW3cM4U9UUjognEIz
         woTQmvzuKuDGTI35rTFN3g30QQogbl4YLX7dWuMs8OirF5BuA15glo+8tI3dY6vb5UZ4
         nn1x71J2HbitkZNtgoS/t7+P1zBzv9AHadDqPi9LCoNyH5Jegp9aNx8UctbQpGzLzJQl
         xrm06eYVe1W4NQVh6NGh69WDoWT6ZpzWR3aFYPo7bH+z3A949uyMemZ6cU07iH50HzsF
         CKFA==
X-Gm-Message-State: AOAM533nRnJZWuPGui8VvsnFaSzwexx3WfAv0aph0cGVsNbQiGSRK+LS
        YcXExYzDnN4m0aK/RLxuYdh57e2mvbPIsrchRQEw6ot0Qw6m
X-Google-Smtp-Source: ABdhPJxFHPJcx1dQ9Ta7mvY45fXl8ZWoc4sgViuiPUjYxPbvgejLvXSZs8CkXZJccsJ4g2qApaBs4cXs2gKZWKGDicWXsA0QY+QZ
MIME-Version: 1.0
X-Received: by 2002:a92:c7a1:: with SMTP id f1mr13598531ilk.33.1620010824063;
 Sun, 02 May 2021 20:00:24 -0700 (PDT)
Date:   Sun, 02 May 2021 20:00:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b361bf05c16429a5@google.com>
Subject: [syzbot] bpf-next test error: WARNING in __nf_unregister_net_hook
From:   syzbot <syzbot+0d9ff6eeee8f4b6e2aed@syzkaller.appspotmail.com>
To:     ast@kernel.org, coreteam@netfilter.org, daniel@iogearbox.net,
        davem@davemloft.net, fw@strlen.de, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9d31d233 Merge tag 'net-next-5.13' of git://git.kernel.org..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=102b70d9d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=57b4b78935781045
dashboard link: https://syzkaller.appspot.com/bug?extid=0d9ff6eeee8f4b6e2aed

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0d9ff6eeee8f4b6e2aed@syzkaller.appspotmail.com

------------[ cut here ]------------
hook not found, pf 3 num 0
WARNING: CPU: 1 PID: 108 at net/netfilter/core.c:480 __nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
Modules linked in:
CPU: 1 PID: 108 Comm: kworker/u4:2 Not tainted 5.12.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:__nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
Code: 0f b6 14 02 48 89 c8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 11 04 00 00 8b 53 1c 89 ee 48 c7 c7 c0 78 6d 8a e8 60 4c 8a 01 <0f> 0b e9 e5 00 00 00 e8 79 48 30 fa 44 8b 3c 24 4c 89 f8 48 c1 e0
RSP: 0018:ffffc9000121fbc0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff888147896c00 RCX: 0000000000000000
RDX: ffff888012371c40 RSI: ffffffff815c8ba5 RDI: fffff52000243f6a
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815c2a0e R11: 0000000000000000 R12: ffff88802f600f20
R13: 0000000000000000 R14: ffff888021357800 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000f43ef0 CR3: 0000000024afe000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 nf_unregister_net_hook net/netfilter/core.c:502 [inline]
 nf_unregister_net_hooks+0x117/0x160 net/netfilter/core.c:576
 arpt_unregister_table_pre_exit+0x67/0x80 net/ipv4/netfilter/arp_tables.c:1565
 ops_pre_exit_list net/core/net_namespace.c:165 [inline]
 cleanup_net+0x451/0xb10 net/core/net_namespace.c:583
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
