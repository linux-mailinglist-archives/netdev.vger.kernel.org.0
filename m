Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38FE44AD62
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 13:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242214AbhKIMUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 07:20:12 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:39452 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242041AbhKIMUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 07:20:06 -0500
Received: by mail-io1-f72.google.com with SMTP id r15-20020a6b600f000000b005dde03edc0cso14058446iog.6
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 04:17:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=aCoweEaOvgt71+0i7uxsWqNufLYUKzPDGNM1p0HMj7E=;
        b=Nrhe5qs7uUVXTAQ2quxq9+iAovDtJXM00/vRFbO2QTzIc/53QE+n/b9C8xY1VPHAuG
         RPvm4wYWRxb/fzrekcrXJlzEsYF0RRA13dOa4LywB+NGGt2F0+wUL/DTA0W8D/PHXlHZ
         IKNRGYgpjMfHQNGCLVS++ygJPvIGdIb/MMBFvTvw7CnA/8nLFqYEuEZwvEK8dfDwyvjd
         pdS4YeM4Fj8GlCsrI4PAQh2xFdK3koyaG0ec32xW/yNYUmHrnfwlyl77COyLKv+7/ZQ4
         otER45sa2BmWnJUtmr0S2jczbL9lqBUdxCHIUdUqmFcpuneuTsuwWlb9OjfhdwWbvk9e
         7Hsw==
X-Gm-Message-State: AOAM533qD1Up25vEeMeOqoR9Yvj24tYp8gnISSNfw1ti+zTXLKr2OovW
        5dl0vj2LTUUOs9Jf9EP4G/7QB3R3vj0Nj1n5Zf55+yNOAqii
X-Google-Smtp-Source: ABdhPJxHGqbMCdDPD99fI2rQ3B09+I0TS+iw5PhxMREKjUcnFu0aagRR+VHmZTddB2VF4YbOV6ZUNDwhZ8MzjNnidcIeCpqjHzAd
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:178a:: with SMTP id y10mr4676101ilu.257.1636460240527;
 Tue, 09 Nov 2021 04:17:20 -0800 (PST)
Date:   Tue, 09 Nov 2021 04:17:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000053692705d05a17c1@google.com>
Subject: [syzbot] WARNING in perf_pending_event
From:   syzbot <syzbot+23843634c323e144fd0b@syzkaller.appspotmail.com>
To:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, jolsa@redhat.com,
        kafai@fb.com, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
        peterz@infradead.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    85a90500f9a1 Merge tag 'io_uring-5.14-2021-08-07' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13c8aa81300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5ba4a97de189f896
dashboard link: https://syzkaller.appspot.com/bug?extid=23843634c323e144fd0b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12ac8392300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1039bce6300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+23843634c323e144fd0b@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 8449 at kernel/events/core.c:6407 perf_sigtrap kernel/events/core.c:6407 [inline]
WARNING: CPU: 0 PID: 8449 at kernel/events/core.c:6407 perf_pending_event_disable kernel/events/core.c:6431 [inline]
WARNING: CPU: 0 PID: 8449 at kernel/events/core.c:6407 perf_pending_event+0x4ba/0x560 kernel/events/core.c:6474
Modules linked in:
CPU: 0 PID: 8449 Comm: syz-executor996 Not tainted 5.14.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:perf_sigtrap kernel/events/core.c:6407 [inline]
RIP: 0010:perf_pending_event_disable kernel/events/core.c:6431 [inline]
RIP: 0010:perf_pending_event+0x4ba/0x560 kernel/events/core.c:6474
Code: ff 4c 89 e7 e8 d7 78 27 00 e9 2f ff ff ff e8 ad 78 27 00 e9 3d fc ff ff 4c 89 ff e8 30 79 27 00 e9 fb fb ff ff e8 b6 ba e1 ff <0f> 0b e9 86 fd ff ff e8 ba 78 27 00 e9 7b fe ff ff 48 89 df e8 9d
RSP: 0018:ffffc90000007f38 EFLAGS: 00010046
RAX: 0000000080010001 RBX: ffff88802a04fc40 RCX: 0000000000000000
RDX: ffff8880377e0040 RSI: ffffffff8193268a RDI: ffff888026467958
RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000020
R10: ffffffff819322cb R11: 0000000000000000 R12: ffff8880377e0040
R13: ffff888026467800 R14: ffff88802a04f800 R15: ffff88802a04fc30
FS:  0000000000545300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004d05c0 CR3: 000000003d54f000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 irq_work_single+0x120/0x1f0 kernel/irq_work.c:155
 irq_work_run_list+0x91/0xc0 kernel/irq_work.c:177
 irq_work_run+0x54/0xd0 kernel/irq_work.c:186
 __sysvec_irq_work+0x95/0x3d0 arch/x86/kernel/irq_work.c:22
 sysvec_irq_work+0x8e/0xc0 arch/x86/kernel/irq_work.c:17
 </IRQ>
 asm_sysvec_irq_work+0x12/0x20 arch/x86/include/asm/idtentry.h:664
RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
RIP: 0010:_raw_spin_unlock_irq+0x25/0x40 kernel/locking/spinlock.c:199
Code: 0f 1f 44 00 00 55 48 8b 74 24 08 48 89 fd 48 83 c7 18 e8 3e 1a 2d f8 48 89 ef e8 e6 8f 2d f8 e8 21 cb 4d f8 fb bf 01 00 00 00 <e8> 36 6a 21 f8 65 8b 05 cf b0 d4 76 85 c0 74 02 5d c3 e8 2b 06 d3
RSP: 0018:ffffc90001a17ee8 EFLAGS: 00000202
RAX: 0000000000000315 RBX: 0000000000000000 RCX: 1ffffffff1ad8461
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
RBP: ffff888021b9cb40 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff817b0a38 R11: 0000000000000000 R12: ffff888033f2f320
R13: 0000000000000000 R14: ffff888021b9cb40 R15: ffff8880377e0040
 spin_unlock_irq include/linux/spinlock.h:404 [inline]
 do_group_exit+0x29a/0x310 kernel/exit.c:919
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x444379
Code: 00 49 c7 c0 b8 ff ff ff be e7 00 00 00 ba 3c 00 00 00 eb 12 0f 1f 44 00 00 89 d0 0f 05 48 3d 00 f0 ff ff 77 1c f4 89 f0 0f 05 <48> 3d 00 f0 ff ff 76 e7 f7 d8 64 41 89 00 eb df 0f 1f 80 00 00 00
RSP: 002b:00007fffad23f4c8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00000000004ca370 RCX: 0000000000444379
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffb8 R09: 0000000000f0b5ff
R10: 00007fffad23f550 R11: 0000000000000246 R12: 00000000004ca370
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
