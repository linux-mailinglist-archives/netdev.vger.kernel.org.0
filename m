Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E251710C384
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 06:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfK1FQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 00:16:59 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37216 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbfK1FQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 00:16:59 -0500
Received: by mail-lf1-f65.google.com with SMTP id b20so18995032lfp.4
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 21:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lR12DaEE+AW1TedwejaQ5XBaagtm7RCiAuWey8Otkmg=;
        b=CF/bXBoLEkRFv4y+G375Ejw43bwkSRxz7ttzZMIBn/MNndnQ8U+DXap2uA4fZbCive
         WQS1QwFAjXzwXUju61HOYQqs0NBgPbLiPLmsz3SWG9RYbQnYsk4oejIXRkJRFcw6LCQ2
         36a+jl4hq4qPAFWyLTccqagURnkUCGYALpaNJN6QVbIEADZQczdSt6bMLAf33zDtgOfl
         1ArUrc55efVXjwXx1G68rVz2iFhQsH8odzaCsmD53Az94HlnwGd2tmSV/95rRxInzCjJ
         5s+Lp6T5v3NuLYdDHZ2tkXxRLONdqvfLaByPrkswWE8U9Ws+gNkyGwAMKgjlAyMXBEwe
         G5Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lR12DaEE+AW1TedwejaQ5XBaagtm7RCiAuWey8Otkmg=;
        b=FLrpgGuicwt02WA0IcMegQTZ52ZCRzJccIGcwbzlMoPt8p+g4ByFLZbD3EIRUal4hN
         yIlYoCO5yB4jQ96hMJ1UVHuPDA854IKoL75cQh40pb37IqEXw+5Q0EMiebo4ePEjyYyO
         ISASG0p1GePaJEmZjIKsxQu9ikkcNdL5+UJ5nlMf/AjZQJOP5ro6hz2MwAgPCGycztEP
         YdQQ7pbOk3w5HQuMqZFq6BvUnSJe5LRnH++shRurCSnSH1Yoc+u8rAwg4jBoHLSayQSS
         9kImZjKNQoXOVkHP3Lfz6lGlnsg7Qt5mnnxsV33zQCnb5jTJGVcCVlZLtp7sO4nQawH/
         l84w==
X-Gm-Message-State: APjAAAWjeapdSkS8OdeI8T/+Qr6qGObCvXy1uQFTljdvEovXx2lTKuNk
        zG6s1hHmIWId1HZghGVrqory6BZ4P3zPtsFTP4cBYA==
X-Google-Smtp-Source: APXvYqyGXHIYd7ZRfGH3KoDb4L4AdaypYelyQIewvgdCPKt9eEmrdgZEoh3E6Dcfr7MuM8WLjOLjsNVEVCKQ1OZohQU=
X-Received: by 2002:ac2:4a91:: with SMTP id l17mr3317369lfp.75.1574918216353;
 Wed, 27 Nov 2019 21:16:56 -0800 (PST)
MIME-Version: 1.0
References: <20191127203049.431810767@linuxfoundation.org>
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 28 Nov 2019 10:46:45 +0530
Message-ID: <CA+G9fYtFNKTYiqm0Bvk_nqBTjsRMKTtNxr6PhE8YaDXFjqwhYQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/211] 4.14.157-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Nov 2019 at 02:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.157 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.157-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Kernel BUG noticed on x86_64 device while booting 4.14.157-rc1 kernel.

Summary
------------------------------------------------------------------------

kernel: 4.14.157-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.14.y
git commit: 3ecb26dddb12a0368baea19c0778c267e215edff
git describe: v4.14.156-212-g3ecb26dddb12
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe-sanity/build/v4.14.156-212-g3ecb26dddb12
kernel-config: http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkft/linux-stable-rc-4.14/655/config

Regressions (compared to build v4.14.156)

