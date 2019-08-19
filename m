Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9E8194D88
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 21:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbfHSTHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 15:07:30 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40919 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728202AbfHSTH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 15:07:29 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so483488wmj.5;
        Mon, 19 Aug 2019 12:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U1JLaDiYCltfAHklDQS2biEfpfLdTNU1x3wSMQscj/s=;
        b=Vdz6lseDIJWjdFYPDTxNWWkmGby8IE2xxBESUWBqj7pguJtMGNsTa88kNsWehwuKGV
         YKn3iq8ovb12dNhgCIhIPQMy+D8IV7wOfHKT2yUQ9ES4AG8LgSqOjOq7uV1A7Ix7qWJr
         Tro0Y7OJ2mGa1hW9ArCN/Um00fRiUhlBqzyEn4/Rdm08aSo0Tg5caLgos96rRNs0mvM0
         1aBuqcJkdWsb90TG1vinNbWcYtwLk9Dg2abANWXCfjWCJbxb7dxRhmNPF7uq7tJnOxm7
         NDC5MTZE7dLMdf0VSJDOORQRUeqP3M3jHYWILPZdIuvfkNPuaPJUeMsWXL8OSqkoeqvl
         AgcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U1JLaDiYCltfAHklDQS2biEfpfLdTNU1x3wSMQscj/s=;
        b=NqGOK599ZbQXbqwH/mL3tw8/LJ4JG1vsXHHlXCNtzRhaPo5J8+oMhnrUdf8S2t2C8l
         X4dgp6hYijsQMkdNuCMFokGM8rISd2vDautM+CXcxlfRPkP3jwPHt1Jug6RkiaL5u9h5
         YcX4QiC8WF/SmShYj9V9gO9WssTqP3MwyUA9zw8jKUr3pu9RwfUjZDpH36r9HUxBvSz0
         6oEHZy2qEeGRwzqiPkbJldd9JsVHuNz0d1MODsGa64IMu4a9SteCrA75VPlti3Ie7/k4
         9K06zWweQpk4Gd1j2buWE/LFNGpXjOdI6Dd1IjLV3OR9MJ7drrNQBJgUlFuV+KRDMCK+
         A0pQ==
X-Gm-Message-State: APjAAAWUJeysiFunpW0MRQuT3iowPoUZFqhsouz2h9ApbJrYOroepozn
        XW6WWobDxYteJTCvDLlfNBAyx0u7
X-Google-Smtp-Source: APXvYqznhLsoBZ5h509LqRx3ejIvQPCSEsvkFuq4GGr3lyYKw3hlmUtwQbmfESebI65aX5NDb9Tczg==
X-Received: by 2002:a7b:c4d2:: with SMTP id g18mr22227876wmk.79.1566241646910;
        Mon, 19 Aug 2019 12:07:26 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f47:db00:69f9:84c:2cc6:baef? (p200300EA8F47DB0069F9084C2CC6BAEF.dip0.t-ipconnect.de. [2003:ea:8f47:db00:69f9:84c:2cc6:baef])
        by smtp.googlemail.com with ESMTPSA id j16sm14216835wrp.62.2019.08.19.12.07.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 12:07:26 -0700 (PDT)
Subject: Re: [PATCH net-next 0/1] Add BASE-T1 PHY support
To:     Christian Herber <christian.herber@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190815153209.21529-1-christian.herber@nxp.com>
 <8c15b855-6947-9930-c3df-71a64fbff33b@gmail.com>
 <AM6PR0402MB379864B810F08D3698618B5F86A80@AM6PR0402MB3798.eurprd04.prod.outlook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <13e65051-fe4f-5964-30b3-75285e6d2eee@gmail.com>
