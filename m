Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58BC5093BB
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 01:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383285AbiDTXvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 19:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383278AbiDTXvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 19:51:04 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B763B54E
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 16:48:16 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id h8so5722768ybj.11
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 16:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q3O9US0n2UzXan2e21MKKNaMm8F8Zb9/4YNMGiLrWSA=;
        b=phouAeM8+n8/21EdjUq29cMvCCmXV7I+mFVHMA8yRhbI2ZeFhFME+GsM/YdkOJ+z/C
         09m7jApTuCTrba/kNnDGoZSYEvoGHgSOiITF5H9A3af9FDDIcvsqoDLKu6yuIdfB9IPX
         l9D/NwMBQdwML+N7r71OOoBnqETGhQ28QVV55htKbX1W/CUzBTfuAv4ecz8RKIEQjmGU
         Km2uONTd50ZhFS0i3aQHRgc5CjKQ7Hy0Zu8yU2+wPZvLti/8mCg9sotjWVhRQk6yEDtv
         K1qMIuG30ErHEDEB5Goe0y0nhRc0kQTfVt+A+TMJWRgza//sPVxMl833ROub+LS1u7mN
         TGEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q3O9US0n2UzXan2e21MKKNaMm8F8Zb9/4YNMGiLrWSA=;
        b=VALlDwPdcZePFqAismQvMm3XDv0hOUq2nBa5GtpKh5Iz37b4s8mrMpu4R0jqV+8Bll
         Ei3Mqd0SpaQf5MIi8QPNap13ClQApZi9i0jwCddVFUcAKGL5NTSXBNYTorcKxz1dkDSx
         /5lih8wk/Yr5yA5wdVOuQuyNNSksKzlku5JT6jCIUITbNkSWzkuys32tLOJUsiGbxTag
         TtqIIDgb6m2zOvonl0Hzx+eqzKX8vuaInmpCb2wPtHdMHzmnqCdmeoJyclTjAMbqsDkM
         Ly8OLO1q+OkUO/VZsJ9QhKwyU8tl1jGexXCy7O6P7cSWcaPZ6D52gmwmNQrCbLX0FO3d
         3gow==
X-Gm-Message-State: AOAM532dVqKiGmRhAvg6BAsk2l4NDQAjQsMqDSOvjdbA/hjU3BSEWol9
        wGCiA9tqhPavgHOeVwiw2utbEND4slKZX9qehU2lmw==
X-Google-Smtp-Source: ABdhPJzWLoKAq5dHEia+wimiT6TUUscUqI7ZhR1vGw31AVQAJjofyoXALdULrnUoTC9yRFf+12BPW0BeXJZlf+J/VTE=
X-Received: by 2002:a25:2d4d:0:b0:641:d14e:ff85 with SMTP id
 s13-20020a252d4d000000b00641d14eff85mr21674484ybe.128.1650498495301; Wed, 20
 Apr 2022 16:48:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220414110838.883074566@linuxfoundation.org> <CA+G9fYvgzFW7sMZVdw5r970QNNg4OK8=pbQV0kDfbOX-rXu5Rw@mail.gmail.com>
In-Reply-To: <CA+G9fYvgzFW7sMZVdw5r970QNNg4OK8=pbQV0kDfbOX-rXu5Rw@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 21 Apr 2022 05:18:03 +0530
Message-ID: <CA+G9fYscMP+DTzaQGw1p-KxyhPi0JB64ABDu_aNSU0r+_VgBHg@mail.gmail.com>
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
        Paolo Abeni <pabeni@redhat.com>, NeilBrown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        linux-nfs@vger.kernel.org,
        Anna Schumaker <anna.schumaker@netapp.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Apr 2022 at 14:09, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Thu, 14 Apr 2022 at 18:45, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.238 release.
