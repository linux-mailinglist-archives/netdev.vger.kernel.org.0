Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF2723E45D
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 01:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgHFX2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 19:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgHFX23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 19:28:29 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E694C061574;
        Thu,  6 Aug 2020 16:28:29 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id p1so174554pls.4;
        Thu, 06 Aug 2020 16:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CpDCB8YxQwPLWIF3xEIJdkJW9LJsXXYQOGG+IhMlCYM=;
        b=HogmGCIN6bljTOM/CyRvXsU6H0pek9KxOmJNz9dV2SAHG9UnIaNmqdse/487iLO2gZ
         oBPltWUueVz43ZPSrdsmHB/ik8A4xjpleKiLhJW5PI4DFOQLEcqLkkL1qEmGt3ve/cZz
         lzm5bELzR7oMuQ+t5R+R5eyD5xTZTQg14CCpEgGLsYHD+bKdaBIeDICRIngQiunQK3f2
         YBPA5tX5GsEN/4dB99Wifpk1BR1gEFBUf0JJAOivzmj7AkL+p7lfjaNrghQDr6o9C5/s
         xMTvlfhaQPAUQJlW14WFf9CnUTjXkKuKX5NYKfdpPS8EQOzbWPKGltOqc4/jPQ1P/wTp
         9cDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CpDCB8YxQwPLWIF3xEIJdkJW9LJsXXYQOGG+IhMlCYM=;
        b=mGp0F7sNnuC2TAchEWWrHNOJAWpbvRAjkIq3viFMOvy+J/Tnk8hOATPsRTGKSqoCnH
         K1FEYvG4ruYnj5HYOEdDB6XXk4gZyHNeV1z2qUM4edax9XQCIFBJ5hGKkMF7LUjLsKvv
         8sa2faK0vNX267WiQXor0s+io4VNmQv8cebJO+/kLKixbxSQMQip3WLZghaLIyk2OFo4
         3pSlAXaxxixeEtTO14pT4t3tm76pH3weqzqRkIqpvhRWvhh1++UR9D8RMvK/ZJ/2mvWL
         jyT0U8YgUxULcxPK0kt3Ldr0eus0oxyJT4lRqDys5oIvTh8W0fat93eJH6qajg2L1Jdh
         bbag==
X-Gm-Message-State: AOAM530tvQojePBX8Ok2fIkG6u7bgHd+Nk0GlPZ9mTwCSBN52XirP6Hp
        pnQC+toKKPKKWBLth+Y+V6acBrig
X-Google-Smtp-Source: ABdhPJyHhLzkeH+orW1TTL7Gxf+rpUGVgIhcBXAxWFJOQuHBFWCkqa478pgdPnXesN5KziCTyDe7mQ==
X-Received: by 2002:a17:902:6b43:: with SMTP id g3mr9361192plt.319.1596756508599;
        Thu, 06 Aug 2020 16:28:28 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id l17sm10564085pff.126.2020.08.06.16.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 16:28:27 -0700 (PDT)
Subject: Re: [GIT] Networking
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     John Stultz <john.stultz@linaro.org>,
        David Miller <davem@davemloft.net>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Todd Kjos <tkjos@google.com>,
        Amit Pundir <amit.pundir@linaro.org>
References: <20200805.185559.1225246192723680518.davem@davemloft.net>
 <CANcMJZA1pSz8T9gkRtwYHy_vVfoMj35Wd-+qqxQBg+GRaXS0_Q@mail.gmail.com>
 <011a0a3b-74ac-fa61-2a04-73cb9897e8e8@gmail.com>
