Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86BCA29FF4
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 22:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404010AbfEXUip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 16:38:45 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46447 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfEXUip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 16:38:45 -0400
Received: by mail-wr1-f68.google.com with SMTP id r7so11173205wrr.13
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 13:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+ZphBemP3UPakFGa2M+bXSLNsJ8X58abSVmckx0Msw8=;
        b=NfYEHFF8rH80qFbyKPkdSxFGUJsp4IoRpNBrHoWxvEd+MYvy3K+s1mkYomolFc465G
         MxCq7B20YqVGd04fuIshgh4cgFZq3/MV9su/hAXmd6++/9UJXl0RkLvb5fPpCgfnODLH
         hrGgSCaOPnxYKU2PsH1JBBg2BD8KyAHsaDnodaDC3oYVp8gLI8SFso7I/GPpeD6VSc/e
         zfFKE8ea96eKcaoHa7Laiz/Djc2d8ttoh70xtocH1Xh9umMKAkKm8rrVZlIvYbg8zbZs
         KI8xJG1v3tKQndcgL1PCUhXYt0v5eAoSLMvme/rs4X/vZOxyBxb1CS26SzrUqbJC5/6h
         0oXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+ZphBemP3UPakFGa2M+bXSLNsJ8X58abSVmckx0Msw8=;
        b=J+V4AwgsgyH4V2R7KHhz48WPgo6IjZc9llZdNWb0l5EsEWtiGbVNAdPdAvY03nYodF
         qD3cqcQLVNmSy3AccxppwEi7BCz/D4bHjRf3N5ybsNsEv7spwozhW/wFOLWe0AOKUfHa
         F4356IkZfzfwVqJr0t6b2WVToYiHhVCNe9Ex0k7Hd/CvdROfwFqblPi5+LqcQ7WzB52l
         5/E80SLTaw4pBTT7ejls+bKPq0kWc0jZi7y9I/QGXflWJ/046vxTgwlCtUoyM40HzTVJ
         gYnKbaLeOGekhjjSi3evfy2EZK20VrzG/uFzelKgXjL18m3CH0ABRHMU0LwEOlVANp5Y
         hafg==
X-Gm-Message-State: APjAAAWh3TZ+kpiPo08aj012kdYmp2S+U5lRDZS0URrxQVqWOz8gnrvy
        YEol8qe/U/85ji+G3meaLfs=
X-Google-Smtp-Source: APXvYqzS+ufEeLRoxjM15JOcDxcEK6IYNJ4Mgrl+SD4bIEbcqdAi883eBZYkLesCcEt2lgJTdC+EFw==
X-Received: by 2002:adf:f250:: with SMTP id b16mr33312376wrp.24.1558730323750;
        Fri, 24 May 2019 13:38:43 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:e8aa:5f65:936f:3a1f? (p200300EA8BE97A00E8AA5F65936F3A1F.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:e8aa:5f65:936f:3a1f])
        by smtp.googlemail.com with ESMTPSA id i125sm6611011wmi.2.2019.05.24.13.38.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 13:38:43 -0700 (PDT)
Subject: Re: [PATCH 2/3] net:phy:dp83867: increase SGMII autoneg timer
 duration
To:     Maxim Uvarov <muvarov@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
References: <20190524102541.4478-1-muvarov@gmail.com>
 <20190524102541.4478-3-muvarov@gmail.com>
 <4cd0770d-5eca-a153-1ed3-32472a1a8860@gmail.com>
 <CAJGZr0LfJ5YeDRaTOsADLR+YyLQAwZoKhhtSNL1wiYhEu4uk8w@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <0262d99e-5389-7b73-408a-ac7b86a2176d@gmail.com>
Date:   Fri, 24 May 2019 22:38:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAJGZr0LfJ5YeDRaTOsADLR+YyLQAwZoKhhtSNL1wiYhEu4uk8w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.05.2019 21:55, Maxim Uvarov wrote:
> пт, 24 мая 2019 г. в 20:24, Heiner Kallweit <hkallweit1@gmail.com>:
>>
>> On 24.05.2019 12:25, Max Uvarov wrote:
>>> After reset SGMII Autoneg timer is set to 2us (bits 6 and 5 are 01).
>>> That us not enough to finalize autonegatiation on some devices.
>>> Increase this timer duration to maximum supported 16ms.
>>>
>>> Signed-off-by: Max Uvarov <muvarov@gmail.com>
>>> ---
>>>  drivers/net/phy/dp83867.c | 13 +++++++++++++
>>>  1 file changed, 13 insertions(+)
>>>
>>> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
>>> index afd31c516cc7..66b0a09ad094 100644
>>> --- a/drivers/net/phy/dp83867.c
>>> +++ b/drivers/net/phy/dp83867.c
>>> @@ -297,6 +297,19 @@ static int dp83867_config_init(struct phy_device *phydev)
>>>                       WARN_ONCE(1, "dp83867: err DP83867_10M_SGMII_CFG\n");
>>>                       return ret;
>>>               }
>>> +
>>> +             /* After reset SGMII Autoneg timer is set to 2us (bits 6 and 5
>>> +              * are 01). That us not enough to finalize autoneg on some
>>> +              * devices. Increase this timer duration to maximum 16ms.
>>> +              */
>> In the public datasheet the bits are described as reserved. However, based on
>> the value, I suppose it's not a timer value but the timer resolution.
> 
> No, it's public:
> http://www.ti.com/lit/ds/symlink/dp83867e.pdf page 72.
> 
I just searched for Dp83867 and found this one:
http://www.ti.com/lit/ds/symlink/dp83867cr.pdf
This PHY seems to have the same ID, but the timer bits are at least not
documented.

> SGMII Auto-Negotiation Timer Duration.
> 
I see, we talk about SGMII aneg, not PHY aneg. My bad.

>>
>>> +             val = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4);
>>> +             val &= ~(BIT(5) | BIT(6));
>>> +             ret = phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4, val);
>>> +             if (ret) {
>>> +                     WARN_ONCE(1, "dp83867: error config sgmii auto-neg timer\n");
>>> +                     return ret;
>>
>> Same comment as for patch 1.
> 
> Yes, the same answer. I want to capture hardware error then silently
> return error and then debug it.

If you have hardware with buggy MDIO support, then the problem could occur
in any MDIO access. I think then the WARN should be in the MDIO bus ops.

> WARN is more informative then some random "phy not detected" things.
> 
> Max.
> 
>>
>>> +             }
>>> +
>>>       }
>>>
>>>       /* Enable Interrupt output INT_OE in CFG3 register */
>>>
>>
> 

