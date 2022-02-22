Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12044BF76B
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 12:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbiBVLpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 06:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiBVLpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 06:45:02 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46941139CE0
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 03:44:37 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id d3so12314451ilr.10
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 03:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yJHRQCgLMWoDtd5FRtcK1e6cz+hbzQFT86laYM8r5Ds=;
        b=UjP3l4Le0EiaLCPOI0tEXe216Kqr+5sPUJHppt2plzvf0J9Eu7RwHNr99gwymg/Eu8
         PpzMXovsSsmwfXpRENrVLS7t9dlmCzDrMlfYGmE+4tRWkxFivY29LBNDz4eWY4Ru2KWu
         Z6jM5yko+OG/GRWzKQriOLlsZPZ+XQsabttRLE7EMYtomzmEIteT49+3TGH9+5UTJ05w
         YsElyo0ttAFfnAbOV4pe3FYNL+txf+lcTORvxSI9D50P+EE4utRMpIna5FSrBgf69JwU
         YUyZFBviQPEU76yETH96CnXTlOXJbigrO7SJM0pfCxGSosg5Wx+BoT70xjzw/L5P7GXI
         yDhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yJHRQCgLMWoDtd5FRtcK1e6cz+hbzQFT86laYM8r5Ds=;
        b=ELpPg9bMNKOvGlcuSI5ei5u5GWanSWGMnZJBbMrVuG6m2LuTSsA7ryOGIVIXp8kWID
         j5yrKD0jzGTGxFka3h3SpAdwlcaLb4XXDrh6qJN6aeUULvd7NTfJKD7KyPDwTUBOtkKx
         wcT0T6wtBaDklE5VNCvYZguZikmSIS5jJ2BIt0mU+DlI6oypj3hA5RjmjchUS6lUBsGY
         WqCCpYN8qB+lB9Vq6oEYntk0eO96ct95Q+Fak6pizilCu/OczKHQh2rA1sTMsFdVnfMS
         9XtfCSHtJ5+50QJkv94LhCSbK3ZQQBNE37QfosKJA/Gl7EKfWSBpH6LC6FcYbQT1W+4o
         dyKA==
X-Gm-Message-State: AOAM533gxV31UP20yeBEprkBRn7euu1PNC7WQyHuyO/C2Uv7HNmOG5BO
        AecCHaPBv9g430mxsbiEAHBTdQ==
X-Google-Smtp-Source: ABdhPJxGD9iZ9sbxrR7uwxCuFVEF1X+tGmEPsHp9NIhrSqETGIt7m9UZMpAAj84J3kXNOp25f0PFXA==
X-Received: by 2002:a05:6e02:1b8e:b0:2c2:2750:1178 with SMTP id h14-20020a056e021b8e00b002c227501178mr9310662ili.126.1645530276608;
        Tue, 22 Feb 2022 03:44:36 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-124.dsl.bell.ca. [184.148.47.124])
        by smtp.googlemail.com with ESMTPSA id b5sm9569379ilr.0.2022.02.22.03.44.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 03:44:35 -0800 (PST)
Message-ID: <46cfd7bc-5242-0a4c-b710-48fc2e69007c@mojatatu.com>
Date:   Tue, 22 Feb 2022 06:44:34 -0500
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
 <bc0affeb-1d2e-3e1f-bc3f-43fc47736674@mojatatu.com>
 <CAMDZJNW3zV07h3_u1g7rFX+uaB11smjVv1zqZKHj9n4YzctBmA@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <CAMDZJNW3zV07h3_u1g7rFX+uaB11smjVv1zqZKHj9n4YzctBmA@mail.gmail.com>
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

On 2022-02-20 20:43, Tonghao Zhang wrote:
> On Mon, Feb 21, 2022 at 2:30 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>
>> On 2022-02-18 07:43, Tonghao Zhang wrote:
>>> On Thu, Feb 17, 2022 at 7:39 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>>>
>>





