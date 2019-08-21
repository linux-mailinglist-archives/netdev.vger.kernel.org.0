Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F64298136
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 19:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbfHURYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 13:24:38 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:38018 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728170AbfHURYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 13:24:37 -0400
Received: by mail-pg1-f176.google.com with SMTP id e11so1691897pga.5
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 10:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KC5I0o7d3Z0/vi8x0/zkMSQ9AwW8lfyeYqB7H+WS89k=;
        b=B4ZHQYpBVo1wiHDTOJMVR8ds6oHg2zkdvjs+fiyCu9LqX1p4NG3cusX+pF2rxWp58z
         UGn4W6RglEP5DIAV5WfKvczA5ZgxewyYevq+pLvpw7g0PaR4DUhC5jw5foW1o3ei8L5t
         R292yD5Jj0oDAk59O4uibS+w0szTZm2CbIx7T5IjIKdNU40AlVxwwLL1JRC+kLrEjeMO
         Ea/zt1BRSabGHop//Pmest+lwOoyvwtpLlQueIRDqV1K9rsgmZvnzA2jBWbxgxCNPUfD
         flh5gRWuCKTeKTZdT/Qa8yf9duwFpWJzCbUs9LxLNKhvpuqD++9x2qzQHQDaBIDe03Rw
         XIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KC5I0o7d3Z0/vi8x0/zkMSQ9AwW8lfyeYqB7H+WS89k=;
        b=Zzn/Alk1mRxM6SgGD9y3h7KEyZCJDm6nZF9JYiMEOAf82IJE80KFwwKR13/S+6i/G5
         NWWGobQ9cwNQ6K5S9MIcWRlaYsjh9E5PJXaxcZfDg1FTYhrd4EDy93GaGSbypgcNEoff
         c4lfHYSfIWCvljcZv9XXQmYCwP8Te72jO0uBBpz2xuXCaEfVgnEf15IfDjQnUjDWYYZw
         b9q1h3GvOQCow5v4edtIthNLMWxSsnLH5QYp2mnW+Kq45zzhaINZxyelh1jq7YIIrKci
         GDLzbZxlfwwztJ/avcUeLca9rqO2BLxHw8jgygZxlGzWE6KU3RYgrz968aIR9v1ju7lY
         j19w==
X-Gm-Message-State: APjAAAXSA2Y77mnpLkeFek334qKEiJqot7fEIE58jA9FcD+t6mHNLx5+
        rGYpIGCvdkxaZTLbL9QTco0=
X-Google-Smtp-Source: APXvYqyfy3IXhMefimp4XHapqEX1aBdABiKki5LQApzKIkx61PFxgKsaKsxrQuqOQ+mnwvL6CI7kLQ==
X-Received: by 2002:aa7:8a47:: with SMTP id n7mr38463391pfa.182.1566408276874;
        Wed, 21 Aug 2019 10:24:36 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s5sm591968pjo.26.2019.08.21.10.24.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 10:24:36 -0700 (PDT)
Subject: Re: net: micrel: confusion about phyids used in driver
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, kernel@pengutronix.de,
        hkallweit1@gmail.com, Ravi.Hegde@microchip.com,
        Tristram.Ha@microchip.com, Yuiko.Oshino@microchip.com,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>
References: <20190509202929.wg3slwnrfhu4f6no@pengutronix.de>
 <da599967-c423-80dd-945d-5b993c041e90@gmail.com>
 <20190509210745.GD11588@lunn.ch>
 <20190510072243.h6h3bgvr2ovsh5g5@pengutronix.de>
 <20190702203152.gviukfldjhdnmu7j@pengutronix.de>
 <BL0PR11MB3251651EB9BC45DF4282D51D8EF80@BL0PR11MB3251.namprd11.prod.outlook.com>
 <20190808083637.g77loqpgkzi63u55@pengutronix.de>
 <20190820202503.xauhbrj24p3vcoxp@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <1057c2c2-e1f0-75ba-3878-dbd52805e0cc@gmail.com>
Date:   Wed, 21 Aug 2019 10:24:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190820202503.xauhbrj24p3vcoxp@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Allan,

On 8/20/19 1:25 PM, Uwe Kleine-König wrote:
> Hello Nicolas,
> 
> there are some open questions regarding details about some PHYs
> supported in the drivers/net/phy/micrel.c driver.
> 
> On Thu, Aug 08, 2019 at 10:36:37AM +0200, Uwe Kleine-König wrote:
>> On Tue, Jul 02, 2019 at 08:55:07PM +0000, Yuiko.Oshino@microchip.com wrote:
>>>> On Fri, May 10, 2019 at 09:22:43AM +0200, Uwe Kleine-König wrote:
>>>>> On Thu, May 09, 2019 at 11:07:45PM +0200, Andrew Lunn wrote:
>>>>>> On Thu, May 09, 2019 at 10:55:29PM +0200, Heiner Kallweit wrote:
>>>>>>> On 09.05.2019 22:29, Uwe Kleine-König wrote:
>>>>>>>> I have a board here that has a KSZ8051MLL (datasheet:
>>>>>>>> http://ww1.microchip.com/downloads/en/DeviceDoc/ksz8051mll.pdf, phyid:
>>>>>>>> 0x0022155x) assembled. The actual phyid is 0x00221556.
> 
> The short version is that a phy with ID 0x00221556 matches two
> phy_driver entries in the driver:
> 
> 	{ .phy_id = PHY_ID_KSZ8031, .phy_id_mask = 0x00ffffff, ... },
> 	{ .phy_id = PHY_ID_KSZ8051, .phy_id_mask = MICREL_PHY_ID_MASK, ... }
> 
> The driver doesn't behave optimal for "my" KSZ8051MLL with both entries
> ... It seems to work, but not all features of the phy are used and the
> bootlog claims this was a KSZ8031 because that's the first match in the
> list.
> 
> So we're in need of someone who can get their hands on some more
> detailed documentation than publicly available to allow to make the
> driver handle the KSZ8051MLL correctly without breaking other stuff.
> 
> I assume you are in a different department of Microchip than the people
> caring for PHYs, but maybe you can still help finding someone who cares?

Allan, is this something you could help with? Thanks!

> 
>>>>>>> I think the datasheets are the source of the confusion. If the
>>>>>>> datasheets for different chips list 0x0022155x as PHYID each, and
>>>>>>> authors of support for additional chips don't check the existing
>>>>>>> code, then happens what happened.
>>>>>>>
>>>>>>> However it's not a rare exception and not Microchip-specific that
>>>>>>> sometimes vendors use the same PHYID for different chips.
>>>>>
>>>>> From the vendor's POV it is even sensible to reuse the phy IDs iff the
>>>>> chips are "compatible".
>>>>>
>>>>> Assuming that the last nibble of the phy ID actually helps to
>>>>> distinguish the different (not completely) compatible chips, we need
>>>>> some more detailed information than available in the data sheets I have.
>>>>> There is one person in the recipents of this mail with an
>>>>> @microchip.com address (hint, hint!).
>>>>
>>>> can you give some input here or forward to a person who can?
>>>
>>> I forward this to the team.
>>
>> This thread still sits in my inbox waiting for some feedback. Did
>> something happen on your side?
> 
> This is still true, didn't hear back from Yuiko Oshino for some time
> now.
> 
> Best regards
> Uwe
> 


-- 
Florian
