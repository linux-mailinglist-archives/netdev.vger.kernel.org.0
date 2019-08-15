Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6BF8F0A8
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 18:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731854AbfHOQeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 12:34:20 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33394 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730156AbfHOQeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 12:34:19 -0400
Received: by mail-wr1-f67.google.com with SMTP id u16so2783696wrr.0;
        Thu, 15 Aug 2019 09:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pTn+NtsTL+V0D+GdWsANpO5LDlMDujGKQnBTFznYvrg=;
        b=b0I5b9umvFU/dTbkGZ8lpI4IO0BntAfcK/I9nuYpwuBM+8XbOgALyBm+ZWw4KA8Rpq
         5QjqOnGNaJK6h456JXrc9md8wR77ry1v2+nExuB1/of/Cx6VQTNlp3zqUydXrs595iLN
         xi5g99hILsigrn9aspf7eQbiNtWPbG3/EiHghM18mEQ2KHNbqW5o0b8YGihRneXoAX1x
         CZGuMee8ohk2PO5cChypZvO4/JWYSUCII8yJCbl1gNJFDyTXDAQ8qKIzq9hW7w2ZpoOq
         veLzzO3eA0lFHqAH2iGJPr8p7wHKS9A17modOPj5hy8g31swF7edmPtCA2tm+NsPkqeN
         nzZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pTn+NtsTL+V0D+GdWsANpO5LDlMDujGKQnBTFznYvrg=;
        b=AHqeCZKgBRsoEAs4kxiOI0EoDhnUw+SSXjunR+OwNfRbSOsuepmp3l8Eil8AtN85dL
         /QD76zKWlTkPw81YLpxwGfFjkoXYBomFVlAbq+w0YiNyUWohMv4dMWJT6Axk5Hxi9s4F
         5frhXVOsQluMS+ZLl0fJbNnDuo+Iqws7b+Ea7TXI6BMUKv8v5F6ZMOtAzXTQ88ryPfez
         D23cSEvK4Qx6xHk3f/cj1YxePklYjTC7KEijDPFo+CE275h1sKzDvbIsdYs27hqqyAeG
         ZkNTxnxLTL2Y9fA8KHSUix2TMcM39OJUFEXVhBZICG9wZmtJg0/tZEksgSheNf6rnb+v
         4UNQ==
X-Gm-Message-State: APjAAAUwN8x9o0b4EVJ2LN83mgEZZey2soZRlLxbG13afrFJSMtmI9sW
        ZKbVVr+pqsgBj6xh56jBNzk=
X-Google-Smtp-Source: APXvYqwOrCQJCIbbsm7t9XfeonICJnDff2rMsiIMCZSORG7Bv+ZFuT2VYG1FcFnDQtFQ42EJPkFZjA==
X-Received: by 2002:adf:b64e:: with SMTP id i14mr6486128wre.248.1565886857510;
        Thu, 15 Aug 2019 09:34:17 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:c0f5:392f:547b:417a? (p200300EA8F2F3200C0F5392F547B417A.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:c0f5:392f:547b:417a])
        by smtp.googlemail.com with ESMTPSA id g14sm5756141wrb.38.2019.08.15.09.34.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 09:34:16 -0700 (PDT)
Subject: Re: [PATCH net-next 1/1] Added BASE-T1 PHY support to PHY Subsystem
To:     Andrew Lunn <andrew@lunn.ch>,
        Christian Herber <christian.herber@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <20190815153209.21529-1-christian.herber@nxp.com>
 <20190815153209.21529-2-christian.herber@nxp.com>
 <20190815155613.GE15291@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <2ca68436-8e49-b0b2-2460-4fcac3094b09@gmail.com>
Date:   Thu, 15 Aug 2019 18:34:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190815155613.GE15291@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.08.2019 17:56, Andrew Lunn wrote:
> On Thu, Aug 15, 2019 at 03:32:29PM +0000, Christian Herber wrote:
>> BASE-T1 is a category of Ethernet PHYs.
>> They use a single copper pair for transmission.
>> This patch add basic support for this category of PHYs.
>> It coveres the discovery of abilities and basic configuration.
>> It includes setting fixed speed and enabling auto-negotiation.
>> BASE-T1 devices should always Clause-45 managed.
>> Therefore, this patch extends phy-c45.c.
>> While for some functions like auto-neogtiation different registers are
>> used, the layout of these registers is the same for the used fields.
>> Thus, much of the logic of basic Clause-45 devices can be reused.
>>
>> Signed-off-by: Christian Herber <christian.herber@nxp.com>
>> ---
>>  drivers/net/phy/phy-c45.c    | 113 +++++++++++++++++++++++++++++++----
>>  drivers/net/phy/phy-core.c   |   4 +-
>>  include/uapi/linux/ethtool.h |   2 +
>>  include/uapi/linux/mdio.h    |  21 +++++++
>>  4 files changed, 129 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
>> index b9d4145781ca..9ff0b8c785de 100644
>> --- a/drivers/net/phy/phy-c45.c
>> +++ b/drivers/net/phy/phy-c45.c
>> @@ -8,13 +8,23 @@
>>  #include <linux/mii.h>
>>  #include <linux/phy.h>
>>  
>> +#define IS_100BASET1(phy) (linkmode_test_bit( \
>> +			   ETHTOOL_LINK_MODE_100baseT1_Full_BIT, \
>> +			   (phy)->supported))
>> +#define IS_1000BASET1(phy) (linkmode_test_bit( \
>> +			    ETHTOOL_LINK_MODE_1000baseT1_Full_BIT, \
>> +			    (phy)->supported))
> 
> Hi Christian
> 
> We already have the flag phydev->is_gigabit_capable. Maybe add a flag
> phydev->is_t1_capable
> 
>> +
>> +static u32 get_aneg_ctrl(struct phy_device *phydev);
>> +static u32 get_aneg_stat(struct phy_device *phydev);
> 
> No forward declarations please. Put the code in the right order so
> they are not needed.
> 
> Thanks
> 
>      Andrew
> 

For whatever reason I don't have the original mail in my netdev inbox (yet).

+	if (IS_100BASET1(phydev) || IS_1000BASET1(phydev))
+		ctrl = MDIO_AN_BT1_CTRL;

Code like this could be problematic once a PHY supports one of the T1 modes
AND normal modes. Then normal modes would be unusable.

I think this scenario isn't completely hypothetical. See the Aquantia
AQCS109 that supports normal modes and (proprietary) 1000Base-T2.

Maybe we need separate versions of the generic functions for T1.
Then it would be up to the PHY driver to decide when to use which
version.

Heiner
