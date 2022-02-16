Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24214B9495
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 00:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238562AbiBPXjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 18:39:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbiBPXja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 18:39:30 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDED817186F
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 15:39:14 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id h9so5108700qvm.0
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 15:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hnmhp4lz64lw0c/CFajcTvxHAsHoRy5ynkPxCPOvbQc=;
        b=YwftTNt23Q6+dzjZnBUKneObKWoO96cRvMfOiJWiXzu89zP3CHHNKhZjuCGnTdzm3c
         WjjGPTscGk7WCpbMoyO1vO6XCA0ehckqoVW3aNh4LR6/5SDLY0gqimhZWmt+Tvi4Ot4v
         sgm3R6p/tX5LBxqoNWhF6GILNn/5RJ4Wcz0harB3879BBa7QTqExCk0NejFwhwWWpWI8
         ekpu7UmyS8SxLzpayf+2PwP+Or9uQx7CunE4nU99r8pERskleOghluvHucK1icKGacPB
         +dDW+gojELPr01b9VckOIfUewDwpE1eIStfx3h8dmpxdITXS7UGCLib4zPBO/5B95lhY
         R9YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hnmhp4lz64lw0c/CFajcTvxHAsHoRy5ynkPxCPOvbQc=;
        b=AMYLL6ldX6pNgZNPw/pLFfRnzlOXcGOVoZnEDN+YjdI9Va32niO+uBBgseIRfJgwwV
         Sn0I+GDR8wi4lHHGhRpY+utmc1M7rjYYvVsNRvHf3z0kg6+Maevg+QNT7/20bGT1y+WC
         xj5ihcGakaKfjbyChQDvDUvn07EirQN9RE322VXCXhWAF2t1GFJEkETSE0z2NykE5RGd
         J36+9RB1hwIgPxMIflDrhpetNz6o5DMCDDEdmj7hiUsO2SBdRNXfkq69b2PRhjNyfsr7
         +esmT4sU08awfR+RvksBnfgPEdJSLXGkA8Yk7og3CCWl+Yt2wqvpda4NNjN0joN1Yc9z
         n1eA==
X-Gm-Message-State: AOAM530HPFXoaMbZYVDgTJsY94Ua1sUs0DbMKLbas5VeW8cKl5ChsrSd
        duXS3ukPjYgTJRWJ4Wat0P1pcA==
X-Google-Smtp-Source: ABdhPJzQVqVcVnggzLfVay6Yg2nkCP8AmFXHlyDRkUJdECTpiqTvJcl+yXNjE6b+imV+QBhDFbCpVQ==
X-Received: by 2002:a05:622a:1011:b0:2d2:4ec7:6cda with SMTP id d17-20020a05622a101100b002d24ec76cdamr323801qte.522.1645054753770;
        Wed, 16 Feb 2022 15:39:13 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id bp18sm13842503qtb.72.2022.02.16.15.39.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 15:39:12 -0800 (PST)
Message-ID: <7a6b7a74-82f5-53e7-07f4-2a995df9f349@mojatatu.com>
Date:   Wed, 16 Feb 2022 18:39:11 -0500
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
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <CAMDZJNXbxstEvFoF=ZRD_PwH6HQc17LEn0tSvFTJvKB9aoW6Aw@mail.gmail.com>
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

On 2022-02-16 08:36, Tonghao Zhang wrote:
> On Wed, Feb 16, 2022 at 8:17 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:


[...]
The mapping to hardware made sense. Sorry I missed it earlier.

>> Can you paste a more complete example of a sample setup on some egress
>> port including what the classifier would be looking at?
> Hi
> 
>    +----+      +----+      +----+     +----+
>    | P1 |      | P2 |      | PN |     | PM |
>    +----+      +----+      +----+     +----+
>      |           |           |           |
>      +-----------+-----------+-----------+
>                         |
>                         | clsact/skbedit
>                         |      MQ
>                         v
>      +-----------+-----------+-----------+
>      | q0        | q1        | qn        | qm
>      v           v           v           v
>    HTB/FQ      HTB/FQ  ...  FIFO        FIFO
> 

