Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5611AEA65
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 09:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbgDRHCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 03:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgDRHCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 03:02:53 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A7AC061A10
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 00:02:53 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id z90so3996922qtd.10
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 00:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TjXmWmuINQagYGOhB0mh8AmFnIMZ72LlgvA/kNKwdwQ=;
        b=eneHelWvQA1o2xZd7COnbAkMg2VijPrSKWln3C1KPWsKzKaxkBchi9lH3mm6z0mchu
         bs0JjsONZdn1EW5Pa5rkEnyVwrcm1Xes/rbgpL6bD1OKq7M9E+4rryt6Zw8Vo7c14dm/
         85kHXX1ylyxSOjBeELkVJa1w6RhDAf58NGAoh0pMlB6JwQWsGpHv7xZfT3vsG5wcU8PO
         PO4Rx84G3YCeWDVr81SGT2C0srVpxwfHmc3kp1owb9mgCLLBYC0Y6VOoawwzTCKp4JmH
         iZL2vDgA7Ta2F2bdfEt3J5CsDJ+Hco3D3DWELetZrFN+Ldj5y5ib+FWK5fd+pxaSWQJg
         ew1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TjXmWmuINQagYGOhB0mh8AmFnIMZ72LlgvA/kNKwdwQ=;
        b=IU9cWAhxRBXOP9fLOm8FS62zMP84v9U/ubOS4beHaRsfZ1UhgQVqQLk/Vt7/FeE+UB
         qjeqMiWzYF7uqLzAKzzSDs9Jl1NSVgdpd3bHMgQAtFluRye78TmHg0PdwAEsdegLy72S
         J7UX7ZED4QAyBOccIcVIq9kdt7//ijWvcy0dTBeSqyJn0NLS4OUn6BURrV0WhLXbY/qF
         t0AX5fZJOim3rpvAQp3n3+mssV2Gjvv2iKrXD+u187HUGK15JdEXXSRYnoTjmMheHnFL
         shWvZK+2KT16wYCniELry9FQEeKK2JPZGCnIWq9vSF+2nAO4gBF972LhrmJSzc+aRt8V
         azPw==
X-Gm-Message-State: AGi0PuZYyR5LiYXrG+to2/ZenfiYAh3CUu4zdz/75+ca0LBccatwCahM
        51R+iepS1EVzUoFb+i06jaPJZxK9l+Ns4nyzwO7ZvA==
X-Google-Smtp-Source: APiQypLsCDn+7Nx+XS+vfQdJLSgMyJ6cAip9eoqxwKIcZG7bcNNfpWA3QWLCOsdYajOXxXkuacs3h/Laq/BJ+KxyQO4=
X-Received: by 2002:ac8:1b6a:: with SMTP id p39mr6720360qtk.158.1587193372377;
 Sat, 18 Apr 2020 00:02:52 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000e642a905a0cbee6e@google.com>
In-Reply-To: <000000000000e642a905a0cbee6e@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sat, 18 Apr 2020 09:02:41 +0200
Message-ID: <CACT4Y+YR5Y8OQ4MCdCA2eoQM=GdBXN39O4HahWtL0sdqwsB=mg@mail.gmail.com>
Subject: Re: linux-next test error: WARNING: suspicious RCU usage in ovs_ct_exit
To:     syzbot <syzbot+7ef50afd3a211f879112@syzkaller.appspotmail.com>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>, dev@openvswitch.org,
        kuba@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 14, 2020 at 8:57 AM syzbot
<syzbot+7ef50afd3a211f879112@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    2e602db7 Add linux-next specific files for 20200313
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=16669919e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cf2879fc1055b886
> dashboard link: https://syzkaller.appspot.com/bug?extid=7ef50afd3a211f879112
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+7ef50afd3a211f879112@syzkaller.appspotmail.com

+linux-next, Stephen for currently open linux-next build/boot failure

