Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BADD3263ACD
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbgIJCqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730826AbgIJCne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 22:43:34 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28E9C061796;
        Wed,  9 Sep 2020 19:43:31 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id g4so4762123edk.0;
        Wed, 09 Sep 2020 19:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=J93ysr1OoLquUDL10I/+5RMxNpMBU1diucXslF/gGA8=;
        b=IUYytGTRcxBH2IwUQoGPkXLhp/CbhE68StB0i1GNg6vWsySVze/rfl9t5UDbWhsUn8
         TnEyihoFTGlBb3X/n1BccZ7WYuk56B3ddpQXJ0uoHG+VuvoMgOH8E0JYG/CG44uINZis
         jdNZPGk4GoQayWiqobptkkLdyx0IIBMPHUqxCn8pmFxm9IzI6OzIhxajLKeDtKNL8BrY
         dCfS1ydXv7jbI+rGY7dvnN6B02UGY8xmdVLpn5kOnrnwYLC/PBAbSHWQ7mSJhWQrk5uw
         9qFXdq9ICqvsmzswYUjLejBhCusAoMsYMqf9841vjATu9zJCIbUikcymO7JngvJneuG7
         LkRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=J93ysr1OoLquUDL10I/+5RMxNpMBU1diucXslF/gGA8=;
        b=grdtEujg/Um6Pxmii7hKU3GccM3XsC7ODIhJewjxtCcG0uTF456x9F++drAxWnNa3f
         93rD2G3BMAoZpnf1QRx2cTj5MZHy2ynA/fjWgvH9WMD3z1TDDIB2ALbafjWGY4FGNWj/
         Gcc9vOdMjNj5Ea+C2vUEzOLCsaEidj8AgeEZqKEePdVPBvgUBCth2PP2YAuiwWFOO28Z
         ajH+AgECqLoF1Wy2ovkucLXdWnZg6Uq+MQIlCR/sLHqHHKILy4BEEzHwvZxyA7QjlpwJ
         cZrQqt3Ed/2hGMErUa6QnrvHssHDA2zLpv7GWv+ttgX+km7in9JiHk5yBRah9kJaFkYu
         jieA==
X-Gm-Message-State: AOAM5308q7rLuG+GLXsKpggDAyB0BpPfblk47WdykBPsT9ad+n1OK1mY
        nREzA7JBJAqpt0SUKBUKWaocVq3GrFcunjfz7Iw=
X-Google-Smtp-Source: ABdhPJyOtT99TUEyAgGdR1uzoxtj+dRH9RxGnLW5YzTxtlPfWLxFm+l0A2hX++cGDM1N/9llbAwwRxUoWM5RlHsZ6OI=
X-Received: by 2002:a05:6402:1694:: with SMTP id a20mr6989802edv.286.1599705810338;
 Wed, 09 Sep 2020 19:43:30 -0700 (PDT)
MIME-Version: 1.0
References: <110eaa273bf313fb1a2a668a446956d27aba05a8.1599532593.git.geliangtang@gmail.com>
 <20200910001827.GS31308@shao2-debian>
In-Reply-To: <20200910001827.GS31308@shao2-debian>
From:   Geliang Tang <geliangtang@gmail.com>
Date:   Thu, 10 Sep 2020 10:43:18 +0800
Message-ID: <CA+WQbwtsBFcHrC_2Nd7uj2a3c4cthFTEAmAho-Roz7PW__fp=g@mail.gmail.com>
Subject: Re: [mptcp] db71a2f198: WARNING:inconsistent_lock_state
To:     kernel test robot <lkp@intel.com>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Peter Krystad <peter.krystad@linux.intel.com>,
        netdev@vger.kernel.org, mptcp <mptcp@lists.01.org>,
        "To: Phillip Lougher <phillip@squashfs.org.uk>, Andrew Morton
        <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Coly Li
        <colyli@suse.de>, linux-fsdevel@vger.kernel.org," 
        <linux-kernel@vger.kernel.org>, lkp@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel test robot <lkp@intel.com> =E4=BA=8E2020=E5=B9=B49=E6=9C=8810=E6=97=
=A5=E5=91=A8=E5=9B=9B =E4=B8=8A=E5=8D=888:19=E5=86=99=E9=81=93=EF=BC=9A
>
> Greeting,
>
> FYI, we noticed the following commit (built with gcc-9):
>
> commit: db71a2f198fef53a9f710ad5ac475bbdb6aba840 ("[MPTCP][PATCH v2 net 1=
/2] mptcp: fix subflow's local_id issues")
> url: https://github.com/0day-ci/linux/commits/Geliang-Tang/mptcp-fix-subf=
low-s-local_id-remote_id-issues/20200908-105733
> base: https://git.kernel.org/cgit/linux/kernel/git/davem/net.git e1f469cd=
5866499ac40bfdca87411e1c525a10c7
>
> in testcase: kernel-selftests
> version: kernel-selftests-x86_64-e8e8f16e-1_20200807
> with following parameters:
>
>         group: kselftests-mptcp
>
> test-description: The kernel contains a set of "self tests" under the too=
ls/testing/selftests/ directory. These are intended to be small unit tests =
to exercise individual code paths in the kernel.
> test-url: https://www.kernel.org/doc/Documentation/kselftest.txt
>
>
> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -=
m 8G
>
> caused below changes (please refer to attached dmesg/kmsg for entire log/=
backtrace):
>
>
> +------------------------------------------------------------------------=
----+------------+------------+
> |                                                                        =
    | e1f469cd58 | db71a2f198 |
