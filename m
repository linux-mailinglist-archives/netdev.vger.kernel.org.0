Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F39278318
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 10:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbgIYIsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 04:48:19 -0400
Received: from mail-il1-f207.google.com ([209.85.166.207]:34082 "EHLO
        mail-il1-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbgIYIsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 04:48:18 -0400
Received: by mail-il1-f207.google.com with SMTP id i18so1351812ils.1
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 01:48:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xpqbTZfStSIuVEoObRsHHR2i+19fjYogGRuP7YNgucU=;
        b=dtyjKPyoZXneEo0V3CB4TAkehnxhMEsSM5y8AUtWjclCrOHenRHb80gaNadQXHtNC0
         LLt1pY3VW3Ypizj8MxUfPOsoIYU+2ag/RJDXS8gzQQfwmHQtDL3JWKCikcZ4WIz3mtk0
         h6KXxcwQ/hBEiPknRY+al+wqY9EJf5osx5xSZPRtHGkCKM1OusZ+2JuGSNAkswJ/eL66
         a+cLTJoJsgeS8JS0c+Wf9XPGq25CyuGMLZActPlAl55lXMNVV3BWS+5tRIYKhyhoQDjJ
         qJqvbHZ59CaqO2m9NHATnuhQVvyqSS+4VOd9KhxwcHJek8PJKfi7PwbBCLW9QfdB9nm0
         Y9yA==
X-Gm-Message-State: AOAM53051y2oXhuXKlF/qHzgYeAFA4HM82VLUav+KElTIbXF2BHkb8f1
        XE9kas+278R6D+xSjuSWS0Pt53uwT+24tN2/7gNbMy9URyZ5
X-Google-Smtp-Source: ABdhPJzfhbhiI0fVgF5zyslswraw0CBpn5piWBElJg2i6ojq4f7/o6M3yJ6QoxDpdNhEvORVPpN79BZSaI0Di5Mqo1Chgzt6BJx8
MIME-Version: 1.0
X-Received: by 2002:a6b:194:: with SMTP id 142mr2476060iob.18.1601023697066;
 Fri, 25 Sep 2020 01:48:17 -0700 (PDT)
Date:   Fri, 25 Sep 2020 01:48:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bd9ee505b01f60e2@google.com>
Subject: WARNING in hrtimer_forward
From:   syzbot <syzbot+ca740b95a16399ceb9a5@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    12450081 libbpf: Fix native endian assumption when parsing..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=10bf85c5900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5ac0d21536db480b
dashboard link: https://syzkaller.appspot.com/bug?extid=ca740b95a16399ceb9a5
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ca740b95a16399ceb9a5@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 9082 at kernel/time/hrtimer.c:932 hrtimer_forward+0x1e3/0x260 kernel/time/hrtimer.c:932
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 9082 Comm: syz-executor.4 Not tainted 5.9.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x382/0x7fb kernel/panic.c:231
 __warn.cold+0x20/0x4b kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:hrtimer_forward+0x1e3/0x260 kernel/time/hrtimer.c:932
Code: e5 4d 0f 4e ec e8 1d 25 10 00 4c 89 6b 20 e8 14 25 10 00 4c 89 f0 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 e8 fd 24 10 00 <0f> 0b 45 31 f6 eb dd e8 f1 24 10 00 4c 89 e0 48 8b 3c 24 48 99 48
RSP: 0018:ffffc90000da8d90 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88805cb74b78 RCX: ffffffff816606b8
RDX: ffff88805a4aa380 RSI: ffffffff81660803 RDI: 0000000000000001
RBP: 00000000061a8000 R08: 0000000000000001 R09: ffff88805a4aac60
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000002b545ee359 R14: 0000000000000001 R15: dffffc0000000000
 mac80211_hwsim_beacon+0x159/0x1a0 drivers/net/wireless/mac80211_hwsim.c:1726
 __run_hrtimer kernel/time/hrtimer.c:1524 [inline]
 __hrtimer_run_queues+0x6a9/0xfc0 kernel/time/hrtimer.c:1588
 hrtimer_run_softirq+0x17b/0x360 kernel/time/hrtimer.c:1605
 __do_softirq+0x1f8/0xb23 kernel/softirq.c:298
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0x235/0x280 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x51/0xf0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
RIP: 0010:_raw_spin_unlock_irq+0x4b/0x80 kernel/locking/spinlock.c:199
Code: c0 b8 6b fc 89 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 75 31 48 83 3d c6 df d5 01 00 74 25 fb 66 0f 1f 44 00 00 <bf> 01 00 00 00 e8 ab 59 2a f9 65 8b 05 74 72 db 77 85 c0 74 02 5d
RSP: 0018:ffffc9000767f550 EFLAGS: 00000286
RAX: 1ffffffff13f8d77 RBX: ffff88805a4aa380 RCX: 0000000000000006
RDX: dffffc0000000000 RSI: 0000000000000002 RDI: 0000000000000000
RBP: ffff8880ae535e00 R08: 0000000000000001 R09: ffffffff8d0b69ef
R10: fffffbfff1a16d3d R11: 0000000000000000 R12: ffff8880ae535e00
R13: ffff888087046300 R14: 0000000000000000 R15: 0000000000000001
 finish_lock_switch kernel/sched/core.c:3517 [inline]
 finish_task_switch+0x150/0x790 kernel/sched/core.c:3617
 context_switch kernel/sched/core.c:3781 [inline]
 __schedule+0xed1/0x2280 kernel/sched/core.c:4527
 preempt_schedule_irq+0xbf/0x1b0 kernel/sched/core.c:4785
 irqentry_exit_cond_resched kernel/entry/common.c:333 [inline]
 irqentry_exit_cond_resched kernel/entry/common.c:325 [inline]
 irqentry_exit+0x65/0x90 kernel/entry/common.c:363
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
RIP: 0010:__sanitizer_cov_trace_pc+0x42/0x60 kernel/kcov.c:202
Code: 24 74 0f f6 c4 01 74 35 8b 82 2c 14 00 00 85 c0 74 2b 8b 82 08 14 00 00 83 f8 02 75 20 48 8b 8a 10 14 00 00 8b 92 0c 14 00 00 <48> 8b 01 48 83 c0 01 48 39 c2 76 07 48 89 34 c1 48 89 01 c3 66 2e
RSP: 0018:ffffc9000767f780 EFLAGS: 00000246
RAX: 0000000000000002 RBX: ffffc9000767f918 RCX: ffffc90011138000
RDX: 0000000000040000 RSI: ffffffff83889163 RDI: ffffc9000767f938
RBP: ffff88808c3a5f00 R08: 0000000000000000 R09: ffffffff8a68da47
R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88808ea8f818 R14: ffff88808c3a5f18 R15: 0000000000000002
 tomoyo_same_path_number_acl+0x63/0x2c0 security/tomoyo/file.c:639
 tomoyo_update_domain+0x34c/0x850 security/tomoyo/domain.c:128
 tomoyo_update_path_number_acl security/tomoyo/file.c:691 [inline]
 tomoyo_write_file+0x68b/0x7f0 security/tomoyo/file.c:1034
 tomoyo_write_domain2+0x116/0x1d0 security/tomoyo/common.c:1152
 tomoyo_add_entry security/tomoyo/common.c:2042 [inline]
 tomoyo_supervisor+0xbc4/0xef0 security/tomoyo/common.c:2103
 tomoyo_audit_path_number_log security/tomoyo/file.c:235 [inline]
 tomoyo_path_number_perm+0x419/0x590 security/tomoyo/file.c:734
 security_file_ioctl+0x50/0xb0 security/security.c:1480
 __do_sys_ioctl fs/ioctl.c:747 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0xb3/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e179
Code: 3d b2 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 0b b2 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f720959bc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000000153c0 RCX: 000000000045e179
RDX: 0000000020000000 RSI: 0000000000008914 RDI: 0000000000000006
RBP: 000000000118d028 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cff4
R13: 00007ffdf66d8fdf R14: 00007f720959c9c0 R15: 000000000118cff4
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
