Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6573D3829ED
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 12:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236428AbhEQKhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 06:37:03 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:56061 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236413AbhEQKhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 06:37:02 -0400
Received: by mail-il1-f199.google.com with SMTP id a15-20020a927f0f0000b02901ac2bdd733dso5911688ild.22
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 03:35:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=iywxSo2lx3kZ1fCQDpQVN15Vtz3n4hPyATpxCDp6BbU=;
        b=VO5+5P9wtfd3KJPJhXMUVMF6EC2QJYnqKr+0a1LJ6Awb9k6xnonN7hUIw7cUolrEz0
         lIg35NzPFpTEL8JJJG01dVJZ6QKYofm+LZHnibubk/OumFaz3XBoeAdmO03i6H430VQ5
         d1XhuRMU2PzdevplQHDZdQzfK65mWCUsebEPJdxOvCzf8L/rK4K3qsUt3W6eZnRAsnHv
         dtP7qGIdCVnT2dXnd7avfKuYrKwcF61Q2WyIzPUtlNt37XOjB6H00t1E3SsFpwmnxGN0
         ZqloMtIWBHHTjNNpkjAK/XcYpE5AaHmhEz3tmxHSWZkOq8p9C1/+wEScOGZ/79GxyZvy
         MIfA==
X-Gm-Message-State: AOAM533FnJQOWznf+hD/0hSQXGygoeMtuSp8ip0WfsFbArKpywBXv/Hl
        0u0iDkN54GTjasNJMjIKnQfVEyWjxgahvZXWxM4KpMrCvMVb
X-Google-Smtp-Source: ABdhPJzigzC05NsRon/Bi7ggPaRHOedoVm602oMpajmLvm3xYJiKUjUOC4+J44K7u/RBbIv6lORutlBUBRtLhLivv9Uza1mDa5wE
MIME-Version: 1.0
X-Received: by 2002:a02:cac6:: with SMTP id f6mr2991780jap.142.1621247744762;
 Mon, 17 May 2021 03:35:44 -0700 (PDT)
Date:   Mon, 17 May 2021 03:35:44 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000eb645905c28427b5@google.com>
Subject: [syzbot] WARNING in ctx_sched_out
From:   syzbot <syzbot+728b5fa8935674c320bf@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=12d1bb9ad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f8af20e245283c9a
dashboard link: https://syzkaller.appspot.com/bug?extid=728b5fa8935674c320bf
userspace arch: riscv64

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+728b5fa8935674c320bf@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 5748 at kernel/events/core.c:3219 ctx_sched_out+0x544/0x548 kernel/events/core.c:3219
Modules linked in:
CPU: 1 PID: 5748 Comm: syz-executor.0 Not tainted 5.12.0-rc6-syzkaller-00183-g79c338ab575e #0
Hardware name: riscv-virtio,qemu (DT)
epc : ctx_sched_out+0x544/0x548 kernel/events/core.c:3219
 ra : ctx_sched_out+0x544/0x548 kernel/events/core.c:3219
epc : ffffffe00027c604 ra : ffffffe00027c604 sp : ffffffe01e84ba90
 gp : ffffffe004588ad0 tp : ffffffe007ba2f80 t0 : ffffffc400f57234
 t1 : 0000000000000001 t2 : 0000000000000000 s0 : ffffffe01e84baf0
 s1 : ffffffe006c8dc00 a0 : ffffffe067d79118 a1 : 00000000000f0000
 a2 : ffffffd013437000 a3 : ffffffe00027c604 a4 : ffffffd01343ddb0
 a5 : 0000000000000db6 a6 : 0000000000f00000 a7 : ffffffe00027d02e
 s2 : ffffffe067d78f70 s3 : 0000000000000000 s4 : ffffffe067d79118
 s5 : 0000000000000001 s6 : ffffffe006c8dd40 s7 : 0000000000000000
 s8 : ffffffe007ba2f80 s9 : ffffffe00458c0d0 s10: 0000000000000000
 s11: 0000000000000000 t3 : dca1909648c0c800 t4 : ffffffc403d09797
 t5 : ffffffc403d09799 t6 : ffffffe00d5a321c
status: 0000000000000100 badaddr: 0000000000000000 cause: 0000000000000003
Call Trace:
[<ffffffe00027c604>] ctx_sched_out+0x544/0x548 kernel/events/core.c:3219
[<ffffffe00027d162>] __perf_install_in_context+0x1f4/0x47c kernel/events/core.c:2799
[<ffffffe00026b630>] remote_function kernel/events/core.c:91 [inline]
[<ffffffe00026b630>] remote_function+0xa8/0xc0 kernel/events/core.c:71
[<ffffffe0001452cc>] generic_exec_single+0x1a6/0x212 kernel/smp.c:293
[<ffffffe00014546c>] smp_call_function_single+0x134/0x2ba kernel/smp.c:513
[<ffffffe00026a8ba>] task_function_call+0x90/0xee kernel/events/core.c:119
[<ffffffe00027bf4e>] perf_install_in_context+0x174/0x2e6 kernel/events/core.c:2902
[<ffffffe000288690>] __do_sys_perf_event_open+0x10ea/0x199e kernel/events/core.c:12169
[<ffffffe00028f3e6>] sys_perf_event_open+0x34/0x46 kernel/events/core.c:11775
[<ffffffe000005578>] ret_from_syscall+0x0/0x2


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
