Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD024BD0AD
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 19:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244504AbiBTSau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 13:30:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiBTSat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 13:30:49 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DC525C7C
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 10:30:27 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id c14so26400024qvl.12
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 10:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ruF9UmVk5L8mOys1Xob/xnU3nr9baWOO8MBm1hNjpfQ=;
        b=iv34ZvfkD0OZSArFYEsI1579iakLc64nXOaam9VYL7u8RhaPnLu0WdS2ocQ2UdZW9n
         l2aZWRvwVLEO/POSSlyXxeewgS87C30Fq0aR7wNOHpd7S2XS0NbKCppJyVzkDh5MU8jL
         AK5UGZncQ0KgZGIk+3FqSEvos7/UA6CvOnPPR6coo3PM4yHBnsKkgAHwbXQ+y6DF1rUo
         Z62Lpkr64jgWutO3Lp6j4FqfvxAahkvdBkDHibj2DHqkXMFr16VNJg+5cRQU5ANo2via
         kgTyxCgcp6hhAlvyHC5IB2b0woXEU4R3OfV7NIxdtPvGmVe2P1qeOqd3noTTFRX0LW+3
         k9nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ruF9UmVk5L8mOys1Xob/xnU3nr9baWOO8MBm1hNjpfQ=;
        b=uviKVRHHcJvKHV0nfXKqa351sxftDLhCCiCaw+QlD3P0VCQ9B3ag+Mg0oLHxIW+AjA
         IWpdCxuC8eJqLxut1usjO00GF6NA3IGcW8dm/Lg6tro1pETLHk+lLwnvLSQcv5sxEOVr
         HWvWIp7zz2ByoPahVQ5GvwXhn6ChPb+vxdNkgIymBQ3CpvxB5sXHijFguf18vl/5o9Ax
         AzprqVSs3A6VcaWnhMkKyzMYZagnLeoPNzb/I6sweKxMP2h7UtzwM8KgKSY/f8y8vrA4
         aD4qsu8ixJYWiplIM4uvDBOcLxnYvJ1Wv5vGZJALPWpsqu09Ehwzyl3ioqM9MGQmO1b3
         26rQ==
X-Gm-Message-State: AOAM532jthjOQ224kMsB8cceXcbnQHR8NwNq4X2MDh5n4Xy8IDRGPTXn
        TNm2uAuCKVXPDsAnQZzvX1DGUg==
X-Google-Smtp-Source: ABdhPJzEn7yNseDOMc0vnSkeobBxP/VHSmJIvRIlllvTlY7ZBIt2mL1dDb/9pshO6GCZxHfKw9nrqA==
X-Received: by 2002:ac8:5993:0:b0:2dd:c4df:35aa with SMTP id e19-20020ac85993000000b002ddc4df35aamr9279181qte.369.1645381826824;
        Sun, 20 Feb 2022 10:30:26 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-124.dsl.bell.ca. [184.148.47.124])
        by smtp.googlemail.com with ESMTPSA id q22sm29929235qtw.52.2022.02.20.10.30.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Feb 2022 10:30:25 -0800 (PST)
