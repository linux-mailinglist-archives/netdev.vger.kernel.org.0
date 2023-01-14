Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB75366A9B8
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 07:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjANGpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 01:45:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjANGpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 01:45:49 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAC93A93
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 22:45:47 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id i14-20020a056e020d8e00b003034b93bd07so17595297ilj.14
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 22:45:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=THFlPJ7tMxLlWFFBk7hTvqZFdbpi07VUzqMCXl6OMHY=;
        b=qOIyJJBfRksk9wi1mTpqeaMbM4hoBNm9OvpwgJz2mpR2Tj/w9rAcZliTaUambcfwix
         VxFaNhnYj02WNhqA4b9cZ/ZhdkyeSrkWJvVy5M5qb+YNNPyTsOd0ciRklBqjbWtf99z+
         dT5B9Coqxgt5quFAgw2z2tdoyHixbVcAqOH82NlLEGls7zJVvqyqRIojNOPHh0AJkNnH
         22QhY6N4BugaS2nW57Ye4v06cvRioChPQDj8EcCVbzFa5zqXRXBDSlmTYd4Q85ubPEWn
         o93lzp6GsW72/jaiPSlt6mpwgrjwHLyNh6sUmv6F+N//0hRhGOSv5dV6TTFiCXTRCna+
         CLMA==
X-Gm-Message-State: AFqh2kqfxgNUcXWDSJl6uy8I3MoCoRo60WS0p5YGbHXIYDkT4HGJ3u4l
        01og5rIcO/d+fOxmBvdv1JJYEa8MnTrJRmPcm+CsNdvs/v9k
X-Google-Smtp-Source: AMrXdXsxlAHaSACZXxt4jh0Kfvb2HJn9vvtRVBj0vBikxDh3d6WV6wK1LDi6sDFwpLlI3UJZs9+VXKQGUniem14QqPxQLq6HrjHN
MIME-Version: 1.0
X-Received: by 2002:a02:cb8d:0:b0:38a:b7c8:5317 with SMTP id
 u13-20020a02cb8d000000b0038ab7c85317mr7097036jap.121.1673678746564; Fri, 13
 Jan 2023 22:45:46 -0800 (PST)
