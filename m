Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9839BE5D
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 17:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfHXPDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 11:03:48 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34951 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727638AbfHXPDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 11:03:48 -0400
Received: by mail-wr1-f67.google.com with SMTP id k2so11250291wrq.2;
        Sat, 24 Aug 2019 08:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hiGz5lvlbrWK+uutFSFiz0Vky1xYc1AVTuAhL4+Ad8o=;
        b=gqPvvUY/d5ez/8TAduc0IiVUTQQ4BX0/ywQ378zt64y7ub6jjaRp6lgwS4xqJC0sx+
         fK/HU47NrYzbSHK5kTws5EyLleM6W2GWgq0gmiAiJb1P9ECzPrqfuKcNt5LMUfkyD6Vg
         zgAbJDqGq/7zlO9Bz68GoDDgEqQzXeDKf25ls4xvRRsDtBrqca1wVJFpsvXxqf7TQf/k
         VfGs3xr/H4Gs06uHevXeRLkdtP7eIWYl4P1YM44iYpR/rJEC/Gsrhfo3nZlJy1CTmDs/
         xIntovMLObAXMvoznS47IzJ8zBBVDTqr7ok/UcqNd1L2QfR9wSheJhZNKhNHLtCZ3Xku
         IY9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hiGz5lvlbrWK+uutFSFiz0Vky1xYc1AVTuAhL4+Ad8o=;
        b=YM+Z4/TacdG0GKblsq4bimOzlWKawEPvlBvyqFP/4wEMs53k0rhvgjLy4uEUlT4JxH
         m4YcgLvI9tTcnQ+TXRMEus5hbUgyUbTAQlJEfL/72R7QLtXma+WOlkU29zal9M/jMlXt
         1u+/6U0VlP9FHaHPB8zZrtbR88i+wrLKU5YFs/vCgmC3yV55yK2HcJYt7lQ611RYCpA9
         WczaaUj5AznGGUvFc0M8AHjdjeK96nTAlbFfiKK0sKUkWrM3kyVdVF/Sc7dyn3l07/NB
         lhiOdpmYNrFE9RzMyLJvDWu3/X3cA2Uo6yeYpv4BAQF+ebMSzchlrXdqJPR++mOwprb8
         cTeA==
X-Gm-Message-State: APjAAAXIaFeP5SXAQNvP/ZrhuEjybjXDU86pQfQ3tzxqYJIkmkCtsnoH
        X7OZSe/OkSzww+uGDr9Q/7Ug4WzT
X-Google-Smtp-Source: APXvYqxcr0JM6GRTYqhy4dvHD6srcnr0X2F75Zyf22rRQoAzEDFPPAoY8zo/XKNa47Ji8bSYRyBBdw==
X-Received: by 2002:a5d:4211:: with SMTP id n17mr10570320wrq.137.1566659024925;
        Sat, 24 Aug 2019 08:03:44 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:2069:2121:113c:4840? (p200300EA8F047C0020692121113C4840.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:2069:2121:113c:4840])
        by smtp.googlemail.com with ESMTPSA id w5sm6758939wmm.43.2019.08.24.08.03.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 24 Aug 2019 08:03:44 -0700 (PDT)
Subject: Re: [PATCH net-next 0/1] Add BASE-T1 PHY support
To:     Christian Herber <christian.herber@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190815153209.21529-1-christian.herber@nxp.com>
 <8c15b855-6947-9930-c3df-71a64fbff33b@gmail.com>
 <AM6PR0402MB379864B810F08D3698618B5F86A80@AM6PR0402MB3798.eurprd04.prod.outlook.com>
 <13e65051-fe4f-5964-30b3-75285e6d2eee@gmail.com>
 <AM6PR0402MB3798FCBF1EE592687B13A3C386AB0@AM6PR0402MB3798.eurprd04.prod.outlook.com>
 <5c920846-b8f5-d087-cea4-a8ca3f816127@gmail.com>
 <20190821185715.GA16401@lunn.ch>
 <AM6PR0402MB3798C702793071E34A5659ED86A50@AM6PR0402MB3798.eurprd04.prod.outlook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <1f50cdcf-200d-7c25-35ae-aee011a6a520@gmail.com>
Date:   Sat, 24 Aug 2019 17:03:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AM6PR0402MB3798C702793071E34A5659ED86A50@AM6PR0402MB3798.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.08.2019 09:18, Christian Herber wrote:
> On 21.08.2019 20:57, Andrew Lunn wrote:
>>
>>> The current patch set IMO is a little bit hacky. I'm not 100% happy
>>> with the implicit assumption that there can't be devices supporting
>>> T1 and classic BaseT modes or fiber modes.
>>
>>> Andrew: Do you have an opinion on that?
>>
>> Hi Heiner
>>
>> I would also like cleaner integration. I doubt here is anything in the
>> standard which says you cannot combine these modes. It is more a
>> marketing question if anybody would build such a device. Maybe not
>> directly into a vehicle, but you could imaging a mobile test device
>> which uses T1 to talk to the car and T4 to connect to the garage
>> network?
>>
>> So i don't think we should limit ourselves. phylib should provide a
>> clean, simple set of helpers to perform standard operations for
>> various modes. Drivers can make use of those helpers. That much should
>> be clear. If we try to make genphy support them all simultaneously, is
>> less clear.
>>
>>       Andrew
>>
> 
> If you want to go down this path, then i think we have to ask some more 
> questions. Clause 45 is a very scalable register scheme, it is not a 
> specific class of devices and will be extended and extended.
> 
> Currently, the phy-c45.c supports 10/100/1000/2500/5000/10000 Mbps 
> consumer/enterprise PHYs. This is also an implicit assumption. The 
> register set (e.g. on auto-neg) used for this will also only support 
> these modes and nothing more, as it is done scaling.
> 
> Currently not supported, but already present in IEEE 802.3:
> - MultiGBASE-T (25/40 Gbps) (see e.g. MultiGBASE-T AN control 1 register)
> - BASE-T1
> - 10BASE-T1
> - NGBASE-T1
> 
> And surely there are some on the way or already there that I am not 
> aware of.
> 
> To me, one architectural decision point is if you want to have generic 
> support for all C45 PHYs in one file, or if you want to split it by 
> device class. I went down the first path with my patch, as this is the 
> road gone also with the existing code.
> 
> If you want to split BASE-T1, i think you will need one basic C45 
> library (genphy_c45_pma_read_abilities() is a good example of a function 
> that is not specific to a device class). On the other hand, 
> genphy_c45_pma_setup_forced() is not a generic function at this point as 
> it supports only a subset of devices managed in C45.
> 
> I tend to agree with you that splitting is the best way to go in the 
> long run, but that also requires a split of the existing phy-c45.c into 
> two IMHO.
> 
BASE-T1 seems to be based on Clause 45 (at least Clause 45 MDIO),
but it's not fully compliant with Clause 45. Taking AN link status
as an example: 45.2.7.2.7 states that link-up is signaled in bit 7.1.2.
If BASE-T1 uses a different register, then it's not fully Clause 45
compatible.
Therefore also my question for the datasheet of an actual BASE-T1 PHY,
as I would be curious whether it shadows the link-up bit from 7.513.2
to 7.1.2 to be Clause 45 compliant. Definitely reading bit 7.513.2
is nothing that belongs into a genphy_c45_ function.

The extension to genphy_c45_pma_read_abilities() looks good to me,
for the other parts I'd like to see first how real world BASE-T1 PHYs
handle it. If they shadow the T1-specific bits to the Clause 45
standard ones, we should be fine. Otherwise IMO we have to add
separate T1 functions to phylib.

Heiner














