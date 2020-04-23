Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73751B59E7
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 13:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgDWLCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 07:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727069AbgDWLCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 07:02:14 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D47C035494
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 04:02:13 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id u10so4394059lfo.8
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 04:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=xaW+mnhjgVoJv5NiNtJ4Kk3cEDBGI/xJgmkizAEw7eA=;
        b=rmz83U7sE205OchDK29ZZjHcr537NHA9Md0lmdSQlIQeWb7U1+11hB7Z6oPW98GvQC
         Rsxk8XjJvWw4pZNbYsShvLu3J7V61rWY8ZiNlSRjDwqhv+Y7tWei7TDuikYlGXIOdU8S
         lTSI1YaxQqgPEPIptOiic/RyCmTLErjZ4Q/DH4CE+xqKFnAxBgWgAWNduWzmyG41ROTy
         LGMUOISFDxVLcIEojqohXMU11/R7zd8Ooc3rMOlufzmYrzUR+AoBWDJDodOTxHh0DW/8
         ww+qH0N+4aLvA/raI2JfDJ4OWpPHLCfFvkoyJ9K0h9cIND8O0ZVXAs8eHyAUq3CQeK6q
         kJyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=xaW+mnhjgVoJv5NiNtJ4Kk3cEDBGI/xJgmkizAEw7eA=;
        b=GB+W63uqnlwBpY0mkwsJGRn6sjMfHdS1ygEQK/ZefTwzeKDNF8/58sIWBSXj83MTZS
         BshsXcmG60Rm7SybnjX1Yqh3bwFPBJIyR3XxSuevwyvpfOzVygSeLg83xFdtCAnVpfV7
         4FzbYqF184hliFG24wrAuRurFrRMIOFPnkHgn4ih87PtDqSZW+ns+6xtkLbWzQR2EPu9
         2X9/EXeFEOdAv/hZzw7fF0Us26s1aG8+nGAlfoqfSSX+aOoWcQTIddIE5ykjyXvhM6e5
         t0UYtYOpgJrcHgWqgkWHin527EX3GZSZluxoe/8QjSW5cy9zSy0o2QqTabF8PHVkeXg1
         vDyg==
X-Gm-Message-State: AGi0PuYP37TSOQHQ4MzaQR7U6zE2Vf8eokAtSvsmd+BpCiGFjpWiFYA0
        lqR7q9hGiPGu1th5GEV8RvcW8KYnrVUzslH/Qb81Qg==
X-Google-Smtp-Source: APiQypKsRAnKv/+SUeLr/83RrfVhQJu7iFWPVvghIe1H9p6QL/FXa5l0YD1kXNRT1tXZ4dE827pXlcHN6Zm8ma2X0XI=
X-Received: by 2002:ac2:5559:: with SMTP id l25mr2071966lfk.55.1587639731920;
 Thu, 23 Apr 2020 04:02:11 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 23 Apr 2020 16:32:00 +0530
Message-ID: <CA+G9fYtR4cvY9N0NLYDOByHsDyQJwpaYuV8qss6s-D+_DS9x_A@mail.gmail.com>
Subject: WARNING: net/sched/sch_generic.c:320 dev_watchdog
To:     linux- stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While running selftests: bpf test_sysctl on arm64 hi6220-hikey on
stable rc 4.14 branch the following kernel warnings were noticed.

steps to reproduce: (Not always reproducible)
--------------------------
# cd /opt/kselftests/mainline/bpf
# ./test_sysctl

