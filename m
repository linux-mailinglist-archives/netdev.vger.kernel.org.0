Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE18520C09
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbiEJDbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 23:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbiEJDag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 23:30:36 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C926B6D97B;
        Mon,  9 May 2022 20:26:29 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id c1-20020a17090a558100b001dca2694f23so1018233pji.3;
        Mon, 09 May 2022 20:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/k2Rh9N35QdKVmFAAVQT5bIUzhhwmEjyL+VsoErqVkI=;
        b=XJ/9xiodL+AamsRuKRVwEH3bzfE9F5WeP16Eg5DPMJ0w4zgWWrD3hT9t5zKBuo+5ke
         Sax1RYNPRlebJo/+xFFb4xlrndn3VFwV7hQQ0aXiHxHVA+1ntJbpSUiSCzIN0gyN4xCE
         b+d3WCP5DbmNSprp2FRDTSFEesB69btFkCs1LVTWuikbTKNlxxBF2tbKIkAJpIYh86re
         aFpT/+GHf+7aZeF0SsdOIdm2HMwS4qtryOr4JWIWCxA72aea1V0SFJp2Hlju+eVyxxTj
         JllF8EtvnhxXk3CylgCuEmqehUlPhpwl3r4Mh+CtmUoVUWdi3rMJWqoyI/3tLh7bBWLu
         +H4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/k2Rh9N35QdKVmFAAVQT5bIUzhhwmEjyL+VsoErqVkI=;
        b=oWOV9aPalkhlqqDLjpJgjMXspSJDaS+6NOSmo7+Dycz+RrYvR0motGo9sVqDBFz2Cf
         pMQOi6Ab5sE2UohyiR8UYaNEMV5+L887aq1WTy6UaSyeE65v8Fc3/EsyiI6wxBJnJdoe
         vSxqKWpGqzdr8RSpW7T+YRU0FiXBhvn8CA8AYiALYi+1uJAJHXWZCV+6NKpeXNYsLzqm
         6jd/VeUshhF40VIfOQcq7QztvbF84Penta4IoEWzwNA1yupTobW16thrSqWN1bxt7QdK
         3ScZrZPNCjCG94QQjCzVNyHMA8UzD/R0Eibzd6J/cpasg6CK+zrEn0TW/yRKau/NCsRB
         ootw==
X-Gm-Message-State: AOAM531wfMUBcWDUQoTZLaxgUv3LmY0zG4gZVgqS+Xe+esdjuewpOP1S
        5KMwfW7qtpWIHqod+clJr6c=
X-Google-Smtp-Source: ABdhPJyzHurBXGyGbtG7UWaP3ycoMaaDo9bLr6xDdMjq5pdVsrk/gLWe59rt9zLV0SylX0DJe3IfbQ==
X-Received: by 2002:a17:903:3093:b0:15e:d850:56 with SMTP id u19-20020a170903309300b0015ed8500056mr19342914plc.152.1652153189274;
        Mon, 09 May 2022 20:26:29 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id d4-20020a170902b70400b0015e8d4eb298sm646444pls.226.2022.05.09.20.26.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 20:26:28 -0700 (PDT)
Message-ID: <2dbd5e38-b748-0c16-5b8b-b32bc0cc43b0@gmail.com>
Date:   Mon, 9 May 2022 20:26:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH RFC v1 net-next 0/4] net: Qdisc backpressure
 infrastructure
Content-Language: en-US
To:     Peilin Ye <yepeilin.cs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Peilin Ye <peilin.ye@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
References: <cover.1651800598.git.peilin.ye@bytedance.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <cover.1651800598.git.peilin.ye@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/6/22 12:43, Peilin Ye wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
>
> Hi all,
>
> Currently sockets (especially UDP ones) can drop a lot of skbs at TC
> egress when rate limited by shaper Qdiscs like HTB.  This experimental
> patchset tries to improve this by introducing a backpressure mechanism, so
> that sockets are temporarily throttled when they "send too much".
>
> For now it takes care of TBF, HTB and CBQ, for UDP and TCP sockets.  Any
> comments, suggestions would be much appreciated.  Thanks!


This very much looks like trying to solve an old problem to me.

If you were using EDT model, a simple eBPF program could get rid of the 
HTB/TBF qdisc

and you could use MQ+FQ as the packet schedulers, with the true 
multiqueue sharding.

FQ provides fairness, so a flow can not anymore consume all the qdisc limit.

(If your UDP sockets send packets all over the place (not connected 
sockets),

then the eBPF can also be used to rate limit them)


