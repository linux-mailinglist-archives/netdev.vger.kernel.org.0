Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938881B1957
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 00:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgDTWYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 18:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgDTWYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 18:24:36 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43225C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 15:24:34 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id n6so8481003ljg.12
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 15:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XBrjco43EgLPQHKsgKfkcPVDlJYyQuCrZyg/ov/OCgY=;
        b=shrxDiodM5ll8/fX+8GjGwAkd8FTCBhTzsAWxCPXGiC0jPqqS1aBYVd4QIKB7oxR9f
         iYrhNewl1t2Yp0Z54I7P4nzfqu/9DLxaeSwY4VSvUUtQqxkkj/0k0zxQpX/s55YxhOSm
         m1pbO+U411tiC+aQvNka/G4uWhOZPakRDr6jMh+B67gunAYLTxoj3BqZNqYT24LLwP+/
         zWJXw9WUY4aLWNl7lU/4JGW+lW8ZOCLc2UybEXh4C8YnMY++ddj4lPR1se2NfycBIWp7
         z3l3F9AbDyEQjw042/SKBq8nU2U3tqNPsVcR3d2mUCkiYGo+1BqxkFnT7MUDf2joJtz1
         Njmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XBrjco43EgLPQHKsgKfkcPVDlJYyQuCrZyg/ov/OCgY=;
        b=qW9DKTbr3TL+Yq53Alj74SijexPbXozo8s5g36yFiT+smpKKs6TtqyNCyYQ336ySBA
         ALJf2Z0W2CnaYDLFUBMjagcvzAhhDvCVZrbghi0zub6/vf1Yk+/buZW1MEoAJPU+NH4E
         8rrbNchniCckTTRHOg8OR11ESfa09xl5Oo0h53YjKx+pLAsWXshLR+Qwzmoz0pE7DVmw
         gc7qZtoHnhICzFna79NcGuJfJU0gZMpWkCQIY9kH600Vr0pT5mL9rg3axJ6prY2r9rS7
         ZkCShxG9B9FIiTQG9t/1UgwlnqB5xB1kpXEW+6YAhTuIbvAlpKeiePC8hSTM836FdKyo
         Eupw==
X-Gm-Message-State: AGi0Pub3TTQlzOmbwYvXJieT0yPNVUskABFE9eVexfG/JxTMBN1J4PSP
        PtWOpddcv/QfaqLHznpTKa+vbobWvWuhEp6wJiNNxQ==
X-Google-Smtp-Source: APiQypLj3aD5kAop4gXWOV8CcVQHDcLCtJZ83zLLmyhddPGY8co/nYuv7WZjxmN5wwyj7tDqfoxWzYnJVFQ08Sk6cGY=
X-Received: by 2002:a2e:8999:: with SMTP id c25mr11623261lji.73.1587421472474;
 Mon, 20 Apr 2020 15:24:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200420121444.178150063@linuxfoundation.org>
In-Reply-To: <20200420121444.178150063@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Apr 2020 03:54:20 +0530
Message-ID: <CA+G9fYsPaoo5YE9pAKV+w=MnZ_AGn93iquOC-tAN5arVyUD8FQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/40] 4.19.117-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org
Cc:     open list <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Wang Wenhu <wenhu.wang@vivo.com>,
        Tim Stallard <code@timstallard.me.uk>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Taehee Yoo <ap420073@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Apr 2020 at 18:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.117 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Apr 2020 12:10:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.117-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
Regressions on x86_64.

x86_64 boot failed due to kernel BUG and kernel panic.
It is hard to reproduce this BUG and kernel panic
We are investigating this problem. The full log links are at [1] and [2].

