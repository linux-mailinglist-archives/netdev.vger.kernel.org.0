Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7B26C7215
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 22:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCWVCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 17:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjCWVCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 17:02:25 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014C52311A;
        Thu, 23 Mar 2023 14:02:21 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id cu12so31414pfb.13;
        Thu, 23 Mar 2023 14:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679605341;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p5uiJRroyVtf8LvtPinLAxBV2hvJ6FPnzSdm/G+aNVk=;
        b=qAIyOJ3j8C80s4IAcmwxzYnJuHB9bJXHF0THG/5RRTv8Xt+k8gt1hR0PdCcqYwGx55
         9Xs8oforUZ85JiZFHvFlCgbaiM83jiadZMLqbPayZfL8OKIwKapG+H+5uvqgkSLCEICD
         m/Kg81x+SaTyRbxSt0cws7AslqQ7n4qkSfwFI/WqsLhoPYileXoCT85A+c7ZjCha1f08
         Ojgvc91ftXCRGkPjXBzmH82i/baGMgb6XzcBT9O51D1PJ2yU2i6fcqsInrA8Sy3lcTI9
         5/QJbWRuKumunRrnroPKJGAtniqMjhdjwsjxfm/xcdB8/9JsBRYWLic89TjFUBRLO+lW
         SiPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679605341;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p5uiJRroyVtf8LvtPinLAxBV2hvJ6FPnzSdm/G+aNVk=;
        b=PbbLHQuKKluilDLWjfsgIk8fYwDZKqs3mVuHQaoq6UIuZJHcmFZpUUraMjubSj6uFV
         xW42v3Ap5nlA1nt2fV29nP2rMpAyK89VAMom0p2xodEyhXQd5XoMbBuA3xx60epIc0LO
         8tjUIWbvPUVsUCy43pVk1T0TvyMXVTd0LsK51khIx+WZ42dbFpV+b1mFeAoDbh4M1V9Q
         eV0KmmJpdM/OKCbvAI0/BTwFzeWoraMqHe5Bb3Nhxpfyp+cfM+5F/jtDbfG3C1J7WIkt
         XgZeuZGWR3a+YU+649LQ4ueWKlOaUpxgZfk+mFvTv0L0htvnjQfDtixPSCEnVjwV+WY4
         EwmA==
X-Gm-Message-State: AAQBX9eZFNfy5yRjlx92qzyrTyfke7qEHOgxXChplL1fHdfqFd6WQAsP
        TklAqLkW1HsaQldLQ/tw6Ps=
X-Google-Smtp-Source: AKy350Yfk0MErpg+gVhnsJHb6rq7kKbSo9pCjlrflM80g06rzBtrQEFztYhhiNEehSaEE+MnuGDJ/Q==
X-Received: by 2002:aa7:9f8f:0:b0:628:9b4:a6a2 with SMTP id z15-20020aa79f8f000000b0062809b4a6a2mr619923pfr.15.1679605340979;
        Thu, 23 Mar 2023 14:02:20 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r14-20020a62e40e000000b00627ee6dcb84sm8999710pfh.203.2023.03.23.14.02.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 14:02:20 -0700 (PDT)
Message-ID: <c54fe984-371a-da06-6dcf-da239a26bd5f@gmail.com>
Date:   Thu, 23 Mar 2023 14:02:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 2/2] net: dsa: b53: mdio: add support for BCM53134
Content-Language: en-US
To:     Paul Geurts <paul.geurts@prodrive-technologies.com>,
        =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        "jonas.gorski@gmail.com" <jonas.gorski@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230323121804.2249605-1-noltari@gmail.com>
 <20230323121804.2249605-3-noltari@gmail.com>
 <ee867960-91bb-659b-a87b-6c04613608c5@gmail.com>
 <AM0PR02MB55242C94846EE5598CDA44A2BD879@AM0PR02MB5524.eurprd02.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <AM0PR02MB55242C94846EE5598CDA44A2BD879@AM0PR02MB5524.eurprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/23 13:10, Paul Geurts wrote:
