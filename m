Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827DE4F849C
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 18:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345596AbiDGQMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 12:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbiDGQMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 12:12:53 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793647665D
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 09:10:52 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r13so8545739wrr.9
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 09:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=x3pmqaNa0PtoIU8gER1caXrBLSF1ODzqLerDmxXVK74=;
        b=MgRcFKvzVOm0BRJ319dcP8h1WJEwcpMeVvWHzlMWQr0kErX58XxhIu7uM1vZ0ppypR
         LZhIW2MhkAeb1lep7tKBBvc/Bx1daATg6H0d8iJcak05ID3LNkRl1I21jJDE8tnwdywY
         5x8nJQHS4JNm8I7KCMbjnWQOx2ji0VycJiunDlt9/CVHtp6Q9JdkK41obWdoNhMd68cX
         OwUXm0x/HcMIAcTbwhZsxI3dNpA2/9q1teuEl9daUDS0hPYh/+n/ksmmi+K92PMhUH9b
         4jVWenunsBgb7yAwVgMqQotVzS0oouIz+ZuEXQFXB3cXWxJ/oPdgElH9k8HCXeaA997o
         Aq9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=x3pmqaNa0PtoIU8gER1caXrBLSF1ODzqLerDmxXVK74=;
        b=S+LWIa1grpSG5gNL/g9IsLGjORVmtLna7TB6vGCmgktM3ubMXbqciB8dRbth8oQgDf
         4IOtB60wQ7C/HeEPfKBwOImo7BtcyI3e4XF46gYecSoncXQMWcKfoWimsXYr8/+5urfb
         I8yZXqlSVObXQyTvz6u9I7zlzzJCTaIJZmzzY2lfbugn1NuUjv7OIkTtZyjX/+DVMzT3
         afq49ekYFCSxQbqjaRLGLBFRXxz2hVh40cvzOXZeTMpUFqqjumX2s4YQinUQyq3u4iCS
         antEuplkWY7b967jt5TbDb43f91ozQiIIBGlprnqvqEeZqJq43rrcOiyWs0H+Lo8c86u
         9GOw==
X-Gm-Message-State: AOAM532JaOx7amljXa9mChE/0TCJsiBO4vo3qOshpYo8MPs5xAaAeIxd
        pIyfjh5v0LFBMzU1/r8AEKNFOw==
X-Google-Smtp-Source: ABdhPJw3v3eQrWyaBWPZCs/0STYwsAh4zpwNJHkq77RkY9jCBCfXuw86xtXgxD9aX1BYf7EwzrEKNg==
X-Received: by 2002:adf:f90e:0:b0:203:e0fd:e9af with SMTP id b14-20020adff90e000000b00203e0fde9afmr11446956wrr.154.1649347850954;
        Thu, 07 Apr 2022 09:10:50 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:6115:f172:4f40:31e9? ([2a01:e0a:b41:c160:6115:f172:4f40:31e9])
        by smtp.gmail.com with ESMTPSA id f9-20020adff589000000b002060fcd92e9sm11380422wro.14.2022.04.07.09.10.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 09:10:50 -0700 (PDT)
Message-ID: <59150cd5-9950-2479-a992-94dcdaa5e63c@6wind.com>
Date:   Thu, 7 Apr 2022 18:10:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] ipv6:fix crash when idev is NULL
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        kongweibin <kongweibin2@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Vasily Averin <vvs@virtuozzo.com>,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, rose.chen@huawei.com,
        liaichun@huawei.com
References: <20220407112512.2099221-1-kongweibin2@huawei.com>
 <CANn89iLx5HRnyRShNatPveTBhdjoQTxaRn-8_gYk-6_NuSCiOQ@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <CANn89iLx5HRnyRShNatPveTBhdjoQTxaRn-8_gYk-6_NuSCiOQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 07/04/2022 à 16:08, Eric Dumazet a écrit :
[snip]
> 
> And CC patch author for feedback.
Thanks Eric.

> 
> In this case I suspect:
> 
> commit ccd27f05ae7b8ebc40af5b004e94517a919aa862
> Author: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Date:   Tue Jul 6 11:13:35 2021 +0200
> 
>     ipv6: fix 'disable_policy' for fwd packets
I agree.

> 
> 
> 
>> ---
>>  net/ipv6/ip6_output.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
>> index 54cabf1c2..347b5600d 100644
>> --- a/net/ipv6/ip6_output.c
>> +++ b/net/ipv6/ip6_output.c
>> @@ -495,6 +495,9 @@ int ip6_forward(struct sk_buff *skb)
>>         u32 mtu;
>>
>>         idev = __in6_dev_get_safely(dev_get_by_index_rcu(net, IP6CB(skb)->iif));
>> +       if (!idev)
>> +               goto drop;
>> +
>>         if (net->ipv6.devconf_all->forwarding == 0)
>>                 goto error;

Dropping packet in this case may introduce another regression, because there was
no drop before commit ccd27f05ae7b ("ipv6: fix 'disable_policy' for fwd packets").

Maybe something like this:
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -485,7 +485,7 @@ int ip6_forward(struct sk_buff *skb)
                goto drop;

        if (!net->ipv6.devconf_all->disable_policy &&
-           !idev->cnf.disable_policy &&
+           (!idev || !idev->cnf.disable_policy) &&
            !xfrm6_policy_check(NULL, XFRM_POLICY_FWD, skb)) {
                __IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);
                goto drop;

I could submit it formally tomorrow.


Regards,
Nicolas
