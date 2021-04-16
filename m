Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5863618F4
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 06:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238076AbhDPEfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 00:35:43 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:55896 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234735AbhDPEfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 00:35:40 -0400
Received: by mail-il1-f199.google.com with SMTP id v1-20020a92d2410000b02901533f3ed5dbso5800885ilg.22
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 21:35:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=vQTgohi03z5tK7Cg1hw3ZJisST4UH/MCqTpc+mpUM3w=;
        b=HguC/piEXPg7ZRVjkB78yfdk7kHdNkbrCutO1hOf45ARzBYHzc2EBmxR8G+tF1V1xu
         dqWNm3l8KjFZxdQ2xyI79gKllv1r8bgnUN1LnznRPGXC27lokltrCuna+tP+od6IKwrU
         C7AHW6Peg5z4JpnKJYUUWPSRihSOWVdLlYXTmc+2MlNTdAXh9A057XrBUwezTpiwifQG
         24CKsI23kCyXNzSt79cnMprX/88rErrmRb9LdAP3ZT5QuQdBaL4Fq858ts6YN9aBGObr
         rkI/dJBC/e2J/pHblpwwjsYjcsGM8MYa0xkDAPs3Jg0wA1OAezM+OrEuqYH/bGIRTqna
         BSYw==
X-Gm-Message-State: AOAM531CZ3Nm62IbSMwfjHLS82G9N3tpX99QXe7EI4caWMc2vWO8eirp
        P8kSBVFjyGAZk1dUnP21OZV3ZvT1b7djpni+cc0LYT6Czz13
X-Google-Smtp-Source: ABdhPJw1usrwJxPJNZPdyxUalJuLF2O2KN2oetB1VB36jzdNFtg6/b+WSHV39d4QGIjC1xLB7NXq3r61gkbTcUaBrhhTb6j06Uy0
MIME-Version: 1.0
X-Received: by 2002:a5e:8419:: with SMTP id h25mr1970510ioj.43.1618547715699;
 Thu, 15 Apr 2021 21:35:15 -0700 (PDT)
Date:   Thu, 15 Apr 2021 21:35:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a5772005c00f8101@google.com>
Subject: [syzbot] WARNING in ctx_sched_in
From:   syzbot <syzbot+50d41b514809f6f4f326@syzkaller.appspotmail.com>
To:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, jolsa@redhat.com,
        kafai@fb.com, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    79c338ab riscv: keep interrupts disabled for BREAKPOINT ex..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
console output: https://syzkaller.appspot.com/x/log.txt?x=10fb93f9d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f8af20e245283c9a
dashboard link: https://syzkaller.appspot.com/bug?extid=50d41b514809f6f4f326
userspace arch: riscv64

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+50d41b514809f6f4f326@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 4475 at kernel/events/core.c:3752 ctx_sched_in+0x12e/0x3ee kernel/events/core.c:3752
Modules linked in:
CPU: 1 PID: 4475 Comm: syz-executor.1 Not tainted 5.12.0-rc6-syzkaller-00183-g79c338ab575e #0
Hardware name: riscv-virtio,qemu (DT)
epc : ctx_sched_in+0x12e/0x3ee kernel/events/core.c:3752
 ra : ctx_sched_in+0x12e/0x3ee kernel/events/core.c:3752
epc : ffffffe000279fe8 ra : ffffffe000279fe8 sp : ffffffe009e17680
 gp : ffffffe004588ad0 tp : ffffffe006398000 t0 : 0000000000000000
 t1 : 0000000000000001 t2 : 00000000000f4240 s0 : ffffffe009e176f0
 s1 : ffffffe0077edc00 a0 : ffffffe067d79118 a1 : 00000000000f0000
 a2 : 0000000000000002 a3 : ffffffe000279fe8 a4 : ffffffe006399000
 a5 : 0000000040000000 a6 : 0000000000f00000 a7 : ffffffe000280cc8
 s2 : 0000000000000007 s3 : ffffffe0077edd40 s4 : ffffffe006398000
 s5 : 0000000000000002 s6 : ffffffe00458c0d0 s7 : ffffffe067d78f70
 s8 : 0000000000000007 s9 : ffffffe067d79118 s10: ffffffe0077edc00
 s11: ffffffe0077edc08 t3 : e189d98bb4bfb900 t4 : ffffffc4042c47b2
 t5 : ffffffc4042c47ba t6 : 0000000000040000
