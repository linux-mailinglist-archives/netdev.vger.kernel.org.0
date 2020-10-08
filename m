Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22AB286FAD
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 09:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbgJHHk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 03:40:26 -0400
Received: from mail-io1-f80.google.com ([209.85.166.80]:52874 "EHLO
        mail-io1-f80.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbgJHHkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 03:40:20 -0400
Received: by mail-io1-f80.google.com with SMTP id e10so3159730ioq.19
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 00:40:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=sY2IwiMHaNHjrlHF4HKmprZAKOkbqITB/BHAQtltvXw=;
        b=a5D0Ujio9vzjKQhrK0IQDWJ3tS8KIisX9CTVSOjbhqHYp3IcChn7b5MTfPPAb459DG
         1WNKJGzhhQcS2UXOYXwYRMQBljtKeim9ZlGpXANNtth1LdQ/VSWT7GVkG9OOxIAK85ZG
         N1TNaS1df6mgj2b/F20OmOtQ5avtEOP47gAjo8177A8mMaK7NxNnPCiUUys/Z9PZpFXR
         gElCtPxR22FHxLh6GXAJNr39UvRWm4lkwLrODJF8cVulSQ4nHqSvaiawm+1+BpFbvhau
         HM9z4lXSU4hqRM/DcGGqOf4M3PFmaNyOFGABO7Sc0fmns4vLfz0ZjK8NwTgNh3sf5x0k
         dwqA==
X-Gm-Message-State: AOAM5310wLAj0O50Byp67wEopH3DAB0QnfDz0dBHGsMrappn/Bi+8ndG
        3VxLqgoKuYV5ZO3KjK+ZSN0QEjV6XA8RUuaDoOcqOPLwT0Zt
X-Google-Smtp-Source: ABdhPJwu338smk3gnI3WmrD/qM6p1msBcGtR1Ta0xpsNG36bwiBcJaaXiNnNP6YdutsZLGdAJD1QSK7cyG98n9+UUaew2TcaV5Gs
MIME-Version: 1.0
X-Received: by 2002:a6b:b5c2:: with SMTP id e185mr4988645iof.106.1602142818040;
 Thu, 08 Oct 2020 00:40:18 -0700 (PDT)
Date:   Thu, 08 Oct 2020 00:40:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008c848805b123f174@google.com>
Subject: WARNING in ieee80211_ibss_csa_beacon
From:   syzbot <syzbot+b6c9fe29aefe68e4ad34@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c85fb28b Merge tag 'arm64-fixes' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15b2b400500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=de7f697da23057c7
dashboard link: https://syzkaller.appspot.com/bug?extid=b6c9fe29aefe68e4ad34
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b6c9fe29aefe68e4ad34@syzkaller.appspotmail.com

WARNING: CPU: 1 PID: 11321 at net/mac80211/ibss.c:504 ieee80211_ibss_csa_beacon+0x4e9/0x5a0 net/mac80211/ibss.c:504
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 11321 Comm: kworker/u4:0 Not tainted 5.9.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy10 ieee80211_csa_finalize_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1d6/0x29e lib/dump_stack.c:118
 panic+0x2c0/0x800 kernel/panic.c:231
 __warn+0x227/0x250 kernel/panic.c:600
 report_bug+0x1b1/0x2e0 lib/bug.c:198
 handle_bug+0x42/0x80 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x16/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:ieee80211_ibss_csa_beacon+0x4e9/0x5a0 net/mac80211/ibss.c:504
Code: e8 fc 29 8b f9 b8 f4 ff ff ff eb 0a e8 f0 29 8b f9 b8 00 01 00 00 48 83 c4 30 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 d7 29 8b f9 <0f> 0b b8 ea ff ff ff eb e3 e8 c9 29 8b f9 0f 0b e9 88 fb ff ff 48
RSP: 0018:ffffc9000ab5fbf8 EFLAGS: 00010293
RAX: ffffffff87e9d419 RBX: ffff88804cc20580 RCX: ffff888016268280
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff88804cc23490 R08: dffffc0000000000 R09: fffffbfff16c82b4
R10: fffffbfff16c82b4 R11: 0000000000000000 R12: ffff8880a21a18c0
R13: ffff8880a21a18ba R14: ffff8880a21a0c00 R15: ffff8880a21a18e0
 ieee80211_set_after_csa_beacon net/mac80211/cfg.c:3043 [inline]
 __ieee80211_csa_finalize net/mac80211/cfg.c:3099 [inline]
 ieee80211_csa_finalize+0x46f/0x960 net/mac80211/cfg.c:3122
 ieee80211_csa_finalize_work+0xfb/0x140 net/mac80211/cfg.c:3147
 process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
 worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
 kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
