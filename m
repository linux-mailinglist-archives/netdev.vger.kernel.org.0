Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878D06D79F8
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 12:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237815AbjDEKkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 06:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237734AbjDEKkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 06:40:07 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEFF55A2;
        Wed,  5 Apr 2023 03:40:02 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id l184so12309181pgd.11;
        Wed, 05 Apr 2023 03:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680691202;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jTgOpRTUpBCosSx793RVdLeqSwFgCSS0O2U2bxuiSrA=;
        b=mGn3ZU68NuHdVoVJsIhEVXRfCXpaRPvAA0HjnJEF13t+Y3v4wWlztOrLtFJCha4DGm
         Uh1vwygCTKCK7PSW7yADkT4EJhgDOkWRZb5B6hqKmP27fkJHkLounAnKAwqEnAoRB0hN
         8Wp421V5dw+85vvh3DA5W/Rbw1iwApLWxavVG0Ky78h7ItPOOb3g9MAZeRdzQjIUxhdz
         gnXK9zcXdKbiHHDnkpwOBBvAN0gi1yv3Iy0oyVxhzIjgwNah5ZzCp5EG8cBwhU/RMNCK
         gGdQIzYreyRABD4h9V3cX2VljBciC48EeRCGPnLM68+Ma3e9ZtWGc1yFqnXy2hdzxKX4
         j30g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680691202;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jTgOpRTUpBCosSx793RVdLeqSwFgCSS0O2U2bxuiSrA=;
        b=WwSV9PqWXgeBpBBjNwuO7hdBdNgyLOQZMOHpv5QzSMJf0+M+lBg9njVfT5CsKlYPCt
         Jea+bfki/+QM7JjGjFMrD6fsO8snd7Dq+n7cnq/J4YtH6QsiMISjhvP8z5ARinbMlxEi
         wjLAwh2rzwGzjOYBE8hapRw2u3vQedOu9BN3yE9UCeBDfb05QyZLcorpqgYabxt96CK2
         SyUtw3XSTJkyDrwmMFm7oX0HUcYENjPZOc6c5ZeX8g7MO85lR0zJce1QW+M557N/MEtr
         k7AXg8AwRqCxkPKjyah3ycNh3lAg6VrHoR/dDXSpKdn8hYEJxCH0bpMDeJUYCiEob18m
         08eQ==
X-Gm-Message-State: AAQBX9cOBDEv+uRTkcZv3O6qm1tRLy04Q5//hy0eVisYIEwzQkq2rY5N
        4IOApMeXuCLBHKwUJUJvbqk=
X-Google-Smtp-Source: AKy350YtuOr5Cw9yiPm78N7unyMuWyK9NLowiDO04MsC3NRbJ56efHs1mPd+jFPP5Zxm8FD7jRpybQ==
X-Received: by 2002:aa7:970d:0:b0:627:e024:98ca with SMTP id a13-20020aa7970d000000b00627e02498camr4822784pfg.32.1680691201454;
        Wed, 05 Apr 2023 03:40:01 -0700 (PDT)
Received: from dragonet (dragonet.kaist.ac.kr. [143.248.133.220])
        by smtp.gmail.com with ESMTPSA id n12-20020a63ee4c000000b00502f1256674sm9107958pgk.41.2023.04.05.03.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 03:40:00 -0700 (PDT)
Date:   Wed, 5 Apr 2023 19:39:56 +0900
From:   "Dae R. Jeong" <threeearcat@gmail.com>
To:     johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: INFO: task hung in rfkill_unregister
Message-ID: <ZC1P_MSpORnZZfL_@dragonet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We observed an issue "INFO: task hung in rfkill_unregister" during fuzzing.

Unfortunately, we have not found a reproducer for the crash yet. We
will inform you if we have any update on this crash.  Detailed crash
information is attached below.

Best regards,
Dae R. Jeong

-----
- Kernel version:
6.2