>>
>> Thats a different use case than what you are presenting here.
>> i.e the k8s pod scenario is purely a forwarding use case.
>> But it doesnt matter tbh since your data shows reasonable results.
>>
>> [i didnt dig into the code but it is likely (based on your experimental
>> data) that both skb->l4_hash and skb->sw_hash  will _not be set_
>> and so skb_get_hash() will compute the skb->hash from scratch.]
> No, for example, for tcp, we have set hash in __tcp_transmit_skb which
> invokes the skb_set_hash_from_sk
> so in skbedit, skb_get_hash only gets skb->hash.

There is no tcp anything in the forwarding case. Your use case was for
forwarding. I understand the local host tcp/udp variant.

>>>> I may be missing something on the cpuid one - seems high likelihood
>>>> of having the same flow on multiple queues (based on what
>>>> raw_smp_processor_id() returns, which i believe is not guaranteed to be
>>>> consistent). IOW, you could be sending packets out of order for the
>>>> same 5 tuple flow (because they end up in different queues).
>>> Yes, but think about one case, we pin one pod to one cpu, so all the
>>> processes of the pod will
>>> use the same cpu. then all packets from this pod will use the same tx queue.
>>
>> To Cong's point - if you already knew the pinned-to cpuid then you could
>> just as easily set that queue map from user space?
> Yes, we can set it from user space. If we can know the cpu which the
> pod uses, and select the one tx queue
> automatically in skbedit, that can make the things easy?

Yes, but you know the CPU - so Cong's point is valid. You knew the
CPU when you setup the cgroup for iperf by hand, you can use the
same hand to set the queue map skbedit.

