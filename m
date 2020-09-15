Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE8F269B35
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 03:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgIOBbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 21:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgIOBbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 21:31:38 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48D5C06174A;
        Mon, 14 Sep 2020 18:31:37 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id w11so1358042lfn.2;
        Mon, 14 Sep 2020 18:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=opkNEcLncllp4Ebs9OjD9MiSmVpkwKbG0IG2gHXYqbM=;
        b=mRj/yplqffXWlAx5pqRJNfoXVENbnzFLhtW97U89LHQ2OHei1z1IxSrrDzElX4S1Nd
         bTocTUIaEsBHZW6bSqFn8Y5hQfhe33YThx4CvMQyo7eKnUe1LPIyx95SVn7/2X0o82+C
         oh9T6yBzjT0NUlVvIoiNxChdxjrdO3ZzgLL8dir6Vys5xKdlcfV+c4D78c63pz6N7KcX
         9PtldpfIo+nFgeOrAX/SLhM86/rJyG4xYhzDp1XtYDkGi3DD8HmL+4XSMIPqKL0/YAW5
         vXQjBu97yoRWnggIhFNTeizw2S0zhZ7vAA/C+dkTfvAOFrN1ke9puAlSZR6OPNGGO5VU
         LfKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=opkNEcLncllp4Ebs9OjD9MiSmVpkwKbG0IG2gHXYqbM=;
        b=uBy8hXD5PmIdW9gsx1z/1Yv1lx9fn6y1tkjuRO6/IQGRa1vHuA1ZvLFVR4b96HYxSk
         VV7UwWXfQ8C4fYWYzXvgrQfiTzM6tWQU3aBVL/QRqE7SoTE9w84eFRq2Qc48qB/nRxu3
         YvwcsRKkGB+BVnsMUZ96qtf9gklSUMM/H3A8vaq0VEsTzgYZdFvebtXoc1vWvcnVxXq4
         nG+D/XGSZXifMxaD0zaVgD2Ky8awJjr8FYg0fFA9b2ByjVSN7RvAXixc7rCDOhtcJ4ZL
         9jwa7q9ctIURNgwv7MiIfR9O3b8dLZtU97Df9Rvs3WcZt07oWjkyyMBHEkwMmyk/c0gU
         x3CA==
X-Gm-Message-State: AOAM531mJczbzp331YN6Xq0FqQGvrMDsjKRAimpyHVXRUgSyJzKK/3QV
        cEWZ+EtpRI+bHYbBF+mGNxRTjUMYKviZiT8irII=
X-Google-Smtp-Source: ABdhPJzSEODWNV1YrgURuC/rwDjDnhro31dJhM8kjzWhsOlniGMjDJqn3w6EsXPFvW4kLFSJuO0SVtVBrBVsaADbfgU=
X-Received: by 2002:a19:8089:: with SMTP id b131mr4653149lfd.390.1600133496085;
 Mon, 14 Sep 2020 18:31:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200910011404.2519355-1-andriin@fb.com>
In-Reply-To: <20200910011404.2519355-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 14 Sep 2020 18:31:24 -0700
Message-ID: <CAADnVQKNA-sL_NAGVnAobsc08jiAr51AmTL9fmkoQVZbn9okvQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: merge most of test_btf into test_progs
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 7:51 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Move almost 200 tests from test_btf into test_progs framework to be exercised
> regularly. Pretty-printing tests were left alone in test_btf because they are
> very slow and were not even executed by default with test_btf. Also, they seem
> to break when moved under test_progs and I didn't want to spend more time on
> figuring out why they broke, given we don't want to execute them all the time
> anyway.
>
> All the test_btf tests that were moved are modeled as proper sub-tests in
> test_progs framework for ease of debugging and reporting.
>
> No functional or behavioral changes were intended, I tried to preserve
> original behavior as close to the original as possible. `test_progs -v` will
> activate "always_log" flag to emit BTF validation log.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/btf.c | 6124 ++++++++++++++
>  tools/testing/selftests/bpf/test_btf.c       | 7442 ++----------------
>  2 files changed, 6796 insertions(+), 6770 deletions(-)

