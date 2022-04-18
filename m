Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09D3504DFD
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 10:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237376AbiDRImt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 04:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237367AbiDRImr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 04:42:47 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91D66430
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 01:40:08 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2ec0bb4b715so133300077b3.5
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 01:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VO1nEBpM2YEzpSjqSp5ZypN9/E5PvRPrZm9lD3pFwK0=;
        b=UIaVzuEYO4Xoxd703BMfjdUKk4kojw9KBYsQ4zcjPaYygOQ4T/UOXau53e34VgPZPZ
         +rhTZE653pDZ+6CDi5HRZE1C8QAUSsHfMBlxBrat3j4+UuH3ZWKDKp9ugeHG9IsYAIL8
         D6evsiMhHBvRlaFWStjW9HR0t6TZQbzvB5fmvCmfNgX9WEclos33MyH9aYjOh3NfJ7N4
         LEC94Nv2JAanVoP+y7+1nTPQNvig2q0+I0RmLN8cSUYDqUNzqw8nuQPvGUtDdsleW0rj
         f6+aOYvlCyst3FrmsQjqKwzTpRWNV8d7e+2sQ4PrCEWOi0YyzNAJXF/1DnuRGgddyTdJ
         QqkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VO1nEBpM2YEzpSjqSp5ZypN9/E5PvRPrZm9lD3pFwK0=;
        b=q02ryXKLBnbxc2kR/pwwTvmQ2ft5SR5NmIjNPW1IhUes667TJWnFqNAaTjWJS0VJ/1
         gNgdRivL4jhk0u0vo1aRWTtZRO/Rur6cChu+hg11ifZVGAgzlHiqMyd/R8lLCCLxOgv5
         0/DtrD28f9OpW7o9DLSoq7GHuy2PG1gWBxc2fA6DGsUOwCKh4oPUcg+6uZK+rtAk8pB9
         QFgaWteshhB3dO4rOf5zyg/p6Yv6MNk0rszaRPDiFKuIvYc87qNV3hbemU0YYD1n3/sp
         s8hom7IhgB3X00qCSEVR0xIt9lm41BslkxbHGfRPFtMDT6xn1+lkEKAxpE5jBeT1LkIT
         X01w==
X-Gm-Message-State: AOAM531NCkyfXP4vrYs9ChdnuVDeur4zHMX8Jnn4MKqV5gROLvbBIXhR
        EPbtPawaf/OLehwamZys4HyzSTjvrTAq55YVixpOzA==
X-Google-Smtp-Source: ABdhPJwBsdJqYmnkgUOwR19QmRCRBStZn9e3VvdDBzctQiTa1N4fHUqW3RN/k4sO1BNcBrw/Ox1gi3Brn2Bt1M34N5U=
X-Received: by 2002:a0d:f487:0:b0:2eb:54f5:3abf with SMTP id
 d129-20020a0df487000000b002eb54f53abfmr9383836ywf.141.1650271207850; Mon, 18
 Apr 2022 01:40:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220414110838.883074566@linuxfoundation.org>
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 18 Apr 2022 14:09:56 +0530
Message-ID: <CA+G9fYvgzFW7sMZVdw5r970QNNg4OK8=pbQV0kDfbOX-rXu5Rw@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/338] 4.19.238-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Apr 2022 at 18:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.238 release.
> There are 338 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 16 Apr 2022 11:07:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.238-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Following kernel warning noticed on arm64 Juno-r2 while booting
stable-rc 4.19.238. Here is the full test log link [1].

