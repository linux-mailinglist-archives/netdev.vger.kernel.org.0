Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8232B1258FA
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 01:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfLSA57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 19:57:59 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45212 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfLSA56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 19:57:58 -0500
Received: by mail-ed1-f67.google.com with SMTP id v28so3200588edw.12
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 16:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GFAkwUASTqackgary7H6sv2gF4QyczP924Bbls6Mt+g=;
        b=gKIGBeesvzrEwiPVOT229Fr/1NIghooqDPvVTfpkKmGGvz8MvrmRhQ3Y5y9o9Js7WI
         6zqk33LZB4RxyJeSWeMhAWQ6Gpu2HGxmnljLrmv24z9hMSexsLPYDrSAB7AMuSPMwjHP
         RH2PLsvfMBU4kUHjEIvmmPKPiRr0i10ZgvtuNc7eGFcIPrSuDwdLhQnILWTl8R/H4L/b
         /TY/3usdfZPm0/T9fN2u7YY2UFBIU59lxTqTbgGafiowbx1Y4kKFYORBgFvp+sf0IjpK
         IOoKIfhSvukOQQFSUGL9IY1w7D/w0WpG7SB9UMZOLOgJrSLhbtv0+S8I9mmoMpQNEpZY
         jVvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GFAkwUASTqackgary7H6sv2gF4QyczP924Bbls6Mt+g=;
        b=N/289zFhLZgih9azw9e/sP3MBy4cyQva5SZ8wCVffNHfC6jMktN3+AH6UEarQMpCHK
         rv4heI0besk5JCx3yV3vOOFyvNfMQAyff828UyarnDHQBMeF1QmheRliTFeLg1DZQy7a
         7At8EC1krIUFBz9ri6ieD5ZJUImpHQyaUbZZDp+nxDu+x5HGySXPGBW3LCsZk4eufPC6
         5sGtqTqgAeFimGaeKzsAf9VKFS9xHUht+Bx6wzWpKEKXH95E+Fk56S3QkTwQUSCTZMEs
         A7l+YJO5hJbWCPBdWzuX+SaVrmSQwhYOPlXZv5SqJuIQCOx3zauC3ESyakN88evrv5o2
         ervA==
X-Gm-Message-State: APjAAAWHzFUMF5/fn++wSdzD1hcrboslI4xXee2VJ+mkFhFj0AKh2+um
        WmNV9/Ca2l3uuWPABbR9IhgOzEeH
X-Google-Smtp-Source: APXvYqx3r9+gqO/QA1VnyscH0/VRlv4fbJ+obMi8TSBc8ZyiO+8Hjgl5yDnrlwxCm9VIFd9KolnlwQ==
X-Received: by 2002:a05:6402:3123:: with SMTP id dd3mr6108430edb.259.1576717075843;
        Wed, 18 Dec 2019 16:57:55 -0800 (PST)
Received: from [10.67.50.49] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e21sm83875eds.36.2019.12.18.16.57.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 16:57:55 -0800 (PST)
Subject: Re: [PATCH net-next v2 13/14] net: phy: add Broadcom BCM84881 PHY
 driver
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20191209151553.GP25745@shell.armlinux.org.uk>
 <E1ieKov-0004vw-Dk@rmk-PC.armlinux.org.uk>
 <557220a9-bdf4-868a-d9cd-a382ae80d288@gmail.com>
 <20191210175837.GY25745@shell.armlinux.org.uk>
 <20191210184640.GU1344@shell.armlinux.org.uk>
 <20191219005545.GY1344@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <d4484799-a7f9-5edc-2242-78b41d6840a6@gmail.com>