Message-ID: <bc0affeb-1d2e-3e1f-bc3f-43fc47736674@mojatatu.com>
Date:   Sun, 20 Feb 2022 13:30:24 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [net-next v8 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
Content-Language: en-US
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
References: <20220126143206.23023-1-xiangxia.m.yue@gmail.com>
 <20220126143206.23023-3-xiangxia.m.yue@gmail.com>
 <0b486c4e-0af5-d142-44e5-ed81aa0b98c2@mojatatu.com>
 <CAMDZJNVB4FDgv+xrTw2cZisEy2VNn1Dv9RodEhEAsd5H6qwkRA@mail.gmail.com>
 <4e556aff-0295-52d1-0274-a0381b585fbb@mojatatu.com>
 <CAMDZJNXbxstEvFoF=ZRD_PwH6HQc17LEn0tSvFTJvKB9aoW6Aw@mail.gmail.com>
 <7a6b7a74-82f5-53e7-07f4-2a995df9f349@mojatatu.com>
 <CAMDZJNUB8KwjgGOdn1iuJLHMwL4VfmfKEfvK69WCaoAmubDt3g@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <CAMDZJNUB8KwjgGOdn1iuJLHMwL4VfmfKEfvK69WCaoAmubDt3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-18 07:43, Tonghao Zhang wrote:
> On Thu, Feb 17, 2022 at 7:39 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>

> Hi Jamal
> 
> The setup commands is shown as below:
> NETDEV=eth0
> ip li set dev $NETDEV up
> tc qdisc del dev $NETDEV clsact 2>/dev/null
> tc qdisc add dev $NETDEV clsact
> 
> ip link add ipv1 link $NETDEV type ipvlan mode l2
> ip netns add n1
> ip link set ipv1 netns n1
> 
> ip netns exec n1 ip link set ipv1 up
> ip netns exec n1 ifconfig ipv1 2.2.2.100/24 up
> 
> tc filter add dev $NETDEV egress protocol ip prio 1 flower skip_hw
> src_ip 2.2.2.100 action skbedit queue_mapping hash-type skbhash 2 6
> 
> tc qdisc add dev $NETDEV handle 1: root mq
> 
> tc qdisc add dev $NETDEV parent 1:1 handle 2: htb
> tc class add dev $NETDEV parent 2: classid 2:1 htb rate 100kbit
> tc class add dev $NETDEV parent 2: classid 2:2 htb rate 200kbit
> 
> tc qdisc add dev $NETDEV parent 1:2 tbf rate 100mbit burst 100mb latency 1
> tc qdisc add dev $NETDEV parent 1:3 pfifo
> tc qdisc add dev $NETDEV parent 1:4 pfifo
> tc qdisc add dev $NETDEV parent 1:5 pfifo
> tc qdisc add dev $NETDEV parent 1:6 pfifo
> tc qdisc add dev $NETDEV parent 1:7 pfifo
> 
> 
> use the perf to generate packets:
> ip netns exec n1 iperf3 -c 2.2.2.1 -i 1 -t 10 -P 10
> 
> we use the skbedit to select tx queue from 2 - 6
> # ethtool -S eth0 | grep -i [tr]x_queue_[0-9]_bytes
>       rx_queue_0_bytes: 442
>       rx_queue_1_bytes: 60966
>       rx_queue_2_bytes: 10440203
>       rx_queue_3_bytes: 6083863
>       rx_queue_4_bytes: 3809726
>       rx_queue_5_bytes: 3581460
>       rx_queue_6_bytes: 5772099
>       rx_queue_7_bytes: 148
>       rx_queue_8_bytes: 368
>       rx_queue_9_bytes: 383
>       tx_queue_0_bytes: 42
>       tx_queue_1_bytes: 0
>       tx_queue_2_bytes: 11442586444
>       tx_queue_3_bytes: 7383615334
>       tx_queue_4_bytes: 3981365579
>       tx_queue_5_bytes: 3983235051
>       tx_queue_6_bytes: 6706236461
>       tx_queue_7_bytes: 42
>       tx_queue_8_bytes: 0
>       tx_queue_9_bytes: 0
> 
> tx queues 2-6 are mapping to classid 1:3 - 1:7
> # tc -s class show dev eth0
> class mq 1:1 root leaf 2:
>   Sent 42 bytes 1 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> class mq 1:2 root leaf 8001:
>   Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> class mq 1:3 root leaf 8002:
>   Sent 11949133672 bytes 7929798 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> class mq 1:4 root leaf 8003:
>   Sent 7710449050 bytes 5117279 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> class mq 1:5 root leaf 8004:
>   Sent 4157648675 bytes 2758990 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> class mq 1:6 root leaf 8005:
>   Sent 4159632195 bytes 2759990 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> class mq 1:7 root leaf 8006:
>   Sent 7003169603 bytes 4646912 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> class mq 1:8 root
>   Sent 42 bytes 1 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> class mq 1:9 root
>   Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> class mq 1:a root
>   Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> class tbf 8001:1 parent 8001:
> 
> class htb 2:1 root prio 0 rate 100Kbit ceil 100Kbit burst 1600b cburst 1600b
>   Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
>   lended: 0 borrowed: 0 giants: 0
>   tokens: 2000000 ctokens: 2000000
> 
> class htb 2:2 root prio 0 rate 200Kbit ceil 200Kbit burst 1600b cburst 1600b
>   Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
>   lended: 0 borrowed: 0 giants: 0
>   tokens: 1000000 ctokens: 1000000
> 

Yes, this is a good example (which should have been in the commit
message of 0/2 or 2/2 - would have avoided long discussion).
The byte count doesnt map correctly between the DMA side and the
qdisc side; you probably had some additional experiments running
prior to installing the mq qdisc.
So not a big deal - it is close enough.

To Cong's comments earlier - I dont think you can correctly have
picked the queue in user space for this specific policy (hash-type
skbhash). Reason is you are dependent on the skb hash computation
which is based on things like ephemeral src port for the netperf
client - which cannot be determined in user space.

> Good question, for TCP, we set the ixgbe ntuple off.
> ethtool -K ixgbe-dev ntuple off
> so in the underlying driver, hw will record this flow, and its tx
> queue, when it comes back to pod.
> hw will send to rx queue corresponding to tx queue.
> 
> the codes:
> ixgbe_xmit_frame/ixgbe_xmit_frame_ring -->ixgbe_atr() ->
> ixgbe_fdir_add_signature_filter_82599
> ixgbe_fdir_add_signature_filter_82599 will install the rule for
> incoming packets.
> 
>> ex: who sets the skb->hash (skb->l4_hash, skb->sw_hash etc)
> for tcp:
> __tcp_transmit_skb -> skb_set_hash_from_sk
> 
> for udp
> udp_sendmsg -> ip_make_skb -> __ip_append_data -> sock_alloc_send_pskb
> -> skb_set_owner_w

Thats a different use case than what you are presenting here.
i.e the k8s pod scenario is purely a forwarding use case.
But it doesnt matter tbh since your data shows reasonable results.

[i didnt dig into the code but it is likely (based on your experimental
data) that both skb->l4_hash and skb->sw_hash  will _not be set_
and so skb_get_hash() will compute the skb->hash from scratch.]

>> I may be missing something on the cpuid one - seems high likelihood
>> of having the same flow on multiple queues (based on what
>> raw_smp_processor_id() returns, which i believe is not guaranteed to be
>> consistent). IOW, you could be sending packets out of order for the
>> same 5 tuple flow (because they end up in different queues).
> Yes, but think about one case, we pin one pod to one cpu, so all the
> processes of the pod will
> use the same cpu. then all packets from this pod will use the same tx queue.

To Cong's point - if you already knew the pinned-to cpuid then you could
just as easily set that queue map from user space?

>> As for classid variant - if these packets are already outside th
>> pod and into the host stack, is that field even valid?
> Yes, ipvlan, macvlan and other virt netdev don't clean this field.
>>> Why we want to do the balance, because we don't want pin the packets
>>> from Pod to one tx queue. (in k8s the pods are created or destroy
>>> frequently, and the number of Pods > tx queue number).
>>> sharing the tx queue equally is more important.
>>>
>>
>> As long as the same flow is pinned to the same queue (see my comment
>> on cpuid).
>> Over a very long period what you describe maybe true but it also
>> seems depends on many other variables.
> NETDEV=eth0
> 
> ip li set dev $NETDEV up
> 
> tc qdisc del dev $NETDEV clsact 2>/dev/null
> tc qdisc add dev $NETDEV clsact
> 
> ip link add ipv1 link $NETDEV type ipvlan mode l2
> ip netns add n1
> ip link set ipv1 netns n1
> 
> ip netns exec n1 ip link set ipv1 up
> ip netns exec n1 ifconfig ipv1 2.2.2.100/24 up
> 
> tc filter add dev $NETDEV egress protocol ip prio 1 \
> flower skip_hw src_ip 2.2.2.100 action skbedit queue_mapping hash-type cpuid 2 6
> 
> tc qdisc add dev $NETDEV handle 1: root mq
> 
> tc qdisc add dev $NETDEV parent 1:1 handle 2: htb
> tc class add dev $NETDEV parent 2: classid 2:1 htb rate 100kbit
> tc class add dev $NETDEV parent 2: classid 2:2 htb rate 200kbit
> 
> tc qdisc add dev $NETDEV parent 1:2 tbf rate 100mbit burst 100mb latency 1
> tc qdisc add dev $NETDEV parent 1:3 pfifo
> tc qdisc add dev $NETDEV parent 1:4 pfifo
> tc qdisc add dev $NETDEV parent 1:5 pfifo
> tc qdisc add dev $NETDEV parent 1:6 pfifo
> tc qdisc add dev $NETDEV parent 1:7 pfifo
> 
> set the iperf3 to one cpu
> # mkdir -p /sys/fs/cgroup/cpuset/n0
> # echo 4 > /sys/fs/cgroup/cpuset/n0/cpuset.cpus
> # echo 0 > /sys/fs/cgroup/cpuset/n0/cpuset.mems
> # ip netns exec n1 iperf3 -c 2.2.2.1 -i 1 -t 1000 -P 10 -u -b 10G
> # echo $(pidof iperf3) > /sys/fs/cgroup/cpuset/n0/tasks
> 
> # ethtool -S eth0 | grep -i tx_queue_[0-9]_bytes
>       tx_queue_0_bytes: 7180
>       tx_queue_1_bytes: 418
>       tx_queue_2_bytes: 3015
>       tx_queue_3_bytes: 4824
>       tx_queue_4_bytes: 3738
>       tx_queue_5_bytes: 716102781 # before setting iperf3 to cpu 4
>       tx_queue_6_bytes: 17989642640 # after setting iperf3 to cpu 4,
> skbedit use this tx queue, and don't use tx queue 5
>       tx_queue_7_bytes: 4364
>       tx_queue_8_bytes: 42
>       tx_queue_9_bytes: 3030
> 
> 
> # tc -s class show dev eth0
> class mq 1:1 root leaf 2:
>   Sent 9874 bytes 63 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> class mq 1:2 root leaf 8001:
>   Sent 418 bytes 3 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> class mq 1:3 root leaf 8002:
>   Sent 3015 bytes 13 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> class mq 1:4 root leaf 8003:
>   Sent 4824 bytes 8 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> class mq 1:5 root leaf 8004:
>   Sent 4074 bytes 19 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> class mq 1:6 root leaf 8005:
>   Sent 716102781 bytes 480624 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> class mq 1:7 root leaf 8006:
>   Sent 18157071781 bytes 12186100 pkt (dropped 0, overlimits 0 requeues 18)
>   backlog 0b 0p requeues 18
> class mq 1:8 root
>   Sent 4364 bytes 26 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> class mq 1:9 root
>   Sent 42 bytes 1 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> class mq 1:a root
>   Sent 3030 bytes 13 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> class tbf 8001:1 parent 8001:
> 
> class htb 2:1 root prio 0 rate 100Kbit ceil 100Kbit burst 1600b cburst 1600b
>   Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
>   lended: 0 borrowed: 0 giants: 0
>   tokens: 2000000 ctokens: 2000000
> 
> class htb 2:2 root prio 0 rate 200Kbit ceil 200Kbit burst 1600b cburst 1600b
>   Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
>   lended: 0 borrowed: 0 giants: 0
>   tokens: 1000000 ctokens: 1000000
> 

Yes, if you pin a flow/process to a cpu - this is expected. See my
earlier comment. You could argue that you are automating things but
it is not as a strong as the hash setup (and will have to be documented
that it works only if you pin processes doing network i/o to cpus).

Could you also post an example on the cgroups classid?

cheers,
jamal
