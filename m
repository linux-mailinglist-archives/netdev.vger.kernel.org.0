Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEEB52DADC
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 19:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242417AbiESRLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 13:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbiESRLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 13:11:17 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551A2140F4;
        Thu, 19 May 2022 10:11:16 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id pq9-20020a17090b3d8900b001df622bf81dso5800312pjb.3;
        Thu, 19 May 2022 10:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=y6OjDxOQRwuvH78XVR01DIVKNTgQ0Q7yKBb/rit7+xA=;
        b=IHORutaKe4ppK6InBQv0GNjSWd2++frTadPRrNRvVWB2jCYC5jB0D5jY8Pbb+1SAF7
         H5pyrBufm4yuwxHCDzD6JpuR8PiRjAQOImZeBididWjQ4xxcTQc9zEr4ENFrP22nk/Sa
         jJS4P7/QutWGHO8kliCLBVpejEDbXsfStJTgXPVzJMYkh/0k8LBcSisjNTW0LK/TBbF3
         xtojUxtkxnDBqpaeppo+8UobdHaRHpamk7/OeYdk36dJCuyuionJpGusdK/j8d1jCgac
         t1u8DUanEItM/G2jh82nUhbp01ZeLKNJ6TukEyamQVUcEIf/uE9LCWXN8WXHrXLdoCDn
         ZvoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y6OjDxOQRwuvH78XVR01DIVKNTgQ0Q7yKBb/rit7+xA=;
        b=o8OkqOiGUsm2Xhcv25PMLH36qUkb2klqWji2JCcpiaDQ4UGUp+l0Ipn84Sy0IbZynu
         b8uqZ+i57cB/ZZEJ62yii6cEyqjJCXp/4Al5lD/WJQ7bmXAb/1GjUvgV9kdP3qga7RhB
         TIIziYhWX6Y3qulcFw3OymMnh8LfFB/8ICKL+PxgLjPv4qHKOIt+m2U+ailw4bRI5GI2
         8gpS1IsQcwNJPQ+VAaMM7mMrnpB+BNHM+eGeeq3/SCT8rV6BQ40DBAkky7z/MWYukHa6
         BQTzHRySY7JY4tstHPvsR6nGaH57PxpjsdLSxXrqI6/1oUpAK3NqWRzP9ADEcfzfhVM7
         OAjA==
X-Gm-Message-State: AOAM5326BdUR6joNwgi+10AabcACHfs2N3ohRrQusOzxC2sgWlIJ3xCt
        3hrEf2jAbnkVhqGxA0sibnM=
X-Google-Smtp-Source: ABdhPJwX049Tvsbi1cmWaDlUQdXkur0qJSK86fZeYKVHGz+WIa7YMp6J9/E/3e8N6mZ9qjmUiSbipA==
X-Received: by 2002:a17:90a:5ae1:b0:1db:d0a4:30a4 with SMTP id n88-20020a17090a5ae100b001dbd0a430a4mr6143016pji.128.1652980275734;
        Thu, 19 May 2022 10:11:15 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id c9-20020a170902b68900b0016162e01553sm3949929pls.168.2022.05.19.10.11.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 May 2022 10:11:15 -0700 (PDT)
Message-ID: <c16384a3-d868-11e7-ceed-bc8e7029962a@gmail.com>
Date:   Thu, 19 May 2022 10:11:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net-next v2 2/5] net: dsa: add out-of-band tagging
 protocol
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
References: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
 <20220514150656.122108-3-maxime.chevallier@bootlin.com>
 <20220514224002.vvmd43lnjkbsw2g3@skbuf> <20220517090156.3fde5a8f@pc-20.home>
 <20220519145221.odisjsmjojrpuutp@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220519145221.odisjsmjojrpuutp@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/19/2022 7:52 AM, Vladimir Oltean wrote:
> On Tue, May 17, 2022 at 09:01:56AM +0200, Maxime Chevallier wrote:
>> Hi Vlad,
>>
>> On Sat, 14 May 2022 22:40:03 +0000
>> Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>>
>>> On Sat, May 14, 2022 at 05:06:53PM +0200, Maxime Chevallier wrote:
>>>> This tagging protocol is designed for the situation where the link
>>>> between the MAC and the Switch is designed such that the Destination
>>>> Port, which is usually embedded in some part of the Ethernet
>>>> Header, is sent out-of-band, and isn't present at all in the
>>>> Ethernet frame.
>>>>
>>>> This can happen when the MAC and Switch are tightly integrated on an
>>>> SoC, as is the case with the Qualcomm IPQ4019 for example, where
>>>> the DSA tag is inserted directly into the DMA descriptors. In that
>>>> case, the MAC driver is responsible for sending the tag to the
>>>> switch using the out-of-band medium. To do so, the MAC driver needs
>>>> to have the information of the destination port for that skb.
>>>>
>>>> This out-of-band tagging protocol is using the very beggining of
>>>> the skb headroom to store the tag. The drawback of this approch is
>>>> that the headroom isn't initialized upon allocating it, therefore
>>>> we have a chance that the garbage data that lies there at
>>>> allocation time actually ressembles a valid oob tag. This is only
>>>> problematic if we are sending/receiving traffic on the master port,
>>>> which isn't a valid DSA use-case from the beggining. When dealing
>>>> from traffic to/from a slave port, then the oob tag will be
>>>> initialized properly by the tagger or the mac driver through the
>>>> use of the dsa_oob_tag_push() call.
>>>>
>>>> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
>>>> ---
>>>
>>> Why put the DSA pseudo-header at skb->head rather than push it using
>>> skb_push()? I thought you were going to check for the presence of a
>>> DSA header using something like skb->mac_len == ETH_HLEN + tag len,
>>> but right now it sounds like treating garbage in the headroom as a
>>> valid DSA tag is indeed a potential problem. If you can't sort that
>>> out using information from the header offsets alone, maybe an skb
>>> extension is required?
>>
>> Indeed, I thought of that, the main reason is that pushing/poping in
>> itself is not enough, you also have to move the whole mac_header to
>> leave room for the tag, and then re-set it in it's original location.
>> There's nothing wrong with this, but it looked a bit cumbersome just to
>> insert a dummy tag that gets removed rightaway. Does that make sense ?
> 
> You're thinking about inserting a header before the EtherType. But what
> has been said was to _prepend_ a header, i.e. put it before the Ethernet
> MAC DA. That way you don't need to move the Ethernet header.
> 
> But anyway, too much talk for mostly nothing, see below.
> 
>> But yes I would really like to get a way to know wether the tag is
>> there or not, I'll dig a bit more to see if I can find a way to get
>> this info from the various skb offsets in a reliable way.
> 
> Without an skb extension, this seems like an impossible task to me
> (which should also answer Florian's request for feedback on the proposal
> to share skb->cb with GRO, the qdisc, and whomever else there might be
> in the path between the DSA master and the switch).

Sorry I should have been clearer, the patch series that I pointed Maxime 
at earlier:

https://lore.kernel.org/lkml/1438322920.20182.144.camel@edumazet-glaptop2.roam.corp.google.com/T/

was initially accepted only to be reverted later on because on 64-bit 
host, there was not enough room in skb->cb[] to insert 4 bytes, so it 
got reverted.

So yes, I think we need to allocate a custom SKB extension if we want to 
convey the tag, unless we somehow manage to put it in the linear portion 
of the SKB to avoid using any control buffer or extension.
-- 
Florian
