Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D574F31A9AD
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 03:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhBMCz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 21:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhBMCzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 21:55:52 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A0CC061574
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 18:55:12 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id c11so672143pfp.10
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 18:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WVkKkIB2sI+QjOD2AVkIQdCbbfav/ju7dbiJ6su7Ez4=;
        b=m7L2hLB1+iJKX3Qr7nx8DkhKkZZo1CQHHVjUwVwcMnNYzHpXqJeyhyHk58w+n+/JQy
         Y3txrDgs+4qnOUlxQ3/RerjOuFmvCwL6o3RgELbHPeK6oGahfuHy/m1r8fziUYuZEQTJ
         lVb4oMBZv6af4bji6VPHUgRSZq6St04qIz+rC0XiDSgMLneaRsbQzlTkpAE2NKptnChB
         mT2zn1whm3JxuxwwwuUF4yf8hveE66AEq0V/V2QtMZZgw2K+zEyBd1lfGk4qqfwFJGnu
         xCHujFmngImCCxC33U2acREoFZNCu5b2XPJx0HDWsVoHMvTn8DilYo3GY/NaIrB5edb4
         Qi7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WVkKkIB2sI+QjOD2AVkIQdCbbfav/ju7dbiJ6su7Ez4=;
        b=PTceNHLNzTOn+PNy5MJF4MPxkzd5a5a95sHTatEKaMiOzlrU++FRO10nqBrH5nZJqC
         qGttEeLkBQjx/dHkVQiuINPKFRlx6PKev2WHV1XdYcm8YZNeripVKYj7aZf5Bi6LbFQ0
         RwjUyYwO8iaJtGhoUOSzaYueREOEBa7trkN7Xhu/VS7EzJHepTEcRzv8CtS/20WSitP6
         uyGeJYOvnOxmN0yd7EsHR0BL5/N0nfSlSmpQMxmmB4Uf7l61g4J3zrfoSZL9T8c3wXXZ
         IHr8CuxOAeQKqS47n6tbwksnPmXi2cJ+TFgwpt1giossGMoiPQqy1GISZvAxNHv+S5iB
         F5hQ==
X-Gm-Message-State: AOAM533c9w7qYTagwBJyBbaR23icp2y7GYy+dVPJRxbIkzHgcLBoEzuk
        rRH276l8764oYEPjS5jXffo=
X-Google-Smtp-Source: ABdhPJyHthjLOa4U8ymyVPABDzOiSZlMG/j4oWHWw4iGgKNuhvmtk62qv+1jHS7JphWikHxo52W8Hw==
X-Received: by 2002:a63:c70c:: with SMTP id n12mr6014009pgg.347.1613184911562;
        Fri, 12 Feb 2021 18:55:11 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w5sm10412036pfb.11.2021.02.12.18.55.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 18:55:10 -0800 (PST)
Subject: Re: [PATCH net-next 1/2] net: phy: broadcom: Set proper
 1000BaseX/SGMII interface mode for BCM54616S
To:     Robert Hancock <robert.hancock@calian.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>
References: <20210213002825.2557444-1-robert.hancock@calian.com>
 <20210213002825.2557444-2-robert.hancock@calian.com>
 <87f06cb4-3bee-3ccb-bb21-ce6943e75336@gmail.com>
 <6d854d63df7f81421e927e1cd7726a41fd870ee3.camel@calian.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3a3f733a-8665-b9fb-5f0a-ed25a3d93275@gmail.com>
Date:   Fri, 12 Feb 2021 18:55:08 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <6d854d63df7f81421e927e1cd7726a41fd870ee3.camel@calian.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/12/2021 5:45 PM, Robert Hancock wrote:
> On Fri, 2021-02-12 at 17:26 -0800, Florian Fainelli wrote:
>>
>> On 2/12/2021 4:28 PM, 'Robert Hancock' via BCM-KERNEL-FEEDBACK-LIST,PDL
>> wrote:
>>> The default configuration for the BCM54616S PHY may not match the desired
>>> mode when using 1000BaseX or SGMII interface modes, such as when it is on
>>> an SFP module. Add code to explicitly set the correct mode using
>>> programming sequences provided by Bel-Fuse:
>>>
>>> https://urldefense.com/v3/__https://www.belfuse.com/resources/datasheets/powersolutions/ds-bps-sfp-1gbt-05-series.pdf__;!!IOGos0k!20FhZqRHEiz2-qFJ7J8XC4xX2qG-ajZ17Ma1W-VwDgwdQZeIhHEpWKlNldWW8DyFaQo$ 
>>> https://urldefense.com/v3/__https://www.belfuse.com/resources/datasheets/powersolutions/ds-bps-sfp-1gbt-06-series.pdf__;!!IOGos0k!20FhZqRHEiz2-qFJ7J8XC4xX2qG-ajZ17Ma1W-VwDgwdQZeIhHEpWKlNldWW58K3fY4$ 
>>>
>>> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
>>> ---
>>>  drivers/net/phy/broadcom.c | 83 ++++++++++++++++++++++++++++++++------
>>>  include/linux/brcmphy.h    |  4 ++
>>>  2 files changed, 75 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
>>> index 0472b3470c59..78542580f2b2 100644
>>> --- a/drivers/net/phy/broadcom.c
>>> +++ b/drivers/net/phy/broadcom.c
>>> @@ -64,6 +64,63 @@ static int bcm54612e_config_init(struct phy_device
>>> *phydev)
>>>  	return 0;
>>>  }
>>>  
>>> +static int bcm54616s_config_init(struct phy_device *phydev)
>>> +{
>>> +	int rc, val;
>>> +
>>> +	if (phydev->interface == PHY_INTERFACE_MODE_SGMII ||
>>> +	    phydev->interface == PHY_INTERFACE_MODE_1000BASEX) {
>>
>> Can you reverse the condition so as to save a level of identation?
> 
> Can do.
> 
>>
>>> +		/* Ensure proper interface mode is selected. */
>>> +		/* Disable RGMII mode */
>>> +		val = bcm54xx_auxctl_read(phydev,
>>> MII_BCM54XX_AUXCTL_SHDWSEL_MISC);
>>> +		if (val < 0)
>>> +			return val;
>>> +		val &= ~MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RGMII_EN;
>>> +		rc = bcm54xx_auxctl_write(phydev,
>>> MII_BCM54XX_AUXCTL_SHDWSEL_MISC,
>>> +					  val);
>>> +		if (rc < 0)
>>> +			return rc;
>>
>> I don't think this write is making it through since you are not setting
>> MII_BCM54XX_AUXCTL_MISC_WREN in val, I know this is an annoying detail,
>> and we could probably fold that to be within bcm54xx_auxctl_write()
>> directly, similarly to what bcm_phy_write_shadow() does.
> 
> Ah, indeed. I assume that is specific to the MII_BCM54XX_AUXCTL_SHDWSEL_MISC
> register? I suppose bcm54xx_auxctl_write could add that automatically for
> writes to that register. Not sure if that is too much magic for that function
> or not..

Upon closer look it's a bit more subtle than that, as we need to apply
the write enable bit only when targeting the "misc" shadow register, a
million ways to die in the west :)
-- 
Florian
