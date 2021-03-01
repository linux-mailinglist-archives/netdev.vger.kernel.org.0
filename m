Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECC33282E7
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 17:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237443AbhCAP7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 10:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237135AbhCAP7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 10:59:45 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBD8C061756
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 07:59:05 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id e9so10180463plh.3
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 07:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=BDMDleRA0/7daXc6SYUvlGpMl6pzis2IbNjU8eN3HHQ=;
        b=Yk27F6vl55e7SBy5kb74xdnRqJKvHP48eTnteIe9UX4CmUtMailZ6rH01NDiX3R0iQ
         OrhwWXfIjhsDf+EcK0EaILRGswjI5jNwcT0q7gUme8VGpaadgIjCPQpCUQIMrj5Pe4u2
         NSiNpvcAcv4408cZlelXD9tlft9anjGDIze4SnlqD7OY6xC23lqBrQfGirjIxglFBw6b
         PgmfvcBClBkadJIPhy4HG+r0c/oGlmCUPiUJWHMx5vfb2Lh2qnr7AC5B5wO3vYB+uFfh
         EbGw9G9eMssaU5eZw+Fg7m0SrmsL0KVJEegWWe+YncJx/ooI2FVmQenu7XQWxNUWSIO7
         cP/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=BDMDleRA0/7daXc6SYUvlGpMl6pzis2IbNjU8eN3HHQ=;
        b=e690IQr1mL89p92/qhYrfYYwI5rAJ1QnOx+aNNnCHWKQAYpB3UCKVzLuiftvMuNsK3
         vGbZBJI1z/etX+g4EtsgUbc9h3t26xJmok8voq1+nryIXS7eejZ2deP6AyNtH+9A4GZd
         b/py859yCF9+EAYwXF0OA3QzsGPxHzYfme3ufxXyrl8jl6oMr6Z2ZG7w0Dd9Q026fJ6T
         3g1c5Pup4JjYGz6SbL1lHNfs9G+Q3sJIA/3nrW2J68u5kraNi2zTkdEMHItuaovm7dRu
         VyIcc7TZCpVtnv2vwY1o5UgeY7gfKAfk8B40BLwEkTehmI94gmERXBUOKoZbqbEJ636Z
         ekag==
X-Gm-Message-State: AOAM532oG2Tyu1cHUSHlZmrJN7+SMX6w+8HOTgjiNGGucnlDO6m/SgDF
        hKpu0aPhOyOvovuzhdohfF9j9migwSukWQ==
X-Google-Smtp-Source: ABdhPJw7wMK0s1tt769tbWqvngK/aTI0mW0DtrTeo+ODARxvS7yR7JQ1lTZBeM/+lhgXZPGxsMakfw==
X-Received: by 2002:a17:90a:2ec6:: with SMTP id h6mr18351117pjs.103.1614614344330;
        Mon, 01 Mar 2021 07:59:04 -0800 (PST)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id v27sm15000860pfi.146.2021.03.01.07.59.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 07:59:04 -0800 (PST)
Date:   Mon, 1 Mar 2021 07:58:54 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 212005] New: WARNING: CPU: 1 PID: 356 at
 net/ipv4/tcp.c:2343 tcp_recvmsg_locked+0x90e/0x29a0
Message-ID: <20210301075854.5f72e433@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Mon, 01 Mar 2021 11:50:22 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 212005] New: WARNING: CPU: 1 PID: 356 at net/ipv4/tcp.c:2343 tcp_recvmsg_locked+0x90e/0x29a0


https://bugzilla.kernel.org/show_bug.cgi?id=212005

            Bug ID: 212005
           Summary: WARNING: CPU: 1 PID: 356 at net/ipv4/tcp.c:2343
                    tcp_recvmsg_locked+0x90e/0x29a0
           Product: Networking
           Version: 2.5
    Kernel Version: 5.11.0-rc7+
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: ieatmuttonchuan@gmail.com
        Regression: No

Created attachment 295545
  --> https://bugzilla.kernel.org/attachment.cgi?id=295545&action=edit  
poc C file

