Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC66022B997
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 00:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgGWWeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 18:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728062AbgGWWeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 18:34:09 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82623C0619D3;
        Thu, 23 Jul 2020 15:34:09 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id 9so6310984wmj.5;
        Thu, 23 Jul 2020 15:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=448dqQuCFaUnNm1WJ4ZEIYQ5IyDQZsuGd3tMx7sn1II=;
        b=WxegyGy9JoUJZvmU3v8KYrJx+/KozqC/qZuJ3ZSjU3CaulBheWlszlUtLU6QzLIrG9
         RXEGhZbu3xV3SuxVklzl5sBHw0wpYzWuShpGE0vlxdw9SPu8ANXgwC8wYNWgfniPREBw
         Ozb46/mEGVoj0k6jMGcwP6UaeaoHqdYGE1RV9HofTvaHMicu4gA+kAVO75bWwxHXfoOu
         UJcBSi8cfJZSyaye0PBwnD1kUhdAJ6BEVsxoea6YqU+f0dZzDkvzvh/CAcTUIhNuke7D
         UlT7tjpG1yWqw+jmavrgKtBRzdwI+WvfJj1r49YhfNfH0lHbH4rmqO/ag2zxnTIxGUjG
         jDaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=448dqQuCFaUnNm1WJ4ZEIYQ5IyDQZsuGd3tMx7sn1II=;
        b=ip1/ceBBKlsqV6ldltT0wjlMXLcKHH+AoYtfgTkLH5FOClmOm1OMTJOOMlkggpsuw6
         X8fs9058C2xl7M7O568YcJ+/J2V/qx69NqjIOisrHBYFNasaGTtgK7hv1cKv9fFaMTaK
         cuvJfjAmVctyerwrIlOB4iT9qw8bzhputFgIku91yxhRnwagehNSbQN7144Fg06hL4pN
         Jxzx/Wv/eb05d2GS9GhH4VcRIyxVOVszTm5xEpWlXxPY1n8SZ05+J9XxOs0vviSxmpQk
         jmDyOwX8R14VX2OliYyYvWWZTFzV/uAmVCsUOK0YKNmM3xepdYWfIGyaAdkVoGdiuMc8
         7EGw==
X-Gm-Message-State: AOAM532I7b81l6oFCGFAG/Sf8mLT+vu6l5PMVWOd2eK7yw/7cIFaU8GI
        VGEsWv/y5GrAy+csPBWLpVo=
X-Google-Smtp-Source: ABdhPJzX0YEiFfKzdjjDbCatHLSmiLVMTqd00rFk44V+u7Uftv+Cyn6s5FvoQ9xnUXSigvMv9KBW6A==
X-Received: by 2002:a1c:7ecb:: with SMTP id z194mr5597919wmc.12.1595543648205;
        Thu, 23 Jul 2020 15:34:08 -0700 (PDT)
Received: from [10.67.50.75] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k10sm4669322wrm.74.2020.07.23.15.34.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 15:34:07 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/7] net: macb: parse PHY nodes found under an
 MDIO node
To:     Codrin.Ciubotariu@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc:     Nicolas.Ferre@microchip.com, Claudiu.Beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        robh+dt@kernel.org, alexandre.belloni@bootlin.com,
        Ludovic.Desroches@microchip.com
References: <20200721171316.1427582-1-codrin.ciubotariu@microchip.com>
 <20200721171316.1427582-4-codrin.ciubotariu@microchip.com>
 <460e5f3d-f3a0-154e-d617-d1536c96e390@gmail.com>
 <1ba55a2a-487a-dbd5-29e6-5d4231e80167@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <4c286a61-6da9-392f-7a06-bace7f04700d@gmail.com>
Date:   Thu, 23 Jul 2020 15:33:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1ba55a2a-487a-dbd5-29e6-5d4231e80167@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/20 3:08 PM, Codrin.Ciubotariu@microchip.com wrote:
> On 23.07.2020 21:59, Florian Fainelli wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>
>> On 7/21/20 10:13 AM, Codrin Ciubotariu wrote:
>>> The MACB embeds an MDIO bus controller. For this reason, the PHY nodes
>>> were represented as sub-nodes in the MACB node. Generally, the
>>> Ethernet controller is different than the MDIO controller, so the PHYs
>>> are probed by a separate MDIO driver. Since adding the PHY nodes directly
>>> under the ETH node became deprecated, we adjust the MACB driver to look
>>> for an MDIO node and register the subnode MDIO devices.
>>>
>>> Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
>>> ---
>>>
>>> Changes in v2:
>>>   - readded newline removed by mistake;
>>>
>>>   drivers/net/ethernet/cadence/macb_main.c | 10 ++++++++++
>>>   1 file changed, 10 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
>>> index 89fe7af5e408..b25c64b45148 100644
>>> --- a/drivers/net/ethernet/cadence/macb_main.c
>>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>>> @@ -740,10 +740,20 @@ static int macb_mii_probe(struct net_device *dev)
>>>   static int macb_mdiobus_register(struct macb *bp)
>>>   {
>>>        struct device_node *child, *np = bp->pdev->dev.of_node;
>>> +     struct device_node *mdio_node;
>>> +     int ret;
>>>
>>>        if (of_phy_is_fixed_link(np))
>>>                return mdiobus_register(bp->mii_bus);
>>
>> Does not this need changing as well? Consider the use case of having
>> your MACB Ethernet node have a fixed-link property to describe how it
>> connects to a switch, and your MACB MDIO controller, expressed as a
>> sub-node, describing the MDIO attached switch it connects to.
> 
> Right, this is what I was discussing with Claudiu on the other thread. I 
> am thinking to just move the look for mdio before checking for 
> fixed-link. This will probe the MDIO devices and simple mdiobus_register 
> will be called only if the mdio node is missing.

Found it after I had sent this email. What you propose sounds
reasonable, looking forward to v3.

> 
> Thank you for your review(s)!

Of course.
-- 
Florian
