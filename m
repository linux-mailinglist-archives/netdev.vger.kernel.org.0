Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1BE398108
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 19:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbfHURJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 13:09:14 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55607 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729162AbfHURJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 13:09:14 -0400
Received: by mail-wm1-f67.google.com with SMTP id f72so2879066wmf.5;
        Wed, 21 Aug 2019 10:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UMR/Orq2VXEoqtMil/E3IY1gq7rGKQTBq1zwm09du9Q=;
        b=tqWXC1kvVN/WaBA7ZeYmo6gcE3pIp443OzO9+aw8egrUA4pRZMy0X8AUyC2daJ8KJf
         skTQ0anvwcSbQK9BCNHFmphfdHHmKkG4zMA6wdDaFm80m5n0RWfYIuXUEQTKci71s4EW
         sk1Hz7HQRzaAhyndAlwUGZYPzHWnQdPa6RQYf0f4TLSa1nZuFJruwrqWtAlwGQTMoz/A
         CrmlewrKMB9XSTcOboZindf9XWYXO9JCWJzxLutxx7PsRp7z/HUKdQKJWXEVtQc0IaNo
         jX3lZJNmTtKqtHFGGn1H4mjDpe+cqk4EV1814y6Gq2Xkqw3j4zT+0jMg/Gfk4/BXXEvm
         ui9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UMR/Orq2VXEoqtMil/E3IY1gq7rGKQTBq1zwm09du9Q=;
        b=WD2bOFjqC/rpfDKbzBRglFCAjwLvvSl5gsnOlf3K2L/yJ3aIXwDqGG5QbBGiyCqns8
         Ie+wTp7kywYUBcA0X+2mC67Q82GEW8Vc2qcNU2/hFvOT8QT2kz5V54sxKQuruMNuVeZA
         D6DLX82Tc1Gru9jvm6cN020FlopdpCWKRAHvEA2Rd4yXbH+rRUaSkCsZGreTkj59KcmV
         pRD3OTcL5YCG01XWj1Koz/JaZ1bf+tNh9KI4g+7pipo5p1MtjzZkfuAL77JVA+FHwaEa
         4rGIUFhOCQ/w9W4KCsmu/90+zIBsBneRZccjKo1tOqKjTTZBhytwP13VkHmhIj/wuyqu
         qqUA==
X-Gm-Message-State: APjAAAXwFh3A91WlI5RJeVTR5DYST088jU5eDRUZVXzNPipDtTAj+XgS
        Abt2boFyl08M1drXM6FGXZB7IOnG
X-Google-Smtp-Source: APXvYqyM5KTZhwUSWIZPTATAD3HjZa+4IGrcteHQPv8ofuB4n3NLdmYchdJ6ySkM1zfiXt71u4mc6w==
X-Received: by 2002:a1c:a8d7:: with SMTP id r206mr1179944wme.47.1566407350948;
        Wed, 21 Aug 2019 10:09:10 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:7026:65b1:a037:c969? (p200300EA8F047C00702665B1A037C969.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:7026:65b1:a037:c969])
        by smtp.googlemail.com with ESMTPSA id m3sm300425wmc.44.2019.08.21.10.09.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 10:09:10 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH net-next 0/1] Add BASE-T1 PHY support
To:     Christian Herber <christian.herber@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190815153209.21529-1-christian.herber@nxp.com>
 <8c15b855-6947-9930-c3df-71a64fbff33b@gmail.com>
 <AM6PR0402MB379864B810F08D3698618B5F86A80@AM6PR0402MB3798.eurprd04.prod.outlook.com>
 <13e65051-fe4f-5964-30b3-75285e6d2eee@gmail.com>
 <AM6PR0402MB3798FCBF1EE592687B13A3C386AB0@AM6PR0402MB3798.eurprd04.prod.outlook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <5c920846-b8f5-d087-cea4-a8ca3f816127@gmail.com>