- Crash report:
INFO: task syz-executor.0:10719 blocked for more than 143 seconds.
      Not tainted 6.2.0-32343-g77ace34138e1 #6
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.0  state:D stack:25296 pid:10719 ppid:8106   flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5296 [inline]
 __schedule+0xa63/0x11a0 kernel/sched/core.c:6609
 schedule+0xba/0x180 kernel/sched/core.c:6685
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6744
 __mutex_lock_common+0xebf/0x2490 kernel/locking/mutex.c:679
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x17/0x20 kernel/locking/mutex.c:799
 rfkill_unregister+0xe0/0x290 net/rfkill/core.c:1130
 nfc_unregister_device+0x8d/0x310 net/nfc/core.c:1167
 virtual_ncidev_close+0x6a/0xb0 drivers/nfc/virtual_ncidev.c:163
 __fput+0x472/0x9f0 fs/file_table.c:320
 task_work_run+0x263/0x320 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x1df/0x200 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x2e/0x60 kernel/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x478d29
RSP: 002b:00007fdfd9160be8 EFLAGS: 00000246 ORIG_RAX: 0000000000000021
RAX: 0000000000000005 RBX: 000000000078bf80 RCX: 0000000000478d29
RDX: 0000000000000000 RSI: 0000000000000005 RDI: 0000000000000007
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf88
R13: 000000000078bf8c R14: 000000000078bf80 R15: 00007ffc75961cb0
 </TASK>
INFO: task systemd-rfkill:10728 blocked for more than 143 seconds.
      Not tainted 6.2.0-32343-g77ace34138e1 #6
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:systemd-rfkill  state:D stack:23504 pid:10728 ppid:1      flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5296 [inline]
 __schedule+0xa63/0x11a0 kernel/sched/core.c:6609
 schedule+0xba/0x180 kernel/sched/core.c:6685
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6744
 __mutex_lock_common+0xebf/0x2490 kernel/locking/mutex.c:679
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x17/0x20 kernel/locking/mutex.c:799
 device_lock include/linux/device.h:831 [inline]
 nfc_dev_down+0x33/0x2f0 net/nfc/core.c:143
 nfc_rfkill_set_block+0x2a/0xd0 net/nfc/core.c:179
 rfkill_set_block+0x248/0x520 net/rfkill/core.c:345
 rfkill_fop_write+0x37f/0x8b0 net/rfkill/core.c:1294
 vfs_write+0x320/0xce0 fs/read_write.c:582
 ksys_write+0x1e0/0x320 fs/read_write.c:637
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x35/0x60 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fe17dc101b0
RSP: 002b:00007ffdcca38168 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00005638ecc0c040 RCX: 00007fe17dc101b0
RDX: 0000000000000008 RSI: 00007ffdcca381b0 RDI: 0000000000000003
RBP: 00007ffdcca381a8 R08: 0000000000000003 R09: 0000000000001010
R10: 0000000000000020 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffdcca381a0 R14: 0000000000000000 R15: 0000000000000003
 </TASK>

Showing all locks held in the system:
1 lock held by rcu_tasks_kthre/13:
 #0: ffffffff8ed20bb0 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x30/0xbe0 kernel/rcu/tasks.h:507
1 lock held by rcu_tasks_trace/14:
 #0: ffffffff8ed213b0 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x30/0xbe0 kernel/rcu/tasks.h:507
1 lock held by khungtaskd/41:
 #0: ffffffff8ed209e0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire+0x0/0x30
1 lock held by in:imklog/7763:
 #0: ffff88810c37e168 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xed/0x120 fs/file.c:1046
2 locks held by syz-executor.0/10719:
 #0: ffff88810fea5100 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:831 [inline]
 #0: ffff88810fea5100 (&dev->mutex){....}-{3:3}, at: nfc_unregister_device+0x52/0x310 net/nfc/core.c:1165
 #1: ffffffff90180ae8 (rfkill_global_mutex){+.+.}-{3:3}, at: rfkill_unregister+0xe0/0x290 net/rfkill/core.c:1130
