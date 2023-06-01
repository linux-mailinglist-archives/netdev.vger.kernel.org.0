Return-Path: <netdev+bounces-7244-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42E0471F491
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 23:24:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA16B280F5A
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 21:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E45E524127;
	Thu,  1 Jun 2023 21:24:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC99324122
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 21:24:25 +0000 (UTC)
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BE71A6
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 14:24:20 -0700 (PDT)
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-33b50b22030so10775815ab.3
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 14:24:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685654659; x=1688246659;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Blfp+qDnSUKlgbp98HaynHRQ4FrH5MpEBQOEFp5dVeI=;
        b=dpUfEscS1Pf1mRQhtPPKQvd9CeLxz0DiOOlCdAG92iSOin/haZ0OzFqpn0Bg/ZEUgB
         16bTLAErykO49hZ8+xtt6bD1PxBd67QhnFs6tTA+ri+EO2eynzvidoYqyprYpsgL86sl
         hJwMTxkB/MzeiLdiZxhxU7yPrgouAK2n2kuQaJm4Fy2aKAyUcX2W+jlFQqHTFljoiAgS
         h42+7EzMph82PpTZIjcoYCNC5Gz9hC3f6hWopJu2h8d+EvJos/tQemoVnYKtuUStKsFe
         g7mzJBc8I9teoClT3or4/IS/2XiIFYb+fxUIo6V9Ko6LqTRqsECUq48pi390fouC+jC4
         99Dg==
X-Gm-Message-State: AC+VfDwDVMCmSg4h+jzO6sJ7MqfjL6ID+olXuJ6ylGpQHHW1HM2bShxm
	sjE0k+6nEE7LleyiQES8xbyZnTJ8J7gJsRJzvv9m+ZCnucjt
X-Google-Smtp-Source: ACHHUZ6Mn5OwzpSxpnk+Qj/cLbIAZI4exZA++M/YNa+M4M5miNQLmqrOfRvtYsY6ST1rEw4uQZXsXdtyUk535KlBD6jCr6IFHgFa
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:d581:0:b0:331:9a82:33f8 with SMTP id
 a1-20020a92d581000000b003319a8233f8mr3187247iln.3.1685654659408; Thu, 01 Jun
 2023 14:24:19 -0700 (PDT)
Date: Thu, 01 Jun 2023 14:24:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000302fb805fd180f4a@google.com>
Subject: [syzbot] [wireless?] [reiserfs?] general protection fault in __iterate_interfaces
From: syzbot <syzbot+1c54f0eff457978ad5f9@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, johannes@sipsolutions.net, 
	kuba@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, 
	reiserfs-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot found the following issue on:

