Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82192C36AA
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 03:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgKYCQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 21:16:21 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:50803 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbgKYCQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 21:16:19 -0500
Received: by mail-io1-f72.google.com with SMTP id l14so497060ioj.17
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 18:16:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=6VIJ5IwnX0ZeqUGt6VG60v0fau25OfzFdCcAMNNzl6M=;
        b=KumnHfEqM97RlR+eT0QblLvLFVpUn64TgpcF8jbmEepoZ9kC0yWhSR4INpLly7S0Dj
         xQVhrJcL8YLWFtj9hyEpmVxJoIawh/uBCb2ptYSmNXy6+prm7kC2WhXXT2X3z5Xg8f7m
         fH1dqf+2xOeqvof9GfollnKhfjwx4xnfImJjoMWRznFItpUHkjPt9sQV2UKRNJNRcI8S
         P8rxtTZlaUsnpdQgzqPkmTaX5NLoVWVeqUocIDKv0sLRN6r6ZM6y3Ybscvd3JMnrJbtf
         4qFK48qtkZdQzRps1o94BXAcLmam8o0E6w59geh/IJhFXaSJkS5NCwml0fDoLALSbGSm
         rwgg==
X-Gm-Message-State: AOAM531U2CXohR3Pc6r5YykfxUaHcw0YIfY/eqAlYRiGL4iJ+ylpflJ1
        LGIR6A5HptZ7F565V0vFtd3SNwXEEY70G6rW/FSCHAhOmAjo
X-Google-Smtp-Source: ABdhPJyf6XtH9g0m9h5hGn2groR7LAeuOpT63CFq6bteIkDj4QL2RhHsa5FvrWjxP9X9kPllsUvmQIV80FTnel40HDAAbRppzVVS
MIME-Version: 1.0
X-Received: by 2002:a92:6403:: with SMTP id y3mr1290488ilb.72.1606270576956;
 Tue, 24 Nov 2020 18:16:16 -0800 (PST)
Date:   Tue, 24 Nov 2020 18:16:16 -0800
In-Reply-To: <00000000000064f6cd05b1a04a2c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000271c8805b4e5036b@google.com>
Subject: Re: WARNING in __rate_control_send_low
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    80145ac2 Merge tag 's390-5.10-5' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=130e5a79500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b81aff78c272da44
dashboard link: https://syzkaller.appspot.com/bug?extid=fdc5123366fb9c3fdc6d
compiler:       gcc (GCC) 10.1.0-syz 20200507
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12bf662d500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11671c8b500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fdc5123366fb9c3fdc6d@syzkaller.appspotmail.com