>
> Contents
>       [I] Background
>      [II] Design Overview
>     [III] Performance Numbers & Issues
>      [IV] Synchronization
>       [V] Test Setup
>
> ______________
> [I] Background
>
> Imagine 2 UDP iperf2 clients, both wish to send at 1 GByte/sec from veth0.
> veth0's egress root Qdisc is a TBF Qdisc, with a configured rate of 200
> Mbits/sec.  I tested this setup [V]:
>
> [  3] 10.0-10.5 sec  25.9 MBytes   434 Mbits/sec
> [  3] 10.0-10.5 sec  22.0 MBytes   369 Mbits/sec
> [  3] 10.5-11.0 sec  24.3 MBytes   407 Mbits/sec
> [  3] 10.5-11.0 sec  21.7 MBytes   363 Mbits/sec
> <...>                              ^^^^^^^^^^^^^
>
> [  3]  0.0-30.0 sec   358 MBytes   100 Mbits/sec   0.030 ms 702548/958104 (73%)
> [  3]  0.0-30.0 sec   347 MBytes  96.9 Mbits/sec   0.136 ms 653610/900810 (73%)
>                                                              ^^^^^^^^^^^^^ ^^^^^
>
> On average, both clients try to send at 389.82 Mbits/sec.  TBF drops 74.7%
> of the traffic, in order to keep veth0's egress rate (196.93 Mbits/sec)
> under the configured 200 Mbits/sec.
>
> Why is this happening?  Consider sk->sk_wmem_alloc, number of bytes of
> skbs that a socket has currently "committed" to the "transmit queue":
>
>           ┌─────┐         ┌───────────┐     ┌──────────────┐
>      ─ ─ >│ UDP │─ ... ─ >│ TBF Qdisc │─ ─ >│ device queue │─ ┬ >
>           └───┬─┘         └───────────┘     └──────────────┘ [b]
>              [a]
>
> Normally, sk_wmem_alloc is increased right before an skb leaves UDP [a],
> and decreased when an skb is consumed upon TX completion [b].
>
> However, when TBF becomes full, and starts to drop skbs (assuming a
> simple taildrop inner Qdisc like bfifo for brevity):
>
>           ┌─────┐         ┌───────────┐     ┌──────────────┐
>      ─ ─ >│ UDP │─ ... ─ >│ TBF Qdisc │─ ─ >│ device queue │─ ┬ >
>           └───┬─┘         ├───────────┘     └──────────────┘ [b]
>              [a]         [c]
>
> For those dropped skbs, sk_wmem_alloc is decreased right before TBF [c].
> This is problematic: since the (a,c) "interval" does not cover TBF,
> whenever UDP starts to send faster, TBF simply drops faster, keeping
> sk_wmem_alloc balanced, and tricking UDP into thinking "it is okay to send
> more".
>
> Similar thing happens to other shapers as well.  TCP behaves much better
> than UDP, since TCP slows down itself when TC egress fails to enqueue an
> skb.
>
> ____________________
> [II] Design Overview
>
> Hacking sk_wmem_alloc turned out to be tricky.  Instead, introduce the
> following state machine for sockets:
>
>    ┌────────────────┐  [d]  ┌────────────────┐  [e]  ┌────────────────┐
>    │ SK_UNTHROTTLED │─ ─ ─ >│  SK_OVERLIMIT  │─ ─ ─ >│  SK_THROTTLED  │
>    └────────────────┘       └────────────────┘       └────────────────┘
>             └─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ < ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─┘
>                                     [f]
>
> Take TBF as an example:
>
>    [d] qdisc_backpressure_overlimit()
>        When TBF fails to enqueue an skb belonging to an UNTHROTTLED socket,
>        the socket is marked as OVERLIMIT, and added to TBF's
>        "backpressure_list";
>
>    [e] qdisc_backpressure_throttle()
>        Later, when TBF runs out of tokens, it marks all OVERLIMIT sockets
>        on its backpressure_list as THROTTLED, and schedules a Qdisc
>        watchdog to wait for more tokens;
>
>      * TCP and UDP sleeps on THROTTLED sockets
>      * epoll() and friends should not report EPOLL{OUT,WRNORM} for
>        THROTTLED sockets
>
>    [f] qdisc_backpressure_unthrottle()
>        When the timer expires, all THROTTLED sockets are removed from TBF's
>        backpressure_list, and marked back as UNTHROTTLED.
>
>      * Also call ->sk_write_space(), so that all TCP and UDP waiters are
>        woken up, and all SOCKWQ_ASYNC_NOSPACE subscribers are notified
>
> This should work for all Qdisc watchdog-based shapers (as pointed out by
> Cong though, ETF seems like a special one, I haven't looked into it yet).
>
> (As discussed with Cong, a slightly different design would be: only
>   mark OVERLIMIT sockets as THROTTLED when:
>   
>   1. TBF is full, AND
>   2. TBF is out of tokens i.e. Qdisc watchdog timer is active
>
>   This approach seems to have a slightly lower drop rate under heavy load,
>   at least for TBF.  I'm still working on it.)
>
> __________________________________
> [III] Performance Numbers & Issues
>
> I tested the same setup [V] after applying this patchset:
>
> [  3] 10.0-10.5 sec  6.29 MBytes   106 Mbits/sec
> [  3] 10.0-10.5 sec  5.84 MBytes  98.0 Mbits/sec
> [  3] 10.5-11.0 sec  6.31 MBytes   106 Mbits/sec
> [  3] 10.5-11.0 sec  6.01 MBytes   101 Mbits/sec
> <...>                              ^^^^^^^^^^^^^
>
> [  3]  0.0-30.0 sec   358 MBytes   100 Mbits/sec  62.444 ms 8500/263825 (3.2%)
> [  3]  0.0-30.0 sec   357 MBytes  99.9 Mbits/sec   0.217 ms 8411/263310 (3.2%)
>                                                              ^^^^^^^^^^^ ^^^^^^
>
> On average, drop rate decreased from 74.7% to 3.2%.  No significant
> affects on throughput (196.93 Mbits/sec becomes 197.46 Mbits/sec).
>
> However, drop rate starts to increase when we add more iperf2 clients.
> For example, 3 clients (also UDP -b 1G):
>
> [  3]  0.0-30.0 sec   232 MBytes  65.0 Mbits/sec   0.092 ms 104961/270765 (39%)
> [  3]  0.0-30.0 sec   232 MBytes  64.8 Mbits/sec   0.650 ms 102493/267769 (38%)
> [  3]  0.0-30.1 sec   239 MBytes  66.8 Mbits/sec   0.045 ms 99234/269987 (37%)
>                                                              ^^^^^^^^^^^^ ^^^^^
>
> 38% of the traffic is dropped.  This is still a lot better than current
> (87%), but not ideal.  There is a thundering herd problem: when the Qdisc
> watchdog timer expires, we wake up all THROTTLED sockets at once in [f],
> so all of them just resume sending (and dropping...).  We probably need a
> better algorithm here, please advise, thanks!
>
> One "workaround" is making TBF's queue larger (the "limit" parameter).  In
> the above 3-client example, raising "limit" from 200k to 300k decreases
> drop rate from 38% back to 3.1%.  Without this patchset, it requires about
> a 400k "limit" for the same setup to drop less than 5% of the traffic.
>
> ____________________
> [IV] Synchronization
>
> 1. For each device, all backpressure_list operations are serialized by
>     Qdisc root_lock:
>
>     [d] and [e] happen in shaper's ->enqueue() and ->dequeue()
>     respectively; in both cases we hold root_lock.
>
>     [f] happens in TX softirq, right after grabbing root_lock.  Scheduling
>     Qdisc watchdog is not the only way to wait for more tokens, see
>     htb_work_func() for an example.  However, they all end up raising TX
>     softirq, so run [f] there.
>
> 2. Additionally, we should prevent 2 CPUs from trying to add the same
>     socket to 2 different backpressure_lists (on 2 different devices).  Use
>     memory barriers to make sure this will not happen.  Please see [1/4]
>     commit message for details.
>
> ______________
> [V] Test Setup
>
>      # setup network namespace
>      ip netns add red
>      ip link add name veth0 type veth peer name veth1
>      ip link set veth1 netns red
>      ip addr add 10.0.0.1/24 dev veth0
>      ip -n red addr add 10.0.0.2/24 dev veth1
>      ip link set veth0 up
>      ip -n red link set veth1 up
>
>      tc qdisc replace dev veth0 handle 1: root \
>          tbf rate 200mbit burst 20kb limit 200k
>
>      # servers
>      ip netns exec red iperf -u -s -p 5555 -i 0.5 -t 1000 &
>      ip netns exec red iperf -u -s -p 6666 -i 0.5 -t 1000 &
>
>      # clients
>      iperf -u -c 10.0.0.2 -p 5555 -i 0.5 -t 30 -b 1G &
>      iperf -u -c 10.0.0.2 -p 6666 -i 0.5 -t 30 -b 1G &
>
> Thanks,
> Peilin Ye (4):
>    net: Introduce Qdisc backpressure infrastructure
>    net/sched: sch_tbf: Use Qdisc backpressure infrastructure
>    net/sched: sch_htb: Use Qdisc backpressure infrastructure
>    net/sched: sch_cbq: Use Qdisc backpressure infrastructure
>
>   include/net/sch_generic.h | 43 +++++++++++++++++++++++++++++++++++++++
>   include/net/sock.h        | 18 +++++++++++++++-
>   net/core/dev.c            |  1 +
>   net/core/sock.c           |  6 ++++--
>   net/ipv4/tcp_ipv4.c       | 11 +++++++---
>   net/sched/sch_cbq.c       |  6 +++++-
>   net/sched/sch_generic.c   |  4 ++++
>   net/sched/sch_htb.c       |  5 +++++
>   net/sched/sch_tbf.c       |  2 ++
>   9 files changed, 89 insertions(+), 7 deletions(-)
>
