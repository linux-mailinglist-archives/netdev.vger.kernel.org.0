Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C84351F6D4
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 10:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbiEIINZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 04:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238893AbiEIIKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 04:10:02 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E61A164993
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 01:06:09 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id v59so23415302ybi.12
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 01:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=8h8s2UIhLbQhR3bj9oLDNqez2gEqdf+IITKyhyBMql4=;
        b=b0+zhXa7ZJNWEISpwG9560IoK3LYc0I+My9tUceVPE/60+CEBz/JTmlsG+JtoZx9gz
         4CCpUpzWuTF80kIWYyV2BSERfumCkoEF4ZC5F/HFyaVMKR9ZpnXYc1sUqNF45BIhUM9z
         mpNEE3oelttWMIte9ZrhJXD+mxnY5nQ1v8NnN/SPOPwvLt7bYF9G7+sUjzNpLVBQmen1
         HakGiBOy/fd9Hj2tONabiKlL4RNXhLZUawste12If8fiazvN1AuRK5Igj6ZssBw8wwI4
         DTqR+vjCUFL+tuv0dMQ+9A0VyvY4jYhUIL094HgxWAQhoSSMdF1kPS4Ew1hWPUh63o8z
         YPzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=8h8s2UIhLbQhR3bj9oLDNqez2gEqdf+IITKyhyBMql4=;
        b=NMOrVInTxQhnVPlWqz4GbGBWb7z0BlorqPEAxMWJuaJ+eoGT5RxY3l3qL/AUNphk70
         l2f6PNzVc3J8BkTdA/mgOZyoQRzupOT/lpWmCoikBCt/tukK+kuvqy5qRfH5OXgLHc3L
         sWbG5UMxHsr2Wn7A4kZDxU9BAk2oScZ7Mj2L/XG+3jehSh2fYZFKUZ+o0g44Q12PisT5
         ypX7vFI5DMLQiosF6UyeSnD7NRgXF4Nrqb3BoDlcjiCyTVWAZds8xf0fzmaMr7vf7YoM
         P2A0XXjtX8RfleBf13UnhzzxHb+LfYeydAH3AwR91+Z6hS+1i8DgSQ3uXD96AjQcv+k6
         GEyQ==
X-Gm-Message-State: AOAM533tPh8p6goH2dc/+hIdDss4Y8AjCjMcZYw0mIMAwe9rg693lsS0
        wjm5BqChjES4HB5N8mGl06VwdlHWGsknFHJNh09NXQ==
X-Google-Smtp-Source: ABdhPJxjytE5O9d4bcT9gA9hB1+1vuRTtKPtBka7d+eZRI8y9phYsp9a6K+W2e4rXIgiPiLGCPxiX9EbPdpPsWQm1f8=
X-Received: by 2002:a25:8045:0:b0:648:a9b3:96d0 with SMTP id
 a5-20020a258045000000b00648a9b396d0mr11637542ybn.88.1652083566237; Mon, 09
 May 2022 01:06:06 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 9 May 2022 13:35:54 +0530
