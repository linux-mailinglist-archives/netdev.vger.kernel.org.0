Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 946B7D55C3
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 13:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbfJMLZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 07:25:29 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:48210 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728620AbfJMLZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 07:25:29 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 46rfWB55wDz1rGRl;
        Sun, 13 Oct 2019 13:25:26 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 46rfWB4N79z1qqkB;
        Sun, 13 Oct 2019 13:25:26 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id MGkQ8KYYmwXm; Sun, 13 Oct 2019 13:25:23 +0200 (CEST)
X-Auth-Info: n/9suSe9kItaE2RE1TTGUIC9QSEBoyjGV9PzaTGFjt4=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 13 Oct 2019 13:25:23 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
Subject: Re: [PATCH V2 1/2] net: phy: micrel: Discern KSZ8051 and KSZ8795 PHYs
To:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
References: <20191010194622.28742-1-marex@denx.de>
 <84cb8eca-2eea-6f54-16c7-fa7b95655e2e@gmail.com>
 <42abfa5c-1e84-63c7-1f3d-4816d232dc98@gmail.com>
Message-ID: <6618b999-07ba-5c1b-60cf-6f7d7c1b3526@denx.de>
Date:   Sun, 13 Oct 2019 12:53:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <42abfa5c-1e84-63c7-1f3d-4816d232dc98@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/19 11:22 PM, Heiner Kallweit wrote:

[...]

>>> @@ -1141,13 +1174,12 @@ static struct phy_driver ksphy_driver[] = {
>>>  	.suspend	= genphy_suspend,
>>>  	.resume		= genphy_resume,
>>>  }, {
>>> -	.phy_id		= PHY_ID_KSZ8795,
>>> -	.phy_id_mask	= MICREL_PHY_ID_MASK,
>>>  	.name		= "Micrel KSZ8795",
>>>  	/* PHY_BASIC_FEATURES */
>>>  	.config_init	= kszphy_config_init,
>>>  	.config_aneg	= ksz8873mll_config_aneg,
>>>  	.read_status	= ksz8873mll_read_status,
>>> +	.match_phy_device = ksz8795_match_phy_device,
>>>  	.suspend	= genphy_suspend,
>>>  	.resume		= genphy_resume,
>>>  }, {
>>>
>>
>> Patch needs to be annotated as "net-next".
>> See https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt
>>
> Except you consider this a fix, then it would require a Fixes tag and
> should be annotated "net". The question is:
> Do KSZ87xx switches misbehave currently?

Well yes they do, otherwise I won't be sending this fix.

-- 
Best regards,
Marek Vasut
