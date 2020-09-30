Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAA727E299
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 09:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgI3H31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 03:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbgI3H31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 03:29:27 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965A1C061755;
        Wed, 30 Sep 2020 00:29:26 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z1so574567wrt.3;
        Wed, 30 Sep 2020 00:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xXfkrfrflKsk3O9EgwzTyQbEAgQda9XCPrd64e/Yg6Q=;
        b=MYUfzLqBwc9ET3CrMHL3DpVcbkci8mU05q9Mtc1DKbZB0FtmyQSTD1mAz/fFrNWLGA
         iVYsUcI5CtJMl2uNmNCrIoAJ6g3Z011dgaoba821toRdFfmnOIZYb7bwMw4DdYSzXEX7
         92EZM+fe5MnAicQEFB/JQThjQluinxTf/IgRb+s6d3Kfv72bclk7REudcG+gszOOIFBX
         B93lAoPoQMaKACZUr2gHxOPIm3yWEAM35yZ4g+wNOYrIAxRMUAKSJNYnUujaDnX0DiRf
         U8tBg0N4DSZyUrEt+q7xb5LzcU4pR/Y6HW+g9nRoYanG74l9b4fr+/ZX5d2lWupo4TfZ
         8esg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xXfkrfrflKsk3O9EgwzTyQbEAgQda9XCPrd64e/Yg6Q=;
        b=OHQdk3EpsCVfSM18WJdvjYCsf54uN0j6aL+yOGUlHTcttRQgpf5bvEwxGS99HuRncJ
         vCp60J7dAvafTEGsemnFB1+bybwIYpqPlTAvrVPtnyOBreXUgATFJXcYk01XdcnStjSE
         ce29wEvY2cYK18f+epQg9YlogzTlv0gPGj7Csn8NlqGxqnuUkTsIjsUkyYtpyuG/ZkER
         FAkzQL+2aN4ZEOgSXMYpX93tEFghZ5A/xuAwjS4nPEAC31zzMu7X/1C+i+IIUd6HvLQ2
         Oq2yiePi9MlNQ8+dlavEliQ9QHHer9pT9HoIm3h1kOwUmyt+B/rci/lRTc4ifwEOuYhI
         ns/Q==
X-Gm-Message-State: AOAM530eYrSfmJQgK+nbmLldFvOrKtI4PQanMgnq7cgSx2y/M2x8ifXb
        ZVQoHd2LTy1s7MOt7vGGDEAP6rjcy3g=
X-Google-Smtp-Source: ABdhPJz8rDMFY2NkXh6foFjopl3sxebcI/jqLiX2MGZwmZnE0kgZBMcE+FCirNl7m6IQik45GnpVww==
X-Received: by 2002:adf:84c3:: with SMTP id 61mr1477400wrg.131.1601450965300;
        Wed, 30 Sep 2020 00:29:25 -0700 (PDT)
Received: from [192.168.8.147] ([37.173.161.238])
        by smtp.gmail.com with ESMTPSA id i26sm1264669wmb.17.2020.09.30.00.29.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 00:29:24 -0700 (PDT)
Subject: Re: Fw: [Bug 209427] New: Incorrect timestamp cause packet to be
 dropped
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
        "lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>,
        abt-admin@mail.ru
