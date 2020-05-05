Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C6F1C545E
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 13:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgEELcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 07:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728233AbgEELcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 07:32:04 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0ECC0610D6
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 04:32:02 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id b2so1229137ljp.4
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 04:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=6Kw2yA9CUSLvugQxqJYorOBTA6l0idW5kKDVSxAH/kE=;
        b=coAZ8iVOFWOOomoiqm+wZLKCpH4mndA9QXaPX2ELit9fUmObsX+ixV/xRXnEZRzD4Y
         Gdf2oirbDBqp9LrsFvFeOy/7SgPA9OO0FyuyFFEVgPdvyyhrLfSreBUyPcWw5ns3tuf+
         anzwvmSxbwTnUT/6PyAyyOzSYi2xsd5oM07WEAKBs4ofvOr8F6Xgvty2BrOsW9j2onbq
         eoRRyFRlAAPqm3e1sBLaKSqejYgJsl6VCtMiETpa+ZccVmcQ5wwLgx6INRCJqTSAAgtx
         WgwQETURYW0oU/XwYggKOPKfZExvecXyZLcNegkwd3GBLxNUTm/1uBMJJMFJl3x8PK4o
         LQjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=6Kw2yA9CUSLvugQxqJYorOBTA6l0idW5kKDVSxAH/kE=;
        b=iYwKNwavSbUoDoLd/FZ8bj6yybdZhJipifRDwCHBoTZc0a5ZWw+xn6Y+FstLEgA0lv
         4N8KH8oMd9BE5PrnrAhLbzBecSa96caTOEmhj4BYa7XfhakwUXQIwN+dmhrmkc1CewEa
         MTMi6TUXiPpvQz3rW4MARU3P9f9wAylRiVmXhTpNF1lgnC9UzEhpA29Me3JRVjYskNeh
         K9onetEnLJsk0ZR55ITcHnNp8Lg7uNvSxssaen2uflvEXsgEeJ/Yo6/4zjxKCzX1DLlw
         9u/ZcHRtb/7uZu4HzjifrVSBZTfFGNK21cbNbPKxeOzJa9MgYVEONSTbBpFnV9/sdRcB
         Bthg==
X-Gm-Message-State: AGi0PubU7HWaFRNz33TCfSNacugCLBkZPG2PDEeF1l+Th1I2wZbGVRU2
        5nKJOAXIHyTbUDgNWOB3hG66KEFLZh4lBrkORVoeDUSaQzWjyw==
X-Google-Smtp-Source: APiQypJxsh7E9ZcxUHOPMgujnzqqC41844Pwzmz3J7Msos8vsl6HqgNVKyuYrUnd1CeV9mqGhR7zuEr6aFQB69MShAs=
X-Received: by 2002:a2e:8999:: with SMTP id c25mr1573219lji.73.1588678320503;
 Tue, 05 May 2020 04:32:00 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 5 May 2020 17:01:49 +0530
Message-ID: <CA+G9fYu4gE2vqSmgyYMfdMS-ZDfQiY1vhk2Jbni+wDJFjLHVKg@mail.gmail.com>
Subject: stable-rc 4.19: NETDEV WATCHDOG: eth0 (asix): transmit queue 0 timed
 out - net/sched/sch_generic.c:466 dev_watchdog
To:     Netdev <netdev@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        lkft-triage@lists.linaro.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While running selftests bpf test_sysctl on stable rc 4.19 branch kernel
on arm64 hikey device. The following warning was noticed.

