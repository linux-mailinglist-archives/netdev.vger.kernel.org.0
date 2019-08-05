Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 701FD82643
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 22:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730771AbfHEUpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 16:45:12 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35476 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729383AbfHEUpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 16:45:11 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so74239554wmg.0;
        Mon, 05 Aug 2019 13:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EgXdDmP0k1tqZgycySCKwplOmPJButNgffG4bh/ytLc=;
        b=ha1kccmItNUXTZwqjy+EwRU64TDB9oBQA9lqPCxHRWhGnbl2am4RRvu6HVyG4PEMgF
         ZhKW4zk4HMPmntg65C72XwyX8l1vH4iSYZpLoI0l5UQePQ124Hr/zbZjfT5ogAiISyGt
         9pVeNOSfNqC0qSaQorruFF8NoNxQuXalzCMaB6yAB0GulpDCkyE0TY/nsSHLZ/42IjZ1
         Jckfd6hLdnBNduvSMNkKB+HbeuHvZexGIX0MSgsSwEoyI+mL/nD2UwUqVqJeJOq0kbJW
         P/UBJ1okrlFn6yatswf5Bq+9SmyUeA8AzargfX01roOcmTP60pgADr3AstJavSE77hLA
         f30g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EgXdDmP0k1tqZgycySCKwplOmPJButNgffG4bh/ytLc=;
        b=eIK3jwhst24E5KYGCr+co3l4s/aIPKtAd3hzVc3LcduyJ1p21xu8e/R3jw4QCozoEV
         EJ2cTRNPOMHgyxvYISd7vmFRkIy5sHqzhRJOL7hjBwRzTpqtSrgimgikXHcSpzG1pMVz
         hVr+9glVc3McMgftxjOK1nYHenDTryXIul3Mt+OzQUwFtd7dX3LjEzgMeyOtVPgFSgmA
         5lqRDTiaFAa5Tov63/qRgZG4SGoRwQHlOTKV5YYWK+Uy1l9xZIpsGOm4tT6azjV3umxU
         RGatWGTuoUOTd45basmpa9NkdmORSY1Gt1Oe/P4blP5ivP5ZmY6blB1EWfw99qWVEW5n
         093w==
X-Gm-Message-State: APjAAAX8viJIu5DItXUj4rxaIPhOS3G6Z6rwBjD8/Gfwwa9ZwwA57Puy
        I/ntDC3IMNebDQL1aCFgO3Y=
X-Google-Smtp-Source: APXvYqykjkECVeegO7PV5zTexDEVC6PLGPDdBeHJMAo2IUPpo2e8tQlEZ96KnKyTBJIQ3fGN2SscRw==
X-Received: by 2002:a1c:7e90:: with SMTP id z138mr168152wmc.128.1565037909695;
        Mon, 05 Aug 2019 13:45:09 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f05:8600:d16c:62d1:98de:d1e5? (p200300EA8F058600D16C62D198DED1E5.dip0.t-ipconnect.de. [2003:ea:8f05:8600:d16c:62d1:98de:d1e5])
        by smtp.googlemail.com with ESMTPSA id n3sm77342100wrt.31.2019.08.05.13.45.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 13:45:09 -0700 (PDT)
Subject: Re: [PATCH net-next v3] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Tao Ren <taoren@fb.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
References: <20190802215419.313512-1-taoren@fb.com>
 <CA+h21hrOEape89MTqCUyGFt=f6ba7Q-2KcOsN_Vw2Qv8iq86jw@mail.gmail.com>
 <53e18a01-3d08-3023-374f-2c712c4ee9ea@fb.com> <20190804145152.GA6800@lunn.ch>
 <CA+h21hrUDaSxKpsy9TuWqwgaxKYaoXHyhgS=xSoAcPwxXzvrHg@mail.gmail.com>
 <f8de2514-081a-0e6e-fbe2-bcafcd459646@gmail.com>
 <CA+h21hov3WzqYSUcxOnH0DOMO2dYdh_Q30Q_GQJpxa4nFM7MsQ@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <291a3c6e-ca8f-a9b8-a0b8-735a68dc04ea@gmail.com>
Date:   Mon, 5 Aug 2019 22:45:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hov3WzqYSUcxOnH0DOMO2dYdh_Q30Q_GQJpxa4nFM7MsQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.08.2019 21:22, Vladimir Oltean wrote:
> On Sun, 4 Aug 2019 at 19:07, Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> On 04.08.2019 17:59, Vladimir Oltean wrote:
>>> On Sun, 4 Aug 2019 at 17:52, Andrew Lunn <andrew@lunn.ch> wrote:
>>>>
>>>>>> The patchset looks better now. But is it ok, I wonder, to keep
>>>>>> PHY_BCM_FLAGS_MODE_1000BX in phydev->dev_flags, considering that
>>>>>> phy_attach_direct is overwriting it?
>>>>>
>>>>
>>>>> I checked ftgmac100 driver (used on my machine) and it calls
>>>>> phy_connect_direct which passes phydev->dev_flags when calling
>>>>> phy_attach_direct: that explains why the flag is not cleared in my
>>>>> case.
>>>>
>>>> Yes, that is the way it is intended to be used. The MAC driver can
>>>> pass flags to the PHY. It is a fragile API, since the MAC needs to
>>>> know what PHY is being used, since the flags are driver specific.
>>>>
>>>> One option would be to modify the assignment in phy_attach_direct() to
>>>> OR in the flags passed to it with flags which are already in
>>>> phydev->dev_flags.
>>>>
>>>>         Andrew
>>>
>>> Even if that were the case (patching phy_attach_direct to apply a
>>> logical-or to dev_flags), it sounds fishy to me that the genphy code
>>> is unable to determine that this PHY is running in 1000Base-X mode.
>>>
>>> In my opinion it all boils down to this warning:
>>>
>>> "PHY advertising (0,00000200,000062c0) more modes than genphy
>>> supports, some modes not advertised".
>>>
>> The genphy code deals with Clause 22 + Gigabit BaseT only.
>> Question is whether you want aneg at all in 1000Base-X mode and
>> what you want the config_aneg callback to do.
>> There may be some inspiration in the Marvel PHY drivers.
>>
> 
> AN for 1000Base-X still gives you duplex and pause frame settings. I
> thought the base page format for exchanging that info is standardized
> in clause 37.
> Does genphy cover only copper media by design, or is it desirable to
> augment genphy_read_status?
> 
So far we care about copper only in phylib. Some constants needed for
Clause 37 support are defined, but used by few drivers only.

ADVERTISE_1000XHALF
ADVERTISE_1000XFULL
ADVERTISE_1000XPAUSE
ADVERTISE_1000XPSE_ASYM

I think it would make sense to have something like genphy_c37_config_aneg.
Similar for read_status.

>>> You see, the 0x200 in the above advertising mask corresponds exactly
>>> to this definition from ethtool.h:
>>>     ETHTOOL_LINK_MODE_1000baseX_Full_BIT    = 41,
>>>
>>> But it gets truncated and hence lost.
>>>
>>> Regards,
>>> -Vladimir
>>>
>> Heiner
> 
Heiner