Below is still missing your MQ setup (If i understood your diagram
correctly). Can you please post that?
Are you classids essentially mapping to q0..m?
tc -s class show after you run some traffic should help

> NETDEV=eth0
> tc qdisc add dev $NETDEV clsact
> tc filter add dev $NETDEV egress protocol ip prio 1 flower skip_hw
> src_ip 192.168.122.100 action skbedit queue_mapping hash-type skbhash
> n m
> 

Have you observed a nice distribution here?
for s/w side tc -s class show after you run some traffic should help
for h/w side ethtool -s

IIUC, the hash of the ip header with src_ip 192.168.122.100
(and dst ip,
is being distributed across queues n..m
[because either 192.168.122.100 is talking to many destination
IPs and/or ports?]
Is this correct if packets are being forwarded as opposed to
being sourced from the host?
ex: who sets the skb->hash (skb->l4_hash, skb->sw_hash etc)

> The packets from pod(P1) which ip is 192.168.122.100, will use the txqueue n ~m.
> P1 is the pod of latency sensitive traffic. so P1 use the fifo qdisc.
> 
> tc filter add dev $NETDEV egress protocol ip prio 1 flower skip_hw
> src_ip 192.168.122.200 action skbedit queue_mapping hash-type skbhash
> 0 1
> 
> The packets from pod(P2) which ip is 192.168.122.200, will use the txqueue 0 ~1.
> P2 is the pod of bulk sensitive traffic. so P2 use the htb qdisc to
> limit its network rate, because we don't hope P2 use all bandwidth to
> affect P1.
> 

Understood.

>> Your diagram was unclear how the load balancing was going to be
>> achieved using the qdiscs (or was it the hardware?).
> Firstly, in clsact hook, we select one tx queue from qn to qm for P1,
> and use the qdisc of this tx queue, for example FIFO.
> in underlay driver, because the we set the skb->queue_mapping in
> skbedit, so the hw tx queue from qn to qm will be select too.
> any way, in clsact hook, we can use the skbedit queue_mapping to
> select software tx queue and hw tx queue.
> 

ethtool -s and tc -s class if you have this running somewhere..

> For doing balance, we can use the skbhash/cpuid/cgroup classid to
> select tx queue from qn to qm for P1.
> tc filter add dev $NETDEV egress protocol ip prio 1 flower skip_hw
> src_ip 192.168.122.100 action skbedit queue_mapping hash-type cpuid n
> m
> tc filter add dev $NETDEV egress protocol ip prio 1 flower skip_hw
> src_ip 192.168.122.100 action skbedit queue_mapping hash-type classid
> n m
> 

The skbhash should work fine if you have good entropy (varying dst ip
and dst port mostly, the srcip/srcport/protocol dont offer much  entropy
unless you have a lot of pods on your system).
i.e if it works correctly (forwarding vs host - see my question above)
then you should be able to pin a 5tuple flow to a tx queue.
If you have a large number of flows/pods then you could potentially
get a nice distribution.

I may be missing something on the cpuid one - seems high likelihood
of having the same flow on multiple queues (based on what
raw_smp_processor_id() returns, which i believe is not guaranteed to be
consistent). IOW, you could be sending packets out of order for the
same 5 tuple flow (because they end up in different queues).

As for classid variant - if these packets are already outside the
pod and into the host stack, is that field even valid?

> Why we want to do the balance, because we don't want pin the packets
> from Pod to one tx queue. (in k8s the pods are created or destroy
> frequently, and the number of Pods > tx queue number).
> sharing the tx queue equally is more important.
> 

As long as the same flow is pinned to the same queue (see my comment
on cpuid).
Over a very long period what you describe maybe true but it also
seems depends on many other variables.
I think it would help to actually show some data on how true above
statement is (example the creation/destruction rate of the pods).
Or collect data over a very long period.

cheers,
jamal