[    0.000000] Booting Linux on physical CPU 0x0000000100 [0x410fd033]
[    0.000000] Linux version 4.19.238 (tuxmake@tuxmake) (gcc version
11.2.0 (Debian 11.2.0-18)) #1 SMP PREEMPT @1650206156
[    0.000000] Machine model: ARM Juno development board (r2)
<trim>
[   18.499895] ================================
[   18.504172] WARNING: inconsistent lock state
[   18.508451] 4.19.238 #1 Not tainted
[   18.511944] --------------------------------
[   18.516222] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
[   18.522242] kworker/u12:3/60 [HC0[0]:SC0[0]:HE1:SE1] takes:
[   18.527826] (____ptrval____)
(&(&xprt->transport_lock)->rlock){+.?.}, at: xprt_destroy+0x70/0xe0
[   18.536648] {IN-SOFTIRQ-W} state was registered at:
[   18.541543]   lock_acquire+0xc8/0x23c
[   18.545216]   _raw_spin_lock+0x50/0x64
[   18.548973]   xs_tcp_state_change+0x1b4/0x440
[   18.553343]   tcp_rcv_state_process+0x684/0x1300
[   18.557972]   tcp_v4_do_rcv+0x70/0x290
[   18.561731]   tcp_v4_rcv+0xc34/0xda0
[   18.565316]   ip_local_deliver_finish+0x16c/0x3c0
[   18.570032]   ip_local_deliver+0x6c/0x240
[   18.574051]   ip_rcv_finish+0x98/0xe4
[   18.577722]   ip_rcv+0x68/0x210
[   18.580871]   __netif_receive_skb_one_core+0x6c/0x9c
[   18.585847]   __netif_receive_skb+0x2c/0x74
[   18.590039]   netif_receive_skb_internal+0x88/0x20c
[   18.594928]   netif_receive_skb+0x68/0x1a0
[   18.599036]   smsc911x_poll+0x104/0x290
[   18.602881]   net_rx_action+0x124/0x4bc
[   18.606727]   __do_softirq+0x1d0/0x524
[   18.610484]   irq_exit+0x11c/0x144
[   18.613894]   __handle_domain_irq+0x84/0xe0
[   18.618086]   gic_handle_irq+0x5c/0xb0
[   18.621843]   el1_irq+0xb4/0x130
[   18.625081]   cpuidle_enter_state+0xc0/0x3ec
[   18.629361]   cpuidle_enter+0x38/0x4c
[   18.633032]   do_idle+0x200/0x2c0
[   18.636353]   cpu_startup_entry+0x30/0x50
[   18.640372]   rest_init+0x260/0x270
[   18.643870]   start_kernel+0x45c/0x490
[   18.647625] irq event stamp: 18931
[   18.651037] hardirqs last  enabled at (18931): [<ffff00000832e800>]
kfree+0xe0/0x370
[   18.658799] hardirqs last disabled at (18930): [<ffff00000832e7ec>]
kfree+0xcc/0x370
[   18.666564] softirqs last  enabled at (18920): [<ffff000008fbce94>]
rpc_wake_up_first_on_wq+0xb4/0x1b0
[   18.675893] softirqs last disabled at (18918): [<ffff000008fbce18>]
rpc_wake_up_first_on_wq+0x38/0x1b0
[   18.685217]
[   18.685217] other info that might help us debug this:
[   18.691758]  Possible unsafe locking scenario:
[   18.691758]
[   18.697689]        CPU0
[   18.700137]        ----
[   18.702586]   lock(&(&xprt->transport_lock)->rlock);
[   18.707562]   <Interrupt>
[   18.710184]     lock(&(&xprt->transport_lock)->rlock);
[   18.715335]
[   18.715335]  *** DEADLOCK ***
[   18.715335]
[   18.721270] 2 locks held by kworker/u12:3/60:
[   18.725633]  #0: (____ptrval____)
((wq_completion)\"rpciod\"){+.+.}, at: process_one_work+0x1e0/0x6c0
[   18.734711]  #1: (____ptrval____)
((work_completion)(&task->u.tk_work)){+.+.}, at:
process_one_work+0x1e0/0x6c0
[   18.744831]
[   18.744831] stack backtrace:
[   18.749202] CPU: 0 PID: 60 Comm: kworker/u12:3 Not tainted 4.19.238 #1
[   18.755741] Hardware name: ARM Juno development board (r2) (DT)
[   18.761678] Workqueue: rpciod rpc_async_schedule
[   18.766305] Call trace:
[   18.768758]  dump_backtrace+0x0/0x190
[   18.772427]  show_stack+0x28/0x34
[   18.775748]  dump_stack+0xb0/0xf8
[   18.779072]  print_usage_bug.part.0+0x25c/0x270
[   18.783613]  mark_lock+0x5d0/0x6e0
[   18.787023]  __lock_acquire+0x6c4/0x16f0
[   18.790955]  lock_acquire+0xc8/0x23c
[   18.794539]  _raw_spin_lock+0x50/0x64
[   18.798210]  xprt_destroy+0x70/0xe0
[   18.801708]  xprt_put+0x44/0x50
[   18.804857]  rpc_task_release_client+0x7c/0x90
[   18.809311]  __rpc_execute+0x2a8/0x5f4
[   18.813069]  rpc_async_schedule+0x24/0x30
[   18.817089]  process_one_work+0x28c/0x6c0
[   18.821108]  worker_thread+0x6c/0x450
[   18.824779]  kthread+0x12c/0x16c
[   18.828015]  ret_from_fork+0x10/0x24
[   18.931718] VFS: Mounted root (nfs filesystem) on device 0:17.

metadata:
  git_ref: linux-4.19.y
  git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  git_sha: aaad8e56ca1e56fe34b5a33f30fb6f9279969020
  git_describe: v4.19.238
  kernel_version: 4.19.238
  kernel-config: https://builds.tuxbuild.com/27vgbZzdS2aNU90tNu4Hl0IJuIP/config


--
Linaro LKFT
https://lkft.linaro.org

[1] https://lkft.validation.linaro.org/scheduler/job/4909565#L1141