2 locks held by systemd-rfkill/10728:
 #0: ffffffff90180ae8 (rfkill_global_mutex){+.+.}-{3:3}, at: rfkill_fop_write+0x1e4/0x8b0 net/rfkill/core.c:1278
 #1: ffff88810fea5100 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:831 [inline]
 #1: ffff88810fea5100 (&dev->mutex){....}-{3:3}, at: nfc_dev_down+0x33/0x2f0 net/nfc/core.c:143

=============================================

NMI backtrace for cpu 2
CPU: 2 PID: 41 Comm: khungtaskd Not tainted 6.2.0-32343-g77ace34138e1 #6
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x23a/0x350 lib/dump_stack.c:106
 nmi_cpu_backtrace+0x566/0x5e0 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x1e5/0x460 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:148 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:220 [inline]
 watchdog+0xd6f/0xdd0 kernel/hung_task.c:377
 kthread+0x283/0x320 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
Sending NMI from CPU 2 to CPUs 0-1,3:
NMI backtrace for cpu 3
CPU: 3 PID: 7762 Comm: rs:main Q:Reg Not tainted 6.2.0-32343-g77ace34138e1 #6
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
RIP: 0010:ext4_do_update_inode fs/ext4/inode.c:5234 [inline]
RIP: 0010:ext4_mark_iloc_dirty+0x244/0x1f30 fs/ext4/inode.c:5877
Code: 9a ff be 08 00 00 00 48 89 df e8 67 eb 67 ff 48 89 d8 48 c1 e8 03 80 3c 28 00 74 08 48 89 df e8 42 6e 9a ff 48 89 df 48 8b 1b <48> 89 bc 24 d0 00 00 00 e8 ff b3 67 ff 48 bd 00 00 00 00 02 00 00
RSP: 0018:ffffc9001138f568 EFLAGS: 00000246
RAX: 1ffff110221a03cd RBX: 0000004400080000 RCX: ffffffff8248e049
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff888110d01e68
RBP: dffffc0000000000 R08: dffffc0000000000 R09: ffffed10221a03ce
R10: ffffed10221a03ce R11: 0000000000000000 R12: ffff888110d01e18
R13: ffff888029230500 R14: ffffc9001138f750 R15: 1ffff110221a041e
FS:  00007fb4f4dfd700(0000) GS:ffff888135d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc5b9053ab4 CR3: 000000010c641000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __ext4_mark_inode_dirty+0x422/0x730 fs/ext4/inode.c:6081
 ext4_dirty_inode+0xe7/0x130 fs/ext4/inode.c:6110
 __mark_inode_dirty+0x226/0x720 fs/fs-writeback.c:2419
 mark_inode_dirty include/linux/fs.h:2465 [inline]
 generic_write_end+0x196/0x1f0 fs/buffer.c:2184
 ext4_da_write_end+0x6cb/0x990 fs/ext4/inode.c:3175
 generic_perform_write+0x4e7/0x730 mm/filemap.c:3784
 ext4_buffered_write_iter+0x401/0x760 fs/ext4/file.c:285
 ext4_file_write_iter+0x216/0x1ef0
 call_write_iter include/linux/fs.h:2189 [inline]
 new_sync_write fs/read_write.c:491 [inline]
 vfs_write+0x808/0xce0 fs/read_write.c:584
 ksys_write+0x1e0/0x320 fs/read_write.c:637
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x35/0x60 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fb4f96101cd
Code: c2 20 00 00 75 10 b8 01 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 ae fc ff ff 48 89 04 24 b8 01 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 f7 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007fb4f4dfc590 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007fb4e802b640 RCX: 00007fb4f96101cd
RDX: 0000000000000b1c RSI: 00007fb4e802b640 RDI: 0000000000000009
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000293 R12: 00007fb4e802b3c0
R13: 00007fb4f4dfc5b0 R14: 00005643ced2c440 R15: 0000000000000b1c
 </TASK>
