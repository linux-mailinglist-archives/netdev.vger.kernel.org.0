Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15C04B7BAE
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 01:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237470AbiBPARw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 19:17:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiBPARv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 19:17:51 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB1E5F85
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 16:17:38 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id g24so370450qkl.3
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 16:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LXXohFohWtk3A40QmzsojwJHplBXzapPwHo59ri0+C8=;
        b=Z91IRJHLsFjXyclo6WPTjseLkgCj13SH8YjddghQ9UmNgqavyk66+TIQ3eoQBSOUMg
         f0jIhCJsLqyha/zR77amepywMX4AhHEql3o59XVII3DB5sVaphImXdfJuMQZGlaTZEFg
         yLS6/SCDyvXDx/YEwWuQJWqxLx5Xayk2sl4rHY/jL0B3LwSc15YG/tq7o7kRUxLBa7m6
         v/17DOxsczLCWaxduGkXLM2evam6nR1Yd6COy8rocpBeJ+fyt5mjZ+Y8QLXpukplsttG
         XsSMUUk2yMOLFsstzPgoY/OfMwmjMpFEcM/Rv5uNSZYiyTlwbUW00zcK8MalpAef1lwF
         y/Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LXXohFohWtk3A40QmzsojwJHplBXzapPwHo59ri0+C8=;
        b=8RH77e8jcpoIxHkpqJeX3VMq8tZg0osX1rzEOgie+OyTEwQOQT/9LVfM2jaiSjYSP6
         C94FKhYQzHzwSYPW4+9cg1laKKt4ebWJhbCzGUK+gfv/z3YXZh2Jyv3zgpqAtqczL0is
         kdo1E9z93TrLohut0XtW8cSFyXi8SbtNXlDsjVWOf9CJBuiwYMASUvejCcw3X/CwW2oy
         YFEu1NLlI7N4XpKqZz3U99TvmwNrE3JDzKd0twkzY1ZewkKwZyvmhAz6YPGIEYqqV59m
         IzwAvQwaj7YZNCi8nUbEpUPv/Qtl9JI1Ufti/BQWRhV+y4m/K0AaKYIwnl5h71YDd2mC
         w3Ag==
X-Gm-Message-State: AOAM5326ZF4Nn+IkO9B4lzLaWcPBvUEx3mG432s00ahKfzoZ3m6trxy2
        0B9Y1QZv1GMEQVps4E91godnrw==
X-Google-Smtp-Source: ABdhPJwUM33plWNAJT/onKaxKVSQKDxE1WeWXv32uyQEzWiwlv0iNtOgWQRlCKvl6mUHt3yfhfN8Gg==
X-Received: by 2002:a05:620a:2293:b0:600:2b7b:2a19 with SMTP id o19-20020a05620a229300b006002b7b2a19mr198355qkh.408.1644970657886;
        Tue, 15 Feb 2022 16:17:37 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id u17sm17295840qkj.44.2022.02.15.16.17.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 16:17:37 -0800 (PST)
Message-ID: <4e556aff-0295-52d1-0274-a0381b585fbb@mojatatu.com>
Date:   Tue, 15 Feb 2022 19:17:36 -0500
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
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <CAMDZJNVB4FDgv+xrTw2cZisEy2VNn1Dv9RodEhEAsd5H6qwkRA@mail.gmail.com>
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

On 2022-02-14 20:40, Tonghao Zhang wrote:
> On Tue, Feb 15, 2022 at 8:22 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>
>> On 2022-01-26 09:32, xiangxia.m.yue@gmail.com wrote:
>>> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>>>

>
>> So while i dont agree that ebpf is the solution for reasons i mentioned
>> earlier - after looking at the details think iam confused by this change
>> and maybe i didnt fully understand the use case.
>>
>> What is the driver that would work  with this?
>> You said earlier packets are coming out of some pods and then heading to
>> the wire and you are looking to balance and isolate between bulk and
>> latency  sensitive traffic - how are any of these metadatum useful for
>> that? skb->priority seems more natural for that.

Quote from your other email:

 > In our production env, we use the ixgbe, i40e and mlx nic which
 > support multi tx queue.

Please bear with me.
The part i was wondering about is how these drivers would use queue
mapping to select their hardware queues.
Maybe you meant the software queue (in the qdiscs?) - But even then
how does queue mapping map select which queue is to be used.

> Hi
> I try to explain. there are two tx-queue range, e.g. A(Q0-Qn), B(Qn+1-Qm).
> A is used for latency sensitive traffic. B is used for bulk sensitive
> traffic. A may be shared by Pods/Containers which key is
> high throughput. B may be shared by Pods/Containers which key is low
> latency. So we can do the balance in range A for latency sensitive
> traffic.

So far makes sense. I am not sure if you get better performance but
thats unrelated to this discussion. Just trying to understand your
setup  first in order to understand the use case. IIUC:
You have packets coming out of the pods and hitting the host stack
where you are applying these rules on egress qdisc of one of these
ixgbe, i40e and mlx nics, correct?
And that egress qdisc then ends up selecting a queue based on queue
mapping?

Can you paste a more complete example of a sample setup on some egress
port including what the classifier would be looking at?
Your diagram was unclear how the load balancing was going to be
achieved using the qdiscs (or was it the hardware?).

> So we can use the skb->hash or CPUID or classid to classify the
> packets in range A or B. The balance policies are used for different
> use case.
> For skb->hash, the packets from Pods/Containers will share the range.
> Should to know that one Pod/Container may use the multi TCP/UDP flows.
> That flows share the tx queue range.
> For CPUID, while Pod/Container use the multi flows, pod pinned on one
> CPU will use one tx-queue in range A or B.
> For CLASSID, the Pod may contain the multi containters.
> 
> skb->priority may be used by applications. we can't require
> application developer to change them.

It can also be set by skbedit.
Note also: Other than user specifying via setsockopt and skbedit,
DSCP/TOS/COS are all translated into skb->priority. Most of those
L3/L2 fields are intended to map to either bulk or latency sensitive
traffic.
More importantly:
 From s/w level - most if not _all_ classful qdiscs look at skb->priority
to decide where to enqueue.
 From h/w level - skb->priority is typically mapped to qos hardware level
(example 802.1q).
Infact skb->priority could be translated by qdisc layer into
classid if you set the 32 bit value to be the major:minor number for
a specific configured classid.

cheers,
jamal