Date:   Mon, 19 Aug 2019 21:07:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AM6PR0402MB379864B810F08D3698618B5F86A80@AM6PR0402MB3798.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.08.2019 08:32, Christian Herber wrote:
> On 16.08.2019 22:59, Heiner Kallweit wrote:
>> On 15.08.2019 17:32, Christian Herber wrote:
>>> This patch adds basic support for BASE-T1 PHYs in the framework.
>>> BASE-T1 PHYs main area of application are automotive and industrial.
>>> BASE-T1 is standardized in IEEE 802.3, namely
>>> - IEEE 802.3bw: 100BASE-T1
>>> - IEEE 802.3bp 1000BASE-T1
>>> - IEEE 802.3cg: 10BASE-T1L and 10BASE-T1S
>>>
>>> There are no products which contain BASE-T1 and consumer type PHYs like
>>> 1000BASE-T. However, devices exist which combine 100BASE-T1 and 1000BASE-T1
>>> PHYs with auto-negotiation.
>>
>> Is this meant in a way that *currently* there are no PHY's combining Base-T1
>> with normal Base-T modes? Or are there reasons why this isn't possible in
>> general? I'm asking because we have PHY's combining copper and fiber, and e.g.
>> the mentioned Aquantia PHY that combines NBase-T with 1000Base-T2.
>>
>>>
>>> The intention of this patch is to make use of the existing Clause 45 functions.
>>> BASE-T1 adds some additional registers e.g. for aneg control, which follow a
>>> similiar register layout as the existing devices. The bits which are used in
>>> BASE-T1 specific registers are the same as in basic registers, thus the
>>> existing functions can be resued, with get_aneg_ctrl() selecting the correct
>>> register address.
>>>
>> If Base-T1 can't be combined with other modes then at a first glance I see no
>> benefit in defining new registers e.g. for aneg control, and the standard ones
>> are unused. Why not using the standard registers? Can you shed some light on that?
>>
>> Are the new registers internally shadowed to the standard location?
>> That's something I've seen on other PHY's: one register appears in different
>> places in different devices.
>>
>>> The current version of ethtool has been prepared for 100/1000BASE-T1 and works
>>> with this patch. 10BASE-T1 needs to be added to ethtool.
>>>
>>> Christian Herber (1):
>>>    Added BASE-T1 PHY support to PHY Subsystem
>>>
>>>   drivers/net/phy/phy-c45.c    | 113 +++++++++++++++++++++++++++++++----
>>>   drivers/net/phy/phy-core.c   |   4 +-
>>>   include/uapi/linux/ethtool.h |   2 +
>>>   include/uapi/linux/mdio.h    |  21 +++++++
>>>   4 files changed, 129 insertions(+), 11 deletions(-)
>>>
>>
>> Heiner
>>
> 
> Hi Heiner,
> 
> I do not think the Aquantia part you are describing is publicly 
> documented, so i cannot comment on that part.
Right, datasheet isn't publicly available. All I wanted to say with
mentioning this PHY: It's not a rare exception that a PHY combines
standard BaseT modes with "non-consumer" modes for special purposes.
One practical use case of this proprietary 1000Base-T2 mode is
re-using existing 2-pair cabling in aircrafts.

> There are multiple reasons why e.g. xBASE-T1 plus 1000BASE-T is 
> unlikely. First, the is no use-case known to me, where this would be 
> required. Second, there is no way that you can do an auto-negotiation 
> between the two, as these both have their own auto-neg defined (Clause 
> 28/73 vs. Clause 98). Thirdly, if you would ever have a product with 
> both, I believe it would just include two full PHYs and a way to select 
> which flavor you want. Of course, this is the theory until proven 
> otherwise, but to me it is sufficient to use a single driver.
> 
I'm with you if you say it's unlikely. However your statement in the
commit message leaves the impression that there can't be such a device.
And that's a difference.

Regarding "including two full PHYs":
This case we have already, there are PHYs combining different IP blocks,
each one supporting a specific mode (e.g. copper and fiber). There you
also have the case of different autoneg methods, clause 28 vs. clause 37.

> The registers are different in the fields they include. It is just that 
> the flags which are used by the Linux driver, like restarting auto-neg, 
> are at the same position.
> 
Good to know. Your commit description doesn't mention any specific PHY.
I suppose you have PHYs you'd like to operate with the genphy_c45 driver.
Could you give an example? And ideally, is a public datasheet available?

> Christian
> 
> 
Heiner