------------[ cut here ]------------
no supported rates for sta (null) (0xffffffff, band 0) in rate_mask 0x0 with flags 0x0
WARNING: CPU: 1 PID: 8503 at net/mac80211/rate.c:375 __rate_control_send_low+0x4d0/0x6d0 net/mac80211/rate.c:375
Modules linked in:
CPU: 1 PID: 8503 Comm: systemd-sysctl Not tainted 5.10.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__rate_control_send_low+0x4d0/0x6d0 net/mac80211/rate.c:375
Code: 14 48 89 44 24 08 e8 7f dd 25 f9 44 8b 44 24 24 45 89 e9 44 89 e1 48 8b 74 24 08 44 89 f2 48 c7 c7 a0 f7 61 8a e8 fc 5b 62 00 <0f> 0b e9 1c fe ff ff e8 54 dd 25 f9 48 8b 44 24 10 48 8d 78 7f 48
RSP: 0018:ffffc90000d90a40 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff888026ce8de8 RCX: 0000000000000000
RDX: ffff88801e450000 RSI: ffffffff8158d875 RDI: fffff520001b213a
RBP: ffff888144343148 R08: 0000000000000001 R09: ffff8880b9f30627
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000000 R14: 00000000ffffffff R15: 0000000000000090
FS:  0000000000000000(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fde93cedab4 CR3: 0000000012e10000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 rate_control_send_low+0x265/0x730 net/mac80211/rate.c:400
 rate_control_get_rate+0x1b9/0x5a0 net/mac80211/rate.c:913
 __ieee80211_beacon_get+0xb06/0x1aa0 net/mac80211/tx.c:4924
 ieee80211_beacon_get_tim+0x88/0x910 net/mac80211/tx.c:4951
 ieee80211_beacon_get include/net/mac80211.h:4912 [inline]
 mac80211_hwsim_beacon_tx+0x111/0x910 drivers/net/wireless/mac80211_hwsim.c:1729
 __iterate_interfaces+0x1e5/0x520 net/mac80211/util.c:792
 ieee80211_iterate_active_interfaces_atomic+0x8d/0x170 net/mac80211/util.c:828
 mac80211_hwsim_beacon+0xd5/0x1a0 drivers/net/wireless/mac80211_hwsim.c:1782
 __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
 __hrtimer_run_queues+0x693/0xea0 kernel/time/hrtimer.c:1583
 hrtimer_run_softirq+0x17b/0x360 kernel/time/hrtimer.c:1600
 __do_softirq+0x2a0/0x9f6 kernel/softirq.c:298
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0xaa/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0x132/0x200 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x4d/0x100 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:631
RIP: 0010:__this_cpu_preempt_check+0xd/0x20 lib/smp_processor_id.c:65
Code: 00 00 48 c7 c6 c0 90 9d 89 48 c7 c7 00 91 9d 89 e9 b8 fe ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 0f 1f 44 00 00 48 89 ee 5d <48> c7 c7 40 91 9d 89 e9 97 fe ff ff cc cc cc cc cc cc cc eb 1e 0f
RSP: 0018:ffffc900016ff918 EFLAGS: 00000283
RAX: 0000000000000003 RBX: ffff8880101ad800 RCX: ffffffffffffffff
RDX: fffffffffffffffd RSI: ffffffff8956fa40 RDI: ffffffff8956fa40
RBP: 0000000000000088 R08: 0000000000000001 R09: ffffea0000c3d9b3
R10: ffffffffffffffff R11: 0000000000000000 R12: ffff8880101ad890
R13: fffffffffffffffd R14: 0000000000000020 R15: 0000000000000011
 __mod_memcg_lruvec_state+0x10e/0x350 mm/memcontrol.c:837
 __mod_lruvec_page_state include/linux/memcontrol.h:847 [inline]
 __dec_lruvec_page_state include/linux/memcontrol.h:1346 [inline]
 page_remove_rmap+0x289/0x1c00 mm/rmap.c:1349
 zap_pte_range mm/memory.c:1253 [inline]
 zap_pmd_range mm/memory.c:1357 [inline]
 zap_pud_range mm/memory.c:1386 [inline]
 zap_p4d_range mm/memory.c:1407 [inline]
 unmap_page_range+0xe30/0x2640 mm/memory.c:1428
 unmap_single_vma+0x198/0x300 mm/memory.c:1473
 unmap_vmas+0x168/0x2e0 mm/memory.c:1505
 exit_mmap+0x2b1/0x530 mm/mmap.c:3222
 __mmput+0x122/0x470 kernel/fork.c:1079
 mmput+0x53/0x60 kernel/fork.c:1100
 exit_mm kernel/exit.c:486 [inline]
 do_exit+0xa72/0x29b0 kernel/exit.c:796
 do_group_exit+0x125/0x310 kernel/exit.c:906
 __do_sys_exit_group kernel/exit.c:917 [inline]
 __se_sys_exit_group kernel/exit.c:915 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:915
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fde953c6618
Code: Unable to access opcode bytes at RIP 0x7fde953c65ee.
RSP: 002b:00007ffdb9f65758 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fde953c6618
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00007fde956a38e0 R08: 00000000000000e7 R09: fffffffffffffee8
R10: 00007fde93881158 R11: 0000000000000246 R12: 00007fde956a38e0
R13: 00007fde956a8c20 R14: 0000000000000000 R15: 0000000000000000