Date:   Wed, 21 Aug 2019 19:09:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AM6PR0402MB3798FCBF1EE592687B13A3C386AB0@AM6PR0402MB3798.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.08.2019 15:36, Christian Herber wrote:
> On 19.08.2019 21:07, Heiner Kallweit wrote:
>> Caution: EXT Email
>>
>> On 19.08.2019 08:32, Christian Herber wrote:
>>> On 16.08.2019 22:59, Heiner Kallweit wrote:
>>>> On 15.08.2019 17:32, Christian Herber wrote:
>>>>> This patch adds basic support for BASE-T1 PHYs in the framework.
>>>>> BASE-T1 PHYs main area of application are automotive and industrial.
>>>>> BASE-T1 is standardized in IEEE 802.3, namely
>>>>> - IEEE 802.3bw: 100BASE-T1
>>>>> - IEEE 802.3bp 1000BASE-T1
>>>>> - IEEE 802.3cg: 10BASE-T1L and 10BASE-T1S
>>>>>
>>>>> There are no products which contain BASE-T1 and consumer type PHYs like
>>>>> 1000BASE-T. However, devices exist which combine 100BASE-T1 and 1000BASE-T1
>>>>> PHYs with auto-negotiation.
>>>>
>>>> Is this meant in a way that *currently* there are no PHY's combining Base-T1
>>>> with normal Base-T modes? Or are there reasons why this isn't possible in
>>>> general? I'm asking because we have PHY's combining copper and fiber, and e.g.
>>>> the mentioned Aquantia PHY that combines NBase-T with 1000Base-T2.
>>>>
>>>>>
>>>>> The intention of this patch is to make use of the existing Clause 45 functions.
>>>>> BASE-T1 adds some additional registers e.g. for aneg control, which follow a
>>>>> similiar register layout as the existing devices. The bits which are used in
>>>>> BASE-T1 specific registers are the same as in basic registers, thus the
>>>>> existing functions can be resued, with get_aneg_ctrl() selecting the correct
>>>>> register address.
>>>>>
>>>> If Base-T1 can't be combined with other modes then at a first glance I see no
>>>> benefit in defining new registers e.g. for aneg control, and the standard ones
>>>> are unused. Why not using the standard registers? Can you shed some light on that?
>>>>
>>>> Are the new registers internally shadowed to the standard location?
>>>> That's something I've seen on other PHY's: one register appears in different
>>>> places in different devices.
>>>>
>>>>> The current version of ethtool has been prepared for 100/1000BASE-T1 and works
>>>>> with this patch. 10BASE-T1 needs to be added to ethtool.
>>>>>
>>>>> Christian Herber (1):
>>>>>     Added BASE-T1 PHY support to PHY Subsystem
>>>>>
>>>>>    drivers/net/phy/phy-c45.c    | 113 +++++++++++++++++++++++++++++++----
>>>>>    drivers/net/phy/phy-core.c   |   4 +-
>>>>>    include/uapi/linux/ethtool.h |   2 +
>>>>>    include/uapi/linux/mdio.h    |  21 +++++++
>>>>>    4 files changed, 129 insertions(+), 11 deletions(-)
>>>>>
>>>>
>>>> Heiner
>>>>
>>>
>>> Hi Heiner,
>>>
>>> I do not think the Aquantia part you are describing is publicly
>>> documented, so i cannot comment on that part.
>> Right, datasheet isn't publicly available. All I wanted to say with
>> mentioning this PHY: It's not a rare exception that a PHY combines
>> standard BaseT modes with "non-consumer" modes for special purposes.
>> One practical use case of this proprietary 1000Base-T2 mode is
>> re-using existing 2-pair cabling in aircrafts.
>>
>>> There are multiple reasons why e.g. xBASE-T1 plus 1000BASE-T is
>>> unlikely. First, the is no use-case known to me, where this would be
>>> required. Second, there is no way that you can do an auto-negotiation
>>> between the two, as these both have their own auto-neg defined (Clause
>>> 28/73 vs. Clause 98). Thirdly, if you would ever have a product with
>>> both, I believe it would just include two full PHYs and a way to select
>>> which flavor you want. Of course, this is the theory until proven
>>> otherwise, but to me it is sufficient to use a single driver.
>>>
>> I'm with you if you say it's unlikely. However your statement in the
>> commit message leaves the impression that there can't be such a device.
>> And that's a difference.
>>
>> Regarding "including two full PHYs":
>> This case we have already, there are PHYs combining different IP blocks,
>> each one supporting a specific mode (e.g. copper and fiber). There you
>> also have the case of different autoneg methods, clause 28 vs. clause 37.
>>
>>> The registers are different in the fields they include. It is just that
>>> the flags which are used by the Linux driver, like restarting auto-neg,
>>> are at the same position.
>>>
>> Good to know. Your commit description doesn't mention any specific PHY.
>> I suppose you have PHYs you'd like to operate with the genphy_c45 driver.
>> Could you give an example? And ideally, is a public datasheet available?
>>
>>> Christian
>>>
>>>
>> Heiner
>>
> 
> There are no public BASE-T1 devices on the market right now that use 
> Clause 45 standard registers. The first such products were developed 
> before the IEEE standard (BroadR-Reach) and used Clause 22 access (see 
> e.g. the support in the Kernel for TJA110x).
> 
> The most convenient way to test with a BASE-T1 device would be to use an 
> SFP (e.g. 
> https://technica-engineering.de/produkt/1000base-t1-sfp-module/). 
> Alternative source could be Goepel.
> 
> There are also a number of media-converters around where one could break 
> out the MDIO and connect to a processor. Of course, in all cases it 
> should be made sure that this is a Clause-45 device.
> 
> As all relevant parts are NDA-restricted, this is pretty much all the 
> information I can share.
> 
If no such device is on the market yet, then I'd suggest:
- wait for such a device to see whether genphy_c45 driver is really
  sufficient or whether other chip features require a dedicated driver
  anyway. In the latter case it may be better to add dedicated T1
  functions to phylib.
- add the missing 10BASE-T1L and 10BASE-T1S support meanwhile

The current patch set IMO is a little bit hacky. I'm not 100% happy
with the implicit assumption that there can't be devices supporting
T1 and classic BaseT modes or fiber modes.

Andrew: Do you have an opinion on that?

> Christian
> 
> 
Heiner
