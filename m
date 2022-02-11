Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986F74B2326
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 11:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348927AbiBKKcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 05:32:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348919AbiBKKcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 05:32:18 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205D1E9E;
        Fri, 11 Feb 2022 02:32:17 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id d27so10642943wrb.5;
        Fri, 11 Feb 2022 02:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=CTKCm88v7qTQ2R8sYmJYejrVwfkvF1N7DAtwHgyHITA=;
        b=PEVvI8lvyG+yyMuME6bK+NTUsE9VvoSvcZ4MFjHGv/9JTjXB5/7gUu/nqdrnmGCQQm
         OueBhXQhUMI0LuetsVxITm0ROgg7pw0c7ZZHVr44THPeXeuhKDqURax/pVdIgBIpYHXH
         /ZIgIHxPDXcL9CPWn53STCsmHaIDtxOs5/0TYZ0ShMcOCkZQv3xNmqgPJV4ZwxW0Gqf6
         f4QyUzQ4m3Fs50iKseKBV77iMM/V+AYaU94j531twb2pBv+DAXnjekLQHDAqn3WWbV0g
         8m2gvpBo505dvgtughe0vKh7kEfe6SOuiXjgRZs1e9Hb3pGCg9MN9YWbjQpWbw7q/abd
         zgjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=CTKCm88v7qTQ2R8sYmJYejrVwfkvF1N7DAtwHgyHITA=;
        b=Mtmd2ar1ddz49s29OjxuetvpKv/JnFe3hrL5O7LwzvqdTLYwIxXroLaV7GODJvnF8C
         o7Ro+bUgCPY62ooCXun3GzM+vs+/hWfd9Nw31rMSxcN78O/vCpXR+dAXdvJ7RFWnhENt
         GeP63mmER+fpSfVlz7qex4rWmlwKmF7wRjfYQaa7teIuTb+tSJUR6w20nv9WUORfK+bG
         A1F3p2oZFCOR13BGPQHZcsJ7MgkStmUXYHnGVKZqU7ViCH9PDtr1UBgr3OkD3shTGA6e
         cPkDAUKZ2vcTcWIaYPJz7Z8JNnLAw3JZaX30WxpuLnvlFSJcjiuqCJIn2a4upfd2BYiH
         dbig==
X-Gm-Message-State: AOAM533GNT32bz6fAVPS0OM7rZo/r6FO80K1YPMbSGSnY5MTNwhmbWo9
        TSEUlrewGcCUrWFF6T7yI5U=
X-Google-Smtp-Source: ABdhPJy/olguZC72hWtA2h8VahlzAoOL3pM5jrE8dTwRcymyszjlSN/r88pZnO/nGFQlgNwxrH7new==
X-Received: by 2002:a05:6000:137b:: with SMTP id q27mr852318wrz.430.1644575535558;
        Fri, 11 Feb 2022 02:32:15 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id y15sm30478038wry.36.2022.02.11.02.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 02:32:15 -0800 (PST)
Date:   Fri, 11 Feb 2022 11:32:13 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     hkallweit1@gmail.com, swsd@realtek.com, davem@davemloft.net,
        kuba@kernel.org, thierry.reding@gmail.com, jonathanh@nvidia.com
Cc:     linux-tegra@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: NETDEV WATCHDOG: enp1s0 (r8169): transmit queue 0 timed out
Message-ID: <YgY7LW8WLtTCZUu0@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

On my tegra124-jetson-tk1, I always got:
[ 1311.064826] ------------[ cut here ]------------
[ 1311.064880] WARNING: CPU: 0 PID: 0 at net/sched/sch_generic.c:477 dev_watchdog+0x2fc/0x300
[ 1311.064976] NETDEV WATCHDOG: enp1s0 (r8169): transmit queue 0 timed out
[ 1311.065011] Modules linked in:
[ 1311.065074] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.16.7-dirty #7
[ 1311.065116] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
[ 1311.065177] [<c01103e4>] (unwind_backtrace) from [<c010ade0>] (show_stack+0x10/0x14)
[ 1311.065253] [<c010ade0>] (show_stack) from [<c0bbe884>] (dump_stack_lvl+0x40/0x4c)
[ 1311.065322] [<c0bbe884>] (dump_stack_lvl) from [<c0122d6c>] (__warn+0xd0/0x12c)
[ 1311.065379] [<c0122d6c>] (__warn) from [<c0bb8c48>] (warn_slowpath_fmt+0x90/0xb4)
[ 1311.065434] [<c0bb8c48>] (warn_slowpath_fmt) from [<c0a0f0f0>] (dev_watchdog+0x2fc/0x300)
[ 1311.065493] [<c0a0f0f0>] (dev_watchdog) from [<c01a8ab0>] (call_timer_fn+0x34/0x1a8)
[ 1311.065554] [<c01a8ab0>] (call_timer_fn) from [<c01a8e50>] (__run_timers.part.0+0x22c/0x328)
[ 1311.065599] [<c01a8e50>] (__run_timers.part.0) from [<c01a8f84>] (run_timer_softirq+0x38/0x68)
[ 1311.065648] [<c01a8f84>] (run_timer_softirq) from [<c0101394>] (__do_softirq+0x124/0x3cc)
[ 1311.065732] [<c0101394>] (__do_softirq) from [<c0129ff4>] (irq_exit+0xa4/0xd4)
[ 1311.065818] [<c0129ff4>] (irq_exit) from [<c0100b90>] (__irq_svc+0x50/0x80)
[ 1311.065860] Exception stack(0xc1101ed8 to 0xc1101f20)
[ 1311.065884] 1ec0:                                                       00000000 00000001
[ 1311.065913] 1ee0: c110a800 00000060 00000001 eed889f8 c121eaa0 418a949d 00000001 00000131
[ 1311.065940] 1f00: 00000001 00000131 00000000 c1101f28 c08bbe20 c08bbee8 60000113 ffffffff
[ 1311.065962] [<c0100b90>] (__irq_svc) from [<c08bbee8>] (cpuidle_enter_state+0x270/0x480)
[ 1311.066031] [<c08bbee8>] (cpuidle_enter_state) from [<c08bc15c>] (cpuidle_enter+0x50/0x54)
[ 1311.066078] [<c08bc15c>] (cpuidle_enter) from [<c015a658>] (do_idle+0x1e0/0x298)
[ 1311.066133] [<c015a658>] (do_idle) from [<c015a9e0>] (cpu_startup_entry+0x18/0x1c)
[ 1311.066174] [<c015a9e0>] (cpu_startup_entry) from [<c1000fc8>] (start_kernel+0x678/0x6bc)
[ 1311.066242] ---[ end trace 3df1a997f30c7eb8 ]---
[ 1311.083269] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
[ 2671.118597] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
[27521.391461] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
[47441.629280] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
[49046.691475] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
[53081.713430] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
[55101.737951] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
[59351.771382] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
[60491.797371] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
[61351.805499] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
[69631.911327] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
[71246.958267] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
[86522.110241] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
[88507.174307] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
[104612.315286] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
[132797.695339] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).

This happen since at least 5.10.
Any idea on how to debug this ?

Regards
