Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A686C10C41F
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 07:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfK1Gxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 01:53:55 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44075 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbfK1Gxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 01:53:54 -0500
Received: by mail-ot1-f66.google.com with SMTP id c19so21342334otr.11
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 22:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wJa16Nd4lZ1mLaB9TdiTkMJ+KJ3QKJBaGmOkeaLvJ6Q=;
        b=pqm79NTlVdFNPQosYkLVtpIUGYu300ZPWBuGyDuPHfkrEeJ1j4RfGKGJM9HngluQor
         WrZ3FaIC6kzJ/sCUbyKg3ievHC/+TaMFwwW+Uox10LJOB8TkPb3vyMxzS2eR0SjqJvVC
         6sFs4kq38xIPSVz+oLJmYnCiGsRu+ije/bZk2m5cibO749CmSef7eIsv/J4180dmQ127
         9hhBjpWQXKFo6IuJ/OLO9Arx3dg2MKJGbeNWlnBh4LXEqKNR7MKlXbo6OeiEqPf54qyo
         OB9GwaqLkTLISwemCkaEeRQQ3RB/63ckkyVMKGJ8Yo9OxgnTLY4kPJlhgrnqkokwz5Oj
         4lqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wJa16Nd4lZ1mLaB9TdiTkMJ+KJ3QKJBaGmOkeaLvJ6Q=;
        b=erREczmeKVDCzCKsiXMzTVS96sgkzcf896tSXfrtl+XgfN6jvrCX/HySQgB62OUMYf
         tAp9VEpgZhspEUY+9rKP7W8roSnzXNVUrTtPwMEyCoVGwN8+dzs1HRYFuwYeq6x2io7j
         q9eMKQW/v83OmW3BFLhPl1hdTA2Ar6DW3YmSe/2BL3y2tuu28USlrxmik09TdaIl6/ZV
         iF+CJbN0nsjGaQ1M2QkVZvlhL+S6s+9mqGxm4GvM91r92C11XbVPdUa9RKwUob0IsMyx
         JsAhDL2CO498dKqYorV0TaFctnDmvhaL4YZEBOby0sqxheYwwTo/1C6DqpE2sfahYSdM
         HwnA==
X-Gm-Message-State: APjAAAV0meuAQ+QVGzQpN+T7za8pYMRxsjjKFtlB+cA2KtNHeIBZPZPY
        SCFhORKT8hta3d3RzeSDrqVC/UBcHMDjhawZC8xTxA==
X-Google-Smtp-Source: APXvYqycsSJyeSkya5N7feu4ipwA/fEvWBjaSHN8dgRJaaMaPTfF2MQbpi4S5RkSUFv6JuOW3Cl84a7YWwaukVc80wo=
X-Received: by 2002:a9d:6294:: with SMTP id x20mr6138399otk.31.1574924032684;
 Wed, 27 Nov 2019 22:53:52 -0800 (PST)
MIME-Version: 1.0
References: <20191127203114.766709977@linuxfoundation.org>
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 28 Nov 2019 12:23:41 +0530
Message-ID: <CA+G9fYuAY+14aPiRVUcXLbsr5zJ-GLjULX=s9jcGWcw_vb5Kzw@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/306] 4.19.87-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        jouni.hogander@unikie.com, "David S. Miller" <davem@davemloft.net>,
        lukas.bulwahn@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Nov 2019 at 02:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.87 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.87-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Kernel BUG noticed on x86_64 device while booting 4.19.87-rc1 kernel.

The problematic patch is,

> Jouni Hogander <jouni.hogander@unikie.com>
>     net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject

And this kernel panic is been fixed by below patch,

commit 48a322b6f9965b2f1e4ce81af972f0e287b07ed0
Author: Eric Dumazet <edumazet@google.com>
Date:   Wed Nov 20 19:19:07 2019 -0800

    net-sysfs: fix netdev_queue_add_kobject() breakage

    kobject_put() should only be called in error path.

    Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in
rx|netdev_queue_add_kobject")
    Signed-off-by: Eric Dumazet <edumazet@google.com>
    Cc: Jouni Hogander <jouni.hogander@unikie.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

Summary
------------------------------------------------------------------------

kernel: 4.19.87-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.19.y
git commit: 57c5d287ed483d6100bdca528c57562b894487b5
git describe: v4.19.86-307-g57c5d287ed48
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe-sanity/build/v4.19.86-307-g57c5d287ed48

Regressions (compared to build v4.19.86)