> +------------------------------------------------------------------------=
----+------------+------------+
> | boot_successes                                                         =
    | 15         | 8          |
> | boot_failures                                                          =
    | 2          | 9          |
> | Kernel_panic-not_syncing:VFS:Unable_to_mount_root_fs_on_unknown-block(#=
,#) | 2          |            |
> | WARNING:inconsistent_lock_state                                        =
    | 0          | 9          |
> | inconsistent{SOFTIRQ-ON-W}->{IN-SOFTIRQ-W}usage                        =
    | 0          | 9          |
> | calltrace:asm_call_on_stack                                            =
    | 0          | 9          |
> | BUG:sleeping_function_called_from_invalid_context_at_mm/slab.h         =
    | 0          | 9          |
> +------------------------------------------------------------------------=
----+------------+------------+
>
>
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <lkp@intel.com>
>
>
> [  257.607162] WARNING: inconsistent lock state
> [  257.609399] 5.9.0-rc3-00371-gdb71a2f198fef #1 Not tainted
> [  257.611927] --------------------------------
> [  257.614273] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> [  257.617486] kworker/1:2/101 [HC0[0]:SC1[3]:HE1:SE0] takes:
> [  257.620140] ffffffffae1aaa40 (fs_reclaim){+.?.}-{0:0}, at: fs_reclaim_=
acquire+0x5/0x40
> [  257.623680] {SOFTIRQ-ON-W} state was registered at:
> [  257.626250]   lock_acquire+0xaf/0x380
> [  257.628516]   fs_reclaim_acquire+0x25/0x40
> [  257.631071]   __kmalloc_node+0x60/0x560
> [  257.633350]   alloc_cpumask_var_node+0x1b/0x40
> [  257.635850]   native_smp_prepare_cpus+0xad/0x292
> [  257.638255]   kernel_init_freeable+0x15a/0x2dd
> [  257.640847]   kernel_init+0xa/0x122
> [  257.643277]   ret_from_fork+0x22/0x30
> [  257.645510] irq event stamp: 89762
> [  257.647888] hardirqs last  enabled at (89762): [<ffffffffacf08ef0>] pr=
ocess_backlog+0x1b0/0x260
> [  257.651614] hardirqs last disabled at (89761): [<ffffffffacf08f75>] pr=
ocess_backlog+0x235/0x260
> [  257.655368] softirqs last  enabled at (89756): [<ffffffffacfb8598>] ip=
_finish_output2+0x258/0xa20
> [  257.659186] softirqs last disabled at (89757): [<ffffffffad2010d2>] as=
m_call_on_stack+0x12/0x20
> [  257.663053]
> [  257.663053] other info that might help us debug this:
> [  257.667675]  Possible unsafe locking scenario:
> [  257.667675]
> [  257.672233]        CPU0
> [  257.674229]        ----
> [  257.676375]   lock(fs_reclaim);
> [  257.678563]   <Interrupt>
> [  257.680618]     lock(fs_reclaim);
> [  257.682673]
> [  257.682673]  *** DEADLOCK ***
> [  257.682673]
> [  257.687974] 8 locks held by kworker/1:2/101:
> [  257.690177]  #0: ffffa060c7c56938 ((wq_completion)events){+.+.}-{0:0},=
 at: process_one_work+0x1bc/0x5a0
> [  257.693771]  #1: ffffc2fac0197e58 ((work_completion)(&msk->work)){+.+.=
}-{0:0}, at: process_one_work+0x1bc/0x5a0
> [  257.697437]  #2: ffffa060dd8258e0 (sk_lock-AF_INET){+.+.}-{0:0}, at: m=
ptcp_worker+0x5f/0xac0
> [  257.700972]  #3: ffffa061247e2e20 (k-sk_lock-AF_INET){+.+.}-{0:0}, at:=
 inet_stream_connect+0x23/0x60
