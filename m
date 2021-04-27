Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8294736C9A2
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 18:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236572AbhD0QmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 12:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236647AbhD0Qlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 12:41:45 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2A6C06175F;
        Tue, 27 Apr 2021 09:41:00 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id i190so2164833pfc.12;
        Tue, 27 Apr 2021 09:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fRlRng113AqCi5rS2c/w+FmvO2gvMQdkL15LlhC7fRY=;
        b=KDg/xbHZVqgef4V+q+sgpFpKOsk1EwElT5BgKs0BZjbMt++ijRpNOLOUmkOo121x5+
         khYFmQdTdvgqDK2kzb530kbjRgOCREzfHmgO4jUbGEbsOmlpX1nKvu/WGkImjaxykeTN
         kO45FR+nGKuGXslS66hlQ7sRABMQV7vBo2tj+135dEy/gF/XJOqGgBZ1BRyRhg5pXkBj
         07NAvbQ5A+YOYj3upje3LxK1iSWkZo3/BlWMqEh48MY1R9jw7lblwiaEStYlekb27QRA
         QBKNyl2RmYs5oqf7TFFwHbsDQuq9UgKyVpo5NH/T2UZHMNR81d4NOH0hr1mQqr/HLrED
         giZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fRlRng113AqCi5rS2c/w+FmvO2gvMQdkL15LlhC7fRY=;
        b=rUXStxi5gKoTPoazS65twbItaB2YsyboHTwDR1OldDAi8tXqn/Yp5CPjIV0gYSeTtA
         Z2PTzvlVyH5a3DuNPbXncheuBS5IDvyy5/X7krqkbAcRWFsoBHfVwwv0HRZS7Rk/QbWV
         55IBlPRfp3sVNF47oJU5Go562YeJBydwBJZbE0J0D5CToHl2tmYQqbVkLVbORUwVCWxX
         41yTU5p26bncLz261IVJDEtbgpK+FVsAdtK3Im7eSNdDVM8GTTRUF4lpgs/xDGiuH71f
         CjkzrLfxlV7WeUXXlcGQKObQl2YlT88OuaoOtQ9lQS9wNMU6VTUSMom7yv+SuCR5tlxo
         Ihqw==
X-Gm-Message-State: AOAM531QiKMjcJ2UoXksjqqLYewY3NGPN67irZ+WX3uNcBw4PRINwIVR
        3+xLQs0EeWmL3CwFkbCzn6o=
X-Google-Smtp-Source: ABdhPJyIKddBlaWCnhFlSLjFt25IPh43+8IYPZ7Hi/ZJpaoqJbQTySlexQUi2IHv8HndPvdELyR3mw==
X-Received: by 2002:a63:f608:: with SMTP id m8mr22045137pgh.54.1619541660395;
        Tue, 27 Apr 2021 09:41:00 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t32sm2965131pfg.168.2021.04.27.09.40.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Apr 2021 09:40:59 -0700 (PDT)
Subject: Re: [PATCH net-next v3 0/6] provide generic net selftest support
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
References: <20210419130106.6707-1-o.rempel@pengutronix.de>
 <DB8PR04MB67951B9C6AB1620E807205F2E6459@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210423043729.tup7nntmmyv6vurm@pengutronix.de>
 <DB8PR04MB6795479FBF086751D16080E2E6419@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6416c580-0df9-7d36-c42d-65293c40aa25@gmail.com>
Date:   Tue, 27 Apr 2021 09:40:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB6795479FBF086751D16080E2E6419@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/26/2021 9:48 PM, Joakim Zhang wrote:
> 
>> -----Original Message-----
>> From: Oleksij Rempel <o.rempel@pengutronix.de>
>> Sent: 2021Äê4ÔÂ23ÈÕ 12:37
>> To: Joakim Zhang <qiangqing.zhang@nxp.com>
>> Cc: Shawn Guo <shawnguo@kernel.org>; Sascha Hauer
>> <s.hauer@pengutronix.de>; Andrew Lunn <andrew@lunn.ch>; Florian Fainelli
>> <f.fainelli@gmail.com>; Heiner Kallweit <hkallweit1@gmail.com>; Fugang
>> Duan <fugang.duan@nxp.com>; kernel@pengutronix.de;
>> netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
>> linux-kernel@vger.kernel.org; dl-linux-imx <linux-imx@nxp.com>; Fabio
>> Estevam <festevam@gmail.com>; David Jander <david@protonic.nl>; Russell
>> King <linux@armlinux.org.uk>; Philippe Schenker
>> <philippe.schenker@toradex.com>
>> Subject: Re: [PATCH net-next v3 0/6] provide generic net selftest support
>>
>> Hi Joakim,
>>
>> On Fri, Apr 23, 2021 at 03:18:32AM +0000, Joakim Zhang wrote:
>>>
>>> Hi Oleksij,
>>>
>>> I look both stmmac selftest code and this patch set. For stmmac, if PHY
>> doesn't support loopback, it will fallthrough to MAC loopback.
>>> You provide this generic net selftest support based on PHY loopback, I have a
>> question, is it possible to extend it also support MAC loopback later?
>>
>> Yes. If you have interest and time to implement it, please do.
>> It should be some kind of generic callback as phy_loopback() and if PHY and
>> MAC loopbacks are supported we need to tests both variants.
> Hi Oleksij,
> 
> Yes, I can try to implement it when I am free, but I still have some questions:
> 1. Where we place the generic function? Such as mac_loopback().
> 2. MAC is different from PHY, need program different registers to enable loopback on different SoCs, that means we need get MAC private data from "struct net_device".
> So we need a callback for MAC drivers, where we extend this callback? Could be "struct net_device_ops"? Such as ndo_set_loopback?

Even for PHY devices, if we implemented external PHY loopback in the
future, the programming would be different from one vendor to another. I
am starting to wonder if the existing ethtool self-tests are the best
API to expose the ability for an user to perform PHY and MAC loopback
testing.

From an Ethernet MAC and PHY driver perspective, what I would imagine we
could have for a driver API is:

enum ethtool_loopback_mode {
	ETHTOOL_LOOPBACK_OFF,
	ETHTOOL_LOOPBACK_PHY_INTERNAL,
	ETHTOOL_LOOPBACK_PHY_EXTERNAL,
	ETHTOOL_LOOPBACK_MAC_INTERNAL,
	ETHTOOL_LOOPBACK_MAC_EXTERNAL,
	ETHTOOL_LOOPBACK_FIXTURE,
	__ETHTOOL_LOOPBACK_MAX
};

	int (*ndo_set_loopback_mode)(struct net_device *dev, enum
ethtool_loopback_mode mode);

and within the Ethernet MAC driver you would do something like this:

	switch (mode) {
	case ETHTOOL_LOOPBACK_PHY_INTERNAL:
	case ETHTOOL_LOOPBACK_PHY_EXTERNAL:
	case ETHTOOL_LOOPBACK_OFF:
		ret = phy_loopback(ndev->phydev, mode);
		break;
	/* Other case statements implemented in driver */
	
we would need to change the signature of phy_loopback() to accept being
passed ethtool_loopback_mode so we can support different modes.

Whether we want to continue using the self-tests API, or if we implement
a new ethtool command in order to request a loopback operation is up for
discussion.
-- 
Florian
