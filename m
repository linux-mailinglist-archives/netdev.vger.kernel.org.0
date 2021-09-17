Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2697140FF0C
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 20:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343754AbhIQSMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 14:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbhIQSMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 14:12:22 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC93C061574;
        Fri, 17 Sep 2021 11:11:00 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id c4so6701620pls.6;
        Fri, 17 Sep 2021 11:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j19W3k0UxVY88rp02NOZtY+ypRE1blCAPpTIKIHSJS8=;
        b=dWF91zoBQIbPkhGCiZrX5h6hbAUvWQ+lWE2PTlNr0sRDf2mlU8FpoDoaSeD2cm9VZs
         vVXToZUcZ2c2QglOwr6rDyrcqGSfj03nM4CE5CEFxh0cVKZyTwkixMh1ifst0d0fxB5b
         YbWUmjyJk9fODeTpaub7L61djgtF1PAsos28+lVY49nvClHjOp9zZnnzALZTHmvpInuL
         3n68reRnoAAlxQxYVwAy9ZqQrNn5Xn5WFEfDcPDzWhJwetdtgrGo/zfKsCazyJXHRZf0
         JER8FiqzfflXgdSUxxY/4sjieaRHvafKMo3BdOSkt0NJv1QwbJD3x0dsEXjoo0a/u/n1
         c0jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j19W3k0UxVY88rp02NOZtY+ypRE1blCAPpTIKIHSJS8=;
        b=s709Z/oytEysYmlUQQLzlp0AvsyOqkcOI7+egj8UCo2WMgLfyyFFK9PQGs0QxdlFS3
         s6JwOpR6t8dbUaA1rULb0fDOfGao/fo3Eux83NB+SF8Xt4N8wpzihFOW6VbmeOGV0mQS
         wmL9rkk7qjwgNe/Ting+zvf8FaTdwTy/GINO0TPQExqWc/bS9lLQZnya5we5+Rla57zG
         u2WVgCFKfgY3LZffmutUVH1fCvqCTrrHvsWGj6YNz9b3VGfCPE/uwjNP6/HvsMFOJSw7
         D5zZO2k4DQ0w7rW43mUUr3SksAmwSVgzoqZViBLPibeDr+8BhNdll2ZRVOA5NjdhEjHH
         EkDQ==
X-Gm-Message-State: AOAM531Z9+9hDyV3V5ma9p7VeVZAARnRFulDG0MwM6PKdFDFQOnFM1Be
        BrBAWqndCdw+z4fDHGOticNynxnmdws=
X-Google-Smtp-Source: ABdhPJzArJx9Jto0WhTT+o9nJ+ILTrOnKn1ZMg/LgJgJUGHjXxfcozm1dbjgmbBNetC0bwhPKwBGfQ==
X-Received: by 2002:a17:90a:2b88:: with SMTP id u8mr22806072pjd.216.1631902259260;
        Fri, 17 Sep 2021 11:10:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g13sm7023201pfi.176.2021.09.17.11.10.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Sep 2021 11:10:58 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: bcm7xxx: Add EPHY entry for 72165
To:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:BROADCOM ETHERNET PHY DRIVERS" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20210914224042.418365-1-f.fainelli@gmail.com>
 <20210915144716.12998b33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <373865cd-469d-78ab-12ed-d84de63c6295@gmail.com>
Date:   Fri, 17 Sep 2021 11:10:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210915144716.12998b33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/15/21 2:47 PM, Jakub Kicinski wrote:
> On Tue, 14 Sep 2021 15:40:41 -0700 Florian Fainelli wrote:
>> 72165 is a 16nm process SoC with a 10/100 integrated Ethernet PHY,
>> create a new macro and set of functions for this different process type.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  drivers/net/phy/bcm7xxx.c | 200 ++++++++++++++++++++++++++++++++++++++
>>  include/linux/brcmphy.h   |   1 +
>>  2 files changed, 201 insertions(+)
>>
>> diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
>> index e79297a4bae8..f6912a77a378 100644
>> --- a/drivers/net/phy/bcm7xxx.c
>> +++ b/drivers/net/phy/bcm7xxx.c
>> @@ -398,6 +398,189 @@ static int bcm7xxx_28nm_ephy_config_init(struct phy_device *phydev)
>>  	return bcm7xxx_28nm_ephy_apd_enable(phydev);
>>  }
>>  
>> +static int bcm7xxx_16nm_ephy_afe_config(struct phy_device *phydev)
>> +{
>> +	int tmp, rcalcode, rcalnewcodelp, rcalnewcode11, rcalnewcode11d2;
>> +
>> +	/* Reset PHY */
>> +	tmp = genphy_soft_reset(phydev);
>> +	if (tmp)
>> +		return tmp;
>> +
>> +	/* Reset AFE and PLL */
>> +	bcm_phy_write_exp_sel(phydev, 0x0003, 0x0006);
>> +	/* Clear reset */
>> +	bcm_phy_write_exp_sel(phydev, 0x0003, 0x0000);
>> +
>> +	/* Write PLL/AFE control register to select 54MHz crystal */
>> +	bcm_phy_write_misc(phydev, 0x0030, 0x0001, 0x0000);
>> +	bcm_phy_write_misc(phydev, 0x0031, 0x0000, 0x044a);
>> +
>> +	/* Change Ka,Kp,Ki to pdiv=1 */
>> +	bcm_phy_write_misc(phydev, 0x0033, 0x0002, 0x71a1);
>> +	/* Configuration override */
>> +	bcm_phy_write_misc(phydev, 0x0033, 0x0001, 0x8000);
>> +
>> +	/* Change PLL_NDIV and PLL_NUDGE */
>> +	bcm_phy_write_misc(phydev, 0x0031, 0x0001, 0x2f68);
>> +	bcm_phy_write_misc(phydev, 0x0031, 0x0002, 0x0000);
>> +
>> +	/* Reference frequency is 54Mhz, config_mode[15:14] = 3 (low
>> +	 * phase) */
> 
> Checkpatch points out:
> 
> WARNING: Block comments use a trailing */ on a separate line
> #55: FILE: drivers/net/phy/bcm7xxx.c:429:
> +	 * phase) */

Yes indeed, sorry about that.

> 
>> +	/* Drop LSB */
>> +	rcalnewcode11d2 = (rcalnewcode11 & 0xfffe) / 2;
>> +	tmp = bcm_phy_read_misc(phydev, 0x003d, 0x0001);
>> +	/* Clear bits [11:5] */
>> +	tmp &= ~0xfe0;
>> +	/* set txcfg_ch0<5>=1 (enable + set local rcal) */
>> +	tmp |= 0x0020 | (rcalnewcode11d2 * 64);
>> +	bcm_phy_write_misc(phydev, 0x003d, 0x0001, tmp);
>> +	bcm_phy_write_misc(phydev, 0x003d, 0x0002, tmp);
>> +
>> +	tmp = bcm_phy_read_misc(phydev, 0x003d, 0x0000);
>> +	/* set txcfg<45:44>=11 (enable Rextra + invert fullscaledetect)
>> +	 */
>> +	tmp &= ~0x3000;
>> +	tmp |= 0x3000;
> 
> Clearing then setting the same bits looks a little strange. Especially
> since from the comment it sounds like these are two separate bits, not
> a bitfield which is cleared and set as a whole. Anyway, up to you, just
> jumped out when I was looking thru to see if the use of signed tmp may
> cause any trouble...

I will keep it for now if you don't mind because there is a good chance
that we will need to change that in the future. For the most part the
programming sequence is automated based on a script provided by the
design team, the less manual updates I have to do the better.
-- 
Florian
