Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F2836A3DA
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 03:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhDYBKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 21:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhDYBKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 21:10:09 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34139C061574;
        Sat, 24 Apr 2021 18:09:31 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id b17so743143pgh.7;
        Sat, 24 Apr 2021 18:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hDUnIusZ1DadclcLYuMe0SfPY7kssajJ2jsKvP8VfMg=;
        b=IdyNOxN4M14QU6/Aga/AL+7aidk4QuQALnJdzSwg7LGKIAefKHheh+ABksklkj1FUf
         /i/edhCFTk//KAI4ArCQujmF0xT+j937hUZ+o+B3KFXH7/xwRTOKMXIjU17M06l3v4ij
         v+IG8rXK2/pJOTcKr+5l6lQ5SbvCsJgf/BZTelsac4dHyuzxlnO9nPr1VFzhSACPLKyy
         X107o1QtS+bA2Oz/pCRVHbylKiMAAN5Ub6+zd9bMbG0cJK3k1Yd4ZC5OpWAxpV2SKMnr
         dtpaPwsNGmMnta7yIHS+PwtlgCeAGuvxGvgrghMeiagwAul9u1u7NOe0s+UZBsKqgipb
         XwPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hDUnIusZ1DadclcLYuMe0SfPY7kssajJ2jsKvP8VfMg=;
        b=H5SXyVr5+rWmWSIK15FNEc4+cvfRDskuXBvq9pM5FXzKRgrdME77dXmRkCW30WZugt
         P9b2n2dHxBII50oQ81z5IfcUkidqY/3cwfzxn/DlVg9cBerAKE+8mWK6qdYk9Ai0EFOq
         NWT9tawc3qCfoPgsgTZQV1M+q4mNlhZc8FU/68SOj3B2kzGrrqbxN/x9mpGgGe8YS0g1
         HvQtV0UlGW8f7ETKTsjMKSJ2ZX5jl1aUqJhSWdhQJT71Jo8DiW9X0+nZwebAadgKDnzn
         Fyb3OfDIecZLr6obuLCibJwLqyKZUYiZ+VRolRjV4y108A5uYvY/W5eUOEiHojYHJ6zi
         DUJA==
X-Gm-Message-State: AOAM532gkM9L4s5b5BGMtNiEIxII8uNfwh12Ozu43bPZMgPjPehZ0yR3
        6wTFFp+8UJYon7pS2RrvQIOLMdkNiBY=
X-Google-Smtp-Source: ABdhPJxj8b9/lzqBw/w6alkSqpAHYZUU/LQZFgOYG0g70kJl/vdINLwaPHHKmRb9lGJpSPgP8wi6xA==
X-Received: by 2002:a65:4303:: with SMTP id j3mr10426132pgq.55.1619312970301;
        Sat, 24 Apr 2021 18:09:30 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i126sm7483065pfc.20.2021.04.24.18.09.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Apr 2021 18:09:29 -0700 (PDT)
Subject: Re: [PATCH 11/14] drivers: net: dsa: qca8k: apply switch revision fix
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
 <20210423014741.11858-12-ansuelsmth@gmail.com>
 <e644aba9-a092-3825-b55b-e0cca158d28b@gmail.com>
 <YISLHNK8binc9T1N@Ansuel-xps.localdomain>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bbbb511a-0ab7-77e4-2dde-473d25b90d17@gmail.com>
Date:   Sat, 24 Apr 2021 18:09:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YISLHNK8binc9T1N@Ansuel-xps.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/24/2021 2:18 PM, Ansuel Smith wrote:
> On Thu, Apr 22, 2021 at 07:02:37PM -0700, Florian Fainelli wrote:
>>
>>
>> On 4/22/2021 6:47 PM, Ansuel Smith wrote:
>>> qca8k require special debug value based on the switch revision.
>>>
>>> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
>>> ---
>>>  drivers/net/dsa/qca8k.c | 23 +++++++++++++++++++++--
>>>  1 file changed, 21 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
>>> index 193c269d8ed3..12d2c97d1417 100644
>>> --- a/drivers/net/dsa/qca8k.c
>>> +++ b/drivers/net/dsa/qca8k.c
>>> @@ -909,7 +909,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>>>  {
>>>  	const struct qca8k_match_data *data;
>>>  	struct qca8k_priv *priv = ds->priv;
>>> -	u32 reg, val;
>>> +	u32 phy, reg, val;
>>>  
>>>  	/* get the switches ID from the compatible */
>>>  	data = of_device_get_match_data(priv->dev);
>>> @@ -928,7 +928,26 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>>>  	case 3:
>>>  	case 4:
>>>  	case 5:
>>> -		/* Internal PHY, nothing to do */
>>> +		/* Internal PHY, apply revision fixup */
>>> +		phy = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
>>> +		switch (priv->switch_revision) {
>>> +		case 1:
>>> +			/* For 100M waveform */
>>> +			qca8k_phy_dbg_write(priv, phy, 0, 0x02ea);
>>> +			/* Turn on Gigabit clock */
>>> +			qca8k_phy_dbg_write(priv, phy, 0x3d, 0x68a0);
>>> +			break;
>>> +
>>> +		case 2:
>>> +			qca8k_phy_mmd_write(priv, phy, 0x7, 0x3c, 0x0);
>>> +			fallthrough;
>>> +		case 4:
>>> +			qca8k_phy_mmd_write(priv, phy, 0x3, 0x800d, 0x803f);
>>> +			qca8k_phy_dbg_write(priv, phy, 0x3d, 0x6860);
>>> +			qca8k_phy_dbg_write(priv, phy, 0x5, 0x2c46);
>>> +			qca8k_phy_dbg_write(priv, phy, 0x3c, 0x6000);
>>> +			break;
>>
>> This would be better done with a PHY driver that is specific to the
>> integrated PHY found in these switches, it would provide a nice clean
>> layer and would allow you to expose additional features like cable
>> tests, PHY statistics/counters, etc.
> 
> I'm starting to do some work with this and a problem arised. Since these
> value are based on the switch revision, how can I access these kind of
> data from the phy driver? It's allowed to declare a phy driver in the
> dsa directory? (The idea would be to create a qca8k dir with the dsa
> driver and the dedicated internal phy driver.) This would facilitate the
> use of normal qca8k_read/write (to access the switch revision from the
> phy driver) using common function?

The PHY driver should live under drivers/net/phy/ and if you need to
communicate the switch revision to the PHY driver you can use
phydev->dev_flags and implement a dsa_switch_ops::get_phy_flags()
callback and define a custom bitmask.

As far as the read/write operations if your switch implements a custom
mii_bus for the purpose of doing all of the underlying indirect register
accesses, then you should be fine. A lot of drivers do that however if
you want an example of both (communicating something to the PHY driver
and having a custom MII bus) you can look at drivers/net/dsa/bcm_sf2.c
for an example.
-- 
Florian
