Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26531514C99
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 16:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376794AbiD2OVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 10:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358148AbiD2OVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 10:21:39 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949BC8FFBB
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 07:18:20 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id r13so15739047ejd.5
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 07:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:from:to:cc
         :references:in-reply-to:content-transfer-encoding;
        bh=QSgzc0vyPfdM2R74h+fDAaKGxEkHW/J6GntJH/+8MqA=;
        b=JErjgbrGSCuxkZSPXdXs662X6qLQdm2y9B6kAp85o6xrHVLdlC8F2OKVKlasmfV0VD
         oUuOBZzjkjlcsO8BgbDE/PUx4+HGFxnB2WnAr6pjLfpmDf8LzN5E6VfV3+rOeb2SgKNd
         QpNBlHz2V8N0pwdR1FrceUuWfkw62IIZGmiWGsaDw87TVLkKhjqs14ZK1HgwqPjuZURJ
         cxjayRv06hYSKFJjmbz5uAioOrtkGlBunuj9XhJDW0IrEjrhvoKGjGrpzZIbmpXtQLze
         8m4u/C+tDu/zqkuN4Unju+SewE7qH1UUX35amdRXdmQD6IaO8Phmu3nUIX2EbQBfT5sl
         r37w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=QSgzc0vyPfdM2R74h+fDAaKGxEkHW/J6GntJH/+8MqA=;
        b=WqrXB/9DckzAZEVdxex8+iT3FsGn9RYFYfCd5EPErwLajREWljTHyV4Ra83mKKGFTB
         nAf7hO+T/twdohKQ+8z2+hpI9ufdvCh6HHLx2DzdxPq0I0EFXp/TDiv5wmTZG9G7GM4D
         XfhDE2BeeW7LkI/V+urokXSNZqFQe+BKljPp2Hg8Grb1Sb2teuJVTSGllsXwc4mA3JYS
         PHGE4h/xhdqeVoT2aGXtkdfRFGpFOqcxvHSHg0VCI6q49J2+wqE4+lg/wkbljlG1rX0h
         kDGKtCY70vLi1CSuPgu+PRto3k81joE7C+aBRg1JU2UFK7RDgiViQ1EGcrsm3j/ODhRt
         Ygpw==
X-Gm-Message-State: AOAM532j+NB2Li6vj8geNixL88cRWihwygK3JsNfDKpQioTFHFy1Kg9L
        TncQNAnytjVfpfFV8lrOdJs=
X-Google-Smtp-Source: ABdhPJyxDAQvouWAeDbrXTAnhgRx7IiZ7XBa7/bMsNyRGDs1v1dtJDx9kHoW5KZPnS3NXdeErGMdyA==
X-Received: by 2002:a17:907:105d:b0:6f3:a3ea:cdfd with SMTP id oy29-20020a170907105d00b006f3a3eacdfdmr20718562ejb.704.1651241897738;
        Fri, 29 Apr 2022 07:18:17 -0700 (PDT)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id yo1-20020a170907136100b006f3ef214e0dsm689472ejb.115.2022.04.29.07.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 07:18:16 -0700 (PDT)
Message-ID: <9f958aae-8293-377c-6f30-743d9c3f3ce0@gmail.com>
Date:   Fri, 29 Apr 2022 16:18:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: Optimizing kernel compilation / alignments for network
 performance
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Felix Fietkau <nbd@nbd.name>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
 <20220427125658.3127816-1-alexandr.lobakin@intel.com>
 <066fc320-dc04-11a4-476e-b0d11f3b17e6@gmail.com>
