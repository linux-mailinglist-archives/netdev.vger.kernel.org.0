Return-Path: <netdev+bounces-11752-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 58A7C7343F5
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 23:50:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBA5A1C20A3A
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 21:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D6E61109;
	Sat, 17 Jun 2023 21:50:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6671510EF
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 21:50:19 +0000 (UTC)
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F0DC4
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 14:50:14 -0700 (PDT)
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-77de452f2a1so158900139f.2
        for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 14:50:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687038613; x=1689630613;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aSJCAyt3xF7sEyqxnKMLfM7cX52z2CcdTMjwkioi7g0=;
        b=In25qSQG99JerOjJ2+4JNlVPVBqbsRLrSJqwEawuX9tMdCcMUP2O9LJc0rNnPJN/jf
         ss17uYr2CND7CNT70S2JSHXwLc1PQu/WoewRxGJ+vwkH8L5hL1Jn0vTe7lrq1khTJYIv
         WfPqFEtrvJKbYe0z45/AFYXDpZHsysySLrPEfJ4wp6m6ErYnJ8fQI1+ZIrpLU9nYvMvg
         BjOzeieg4IHD1+8Hu+PF2ryNCl6TggNdHnIx3Qd++forfkVWkMq5wMa1QT+s8Vf1cZGK
         S6Xb7hkluLo62eT1KJjRo9n/qWt3JYWW2prBHAp/qcfU427H0pHU4be7kYYig4LMT0rX
         EfPw==
X-Gm-Message-State: AC+VfDxCC6ZmdtNDYNx511S7srRZCNhXr+vafVa+nH49nQ1NozJb31CW
	j+fCHR7GzY1W4/2UbINPP13LhRwqxJVrnBEaxf592S71Mp0f
X-Google-Smtp-Source: ACHHUZ5611mF4MYCW4KX0dBdY08i/nUvLYyQ0YveQOLu8R7AYbEhqPecjo1hlhte4MHUJ2ofl4Sy51stD11O6qK6jFF/Q5apkNP5
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:541:b0:341:e2fe:bddd with SMTP id
 i1-20020a056e02054100b00341e2febdddmr1785962ils.3.1687038613699; Sat, 17 Jun
 2023 14:50:13 -0700 (PDT)
Date: Sat, 17 Jun 2023 14:50:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004ac4d605fe5a49fe@google.com>
Subject: [syzbot] [nfc?] WARNING in nfc_llcp_unregister_device
From: syzbot <syzbot+41c46680254e9cdab0e4@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, krzysztof.kozlowski@linaro.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, linux-nfc@lists.01.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot found the following issue on:

HEAD commit:    15adb51c04cc Merge tag 'devicetree-fixes-for-6.4-3' of git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1782309b280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2da5e3a224efd76
dashboard link: https://syzkaller.appspot.com/bug?extid=41c46680254e9cdab0e4
compiler:       aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/384ffdcca292/non_bootable_disk-15adb51c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e85d507b375f/vmlinux-15adb51c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4c2cb974500b/Image-15adb51c.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+41c46680254e9cdab0e4@syzkaller.appspotmail.com