[  132.090274] WARNING: CPU: 0 PID: 0 at
/usr/src/kernel/net/sched/sch_generic.c:320 dev_watchdog+0x2d0/0x2d8
[  132.107014] Modules linked in: iptable_filter ip_tables x_tables
algif_hash veth test_bpf hci_uart crc32_ce crct10dif_ce adv7511
bluetooth rfkill kirin_drm drm_kms_helper dw_drm_dsi drm fuse [last
unloaded: test_bpf]
[  132.134030] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.14.177-rc1 #1
[  132.148094] Hardware name: HiKey Development Board (DT)
[  132.161013] task: ffff000009499980 task.stack: ffff000009480000
[  132.174662] pc : dev_watchdog+0x2d0/0x2d8
[  132.186390] lr : dev_watchdog+0x2d0/0x2d8
[  132.198057] sp : ffff000008003d20 pstate : 20000145
[  132.210625] x29: ffff000008003d20 x28: 0000000000000002
[  132.223632] x27: 0000000000000001 x26: ffff8000750ec000
[  132.236678] x25: 00000000ffffffff x24: 0000000000000000
[  132.249753] x23: ffff00000948a000 x22: ffff8000750ec420
[  132.262783] x21: 0000000000000000 x20: ffff8000750ec000
[  132.275840] x19: ffff800075357e00 x18: 0000000000000004
[  132.288937] x17: 00000000000088b3 x16: 00000000000088b2
[  132.302062] x15: 00000000000088ae x14: ffff000009757078
[  132.315219] x13: ffff00000966f198 x12: 000000004b196e61
[  132.328416] x11: ffff00000949a1b8 x10: ffff00000a200000
[  132.341633] x9 : 0000000000000020 x8 : 0000000000000000
[  132.354886] x7 : ffff000008160a7c x6 : 0000000000000000
[  132.368153] x5 : 0000000000000001 x4 : 0000000000000000
[  132.381448] x3 : 0000000000000000 x2 : ffff000009493078
[  132.394700] x1 : ffff000009499980 x0 : 0000000000000038
[  132.407989] Call trace:
[  132.418312]  dev_watchdog+0x2d0/0x2d8
[  132.429841]  call_timer_fn+0xac/0x458
[  132.441396]  expire_timers+0x108/0x270
[  132.453093]  run_timer_softirq+0xbc/0x178
[  132.465099]  __do_softirq+0x12c/0x634
[  132.476762]  irq_exit+0xe0/0x128
[  132.487962]  __handle_domain_irq+0x6c/0xc0
[  132.500060]  gic_handle_irq+0x60/0xb0
[  132.511755]  el1_irq+0xb4/0x12c
[  132.522894]  cpuidle_enter_state+0xb4/0x428
[  132.535164]  cpuidle_enter+0x34/0x48
[  132.546747]  call_cpuidle+0x44/0x78
[  132.558281]  do_idle+0x1b4/0x1f8
[  132.569497]  cpu_startup_entry+0x2c/0x30
[  132.581484]  rest_init+0x25c/0x270
[  132.592926]  start_kernel+0x3c4/0x3d8
[  132.604596] ---[ end trace b4aeed8363f84bc2 ]---

$ git log --oneline net/sched/ | head
9f8b6c44be17 net_sched: keep alloc_hash updated after hash allocation
f0c92f59cf52 net_sched: cls_route: remove the right filter from hashtable
2165d304e82c net: fq: add missing attribute validation for orphan mask
7c9fbd9447bc net: sched: correct flower port blocking
3fdba7cb6f45 net/sched: flower: add missing validation of TCA_FLOWER_FLAGS
221a199d7c17 net/sched: matchall: add missing validation of TCA_MATCHALL_FLAGS
e79fbd72dca6 net_sched: fix a resource leak in tcindex_set_parms()
6cb448ee493c net_sched: fix an OOB access in cls_tcindex
44220931fc22 cls_rsvp: fix rsvp_policy
b4cdf5066ce2 net_sched: ematch: reject invalid TCF_EM_SIMPLE

ref:
https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/build/v4.14.176-200-gcebd79de8787/testrun/1388864/log
https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/build/v4.14.176-200-gcebd79de8787/testrun/1388864

kernel config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/hikey/lkft/linux-stable-rc-4.14/816/config

--
Linaro LKFT
https://lkft.linaro.org