> > There are 338 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 16 Apr 2022 11:07:54 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.238-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
>
> Following kernel warning noticed on arm64 Juno-r2 while booting
> stable-rc 4.19.238. Here is the full test log link [1].
>
> [    0.000000] Booting Linux on physical CPU 0x0000000100 [0x410fd033]
> [    0.000000] Linux version 4.19.238 (tuxmake@tuxmake) (gcc version
> 11.2.0 (Debian 11.2.0-18)) #1 SMP PREEMPT @1650206156
> [    0.000000] Machine model: ARM Juno development board (r2)
> <trim>
> [   18.499895] ================================
> [   18.504172] WARNING: inconsistent lock state
> [   18.508451] 4.19.238 #1 Not tainted
> [   18.511944] --------------------------------
> [   18.516222] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
> [   18.522242] kworker/u12:3/60 [HC0[0]:SC0[0]:HE1:SE1] takes:
> [   18.527826] (____ptrval____)
> (&(&xprt->transport_lock)->rlock){+.?.}, at: xprt_destroy+0x70/0xe0
> [   18.536648] {IN-SOFTIRQ-W} state was registered at:
> [   18.541543]   lock_acquire+0xc8/0x23c
> [   18.545216]   _raw_spin_lock+0x50/0x64
> [   18.548973]   xs_tcp_state_change+0x1b4/0x440
> [   18.553343]   tcp_rcv_state_process+0x684/0x1300
> [   18.557972]   tcp_v4_do_rcv+0x70/0x290
> [   18.561731]   tcp_v4_rcv+0xc34/0xda0
> [   18.565316]   ip_local_deliver_finish+0x16c/0x3c0
> [   18.570032]   ip_local_deliver+0x6c/0x240
> [   18.574051]   ip_rcv_finish+0x98/0xe4
> [   18.577722]   ip_rcv+0x68/0x210
> [   18.580871]   __netif_receive_skb_one_core+0x6c/0x9c
> [   18.585847]   __netif_receive_skb+0x2c/0x74
> [   18.590039]   netif_receive_skb_internal+0x88/0x20c
> [   18.594928]   netif_receive_skb+0x68/0x1a0
> [   18.599036]   smsc911x_poll+0x104/0x290
> [   18.602881]   net_rx_action+0x124/0x4bc
> [   18.606727]   __do_softirq+0x1d0/0x524
> [   18.610484]   irq_exit+0x11c/0x144
> [   18.613894]   __handle_domain_irq+0x84/0xe0
> [   18.618086]   gic_handle_irq+0x5c/0xb0
> [   18.621843]   el1_irq+0xb4/0x130
> [   18.625081]   cpuidle_enter_state+0xc0/0x3ec
> [   18.629361]   cpuidle_enter+0x38/0x4c
> [   18.633032]   do_idle+0x200/0x2c0
> [   18.636353]   cpu_startup_entry+0x30/0x50
> [   18.640372]   rest_init+0x260/0x270
> [   18.643870]   start_kernel+0x45c/0x490
> [   18.647625] irq event stamp: 18931
> [   18.651037] hardirqs last  enabled at (18931): [<ffff00000832e800>]
> kfree+0xe0/0x370
> [   18.658799] hardirqs last disabled at (18930): [<ffff00000832e7ec>]
> kfree+0xcc/0x370
> [   18.666564] softirqs last  enabled at (18920): [<ffff000008fbce94>]
> rpc_wake_up_first_on_wq+0xb4/0x1b0
> [   18.675893] softirqs last disabled at (18918): [<ffff000008fbce18>]
> rpc_wake_up_first_on_wq+0x38/0x1b0
> [   18.685217]
> [   18.685217] other info that might help us debug this:
> [   18.691758]  Possible unsafe locking scenario:
> [   18.691758]
> [   18.697689]        CPU0
> [   18.700137]        ----
> [   18.702586]   lock(&(&xprt->transport_lock)->rlock);
> [   18.707562]   <Interrupt>
> [   18.710184]     lock(&(&xprt->transport_lock)->rlock);
> [   18.715335]
> [   18.715335]  *** DEADLOCK ***

My bisect script pointed to the following kernel commit,

BAT BISECTION OLD: This iteration (kernel rev
2d235d26dcf81d34c93ba8616d75c804b5ee5f3f) presents old behavior.
242a3e0c75b64b4ced82e29e07a6d6d98eeec826 is the first new commit
commit 242a3e0c75b64b4ced82e29e07a6d6d98eeec826
Author: NeilBrown <neilb@suse.de>
Date:   Tue Mar 8 13:42:17 2022 +1100

    SUNRPC: avoid race between mod_timer() and del_timer_sync()

    commit 3848e96edf4788f772d83990022fa7023a233d83 upstream.

    xprt_destory() claims XPRT_LOCKED and then calls del_timer_sync().
    Both xprt_unlock_connect() and xprt_release() call
     ->release_xprt()
    which drops XPRT_LOCKED and *then* xprt_schedule_autodisconnect()
    which calls mod_timer().

    This may result in mod_timer() being called *after* del_timer_sync().
    When this happens, the timer may fire long after the xprt has been freed,
    and run_timer_softirq() will probably crash.

    The pairing of ->release_xprt() and xprt_schedule_autodisconnect() is
    always called under ->transport_lock.  So if we take ->transport_lock to
    call del_timer_sync(), we can be sure that mod_timer() will run first
    (if it runs at all).

    Cc: stable@vger.kernel.org
    Signed-off-by: NeilBrown <neilb@suse.de>
    Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

 net/sunrpc/xprt.c | 7 +++++++
 1 file changed, 7 insertions(+)

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

 --
Linaro LKFT
https://lkft.linaro.org
