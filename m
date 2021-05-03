Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E05371E76
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 19:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhECRWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 13:22:30 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:52210 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbhECRWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 13:22:19 -0400
Received: by mail-il1-f197.google.com with SMTP id i2-20020a056e021b02b029018159d70cffso5034555ilv.18
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 10:21:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=qxFHdf1JyUHuKTV5N7flUIAC+ZyvCmlhk8Q5OCqaAEg=;
        b=tD241MCWHnKpIYwgkmFJ4ikXN2eAvpvtMQM+9tVxrIs1in7S3eN75DtBiy8LLsVcc/
         tZYUuPkehVqD+UBbHbB7VEA4ZAMuDBCbM0peyAUtDubOlfR6/IUZ35uQleVqzh1it64i
         ThVzk16y9k66Xa4b0YbRbFUNCR0DjaPosRV/kJDhl1iiYpKIf0AxkDrl0U+BXga+arzj
         dGpgV0CKTgQGpeNRkZs+zMp6z1q0X1zsKrPErctOAm5UJXkUn1u4Y3p/Xk6GOFoH/kix
         4JGw9i4nRC/SDcEJBkFUZq8QwWEV+TNd8QfA3Ide74P88u4ax0m8Axpkk+OlK/bF6rLh
         vGKA==
X-Gm-Message-State: AOAM531bHMKi0lmEcj3/CIrOQTL6vyHCMFp9YZFOnB83Is9gexdQk+Tk
        qkEFKMH/0F8yZqwe/FWytygNRqwIWQ9q/qw/NqajfIPBvqsl
X-Google-Smtp-Source: ABdhPJwOLPQv3RamVzSEtvjFDe2UbeRHMXHhlq9OqdtKVPh833BUUtSmprOeelnjLpPlNqaSPbFl9gOggNKDEt3j0vr7lXhuBzNK
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1051:: with SMTP id p17mr1757122ilj.96.1620062486145;
 Mon, 03 May 2021 10:21:26 -0700 (PDT)
Date:   Mon, 03 May 2021 10:21:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000032b105c170317c@google.com>
Subject: [syzbot] net test error: WARNING in __nf_unregister_net_hook
From:   syzbot <syzbot+33d023f240aa788eb7fe@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f18c51b6 net: stmmac: Remove duplicate declaration of stmm..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=160a1da5d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=57b4b78935781045
dashboard link: https://syzkaller.appspot.com/bug?extid=33d023f240aa788eb7fe

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+33d023f240aa788eb7fe@syzkaller.appspotmail.com

wlan1: Created IBSS using preconfigured BSSID 50:50:50:50:50:50
wlan1: Creating new IBSS network, BSSID 50:50:50:50:50:50
------------[ cut here ]------------
hook not found, pf 3 num 0
WARNING: CPU: 1 PID: 224 at net/netfilter/core.c:480 __nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
Modules linked in:
CPU: 1 PID: 224 Comm: kworker/u4:5 Not tainted 5.12.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:__nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
Code: 0f b6 14 02 48 89 c8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 11 04 00 00 8b 53 1c 89 ee 48 c7 c7 c0 78 6d 8a e8 40 4c 8a 01 <0f> 0b e9 e5 00 00 00 e8 59 48 30 fa 44 8b 3c 24 4c 89 f8 48 c1 e0
RSP: 0018:ffffc9000178fbc0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff888021b56400 RCX: 0000000000000000
RDX: ffff8880128354c0 RSI: ffffffff815c8ba5 RDI: fffff520002f1f6a
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815c2a0e R11: 0000000000000000 R12: ffff88802db68f20
R13: 0000000000000000 R14: ffff88801ec20900 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000563c6b380160 CR3: 000000001d865000 CR4: 00000000001506e0
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
