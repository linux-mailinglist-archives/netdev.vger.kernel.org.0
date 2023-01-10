Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438B5664DB1
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 21:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbjAJUvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 15:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234043AbjAJUvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 15:51:10 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8226218E
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 12:50:49 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id o16-20020a056602225000b006e032e361ccso7696345ioo.13
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 12:50:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FrGb7T5CWFgT+AcNY8nFRNBTuSt+li16+JKxysSC3eM=;
        b=bF5rlhJZO0qh+/+jdb8hwgi/i3rusRTD1gBf0vA/tI7hBYwWbVT3rYS0Mmj6476qgB
         zAHTAZagm6Tm8MQ1FOAAlK8MP0I1SnvHIn6k64GIsKLrLnF5u8v6fxoE9pjZRbioPMAQ
         4jOSfgVHUCCAVy9lGJvuF3R85HRlf1NomHQFb5HapskqXoApnM6EY5vP92COSy0sgBZU
         igU1z1hWJGwhQbE5XJ7bFVngaACWw/eV6ZEZYnO0Gn2op1PXp50HEc4A2fyK2y2H+zaU
         XPJuWGbuKsh134p4s/eNHobU5dZOcnUVc0kiuvF8FFrQRSPSJreDqzkoF3Cz2QNT4MHv
         k9zA==
X-Gm-Message-State: AFqh2kpShzbznIIYSxa+dk2yMaI/804Ye6ynB+fG84aCf01Q5QA0YX0j
        8/16sewc8STLE8dPDf6m1kw6v6/oxKN52T5J9iVJgdG3FUUS
X-Google-Smtp-Source: AMrXdXuozUlqSWHDOAO0yfa4cKVIsQ+lkXBtEtXo76WRlFEP0Wb+ediaphFRjZIocZ4NTvwt+IWxb0USvCoWS18iAXPsUO8mwnXv
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3f18:b0:38d:30a7:2ae0 with SMTP id
 ck24-20020a0566383f1800b0038d30a72ae0mr6851113jab.234.1673383848565; Tue, 10
 Jan 2023 12:50:48 -0800 (PST)
Date:   Tue, 10 Jan 2023 12:50:48 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dde02b05f1ef09a4@google.com>
Subject: [syzbot] WARNING: locking bug in __perf_event_task_sched_in (2)
From:   syzbot <syzbot+d94d214ea473e218fc89@syzkaller.appspotmail.com>
To:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        bpf@vger.kernel.org, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6d0c4b11e743 libbpf: Poison strlcpy()
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17764f3a480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=46221e8203c7aca6
dashboard link: https://syzkaller.appspot.com/bug?extid=d94d214ea473e218fc89
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/83567aa48724/disk-6d0c4b11.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6047fdb8660e/vmlinux-6d0c4b11.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a94d1047d7b7/bzImage-6d0c4b11.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d94d214ea473e218fc89@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 1 PID: 6975 at kernel/locking/lockdep.c:231 hlock_class kernel/locking/lockdep.c:231 [inline]
WARNING: CPU: 1 PID: 6975 at kernel/locking/lockdep.c:231 hlock_class kernel/locking/lockdep.c:220 [inline]
WARNING: CPU: 1 PID: 6975 at kernel/locking/lockdep.c:231 check_wait_context kernel/locking/lockdep.c:4754 [inline]
WARNING: CPU: 1 PID: 6975 at kernel/locking/lockdep.c:231 __lock_acquire+0xecf/0x56d0 kernel/locking/lockdep.c:5005
Modules linked in:
CPU: 1 PID: 6975 Comm: kworker/u4:13 Not tainted 6.2.0-rc2-syzkaller-00302-g6d0c4b11e743 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: netns cleanup_net
RIP: 0010:hlock_class kernel/locking/lockdep.c:231 [inline]
RIP: 0010:hlock_class kernel/locking/lockdep.c:220 [inline]
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4754 [inline]
RIP: 0010:__lock_acquire+0xecf/0x56d0 kernel/locking/lockdep.c:5005
Code: 28 14 73 8e e8 02 bb 6b 00 8b 05 94 78 0f 0d 85 c0 0f 85 79 f8 ff ff 48 c7 c6 40 51 4c 8a 48 c7 c7 a0 4a 4c 8a e8 51 d6 5b 08 <0f> 0b 31 c0 e9 73 f7 ff ff 48 63 5c 24 18 be 08 00 00 00 48 89 d8
RSP: 0018:ffffc900035ef518 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 000000000000070e RCX: 0000000000000000
RDX: ffff888079031d40 RSI: ffffffff8166724c RDI: fffff520006bde95
RBP: 0000000000000003 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000002 R11: 0000000000000001 R12: 0000000000000003
R13: ffff888079031d40 R14: ffff888079032778 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc92edd748 CR3: 0000000044fa3000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 lock_acquire kernel/locking/lockdep.c:5668 [inline]
 lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
 rcu_lock_acquire include/linux/rcupdate.h:325 [inline]
 rcu_read_lock include/linux/rcupdate.h:764 [inline]
 perf_event_context_sched_in kernel/events/core.c:3913 [inline]
 __perf_event_task_sched_in+0xe2/0x6c0 kernel/events/core.c:3980
 perf_event_task_sched_in include/linux/perf_event.h:1328 [inline]
 finish_task_switch.isra.0+0x5e5/0xc80 kernel/sched/core.c:5118
 context_switch kernel/sched/core.c:5247 [inline]
 __schedule+0xb92/0x5450 kernel/sched/core.c:6555
 schedule+0xde/0x1b0 kernel/sched/core.c:6631
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6690
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa48/0x1360 kernel/locking/mutex.c:747
 devl_lock net/devlink/core.c:54 [inline]
 devlink_pernet_pre_exit+0x10a/0x220 net/devlink/core.c:301
 ops_pre_exit_list net/core/net_namespace.c:159 [inline]
 cleanup_net+0x455/0xb10 net/core/net_namespace.c:594
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