[    3.556598] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000090
[    3.569683] PGD 0 P4D 0
[    3.572221] Oops: 0000 [#1] SMP PTI
[    3.575705] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 4.19.87-rc1 #1
[    3.582049] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[    3.589523] RIP: 0010:kernfs_find_ns+0x1f/0x130
[    3.594053] Code: fe ff ff 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
55 48 89 e5 41 57 41 56 41 55 41 54 49 89 ff 53 49 89 f6 49 89 d5 48
83 ec 08 <0f> b7 87 90 00 00 00 48 8b 5f 68 66 83 e0 20 66 89 45 d6 8b
05 68
[    3.612788] RSP: 0000:ffffaf514002fba8 EFLAGS: 00010292
[    3.618007] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff95d15b89
[    3.625130] RDX: 0000000000000000 RSI: ffffffff95ddefc7 RDI: 0000000000000000
[    3.632254] RBP: ffffaf514002fbd8 R08: ffffffff94b88f05 R09: 0000000000000001
[    3.639377] R10: ffffaf514002fbd8 R11: 0000000000000001 R12: ffffffff95ddefc7
[    3.646502] R13: 0000000000000000 R14: ffffffff95ddefc7 R15: 0000000000000000
[    3.653625] FS:  0000000000000000(0000) GS:ffff95c0dfb00000(0000)
knlGS:0000000000000000
[    3.661704] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.667442] CR2: 0000000000000090 CR3: 00000003bc01e001 CR4: 00000000003606e0
[    3.674565] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    3.681689] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    3.688811] Call Trace:
[    3.691259]  kernfs_find_and_get_ns+0x33/0x60
[    3.695616]  sysfs_remove_group+0x2a/0x90
[    3.699622]  netdev_queue_update_kobjects+0xc6/0x150
[    3.704587]  netif_set_real_num_tx_queues+0x7e/0x230
[    3.709546]  ? igb_configure_msix+0xde/0x170
[    3.713816]  __igb_open+0x19e/0x5e0
[    3.717322]  igb_open+0x10/0x20
[    3.720506]  __dev_open+0xd7/0x170
[    3.723904]  ? _raw_spin_unlock_bh+0x35/0x40
[    3.728168]  __dev_change_flags+0x17e/0x1d0
[    3.732363]  dev_change_flags+0x29/0x60
[    3.736195]  ip_auto_config+0x28b/0xf04
[    3.740033]  ? tcp_set_default_congestion_control+0xac/0x150
[    3.745683]  ? root_nfs_parse_addr+0xa5/0xa5
[    3.749948]  ? set_debug_rodata+0x17/0x17
[    3.753951]  do_one_initcall+0x61/0x2b4
[    3.757783]  ? do_one_initcall+0x61/0x2b4
[    3.761793]  ? set_debug_rodata+0xa/0x17
[    3.765713]  ? rcu_read_lock_sched_held+0x81/0x90
[    3.770418]  kernel_init_freeable+0x1d8/0x270
[    3.774777]  ? rest_init+0x190/0x190
[    3.778354]  kernel_init+0xe/0x110
[    3.781753]  ret_from_fork+0x3a/0x50
[    3.785349] Modules linked in:
[    3.788427] CR2: 0000000000000090
[    3.791740] ---[ end trace 831b7578b86a527b ]---
[    3.796358] RIP: 0010:kernfs_find_ns+0x1f/0x130
[    3.800889] Code: fe ff ff 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
55 48 89 e5 41 57 41 56 41 55 41 54 49 89 ff 53 49 89 f6 49 89 d5 48
83 ec 08 <0f> b7 87 90 00 00 00 48 8b 5f 68 66 83 e0 20 66 89 45 d6 8b
05 68
[    3.819625] RSP: 0000:ffffaf514002fba8 EFLAGS: 00010292
[    3.824843] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff95d15b89
[    3.831968] RDX: 0000000000000000 RSI: ffffffff95ddefc7 RDI: 0000000000000000
[    3.839091] RBP: ffffaf514002fbd8 R08: ffffffff94b88f05 R09: 0000000000000001
[    3.846216] R10: ffffaf514002fbd8 R11: 0000000000000001 R12: ffffffff95ddefc7
[    3.853363] R13: 0000000000000000 R14: ffffffff95ddefc7 R15: 0000000000000000
[    3.860499] FS:  0000000000000000(0000) GS:ffff95c0dfb00000(0000)
knlGS:0000000000000000
[    3.868583] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.874323] CR2: 0000000000000090 CR3: 00000003bc01e001 CR4: 00000000003606e0
[    3.881454] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    3.888576] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    3.895702] BUG: sleeping function called from invalid context at
/usr/src/kernel/include/linux/percpu-rwsem.h:34
[    3.905946] in_atomic(): 0, irqs_disabled(): 1, pid: 1, name: swapper/0
[    3.912550] INFO: lockdep is turned off.
[    3.916465] irq event stamp: 1027104
[    3.920038] hardirqs last  enabled at (1027103):
[<ffffffff9553abd6>] _raw_spin_unlock_irqrestore+0x36/0x50
[    3.929770] hardirqs last disabled at (1027104):
[<ffffffff94801c8b>] trace_hardirqs_off_thunk+0x1a/0x1c
[    3.939233] softirqs last  enabled at (1025718):
[<ffffffff9580031f>] __do_softirq+0x31f/0x426
[    3.947832] softirqs last disabled at (1025703):
[<ffffffff948eddb6>] irq_exit+0xd6/0xe0
[    3.955916] CPU: 2 PID: 1 Comm: swapper/0 Tainted: G      D
  4.19.87-rc1 #1
[    3.963648] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[    3.971126] Call Trace:
[    3.973572]  dump_stack+0x7a/0xa5
[    3.976890]  ___might_sleep+0x152/0x240
[    3.980720]  __might_sleep+0x4a/0x80
[    3.984309]  exit_signals+0x33/0x240
[    3.987896]  do_exit+0xbd/0xcf0
[    3.991035]  ? kernel_init_freeable+0x1d8/0x270
[    3.995567]  ? rest_init+0x190/0x190
[    3.999136]  rewind_stack_do_exit+0x17/0x20
[    4.003348] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x00000009
[    4.003348]
[    4.012537] Kernel Offset: 0x13800000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[    4.023318] ---[ end Kernel panic - not syncing: Attempted to kill
init! exitcode=0x00000009
[    4.023318]  ]---


--
Linaro LKFT
https://lkft.linaro.org
