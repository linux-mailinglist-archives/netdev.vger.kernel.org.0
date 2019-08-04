Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30D9F80A07
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 10:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbfHDIkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 04:40:42 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39379 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbfHDIkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 04:40:41 -0400
Received: by mail-wr1-f68.google.com with SMTP id x4so28179261wrt.6;
        Sun, 04 Aug 2019 01:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jHyKGF97oHLx8vmo+i9ilQ31BEkYlwMC/EOcdvIhgqE=;
        b=lyNBhwGX5ZVs5N1BzYhR5twQUujSfeUmpa3GT3UkR6qqvj1K6bs6A73sPMrbEdvqtJ
         zzdl5BCbieNZOFM5ygUemTkC95MVTIlId3hfBDZEuaCZSt13Rmn00kg+nXLyxPx37hjE
         cPY6fy6oYr32L6CWic8KzbbC7KyS7QQmnytJICt/tml5O9yjXN6ehNd3xAPR2KdZclP+
         BnBAa8QvDPlzCSHHOYHRZrEnN7lCqRHAz4S7HaKNcOwoNzFQyah9zNPL/I1s5GnzWGXu
         JFWwYORk2NPxYjvTPP8DEke97JyhEp5YQgi5wyyMbJbkCECpdv5ac2lPfqn8p7fibzkW
         bSBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jHyKGF97oHLx8vmo+i9ilQ31BEkYlwMC/EOcdvIhgqE=;
        b=QMTCRbNboiel2OuTuNQ6k4VoIKHrutY8elA+5YzeV4v+4F/YNA6aZ85QsSKCsyRJVh
         fLTk7dH8/3uI+yqwpqrGkYJyx3gy1Q2DCh047qTGSOeLiHBbk1RB/DHule4C/zsdGwug
         eWQ4fZzRX+K2aETrKUbF1B+8s0MvJDQ6Y1LJ4Ioje1OBeGXpF9GrDB31eqx+XNYALFeL
         FU4KaK4ryfwOR1AniHriDd4M1KdEnK1IxI4g0Egom3nkWtnFjOc+OLZ5gxdtfQzDjJ5q
         pB7GP8JtNvSDAVesemq24cMXw8iS5u8vhbYlJrTb355jb0aFq+Idzf813dItpJQzt+rE
         taeA==
X-Gm-Message-State: APjAAAXaHeEzxNU+41aFTfIdHN4C6XRhtGdjvorgqkgrkYATH919+k33
        zM+uyIlw8Ws8LdmK9gzq9nHnjmDp
X-Google-Smtp-Source: APXvYqxSpGppNunbyzWK5brcrf+R0WbZ6FVxWzIhSdZvwM7dj6yTTDJiQs1yMkZW3ZKA1He0pg8ZWA==
X-Received: by 2002:adf:b195:: with SMTP id q21mr11938356wra.2.1564908039280;
        Sun, 04 Aug 2019 01:40:39 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:9900:d80f:58c5:990d:c59b? (p200300EA8F289900D80F58C5990DC59B.dip0.t-ipconnect.de. [2003:ea:8f28:9900:d80f:58c5:990d:c59b])
        by smtp.googlemail.com with ESMTPSA id o20sm213884416wrh.8.2019.08.04.01.40.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Aug 2019 01:40:38 -0700 (PDT)
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
 <41c1f898-aee8-d73a-386d-c3ce280c5a1b@gmail.com>
 <fd179662-b9f9-4813-b9b5-91dbd796596e@fb.com>
 <88f4d709-d9bb-943c-37a9-aeebe8ca0ebc@fb.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e4eb6ef6-5536-612e-49c8-d144fc8eb386@gmail.com>
Date:   Sun, 4 Aug 2019 10:40:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <88f4d709-d9bb-943c-37a9-aeebe8ca0ebc@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.08.2019 07:20, Tao Ren wrote:
> On 7/30/19 11:00 PM, Tao Ren wrote:
>> On 7/30/19 10:53 PM, Heiner Kallweit wrote:
>>> On 31.07.2019 02:12, Tao Ren wrote:
>>>> On 7/29/19 11:00 PM, Heiner Kallweit wrote:
>>>>> On 30.07.2019 07:05, Tao Ren wrote:
>>>>>> On 7/29/19 8:35 PM, Andrew Lunn wrote:
>>>>>>> On Mon, Jul 29, 2019 at 05:25:32PM -0700, Tao Ren wrote:
>>>>>>>> BCM54616S feature "PHY_GBIT_FEATURES" was removed by commit dcdecdcfe1fc
>>>>>>>> ("net: phy: switch drivers to use dynamic feature detection"). As dynamic
>>>>>>>> feature detection doesn't work when BCM54616S is working in RGMII-Fiber
>>>>>>>> mode (different sets of MII Control/Status registers being used), let's
>>>>>>>> set "PHY_GBIT_FEATURES" for BCM54616S explicitly.
>>>>>>>
>>>>>>> Hi Tao
>>>>>>>
>>>>>>> What exactly does it get wrong?
>>>>>>>
>>>>>>>      Thanks
>>>>>>> 	Andrew
>>>>>>
>>>>>> Hi Andrew,
>>>>>>
>>>>>> BCM54616S is set to RGMII-Fiber (1000Base-X) mode on my platform, and none of the features (1000BaseT/100BaseT/10BaseT) can be detected by genphy_read_abilities(), because the PHY only reports 1000BaseX_Full|Half ability in this mode.
>>>>>>
>>>>> Are you going to use the PHY in copper or fibre mode?
>>>>> In case you use fibre mode, why do you need the copper modes set as supported?
>>>>> Or does the PHY just start in fibre mode and you want to switch it to copper mode?
>>>>
>>>> Hi Heiner,
>>>>
>>>> The phy starts in fiber mode and that's the mode I want.
>>>> My observation is: phydev->link is always 0 (Link status bit is never set in MII_BMSR) by using dynamic ability detection on my machine. I checked phydev->supported and it's set to "AutoNeg | TP | MII | Pause | Asym_Pause" by dynamic ability detection. Is it normal/expected? Or maybe the fix should go to different places? Thank you for your help.
>>>>
>>>
>>> Not sure whether you stated already which kernel version you're using.
>>> There's a brand-new extension to auto-detect 1000BaseX:
>>> f30e33bcdab9 ("net: phy: Add more 1000BaseX support detection")
>>> It's included in the 5.3-rc series.
>>
>> I'm running kernel 5.2.0. Thank you for the sharing and I didn't know the patch. Let me check it out.
> 
> I applied above patch and ca72efb6bdc7 ("net: phy: Add detection of 1000BaseX link mode support") to my 5.2.0 tree but got following warning when booting up my machine:
> 
> "PHY advertising (0,00000200,000062c0) more modes than genphy supports, some modes not advertised".
> 
It's genphy_config_advert complaining which is called from genphy_config_aneg.
genphy_config_aneg deals with the standard Base-T modes. Therefore in your case
most likely you want to provide an own config_aneg callback (in case autoneg
is applicable at all).

> The BCM54616S PHY on my machine only reports 1000-X features in RGMII->1000Base-KX mode. Is it a known problem?
> 
> Anyways let me see if I missed some dependency/follow-up patches..
> 
> 
> Cheers,
> 
> Tao
> 

Heiner
