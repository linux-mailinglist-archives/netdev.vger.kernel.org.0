Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986F86564D6
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 20:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbiLZTrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 14:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiLZTrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 14:47:40 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36AA6271A;
        Mon, 26 Dec 2022 11:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=OH1oPXjc5XzU8ylm4o4xHBCplWroUmVwhV7ZbXZRfiE=;
        t=1672084058; x=1673293658; b=NbYuKv1RnKv/JMweEFn/Mko4IiQfNyDLTh6sCOlpRNpayC4
        sB9JoF1iTc7UhQpgQ+1Sf91C+vw8F80aP6XnYDIyiFOYLIig1h72OLAQ9o7Zul0PDVfYJY04owEz9
        YW6uC0pKPo6T1+r5EaV5hD+/ZOd4hmOGtRq7vhJJOREya1gb9EHeRJ3uEh44+e+ZeFNvIk8ERT2B+
        nxhON2T3bJK8wPfNv9B1SmmnmeGsL0yeNVEcD+aG3g4UH13vCuIFC9FFePSzQl1b5bsZCwccxrKIh
        cUDQfNg990AIT+YZOjZeZPa7drTrCq+mYbuIvzXiNv4vTok0I4J6SR4Oq2nfI91w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1p9tRc-001JLs-06;
        Mon, 26 Dec 2022 20:47:32 +0100
Message-ID: <b1c831458900997f3b06bfbad7cc2f1a83134d63.camel@sipsolutions.net>
Subject: Re: [syzbot] INFO: task hung in rfkill_sync_work
From:   Johannes Berg <johannes@sipsolutions.net>
To:     syzbot <syzbot+9ef743bba3a17c756174@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date:   Mon, 26 Dec 2022 20:47:30 +0100
In-Reply-To: <000000000000788a6905f0c06160@google.com>
References: <000000000000788a6905f0c06160@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Krzysztof

Looks like another virt NFC issue.

johannes