HEAD commit:    715abedee4cd Add linux-next specific files for 20230515
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13c96725280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6a2745d066dda0ec
dashboard link: https://syzkaller.appspot.com/bug?extid=1c54f0eff457978ad5f9
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1588e999280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1013cbc1280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d4d1d06b34b8/disk-715abede.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3ef33a86fdc8/vmlinux-715abede.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e0006b413ed1/bzImage-715abede.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/0e228936b617/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1c54f0eff457978ad5f9@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc000000839c: 0000 [#1] PREEMPT SMP KASAN
KASAN: probably user-memory-access in range [0x0000000000041ce0-0x0000000000041ce7]
CPU: 0 PID: 5001 Comm: syz-executor387 Not tainted 6.4.0-rc2-next-20230515-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/25/2023
RIP: 0010:__iterate_interfaces+0x85/0x570 net/mac80211/util.c:749
Code: 40 1b 00 00 4c 39 f3 0f 84 82 02 00 00 48 bd 00 00 00 00 00 fc ff df e8 f9 d5 ec f7 4c 8d a3 98 1c 00 00 4c 89 e0 48 c1 e8 03 <0f> b6 04 28 84 c0 74 08 3c 03 0f 8e 5d 04 00 00 8b bb 98 1c 00 00
RSP: 0018:ffffc90000007d90 EFLAGS: 00010206
RAX: 000000000000839c RBX: 0000000000040048 RCX: 0000000000000100
RDX: ffff888026db8000 RSI: ffffffff89974db7 RDI: 0000000000000005
RBP: dffffc0000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: ffffc90000007ff8 R12: 0000000000041ce0
R13: 0000000000000000 R14: ffff88802ab22920 R15: 0000000000000002
FS:  00005555565e7300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000564e16122000 CR3: 0000000021303000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 ieee80211_iterate_active_interfaces_atomic+0x73/0x1c0 net/mac80211/util.c:802
 mac80211_hwsim_beacon+0x101/0x200 drivers/net/wireless/virtual/mac80211_hwsim.c:2283
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0x599/0xa30 kernel/time/hrtimer.c:1749
 hrtimer_run_softirq+0x17f/0x360 kernel/time/hrtimer.c:1766
 __do_softirq+0x1d4/0x905 kernel/softirq.c:553
 invoke_softirq kernel/softirq.c:427 [inline]
 __irq_exit_rcu kernel/softirq.c:632 [inline]
 irq_exit_rcu+0xb7/0x120 kernel/softirq.c:644
 sysvec_apic_timer_interrupt+0x97/0xc0 arch/x86/kernel/apic/apic.c:1106
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:645
RIP: 0010:memmove+0x28/0x1b0 arch/x86/lib/memmove_64.S:44
Code: c3 90 f3 0f 1e fa 48 89 f8 48 39 fe 7d 0f 49 89 f0 49 01 d0 49 39 f8 0f 8f b5 00 00 00 48 83 fa 20 0f 82 01 01 00 00 48 89 d1 <f3> a4 c3 48 81 fa a8 02 00 00 72 05 40 38 fe 74 47 48 83 ea 20 48
RSP: 0018:ffffc900039aefb0 EFLAGS: 00010282
RAX: ffff888073521fb4 RBX: 0000000000000002 RCX: fffffffff2718d78
RDX: ffffffffffffffe1 RSI: ffff888080e0920d RDI: ffff888080e0921d
RBP: 0000000000000020 R08: ffff888073521f85 R09: 0000766972705f73
R10: 667265736965722e R11: 0000766972705f73 R12: 0000000000000001
R13: 0000000000000001 R14: ffff888073521fa4 R15: 0000000000000010
 leaf_paste_entries+0x44d/0x910 fs/reiserfs/lbalance.c:1377
 balance_leaf_finish_node_paste_dirent fs/reiserfs/do_balan.c:1295 [inline]
 balance_leaf_finish_node_paste fs/reiserfs/do_balan.c:1321 [inline]
 balance_leaf_finish_node fs/reiserfs/do_balan.c:1364 [inline]
 balance_leaf+0x9853/0xddc0 fs/reiserfs/do_balan.c:1452
 do_balance+0x319/0x810 fs/reiserfs/do_balan.c:1888
 reiserfs_paste_into_item+0x74b/0x8d0 fs/reiserfs/stree.c:2157
 reiserfs_add_entry+0x8cb/0xcf0 fs/reiserfs/namei.c:565
 reiserfs_mkdir+0x683/0x990 fs/reiserfs/namei.c:860
 xattr_mkdir fs/reiserfs/xattr.c:77 [inline]
 create_privroot fs/reiserfs/xattr.c:890 [inline]
 reiserfs_xattr_init+0x57e/0xbc0 fs/reiserfs/xattr.c:1006
 reiserfs_fill_super+0x2129/0x2eb0 fs/reiserfs/super.c:2175
 mount_bdev+0x357/0x420 fs/super.c:1380
 legacy_get_tree+0x109/0x220 fs/fs_context.c:610
 vfs_get_tree+0x8d/0x350 fs/super.c:1510
 do_new_mount fs/namespace.c:3039 [inline]
 path_mount+0x134b/0x1e40 fs/namespace.c:3369
 do_mount fs/namespace.c:3382 [inline]
 __do_sys_mount fs/namespace.c:3591 [inline]
 __se_sys_mount fs/namespace.c:3568 [inline]
 __x64_sys_mount+0x283/0x300 fs/namespace.c:3568
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fdf5f19069a
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5001 at arch/x86/mm/tlb.c:1295 nmi_uaccess_okay+0x99/0xb0 arch/x86/mm/tlb.c:1295
Modules linked in:
CPU: 0 PID: 5001 Comm: syz-executor387 Not tainted 6.4.0-rc2-next-20230515-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/25/2023
RIP: 0010:nmi_uaccess_okay+0x99/0xb0 arch/x86/mm/tlb.c:1295
Code: d8 48 ba 00 f0 ff ff ff ff 0f 00 41 b8 01 00 00 00 48 21 d0 48 ba 00 00 00 00 80 88 ff ff 48 01 d0 48 39 85 80 00 00 00 74 b0 <0f> 0b eb ac 0f 0b eb a0 e8 5a 59 9d 00 eb 8d e8 53 59 9d 00 eb be
RSP: 0018:ffffc90000007a18 EFLAGS: 00010007
RAX: ffff888021303000 RBX: ffff8880780c8000 RCX: 0000000000000100
RDX: ffff888000000000 RSI: ffffffff8a063b4d RDI: ffff8880780c8080
RBP: ffff8880780c8000 R08: 0000000000000001 R09: 00007fdf5f190670
R10: 00007fdf5f1906b0 R11: 0000000000000001 R12: 00007fdf5f190670
R13: 00007fdf5f1906b0 R14: 0000000000000000 R15: ffffc90000007b88
FS:  00005555565e7300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000564e16122000 CR3: 0000000021303000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 copy_from_user_nmi+0x62/0x150 arch/x86/lib/usercopy.c:39
 copy_code arch/x86/kernel/dumpstack.c:91 [inline]
 show_opcodes+0x5d/0xd0 arch/x86/kernel/dumpstack.c:121
 show_ip arch/x86/kernel/dumpstack.c:144 [inline]
 show_iret_regs+0x30/0x60 arch/x86/kernel/dumpstack.c:149
 __show_regs+0x22/0x680 arch/x86/kernel/process_64.c:75
 show_trace_log_lvl+0x256/0x390 arch/x86/kernel/dumpstack.c:298
 __die_body arch/x86/kernel/dumpstack.c:417 [inline]
 die_addr+0x3c/0xa0 arch/x86/kernel/dumpstack.c:457
 __exc_general_protection arch/x86/kernel/traps.c:783 [inline]
 exc_general_protection+0x129/0x230 arch/x86/kernel/traps.c:728
 asm_exc_general_protection+0x26/0x30 arch/x86/include/asm/idtentry.h:564
RIP: 0010:__iterate_interfaces+0x85/0x570 net/mac80211/util.c:749
Code: 40 1b 00 00 4c 39 f3 0f 84 82 02 00 00 48 bd 00 00 00 00 00 fc ff df e8 f9 d5 ec f7 4c 8d a3 98 1c 00 00 4c 89 e0 48 c1 e8 03 <0f> b6 04 28 84 c0 74 08 3c 03 0f 8e 5d 04 00 00 8b bb 98 1c 00 00
RSP: 0018:ffffc90000007d90 EFLAGS: 00010206
RAX: 000000000000839c RBX: 0000000000040048 RCX: 0000000000000100
RDX: ffff888026db8000 RSI: ffffffff89974db7 RDI: 0000000000000005
RBP: dffffc0000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: ffffc90000007ff8 R12: 0000000000041ce0
R13: 0000000000000000 R14: ffff88802ab22920 R15: 0000000000000002
 ieee80211_iterate_active_interfaces_atomic+0x73/0x1c0 net/mac80211/util.c:802
 mac80211_hwsim_beacon+0x101/0x200 drivers/net/wireless/virtual/mac80211_hwsim.c:2283
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0x599/0xa30 kernel/time/hrtimer.c:1749
 hrtimer_run_softirq+0x17f/0x360 kernel/time/hrtimer.c:1766
 __do_softirq+0x1d4/0x905 kernel/softirq.c:553
 invoke_softirq kernel/softirq.c:427 [inline]
 __irq_exit_rcu kernel/softirq.c:632 [inline]
 irq_exit_rcu+0xb7/0x120 kernel/softirq.c:644
 sysvec_apic_timer_interrupt+0x97/0xc0 arch/x86/kernel/apic/apic.c:1106
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:645
RIP: 0010:memmove+0x28/0x1b0 arch/x86/lib/memmove_64.S:44
Code: c3 90 f3 0f 1e fa 48 89 f8 48 39 fe 7d 0f 49 89 f0 49 01 d0 49 39 f8 0f 8f b5 00 00 00 48 83 fa 20 0f 82 01 01 00 00 48 89 d1 <f3> a4 c3 48 81 fa a8 02 00 00 72 05 40 38 fe 74 47 48 83 ea 20 48
RSP: 0018:ffffc900039aefb0 EFLAGS: 00010282
RAX: ffff888073521fb4 RBX: 0000000000000002 RCX: fffffffff2718d78
RDX: ffffffffffffffe1 RSI: ffff888080e0920d RDI: ffff888080e0921d
RBP: 0000000000000020 R08: ffff888073521f85 R09: 0000766972705f73
R10: 667265736965722e R11: 0000766972705f73 R12: 0000000000000001
R13: 0000000000000001 R14: ffff888073521fa4 R15: 0000000000000010
 leaf_paste_entries+0x44d/0x910 fs/reiserfs/lbalance.c:1377
 balance_leaf_finish_node_paste_dirent fs/reiserfs/do_balan.c:1295 [inline]
 balance_leaf_finish_node_paste fs/reiserfs/do_balan.c:1321 [inline]
 balance_leaf_finish_node fs/reiserfs/do_balan.c:1364 [inline]
 balance_leaf+0x9853/0xddc0 fs/reiserfs/do_balan.c:1452
 do_balance+0x319/0x810 fs/reiserfs/do_balan.c:1888
 reiserfs_paste_into_item+0x74b/0x8d0 fs/reiserfs/stree.c:2157
 reiserfs_add_entry+0x8cb/0xcf0 fs/reiserfs/namei.c:565
 reiserfs_mkdir+0x683/0x990 fs/reiserfs/namei.c:860
 xattr_mkdir fs/reiserfs/xattr.c:77 [inline]
 create_privroot fs/reiserfs/xattr.c:890 [inline]
 reiserfs_xattr_init+0x57e/0xbc0 fs/reiserfs/xattr.c:1006
 reiserfs_fill_super+0x2129/0x2eb0 fs/reiserfs/super.c:2175
 mount_bdev+0x357/0x420 fs/super.c:1380
 legacy_get_tree+0x109/0x220 fs/fs_context.c:610
 vfs_get_tree+0x8d/0x350 fs/super.c:1510
 do_new_mount fs/namespace.c:3039 [inline]
 path_mount+0x134b/0x1e40 fs/namespace.c:3369
 do_mount fs/namespace.c:3382 [inline]
 __do_sys_mount fs/namespace.c:3591 [inline]
 __se_sys_mount fs/namespace.c:3568 [inline]
 __x64_sys_mount+0x283/0x300 fs/namespace.c:3568
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fdf5f19069a
Code: Unable to access opcode bytes at 0x7fdf5f190670.
RSP: 002b:00007fffd1387398 EFLAGS: 00000286 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fdf5f19069a
RDX: 0000000020001100 RSI: 0000000020000180 RDI: 00007fffd13873b0
RBP: 00007fffd13873b0 R08: 00007fffd13873f0 R09: 00000000000010de
R10: 0000000000000080 R11: 0000000000000286 R12: 0000000000000004
R13: 00005555565e72b8 R14: 0000000000000080 R15: 00007fffd13873f0
 </TASK>
----------------
Code disassembly (best guess):
   0:	40 1b 00             	rex sbb (%rax),%eax
   3:	00 4c 39 f3          	add    %cl,-0xd(%rcx,%rdi,1)
   7:	0f 84 82 02 00 00    	je     0x28f
   d:	48 bd 00 00 00 00 00 	movabs $0xdffffc0000000000,%rbp
  14:	fc ff df
  17:	e8 f9 d5 ec f7       	callq  0xf7ecd615
  1c:	4c 8d a3 98 1c 00 00 	lea    0x1c98(%rbx),%r12
  23:	4c 89 e0             	mov    %r12,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	0f b6 04 28          	movzbl (%rax,%rbp,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	74 08                	je     0x3a
  32:	3c 03                	cmp    $0x3,%al
  34:	0f 8e 5d 04 00 00    	jle    0x497
  3a:	8b bb 98 1c 00 00    	mov    0x1c98(%rbx),%edi


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