NMI backtrace for cpu 1
CPU: 1 PID: 4466 Comm: systemd-journal Not tainted 6.2.0-32343-g77ace34138e1 #6
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
RIP: 0010:lockdep_enabled kernel/locking/lockdep.c:124 [inline]
RIP: 0010:lock_acquire+0xff/0x4f0 kernel/locking/lockdep.c:5647
Code: 65 8b 05 54 cb 99 7e 85 c0 0f 85 ac 01 00 00 65 48 8b 1c 25 40 b8 03 00 4c 8d bb 34 0a 00 00 4c 89 f8 48 c1 e8 03 42 8a 04 28 <84> c0 0f 85 8a 03 00 00 41 83 3f 00 0f 85 7f 01 00 00 48 81 c3 70
RSP: 0018:ffffc900029ffa40 EFLAGS: 00000803
RAX: 1ffff110038d2100 RBX: ffff88801c690000 RCX: 0000000080000002
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
RBP: ffffc900029ffb88 R08: dffffc0000000000 R09: fffffbfff206f7c6
R10: fffffbfff206f7c6 R11: 0000000000000000 R12: 1ffff9200053ff50
R13: dffffc0000000000 R14: 0000000000000000 R15: ffff88801c690a34
FS:  00007f4e738fc8c0(0000) GS:ffff888135c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4e6efd5000 CR3: 0000000106eeb000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0xd1/0x120 kernel/locking/spinlock.c:162
 __debug_check_no_obj_freed lib/debugobjects.c:984 [inline]
 debug_check_no_obj_freed+0xba/0x7e0 lib/debugobjects.c:1027
 slab_free_hook mm/slub.c:1756 [inline]
 slab_free_freelist_hook+0x1e8/0x370 mm/slub.c:1807
 slab_free mm/slub.c:3787 [inline]
 kmem_cache_free+0xff/0x300 mm/slub.c:3809
 putname fs/namei.c:271 [inline]
 user_path_at_empty+0x177/0x1d0 fs/namei.c:2878
 user_path_at include/linux/namei.h:57 [inline]
 do_faccessat+0x4c0/0x9b0 fs/open.c:446
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x35/0x60 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f4e722db9c7
Code: 83 c4 08 48 3d 01 f0 ff ff 73 01 c3 48 8b 0d c8 d4 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 b8 15 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a1 d4 2b 00 f7 d8 64 89 01 48
RSP: 002b:00007fff2b1822c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000015
RAX: ffffffffffffffda RBX: 00007fff2b1851e0 RCX: 00007f4e722db9c7
RDX: 00007f4e73360a00 RSI: 0000000000000000 RDI: 000055d951a4b9a3
RBP: 00007fff2b182300 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000069 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fff2b1851e0 R15: 00007fff2b1827f0
 </TASK>
NMI backtrace for cpu 0 skipped: idling at native_safe_halt arch/x86/include/asm/irqflags.h:51 [inline]
NMI backtrace for cpu 0 skipped: idling at arch_safe_halt arch/x86/include/asm/irqflags.h:89 [inline]
NMI backtrace for cpu 0 skipped: idling at default_idle+0xb/0x10 arch/x86/kernel/process.c:730
----------------
Code disassembly (best guess), 2 bytes skipped:
   0:	be 08 00 00 00       	mov    $0x8,%esi
   5:	48 89 df             	mov    %rbx,%rdi
   8:	e8 67 eb 67 ff       	callq  0xff67eb74
   d:	48 89 d8             	mov    %rbx,%rax
  10:	48 c1 e8 03          	shr    $0x3,%rax
  14:	80 3c 28 00          	cmpb   $0x0,(%rax,%rbp,1)
  18:	74 08                	je     0x22
  1a:	48 89 df             	mov    %rbx,%rdi
  1d:	e8 42 6e 9a ff       	callq  0xff9a6e64
  22:	48 89 df             	mov    %rbx,%rdi
  25:	48 8b 1b             	mov    (%rbx),%rbx
* 28:	48 89 bc 24 d0 00 00 	mov    %rdi,0xd0(%rsp) <-- trapping instruction
  2f:	00
  30:	e8 ff b3 67 ff       	callq  0xff67b434
  35:	48                   	rex.W
  36:	bd 00 00 00 00       	mov    $0x0,%ebp
  3b:	02 00                	add    (%rax),%al
