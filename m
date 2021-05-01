Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC48370646
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 09:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbhEAH7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 03:59:05 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:57265 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbhEAH7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 03:59:04 -0400
Received: by mail-io1-f69.google.com with SMTP id y20-20020a6bd8140000b02903e6787c4986so174972iob.23
        for <netdev@vger.kernel.org>; Sat, 01 May 2021 00:58:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=V6CoVXrou85PCbE3OFabws+tjrhLI+Hm1V8ygTXVsoU=;
        b=lLA3B3PrtCbTd8vn/rWRqXzRXW3kghd628JxKSxGO7BheUiZldkE4f2Shgmn9SjCEV
         nYE1Tdk99QmbFWdSHZKrWKrjDcLp8vtKAuJ5Ev1HrvzCNjyn41ZkjwHNSJkdWzdcu/mJ
         7eynC2ZWqsdKvGrhbdVfr2VNrkAAr6iwpT7zVX78qrv+my9xrqCd9zZV5W0yAS6yviK9
         BfumNCgSNG/5OyHPFImOr5Fc0v6GZs5DBxBhl22Lo832prBNji+9ZzKQWgda0e4pQc3U
         NR4bVL5bgNznlhNuowd8q0culuxEYwfe76IY0sYOyP3303lS8E2e3oabL/24hmh9omz6
         ueTA==
X-Gm-Message-State: AOAM531WADEMzA3K8mgyRukv7ugbBla0PZwFFXJUaLFOWT2Gk8R53y5c
        JM1VDuGNsHAKb/GeCiPxFBcH63s4rq9H6ySxZWxk7H8k6EAe
X-Google-Smtp-Source: ABdhPJypGJw5aoqBi/5x0cHc2iY+k3seJpZ4P/QqUK4QubnvK3hhK2CpLUim2n7SOWCDfXODH67Onwsg9Dd2RWI+McF0WO+31iFt
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c24:: with SMTP id m4mr7566857ilh.279.1619855895319;
 Sat, 01 May 2021 00:58:15 -0700 (PDT)
Date:   Sat, 01 May 2021 00:58:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003a5d4c05c140175f@google.com>
Subject: [syzbot] linux-next test error: WARNING in __nf_unregister_net_hook
From:   syzbot <syzbot+dcccba8a1e41a38cb9df@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    74f961f4 Add linux-next specific files for 20210430
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=156e6f15d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=acf3aa1c9f3e62f8
dashboard link: https://syzkaller.appspot.com/bug?extid=dcccba8a1e41a38cb9df

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dcccba8a1e41a38cb9df@syzkaller.appspotmail.com

------------[ cut here ]------------
hook not found, pf 3 num 0
WARNING: CPU: 0 PID: 224 at net/netfilter/core.c:480 __nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
Modules linked in:
CPU: 0 PID: 224 Comm: kworker/u4:5 Not tainted 5.12.0-next-20210430-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:__nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
Code: 0f b6 14 02 48 89 c8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 11 04 00 00 8b 53 1c 89 ee 48 c7 c7 c0 4d 6e 8a e8 e8 5b 8a 01 <0f> 0b e9 e5 00 00 00 e8 99 dd 2c fa 44 8b 3c 24 4c 89 f8 48 c1 e0
RSP: 0018:ffffc900015bfbc0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff8880243de500 RCX: 0000000000000000
RDX: ffff888012df3900 RSI: ffffffff815cc9f5 RDI: fffff520002b7f6a
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815c685e R11: 0000000000000000 R12: ffff88802e9c0f20
R13: 0000000000000000 R14: ffff888019fb2180 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc78cbbe010 CR3: 0000000012d10000 CR4: 00000000001506f0
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