> [  257.704558]  #4: ffffffffae0c9a40 (rcu_read_lock){....}-{1:2}, at: __i=
p_queue_xmit+0x5/0x600
> [  257.707957]  #5: ffffffffae0c9a40 (rcu_read_lock){....}-{1:2}, at: pro=
cess_backlog+0x75/0x260
> [  257.711431]  #6: ffffffffae0c9a40 (rcu_read_lock){....}-{1:2}, at: ip_=
local_deliver_finish+0x2c/0x120
> [  257.714689]  #7: ffffffffae0c9a40 (rcu_read_lock){....}-{1:2}, at: tcp=
_rcv_state_process+0x17f/0x981
> [  257.718220]
> [  257.718220] stack backtrace:
> [  257.722396] CPU: 1 PID: 101 Comm: kworker/1:2 Not tainted 5.9.0-rc3-00=
371-gdb71a2f198fef #1
> [  257.726013] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S 1.12.0-1 04/01/2014
> [  257.729513] Workqueue: events mptcp_worker
> [  257.732037] Call Trace:
> [  257.734092]  <IRQ>
> [  257.736155]  dump_stack+0x8d/0xc0
> [  257.738400]  mark_lock+0x633/0x7c0
> [  257.740652]  ? print_shortest_lock_dependencies+0x40/0x40
> [  257.743499]  __lock_acquire+0x954/0xaa0
> [  257.745907]  lock_acquire+0xaf/0x380
> [  257.748288]  ? fs_reclaim_acquire+0x5/0x40
> [  257.750889]  ? mptcp_pm_nl_get_local_id+0x232/0x400
> [  257.753356]  fs_reclaim_acquire+0x25/0x40
> [  257.755986]  ? fs_reclaim_acquire+0x5/0x40
> [  257.758562]  kmem_cache_alloc_trace+0x40/0x460
> [  257.761092]  mptcp_pm_nl_get_local_id+0x232/0x400
> [  257.763793]  subflow_init_req+0x1c2/0x3a0
> [  257.766127]  ? inet_reqsk_alloc+0x21/0x140
> [  257.768560]  ? rcu_read_lock_sched_held+0x52/0xa0
> [  257.771236]  ? kmem_cache_alloc+0x3b8/0x460
> [  257.773656]  tcp_conn_request+0x341/0xe60
> [  257.776117]  ? lock_acquire+0xaf/0x380
> [  257.778486]  ? tcp_rcv_state_process+0x17f/0x981
> [  257.781114]  ? tcp_rcv_state_process+0x1e2/0x981
> [  257.783833]  tcp_rcv_state_process+0x1e2/0x981
> [  257.786417]  ? tcp_v4_inbound_md5_hash+0x4c/0x160
> [  257.789117]  tcp_v4_do_rcv+0xb8/0x200
> [  257.791562]  tcp_v4_rcv+0xf94/0x1080
> [  257.793835]  ip_protocol_deliver_rcu+0x2d/0x2a0
> [  257.796463]  ip_local_deliver_finish+0x8c/0x120
> [  257.799035]  ip_local_deliver+0x71/0x220
> [  257.801471]  ? rcu_read_lock_held+0x52/0x60
> [  257.803973]  ip_rcv+0x57/0x200
> [  257.806218]  ? process_backlog+0x75/0x260
> [  257.808714]  __netif_receive_skb_one_core+0x87/0xa0
> [  257.811476]  process_backlog+0xe7/0x260
> [  257.814050]  net_rx_action+0x166/0x480
> [  257.816877]  __do_softirq+0xea/0x4eb
> [  257.819171]  asm_call_on_stack+0x12/0x20
> [  257.821573]  </IRQ>
> [  257.823513]  ? ip_finish_output2+0x258/0xa20
> [  257.825923]  do_softirq_own_stack+0x78/0xa0
> [  257.828215]  do_softirq+0x52/0xa0
> [  257.830335]  __local_bh_enable_ip+0xde/0x100
> [  257.832834]  ip_finish_output2+0x27c/0xa20
> [  257.835155]  ? rcu_read_lock_held+0x52/0x60
> [  257.837334]  ? ip_output+0x7f/0x280
> [  257.839546]  ip_output+0x7f/0x280
> [  257.841650]  __ip_queue_xmit+0x1df/0x600
> [  257.844052]  __tcp_transmit_skb+0xa17/0xc80
> [  257.846277]  tcp_connect+0x4fe/0x600
> [  257.848421]  tcp_v4_connect+0x44e/0x560
> [  257.850615]  __inet_stream_connect+0xc5/0x360
> [  257.853019]  ? __local_bh_enable_ip+0x81/0x100
> [  257.855302]  inet_stream_connect+0x37/0x60
> [  257.857569]  __mptcp_subflow_connect+0x195/0x228
> [  257.860107]  mptcp_pm_create_subflow_or_signal_addr+0x27d/0x5a0
> [  257.862786]  mptcp_worker+0x5e4/0xac0
>
>
> To reproduce:
>
>         # build kernel
>         cd linux
>         cp config-5.9.0-rc3-00371-gdb71a2f198fef .config
>         make HOSTCC=3Dgcc-9 CC=3Dgcc-9 ARCH=3Dx86_64 olddefconfig prepare=
 modules_prepare bzImage
>
>         git clone https://github.com/intel/lkp-tests.git
>         cd lkp-tests
>         bin/lkp qemu -k <bzImage> job-script # job-script is attached in =
this email
>

Hi,

I had sent out a patch yesterday named "mptcp: fix kmalloc flag in
mptcp_pm_nl_get_local_id", which can fix this issue.

Thanks.
-Geliang

>
>
> Thanks,
> lkp
>