[ 0.000000] Linux version 4.19.117-rc1+ (TuxBuild@f0f6d9b6cd32) (gcc
version 9.3.0 (Debian 9.3.0-8)) #1 SMP Mon Apr 20 12:40:09 UTC 2020
<>
[    3.237717] igb 0000:01:00.0: Using MSI-X interrupts. 4 rx
queue(s), 4 tx queue(s)
[    3.246412] BUG: unable to handle kernel paging request at 0000000048244=
4ab
[    3.246412] PGD 0 P4D 0
[    3.246412] Oops: 0002 [#1] SMP PTI
[    3.246412] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.19.117-rc1+ #1
[    3.246412] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[    3.246412] RIP: 0010:__hw_addr_add_ex+0xa/0xf0
[    3.246412] Code: 10 01 49 89 5f 08 48 83 c4 08 5b 5d 41 5c 41 5d
41 5e 41 5f c3 b8 f4 ff ff ff eb ea 0f 1f 40 00 41 57 41 56 41 55 41
54 55 53 <48> 83 8c 10 8b 44 24 48 89 4c 24 08 44 89 04 24 44 89 4c 24
04 89
[    3.246412] RSP: 0000:ffff9d614002fc48 EFLAGS: 00010246
[    3.246412] RAX: 0000000000000000 RBX: ffff975d9c17c000 RCX: 00000000000=
00001
[    3.246412] RDX: 0000000000000020 RSI: ffff9d614002fc88 RDI: ffff975d9c1=
7c290
[    3.246412] RBP: ffff975d9c17c000 R08: 0000000000000000 R09: 00000000000=
00000
[    3.246412] R10: ffff975d9da8ee68 R11: 00000000ffffffff R12: 00000000000=
00008
[    3.246412] R13: ffffffffab8ba5bc R14: 0000000000000000 R15: ffffffffaaf=
c93d0
[    3.246412] FS:  0000000000000000(0000) GS:ffff975d9fa80000(0000)
knlGS:0000000000000000
[    3.246412] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.438798] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    3.246412] CR2: 00000000482444ab CR3: 0000000211c0a001 CR4: 00000000003=
606e0
[    3.246412] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    3.246412] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[    3.246412] Call Trace:
[    3.246412]  ? eth_header+0xb0/0xb0
[    3.246412]  dev_addr_init+0x76/0xb0
[    3.448543] ata4: SATA link down (SStatus 0 SControl 300)
[    3.246412]  alloc_netdev_mqs+0x9d/0x3e0
[    3.246412]  igb_probe+0x16e/0x14d0
[    3.462804] ata7: SATA link down (SStatus 0 SControl 300)
[    3.246412]  local_pci_probe+0x3e/0x90
[    3.246412]  pci_device_probe+0x102/0x1a0
[    3.246412]  really_probe+0x1be/0x260
[    3.472410] ata5: SATA link down (SStatus 0 SControl 300)
[    3.246412]  driver_probe_device+0x4b/0x90
[    3.246412]  __driver_attach+0xbb/0xc0
[    3.246412]  ? driver_probe_device+0x90/0x90
[    3.246412]  bus_for_each_dev+0x73/0xb0
[    3.246412]  bus_add_driver+0x192/0x1d0
[    3.246412]  driver_register+0x67/0xb0
[    3.246412]  ? e1000_init_module+0x34/0x34
[    3.246412]  do_one_initcall+0x41/0x1b4
[    3.246412]  kernel_init_freeable+0x15a/0x1e7
[    3.246412]  ? rest_init+0x9a/0x9a
[    3.246412]  kernel_init+0x5/0xf6
[    3.246412]  ret_from_fork+0x35/0x40
[    3.246412] Modules linked in:
[    3.246412] CR2: 00000000482444ab
[    3.246412] ---[ end trace 19f70173fca0a2aa ]---
[    3.246412] RIP: 0010:__hw_addr_add_ex+0xa/0xf0
[    3.246412] Code: 10 01 49 89 5f 08 48 83 c4 08 5b 5d 41 5c 41 5d
41 5e 41 5f c3 b8 f4 ff ff ff eb ea 0f 1f 40 00 41 57 41 56 41 55 41
54 55 53 <48> 83 8c 10 8b 44 24 48 89 4c 24 08 44 89 04 24 44 89 4c 24
04 89
[    3.246412] RSP: 0000:ffff9d614002fc48 EFLAGS: 00010246
[    3.246412] RAX: 0000000000000000 RBX: ffff975d9c17c000 RCX: 00000000000=
00001
[    3.246412] RDX: 0000000000000020 RSI: ffff9d614002fc88 RDI: ffff975d9c1=
7c290
[    3.246412] RBP: ffff975d9c17c000 R08: 0000000000000000 R09: 00000000000=
00000
[    3.246412] R10: ffff975d9da8ee68 R11: 00000000ffffffff R12: 00000000000=
00008
[    3.246412] R13: ffffffffab8ba5bc R14: 0000000000000000 R15: ffffffffaaf=
c93d0
[    3.246412] FS:  0000000000000000(0000) GS:ffff975d9fa80000(0000)
knlGS:0000000000000000
[    3.246412] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.246412] CR2: 00000000482444ab CR3: 0000000211c0a001 CR4: 00000000003=
606e0
[    3.246412] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    3.246412] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[    3.670747] Kernel panic - not syncing: Attempted to kill init!
exitcode=3D0x00000009
[    3.670747]
[    3.679456] Kernel Offset: 0x29600000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[    3.679456] ---[ end Kernel panic - not syncing: Attempted to kill
init! exitcode=3D0x00000009
[    3.679456]  ]---
[    3.701024] ------------[ cut here ]------------
[    3.702023] sched: Unexpected reschedule of offline CPU#2!
[    3.702023] WARNING: CPU: 1 PID: 1 at arch/x86/kernel/smp.c:128
native_smp_send_reschedule+0x2f/0x40

ref:
[1] https://lkft.validation.linaro.org/scheduler/job/1379024#L744
[2] https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/build/v4.19.=
116-41-gdf86600ce713/testrun/1379024/

--=20
Linaro LKFT
https://lkft.linaro.org