Date:   Fri, 13 Jan 2023 22:45:46 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000028409505f233b3f0@google.com>
Subject: [syzbot] general protection fault in pn533_out_complete
From:   syzbot <syzbot+1e608ba4217c96d1952f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, krzysztof.kozlowski@linaro.org,
        linux-kernel@vger.kernel.org, linuxlovemin@yonsei.ac.kr,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    435bf71af3a0 Add linux-next specific files for 20230110
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=11926ea4480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2de08b99ad4f49c
dashboard link: https://syzkaller.appspot.com/bug?extid=1e608ba4217c96d1952f
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c88886480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1480685a480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8541d2e988c8/disk-435bf71a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/09d8d0545d93/vmlinux-435bf71a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f99de1e244bf/bzImage-435bf71a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1e608ba4217c96d1952f@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.2.0-rc3-next-20230110-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:pn533_out_complete.cold+0x15/0x44 drivers/nfc/pn533/usb.c:441
Code: df e8 aa 07 fa f7 e9 39 ff ff ff 48 89 df e8 9d 07 fa f7 eb e0 e8 d6 19 ac f7 4c 89 ea b8 ff ff 37 00 48 c1 ea 03 48 c1 e0 2a <80> 3c 02 00 75 1f 49 8b 7d 00 44 89 e2 48 c7 c6 80 be d0 8a 48 81
RSP: 0018:ffffc900001e0a58 EFLAGS: 00010086
RAX: dffffc0000000000 RBX: ffff88801f705800 RCX: 0000000000000100
RDX: 0000000000000000 RSI: ffffffff89d5a3ea RDI: 0000000000000005
RBP: ffffc90000a1ee70 R08: 0000000000000005 R09: 0000000000000000
R10: ffffffffffffffb9 R11: 0000000000000001 R12: ffffffffffffffb9
R13: 0000000000000000 R14: 0100000000000001 R15: 00000000ffffffb9
FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fffc3520bb0 CR3: 00000000262ac000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 __usb_hcd_giveback_urb+0x2b6/0x5c0 drivers/usb/core/hcd.c:1671
 usb_hcd_giveback_urb+0x384/0x430 drivers/usb/core/hcd.c:1754
 dummy_timer+0x1203/0x32d0 drivers/usb/gadget/udc/dummy_hcd.c:1988
 call_timer_fn+0x1da/0x800 kernel/time/timer.c:1700
 expire_timers+0x234/0x330 kernel/time/timer.c:1751
 __run_timers kernel/time/timer.c:2022 [inline]
 __run_timers kernel/time/timer.c:1995 [inline]
 run_timer_softirq+0x326/0x910 kernel/time/timer.c:2035
 __do_softirq+0x1fb/0xaf6 kernel/softirq.c:571
 invoke_softirq kernel/softirq.c:445 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
 irq_exit_rcu+0x9/0x20 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x97/0xc0 arch/x86/kernel/apic/apic.c:1107
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:649
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:70 [inline]
RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:130 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:113 [inline]
RIP: 0010:acpi_idle_do_entry+0x1fd/0x2a0 drivers/acpi/processor_idle.c:570
Code: 89 de e8 c6 c5 7a f7 84 db 75 ac e8 4d c9 7a f7 e8 c8 49 81 f7 66 90 e8 41 c9 7a f7 0f 00 2d ba cc aa 00 e8 35 c9 7a f7 fb f4 <9c> 5b 81 e3 00 02 00 00 fa 31 ff 48 89 de e8 f0 c5 7a f7 48 85 db
RSP: 0018:ffffc90000177d10 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88813fe71d40 RSI: ffffffff8a06f48b RDI: 0000000000000000
RBP: ffff88813ff2a864 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000001
R13: ffff88813ff2a800 R14: ffff88813ff2a864 R15: ffff88801867f004
 acpi_idle_enter+0x368/0x510 drivers/acpi/processor_idle.c:707
 cpuidle_enter_state+0x1af/0xd40 drivers/cpuidle/cpuidle.c:239
 cpuidle_enter+0x4e/0xa0 drivers/cpuidle/cpuidle.c:356
 call_cpuidle kernel/sched/idle.c:155 [inline]
 cpuidle_idle_call kernel/sched/idle.c:236 [inline]
 do_idle+0x3f7/0x590 kernel/sched/idle.c:303
 cpu_startup_entry+0x18/0x20 kernel/sched/idle.c:400
 start_secondary+0x256/0x300 arch/x86/kernel/smpboot.c:264
 secondary_startup_64_no_verify+0xce/0xdb
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:pn533_out_complete.cold+0x15/0x44 drivers/nfc/pn533/usb.c:441
Code: df e8 aa 07 fa f7 e9 39 ff ff ff 48 89 df e8 9d 07 fa f7 eb e0 e8 d6 19 ac f7 4c 89 ea b8 ff ff 37 00 48 c1 ea 03 48 c1 e0 2a <80> 3c 02 00 75 1f 49 8b 7d 00 44 89 e2 48 c7 c6 80 be d0 8a 48 81
RSP: 0018:ffffc900001e0a58 EFLAGS: 00010086
RAX: dffffc0000000000 RBX: ffff88801f705800 RCX: 0000000000000100
RDX: 0000000000000000 RSI: ffffffff89d5a3ea RDI: 0000000000000005
RBP: ffffc90000a1ee70 R08: 0000000000000005 R09: 0000000000000000
R10: ffffffffffffffb9 R11: 0000000000000001 R12: ffffffffffffffb9
R13: 0000000000000000 R14: 0100000000000001 R15: 00000000ffffffb9
FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fffc3520bb0 CR3: 00000000262ac000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	e8 aa 07 fa f7       	callq  0xf7fa07af
   5:	e9 39 ff ff ff       	jmpq   0xffffff43
   a:	48 89 df             	mov    %rbx,%rdi
   d:	e8 9d 07 fa f7       	callq  0xf7fa07af
  12:	eb e0                	jmp    0xfffffff4
  14:	e8 d6 19 ac f7       	callq  0xf7ac19ef
  19:	4c 89 ea             	mov    %r13,%rdx
  1c:	b8 ff ff 37 00       	mov    $0x37ffff,%eax
  21:	48 c1 ea 03          	shr    $0x3,%rdx
  25:	48 c1 e0 2a          	shl    $0x2a,%rax
* 29:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2d:	75 1f                	jne    0x4e
  2f:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  33:	44 89 e2             	mov    %r12d,%edx
  36:	48 c7 c6 80 be d0 8a 	mov    $0xffffffff8ad0be80,%rsi
  3d:	48                   	rex.W
  3e:	81                   	.byte 0x81


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