------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 1 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 1 PID: 32265 Comm: syz-executor.0 Not tainted 6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000533023acac6c
x14: 00000000000000c5 x13: ffff800009fbc5a8 x12: ffff80000a3bfef0
x11: 0000000000000001 x10: 2f4989d5c1644307 x9 : e1eebcc6241e290b
x8 : fdff000013f8de48 x7 : 0000000000000004 x6 : 0000000000000190
x5 : 00000000000f0510 x4 : 0000000000f0000f x3 : 000000000000ffff
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 1 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 1 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 00008852e20cd18e
x14: 00000000000000d7 x13: ffff800009fbc5a8 x12: ffff80000a3bfef0
x11: 0000000000000001 x10: 2f4989d5c1644307 x9 : e1eebcc6241e290b
x8 : fdff000013f8de48 x7 : 0000000000000004 x6 : 0000000000000190
x5 : 00000000000f0510 x4 : 0000000000f0000f x3 : 000000000000ffff
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 0 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 0 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000ab5ac482fc58
x14: 0000000000000183 x13: ffff800009fbc5a8 x12: ffff80000a3bfef0
x11: 0000000000000001 x10: 2f4989d5c1644307 x9 : e1eebcc6241e290b
x8 : fdff000013f8de48 x7 : 0000000000000004 x6 : 0000000000000190
x5 : 00000000000f0510 x4 : 0000000000f0000f x3 : 000000000000ffff
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 0 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 0 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000ad498c41c9f8
x14: 000000000000004b x13: ffff800009fbc5a8 x12: ffff80000a3bfef0
x11: 0000000000000001 x10: 2f4989d5c1644307 x9 : e1eebcc6241e290b
x8 : fdff000013f8de48 x7 : 0000000000000004 x6 : 0000000000000190
x5 : 00000000000f0510 x4 : 0000000000f0000f x3 : 000000000000ffff
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 0 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 0 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000affd51b303a0
x14: 00000000000002e3 x13: ffff800009fbc5a8 x12: ffff80000a3bfef0
x11: 0000000000000001 x10: 2f4989d5c1644307 x9 : e1eebcc6241e290b
x8 : fdff000013f8de48 x7 : 0000000000000004 x6 : 0000000000000190
x5 : 00000000000f0510 x4 : 0000000000f0000f x3 : 000000000000ffff
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 1 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 1 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000b5ac98293636
x14: 0000000000000065 x13: ffff800009fbc5a8 x12: ffff80000a3bfef0
x11: 0000000000000001 x10: 2f4989d5c1644307 x9 : e1eebcc6241e290b
x8 : fdff000013f8de48 x7 : 0000000000000004 x6 : 0000000000000190
x5 : 00000000000f0510 x4 : 0000000000f0000f x3 : 000000000000ffff
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 1 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 1 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 00008b82604c4172
x14: 0000000000000362 x13: ffff800009fbc5a8 x12: ffff80000a3bfef0
x11: 0000000000000001 x10: 2f4989d5c1644307 x9 : e1eebcc6241e290b
x8 : fdff000013f8de48 x7 : 0000000000000004 x6 : 0000000000000190
x5 : 00000000000f0510 x4 : 0000000000f0000f x3 : 000000000000ffff
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 0 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 0 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 00000000fffffffa
x17: 6564207373657264 x16: 6461206c61757472 x15: 697620746120746c
x14: ffff80000a3ecc78 x13: 0000000000001e15 x12: 0000000000000a07
x11: 2073736572646461 x10: ffff80000a49cc78 x9 : 00000000ffffe000
x8 : ffff80000a3ecc78 x7 : ffff80000a49cc78 x6 : 0000000000000000
x5 : 0000000000017ff4 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 0 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 0 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000ffffd8a3bbf8
x14: 0000000000000365 x13: ffff800009fbc5a8 x12: ffff80000a3bfef0
x11: 0000000000000001 x10: 2f4989d5c1644307 x9 : e1eebcc6241e290b
x8 : fdff000013f8de48 x7 : 0000000000000004 x6 : 0000000000000190
x5 : 00000000000f0510 x4 : 0000000000f0000f x3 : 000000000000ffff
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 0 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 0 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000b3ca2889c864
x14: 0000000000000141 x13: ffff800009fbc5a8 x12: ffff80000a3bfef0
x11: 0000000000000001 x10: 2f4989d5c1644307 x9 : e1eebcc6241e290b
x8 : fdff000013f8de48 x7 : 0000000000000004 x6 : 0000000000000190
x5 : 00000000000f0510 x4 : 0000000000f0000f x3 : 000000000000ffff
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
__do_kernel_fault: 99256 callbacks suppressed
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 0 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 0 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 00000000fffffffa
x17: 6564207373657264 x16: 6461206c61757472 x15: 697620746120746c
x14: ffff80000a3ecc78 x13: 0000000000001f77 x12: 0000000000000a7d
x11: 2073736572646461 x10: ffff80000a49cc78 x9 : 00000000ffffe000
x8 : ffff80000a3ecc78 x7 : ffff80000a49cc78 x6 : 0000000000000000
x5 : ffff00007f9b8c88 x4 : 0000000000000000 x3 : ffff800075618000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 0 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 0 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 00000000fffffffa
x17: 6564207373657264 x16: 6461206c61757472 x15: 697620746120746c
x14: ffff80000a3ecc78 x13: 0000000000001fec x12: 0000000000000aa4
x11: 2073736572646461 x10: ffff80000a49cc78 x9 : 00000000ffffe000
x8 : ffff80000a3ecc78 x7 : ffff80000a49cc78 x6 : 0000000000000000
x5 : 0000000000017ff4 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 0 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 0 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 00000000fffffffa
x17: 6564207373657264 x16: 6461206c61757472 x15: 697620746120746c
x14: ffff80000a3ecc78 x13: 0000000000002061 x12: 0000000000000acb
x11: 2073736572646461 x10: ffff80000a49cc78 x9 : 00000000ffffe000
x8 : ffff80000a3ecc78 x7 : ffff80000a49cc78 x6 : 0000000000000000
x5 : ffff00007f9b8c88 x4 : 0000000000000000 x3 : ffff800075618000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 0 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 0 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 00000000fffffffa
x17: 6564207373657264 x16: 6461206c61757472 x15: 697620746120746c
x14: ffff80000a3ecc78 x13: 00000000000020d6 x12: 0000000000000af2
x11: 2073736572646461 x10: ffff80000a49cc78 x9 : 00000000ffffe000
x8 : ffff80000a3ecc78 x7 : ffff80000a49cc78 x6 : 0000000000000000
x5 : 0000000000017ff4 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 1 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 1 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000b1c3391c9aa8
x14: 0000000000000107 x13: ffff800009fbc5a8 x12: ffff80000a3bfef0
x11: 0000000000000001 x10: 2f4989d5c1644307 x9 : e1eebcc6241e290b
x8 : fdff000013f8de48 x7 : 0000000000000004 x6 : 0000000000000190
x5 : 00000000000f0510 x4 : 0000000000f0000f x3 : 000000000000ffff
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 1 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 1 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000b4d06a69049c
x14: 00000000000003de x13: ffff800009fbc5a8 x12: ffff80000a3bfef0
x11: 0000000000000001 x10: 2f4989d5c1644307 x9 : e1eebcc6241e290b
x8 : fdff000013f8de48 x7 : 0000000000000004 x6 : 0000000000000190
x5 : 00000000000f0510 x4 : 0000000000f0000f x3 : 000000000000ffff
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 1 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 1 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000b26f97788cb8
x14: 00000000000000af x13: ffff800009fbc5a8 x12: ffff80000a3bfef0
x11: 0000000000000001 x10: 2f4989d5c1644307 x9 : e1eebcc6241e290b
x8 : fdff000013f8de48 x7 : 0000000000000004 x6 : 0000000000000190
x5 : 00000000000f0510 x4 : 0000000000f0000f x3 : 000000000000ffff
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 1 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 1 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 000093079324d7cc
x14: 00000000000002b1 x13: ffff800009fbc5a8 x12: ffff80000a3bfef0
x11: 0000000000000001 x10: 2f4989d5c1644307 x9 : e1eebcc6241e290b
x8 : fdff000013f8de48 x7 : 0000000000000004 x6 : 0000000000000190
x5 : 00000000000f0510 x4 : 0000000000f0000f x3 : 000000000000ffff
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 1 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 1 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 00008d756c695530
x14: 00000000000002a4 x13: ffff800009fbc5a8 x12: ffff80000a3bfef0
x11: 0000000000000001 x10: 2f4989d5c1644307 x9 : e1eebcc6241e290b
x8 : fdff000013f8de48 x7 : 0000000000000004 x6 : 0000000000000190
x5 : 00000000000f0510 x4 : 0000000000f0000f x3 : 000000000000ffff
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 1 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 1 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 00009e2fd39596e4
x14: 00000000000000f3 x13: ffff800009fbc5a8 x12: ffff80000a3bfef0
x11: 0000000000000001 x10: 2f4989d5c1644307 x9 : e1eebcc6241e290b
x8 : fdff000013f8de48 x7 : 0000000000000004 x6 : 0000000000000190
x5 : 00000000000f0510 x4 : 0000000000f0000f x3 : 000000000000ffff
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
__do_kernel_fault: 69722 callbacks suppressed
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 0 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 0 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 00000000fffffffa
x17: 6564207373657264 x16: 6461206c61757472 x15: 697620746120746c
x14: ffff80000a3ecc78 x13: 000000000000240f x12: 0000000000000c05
x11: 2073736572646461 x10: ffff80000a49cc78 x9 : 00000000ffffe000
x8 : ffff80000a3ecc78 x7 : ffff80000a49cc78 x6 : 0000000000000000
x5 : ffff00007f9b8c88 x4 : 0000000000000000 x3 : ffff800075618000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 0 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 0 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000b5866e18f700
x14: 0000000000000059 x13: ffff800009fbc5a8 x12: ffff80000a3bfef0
x11: 0000000000000001 x10: 2f4989d5c1644307 x9 : e1eebcc6241e290b
x8 : fdff000013f8de48 x7 : 0000000000000004 x6 : 0000000000000190
x5 : 00000000000f0510 x4 : 0000000000f0000f x3 : 000000000000ffff
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 0 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 0 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000ffffd8a3bbf8
x14: 000000000000031c x13: ffff800009fbc5a8 x12: ffff80000a3bfef0
x11: 0000000000000001 x10: 2f4989d5c1644307 x9 : e1eebcc6241e290b
x8 : fdff000013f8de48 x7 : 0000000000000004 x6 : 0000000000000190
x5 : 00000000000f0510 x4 : 0000000000f0000f x3 : 000000000000ffff
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 0 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 0 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 00000000fffffffa
x17: 6564207373657264 x16: 6461206c61757472 x15: 697620746120746c
x14: ffff80000a3ecc78 x13: 000000000000256e x12: 0000000000000c7a
x11: 2073736572646461 x10: ffff80000a49cc78 x9 : 00000000ffffe000
x8 : ffff80000a3ecc78 x7 : ffff80000a49cc78 x6 : 0000000000000000
x5 : 0000000000017ff4 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 0 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 0 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000aca2bf38bce4
x14: 000000000000018e x13: ffff800009fbc5a8 x12: ffff80000a3bfef0
x11: 0000000000000001 x10: 2f4989d5c1644307 x9 : e1eebcc6241e290b
x8 : fdff000013f8de48 x7 : 0000000000000004 x6 : 0000000000000190
x5 : 00000000000f0510 x4 : 0000000000f0000f x3 : 000000000000ffff
x2 : 0000000000000000 x1 : 0000000000000000 x0 : fdff000013f8cec0
Call trace:
 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
 do_bad_area arch/arm64/mm/fault.c:479 [inline]
 do_translation_fault+0x50/0xb8 arch/arm64/mm/fault.c:732
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:866
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 nfc_llcp_find_local net/nfc/llcp_core.c:286 [inline]
 nfc_llcp_unregister_device+0x34/0x10c net/nfc/llcp_core.c:1611
 nfc_unregister_device+0x74/0xb0 net/nfc/core.c:1179
 nci_unregister_device+0xb8/0xe8 net/nfc/nci/core.c:1303
 virtual_ncidev_close+0x1c/0x40 drivers/nfc/virtual_ncidev.c:163
 __fput+0x78/0x258 fs/file_table.c:321
 ____fput+0x10/0x1c fs/file_table.c:349
 task_work_run+0x6c/0xc4 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x214/0x144c arch/arm64/kernel/signal.c:1304
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0xac/0xb0 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0xb8/0xbc arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:591
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
Ignoring spurious kernel translation fault at virtual address dead000000000110
WARNING: CPU: 0 PID: 32265 at arch/arm64/mm/fault.c:374 __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
Modules linked in:
CPU: 0 PID: 32265 Comm: syz-executor.0 Tainted: G        W          6.4.0-rc6-syzkaller-00035-g15adb51c04cc #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
lr : __do_kernel_fault+0x158/0x1c0 arch/arm64/mm/fault.c:374
sp : ffff80000afe39f0
x29: ffff80000afe39f0 x28: fdff000013f8cec0 x27: 0000000000000000
x26: 0000000045585401 x25: fdff000013f8daa0 x24: 0000000000000000
x23: 0000000080400009 x22: 0000000000000025 x21: dead000000000110
x20: ffff80000afe3ab0 x19: 0000000097c18004 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000ac4d78eac326
x14: 000000000000011b x13: ffff800009fbc5a8 x12: ffff80000a3bfef0
x11: 0000000000000001 x10: 2f4989d5c1644307 x9 : e1eebcc6241e2

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