Message-ID: <CA+G9fYuchz+ZsW4ReZK3nVvDc4wNz1avPQNdkNmO8x=Yc+Y9Vw@mail.gmail.com>
Subject: i386: selftests: net: bareudp.sh: Warning DEADLOCK lock(&(&stat->syncp)->seq#15);
To:     open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following kernel warning noticed while running selftests: net: bareudp.sh on
i386 running Linux 5.18.0-rc6 logs [1] and [2].

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

# selftests: net: bareudp.sh
[  635.997890] device eth1 left promiscuous mode
[  636.002374] br0: port 2(eth1) entered disabled state
[  636.011078] device eth0 left promiscuous mode
[  636.015527] br0: port 1(eth0) entered disabled state
[  636.235841] device eth1 left promiscuous mode
[  636.240316] br0: port 2(eth1) entered disabled state
[  636.254328] device eth0 left promiscuous mode
[  636.258799] br0: port 1(eth0) entered disabled state
[  636.389226] IPv6: ADDRCONF(NETDEV_CHANGE): veth01: link becomes ready
[  636.469276] IPv6: ADDRCONF(NETDEV_CHANGE): veth12: link becomes ready
[  636.531585] IPv6: ADDRCONF(NETDEV_CHANGE): veth23: link becomes ready
[  636.982172] mpls_gso: MPLS GSO support
[  637.184288]
[  637.185806] ================================
[  637.190078] WARNING: inconsistent lock state
[  637.194352] 5.18.0-rc6 #1 Not tainted
[  637.198024] --------------------------------
[  637.202296] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
[  637.208326] tc/17481 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  637.213198] fefaf3a4 (&(&stat->syncp)->seq#15){+.?.}-{0:0}, at:
tcf_stats_update+0x52/0x80 [act_mirred]
[  637.222601] {IN-SOFTIRQ-W} state was registered at:
[  637.227473]   lock_acquire+0xbd/0x2e0
[  637.231136]   tcf_mirred_act+0xf1/0x750 [act_mirred]
[  637.236095]   tcf_action_exec+0x7e/0x200
[  637.240019]   mall_classify+0x6c/0xe0 [cls_matchall]
[  637.244978]   __tcf_classify.constprop.0+0x52/0x150
[  637.249850]   tcf_classify+0x3c/0x60
[  637.253427]   __netif_receive_skb_core.constprop.0+0x6af/0x1170
[  637.259338]   __netif_receive_skb_one_core+0x34/0xa0
[  637.264295]   __netif_receive_skb+0x1d/0x70
[  637.268472]   process_backlog+0x77/0x240
[  637.272390]   __napi_poll.constprop.0+0x31/0x150
[  637.277001]   net_rx_action+0x11a/0x290
[  637.280839]   __do_softirq+0x14f/0x4ae
[  637.284583]   call_on_stack+0x4c/0x60
[  637.288242]   do_softirq_own_stack+0x2f/0x40
[  637.292506]   do_softirq+0xa5/0xd0
[  637.295932]   __local_bh_enable_ip+0xdb/0x100
[  637.300286]   ip_finish_output2+0x239/0xbe0
[  637.304464]   __ip_finish_output+0x14b/0x2a0
[  637.308728]   ip_finish_output+0x2a/0xd0
[  637.312646]   ip_output+0xf6/0x320
[  637.316041]   ip_send_skb+0x1f1/0x230
[  637.319700]   ip_push_pending_frames+0x33/0x50
[  637.324137]   raw_sendmsg+0xb45/0x1240
[  637.327892]   inet_sendmsg+0x6c/0x80
[  637.331469]   sock_sendmsg+0x6d/0x90
[  637.335047]   __sys_sendto+0xda/0x130
[  637.338705]   __ia32_sys_socketcall+0x35c/0x3c0
[  637.343230]   __do_fast_syscall_32+0x77/0xd0
[  637.347502]   do_fast_syscall_32+0x32/0x70
[  637.351591]   do_SYSENTER_32+0x15/0x20
[  637.355336]   entry_SYSENTER_32+0x98/0xf1
[  637.359339] irq event stamp: 11769
[  637.362739] hardirqs last  enabled at (11769): [<d2fd19df>]
call_rcu+0x26f/0x430
[  637.370130] hardirqs last disabled at (11768): [<d2fd19f5>]
call_rcu+0x285/0x430
[  637.377512] softirqs last  enabled at (11764): [<d3ca1d96>]
tc_setup_action.part.0+0x196/0x320
[  637.386110] softirqs last disabled at (11762): [<d3ca1c61>]
tc_setup_action.part.0+0x61/0x320
[  637.394622]
[  637.394622] other info that might help us debug this:
[  637.401138]  Possible unsafe locking scenario:
[  637.401138]
[  637.407047]        CPU0
[  637.409491]        ----
[  637.411935]   lock(&(&stat->syncp)->seq#15);
[  637.416199]   <Interrupt>
[  637.418816]     lock(&(&stat->syncp)->seq#15);
[  637.423256]
[  637.423256]  *** DEADLOCK ***
[  637.423256]
[  637.429164] 1 lock held by tc/17481:
[  637.432735]  #0: d498eb38 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock+0x14/0x20
[  637.439693]
[  637.439693] stack backtrace:
[  637.444045] CPU: 1 PID: 17481 Comm: tc Not tainted 5.18.0-rc6 #1
[  637.450041] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[  637.457512] Call Trace:
[  637.459959]  dump_stack_lvl+0x44/0x57
[  637.463623]  dump_stack+0xd/0x10
[  637.466847]  print_usage_bug.part.0+0x189/0x194
[  637.471379]  mark_lock.part.0.cold+0x4d/0x78
[  637.475643]  ? lock_release+0x1e1/0x2e0
[  637.479475]  __lock_acquire+0x321/0x2800
[  637.483399]  ? kernel_text_address+0xff/0x110
[  637.487752]  ? __kernel_text_address+0x10/0x40
[  637.492195]  ? __lock_acquire+0x33f/0x2800
[  637.496285]  ? __lock_acquire+0x33f/0x2800
[  637.500380]  ? __this_cpu_preempt_check+0xf/0x11
[  637.504996]  ? lock_is_held_type+0xb6/0x120
[  637.509176]  lock_acquire+0xbd/0x2e0
[  637.512752]  ? tcf_stats_update+0x52/0x80 [act_mirred]
[  637.517895]  ? __this_cpu_preempt_check+0xf/0x11
[  637.522509]  ? lock_is_held_type+0xb6/0x120
[  637.526687]  tcf_action_update_stats+0x87/0x320
[  637.531214]  ? tcf_stats_update+0x52/0x80 [act_mirred]
[  637.536354]  tcf_stats_update+0x52/0x80 [act_mirred]
[  637.541319]  ? tcf_mirred_get_fill_size+0x10/0x10 [act_mirred]
[  637.547150]  fl_hw_update_stats+0x15b/0x1c0 [cls_flower]
[  637.552468]  fl_dump+0x1d1/0x1f7 [cls_flower]
[  637.556832]  ? fl_tmplt_dump+0xb0/0xb0 [cls_flower]
[  637.561709]  tcf_fill_node+0x16a/0x220
[  637.565452]  ? fl_tmplt_dump+0xb0/0xb0 [cls_flower]
[  637.570325]  tfilter_notify+0x9e/0x110
[  637.574078]  tc_new_tfilter+0x50e/0xd60
[  637.577936]  ? tc_del_tfilter+0x930/0x930
[  637.581946]  rtnetlink_rcv_msg+0x409/0x520
[  637.586045]  ? rtnetlink_rcv_msg+0x69/0x520
[  637.590232]  ? __this_cpu_preempt_check+0xf/0x11
[  637.594848]  ? lock_release+0x12a/0x2e0
[  637.598681]  ? lock_is_held_type+0xb6/0x120
[  637.602894]  ? netlink_deliver_tap+0x130/0x490
[  637.607355]  ? rtnl_fdb_dump+0x420/0x420
[  637.611273]  netlink_rcv_skb+0x78/0xe0
[  637.615017]  ? netlink_deliver_tap+0x5/0x490
[  637.619290]  rtnetlink_rcv+0x12/0x20
[  637.622874]  netlink_unicast+0x185/0x290
[  637.626796]  netlink_sendmsg+0x21f/0x4b0
[  637.630723]  ? netlink_unicast+0x290/0x290
[  637.634818]  sock_sendmsg+0x75/0x90
[  637.638304]  ____sys_sendmsg+0x1ea/0x240
[  637.642230]  ? import_iovec+0x28/0x30
[  637.645899]  ___sys_sendmsg+0xa8/0xe0
[  637.649563]  ? __this_cpu_preempt_check+0xf/0x11
[  637.654179]  ? __this_cpu_preempt_check+0xf/0x11
[  637.658791]  ? lock_is_held_type+0xb6/0x120
[  637.662978]  ? __this_cpu_preempt_check+0xf/0x11
[  637.667596]  ? lock_is_held_type+0xb6/0x120
[  637.671781]  ? __fdget+0x12/0x20
[  637.675015]  __sys_sendmsg+0x50/0x90
[  637.678586]  __ia32_sys_socketcall+0x39f/0x3c0
[  637.683032]  __do_fast_syscall_32+0x77/0xd0
[  637.687217]  ? __this_cpu_preempt_check+0xf/0x11
[  637.691836]  ? lock_is_held_type+0xb6/0x120
[  637.696021]  ? do_int80_syscall_32+0x59/0x70
[  637.700283]  ? __this_cpu_preempt_check+0xf/0x11
[  637.704898]  ? lockdep_hardirqs_on+0x87/0x120
[  637.709271]  ? lockdep_hardirqs_on_prepare+0xda/0x1f0
[  637.714315]  ? syscall_exit_to_user_mode+0x38/0x50
[  637.719100]  ? do_int80_syscall_32+0x59/0x70
[  637.723364]  ? lockdep_hardirqs_on+0x87/0x120
[  637.727724]  ? lockdep_hardirqs_on_prepare+0xda/0x1f0
[  637.732776]  ? irqentry_exit_to_user_mode+0x26/0x30
[  637.737656]  do_fast_syscall_32+0x32/0x70
[  637.741669]  do_SYSENTER_32+0x15/0x20
[  637.745333]  entry_SYSENTER_32+0x98/0xf1
[  637.749251] EIP: 0xb7fb4549
[  637.752040] Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01
10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f
34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90
8d 76
[  637.770776] EAX: ffffffda EBX: 00000010 ECX: bfe416b4 EDX: 00000000
[  637.777035] ESI: 00000000 EDI: 080e5840 EBP: 00000010 ESP: bfe416a0
[  637.783292] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000282
# TEST: IPv4 packets over UDPv4


metadata:
  git_ref: master
  git_repo: https://gitlab.com/Linaro/lkft/mirrors/torvalds/linux-mainline
  git_sha: c5eb0a61238dd6faf37f58c9ce61c9980aaffd7a
  git_describe: v5.18-rc6
  kernel_version: 5.18.0-rc6
  kernel-config: https://builds.tuxbuild.com/28toZBX67g0hle8cic5YCYCkXyy/config
  build-url: https://gitlab.com/Linaro/lkft/mirrors/torvalds/linux-mainline/-/pipelines/534026340
  artifact-location: https://builds.tuxbuild.com/28toZBX67g0hle8cic5YCYCkXyy
  toolchain: gcc-11


Full test log links,

[1] https://lkft.validation.linaro.org/scheduler/job/4998250#L6279
[2] https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v5.18-rc6/testrun/9390418/suite/linux-log-parser/test/check-kernel-warning-4998250/log


--
Linaro LKFT
https://lkft.linaro.org