On Mon, 2022-12-26 at 11:45 -0800, syzbot wrote:
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    9d2f6060fe4c Merge tag 'trace-v6.2-1' of git://git.kernel=
...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D1635b08848000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D85327a149d5f5=
0f
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D9ef743bba3a17c7=
56174
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binuti=
ls for Debian) 2.35.2
> userspace arch: i386
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D156edba0480=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1555607448000=
0
>=20
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/719b7f41a208/dis=
k-9d2f6060.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/aaff85f16125/vmlinu=
x-9d2f6060.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/25463cba3710/b=
zImage-9d2f6060.xz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+9ef743bba3a17c756174@syzkaller.appspotmail.com
>=20
> INFO: task kworker/0:7:5202 blocked for more than 143 seconds.
>       Not tainted 6.1.0-syzkaller-14364-g9d2f6060fe4c #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:kworker/0:7     state:D stack:28192 pid:5202  ppid:2      flags:0x00=
004000
> Workqueue: events rfkill_sync_work
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5244 [inline]
>  __schedule+0xb8a/0x5450 kernel/sched/core.c:6555
>  schedule+0xde/0x1b0 kernel/sched/core.c:6631
>  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6690
>  __mutex_lock_common kernel/locking/mutex.c:679 [inline]
>  __mutex_lock+0xa48/0x1360 kernel/locking/mutex.c:747
>  rfkill_sync_work+0x1c/0xc0 net/rfkill/core.c:1040
>  process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
>  worker_thread+0x669/0x1090 kernel/workqueue.c:2436
>  kthread+0x2e8/0x3a0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>  </TASK>
> INFO: task kworker/0:9:5210 blocked for more than 143 seconds.
>       Not tainted 6.1.0-syzkaller-14364-g9d2f6060fe4c #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:kworker/0:9     state:D stack:28352 pid:5210  ppid:2      flags:0x00=
004000
> Workqueue: events rfkill_global_led_trigger_worker
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5244 [inline]
>  __schedule+0xb8a/0x5450 kernel/sched/core.c:6555
>  schedule+0xde/0x1b0 kernel/sched/core.c:6631
>  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6690
>  __mutex_lock_common kernel/locking/mutex.c:679 [inline]
>  __mutex_lock+0xa48/0x1360 kernel/locking/mutex.c:747
>  rfkill_global_led_trigger_worker+0x1b/0x120 net/rfkill/core.c:181
>  process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
>  worker_thread+0x669/0x1090 kernel/workqueue.c:2436
>  kthread+0x2e8/0x3a0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>  </TASK>
> INFO: task syz-executor299:5750 blocked for more than 143 seconds.
>       Not tainted 6.1.0-syzkaller-14364-g9d2f6060fe4c #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor299 state:D stack:26944 pid:5750  ppid:5096   flags:0x20=
004002
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5244 [inline]
>  __schedule+0xb8a/0x5450 kernel/sched/core.c:6555
>  schedule+0xde/0x1b0 kernel/sched/core.c:6631
>  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6690
>  __mutex_lock_common kernel/locking/mutex.c:679 [inline]
>  __mutex_lock+0xa48/0x1360 kernel/locking/mutex.c:747
>  rfkill_unregister+0xde/0x2c0 net/rfkill/core.c:1130
>  nfc_unregister_device+0x96/0x330 net/nfc/core.c:1167
>  virtual_ncidev_close+0x52/0xb0 drivers/nfc/virtual_ncidev.c:163
>  __fput+0x27c/0xa90 fs/file_table.c:320
>  task_work_run+0x16f/0x270 kernel/task_work.c:179
>  exit_task_work include/linux/task_work.h:38 [inline]
>  do_exit+0xaa8/0x2950 kernel/exit.c:867
>  do_group_exit+0xd4/0x2a0 kernel/exit.c:1010
>  __do_sys_exit_group kernel/exit.c:1021 [inline]
>  __se_sys_exit_group kernel/exit.c:1019 [inline]
>  __ia32_sys_exit_group+0x3e/0x50 kernel/exit.c:1019
>  do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
>  __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
>  do_fast_syscall_32+0x33/0x70 arch/x86/entry/common.c:203
>  entry_SYSENTER_compat_after_hwframe+0x70/0x82
> RIP: 0023:0xf7ebe549
> RSP: 002b:00000000ffe472dc EFLAGS: 00000292 ORIG_RAX: 00000000000000fc
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 00000000f7f63fa0 RSI: 00000000f7f64358 RDI: 00000000f7f64358
> RBP: 00000000f7f648c8 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> INFO: task syz-executor299:5754 blocked for more than 143 seconds.
>       Not tainted 6.1.0-syzkaller-14364-g9d2f6060fe4c #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor299 state:D stack:27352 pid:5754  ppid:5099   flags:0x20=
000004
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5244 [inline]
>  __schedule+0xb8a/0x5450 kernel/sched/core.c:6555
>  schedule+0xde/0x1b0 kernel/sched/core.c:6631
>  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6690
>  __mutex_lock_common kernel/locking/mutex.c:679 [inline]
>  __mutex_lock+0xa48/0x1360 kernel/locking/mutex.c:747
>  device_lock include/linux/device.h:831 [inline]
>  nfc_dev_down+0x2d/0x2d0 net/nfc/core.c:143
>  nfc_rfkill_set_block+0x33/0xd0 net/nfc/core.c:179
>  rfkill_set_block+0x1f9/0x540 net/rfkill/core.c:345
>  rfkill_fop_write+0x2c7/0x570 net/rfkill/core.c:1286
>  vfs_write+0x2db/0xdd0 fs/read_write.c:582
>  ksys_write+0x1ec/0x250 fs/read_write.c:637
>  do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
>  __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
>  do_fast_syscall_32+0x33/0x70 arch/x86/entry/common.c:203
>  entry_SYSENTER_compat_after_hwframe+0x70/0x82
> RIP: 0023:0xf7ebe549
> RSP: 002b:00000000ffe4733c EFLAGS: 00000246 ORIG_RAX: 0000000000000004
> RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020000080
> RDX: 0000000000000008 RSI: 0000000003700000 RDI: 0000000001000000
> RBP: 0000000000075861 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> INFO: task syz-executor299:5759 blocked for more than 144 seconds.
>       Not tainted 6.1.0-syzkaller-14364-g9d2f6060fe4c #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor299 state:D stack:27544 pid:5759  ppid:5102   flags:0x20=
004004
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5244 [inline]
>  __schedule+0xb8a/0x5450 kernel/sched/core.c:6555
>  schedule+0xde/0x1b0 kernel/sched/core.c:6631
>  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6690
>  __mutex_lock_common kernel/locking/mutex.c:679 [inline]
>  __mutex_lock+0xa48/0x1360 kernel/locking/mutex.c:747
>  rfkill_register+0x3a/0xb00 net/rfkill/core.c:1057
>  nfc_register_device+0x124/0x3b0 net/nfc/core.c:1132
>  nci_register_device+0x7cb/0xb50 net/nfc/nci/core.c:1257
>  virtual_ncidev_open+0x14f/0x230 drivers/nfc/virtual_ncidev.c:148
>  misc_open+0x37a/0x4a0 drivers/char/misc.c:165
>  chrdev_open+0x26a/0x770 fs/char_dev.c:414
>  do_dentry_open+0x6cc/0x13f0 fs/open.c:882
>  do_open fs/namei.c:3557 [inline]
>  path_openat+0x1bbc/0x2a50 fs/namei.c:3714
>  do_filp_open+0x1ba/0x410 fs/namei.c:3741
>  do_sys_openat2+0x16d/0x4c0 fs/open.c:1310
>  do_sys_open fs/open.c:1326 [inline]
>  __do_compat_sys_openat fs/open.c:1386 [inline]
>  __se_compat_sys_openat fs/open.c:1384 [inline]
>  __ia32_compat_sys_openat+0x143/0x1f0 fs/open.c:1384
>  do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
>  __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
>  do_fast_syscall_32+0x33/0x70 arch/x86/entry/common.c:203
>  entry_SYSENTER_compat_after_hwframe+0x70/0x82
> RIP: 0023:0xf7ebe549
> RSP: 002b:00000000ffe4732c EFLAGS: 00000286 ORIG_RAX: 0000000000000127
> RAX: ffffffffffffffda RBX: 00000000ffffff9c RCX: 0000000020000080
> RDX: 0000000000000002 RSI: 0000000000000000 RDI: 00000000f7f2f03f
> RBP: 0000000000000012 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> INFO: task syz-executor299:5761 blocked for more than 144 seconds.
>       Not tainted 6.1.0-syzkaller-14364-g9d2f6060fe4c #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor299 state:D stack:28208 pid:5761  ppid:5097   flags:0x20=
000004
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5244 [inline]
>  __schedule+0xb8a/0x5450 kernel/sched/core.c:6555
>  schedule+0xde/0x1b0 kernel/sched/core.c:6631
>  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6690
>  __mutex_lock_common kernel/locking/mutex.c:679 [inline]
>  __mutex_lock+0xa48/0x1360 kernel/locking/mutex.c:747
>  misc_open+0x63/0x4a0 drivers/char/misc.c:129
>  chrdev_open+0x26a/0x770 fs/char_dev.c:414
>  do_dentry_open+0x6cc/0x13f0 fs/open.c:882
>  do_open fs/namei.c:3557 [inline]
>  path_openat+0x1bbc/0x2a50 fs/namei.c:3714
>  do_filp_open+0x1ba/0x410 fs/namei.c:3741
>  do_sys_openat2+0x16d/0x4c0 fs/open.c:1310
>  do_sys_open fs/open.c:1326 [inline]
>  __do_compat_sys_openat fs/open.c:1386 [inline]
>  __se_compat_sys_openat fs/open.c:1384 [inline]
>  __ia32_compat_sys_openat+0x143/0x1f0 fs/open.c:1384
>  do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
>  __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
>  do_fast_syscall_32+0x33/0x70 arch/x86/entry/common.c:203
>  entry_SYSENTER_compat_after_hwframe+0x70/0x82
> RIP: 0023:0xf7ebe549
> RSP: 002b:00000000ffe4732c EFLAGS: 00000286 ORIG_RAX: 0000000000000127
> RAX: ffffffffffffffda RBX: 00000000ffffff9c RCX: 0000000020000080
> RDX: 0000000000000002 RSI: 0000000000000000 RDI: 00000000f7f2f03f
> RBP: 0000000000000012 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> INFO: task syz-executor299:5763 blocked for more than 144 seconds.
>       Not tainted 6.1.0-syzkaller-14364-g9d2f6060fe4c #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor299 state:D stack:28208 pid:5763  ppid:5100   flags:0x20=
000004
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5244 [inline]
>  __schedule+0xb8a/0x5450 kernel/sched/core.c:6555
>  schedule+0xde/0x1b0 kernel/sched/core.c:6631
>  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6690
>  __mutex_lock_common kernel/locking/mutex.c:679 [inline]
>  __mutex_lock+0xa48/0x1360 kernel/locking/mutex.c:747
>  misc_open+0x63/0x4a0 drivers/char/misc.c:129
>  chrdev_open+0x26a/0x770 fs/char_dev.c:414
>  do_dentry_open+0x6cc/0x13f0 fs/open.c:882
>  do_open fs/namei.c:3557 [inline]
>  path_openat+0x1bbc/0x2a50 fs/namei.c:3714
>  do_filp_open+0x1ba/0x410 fs/namei.c:3741
>  do_sys_openat2+0x16d/0x4c0 fs/open.c:1310
>  do_sys_open fs/open.c:1326 [inline]
>  __do_compat_sys_openat fs/open.c:1386 [inline]
>  __se_compat_sys_openat fs/open.c:1384 [inline]
>  __ia32_compat_sys_openat+0x143/0x1f0 fs/open.c:1384
>  do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
>  __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
>  do_fast_syscall_32+0x33/0x70 arch/x86/entry/common.c:203
>  entry_SYSENTER_compat_after_hwframe+0x70/0x82
> RIP: 0023:0xf7ebe549
> RSP: 002b:00000000ffe4732c EFLAGS: 00000286 ORIG_RAX: 0000000000000127
> RAX: ffffffffffffffda RBX: 00000000ffffff9c RCX: 0000000020000080
> RDX: 0000000000000002 RSI: 0000000000000000 RDI: 00000000f7f2f03f
> RBP: 0000000000000012 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> INFO: task syz-executor299:5768 blocked for more than 145 seconds.
>       Not tainted 6.1.0-syzkaller-14364-g9d2f6060fe4c #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor299 state:D stack:28088 pid:5768  ppid:5101   flags:0x20=
004004
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5244 [inline]
>  __schedule+0xb8a/0x5450 kernel/sched/core.c:6555
>  schedule+0xde/0x1b0 kernel/sched/core.c:6631
>  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6690
>  __mutex_lock_common kernel/locking/mutex.c:679 [inline]
>  __mutex_lock+0xa48/0x1360 kernel/locking/mutex.c:747
>  misc_open+0x63/0x4a0 drivers/char/misc.c:129
>  chrdev_open+0x26a/0x770 fs/char_dev.c:414
>  do_dentry_open+0x6cc/0x13f0 fs/open.c:882
>  do_open fs/namei.c:3557 [inline]
>  path_openat+0x1bbc/0x2a50 fs/namei.c:3714
>  do_filp_open+0x1ba/0x410 fs/namei.c:3741
>  do_sys_openat2+0x16d/0x4c0 fs/open.c:1310
>  do_sys_open fs/open.c:1326 [inline]
>  __do_compat_sys_openat fs/open.c:1386 [inline]
>  __se_compat_sys_openat fs/open.c:1384 [inline]
>  __ia32_compat_sys_openat+0x143/0x1f0 fs/open.c:1384
>  do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
>  __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
>  do_fast_syscall_32+0x33/0x70 arch/x86/entry/common.c:203
>  entry_SYSENTER_compat_after_hwframe+0x70/0x82
> RIP: 0023:0xf7ebe549
> RSP: 002b:00000000ffe4732c EFLAGS: 00000286 ORIG_RAX: 0000000000000127
> RAX: ffffffffffffffda RBX: 00000000ffffff9c RCX: 0000000020000080
> RDX: 0000000000000002 RSI: 0000000000000000 RDI: 00000000f7f2f03f
> RBP: 0000000000000012 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
>=20
> Showing all locks held in the system:
> 1 lock held by rcu_tasks_kthre/12:
>  #0: ffffffff8c790c70 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tas=
ks_one_gp+0x26/0xc70 kernel/rcu/tasks.h:507
> 1 lock held by rcu_tasks_trace/13:
>  #0: ffffffff8c790970 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: r=
cu_tasks_one_gp+0x26/0xc70 kernel/rcu/tasks.h:507
> 1 lock held by khungtaskd/28:
>  #0: ffffffff8c7917c0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_loc=
ks+0x57/0x264 kernel/locking/lockdep.c:6494
> 1 lock held by klogd/4423:
>  #0: ffff8880b983b598 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nes=
ted+0x2f/0x120 kernel/sched/core.c:537
> 2 locks held by getty/4749:
>  #0: ffff88814c048098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wa=
it+0x26/0x80 drivers/tty/tty_ldisc.c:244
>  #1: ffffc900015b02f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_r=
ead+0xef4/0x13e0 drivers/tty/n_tty.c:2177
> 3 locks held by kworker/0:7/5202:
>  #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomi=
c64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomi=
c_long_set include/linux/atomic/atomic-long.h:41 [inline]
>  #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_lon=
g_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
>  #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_d=
ata kernel/workqueue.c:636 [inline]
>  #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_p=
ool_and_clear_pending kernel/workqueue.c:663 [inline]
>  #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: process_on=
e_work+0x86d/0x1710 kernel/workqueue.c:2260
>  #1: ffffc90003d8fda8 ((work_completion)(&rfkill->sync_work)){+.+.}-{0:0}=
, at: process_one_work+0x8a1/0x1710 kernel/workqueue.c:2264
>  #2: ffffffff8e4e30e8 (rfkill_global_mutex){+.+.}-{3:3}, at: rfkill_sync_=
work+0x1c/0xc0 net/rfkill/core.c:1040
> 3 locks held by kworker/0:9/5210:
>  #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomi=
c64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomi=
c_long_set include/linux/atomic/atomic-long.h:41 [inline]
>  #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_lon=
g_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
>  #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_d=
ata kernel/workqueue.c:636 [inline]
>  #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_p=
ool_and_clear_pending kernel/workqueue.c:663 [inline]
>  #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: process_on=
e_work+0x86d/0x1710 kernel/workqueue.c:2260
>  #1: ffffc90004357da8 ((work_completion)(&rfkill_global_led_trigger_work)=
){+.+.}-{0:0}, at: process_one_work+0x8a1/0x1710 kernel/workqueue.c:2264
>  #2: ffffffff8e4e30e8 (rfkill_global_mutex){+.+.}-{3:3}, at: rfkill_globa=
l_led_trigger_worker+0x1b/0x120 net/rfkill/core.c:181
> 2 locks held by syz-executor299/5750:
>  #0: ffff888075e3c100 (&dev->mutex){....}-{3:3}, at: device_lock include/=
linux/device.h:831 [inline]
>  #0: ffff888075e3c100 (&dev->mutex){....}-{3:3}, at: nfc_unregister_devic=
e+0x62/0x330 net/nfc/core.c:1165
>  #1: ffffffff8e4e30e8 (rfkill_global_mutex){+.+.}-{3:3}, at: rfkill_unreg=
ister+0xde/0x2c0 net/rfkill/core.c:1130
> 2 locks held by syz-executor299/5754:
>  #0: ffffffff8e4e30e8 (rfkill_global_mutex){+.+.}-{3:3}, at: rfkill_fop_w=
rite+0x160/0x570 net/rfkill/core.c:1278
>  #1: ffff888075e3c100 (&dev->mutex){....}-{3:3}, at: device_lock include/=
linux/device.h:831 [inline]
>  #1: ffff888075e3c100 (&dev->mutex){....}-{3:3}, at: nfc_dev_down+0x2d/0x=
2d0 net/nfc/core.c:143
> 3 locks held by syz-executor299/5759:
>  #0: ffffffff8d243a88 (misc_mtx){+.+.}-{3:3}, at: misc_open+0x63/0x4a0 dr=
ivers/char/misc.c:129
>  #1: ffff888021d64100 (&dev->mutex){....}-{3:3}, at: device_lock include/=
linux/device.h:831 [inline]
>  #1: ffff888021d64100 (&dev->mutex){....}-{3:3}, at: nfc_register_device+=
0x9f/0x3b0 net/nfc/core.c:1128
>  #2: ffffffff8e4e30e8 (rfkill_global_mutex){+.+.}-{3:3}, at: rfkill_regis=
ter+0x3a/0xb00 net/rfkill/core.c:1057
> 1 lock held by syz-executor299/5761:
>  #0: ffffffff8d243a88 (misc_mtx){+.+.}-{3:3}, at: misc_open+0x63/0x4a0 dr=
ivers/char/misc.c:129
> 1 lock held by syz-executor299/5763:
>  #0: ffffffff8d243a88 (misc_mtx){+.+.}-{3:3}, at: misc_open+0x63/0x4a0 dr=
ivers/char/misc.c:129
> 1 lock held by syz-executor299/5768:
>  #0: ffffffff8d243a88 (misc_mtx){+.+.}-{3:3}, at: misc_open+0x63/0x4a0 dr=
ivers/char/misc.c:129
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> NMI backtrace for cpu 1
> CPU: 1 PID: 28 Comm: khungtaskd Not tainted 6.1.0-syzkaller-14364-g9d2f60=
60fe4c #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 10/26/2022
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
>  nmi_cpu_backtrace.cold+0x24/0x18a lib/nmi_backtrace.c:111
>  nmi_trigger_cpumask_backtrace+0x333/0x3c0 lib/nmi_backtrace.c:62
>  trigger_all_cpu_backtrace include/linux/nmi.h:148 [inline]
>  check_hung_uninterruptible_tasks kernel/hung_task.c:220 [inline]
>  watchdog+0xc75/0xfc0 kernel/hung_task.c:377
>  kthread+0x2e8/0x3a0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>  </TASK>
> Sending NMI from CPU 1 to CPUs 0:
> NMI backtrace for cpu 0
> CPU: 0 PID: 5083 Comm: kworker/u4:3 Not tainted 6.1.0-syzkaller-14364-g9d=
2f6060fe4c #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 10/26/2022
> Workqueue: events_unbound toggle_allocation_gate
> RIP: 0010:arch_static_branch arch/x86/include/asm/jump_label.h:27 [inline=
]
> RIP: 0010:static_key_false include/linux/jump_label.h:207 [inline]
> RIP: 0010:native_write_msr arch/x86/include/asm/msr.h:147 [inline]
> RIP: 0010:wrmsrl arch/x86/include/asm/msr.h:262 [inline]
> RIP: 0010:native_x2apic_icr_write arch/x86/include/asm/apic.h:238 [inline=
]
> RIP: 0010:__x2apic_send_IPI_dest arch/x86/kernel/apic/x2apic_phys.c:123 [=
inline]
> RIP: 0010:x2apic_send_IPI+0x97/0xe0 arch/x86/kernel/apic/x2apic_phys.c:48
> Code: b7 13 0f ae f0 0f ae e8 b9 00 04 00 00 41 83 fc 02 44 89 e0 48 0f 4=
4 c1 48 c1 e2 20 b9 30 08 00 00 48 09 d0 48 c1 ea 20 0f 30 <66> 90 5b 5d 41=
 5c c3 5b 31 d2 48 89 c6 bf 30 08 00 00 5d 41 5c e9
