Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC035FFD15
	for <lists+netdev@lfdr.de>; Sun, 16 Oct 2022 04:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiJPC6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 22:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiJPC6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 22:58:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45AE3472B;
        Sat, 15 Oct 2022 19:58:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E8EE60276;
        Sun, 16 Oct 2022 02:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D24C433D7;
        Sun, 16 Oct 2022 02:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665889121;
        bh=NnUyPHASIfw1LSaaCWx4HRDpypn7TMhqow40xHGimTU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GAiSAepVABOMEe4+x/mAcWbiG0OOc4xfnRqYoTFT0vPNOrpvLllkgj68OmXLOGilb
         M8OLLUk80OuTlbMcaVHgXaxs7HsjAUnIzD2mbhUkMErLXBx6JaPvEwjN4v9w25d2Ju
         z82RKdLyYy/De/T2FDZm0Yph8Uht4q0i6QXFD7n4KBGUXYuiXaKh2Tox1V9b061tem
         708jyfP5zCuqXaULSiteTlrhzozIMX/1bRKFYJ8p/JcO8tosTxG33CUI8SPbhghK9+
         MHDR/Y2XaBnRaryMMIzWOZKY7RYtgksIksuf4ynwlCI6xW7UkJ9iFL+3zXVgeONpvm
         vmn8pc/TcDmpA==
Received: by mail-ot1-f50.google.com with SMTP id br15-20020a056830390f00b0061c9d73b8bdso4023993otb.6;
        Sat, 15 Oct 2022 19:58:41 -0700 (PDT)
X-Gm-Message-State: ACrzQf0xSrYQyVgb0g/JobsmiSK6ZQM1s+c3vlMFl6EV5DeAx0TK7FXf
        l+u25fSi9fKlqXdhk0As2aQYJSVs4oGx7Nxn5OA=
X-Google-Smtp-Source: AMsMyM6QxzN3RRrashA0QCjtbpKDBtR8wHzCuKIHZm0/KJgT2W5LeX8dm8H7j6XXXYJGKbXLUZjFUR0wqtOdclAKcH0=
X-Received: by 2002:a9d:3634:0:b0:661:a991:7c57 with SMTP id
 w49-20020a9d3634000000b00661a9917c57mr2237737otb.308.1665889120751; Sat, 15
 Oct 2022 19:58:40 -0700 (PDT)
MIME-Version: 1.0
References: <20221015130548.3634468-1-guoren@kernel.org> <20221015165017.GA1034513@roeck-us.net>
In-Reply-To: <20221015165017.GA1034513@roeck-us.net>
From:   Guo Ren <guoren@kernel.org>
Date:   Sun, 16 Oct 2022 10:58:29 +0800
X-Gmail-Original-Message-ID: <CAJF2gTR1eBhdd1uhJReSZxfc4vyt9n9MbaG7XQjAJcvdaFbbXQ@mail.gmail.com>
Message-ID: <CAJF2gTR1eBhdd1uhJReSZxfc4vyt9n9MbaG7XQjAJcvdaFbbXQ@mail.gmail.com>
Subject: Re: [PATCH] Revert "cpumask: fix checking valid cpu range"
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@rasmusvillemoes.dk, yury.norov@gmail.com,
        caraitto@google.com, willemb@google.com, jonolson@google.com,
        amritha.nambiar@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 16, 2022 at 12:50 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Sat, Oct 15, 2022 at 09:05:48AM -0400, guoren@kernel.org wrote:
> > From: Guo Ren <guoren@linux.alibaba.com>
> >
> > This reverts commit 78e5a3399421ad79fc024e6d78e2deb7809d26af.
> >
> > ------------[ cut here ]------------
> > WARNING: CPU: 3 PID: 1 at include/linux/cpumask.h:110 cpumask_next_wrap+0x5c/0x80
> >
> > Let's back this out and retry with a larger clean up in -next.
> >
>
> Unfortunately the revert triggers (or exposes ?) another backtrace.
This should be fixed by another Revert patch.

https://lore.kernel.org/netdev/166582921612.1299.769135677399153914.git-patchwork-notify@kernel.org/T/#m0111a76380626b2f91e072ecdd5827578d5cbf60

Please have a try.

>
> WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 __netif_set_xps_queue+0x194/0x976
> Modules linked in:
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-12199-g277163563de8 #1
> Hardware name: riscv-virtio,qemu (DT)
> epc : __netif_set_xps_queue+0x194/0x976
> ra : __netif_set_xps_queue+0x3b0/0x976
> epc : c089a664 ra : c089a880 sp : c2515c60
> gp : c1d8e760 tp : c2578040 t0 : c364f980
> t1 : 00000000 t2 : 00001fff s0 : c2515cd0
> s1 : c2515ce4 a0 : c364f940 a1 : 00000000
> a2 : c364f940 a3 : 00000000 a4 : c364f950
> a5 : c364f890 a6 : 00000003 a7 : 00000000
> s2 : 00000001 s3 : c1d382c0 s4 : 00000000
> s5 : 00000000 s6 : 00000000 s7 : c364f880
> s8 : 00000000 s9 : 00000001 s10: 00000001
> s11: 00000000 t3 : 00000018 t4 : 7fd38a0e
> t5 : 00000007 t6 : c3639470
> status: 00000120 badaddr: 00000000 cause: 00000003
> [<c074548a>] virtnet_set_affinity+0x13a/0x1a2
> [<c07478de>] virtnet_probe+0x884/0xfdc
> [<c063ce9a>] virtio_dev_probe+0x1d6/0x354
> [<c0683d6e>] really_probe+0x82/0x214
> [<c0683f58>] __driver_probe_device+0x58/0xa2
> [<c0683fd2>] driver_probe_device+0x30/0xaa
> [<c0684596>] __driver_attach+0x56/0x11c
> [<c0681f26>] bus_for_each_dev+0x52/0x90
> [<c06837c0>] driver_attach+0x1a/0x22
> [<c068331a>] bus_add_driver+0x148/0x1b6
> [<c0684d70>] driver_register+0x52/0xea
> [<c063c924>] register_virtio_driver+0x1a/0x28
> [<c0c2428e>] virtio_net_driver_init+0x7a/0xa6
> [<c0002824>] do_one_initcall+0x5e/0x2e2
> [<c0c01130>] kernel_init_freeable+0x298/0x306
> [<c0aa0ac2>] kernel_init+0x1e/0x10e
> [<c0003ad8>] ret_from_exception+0x0/0x10
> irq event stamp: 106012
> hardirqs last  enabled at (106011): [<c0aa9284>] _raw_spin_unlock_irqrestore+0x54/0x62
> hardirqs last disabled at (106012): [<c0007534>] __trace_hardirqs_off+0xc/0x14
> softirqs last  enabled at (105764): [<c0886392>] napi_get_frags_check+0x0/0x50
> softirqs last disabled at (105758): [<c0886392>] napi_get_frags_check+0x0/0x50
>
> This is the result of commit 854701ba4c39 ("net: fix cpu_max_bits_warn()
> usage in netif_attrmask_next{,_and}").
>
> Guenter



-- 
Best Regards
 Guo Ren