In-Reply-To: <066fc320-dc04-11a4-476e-b0d11f3b17e6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.04.2022 19:31, Rafał Miłecki wrote:
> On 27.04.2022 14:56, Alexander Lobakin wrote:
>> From: Rafał Miłecki <zajec5@gmail.com>
>> Date: Wed, 27 Apr 2022 14:04:54 +0200
>>
>>> I noticed years ago that kernel changes touching code - that I don't use
>>> at all - can affect network performance for me.
>>>
>>> I work with home routers based on Broadcom Northstar platform. Those
>>> are SoCs with not-so-powerful 2 x ARM Cortex-A9 CPU cores. Main task of
>>> those devices is NAT masquerade and that is what I test with iperf
>>> running on two x86 machines.
>>>
>>> ***
>>>
>>> Example of such unused code change:
>>> ce5013ff3bec ("mtd: spi-nor: Add support for XM25QH64A and XM25QH128A").
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ce5013ff3bec05cf2a8a05c75fcd520d9914d92b
>>> It lowered my NAT speed from 381 Mb/s to 367 Mb/s (-3,5%).
>>>
>>> I first reported that issue it in the e-mail thread:
>>> ARM router NAT performance affected by random/unrelated commits
>>> https://lkml.org/lkml/2019/5/21/349
>>> https://www.spinics.net/lists/linux-block/msg40624.html
>>>
>>> Back then it was commit 5b0890a97204 ("flow_dissector: Parse batman-adv
>>> unicast headers")
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9316a9ed6895c4ad2f0cde171d486f80c55d8283
>>> that increased my NAT speed from 741 Mb/s to 773 Mb/s (+4,3%).
>>>
>>> ***
>>>
>>> It appears Northstar CPUs have little cache size and so any change in
>>> location of kernel symbols can affect NAT performance. That explains why
>>> changing unrelated code affects anything & it has been partially proven
>>> aligning some of cache-v7.S code.
>>>
>>> My question is: is there a way to find out & force an optimal symbols
>>> locations?
>>
>> Take a look at CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B[0]. I've been
>> fighting with the same issue on some Realtek MIPS boards: random
>> code changes in random kernel core parts were affecting NAT /
>> network performance. This option resolved this I'd say, for the cost
>> of slightly increased vmlinux size (almost no change in vmlinuz
>> size).
>> The only thing is that it was recently restricted to a set of
>> architectures and MIPS and ARM32 are not included now lol. So it's
>> either a matter of expanding the list (since it was restricted only
>> because `-falign-functions=` is not supported on some architectures)
>> or you can just do:
>>
>> make KCFLAGS=-falign-functions=64 # replace 64 with your I-cache size
>>
>> The actual alignment is something to play with, I stopped on the
>> cacheline size, 32 in my case.
>> Also, this does not provide any guarantees that you won't suffer
>> from random data cacheline changes. There were some initiatives to
>> introduce debug alignment of data as well, but since function are
>> often bigger than 32, while variables are usually much smaller, it
>> was increasing the vmlinux size by a ton (imagine each u32 variable
>> occupying 32-64 bytes instead of 4). But the chance of catching this
>> is much lower than to suffer from I-cache function misplacement.
> 
> Thank you Alexander, this appears to be helpful! I decided to ignore
> CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B for now and just adjust CFLAGS
> manually.
> 
> 
> 1. Without ce5013ff3bec and with -falign-functions=32
> 387 Mb/s
> 
> 2. Without ce5013ff3bec and with -falign-functions=64
> 377 Mb/s
> 
> 3. With ce5013ff3bec and with -falign-functions=32
> 384 Mb/s
> 
> 4. With ce5013ff3bec and with -falign-functions=64
> 377 Mb/s
> 
> 
> So it seems that:
> 1. -falign-functions=32 = pretty stable high speed
> 2. -falign-functions=64 = very stable slightly lower speed
> 
> 
> I'm going to perform tests on more commits but if it stays so reliable
> as above that will be a huge success for me.

So sadly that doesn't work all the time. Or maybe just works randomly.

I tried multiple commits with both: -falign-functions=32 and
-falign-functions=64 . I still get speed variations. About 30 Mb/s in
total. From commit to commit it's usually about 3% but skipping few can
result in up to 30 Mb/s (almost 10%).

Similarly to code changes performance also gets affected by enabling /
disabling kernel config options. I noticed that enabling
CONFIG_CRYPTO_PCRYPT may decrease *or* increase speed depending on
-falign-functions (and depending on kernel commit surely too).

┌──────────────────────┬───────────┬──────────┬───────┐
│                      │ no PCRYPT │ PCRYPT=y │ diff  │
├──────────────────────┼───────────┼──────────┼───────┤
│ No -falign-functions │ 363 Mb/s  │ 370 Mb/s │ +2%   │
│ -falign-functions=32 │ 364 Mb/s  │ 370 Mb/s │ +1,7% │
│ -falign-functions=64 │ 372 Mb/s  │ 365 Mb/s │ -2%   │
└──────────────────────┴───────────┴──────────┴───────┘

So I still don't have a reliable way of testing kernel changes for speed
regressions :(