>>> ip li set dev $NETDEV up
>>>
>>> tc qdisc del dev $NETDEV clsact 2>/dev/null
>>> tc qdisc add dev $NETDEV clsact
>>>
>>> ip link add ipv1 link $NETDEV type ipvlan mode l2
>>> ip netns add n1
>>> ip link set ipv1 netns n1
>>>
>>> ip netns exec n1 ip link set ipv1 up
>>> ip netns exec n1 ifconfig ipv1 2.2.2.100/24 up
>>>
>>> tc filter add dev $NETDEV egress protocol ip prio 1 \
>>> flower skip_hw src_ip 2.2.2.100 action skbedit queue_mapping hash-type cpuid 2 6
>>>
>>> tc qdisc add dev $NETDEV handle 1: root mq
>>>
>>> tc qdisc add dev $NETDEV parent 1:1 handle 2: htb
>>> tc class add dev $NETDEV parent 2: classid 2:1 htb rate 100kbit
>>> tc class add dev $NETDEV parent 2: classid 2:2 htb rate 200kbit
>>>
>>> tc qdisc add dev $NETDEV parent 1:2 tbf rate 100mbit burst 100mb latency 1
>>> tc qdisc add dev $NETDEV parent 1:3 pfifo
>>> tc qdisc add dev $NETDEV parent 1:4 pfifo
>>> tc qdisc add dev $NETDEV parent 1:5 pfifo
>>> tc qdisc add dev $NETDEV parent 1:6 pfifo
>>> tc qdisc add dev $NETDEV parent 1:7 pfifo
>>>
>>> set the iperf3 to one cpu
>>> # mkdir -p /sys/fs/cgroup/cpuset/n0
>>> # echo 4 > /sys/fs/cgroup/cpuset/n0/cpuset.cpus
>>> # echo 0 > /sys/fs/cgroup/cpuset/n0/cpuset.mems
>>> # ip netns exec n1 iperf3 -c 2.2.2.1 -i 1 -t 1000 -P 10 -u -b 10G
>>> # echo $(pidof iperf3) > /sys/fs/cgroup/cpuset/n0/tasks
>>>
>>> # ethtool -S eth0 | grep -i tx_queue_[0-9]_bytes
>>>        tx_queue_0_bytes: 7180
>>>        tx_queue_1_bytes: 418
>>>        tx_queue_2_bytes: 3015
>>>        tx_queue_3_bytes: 4824
>>>        tx_queue_4_bytes: 3738
>>>        tx_queue_5_bytes: 716102781 # before setting iperf3 to cpu 4
>>>        tx_queue_6_bytes: 17989642640 # after setting iperf3 to cpu 4,
>>> skbedit use this tx queue, and don't use tx queue 5
>>>        tx_queue_7_bytes: 4364
>>>        tx_queue_8_bytes: 42
>>>        tx_queue_9_bytes: 3030
>>>
>>>
>>> # tc -s class show dev eth0
>>> class mq 1:1 root leaf 2:
>>>    Sent 9874 bytes 63 pkt (dropped 0, overlimits 0 requeues 0)
>>>    backlog 0b 0p requeues 0
>>> class mq 1:2 root leaf 8001:
>>>    Sent 418 bytes 3 pkt (dropped 0, overlimits 0 requeues 0)
>>>    backlog 0b 0p requeues 0
>>> class mq 1:3 root leaf 8002:
>>>    Sent 3015 bytes 13 pkt (dropped 0, overlimits 0 requeues 0)
>>>    backlog 0b 0p requeues 0
>>> class mq 1:4 root leaf 8003:
>>>    Sent 4824 bytes 8 pkt (dropped 0, overlimits 0 requeues 0)
>>>    backlog 0b 0p requeues 0
>>> class mq 1:5 root leaf 8004:
>>>    Sent 4074 bytes 19 pkt (dropped 0, overlimits 0 requeues 0)
>>>    backlog 0b 0p requeues 0
>>> class mq 1:6 root leaf 8005:
>>>    Sent 716102781 bytes 480624 pkt (dropped 0, overlimits 0 requeues 0)
>>>    backlog 0b 0p requeues 0
>>> class mq 1:7 root leaf 8006:
>>>    Sent 18157071781 bytes 12186100 pkt (dropped 0, overlimits 0 requeues 18)
>>>    backlog 0b 0p requeues 18
>>> class mq 1:8 root
>>>    Sent 4364 bytes 26 pkt (dropped 0, overlimits 0 requeues 0)
>>>    backlog 0b 0p requeues 0
>>> class mq 1:9 root
>>>    Sent 42 bytes 1 pkt (dropped 0, overlimits 0 requeues 0)
>>>    backlog 0b 0p requeues 0
>>> class mq 1:a root
>>>    Sent 3030 bytes 13 pkt (dropped 0, overlimits 0 requeues 0)
>>>    backlog 0b 0p requeues 0
>>> class tbf 8001:1 parent 8001:
>>>
>>> class htb 2:1 root prio 0 rate 100Kbit ceil 100Kbit burst 1600b cburst 1600b
>>>    Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>>>    backlog 0b 0p requeues 0
>>>    lended: 0 borrowed: 0 giants: 0
>>>    tokens: 2000000 ctokens: 2000000
>>>
>>> class htb 2:2 root prio 0 rate 200Kbit ceil 200Kbit burst 1600b cburst 1600b
>>>    Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>>>    backlog 0b 0p requeues 0
>>>    lended: 0 borrowed: 0 giants: 0
>>>    tokens: 1000000 ctokens: 1000000
>>>
>>
>> Yes, if you pin a flow/process to a cpu - this is expected. See my
>> earlier comment. You could argue that you are automating things but
>> it is not as a strong as the hash setup (and will have to be documented
>> that it works only if you pin processes doing network i/o to cpus).
> Ok, it should be documented in iproute2. and we will doc this in
> commit message too.

I think this part is iffy. You could argue automation pov
but i dont see much else.

>> Could you also post an example on the cgroups classid?
> 
> The setup commands:
> NETDEV=eth0
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
> flower skip_hw src_ip 2.2.2.100 action skbedit queue_mapping hash-type
> classid 2 6
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
> setup classid
> # mkdir -p /sys/fs/cgroup/net_cls/n0
> # echo 0x100001 > /sys/fs/cgroup/net_cls/n0/net_cls.classid
> # echo $(pidof iperf3) > /sys/fs/cgroup/net_cls/n0/tasks
> 


I would say some thing here as well. You know the classid, you manually
set it above, you could have said:

src_ip 2.2.2.100 action skbedit queue_mapping 1

cheers,
jamal