> =============================
> WARNING: suspicious RCU usage
> 5.6.0-rc5-next-20200313-syzkaller #0 Not tainted
> -----------------------------
> net/openvswitch/conntrack.c:1898 RCU-list traversed in non-reader section!!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active = 2, debug_locks = 1
> 3 locks held by kworker/u4:3/127:
>  #0: ffff8880a9771d28 ((wq_completion)netns){+.+.}, at: __write_once_size include/linux/compiler.h:250 [inline]
>  #0: ffff8880a9771d28 ((wq_completion)netns){+.+.}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff8880a9771d28 ((wq_completion)netns){+.+.}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff8880a9771d28 ((wq_completion)netns){+.+.}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff8880a9771d28 ((wq_completion)netns){+.+.}, at: set_work_data kernel/workqueue.c:615 [inline]
>  #0: ffff8880a9771d28 ((wq_completion)netns){+.+.}, at: set_work_pool_and_clear_pending kernel/workqueue.c:642 [inline]
>  #0: ffff8880a9771d28 ((wq_completion)netns){+.+.}, at: process_one_work+0x82a/0x1690 kernel/workqueue.c:2237
>  #1: ffffc900013a7dd0 (net_cleanup_work){+.+.}, at: process_one_work+0x85e/0x1690 kernel/workqueue.c:2241
>  #2: ffffffff8a54df08 (pernet_ops_rwsem){++++}, at: cleanup_net+0x9b/0xa50 net/core/net_namespace.c:551
>
> stack backtrace:
> CPU: 0 PID: 127 Comm: kworker/u4:3 Not tainted 5.6.0-rc5-next-20200313-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: netns cleanup_net
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x188/0x20d lib/dump_stack.c:118
>  ovs_ct_limit_exit net/openvswitch/conntrack.c:1898 [inline]
>  ovs_ct_exit+0x3db/0x558 net/openvswitch/conntrack.c:2295
>  ovs_exit_net+0x1df/0xba0 net/openvswitch/datapath.c:2469
>  ops_exit_list.isra.0+0xa8/0x150 net/core/net_namespace.c:172
>  cleanup_net+0x511/0xa50 net/core/net_namespace.c:589
>  process_one_work+0x94b/0x1690 kernel/workqueue.c:2266
>  worker_thread+0x96/0xe20 kernel/workqueue.c:2412
>  kthread+0x357/0x430 kernel/kthread.c:255
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> tipc: TX() has been purged, node left!
>
> =============================
> WARNING: suspicious RCU usage
> 5.6.0-rc5-next-20200313-syzkaller #0 Not tainted
> -----------------------------
> net/ipv4/ipmr.c:1757 RCU-list traversed in non-reader section!!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active = 2, debug_locks = 1
> 4 locks held by kworker/u4:3/127:
>  #0: ffff8880a9771d28 ((wq_completion)netns){+.+.}, at: __write_once_size include/linux/compiler.h:250 [inline]
>  #0: ffff8880a9771d28 ((wq_completion)netns){+.+.}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff8880a9771d28 ((wq_completion)netns){+.+.}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff8880a9771d28 ((wq_completion)netns){+.+.}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff8880a9771d28 ((wq_completion)netns){+.+.}, at: set_work_data kernel/workqueue.c:615 [inline]
>  #0: ffff8880a9771d28 ((wq_completion)netns){+.+.}, at: set_work_pool_and_clear_pending kernel/workqueue.c:642 [inline]
>  #0: ffff8880a9771d28 ((wq_completion)netns){+.+.}, at: process_one_work+0x82a/0x1690 kernel/workqueue.c:2237
>  #1: ffffc900013a7dd0 (net_cleanup_work){+.+.}, at: process_one_work+0x85e/0x1690 kernel/workqueue.c:2241
>  #2: ffffffff8a54df08 (pernet_ops_rwsem){++++}, at: cleanup_net+0x9b/0xa50 net/core/net_namespace.c:551
>  #3: ffffffff8a559c80 (rtnl_mutex){+.+.}, at: ip6gre_exit_batch_net+0x88/0x700 net/ipv6/ip6_gre.c:1602
>
> stack backtrace:
> CPU: 1 PID: 127 Comm: kworker/u4:3 Not tainted 5.6.0-rc5-next-20200313-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: netns cleanup_net
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x188/0x20d lib/dump_stack.c:118
>  ipmr_device_event+0x240/0x2b0 net/ipv4/ipmr.c:1757
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  rollback_registered_many+0x75c/0xe70 net/core/dev.c:8810
>  unregister_netdevice_many.part.0+0x16/0x1e0 net/core/dev.c:9966
>  unregister_netdevice_many+0x36/0x50 net/core/dev.c:9965
>  ip6gre_exit_batch_net+0x4e8/0x700 net/ipv6/ip6_gre.c:1605
>  ops_exit_list.isra.0+0x103/0x150 net/core/net_namespace.c:175
>  cleanup_net+0x511/0xa50 net/core/net_namespace.c:589
>  process_one_work+0x94b/0x1690 kernel/workqueue.c:2266
>  worker_thread+0x96/0xe20 kernel/workqueue.c:2412
>  kthread+0x357/0x430 kernel/kthread.c:255
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000e642a905a0cbee6e%40google.com.
