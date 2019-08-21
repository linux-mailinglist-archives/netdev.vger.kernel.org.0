Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E938980C3
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 18:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbfHUQ4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 12:56:08 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40180 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728810AbfHUQ4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 12:56:07 -0400
Received: by mail-wr1-f65.google.com with SMTP id c3so2706194wrd.7;
        Wed, 21 Aug 2019 09:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i3Zp/xrNLIhVbSe7rdYIOlD+qEvFODONbYp+TxFFec0=;
        b=sNoyMjDDacPJS3dvBiHkDKQbt3VGWbTKagnxIbPchRlWkvA1weuhlIUL2SsTnAUxe9
         aQEVK6Ti1rZL45HOtRosubCe/d+zcCz3ZBOwzmTWciGQOCCl2tAvBZpmBoil0RYrECQs
         M1NzUH0fKksVWc2dFdHSX0bAqDUEy3HH33LCuSHg6dxFliEIr2kUQSv5mmgSsgBQGgPe
         BrgApye5NRyNomGmBl0y+q7yNklpTQqbZj0oStPwI93Jnp+zGMrgG6EKpbC3U2iUHe2b
         ipZGWaDmSlfS1gavLNgkLQ7s3sQqw9RXlgM8tt750A1bcr9ZQKSA/DbNVhAXloevDO6l
         VwHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i3Zp/xrNLIhVbSe7rdYIOlD+qEvFODONbYp+TxFFec0=;
        b=jZg9/HaerrzdAiNpz4V1Sj7UCK6dDTfcNfmhlhXocppxq8GpZrrBFNhyUHDpMFdfuo
         Jc/+zHnWgfuFkU6+a193MMZRuZWIVGXd7bqTmbP5cOnDHQDuyaLXmDPFe1E6hqNeGDNq
         12AzsSiRS1l3YTsVnotk9ccBtaKYJTjLzPHGJSjjhz185wE9IaZ5I0mWB2e6JPwB6U69
         mlsXtnx0fXsk3xIBOutDCpDaP9pvp73hUsk1l6ZeHPXwxBCtUw5Yp3pSiIqHKNGkRCGj
         TiGAMs0RDLe3Cokr7IaD1Fg13tyABwME54bpFevyirdeW+M1hAS8wYCs4I0rgJra+MOa
         DHyg==
X-Gm-Message-State: APjAAAVrz2vLQLgdKNEqM8sR+IEi33/ivakl7zFg/fthDwZwEAuEO1mF
        O6ZdsouqYUdJ8NeCsmBD6Zk=
X-Google-Smtp-Source: APXvYqzifIju179Z9H7ZpvpK+ol1iUFt+D0QXW0i7YVV9PoYLYmX3wQJjxa9TnqcYPg3ai+nhex5Lg==
X-Received: by 2002:adf:f851:: with SMTP id d17mr14511305wrq.77.1566406565347;
        Wed, 21 Aug 2019 09:56:05 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:7026:65b1:a037:c969? (p200300EA8F047C00702665B1A037C969.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:7026:65b1:a037:c969])
        by smtp.googlemail.com with ESMTPSA id f7sm32226599wrf.8.2019.08.21.09.56.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 09:56:04 -0700 (PDT)
Subject: Re: [PATCH v2 net] Add genphy_c45_config_aneg() function to phy-c45.c
To:     Andrew Lunn <andrew@lunn.ch>,
        Marco Hartmann <marco.hartmann@nxp.com>
Cc:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Herber <christian.herber@nxp.com>
References: <1566385208-23523-1-git-send-email-marco.hartmann@nxp.com>
 <20190821153740.GB22091@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <37eefeb7-7540-cb71-79b5-4a72d140a1a6@gmail.com>
Date:   Wed, 21 Aug 2019 18:55:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190821153740.GB22091@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.08.2019 17:37, Andrew Lunn wrote:
> On Wed, Aug 21, 2019 at 11:00:46AM +0000, Marco Hartmann wrote:
>> Commit 34786005eca3 ("net: phy: prevent PHYs w/o Clause 22 regs from calling
>> genphy_config_aneg") introduced a check that aborts phy_config_aneg()
>> if the phy is a C45 phy.
>> This causes phy_state_machine() to call phy_error() so that the phy
>> ends up in PHY_HALTED state.
>>
>> Instead of returning -EOPNOTSUPP, call genphy_c45_config_aneg()
>> (analogous to the C22 case) so that the state machine can run
>> correctly.
>>
>> genphy_c45_config_aneg() closely resembles mv3310_config_aneg()
>> in drivers/net/phy/marvell10g.c, excluding vendor specific
>> configurations for 1000BaseT.
> 
>> +/**
>> + * genphy_c45_config_aneg - restart auto-negotiation or forced setup
>> + * @phydev: target phy_device struct
>> + *
>> + * Description: If auto-negotiation is enabled, we configure the
>> + *   advertising, and then restart auto-negotiation.  If it is not
>> + *   enabled, then we force a configuration.
>> + */
>> +int genphy_c45_config_aneg(struct phy_device *phydev)
>> +{
>> +	bool changed = false;
>> +	int ret;
>> +
>> +	if (phydev->autoneg == AUTONEG_DISABLE)
>> +		return genphy_c45_pma_setup_forced(phydev);
>> +
>> +	ret = genphy_c45_an_config_aneg(phydev);
>> +	if (ret < 0)
>> +		return ret;
>> +	if (ret > 0)
>> +		changed = true;
>> +
>> +	return genphy_c45_check_and_restart_aneg(phydev, changed);
>> +}
>> +EXPORT_SYMBOL_GPL(genphy_c45_config_aneg);
> 
> The vendor parts for 1000BaseT makes this interesting. Do we expect to
> see an C45 PHYs which don't support 1000BaseT? I think that
> unlikely. So all C45 PHYs are going to implement their own config_aneg
> callback so they can set their vendor registers for 1000BaseT.
> 
>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>> index f3adea9ef400..74c4e15ebe52 100644
>> --- a/drivers/net/phy/phy.c
>> +++ b/drivers/net/phy/phy.c
>> @@ -507,7 +507,7 @@ static int phy_config_aneg(struct phy_device *phydev)
>>  	 * allowed to call genphy_config_aneg()
>>  	 */
>>  	if (phydev->is_c45 && !(phydev->c45_ids.devices_in_package & BIT(0)))
>> -		return -EOPNOTSUPP;
>> +		return genphy_c45_config_aneg(phydev);
>>  
>>  	return genphy_config_aneg(phydev);
> 
> So here we should be calling the driver config_aneg function. It can
> then call genphy_c45_config_aneg(phydev) to do the generic parts.
> 
> Heiner, what do you think?
> 
As you say, C45 doesn't cover 1000BaseT, therefore for this mode a
vendor-specific part is needed in the PHY driver always.
That's the reason why genphy_c45_an_config_aneg is meant to be used
within a PHY drivers config_aneg callback implementation, and why
we don't have a generic C45 config_aneg function yet.

Use case for the new function could be cases where 1000BaseT support
isn't needed, and it could serve as a fallback if there's no
dedicated PHY driver yet e.g. for a new chip.

> 	Andrew
> 
Heiner
