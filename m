Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD377B941
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 07:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfGaFxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 01:53:55 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37620 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfGaFxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 01:53:54 -0400
Received: by mail-wm1-f68.google.com with SMTP id f17so58594196wme.2;
        Tue, 30 Jul 2019 22:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RZKZGhRUKm32qVx6L9wGIUtZwIsOV1pW8pNma7jRm+g=;
        b=ZjZdMTRihTUS5KrNVTrh9HES33YOG4Nv3KPcjebcwbPvdI39SfCVf2FXPiqA+E3nF7
         Sxwoof6JzXR4+zwZzsDf5LVSxujbv0VosEmHGjEL6TtNN5jVG1HpHJDvLKEm8IbXvaBu
         aVtjroOEf1kmLRlkWSYaw7/ETzJaRSvyU2a1hk46vv8VTEzQVTFGOcr3p0WHa4DHRsH8
         Vp9aqQR5lvyg2lpkFzZuFFk5dAwATgM9sRnXM4BKS0vQpcEhve7kOPxaiswBmsuRZoP2
         CKTNv7KRpM4/ZPbZ025DHlgcg04uMp2p1a6eDq1oTZFOabJoA8+KB3LqS4Euf4mzcYdz
         VoGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RZKZGhRUKm32qVx6L9wGIUtZwIsOV1pW8pNma7jRm+g=;
        b=EVMhZVOJgiwr+SrKdjmVgi104qbJ3+f+aigyuC/m5eMAppzEUa6ZSjmKVNFsZ8hjAB
         jPUeDgkE8diPJdeQ58ftrBXuSWQ+gfKcem7FkzDACTYIw+K81a8YPu8D8QOf6tccp6lG
         6cly7WwuVNqIJG3FVhwru871NHJ9Hqqg82jU+f9IEmBs3i2EQVHZ4OKmcV0pxbV0ttHI
         jneKu6O76oYH/S8qDIkPA6+iOMEZWyrSCnkVmjFlq5t5lY9hCiGlwFDn+nZGGiScSlJB
         +cglUFeZAfzCPGHs6wvxhSlY2Ik1tr9DJ4TqUXJhNgRTkj4MO5yn4gfHTrykl6Hrc71R
         ufaQ==
X-Gm-Message-State: APjAAAUIW3a62TplpO7D84J/Qn147cyiZPu7c5y7qqlZX8OHum1HSIZt
        yfeiuv5iQqxVzgpS2VzeqWg=
X-Google-Smtp-Source: APXvYqy9kIQV6RrRdwgRng1A2y1wC+r61hrtqhs00ZxtlPT2UeZ3mo46NyLIWCayILUtnie1h/MjfQ==
X-Received: by 2002:a7b:c310:: with SMTP id k16mr67887905wmj.133.1564552431983;
        Tue, 30 Jul 2019 22:53:51 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:f423:8074:ec73:3cf8? (p200300EA8F434200F4238074EC733CF8.dip0.t-ipconnect.de. [2003:ea:8f43:4200:f423:8074:ec73:3cf8])
        by smtp.googlemail.com with ESMTPSA id g19sm76215914wmg.10.2019.07.30.22.53.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 22:53:51 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] net: phy: broadcom: set features explicitly
 for BCM54616S
To:     Tao Ren <taoren@fb.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
References: <20190730002532.85509-1-taoren@fb.com>
 <20190730033558.GB20628@lunn.ch>
 <aff2728d-5db1-50fd-767c-29b355890323@fb.com>
 <bdfe07d3-66b4-061a-a149-aa2aef94b9b7@gmail.com>
 <f59c2ae9-ef44-1e1b-4ae2-216eb911e92e@fb.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <41c1f898-aee8-d73a-386d-c3ce280c5a1b@gmail.com>
Date:   Wed, 31 Jul 2019 07:53:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <f59c2ae9-ef44-1e1b-4ae2-216eb911e92e@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.07.2019 02:12, Tao Ren wrote:
> On 7/29/19 11:00 PM, Heiner Kallweit wrote:
>> On 30.07.2019 07:05, Tao Ren wrote:
>>> On 7/29/19 8:35 PM, Andrew Lunn wrote:
>>>> On Mon, Jul 29, 2019 at 05:25:32PM -0700, Tao Ren wrote:
>>>>> BCM54616S feature "PHY_GBIT_FEATURES" was removed by commit dcdecdcfe1fc
>>>>> ("net: phy: switch drivers to use dynamic feature detection"). As dynamic
>>>>> feature detection doesn't work when BCM54616S is working in RGMII-Fiber
>>>>> mode (different sets of MII Control/Status registers being used), let's
>>>>> set "PHY_GBIT_FEATURES" for BCM54616S explicitly.
>>>>
>>>> Hi Tao
>>>>
>>>> What exactly does it get wrong?
>>>>
>>>>      Thanks
>>>> 	Andrew
>>>
>>> Hi Andrew,
>>>
>>> BCM54616S is set to RGMII-Fiber (1000Base-X) mode on my platform, and none of the features (1000BaseT/100BaseT/10BaseT) can be detected by genphy_read_abilities(), because the PHY only reports 1000BaseX_Full|Half ability in this mode.
>>>
>> Are you going to use the PHY in copper or fibre mode?
>> In case you use fibre mode, why do you need the copper modes set as supported?
>> Or does the PHY just start in fibre mode and you want to switch it to copper mode?
> 
> Hi Heiner,
> 
> The phy starts in fiber mode and that's the mode I want.
> My observation is: phydev->link is always 0 (Link status bit is never set in MII_BMSR) by using dynamic ability detection on my machine. I checked phydev->supported and it's set to "AutoNeg | TP | MII | Pause | Asym_Pause" by dynamic ability detection. Is it normal/expected? Or maybe the fix should go to different places? Thank you for your help.
> 

Not sure whether you stated already which kernel version you're using.
There's a brand-new extension to auto-detect 1000BaseX:
f30e33bcdab9 ("net: phy: Add more 1000BaseX support detection")
It's included in the 5.3-rc series.

If a feature can be read from a vendor-specific register only,
then the preferred way is: Implement callback get_features in
the PHY driver, call genphy_read_abilities for the basic features
and complement it with reading the vendor-specific register(s).

> 
> Thanks,
> 
> Tao
> 
Heiner
