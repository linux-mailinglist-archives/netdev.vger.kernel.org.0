Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8F140B63E
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 19:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhINRyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 13:54:44 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:47725 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhINRyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 13:54:40 -0400
Received: by mail-io1-f72.google.com with SMTP id f1-20020a5edf01000000b005b85593f933so16843335ioq.14
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 10:53:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=d/BCEmiQUQZFxfE+JV0m+UftuHUj+57emuJFfJpTsxc=;
        b=zlGMRdqEFyBYJz5XvYPOxNPsESKWS2TkSK6U/C/O2iKgmrDBc9QCUa/a6Xy23d6viI
         CXi3blZjIGkJytZNJ2viVqkEP+B0kB22MBa54FiSothCBd91mQxVGzYinB9rcZV3fN9f
         9fScbBBFm+DkHGJHStptlEmTT/ODoO0MXKKwXmilmT5CgM3hY7/zCBZW6yW0wYt7fgyW
         ExaDpHCrANHdrOMyJvvOi2B4JJ4TZK0qL+dTSme7+R0t4XdDJcMJHmDmr5iIVlxAaGV4
         F0UGEnV4GKY6K/uf+GGBlegCx9Nv3sY3t8GOqIIQpQOZas7pYbZcHoRXyF73o7jOiJO7
         24Yg==
X-Gm-Message-State: AOAM531KEVjJnljt7TWFm98HwE73EM/lbYyyR7XCem6qZ8EnihXQo8iB
        BexHN3szpoG3O9FLm8PHmNvvXN/7nUdByxBJ7bK9QDSvWKsH
X-Google-Smtp-Source: ABdhPJzDkCxXta1Ys0R39HdGljue8uKEVN5XjQJBQYyOREPJAfUKUuvYUlVWUcBJJ1OeMxQRRf+GQ3Dduv+80XvpG4iqF+/4RQtb
MIME-Version: 1.0
X-Received: by 2002:a6b:5819:: with SMTP id m25mr14781670iob.105.1631642003271;
 Tue, 14 Sep 2021 10:53:23 -0700 (PDT)
Date:   Tue, 14 Sep 2021 10:53:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000001788e05cbf84285@google.com>
Subject: [syzbot] WARNING in ieee80211_parse_tx_radiotap
From:   syzbot <syzbot+0196ac871673f0c20f68@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3384c7c7641b selftests/bpf: Test new __sk_buff field hwtst..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1555b31b300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6ddc7bf7ff3cd202
dashboard link: https://syzkaller.appspot.com/bug?extid=0196ac871673f0c20f68
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0196ac871673f0c20f68@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 10717 at include/net/mac80211.h:989 ieee80211_rate_set_vht include/net/mac80211.h:989 [inline]
WARNING: CPU: 0 PID: 10717 at include/net/mac80211.h:989 ieee80211_parse_tx_radiotap+0x101e/0x12d0 net/mac80211/tx.c:2244
Modules linked in:
CPU: 0 PID: 10717 Comm: syz-executor.5 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ieee80211_rate_set_vht include/net/mac80211.h:989 [inline]
RIP: 0010:ieee80211_parse_tx_radiotap+0x101e/0x12d0 net/mac80211/tx.c:2244
Code: 48 c1 ea 03 0f b6 04 02 84 c0 0f 84 41 fc ff ff 0f 8f 3b fc ff ff 48 8b 7c 24 10 e8 3c 1a 2e f9 e9 2c fc ff ff e8 b2 d9 e6 f8 <0f> 0b e9 6d ff ff ff e8 f6 19 2e f9 e9 10 fe ff ff e8 cc 19 2e f9
RSP: 0018:ffffc9000186f3e8 EFLAGS: 00010216
RAX: 0000000000000618 RBX: ffff88804ef76500 RCX: ffffc900143a5000
RDX: 0000000000040000 RSI: ffffffff888f478e RDI: 0000000000000003
RBP: 00000000ffffffff R08: 0000000000000000 R09: 0000000000000100
R10: ffffffff888f46f9 R11: 0000000000000000 R12: 00000000fffffff8
R13: ffff88804ef7653c R14: 0000000000000001 R15: 0000000000000004
FS:  00007fbf5718f700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2de23000 CR3: 000000006a671000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
 ieee80211_monitor_select_queue+0xa6/0x250 net/mac80211/iface.c:740
 netdev_core_pick_tx+0x169/0x2e0 net/core/dev.c:4089
 __dev_queue_xmit+0x6f9/0x3710 net/core/dev.c:4165
 __bpf_tx_skb net/core/filter.c:2114 [inline]
 __bpf_redirect_no_mac net/core/filter.c:2139 [inline]
 __bpf_redirect+0x5ba/0xd20 net/core/filter.c:2162
 ____bpf_clone_redirect net/core/filter.c:2429 [inline]
 bpf_clone_redirect+0x2ae/0x420 net/core/filter.c:2401
 bpf_prog_eeb6f53a69e5c6a2+0x59/0x234
 bpf_dispatcher_nop_func include/linux/bpf.h:717 [inline]
 __bpf_prog_run include/linux/filter.h:624 [inline]
 bpf_prog_run include/linux/filter.h:631 [inline]
 bpf_test_run+0x381/0xa30 net/bpf/test_run.c:119
 bpf_prog_test_run_skb+0xb84/0x1ee0 net/bpf/test_run.c:663
 bpf_prog_test_run kernel/bpf/syscall.c:3307 [inline]
 __sys_bpf+0x2137/0x5df0 kernel/bpf/syscall.c:4605
 __do_sys_bpf kernel/bpf/syscall.c:4691 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4689 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4689
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbf5718f188 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665f9
RDX: 0000000000000048 RSI: 0000000020000080 RDI: 000000000000000a
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007fffc508498f R14: 00007fbf5718f300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
