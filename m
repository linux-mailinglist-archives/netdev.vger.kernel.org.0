Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF7E1EC587
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 01:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgFBXNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 19:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgFBXNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 19:13:52 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9AD3C08C5C1;
        Tue,  2 Jun 2020 16:13:51 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id l11so373301wru.0;
        Tue, 02 Jun 2020 16:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qwJh8Bb4M36Ea2x8XMaW1Wp2tdXXDvEeJAN1CUx0LEk=;
        b=IeejpBdoAJespM4xBjpLegDDUBv53Lvl4EWZgtvj56lQOBwleYlaSDn0NdofiRMgMj
         CU3E16SVKWokFPvrF9JjAWwk0hfZf1lmn+vBx+ouVQQBqdxaUJ7QdofoEdhb75MEEH/J
         kI+wYVjExXN+Kj3l/1BdUkTYmmk3ltB6a3QWCTLdlbwhH57KWRD5TLyLh+WcG8Lw9vRt
         +oL9uDOCVERDv4Q6tavFN926zarpTaS9D6f52qa0E0g/wkOb+SdBuGNI9Av1ddiEZRh3
         lzJsQrmA0ahrLfhTMp6KpCgu2m6Rtj/DM1FKpsnt1cbA3jzcgEDOr8C7fNlxihm7NLhU
         QHjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qwJh8Bb4M36Ea2x8XMaW1Wp2tdXXDvEeJAN1CUx0LEk=;
        b=hGkG/Zt4rDWL6DckMJRyBQo0vGrQqDYt8BzFm10oCuOryM3moyED4lnoXO8hOlztE6
         W5TgzLBUlllpA6Pu8KIWmEgiIZfCfwj8y7NCSoEUbFkjqbvh0cRoAYw/jisNuACPJX60
         iwcAq8wReOU/wT29hGlxUBo9JbwMnOePvXzUPC9aDF/zOEWwzZvfZmhHizsLv0t+WkgI
         aFPEN7/4ZOIuWIq6NnohyZbxKUsZDV8/OJMmRRQnzJG6Lav8rVeE5oDuy6kRe+YGo0Fr
         vrl4FkKUA+TcsJfof/QTQJShyj6grUTBPCnKVxYnLM5FmkCKf3RNddVFZw9hL2KdtpzF
         WL/g==
X-Gm-Message-State: AOAM533qLHdA4alImIklfcg4Cx4y42ZzLe+cl8wd7Pb+qVimpB9cRPES
        EbUSiEoVsctxoMehiZYYbB7A/Jr1
X-Google-Smtp-Source: ABdhPJxyacC9il4nE4eKv4EV6QejGKhHn9MTM4PGLu6aoGrpD5bhO4N57XqldoAiZTsceCluYGQUig==
X-Received: by 2002:a5d:690b:: with SMTP id t11mr30746889wru.213.1591139630240;
        Tue, 02 Jun 2020 16:13:50 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id u7sm627230wrm.23.2020.06.02.16.13.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 16:13:49 -0700 (PDT)
Subject: Re: [PATCH net-next v5 4/4] net: dp83869: Add RGMII internal delay
 configuration
To:     Dan Murphy <dmurphy@ti.com>, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, robh@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20200602164522.3276-1-dmurphy@ti.com>
 <20200602164522.3276-5-dmurphy@ti.com>
 <c3c68dcd-ccf1-25fd-fc4c-4c30608a1cc8@gmail.com>
 <61888788-041f-7b93-9d99-7dad4c148021@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6981527b-f155-a46b-574a-2e6621589ca4@gmail.com>
Date:   Tue, 2 Jun 2020 16:13:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <61888788-041f-7b93-9d99-7dad4c148021@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/2/2020 4:10 PM, Dan Murphy wrote:
> Florian
> 
> On 6/2/20 5:33 PM, Florian Fainelli wrote:
>>
>> On 6/2/2020 9:45 AM, Dan Murphy wrote:
>>> Add RGMII internal delay configuration for Rx and Tx.
>>>
>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>>> ---
>> [snip]
>>
>>> +
>>>   enum {
>>>       DP83869_PORT_MIRRORING_KEEP,
>>>       DP83869_PORT_MIRRORING_EN,
>>> @@ -108,6 +113,8 @@ enum {
>>>   struct dp83869_private {
>>>       int tx_fifo_depth;
>>>       int rx_fifo_depth;
>>> +    s32 rx_id_delay;
>>> +    s32 tx_id_delay;
>>>       int io_impedance;
>>>       int port_mirroring;
>>>       bool rxctrl_strap_quirk;
>>> @@ -232,6 +239,22 @@ static int dp83869_of_init(struct phy_device
>>> *phydev)
>>>                    &dp83869->tx_fifo_depth))
>>>           dp83869->tx_fifo_depth = DP83869_PHYCR_FIFO_DEPTH_4_B_NIB;
>>>   +    ret = of_property_read_u32(of_node, "rx-internal-delay-ps",
>>> +                   &dp83869->rx_id_delay);
>>> +    if (ret) {
>>> +        dp83869->rx_id_delay =
>>> +                dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
>>> +        ret = 0;
>>> +    }
>>> +
>>> +    ret = of_property_read_u32(of_node, "tx-internal-delay-ps",
>>> +                   &dp83869->tx_id_delay);
>>> +    if (ret) {
>>> +        dp83869->tx_id_delay =
>>> +                dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
>>> +        ret = 0;
>>> +    }
>> It is still not clear to me why is not the parsing being done by the PHY
>> library helper directly?
> 
> Why would we do that for these properties and not any other?

Those properties have a standard name, which makes them suitable for
parsing by the core PHY library.

> 
> Unless there is a new precedence being set here by having the PHY
> framework do all the dt node parsing for common properties.

You could parse the vendor properties through the driver, let the PHY
library parse the standard properties, and resolve any ordering
precedence within the driver. In general, I would favor standard
properties over vendor properties.

Does this help?
-- 
Florian