Message-ID: <9ae3f033-1634-3dc0-234f-0938dd840def@gmail.com>
Date:   Thu, 6 Aug 2020 16:28:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <011a0a3b-74ac-fa61-2a04-73cb9897e8e8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/6/20 4:17 PM, Eric Dumazet wrote:
> 
> 
> On 8/6/20 2:39 PM, John Stultz wrote:
>> On Wed, Aug 5, 2020 at 6:57 PM David Miller <davem@davemloft.net> wrote:
>>> There is a minor conflict in net/ipv6/ip6_flowlabel.c, it's because of
>>> the commit that did the tree-wide removal of uninitialized_var().  The
>>> resolution is simple, kill all of the conflict markers and content
>>> within, and remove the uninitialized_var() marker that got moved
>>> elsewhere in the file in the net-next tree.
>>>
>>> Otherwise, we have:
>>>
>>> 1) Support 6Ghz band in ath11k driver, from Rajkumar Manoharan.
>>>
>>> 2) Support UDP segmentation in code TSO code, from Eric Dumazet.
>>>
>>> 3) Allow flashing different flash images in cxgb4 driver, from Vishal
>>>    Kulkarni.
>>>
>>> 4) Add drop frames counter and flow status to tc flower offloading,
>>>    from Po Liu.
>>>
>>> 5) Support n-tuple filters in cxgb4, from Vishal Kulkarni.
>>>
>>> 6) Various new indirect call avoidance, from Eric Dumazet and Brian
>>>    Vazquez.
>>>
>>> 7) Fix BPF verifier failures on 32-bit pointer arithmetic, from
>>>    Yonghong Song.
>>>
>>> 8) Support querying and setting hardware address of a port function
>>>    via devlink, use this in mlx5, from Parav Pandit.
>>>
>>> 9) Support hw ipsec offload on bonding slaves, from Jarod Wilson.
>>>
>>> 10) Switch qca8k driver over to phylink, from Jonathan McDowell.
>>>
>>> 11) In bpftool, show list of processes holding BPF FD references to
>>>     maps, programs, links, and btf objects.  From Andrii Nakryiko.
>>>
>>> 12) Several conversions over to generic power management, from Vaibhav
>>>     Gupta.
>>>
>>> 13) Add support for SO_KEEPALIVE et al. to bpf_setsockopt(), from
>>>     Dmitry Yakunin.
>>>
>>> 14) Various https url conversions, from Alexander A. Klimov.
>>>
>>> 15) Timestamping and PHC support for mscc PHY driver, from Antoine
>>>     Tenart.
>>>
>>> 16) Support bpf iterating over tcp and udp sockets, from Yonghong
>>>     Song.
>>>
>>> 17) Support 5GBASE-T i40e NICs, from Aleksandr Loktionov.
>>>
>>> 18) Add kTLS RX HW offload support to mlx5e, from Tariq Toukan.
>>>
>>> 19) Fix the ->ndo_start_xmit() return type to be netdev_tx_t in several
>>>     drivers.  From Luc Van Oostenryck.
>>>
>>> 20) XDP support for xen-netfront, from Denis Kirjanov.
>>>
>>> 21) Support receive buffer autotuning in MPTCP, from Florian Westphal.
>>>
>>> 22) Support EF100 chip in sfc driver, from Edward Cree.
>>>
>>> 23) Add XDP support to mvpp2 driver, from Matteo Croce.
>>>
>>> 24) Support MPTCP in sock_diag, from Paolo Abeni.
>>>
>>> 25) Commonize UDP tunnel offloading code by creating udp_tunnel_nic
>>>     infrastructure, from Jakub Kicinski.
>>>
>>> 26) Several pci_ --> dma_ API conversions, from Christophe JAILLET.
>>>
>>> 27) Add FLOW_ACTION_POLICE support to mlxsw, from Ido Schimmel.
>>>
>>> 28) Add SK_LOOKUP bpf program type, from Jakub Sitnicki.
>>>
>>> 29) Refactor a lot of networking socket option handling code in
>>>     order to avoid set_fs() calls, from Christoph Hellwig.
>>>
>>> 30) Add rfc4884 support to icmp code, from Willem de Bruijn.
>>>
>>> 31) Support TBF offload in dpaa2-eth driver, from Ioana Ciornei.
>>>
>>> 32) Support XDP_REDIRECT in qede driver, from Alexander Lobakin.
>>>
>>> 33) Support PCI relaxed ordering in mlx5 driver, from Aya Levin.
>>>
>>> 34) Support TCP syncookies in MPTCP, from Flowian Westphal.
>>>
>>> 35) Fix several tricky cases of PMTU handling wrt. briding, from
>>>     Stefano Brivio.
>>>
>>> Please pull, thanks a lot!
>>>
>>> The following changes since commit ac3a0c8472969a03c0496ae774b3a29eb26c8d5a:
>>>
>>>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-08-01 16:47:24 -0700)
>>>
>>> are available in the Git repository at:
>>>
>>>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
>>
>> Hey David, All,
>>   Just as a heads up, after net-next was merged into Linus' tree, I
>> started hitting the following crash on boot on the Dragonboard 845c
>> booting AOSP.
>>
>> I've bisected it down to the net-next merge, but haven't bisected it
>> further yet, as I still have a handful of (unrelated to networking)
>> out of tree patches needed to boot the board.
>>
>> [   19.709492] Unable to handle kernel access to user memory outside
>> uaccess routines at virtual address 0000006f53337070
>> [   19.726539] Mem abort info:
>> [   19.726544]   ESR = 0x9600000f
>> [   19.741323]   EC = 0x25: DABT (current EL), IL = 32 bits
>> [   19.741326]   SET = 0, FnV = 0
>> [   19.761185]   EA = 0, S1PTW = 0
>> [   19.761188] Data abort info:
>> [   19.761190]   ISV = 0, ISS = 0x0000000f
>> [   19.761192]   CM = 0, WnR = 0
>> [   19.761199] user pgtable: 4k pages, 39-bit VAs, pgdp=000000016e9e9000
>> [   19.777584] [0000006f53337070] pgd=000000016e99e003,
>> p4d=000000016e99e003, pud=000000016e99e003, pmd=000000016e99a003,
>> pte=00e800016d3c7f53
>> [   19.789205] Internal error: Oops: 9600000f [#1] PREEMPT SMP
>> [   19.789211] Modules linked in:
>> [   19.797153] CPU: 7 PID: 364 Comm: iptables-restor Tainted: G
>> W         5.8.0-mainline-08255-gf9e74a8eb6f3 #3350
>> [   19.797156] Hardware name: Thundercomm Dragonboard 845c (DT)
>> [   19.797161] pstate: a0400005 (NzCv daif +PAN -UAO BTYPE=--)
>> [   19.797177] pc : do_ipt_set_ctl+0x304/0x610
>> [   19.807891] lr : do_ipt_set_ctl+0x50/0x610
>> [   19.807894] sp : ffffffc0139bbba0
>> [   19.807898] x29: ffffffc0139bbba0 x28: ffffff80f07a3800
>> [   19.846468] x27: 0000000000000000 x26: 0000000000000000
>> [   19.846472] x25: 0000000000000000 x24: 0000000000000698
>> [   19.846476] x23: ffffffec8eb0cc80 x22: 0000000000000040
>> [   19.846480] x21: b400006f53337070 x20: ffffffec8eb0c000
>> [   19.846484] x19: ffffffec8e9e9000 x18: 0000000000000000
>> [   19.846487] x17: 0000000000000000 x16: 0000000000000000
>> [   19.846491] x15: 0000000000000000 x14: 0000000000000000
>> [   19.846495] x13: 0000000000000000 x12: 0000000000000000
>> [   19.846501] x11: 0000000000000000 x10: 0000000000000000
>> [   19.856005] x9 : 0000000000000000 x8 : 0000000000000000
>> [   19.856008] x7 : ffffffec8e9e9d08 x6 : 0000000000000000
>> [   19.856012] x5 : 0000000000000000 x4 : 0000000000000213
>> [   19.856015] x3 : 00000001ffdeffef x2 : 11ded3fb0bb85e00
>> [   19.856019] x1 : 0000000000000027 x0 : 0000008000000000
>> [   19.856024] Call trace:
>> [   19.866319]  do_ipt_set_ctl+0x304/0x610
>> [   19.866327]  nf_setsockopt+0x64/0xa8
>> [   19.866332]  ip_setsockopt+0x21c/0x1710
>> [   19.866338]  raw_setsockopt+0x50/0x1b8
>> [   19.866347]  sock_common_setsockopt+0x50/0x68
>> [   19.882672]  __sys_setsockopt+0x120/0x1c8
>> [   19.882677]  __arm64_sys_setsockopt+0x30/0x40
>> [   19.882686]  el0_svc_common.constprop.3+0x78/0x188
>> [   19.882691]  do_el0_svc+0x80/0xa0
>> [   19.882699]  el0_sync_handler+0x134/0x1a0
>> [   19.901555]  el0_sync+0x140/0x180
>> [   19.901564] Code: aa1503e0 97fffd3e 2a0003f5 17ffff80 (a9401ea6)
>> [   19.901569] ---[ end trace 22010e9688ae248f ]---
>> [   19.913033] Kernel panic - not syncing: Fatal exception
>> [   19.913042] SMP: stopping secondary CPUs
>> [   20.138885] Kernel Offset: 0x2c7d080000 from 0xffffffc010000000
>> [   20.138887] PHYS_OFFSET: 0xfffffffa80000000
>> [   20.138894] CPU features: 0x0040002,2a80a218
>> [   20.138898] Memory Limit: none
>>
>> I'll continue to work on bisecting this down further, but figured I'd
>> share now as you or someone else might be able to tell whats wrong
>> from the trace.
>>
> 
> Can you try at commit c2f12630c60ff33a9cafd221646053fc10ec59b6 ("netfilter: switch nf_setsockopt to sockptr_t") 
> (and right before it)
> 
> do_replace(.... unsigned int len) ignore @len parameter.
> 
> This means that the access_ok() in init_user_sockptr() might have received a too small @size
> 
> Presumably on old kernels your command was silently failing.

Could you try : (patch might be mangled)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index f15bc21d730164baf6cd2e8bf982c851685ee3c5..ead2122f5edc5aceae91ff8ee08f4e30e1513def 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1110,6 +1110,8 @@ do_replace(struct net *net, sockptr_t arg, unsigned int len)
        void *loc_cpu_entry;
        struct ipt_entry *iter;
 
+       if (len < sizeof(tmp))
+               return -EINVAL;
        if (copy_from_sockptr(&tmp, arg, sizeof(tmp)) != 0)
                return -EFAULT;
 
@@ -1119,6 +1121,9 @@ do_replace(struct net *net, sockptr_t arg, unsigned int len)
        if (tmp.num_counters == 0)
                return -EINVAL;
 
+       if (len < sizeof(tmp) + tmp.size)
+               return -EINVAL;
+
        tmp.name[sizeof(tmp.name)-1] = 0;
 
        newinfo = xt_alloc_table_info(tmp.size);
@@ -1492,6 +1497,8 @@ compat_do_replace(struct net *net, sockptr_t arg, unsigned int len)
        void *loc_cpu_entry;
        struct ipt_entry *iter;
 
+       if (len < sizeof(tmp))
+               return -EINVAL;
        if (copy_from_sockptr(&tmp, arg, sizeof(tmp)) != 0)
                return -EFAULT;
 
@@ -1501,6 +1508,9 @@ compat_do_replace(struct net *net, sockptr_t arg, unsigned int len)
        if (tmp.num_counters == 0)
                return -EINVAL;
 
+       if (len < sizeof(tmp) + tmp.size)
+               return -EINVAL;
+
        tmp.name[sizeof(tmp.name)-1] = 0;
 
        newinfo = xt_alloc_table_info(tmp.size);

