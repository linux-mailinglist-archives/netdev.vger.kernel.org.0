Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 376291B6ED
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 15:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbfEMNTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 09:19:41 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43040 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727576AbfEMNTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 09:19:41 -0400
Received: by mail-lj1-f196.google.com with SMTP id z5so10912324lji.10
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 06:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=XAU0ZkYgblxOEPy0LXyEdnKyI7sM7WMhiI+bVnbRDHg=;
        b=HNX9l0L8CSuj7vtE1eaJGkQNQAwnD62yg67absNvKQdApaOVf0WfvTp7ar0Z9GHZ7F
         7cIPf5YL7Mgj8z4xESqEPlOWNRz1s8JkqfDAVCBp7j0ZF01txs7/k/hSKjerODEghkap
         KTRsZCgWJXHNpViyw9OAhWjIDwnfqqAXM3fze9bzeyJBfo85hdiKpEUqyy9PvoqN1xTY
         yT7O+6b8O5MbHQEv+jbQxtDzN505Q735GkTeY2UgOv68N5qgV3lmlqw/o9sY1pOiJTE9
         XnC3gR0ELTzC6lNmKMNZQrKBU9sj609KwhK0T/aIX9tVRq819OmLauqbeVyD6uzcFYcT
         K1Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=XAU0ZkYgblxOEPy0LXyEdnKyI7sM7WMhiI+bVnbRDHg=;
        b=ACxQHpbf6dSIsYNY/XZAbPjb/SYFUyxxu+PmMLV9bRK+q9FIhDP9XTd2+B1uMpWCU/
         R+4E4i0G9F+ElGdv4c1J7kzzkP2wjpmb/B6HzlRxPMHMQoKzZQbPveW87rUzWioMuTZQ
         aZYDB/ylqunmbsi/hrHwd1bqIGVMT9Dia5VB342bx13jOdZkvxZIORVtygXyqNsnVfSs
         3iUktN8P69ik6Xw1nfZoTzp4FqMtFNdNVXiThxvUe0S2YI+lQW7o0zP6XcUGUPN1n2l5
         cx0HHUgFvUP6mfhGSGhUsfSArJDZKRYTCw7zAxlT2mF1MzGafAs11ha1O+8h7RdfHxoM
         +RyQ==
X-Gm-Message-State: APjAAAXvgpojzdsZLD8ekqQN16acbA2uBINOiyE8lACnWEY01Fn99mlN
        jutqoC20LPVVOB/CbOz/0xps6/oLKVJpGlAjDd8B4A==
X-Google-Smtp-Source: APXvYqwR0ReMKyKdo9y2aANMGAUr/W9YUPubs0/m5aA15/uXB0gSX1wxoP9dHmvz6GuaSZ7DwuR52z1V5m0kLvL/KxI=
X-Received: by 2002:a2e:8796:: with SMTP id n22mr1512722lji.75.1557753579018;
 Mon, 13 May 2019 06:19:39 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 13 May 2019 18:49:27 +0530
Message-ID: <CA+G9fYv0Ycums3ziT3np3kfGek3Hhphj_c5PFjeL7th3B9feDQ@mail.gmail.com>
Subject: selftests: bpf: test_sock: WARNING: workqueue.c:3030 __flush_work+0x3fc/0x470
To:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, ast@kernel.org
Cc:     lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do you see kernel WARNING while running bpf: test_sock test case ?
This  kernel warning is popping up continuously for ~725 times on all
devices ( arm64, arm, x86_64 and i386).