Date:   Wed, 18 Dec 2019 16:57:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191219005545.GY1344@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/18/19 4:55 PM, Russell King - ARM Linux admin wrote:
> On Tue, Dec 10, 2019 at 06:46:40PM +0000, Russell King - ARM Linux admin wrote:
>> On Tue, Dec 10, 2019 at 05:58:37PM +0000, Russell King - ARM Linux admin wrote:
>>> On Tue, Dec 10, 2019 at 09:34:16AM -0800, Florian Fainelli wrote:
>>>> On 12/9/19 7:19 AM, Russell King wrote:
>>>>> Add a rudimentary Clause 45 driver for the BCM84881 PHY, found on
>>>>> Methode DM7052 SFPs.
>>>>>
>>>>> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
>>>>
>>>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>>>>
>>>>> ---
>>>>>  drivers/net/phy/Kconfig    |   6 +
>>>>>  drivers/net/phy/Makefile   |   1 +
>>>>>  drivers/net/phy/bcm84881.c | 269 +++++++++++++++++++++++++++++++++++++
>>>>>  3 files changed, 276 insertions(+)
>>>>>  create mode 100644 drivers/net/phy/bcm84881.c
>>>>>
>>>>> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
>>>>> index fe602648b99f..41272106dea9 100644
>>>>> --- a/drivers/net/phy/Kconfig
>>>>> +++ b/drivers/net/phy/Kconfig
>>>>> @@ -329,6 +329,12 @@ config BROADCOM_PHY
>>>>>  	  Currently supports the BCM5411, BCM5421, BCM5461, BCM54616S, BCM5464,
>>>>>  	  BCM5481, BCM54810 and BCM5482 PHYs.
>>>>>  
>>>>> +config BCM84881_PHY
>>>>> +	bool "Broadcom BCM84881 PHY"
>>>>> +	depends on PHYLIB=y
>>>>> +	---help---
>>>>> +	  Support the Broadcom BCM84881 PHY.
>>>>
>>>> Cannot we make this tristate, I believe we cannot until there are more
>>>> fundamental issues (that you just reported) to be fixed, correct?
>>>
>>> Indeed.  The problem I saw was that although the bcm84881 has the
>>> PHY correctly described, for whatever reason, the module was not
>>> loaded.
>>>
>>> What I think is going in is that with modern udev userspace,
>>> request_module() is not functional, and we do not publish the
>>> module IDs for Clause 45 PHYs via uevent.  Consequently, there
>>> exists no mechanism to load a Clause 45 PHY driver from the
>>> filesystem.
>>
>> I just attempted booting with sfp as a module, bcm84881 as a module.
>> sfp has to be loaded for the SFP cage to be recognised, so module
>> loading is availble prior to the PHY being known to the kernel.
>>
>> The SFP is probed, and the PHY identified (via my debug):
>>
>> [    7.209549] sfp sfp: phy PMA devid: 0xae02 0x5151
>>
>> The PHY is not bound to its driver at this point.
>>
>> We then try to connect to the PHY, but the support mask is zero,
>> so we know nothing about what modes this PHY supports:
>>
>> [    7.215985] mvneta f1034000.ethernet eno2: phylink_sfp_connect_phy: s=00,00000000,00000000 a=00,00000000,00000000
>> [    7.215997] mvneta f1034000.ethernet eno2: validation with support 00,00000000,00000000 failed: -22
>> [    7.226343] sfp sfp: sfp_add_phy failed: -22
>>
>> and we fail - because we are unable to identify what mode we should
>> configure the MAC side for, because we have no idea what the
>> capabilities of the PHY are at this stage.
>>
>> We can't wait until we've called phylink_attach_phy(), because that
>> configures the PHY for the phy interface mode that was passed in.
>>
>> There is no sign of the bcm84881 module being loaded.
> 
> Okay, I see what is going on - I just added debug into __request_module,
> and got:
> 
> [  234.729163] __request_module: mdio:-10101110000000100101000101010001
> [  234.732561] __request_module: mdio:-10101110000000100101000101010001
> [  234.735729] __request_module: mdio:00000011011000100000000000000000
> 
> on inserting this SFP.  This comes from this:
> 
> #define MDIO_ID_FMT "%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d"
> #define MDIO_ID_ARGS(_id) \
>         (_id)>>31, ((_id)>>30) & 1, ((_id)>>29) & 1, ((_id)>>28) & 1,   \
>         ((_id)>>27) & 1, ((_id)>>26) & 1, ((_id)>>25) & 1, ((_id)>>24) & 1, \
>         ((_id)>>23) & 1, ((_id)>>22) & 1, ((_id)>>21) & 1, ((_id)>>20) & 1, \
>         ((_id)>>19) & 1, ((_id)>>18) & 1, ((_id)>>17) & 1, ((_id)>>16) & 1, \
>         ((_id)>>15) & 1, ((_id)>>14) & 1, ((_id)>>13) & 1, ((_id)>>12) & 1, \
>         ((_id)>>11) & 1, ((_id)>>10) & 1, ((_id)>>9) & 1, ((_id)>>8) & 1, \
>         ((_id)>>7) & 1, ((_id)>>6) & 1, ((_id)>>5) & 1, ((_id)>>4) & 1, \
>         ((_id)>>3) & 1, ((_id)>>2) & 1, ((_id)>>1) & 1, (_id) & 1
> 
> coupled with:
> 
> static int phy_request_driver_module(struct phy_device *dev, int phy_id)
> {
> ...
>         ret = request_module(MDIO_MODULE_PREFIX MDIO_ID_FMT,
>                              MDIO_ID_ARGS(phy_id));
> 
> The signed-ness of the parameter passed into MDIO_ID_ARGS() matters.
> Hence, (0xae025151)>>31 becomes -1, and %d prints it as -1.
> 
> phy_id should be u32, just like it is everywhere else in phylib. Also,
> MDIO_ID_ARGS() should probably be adapted to not care about the signed-
> ness of its argument.
> 
> Thoughts?

Doh, yes that should be fixed, and that does make sense.
-- 
Florian