Hello,
I found a bug in kernel version 5.11.0-rc7+.
This is the POC.
1.Git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
2.Build kernel with CONFIG_KASAN
3.Run kernel with qemu
```
qemu-system-x86_64 \
        -m 1G \
        -smp 2 \
        -kernel bzImage \
        -append "console=ttyS0 root=/dev/sda earlyprintk=serial net.ifnames=0"
\
        -drive file=stretch.img,format=raw \
        -net user,host=10.0.2.10,hostfwd=tcp:127.0.0.1:1569-:22 \
        -net nic,model=e1000 \
        -nographic \
        -enable-kvm
```
4.Compile POC and scp into qemu.
```
gcc tcp_recvmsg_locked.c -static -lpthread
scp -P 1569 a.out root@localhost:~
```
5.Run a.out you will see the dump log.
```
root@syzkaller:~# ./a.out 
[  111.196095] audit: type=1400 audit(1614585907.556:8): avc:  denied  {
execmem } for  pid=356 comm="a.out" scontext=system_u:system_r:kernel_t:s0
tcontext=system_u:system_r:kernel_t:s0 tclass=process permissive=1
[  111.203295] ------------[ cut here ]------------
[  111.205099] TCP recvmsg seq # bug 2: copied 80, seq 0, rcvnxt 80, fl 0
[  111.207894] WARNING: CPU: 1 PID: 356 at net/ipv4/tcp.c:2343
tcp_recvmsg_locked+0x90e/0x29a0
[  111.212756] Modules linked in:
[  111.214115] CPU: 1 PID: 356 Comm: a.out Not tainted 5.11.0-rc7+ #1
[  111.216911] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.10.2-1ubuntu1 04/01/2014
[  111.220464] RIP: 0010:tcp_recvmsg_locked+0x90e/0x29a0
[  111.222596] Code: 48 c1 e8 03 0f b6 04 18 84 c0 0f 85 18 01 00 00 8b 0a 48
c7 c7 60 04 d0 86 44 89 fe 89 ea 44 8b 44 24 2c 31 c0 e8 32 3d c3 fd <0f> 0b e9
2e ff ff ff e8 76 f2 eb fd c6 05 29 7d bf 01 01 48 c7 c7
[  111.228525] RSP: 0018:ffff888001a4fab8 EFLAGS: 00010246
[  111.229905] RAX: f2b8163648339800 RBX: dffffc0000000000 RCX:
ffff8880035b9c00
[  111.232193] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
0000000000000000
[  111.234829] RBP: 0000000000000000 R08: ffffffff83928cd0 R09:
ffffed10061a5d1a
[  111.236645] R10: ffffed10061a5d1a R11: 0000000000000000 R12:
00000000ffffff94
[  111.238287] R13: ffff888001ed0b68 R14: 1ffff110003da16d R15:
0000000000000080
[  111.239721] FS:  00000000010da880(0000) GS:ffff888030d00000(0000)
knlGS:0000000000000000
[  111.241303] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  111.242461] CR2: 00000000004608dd CR3: 0000000003948000 CR4:
00000000000006e0
[  111.243806] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  111.245072] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[  111.246337] Call Trace:
[  111.246775]  tcp_recvmsg+0x1c9/0xd50
[  111.247397]  ? memset+0x1f/0x40
[  111.247978]  ? selinux_socket_recvmsg+0xaf/0x240
[  111.248820]  ? tcp_v6_do_rcv+0x542/0x1280
[  111.249415]  ? tcp_mmap+0xc0/0xc0
[  111.249966]  inet6_recvmsg+0x107/0x480
[  111.250509]  ? inet6_sendmsg+0x120/0x120
[  111.251101]  __sys_recvfrom+0x34d/0x530
[  111.251695]  ? do_tcp_setsockopt+0x2381/0x33d0
[  111.252447]  ? tcp_setsockopt+0x3a/0xf0
[  111.253339]  ? __sys_setsockopt+0x1fd/0x270
[  111.254743]  ? sock_common_recvmsg+0x190/0x190
[  111.256106]  ? __sys_setsockopt+0x211/0x270
[  111.256693]  __x64_sys_recvfrom+0xda/0xf0
[  111.257430]  do_syscall_64+0x33/0x40
[  111.258145]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  111.259133] RIP: 0033:0x449cb9
[  111.259646] Code: 00 b8 00 01 00 00 eb e1 e8 f4 19 00 00 0f 1f 40 00 48 89
f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
[  111.262498] RSP: 002b:00007fffaa2b0328 EFLAGS: 00000212 ORIG_RAX:
000000000000002d
[  111.263615] RAX: ffffffffffffffda RBX: 0000000020000050 RCX:
0000000000449cb9
[  111.264686] RDX: 0000000000000014 RSI: 0000000000000000 RDI:
0000000000000003
[  111.265573] RBP: 00007fffaa2b0360 R08: 0000000000000000 R09:
0000000000000000
[  111.266342] R10: 0000000000000000 R11: 0000000000000212 R12:
0000000000401cb0
[  111.267090] R13: 0000000000000000 R14: 00000000006b9018 R15:
0000000000000000
[  111.267838] ---[ end trace 3bc6b032cf6c31f5 ]---
[  111.268332] ------------[ cut here ]------------
[  111.268873] cleanup rbuf bug: copied 80 seq 14 rcvnxt 80
[  111.269477] WARNING: CPU: 1 PID: 356 at net/ipv4/tcp.c:1555
tcp_cleanup_rbuf+0x3f4/0x5a0
[  111.270330] Modules linked in:
[  111.270655] CPU: 1 PID: 356 Comm: a.out Tainted: G        W        
5.11.0-rc7+ #1
[  111.271445] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.10.2-1ubuntu1 04/01/2014
[  111.272370] RIP: 0010:tcp_cleanup_rbuf+0x3f4/0x5a0
[  111.272886] Code: b9 00 00 00 00 00 fc ff df 8a 04 08 84 c0 0f 85 9a 01 00
00 41 8b 0c 24 48 c7 c7 60 ff cf 86 89 ee 89 da 31 c0 e8 0c 70 c3 fd <0f> 0b e9
a5 fc ff ff 44 89 e9 80 e1 07 38 c1 0f 8c bb fc ff ff 4c
[  111.274834] RSP: 0018:ffff888001a4fa78 EFLAGS: 00010246
[  111.275404] RAX: f2b8163648339800 RBX: 0000000000000014 RCX:
ffff8880035b9c00
[  111.276148] RDX: 0000000000000000 RSI: 0000000000000001 RDI:
0000000000000000
[  111.276890] RBP: 0000000000000080 R08: ffffffff83a84a02 R09:
ffffed10061a3f23
[  111.277702] R10: ffffed10061a3f23 R11: 0000000000000000 R12:
ffff8880075e0570
[  111.278560] R13: ffff888001ed0b68 R14: 00000000ffffff98 R15:
ffff8880075e0000
[  111.279307] FS:  00000000010da880(0000) GS:ffff888030d00000(0000)
knlGS:0000000000000000
[  111.280261] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  111.280866] CR2: 00000000004608dd CR3: 0000000003948000 CR4:
00000000000006e0
[  111.281594] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  111.282495] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[  111.283815] Call Trace:
[  111.284275]  tcp_recvmsg_locked+0x2206/0x29a0
[  111.285467]  tcp_recvmsg+0x1c9/0xd50
[  111.285979]  ? memset+0x1f/0x40
[  111.286394]  ? selinux_socket_recvmsg+0xaf/0x240
[  111.286996]  ? tcp_v6_do_rcv+0x542/0x1280
[  111.287431]  ? tcp_mmap+0xc0/0xc0
[  111.287895]  inet6_recvmsg+0x107/0x480
[  111.288313]  ? inet6_sendmsg+0x120/0x120
[  111.288888]  __sys_recvfrom+0x34d/0x530
[  111.289391]  ? do_tcp_setsockopt+0x2381/0x33d0
[  111.289954]  ? tcp_setsockopt+0x3a/0xf0
[  111.290429]  ? __sys_setsockopt+0x1fd/0x270
[  111.290942]  ? sock_common_recvmsg+0x190/0x190
[  111.291416]  ? __sys_setsockopt+0x211/0x270
[  111.291871]  __x64_sys_recvfrom+0xda/0xf0
[  111.292323]  do_syscall_64+0x33/0x40
[  111.292700]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  111.293240] RIP: 0033:0x449cb9
[  111.293567] Code: 00 b8 00 01 00 00 eb e1 e8 f4 19 00 00 0f 1f 40 00 48 89
f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
[  111.295468] RSP: 002b:00007fffaa2b0328 EFLAGS: 00000212 ORIG_RAX:
000000000000002d
[  111.296323] RAX: ffffffffffffffda RBX: 0000000020000050 RCX:
0000000000449cb9
[  111.297142] RDX: 0000000000000014 RSI: 0000000000000000 RDI:
0000000000000003
[  111.298007] RBP: 00007fffaa2b0360 R08: 0000000000000000 R09:
0000000000000000
[  111.298718] R10: 0000000000000000 R11: 0000000000000212 R12:
0000000000401cb0
[  111.299475] R13: 0000000000000000 R14: 00000000006b9018 R15:
0000000000000000
[  111.300202] ---[ end trace 3bc6b032cf6c31f6 ]---
```

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