selftests: bpf: test_sock
Test case: bind4 load with invalid access: src_ip6 .. [PASS]
Test case: bind4 load with invalid access: mark .. [PASS]
Test case: bind6 load with invalid access: src_ip4 .. [PASS]
Test case: sock_create load with invalid access: src_port .. [PASS]
Test case: sock_create load w/o expected_attach_type (compat mode) .. [PASS]
Test case: sock_create load w/ expected_attach_type .. [PASS]
Test case: attach type mismatch bind4 vs bind6 .. [PASS]
Test case: attach type mismatch bind6 vs bind4 .. [PASS]
Test case: attach type mismatch default vs bind4 .. [PASS]
Test case: attach type mismatch bind6 vs sock_create .. [PASS]
Test case: bind4 reject all .. [PASS]
Test case: bind6 reject all .. [PASS]
Test case: bind6 deny specific IP & port .. [PASS]
Test case: bind4 allow specific IP & port .. [PASS]
Test case: bind4 allow all .. [PASS]
Test case: bind6 allow all .. [PASS]
Summ[  200.359313] WARNING: CPU: 1 PID: 3400 at
/usr/src/kernel/kernel/workqueue.c:3030 __flush_work+0x3fc/0x470
[  200.369390] Modules linked in: tun algif_hash af_alg
x86_pkg_temp_thermal fuse
[  200.376621] CPU: 1 PID: 3400 Comm: kworker/1:156 Not tainted 5.1.0 #1
[  200.383061] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[  200.390455] Workqueue: events sk_psock_destroy_deferred
[  200.395679] RIP: 0010:__flush_work+0x3fc/0x470
[  200.400123] Code: 03 00 31 c0 e9 a4 fe ff ff 41 8b 0c 24 49 8b 54
24 08 83 e1 08 49 0f ba 2c 24 03 80 c9 f0 e9 d0 fd ff ff 0f 0b e9 83
fe ff ff <0f> 0b 31 c0 e9 7a fe ff ff e8 e6 1f 06 00 84 c0 0f 85 fd fe
ff ff
[  200.418859] RSP: 0018:ffffa5d68487bca0 EFLAGS: 00010246
[  200.424079] RAX: 0000000000000000 RBX: ffff9abc19269468 RCX: 0000000000000006
[  200.431200] RDX: 0000000000001b35 RSI: 0000000000000001 RDI: ffff9abc19269468
[  200.438324] RBP: ffffa5d68487bd68 R08: 0000000000000000 R09: 0000000000000000
[  200.445449] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9abc19269468
[  200.452572] R13: 0000000000000001 R14: ffffa5d68487bd98 R15: ffffffffabe91000
[  200.459696] FS:  0000000000000000(0000) GS:ffff9abc6f880000(0000)
knlGS:0000000000000000
[  200.467776] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  200.473521] CR2: 00007f6c3ebf3cb0 CR3: 00000001d920a006 CR4: 00000000003606e0
[  200.480644] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  200.487768] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  200.494891] Call Trace:
[  200.497338]  ? get_work_pool+0x90/0x90
[  200.501090]  ? mark_held_locks+0x4d/0x80
[  200.505015]  ? __cancel_work_timer+0x11a/0x1d0
[  200.509452]  ? cancel_delayed_work_sync+0x13/0x20
[  200.514151]  ? lockdep_hardirqs_on+0xf6/0x190
[  200.518509]  ? __cancel_work_timer+0x11a/0x1d0
[  200.522946]  ? get_work_pool+0x90/0x90
[  200.526691]  __cancel_work_timer+0x134/0x1d0
[  200.530965]  cancel_delayed_work_sync+0x13/0x20
[  200.535497]  strp_done+0x1c/0x50
[  200.538729]  sk_psock_destroy_deferred+0x34/0x1c0
[  200.543434]  process_one_work+0x281/0x610
[  200.547439]  worker_thread+0x3c/0x3f0
[  200.551105]  kthread+0x12c/0x150
[  200.554337]  ? process_one_work+0x610/0x610
[  200.558515]  ? kthread_park+0x90/0x90
[  200.562180]  ret_from_fork+0x3a/0x50
[  200.565762] irq event stamp: 2382
[  200.569079] hardirqs last  enabled at (2381): [<ffffffffabe9569a>]
__cancel_work_timer+0x11a/0x1d0
[  200.578030] hardirqs last disabled at (2382): [<ffffffffabe01b7b>]
trace_hardirqs_off_thunk+0x1a/0x1c
[  200.587234] softirqs last  enabled at (1806): [<fffffffface00334>]
__do_softirq+0x334/0x445
[  200.595573] softirqs last disabled at (1761): [<ffffffffabe76e70>]
irq_exit+0xc0/0xd0
[  200.603398] ---[ end trace 447ba7732b3f8640 ]---

Test full log link,
https://qa-reports.linaro.org/lkft/linux-mainline-oe/build/v5.1-9822-g47782361aca2/testrun/719520/log

Best regards
Naresh Kamboju
