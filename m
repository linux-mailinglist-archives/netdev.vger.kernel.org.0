Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34375407CEA
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 12:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbhILKmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 06:42:32 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:48766 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbhILKmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 06:42:31 -0400
Received: by mail-il1-f200.google.com with SMTP id n4-20020a056e021ba400b0022481cdc803so13291722ili.15
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 03:41:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=BAjX2AkFDNKH19LZZYWbrkqCvuFRehf7ymn/cg3ceC0=;
        b=NszX/FYJJYhDKCJGEReDV9QhKl816fvxKO+tcONWmPqewm1oPkWzev0yDelL9D9JXZ
         JOl+kaLNmqGMSlZRTXvOCsSkJNM60hFGPO38SjipCmeNXIejQpHYeyTDFGnGK6vI6Mmz
         r3leHU1eplLXJUA4IpLmRBwC/Yvqd4y372TVul0x4rTU0IHF9XjhL9i5tHHJEHnYkrD4
         u9+uPS8Ty8WCKy+IYjFtN232N41Cyx0ZlXdy4Dt5U6yvlDjfKZgUQTKkwg61D3MMUxvl
         1FgyIfljalIIhKWW/Ai6bXVbePlSf1sPlzRRHFxOucV89He3pYHHRQK0/eT7EN6MDGhV
         hOXQ==
X-Gm-Message-State: AOAM531N9zb9GL1ineEkFN/b6mbARDeSAWkEeMNfHjw1dtEL7Sb/eRKn
        gEe68zBAvMJ/AvSEZHanCvF6epHNViDgfIdX1K9xK9EI6FvW
X-Google-Smtp-Source: ABdhPJxBLhkP+lsamSOdAfVRoDbugO0ApB1zr09uxqaa9wtDcudadu3O+ExWe6kaPZkPpafpA7xZJ6Q5T9kTnWKn/HZgjSXVDvw8
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2194:: with SMTP id j20mr4005230ila.268.1631443277088;
 Sun, 12 Sep 2021 03:41:17 -0700 (PDT)
Date:   Sun, 12 Sep 2021 03:41:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000008cad05cbc9fdf2@google.com>
Subject: [syzbot] riscv/fixes boot error: BUG: unable to handle kernel paging
 request in corrupted
From:   syzbot <syzbot+6dfe749a37c4895fd959@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, jmorris@namei.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        serge@hallyn.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7d2a07b76933 Linux 5.14
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
console output: https://syzkaller.appspot.com/x/log.txt?x=150f460d300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f8211b06020972e8
dashboard link: https://syzkaller.appspot.com/bug?extid=6dfe749a37c4895fd959
compiler:       riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
userspace arch: riscv64

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6dfe749a37c4895fd959@syzkaller.appspotmail.com

Unable to handle kernel paging request at virtual address 0000000000400dc0
Oops [#1]
Modules linked in:
CPU: 0 PID: 2973 Comm: dhcpcd-run-hook Not tainted 5.14.0-syzkaller #0
Hardware name: riscv-virtio,qemu (DT)
epc : slab_alloc_node mm/slub.c:2900 [inline]
epc : slab_alloc mm/slub.c:2967 [inline]
epc : __kmalloc+0xce/0x388 mm/slub.c:4111
 ra : slab_pre_alloc_hook mm/slab.h:494 [inline]
 ra : slab_alloc_node mm/slub.c:2880 [inline]
 ra : slab_alloc mm/slub.c:2967 [inline]
 ra : __kmalloc+0x6e/0x388 mm/slub.c:4111
epc : ffffffff803e3568 ra : ffffffff803e3508 sp : ffffffe00b36ba70
 gp : ffffffff83f967d8 tp : ffffffe0081ac740 t0 : 0000000000000000
 t1 : 0000000000000001 t2 : 0000000000000000 s0 : ffffffe00b36bb10
 s1 : ffffffe005602500 a0 : 0000000000000000 a1 : ffffffe00b36be5c
 a2 : 1ffffffc01035a0f a3 : 0000000000400dc0 a4 : 0000000000000001
 a5 : ffffffff82e4b410 a6 : 0000000000f00000 a7 : ffffffff8038ca52
 s2 : ffffffff83f96adc s3 : 0000000000400dc0 s4 : 0000000000000010
 s5 : ffffffff807e81f8 s6 : ffffffff83f9a0d0 s7 : 0000000000000000
 s8 : 0000000000400dc0 s9 : 0000000000000001 s10: 0000000000000000
 s11: 0000000000000000 t3 : 2e9dd4183131c900 t4 : ffffffc7f0788989
 t5 : ffffffc7f078898a t6 : ffffffe00b07e9c0
status: 0000000000000120 badaddr: 0000000000400dc0 cause: 000000000000000d
[<ffffffff803e3568>] slab_alloc_node mm/slub.c:2900 [inline]
[<ffffffff803e3568>] slab_alloc mm/slub.c:2967 [inline]
[<ffffffff803e3568>] __kmalloc+0xce/0x388 mm/slub.c:4111
[<ffffffff807e81f8>] kmalloc include/linux/slab.h:596 [inline]
[<ffffffff807e81f8>] kzalloc+0x26/0x32 include/linux/slab.h:721
[<ffffffff807ebea4>] lsm_cred_alloc security/security.c:537 [inline]
[<ffffffff807ebea4>] security_prepare_creds+0xde/0x106 security/security.c:1691
[<ffffffff8007ba92>] prepare_creds+0x40e/0x5ae kernel/cred.c:293
[<ffffffff8007d014>] copy_creds+0x62/0x908 kernel/cred.c:367
[<ffffffff800216ba>] copy_process+0xb52/0x3a98 kernel/fork.c:1992
[<ffffffff8002480c>] kernel_clone+0x94/0x878 kernel/fork.c:2509
[<ffffffff80025074>] __do_sys_clone+0x84/0xac kernel/fork.c:2626
[<ffffffff80025336>] sys_clone+0x32/0x44 kernel/fork.c:2594
[<ffffffff80005150>] ret_from_syscall+0x0/0x2
---[ end trace 90d68454cb946b7b ]---


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