References: <20200929103532.0ecbc3b3@hermes.local>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8e1a8be5-4123-ea86-80f2-16027cfa021c@gmail.com>
Date:   Wed, 30 Sep 2020 09:29:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200929103532.0ecbc3b3@hermes.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/29/20 7:35 PM, Stephen Hemminger wrote:
> 
> 
> Begin forwarded message:
> 
> Date: Tue, 29 Sep 2020 17:15:23 +0000
> From: bugzilla-daemon@bugzilla.kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 209427] New: Incorrect timestamp cause packet to be dropped
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=209427
> 
>             Bug ID: 209427
>            Summary: Incorrect timestamp cause packet to be dropped
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 5.8.10
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>           Assignee: stephen@networkplumber.org
>           Reporter: abt-admin@mail.ru
>         Regression: No
> 
> After upgrading from my 3.10 to 5.8.10 I found out some of my packets are
> getting dropped by ipvlan interface (I'm using qdisk fq). Debugging session led
> me to the place where this happens
> 
> net/sched/sch_fq.c:464
> ...
>         if (fq_packet_beyond_horizon(skb, q)) {
>                 if (q->horizon_drop) {
>                         q->stat_horizon_drops++;
>                         return qdisc_drop(skb, sch, to_free);
>                 }
>                 q->stat_horizon_caps++;
>                 skb->tstamp = q->ktime_cache + q->horizon;
>         }
> ...
> 
> then I noticed that in some cases skb->tstamp is equal to real ts whereas in
> the regular cases where a packet pass through it's time since kernel boot. This
> doesn't make any sense for me as this condition is satisfied constantly
> 
> net/sched/sch_fq.c:439
> static bool fq_packet_beyond_horizon(const struct sk_buff *skb,
>                                     const struct fq_sched_data *q)
> {
>         return unlikely((s64)skb->tstamp > (s64)(q->ktime_cache + q->horizon));
> }
> 
> Any ideas on what it can be?
> 
> some outputs:
>     [Tue Sep 29 14:59:06 2020] DBG: TIME: trid: -1081131982. all:
> q->ktime_cache 328453964122, skb->tstamp 1601391546982793177 <<
>     [Tue Sep 29 14:59:06 2020] DBG: TIME: trid: -1485308564. all:
> q->ktime_cache 334998110463, skb->tstamp 335012588783
>     ...
>     [Tue Sep 29 14:59:06 2020] DBG: TIME: trid: -1010372082. all:
> q->ktime_cache 335873778729, skb->tstamp 335741726080
>     [Tue Sep 29 14:59:06 2020] DBG: TIME: trid: 192888327. all: q->ktime_cache
> 335860696387, skb->tstamp 335870531339
>     [Tue Sep 29 14:59:07 2020] DBG: TIME: trid: -1463571809. all:
> q->ktime_cache 335305774517, skb->tstamp 1601391548109319017 <<
> 
>   perf trace: 
>     curl 32613 [014]  1546.957467: skb:kfree_skb: skbaddr=0xffff888f57159ae0
> protocol=2048 location=0xffffffff817bfdad
>                   9bfd56 kfree_skb (/lib/modules/5.8.10/build/vmlinux)
>                   9bfd56 kfree_skb (/lib/modules/5.8.10/build/vmlinux)
>                   9bfdad kfree_skb_list (/lib/modules/5.8.10/build/vmlinux)
>                   9da2b1 __dev_queue_xmit (/lib/modules/5.8.10/build/vmlinux)
>                   9da380 dev_queue_xmit (/lib/modules/5.8.10/build/vmlinux)
>                     1f39 vlan_dev_open ([8021q])
>                   9d9851 dev_hard_start_xmit
> (/lib/modules/5.8.10/build/vmlinux)
>                   9d9d05 __dev_queue_xmit (/lib/modules/5.8.10/build/vmlinux)
>                   9da380 dev_queue_xmit (/lib/modules/5.8.10/build/vmlinux)
>                   9d9d05 __dev_queue_xmit (/lib/modules/5.8.10/build/vmlinux)
>                   9da380 dev_queue_xmit (/lib/modules/5.8.10/build/vmlinux)
>                   9e32c3 neigh_connected_output
> (/lib/modules/5.8.10/build/vmlinux)
>                   a68cdb ip_finish_output2 (/lib/modules/5.8.10/build/vmlinux)
>                   a69b77 __ip_finish_output (/lib/modules/5.8.10/build/vmlinux)
>                   a69cad ip_finish_output (/lib/modules/5.8.10/build/vmlinux)
>                   a6b65a ip_output (/lib/modules/5.8.10/build/vmlinux)
>                     f2e4 ip_vs_tunnel_xmit ([ip_vs])
>                     536a ip_vs_nat_icmp ([ip_vs])
>                     5913 ip_vs_out_icmp ([ip_vs])
>                     59c6 ip_vs_out_icmp ([ip_vs])
>                   a58255 nf_hook_slow (/lib/modules/5.8.10/build/vmlinux)
>                   a656f1 ip_local_deliver (/lib/modules/5.8.10/build/vmlinux)
>                   a64e07 ip_rcv_finish (/lib/modules/5.8.10/build/vmlinux)
>                   b717bb ip_sabotage_in (/lib/modules/5.8.10/build/vmlinux)
>                   a58255 nf_hook_slow (/lib/modules/5.8.10/build/vmlinux)
>                   a657a0 ip_rcv (/lib/modules/5.8.10/build/vmlinux)
>                   9db608 __netif_receive_skb_one_core
> (/lib/modules/5.8.10/build/vmlinux)
>                   9db658 __netif_receive_skb
> (/lib/modules/5.8.10/build/vmlinux)
>                   9db6e9 netif_receive_skb (/lib/modules/5.8.10/build/vmlinux)
>                   b5c5b6 br_netif_receive_skb
> (/lib/modules/5.8.10/build/vmlinux)
>                   b5c7d3 br_pass_frame_up (/lib/modules/5.8.10/build/vmlinux)
>                   b5c94d br_handle_frame_finish
> (/lib/modules/5.8.10/build/vmlinux)
>                   b7253b br_nf_hook_thresh (/lib/modules/5.8.10/build/vmlinux)
>                   b72fb0 br_nf_pre_routing_finish
> (/lib/modules/5.8.10/build/vmlinux)
>                   b733bc br_nf_pre_routing (/lib/modules/5.8.10/build/vmlinux)
>                   b5cdf1 br_handle_frame (/lib/modules/5.8.10/build/vmlinux)
>                   9da8c8 __netif_receive_skb_core
> (/lib/modules/5.8.10/build/vmlinux)
>                   9db5bf __netif_receive_skb_one_core
> (/lib/modules/5.8.10/build/vmlinux)
>                   9db658 __netif_receive_skb
> (/lib/modules/5.8.10/build/vmlinux)
>                   9db8a9 process_backlog (/lib/modules/5.8.10/build/vmlinux)
>                   9dd337 net_rx_action (/lib/modules/5.8.10/build/vmlinux)
>                   e000e1 __do_softirq (/lib/modules/5.8.10/build/vmlinux)
>                   c010c2 asm_call_on_stack (/lib/modules/5.8.10/build/vmlinux)
>                   235bef do_softirq_own_stack
> (/lib/modules/5.8.10/build/vmlinux)
>                   297f86 do_softirq.part.0 (/lib/modules/5.8.10/build/vmlinux)
>                   297fe0 __local_bh_enable_ip
> (/lib/modules/5.8.10/build/vmlinux)
>                   a68cef ip_finish_output2 (/lib/modules/5.8.10/build/vmlinux)
>                   a69b77 __ip_finish_output (/lib/modules/5.8.10/build/vmlinux)
>                   a69cad ip_finish_output (/lib/modules/5.8.10/build/vmlinux)
>                   a6b65a ip_output (/lib/modules/5.8.10/build/vmlinux)
>                   a6ad4d ip_local_out (/lib/modules/5.8.10/build/vmlinux)
>                   a6b097 __ip_queue_xmit (/lib/modules/5.8.10/build/vmlinux)
>                   a8f740 ip_queue_xmit (/lib/modules/5.8.10/build/vmlinux)
>                   a89746 __tcp_transmit_skb (/lib/modules/5.8.10/build/vmlinux)
>                   a8a5de tcp_connect (/lib/modules/5.8.10/build/vmlinux)
>                   a90f73 tcp_v4_connect (/lib/modules/5.8.10/build/vmlinux)
>                   aad59a __inet_stream_connect
> (/lib/modules/5.8.10/build/vmlinux)
>                   aad88b inet_stream_connect
> (/lib/modules/5.8.10/build/vmlinux)
>                   9b3e3f __sys_connect_file (/lib/modules/5.8.10/build/vmlinux)
>                   9b3ef1 __sys_connect (/lib/modules/5.8.10/build/vmlinux)
>                   9b3f3a __x64_sys_connect (/lib/modules/5.8.10/build/vmlinux)
>                   b896b2 do_syscall_64 (/lib/modules/5.8.10/build/vmlinux)
>                   c0008c entry_SYSCALL_64 (/lib/modules/5.8.10/build/vmlinux)
>                    53878 [unknown] (/lib/ld-musl-x86_64.so.1)
>                        0 [unknown] ([unknown])
>                        0 [unknown] ([unknown])
> 

Thanks for the detailed report !

I suspect ipvs or bridge code needs something similar to the fixes done in 

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=de20900fbe1c4fd36de25a7a5a43223254ecf0d0

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=41d1c8839e5f8cb781cc635f12791decee8271b7

The reason for that is that skb->tstamp can get a timestamp in input path,
with a base which is not CLOCK_MONOTONIC, unfortunately.

Whenever a packet is forwarded, its tstamp must be cleared.

Can you try :

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index b00866d777fe0e9ed8018087ebc664c56f29b5c9..11e8ccdae358a89067046efa62ed40308b9e06f9 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -952,6 +952,8 @@ ip_vs_prepare_tunneled_skb(struct sk_buff *skb, int skb_af,
 
        ip_vs_drop_early_demux_sk(skb);
 
+       skb->tstamp = 0;
+
        if (skb_headroom(skb) < max_headroom || skb_cloned(skb)) {
                new_skb = skb_realloc_headroom(skb, max_headroom);
                if (!new_skb)

