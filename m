Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4888D816
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbfHNQab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 12:30:31 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40186 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfHNQaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 12:30:30 -0400
Received: by mail-pf1-f196.google.com with SMTP id w16so1370065pfn.7
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 09:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ENNE6JhpSb770BDXvi0R+kuflXuWnCisvJB70EvJzvA=;
        b=cSOaE7sdpD7LUjJtIRwSobcnNDnti3Cvqrdi4ngdSId7Z3HwoWCze27/60snsWrNAE
         avK51LmqrDXHgiQpONmh0uFM51VdblrBujgT+iEZVd8E/piC79VfZ+WdY+hTTgp4OQHA
         BhuCHUvm1EdtP2z3wtwQbY+bRndVDLcmV60F3NfGoFLk70XSJiAcx/VqNrnodXt9MrQt
         Wk/22ZADXisNZR8Wd0aqPjILdRYp3XVD1k2KgNL/ieSHTdr3BpoUkGUKRGdoNLXTbidg
         oUy9Z2AqoSfqwHrjIJQkkFZDzMqvtKzEmUVYfOh+nJQWeYLnkU1Gey0yHPvwhx/DZLnW
         h48g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ENNE6JhpSb770BDXvi0R+kuflXuWnCisvJB70EvJzvA=;
        b=g8RRH4vWTmJiWFRo13ibWZHU+hfgJpNH8vcS41cZfYFPGlEM5yxxG3uBWKgN0koqPf
         ldBP7KRcZkz6buL7I8t3tEhZ7obJNZY32dRmBLKgdYDBhTWstMOeCNGVpvZ1bHLDiy3E
         88yOc4gsHrshSM9BCVyUMJNQzsbx/gRVEYWPpwo7te15DuVpA6hma+3EfC+z0cZwEclr
         PCibM2+hQZT5jOKKuISnxNv4fOwbuUgv+oTX3iNAfHyRiqecXsss/wv4l4TCwwiGtVeH
         u7/yoHTkWg55WeavPwlDOXaqzGj+hmCX7B6HS7uOe1PxeNNV1D5MjY+piEmTzldm3hnc
         y1Cw==
X-Gm-Message-State: APjAAAWVLUb/PeqicC9rTZ0JHryrz20ip3nU5KGyhDeqUlm9BQNKv/fo
        VDvN30lbvGGh7ROd261muchHIPk7
X-Google-Smtp-Source: APXvYqz3AaABbGRpt/xLoy61mwxsTlZOw7omt4CDRBaL/Ss8e9D26/Iq2c5ig3a82o7bSkzqCNteVQ==
X-Received: by 2002:a63:7d49:: with SMTP id m9mr41602pgn.161.1565800229573;
        Wed, 14 Aug 2019 09:30:29 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 22sm313933pfv.134.2019.08.14.09.30.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 09:30:28 -0700 (PDT)
Subject: Re: [PATCH RFC 2/4] net: phy: allow to bind genphy driver at probe
 time
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Marek Behun <marek.behun@nic.cz>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ac3471d5-deb7-b711-6e74-23f59914758a@gmail.com>
 <b066560d-2cc3-2ea5-5233-e63a612c5aa1@gmail.com>
 <010ae64f-7e48-5e1e-2928-af3c4364f6e3@gmail.com>
 <7225e653-6f93-63fc-8d61-a712318d1949@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <2d1efd4f-9286-f46c-3573-aff72fa9c326@gmail.com>
Date:   Wed, 14 Aug 2019 09:30:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <7225e653-6f93-63fc-8d61-a712318d1949@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/13/19 4:02 PM, Heiner Kallweit wrote:
> On 14.08.2019 00:53, Florian Fainelli wrote:
>> On 8/13/19 2:25 PM, Heiner Kallweit wrote:
>>> In cases like a fixed phy that is never attached to a net_device we
>>> may want to bind the genphy driver at probe time. Setting a PHY ID of
>>> 0xffffffff to bind the genphy driver would fail due to a check in
>>> get_phy_device(). Therefore let's change the PHY ID the genphy driver
>>> binds to to 0xfffffffe. This still shouldn't match any real PHY,
>>> and it will pass the check in get_phy_devcie().
>>>
>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>> ---
>>>  drivers/net/phy/phy_device.c | 3 +--
>>>  include/linux/phy.h          | 4 ++++
>>>  2 files changed, 5 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>>> index 163295dbc..54f80af31 100644
>>> --- a/drivers/net/phy/phy_device.c
>>> +++ b/drivers/net/phy/phy_device.c
>>> @@ -2388,8 +2388,7 @@ void phy_drivers_unregister(struct phy_driver *drv, int n)
>>>  EXPORT_SYMBOL(phy_drivers_unregister);
>>>  
>>>  static struct phy_driver genphy_driver = {
>>> -	.phy_id		= 0xffffffff,
>>> -	.phy_id_mask	= 0xffffffff,
>>> +	PHY_ID_MATCH_EXACT(GENPHY_ID),
>>>  	.name		= "Generic PHY",
>>>  	.soft_reset	= genphy_no_soft_reset,
>>>  	.get_features	= genphy_read_abilities,
>>> diff --git a/include/linux/phy.h b/include/linux/phy.h
>>> index 5ac7d2137..3b07bce78 100644
>>> --- a/include/linux/phy.h
>>> +++ b/include/linux/phy.h
>>> @@ -37,6 +37,10 @@
>>>  #define PHY_1000BT_FEATURES	(SUPPORTED_1000baseT_Half | \
>>>  				 SUPPORTED_1000baseT_Full)
>>>  
>>> +#define GENPHY_ID_HIGH		0xffffU
>>> +#define GENPHY_ID_LOW		0xfffeU
>>> +#define GENPHY_ID		((GENPHY_ID_HIGH << 16) | GENPHY_ID_LOW)
>>
>> This is a possible user ABI change here, if there is anything that
>> relies on reading 0xffff_ffff as a valid PHY OUI, you would be breaking
>> it. We might as well try to assign ourselves a specific PHY OUI, very
>> much like the Linux USB hubs show up with a Linux Foundation vendor ID.
>>
> 
> I see the point. However in get_phy_device() we have the following check
> that should cause a PHY with ID 0xffff_ffff to be ignored. Therefore
> I doubt there's any such PHY ID in use.
> 
> 	/* If the phy_id is mostly Fs, there is no device there */
> 	if ((phy_id & 0x1fffffff) == 0x1fffffff)
> 		return ERR_PTR(-ENODEV);

Indeed, it looks like the phy_id reported through sysfs for fixed PHY is
actually 0, so your change should be fine then, thanks!
-- 
Florian