> RSP: 0018:ffffc90003bdf8d0 EFLAGS: 00000202
> RAX: 00000001000000fb RBX: ffff8880b99219e8 RCX: 0000000000000830
> RDX: 0000000000000001 RSI: 00000000000000fb RDI: ffffffff8c12f908
> RBP: 0000000000000001 R08: 0000000000000005 R09: 0000000000000001
> R10: 0000000000000001 R11: 0000000000000000 R12: 00000000000000fb
> R13: ffffc90003bdf910 R14: 0000000000000002 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055a7f7541f68 CR3: 000000000c48e000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  arch_send_call_function_single_ipi arch/x86/include/asm/smp.h:108 [inlin=
e]
>  send_call_function_single_ipi+0x1ed/0x3b0 kernel/sched/core.c:3774
>  smp_call_function_many_cond+0xe64/0x10a0 kernel/smp.c:967
>  on_each_cpu_cond_mask+0x5a/0xa0 kernel/smp.c:1155
>  on_each_cpu include/linux/smp.h:71 [inline]
>  text_poke_sync arch/x86/kernel/alternative.c:1772 [inline]
>  text_poke_bp_batch+0x585/0x6b0 arch/x86/kernel/alternative.c:2032
>  text_poke_flush arch/x86/kernel/alternative.c:2131 [inline]
>  text_poke_flush arch/x86/kernel/alternative.c:2128 [inline]
>  text_poke_finish+0x1a/0x30 arch/x86/kernel/alternative.c:2138
>  arch_jump_label_transform_apply+0x17/0x30 arch/x86/kernel/jump_label.c:1=
46
>  jump_label_update+0x32f/0x410 kernel/jump_label.c:829
>  static_key_disable_cpuslocked+0x156/0x1b0 kernel/jump_label.c:235
>  static_key_disable+0x1a/0x20 kernel/jump_label.c:243
>  toggle_allocation_gate mm/kfence/core.c:804 [inline]
>  toggle_allocation_gate+0x143/0x230 mm/kfence/core.c:791
>  process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
>  worker_thread+0x669/0x1090 kernel/workqueue.c:2436
>  kthread+0x2e8/0x3a0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>  </TASK>
> INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.084=
 msecs
>=20
>=20
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>=20
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
>=20