[  118.957395] test_bpf: #296 BPF_MAXINSNS: exec all MSH
[  148.966435] ------------[ cut here ]------------
[  148.988349] NETDEV WATCHDOG: eth0 (asix): transmit queue 0 timed out
[  149.000832] WARNING: CPU: 0 PID: 0 at
/usr/src/kernel/net/sched/sch_generic.c:466 dev_watchdog+0x2b4/0x2c0
[  149.016470] Modules linked in: test_bpf(+) wl18xx wlcore mac80211
cfg80211 crc32_ce hci_uart crct10dif_ce btbcm snd_soc_audio_graph_card
bluetooth snd_soc_simple_card_utils adv7511 cec wlcore_sdio kirin_drm
dw_drm_dsi rfkill drm_kms_helper drm drm_panel_orientation_quirks fuse
[last unloaded: test_bpf]
[  149.056507] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.19.121-rc1 #1
[  149.069594] Hardware name: HiKey Development Board (DT)
[  149.081514] pstate: 80000005 (Nzcv daif -PAN -UAO)
[  149.093062] pc : dev_watchdog+0x2b4/0x2c0
[  149.103862] lr : dev_watchdog+0x2b4/0x2c0
[  149.114575] sp : ffff000008003d10
[  149.124613] x29: ffff000008003d10 x28: 0000000000000002
[  149.136698] x27: 0000000000000001 x26: 00000000ffffffff
[  149.148810] x25: 0000000000000180 x24: ffff800074c654b8
[  149.160891] x23: ffff800074c65460 x22: ffff8000748dd680
[  149.172993] x21: ffff00000974a000 x20: ffff800074c65000
[  149.185065] x19: 0000000000000000 x18: ffffffffffffffff
[  149.197172] x17: 0000000000000000 x16: 0000000000000000
[  149.209243] x15: 0000000000000001 x14: ffff000009062cd8
[  149.221234] x13: 0000000045a6fc2a x12: ffff00000975b630
[  149.233166] x11: 00000000ffffffff x10: ffff00000974fa48
[  149.245023] x9 : ffff0000097e3000 x8 : ffff00000974fa48
[  149.256818] x7 : ffff000008173694 x6 : ffff800077ee62d0
[  149.268639] x5 : ffff800077ee62d0 x4 : 0000000000000000
[  149.280412] x3 : ffff800077eef6c8 x2 : 0000000000000103
[  149.292120] x1 : d13523b333b73d00 x0 : 0000000000000000
[  149.303783] Call trace:
[  149.312481]  dev_watchdog+0x2b4/0x2c0
[  149.322463]  call_timer_fn+0xbc/0x3f0
[  149.332463]  expire_timers+0x104/0x220
[  149.342493]  run_timer_softirq+0xec/0x1a8
[  149.352784]  __do_softirq+0x114/0x554
[  149.362668]  irq_exit+0x144/0x150
[  149.372235]  __handle_domain_irq+0x6c/0xc0
[  149.382633]  gic_handle_irq+0x60/0xb0
[  149.392606]  el1_irq+0xb4/0x130
[  149.402031]  cpuidle_enter_state+0xbc/0x3f0
[  149.412572]  cpuidle_enter+0x34/0x48
[  149.422539]  call_cpuidle+0x44/0x78
[  149.432410]  do_idle+0x228/0x2a8
[  149.441959]  cpu_startup_entry+0x2c/0x30
[  149.452185]  rest_init+0x25c/0x270
[  149.461821]  start_kernel+0x468/0x494
[  149.471659] irq event stamp: 5706193
[  149.481376] hardirqs last  enabled at (5706192):
[<ffff00000817376c>] console_unlock+0x424/0x638
[  149.496628] hardirqs last disabled at (5706193):
[<ffff000008081490>] do_debug_exception+0xf8/0x1d0
[  149.512207] softirqs last  enabled at (5706160):
[<ffff0000080f94a8>] _local_bh_enable+0x28/0x48
[  149.527590] softirqs last disabled at (5706161):
[<ffff0000080f9bb4>] irq_exit+0x144/0x150
[  149.542410] ---[ end trace 4c7bd8e08a6a3d65 ]---
[  177.828500] jited:1 1366234 PASS

ref:
https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/build/v4.19.120-38-g2e3613309d93/testrun/1415357/log

metadata:
  git branch: linux-4.19.y
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  make_kernelversion: 4.19.121-rc1
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/hikey/lkft/linux-stable-rc-4.19/530/config

-- 
Linaro LKFT
https://lkft.linaro.org