>> -----Original Message-----
>> From: Florian Fainelli <f.fainelli@gmail.com>
>> Sent: donderdag 23 maart 2023 17:43
>> To: Álvaro Fernández Rojas <noltari@gmail.com>; Paul Geurts
>> <paul.geurts@prodrive-technologies.com>; jonas.gorski@gmail.com;
>> andrew@lunn.ch; olteanv@gmail.com; davem@davemloft.net;
>> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
>> robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;
>> netdev@vger.kernel.org; devicetree@vger.kernel.org; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH 2/2] net: dsa: b53: mdio: add support for BCM53134
>>
>> On 3/23/23 05:18, Álvaro Fernández Rojas wrote:
>>> From: Paul Geurts <paul.geurts@prodrive-technologies.com>
>>>
>>> Add support for the BCM53134 Ethernet switch in the existing b53 dsa
>> driver.
>>> BCM53134 is very similar to the BCM58XX series.
>>>
>>> Signed-off-by: Paul Geurts <paul.geurts@prodrive-technologies.com>
>>> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
>>> ---
>>>    drivers/net/dsa/b53/b53_common.c | 53
>> +++++++++++++++++++++++++++++++-
>>>    drivers/net/dsa/b53/b53_mdio.c   |  5 ++-
>>>    drivers/net/dsa/b53/b53_priv.h   |  9 +++++-
>>>    3 files changed, 64 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/dsa/b53/b53_common.c
>>> b/drivers/net/dsa/b53/b53_common.c
>>> index 1f9b251a5452..aaa0813e6f59 100644
>>> --- a/drivers/net/dsa/b53/b53_common.c
>>> +++ b/drivers/net/dsa/b53/b53_common.c
>>> @@ -1282,6 +1282,42 @@ static void b53_adjust_link(struct dsa_switch
>> *ds, int port,
>>>    	if (is63xx(dev) && port >= B53_63XX_RGMII0)
>>>    		b53_adjust_63xx_rgmii(ds, port, phydev->interface);
>>>
>>> +	if (is53134(dev) && phy_interface_is_rgmii(phydev)) {
>>
>> Why is not this in the same code block as the one for the is531x5() device like
>> this:
>>
>> diff --git a/drivers/net/dsa/b53/b53_common.c
>> b/drivers/net/dsa/b53/b53_common.c
>> index 59cdfc51ce06..1c64b6ce7e78 100644
>> --- a/drivers/net/dsa/b53/b53_common.c
>> +++ b/drivers/net/dsa/b53/b53_common.c
>> @@ -1235,7 +1235,7 @@ static void b53_adjust_link(struct dsa_switch *ds,
>> int port,
>>                                 tx_pause, rx_pause);
>>           b53_force_link(dev, port, phydev->link);
>>
>> -       if (is531x5(dev) && phy_interface_is_rgmii(phydev)) {
>> +       if ((is531x5(dev) || is53134(dev)) &&
>> phy_interface_is_rgmii(phydev)) {
>>                   if (port == dev->imp_port)
>>                           off = B53_RGMII_CTRL_IMP;
>>                   else
>>
>> Other than that, LGTM!
>> --
>> Florian
> 
> I think the only reason is that the BCM53134 does not support the
> RGMII_CTRL_TIMING_SEL bit, which is set in the original block. I agree
> Putting a if statement around
> rgmii_ctrl |= RGMII_CTRL_TIMING_SEL;
> would prevent a lot of code duplication. _however_, after looking at it again,
> I don’t think the device does not support the bit. When looking at the datasheet,
> The same bit in the this register is called BYPASS_2NS_DEL. It's very uncommon
> For Broadcom to make such a change in the register interface, so maybe they
> Just renamed it. Do you think this could be the same bit?

Yes, I think this is exactly the same bit, just named differently. What 
strikes me as odd is that neither of the 53115, 53125 or 53128 which are 
guarded by the is531x5() conditional have it defined.
-- 
Florian

