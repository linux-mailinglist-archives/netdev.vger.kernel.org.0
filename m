Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCFB32F9B6
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 12:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbhCFL2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 06:28:50 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:44163 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbhCFL2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 06:28:17 -0500
Received: by mail-il1-f200.google.com with SMTP id c11so4002899ilq.11
        for <netdev@vger.kernel.org>; Sat, 06 Mar 2021 03:28:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=+vfSdO+SL3Qb4u87AJJ+RYM5MXyih+emXtKp5NK9jp0=;
        b=dd1mPIKTi5iJYJ1GKpnngdYqd7oBtt+X3dunsNHwFBej3mVRKW3l9q8ZMYDqL6MVog
         RpRAFUOGWA313EyfnNoePsg64zI5Mje+ZCnjy/CR45nNHHUJ9S547VBwS2XlYvr76XfZ
         xdO1MNoTCgyHKc3nyLeaNJ580G1kW8qIm6cfhWIb/8IHQv4qH4T/EezBFR+cFmVftKWv
         w8LtLQJwlEwoW2HqbGpmTzF7yUR7257jr42B4nw2zb9YeuRDnHeeN3NoUi1T/PQR4yKz
         gqWxlZYRLcOLEiOKuXWDW8mr+t+ncMhjccP+bZdYFP4wQ3avytnHPqyeRjGmLX4n8Qi7
         sLVg==
X-Gm-Message-State: AOAM532mm3a3TyAij/J94SqSGqbnKxc29LyZA8cHykrYQHNYYa6B2Upe
        kY6lOMZdpC+hEqMRlFkG13rhriVEAiEZTGm8EayX/Y7jGb9+
X-Google-Smtp-Source: ABdhPJziCEqzKon0OaJlKlz5oXBilnbCKhYwoGWECyXG9W+BLbGVSYRzKoWmPckCfn+3veI8RqdWcRfVsZB4yVHdQ3rNrSEumjzt
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1608:: with SMTP id t8mr12838661ilu.79.1615030097317;
 Sat, 06 Mar 2021 03:28:17 -0800 (PST)
Date:   Sat, 06 Mar 2021 03:28:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004094ff05bcdc7ffb@google.com>
Subject: [syzbot] bpf boot error: WARNING in kvm_wait
From:   syzbot <syzbot+46fc491326a456ff8127@syzkaller.appspotmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    edbea922 veth: Store queue_mapping independently of XDP pr..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=113ae02ad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=402784bff477e1ac
dashboard link: https://syzkaller.appspot.com/bug?extid=46fc491326a456ff8127

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+46fc491326a456ff8127@syzkaller.appspotmail.com

------------[ cut here ]------------
raw_local_irq_restore() called with IRQs enabled
WARNING: CPU: 0 PID: 4787 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
Modules linked in:
CPU: 0 PID: 4787 Comm: systemd-getty-g Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
Code: be ff cc cc cc cc cc cc cc cc cc cc cc 80 3d 1e 62 b0 04 00 74 01 c3 48 c7 c7 a0 8e 6b 89 c6 05 0d 62 b0 04 01 e8 57 da be ff <0f> 0b c3 48 39 77 10 0f 84 97 00 00 00 66 f7 47 22 f0 ff 74 4b 48
RSP: 0018:ffffc900012efc40 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffffffff8be28b80 RCX: 0000000000000000
RDX: ffff888023de5340 RSI: ffffffff815bea35 RDI: fffff5200025df7a
RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff815b77be R11: 0000000000000000 R12: 0000000000000003
R13: fffffbfff17c5170 R14: 0000000000000001 R15: ffff8880b9c35f40
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa257bcaab4 CR3: 000000000bc8e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 kvm_wait arch/x86/kernel/kvm.c:860 [inline]
 kvm_wait+0xc9/0xe0 arch/x86/kernel/kvm.c:837
 pv_wait arch/x86/include/asm/paravirt.h:564 [inline]
 pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:470 [inline]
 __pv_queued_spin_lock_slowpath+0x8b8/0xb40 kernel/locking/qspinlock.c:508
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:554 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
 do_raw_spin_lock+0x200/0x2b0 kernel/locking/spinlock_debug.c:113
 spin_lock include/linux/spinlock.h:354 [inline]
 check_stack_usage kernel/exit.c:715 [inline]
 do_exit+0x1d6a/0x2ae0 kernel/exit.c:868
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fa2592a3618
Code: Unable to access opcode bytes at RIP 0x7fa2592a35ee.
RSP: 002b:00007ffc579980b8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fa2592a3618
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00007fa2595808e0 R08: 00000000000000e7 R09: fffffffffffffee8
R10: 00007fa25775e158 R11: 0000000000000246 R12: 00007fa2595808e0
R13: 00007fa259585c20 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