Thanks for consolidating, but it's impossible to realistically review such diff.
gmail web ui is super slow to even reply to such email.
Could you split it into 'git mv' patch and other patches?
The first move will break the selftests build, but I think that's ok.
I'd rather live with such bisecting issue than no review.
Also just noticed doing
./test_btf -p
BTF pretty print array(#0)......OK
BTF pretty print hash(#0)......[   83.134228] ------------[ cut here
]------------
[   83.134907] WARNING: CPU: 3 PID: 2006 at kernel/bpf/hashtab.c:717
htab_map_get_next_key+0x7fc/0xab0
[   83.135962] Modules linked in: bpf_preload
[   83.136403] CPU: 3 PID: 2006 Comm: test_btf Not tainted
5.9.0-rc1-00870-g2bab48c5bef0 #2930
[   83.137328] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.11.0-2.el7 04/01/2014
[   83.138337] RIP: 0010:htab_map_get_next_key+0x7fc/0xab0
[   83.138947] Code: c0 45 31 e4 e9 0b ff ff ff 48 8b 7c 24 10 48 8d
70 30 89 ca e8 d5 8d 21 00 31 c0 48 83 c4 40 5b 5d 41 5c 41 5d 41 5e
41 5f c3 <0f> 0b e9 30 f8 ff ff 4c 8b 34 24 89 ca 41 89 dc 41 89 dd e9
70 fa
[   83.140997] RSP: 0018:ffff8881df5b7d30 EFLAGS: 00010246
[   83.141577] RAX: 0000000000000000 RBX: ffff8881eb537a98 RCX: 1ffff1103d6a6f58
[   83.142345] RDX: dffffc0000000000 RSI: ffffffff84b180a0 RDI: ffff8881f05008c8
[   83.143153] RBP: ffff8881e6cf8000 R08: 0000000000000000 R09: ffff8881e6cf8000
[   83.143953] R10: ffff8881e793405a R11: ffffed103cf2680b R12: ffff8881f1d96898
[   83.144739] R13: ffffffff83cdf8a0 R14: ffff8881eb537b78 R15: 000000000000005b
[   83.145571] FS:  00007ff4f1d0a700(0000) GS:ffff8881f6f80000(0000)
knlGS:0000000000000000
[   83.146433] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   83.147076] CR2: 0000000000436ef1 CR3: 00000001dfc8e001 CR4: 00000000003706e0
[   83.147842] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   83.148679] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   83.149474] Call Trace:
[   83.149779]  ? memcpy+0x39/0x60
[   83.150136]  map_seq_next+0x176/0x300
[   83.150571]  ? map_seq_show+0x150/0x220
[   83.151054]  seq_read+0x6ed/0xd70
[   83.151423]  vfs_read+0x150/0x4a0
[   83.151830]  ksys_read+0xe9/0x1b0
[   83.152196]  ? vfs_write+0x620/0x620
[   83.152644]  ? trace_hardirqs_on+0x20/0x170
[   83.153133]  do_syscall_64+0x2d/0x40
[   83.153542]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   83.154110] RIP: 0033:0x7ff4f0dd7bf0
[   83.154498] Code: 0b 31 c0 48 83 c4 08 e9 ae fe ff ff 48 8d 3d 7f
ed 08 00 e8 02 d4 01 00 66 90 83 3d 59 5b 2c 00 00 75 10 b8 00 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 ae 96 01 00 48 89
04 24
[   83.156514] RSP: 002b:00007fffb93aeee8 EFLAGS: 00000246 ORIG_RAX:
0000000000000000
[   83.157340] RAX: ffffffffffffffda RBX: 0000000000543040 RCX: 00007ff4f0dd7bf0
[   83.158155] RDX: 0000000000001000 RSI: 0000000000543520 RDI: 0000000000000005
[   83.158981] RBP: 0000000000543040 R08: 0000000000000003 R09: 0000000000001011
[   83.159757] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fffb93aefd8
[   83.160538] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000004
[   83.161323] irq event stamp: 3514803
[   83.161762] hardirqs last  enabled at (3514813):
[<ffffffff81275931>] console_unlock+0x611/0x9d0
[   83.162818] hardirqs last disabled at (3514822):
[<ffffffff81275400>] console_unlock+0xe0/0x9d0
[   83.163900] softirqs last  enabled at (3308060):
[<ffffffff83a005a3>] __do_softirq+0x5a3/0x883
[   83.164851] softirqs last disabled at (3308055):
[<ffffffff83800ebf>] asm_call_on_stack+0xf/0x20
[   83.165883] ---[ end trace 518a74dd5d67d50c ]---
OK
BTF pretty print lru hash(#0)......[   86.149427] perf: interrupt took
too long (2577 > 2500), lowering kernel.perf_event_max_sample_rate to
77000
OK
BTF pretty print percpu array(#0)......[   89.952685] perf: interrupt
took too long (3249 > 3221), lowering
kernel.perf_event_max_sample_rate to 61000
OK
BTF pretty print percpu hash(#0)......OK
BTF pretty print lru percpu hash(#0)......[  100.798017] perf:
interrupt took too long (4160 > 4061), lowering
kernel.perf_event_max_sample_rate to 48000
OK
BTF pretty print array(#1)......OK
BTF pretty print array(#2)......OK
BTF pretty print array(#3)......OK
PASS:9 SKIP:0 FAIL:0

They are slow, but they pass and clearly useful, since they caught above bug.