status: 0000000000000100 badaddr: 0000000000000000 cause: 0000000000000003
Call Trace:
[<ffffffe000279fe8>] ctx_sched_in+0x12e/0x3ee kernel/events/core.c:3752
[<ffffffe00027a2e0>] perf_event_sched_in+0x38/0x74 kernel/events/core.c:2680
[<ffffffe000280da2>] perf_event_context_sched_in kernel/events/core.c:3817 [inline]
[<ffffffe000280da2>] __perf_event_task_sched_in+0x4ea/0x680 kernel/events/core.c:3860
[<ffffffe0000850f8>] perf_event_task_sched_in include/linux/perf_event.h:1210 [inline]
[<ffffffe0000850f8>] finish_task_switch.isra.0+0x284/0x318 kernel/sched/core.c:4189
[<ffffffe002a94308>] context_switch kernel/sched/core.c:4325 [inline]
[<ffffffe002a94308>] __schedule+0x484/0xe8c kernel/sched/core.c:5073
[<ffffffe002a95102>] preempt_schedule_notrace+0x9c/0x19a kernel/sched/core.c:5312
[<ffffffe0000cd54a>] rcu_read_unlock_sched_notrace include/linux/rcupdate.h:794 [inline]
[<ffffffe0000cd54a>] trace_lock_acquire+0xf0/0x20e include/trace/events/lock.h:13
[<ffffffe0000d3c0e>] lock_acquire+0x28/0x5a kernel/locking/lockdep.c:5481
[<ffffffe0003b20ee>] rcu_lock_acquire include/linux/rcupdate.h:267 [inline]
[<ffffffe0003b20ee>] rcu_read_lock include/linux/rcupdate.h:656 [inline]
[<ffffffe0003b20ee>] percpu_ref_put_many.constprop.0+0x38/0x148 include/linux/percpu-refcount.h:317
[<ffffffe0003baa56>] percpu_ref_put include/linux/percpu-refcount.h:338 [inline]
[<ffffffe0003baa56>] obj_cgroup_put include/linux/memcontrol.h:713 [inline]
[<ffffffe0003baa56>] memcg_slab_free_hook mm/slab.h:372 [inline]
[<ffffffe0003baa56>] memcg_slab_free_hook mm/slab.h:336 [inline]
[<ffffffe0003baa56>] do_slab_free mm/slub.c:3117 [inline]
[<ffffffe0003baa56>] ___cache_free+0x2bc/0x3dc mm/slub.c:3168
[<ffffffe0003be26c>] qlink_free mm/kasan/quarantine.c:146 [inline]
[<ffffffe0003be26c>] qlist_free_all+0x56/0xac mm/kasan/quarantine.c:165
[<ffffffe0003be774>] kasan_quarantine_reduce+0x14c/0x1c8 mm/kasan/quarantine.c:272
[<ffffffe0003bc3f8>] __kasan_slab_alloc+0x60/0x62 mm/kasan/common.c:437
[<ffffffe0003b8f10>] kasan_slab_alloc include/linux/kasan.h:223 [inline]
[<ffffffe0003b8f10>] slab_post_alloc_hook mm/slab.h:516 [inline]
[<ffffffe0003b8f10>] slab_alloc_node mm/slub.c:2907 [inline]
[<ffffffe0003b8f10>] slab_alloc mm/slub.c:2915 [inline]
[<ffffffe0003b8f10>] kmem_cache_alloc+0x168/0x3ca mm/slub.c:2920
[<ffffffe0001aaee2>] kmem_cache_zalloc include/linux/slab.h:674 [inline]
[<ffffffe0001aaee2>] taskstats_tgid_alloc kernel/taskstats.c:561 [inline]
[<ffffffe0001aaee2>] taskstats_exit+0x3ce/0x5fe kernel/taskstats.c:600
[<ffffffe000031bfc>] do_exit+0x3b2/0x1846 kernel/exit.c:810
[<ffffffe00003319a>] do_group_exit+0xa0/0x198 kernel/exit.c:922
[<ffffffe00004c558>] get_signal+0x31e/0x14ba kernel/signal.c:2781
[<ffffffe000007e06>] do_signal arch/riscv/kernel/signal.c:271 [inline]
[<ffffffe000007e06>] do_notify_resume+0xa8/0x930 arch/riscv/kernel/signal.c:317
[<ffffffe000005586>] ret_from_exception+0x0/0x14


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
