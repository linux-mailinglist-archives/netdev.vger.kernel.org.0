Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1066A96A92
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730962AbfHTUaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 16:30:12 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36164 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730821AbfHTUaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 16:30:11 -0400
Received: by mail-wm1-f65.google.com with SMTP id g67so3799340wme.1
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 13:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R7RVDKbO2K8Ufgr1MxqJ2UTp/jFy87MA3LRDZfKRqmQ=;
        b=DoNi/uSWEg/Leu2SCClOkCeFikHaWY5x9l/9M+EAax9mnUZFlWrEHxLAZ5E6qSq8gy
         LCKaQlehgvEGu0lyV9PGLu6KhLIh5aef3qmMrvh/r9t4+/6EhTfiDuAhlWwa8ptAb5c3
         rG1tPD2U6i7m1CgsvJ0oHKe6104z59kH5SAt7bfJUnrq3ovmpD+lrnTYPBI0+TbVuzFv
         NiwRpKnMxAx6/WXqEd35ywvmoTAmu17KSDC6UWA/gSogbojqxkxsTmp5oXcup5oIGDUi
         rCTv7hT5dDJR2+dyfIJWvwKcBG2EGnoOkCIQj+s2sltcJyb//35tgLoDhUiMzWkbT1sT
         SlQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R7RVDKbO2K8Ufgr1MxqJ2UTp/jFy87MA3LRDZfKRqmQ=;
        b=PnSD57mYAotZe85XJLAfHC3tbu4zQmOG5C8XrmIvQlGFIGI9mGYYtOKdwca2HQdpT7
         Oghx7AFD7m8H+c0HzY4YDwFwzWSBU4iNAtOd2VOKJHWz3Bq/vV1ob37hcH1dE9qEm46f
         tKouH4+k/PUJDvjRdybEXLYsb7u6fmoOWvlK7BUW9xPN5RSu/iPgtNWlgapvExYTa5E/
         IqucEnhYU6SxvSVlMZJ1F7AtWldvnJY4fYzvwW2UeZ3CuvlUXjfGvUOU4WcGwJe4NF7n
         /rB/kbJw15aLXVhd5DLipT/Yx9cVjCPUl5WWQpQgdDrYNJvJdrUhT8siKsCOQtpjYbUr
         3PTA==
X-Gm-Message-State: APjAAAULL1blrsGaeqwnmBvepzfTiM2cBsnCSi4WNdRz8DfR0Z/gqSr9
        2kLyKMNFdwqoZoxsRE/SJdI=
X-Google-Smtp-Source: APXvYqzg0Yx7p7nWSzuc1n4D3NC++BK+Q4QT6AUypOKV9STc9KHBkLkvhK3KDzMa+EkfHcKsddtI/A==
X-Received: by 2002:a1c:24c3:: with SMTP id k186mr1937604wmk.126.1566333009720;
        Tue, 20 Aug 2019 13:30:09 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f47:db00:f45f:fa9a:bc64:6533? (p200300EA8F47DB00F45FFA9ABC646533.dip0.t-ipconnect.de. [2003:ea:8f47:db00:f45f:fa9a:bc64:6533])
        by smtp.googlemail.com with ESMTPSA id t24sm755793wmj.14.2019.08.20.13.30.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 13:30:09 -0700 (PDT)
Subject: Re: net: micrel: confusion about phyids used in driver
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        kernel@pengutronix.de, Ravi.Hegde@microchip.com,
        Tristram.Ha@microchip.com, Yuiko.Oshino@microchip.com
References: <20190509202929.wg3slwnrfhu4f6no@pengutronix.de>
 <da599967-c423-80dd-945d-5b993c041e90@gmail.com>
 <20190509210745.GD11588@lunn.ch>
 <20190510072243.h6h3bgvr2ovsh5g5@pengutronix.de>
 <20190702203152.gviukfldjhdnmu7j@pengutronix.de>
 <BL0PR11MB3251651EB9BC45DF4282D51D8EF80@BL0PR11MB3251.namprd11.prod.outlook.com>
 <20190808083637.g77loqpgkzi63u55@pengutronix.de>
 <20190820202503.xauhbrj24p3vcoxp@pengutronix.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <2cadf598-1c5d-2d22-e7d3-5aed75a57917@gmail.com>
Date:   Tue, 20 Aug 2019 22:30:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
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

On 20.08.2019 22:25, Uwe Kleine-König wrote:
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

If two PHYs have same ID but need different drivers, then callback
match_phy_device may have to be implemented, provided that the PHYs
can be differentiated by some other register content.
See Realtek PHY driver for an example.

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

