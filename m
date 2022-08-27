Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD785A3801
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 15:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbiH0Ny2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 09:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiH0Ny1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 09:54:27 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74982FFF6
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 06:54:25 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id cu2so7844173ejb.0
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 06:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=8CiaLkECx3krBdKp6oIvGxj9L4zpqrT521rHLsVwe9c=;
        b=g1jkYz6hbaud7MJPfP0jk8kKHIWsdovgRzcgSUPODZpbjnDzLbWqeUUvMfhcoOvP2o
         htWSK5oUojOo772tVxb2ovafBDv5nHDssuSAXh0GJ8cr7DNbVH/vcT15T6DsrywtkG5L
         9N2MXav1SOO5iaoM2/si+QncOtmAC0ORMqsdfWEui/zHqOVusXm259fNbVucOTCO+opN
         5uXJo1y/7kZboMlhv5jq7zi5Bl/1QIwfHlz+GnMU49Cg/+iICR3oJzR79/HXC4KyJO1N
         JcH24SsTQu4KQUwyRQaXQbX4+AADrP7Ie842gQXGkPCgI4H7n1r5lA5bPBLHy+glgCN6
         L/Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=8CiaLkECx3krBdKp6oIvGxj9L4zpqrT521rHLsVwe9c=;
        b=d2wkBlgQsdRMKQ/gaGlPpSD0WHhC/d2HKK1Cz8d9bnHA7EFHpTdVUWuzWkFllaJDmK
         oAXz6qr2skhmJop4ftSejPImlPIyIq24GdYeRQpw847VoZEOONUTIdErf2G3kFjy4Ytj
         0IAhAS5JqjAbaLDYj1hMJykuO5ibABcEqWE/JpwNB3lBH3PFmka99MTr3OQoAYoqTaJp
         PHvg6RWqd+GSJVmcBOsnq6kw9s6zRgvcN4NodBLlkKvTK3DwQFUP0ruBhDIH7Do2zc58
         uvqPIzpIZNBjl34Z5SHpAs+lXNGT93wd1SbCm6/l19p1ICIHsYpCtdmeabTzQsn+BVov
         l33A==
X-Gm-Message-State: ACgBeo2vxK3y5hTDs+a4Fqx6eVhhqm9D1iTADbEixtDfWH3BScBSVk7n
        mKo0DQDZUy7Djvyb1MPAzh6aP/vlH3tWzSnfy7A=
X-Google-Smtp-Source: AA6agR7Ggm9FNAtOJDfVc+2duDQAqokmt0wFwHO5MhLEgQCeXkyrdXp9PBkVxYqT3pzjDOoS/CBgwA==
X-Received: by 2002:a17:906:6a03:b0:730:a20e:cf33 with SMTP id qw3-20020a1709066a0300b00730a20ecf33mr8607603ejc.620.1661608464159;
        Sat, 27 Aug 2022 06:54:24 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id c17-20020a17090618b100b007311eb42e40sm2107674ejf.54.2022.08.27.06.54.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Aug 2022 06:54:23 -0700 (PDT)
Message-ID: <d1de0337-ae16-7dca-b212-1a4e85129c31@blackwall.org>
Date:   Sat, 27 Aug 2022 16:54:21 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v5 net-next 1/6] net: bridge: add locked entry fdb flag to
 extend locked port feature
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Hans Schultz <netdev@kapio-technology.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
References: <20220826114538.705433-1-netdev@kapio-technology.com>
 <20220826114538.705433-2-netdev@kapio-technology.com>
 <e9eb5b72-073a-f182-13b7-37fc53611d5f@blackwall.org>
 <YwoZdzVCkMV8vGtl@shredder>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <YwoZdzVCkMV8vGtl@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/08/2022 16:17, Ido Schimmel wrote:
> On Sat, Aug 27, 2022 at 02:30:25PM +0300, Nikolay Aleksandrov wrote:
>> On 26/08/2022 14:45, Hans Schultz wrote:
>> Please add the blackhole flag in a separate patch.
> 
> +1
> 
> [...]
> 
>>> @@ -185,6 +196,9 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>>  		if (test_bit(BR_FDB_LOCAL, &dst->flags))
>>>  			return br_pass_frame_up(skb);
>>>  
>>> +		if (test_bit(BR_FDB_BLACKHOLE, &dst->flags))
>>> +			goto drop;
>>> +
>> Not happy about adding a new test in arguably the most used fast-path, but I don't see
>> a better way to do blackhole right now. Could you please make it an unlikely() ?
>>
>> I guess the blackhole flag will be allowed for user-space to set at some point, why
>> not do it from the start?
>>
>> Actually adding a BR_FDB_LOCAL and BR_FDB_BLACKHOLE would be a conflict above -
>> the packet will be received. So you should move the blackhole check above the
>> BR_FDB_LOCAL one if user-space is allowed to set it to any entry.
> 
> Agree about unlikely() and making it writeable from user space from the
> start. This flag is different from the "locked" flag that should only be
> ever set by the kernel.
> 
> Regarding BR_FDB_LOCAL, I think BR_FDB_BLACKHOLE should only be allowed
> with BR_FDB_LOCAL as these entries are similar in the following ways:
> 
> 1. It doesn't make sense to associate a blackhole entry with a specific
> port. The packet will never be forwarded to this port, but dropped by
> the bridge. This means user space will add them on the bridge itself:
> 

Right, good point.

> # bridge fdb add 00:11:22:33:44:55 dev br0 self local blackhole
> 
> 2. If you agree that these entries should not be associated with a
> specific port, then it also does not make sense to subject them to
> ageing and roaming, just like existing local/permanent entries.
> 
> The above allows us to push the new check under the BR_FDB_LOCAL check:
> 

hmm.. so only the driver will be allowed to add non-BR_FDB_LOCAL blackhole
entries with locked flag set as well, that sounds ok as they will be extern_learn
and enforced by it. It is a little discrepancy as we cannot add similar entries in SW
but it really doesn't make any sense to have blackhole fdbs pointing to a port.
SW won't be able to have a locked entry w/ blackhole set, but I like that it is hidden
in the fdb local case when fwding and that's good enough for me.

> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index 68b3e850bcb9..4357445529a5 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -182,8 +182,11 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>         if (dst) {
>                 unsigned long now = jiffies;
>  
> -               if (test_bit(BR_FDB_LOCAL, &dst->flags))
> +               if (test_bit(BR_FDB_LOCAL, &dst->flags)) {
> +                       if (unlikely(test_bit(BR_FDB_BLACKHOLE, &dst->flags)))
> +                               goto drop;
>                         return br_pass_frame_up(skb);
> +               }
>  
>                 if (now != dst->used)
>                         dst->used = now;