[    2.777657] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000090
[    2.785487] IP: kernfs_find_ns+0x18/0xf0
[    2.789408] PGD 0 P4D 0
[    2.791941] Oops: 0000 [#1] SMP PTI
[    2.795424] Modules linked in:
[    2.798474] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.14.157-rc1 #1
[    2.804906] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[    2.812288] task: ffff8e09ee250000 task.stack: ffffa0f900028000
[    2.818200] RIP: 0010:kernfs_find_ns+0x18/0xf0
[    2.822636] RSP: 0000:ffffa0f90002bc48 EFLAGS: 00010286
[    2.827854] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff9e6fb326
[    2.834978] RDX: 0000000000000000 RSI: ffffffff9e7b9c81 RDI: 0000000000000000
[    2.842102] RBP: ffffffff9e7b9c81 R08: ffffffff9d718df0 R09: 00000000000020b0
[    2.849225] R10: ffffa0f90002bc80 R11: ffffffff9f8cfc40 R12: 0000000000000000
[    2.856351] R13: 0000000000000000 R14: ffffffff9e7b9c81 R15: 0000000000000004
[    2.863475] FS:  0000000000000000(0000) GS:ffff8e09f7880000(0000)
knlGS:0000000000000000
[    2.871550] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.877288] CR2: 0000000000000090 CR3: 000000014f41e001 CR4: 00000000003606e0
[    2.884411] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    2.891536] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    2.898659] Call Trace:
[    2.901106]  kernfs_find_and_get_ns+0x2e/0x50
[    2.905463]  sysfs_remove_group+0x25/0x80
[    2.909468]  netdev_queue_update_kobjects+0xbe/0x150
[    2.914426]  netif_set_real_num_tx_queues+0x71/0x200
[    2.919393]  __igb_open+0x19a/0x5c0
[    2.922885]  __dev_open+0xa7/0x130
[    2.926290]  ? __dev_change_flags+0x7c/0x190
[    2.930554]  __dev_change_flags+0x153/0x190
[    2.934739]  ? set_debug_rodata+0x11/0x11
[    2.938744]  dev_change_flags+0x23/0x60
[    2.942575]  ip_auto_config+0x202/0xe4e
[    2.946415]  ? set_debug_rodata+0x11/0x11
[    2.950424]  ? root_nfs_parse_addr+0x9e/0x9e
[    2.954690]  ? do_one_initcall+0x3e/0x154
[    2.958691]  do_one_initcall+0x3e/0x154
[    2.962524]  kernel_init_freeable+0x1b1/0x238
[    2.966875]  ? rest_init+0x190/0x190
[    2.970444]  kernel_init+0xa/0x100
[    2.973844]  ret_from_fork+0x3a/0x50
[    2.977422] Code: 85 a5 fe ff ff e9 3c fe ff ff 66 0f 1f 84 00 00
00 00 00 0f 1f 44 00 00 41 57 41 56 49 89 f6 41 55 41 54 49 89 fd 55
53 49 89 d4 <0f> b7 af 90 00 00 00 8b 05 cb ab 3b 01 48 8b 5f 68 66 83
e5 20
[    2.996288] RIP: kernfs_find_ns+0x18/0xf0 RSP: ffffa0f90002bc48
[    3.002199] CR2: 0000000000000090
[    3.005512] ---[ end trace 93a0e1285ce8e359 ]---
[    3.010131] BUG: sleeping function called from invalid context at
/usr/src/kernel/include/linux/percpu-rwsem.h:34
[    3.020381] in_atomic(): 0, irqs_disabled(): 1, pid: 1, name: swapper/0
[    3.026984] INFO: lockdep is turned off.
[    3.030901] irq event stamp: 912954
[    3.034388] hardirqs last  enabled at (912953):
[<ffffffff9dfa6502>] _raw_spin_unlock_irqrestore+0x32/0x50
[    3.044064] hardirqs last disabled at (912954):
[<ffffffff9e00159e>] error_entry+0x7e/0x100
[    3.052415] softirqs last  enabled at (910778):
[<ffffffff9e20037b>] __do_softirq+0x37b/0x4fa
[    3.060933] softirqs last disabled at (910771):
[<ffffffff9d4d6731>] irq_exit+0xd1/0xe0
[    3.068922] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G      D
4.14.157-rc1 #1
[    3.076567] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[    3.083949] Call Trace:
[    3.086397]  dump_stack+0x71/0xa5
[    3.089716]  ___might_sleep+0x149/0x230
[    3.093555]  exit_signals+0x20/0x210
[    3.097124]  do_exit+0xa0/0xd00
[    3.100263]  ? kernel_init_freeable+0x1b1/0x238
[    3.104796]  rewind_stack_do_exit+0x17/0x20
[    3.108995] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x00000009
[    3.108995]
[    3.118161] Kernel Offset: 0x1c400000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)

Full test log,
https://lkft.validation.linaro.org/scheduler/job/1026224#L793


--
Linaro LKFT
https://lkft.linaro.org
