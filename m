Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24C6780B99
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 18:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfHDQHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 12:07:08 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33614 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbfHDQHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 12:07:08 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so82096642wru.0;
        Sun, 04 Aug 2019 09:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jt0SLAU5Fp8gNQ2ASv10+ox91avJ4X0iIVC5PETCfcM=;
        b=F4a5J3CkTLTlUeJ7ZSjRRWlRm3xfNF62p7kg9fcLJPjINSNsMUCaSd6LfRfN9FKlUr
         Du646eJUBxkhWz+BgJNqflVKzlA/amZcWhy5z2fzveonn8Bmb9Aahb20ruB07Miwb4d8
         6ltckFtmN+nf5N8lZqbJa27J1zTPzE1+yn5MB8M86HrmdHTIQALwSJ7twmMEAJzUau74
         aht9WlP13jONznd2Rf5TXVyPS330ioedLTjTcgUdo+9Bo75aOzTqqknW4FQJgk39Qu/s
         lHMhUMUH+YQtAUquK7Xmjit78G729SDIDLaBpsOaiYGaJO4K9eSMReLLS4GzEKNqKRbF
         7JAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jt0SLAU5Fp8gNQ2ASv10+ox91avJ4X0iIVC5PETCfcM=;
        b=dkU6TgVcTHRBRRA5EVNn0aUSFE3ls0TcMEh43BuN9W0FXd8wvHi2Hj6uauk4iS2oW1
         cJ0EMNiT10kTY8okRbxfZFhYlyLE0w9zwYDpjtmO6HbYGg8RdQxrBtSnS+qR6GcocZ0+
         LUI9rok2BZgB0rSVON3Y3FzuwtaMY7iukhO1JXakMHb1O/kLWq0Z1vflYXgCNXIYWRUp
         AEosM9phvbvx7aeyv31ONtwBlViwXqn/e8Usuk0vd+GCV/ayyWqsu0a0HhqUo9z7LRfU
         a5L08rEkc+dpkYdPR9fAXgQ0/l1bgiHR4CzOlv8ZpRY65wXahhttzK/DXR5AJMmmQ0TO
         qObQ==
X-Gm-Message-State: APjAAAVV1MQ2yo4F6YZcSWrXYazNgrTGj577rehIfh5KvsOQZGotRlx8
        UH7mnXaM1s5KoETKpxaHCi8=
X-Google-Smtp-Source: APXvYqyH8GACPxbDrF5MNtZvmWC4XkSICwVCQZbHjd5eRZG/orYvKyQa7Tsq83S/QbCS/8hgGcOY0A==
X-Received: by 2002:a05:6000:118a:: with SMTP id g10mr40693555wrx.175.1564934825862;
        Sun, 04 Aug 2019 09:07:05 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:9900:a1a9:917d:36ea:d474? (p200300EA8F289900A1A9917D36EAD474.dip0.t-ipconnect.de. [2003:ea:8f28:9900:a1a9:917d:36ea:d474])
        by smtp.googlemail.com with ESMTPSA id l2sm55537066wmj.4.2019.08.04.09.07.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Aug 2019 09:07:05 -0700 (PDT)
Subject: Re: [PATCH net-next v3] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Tao Ren <taoren@fb.com>, Florian Fainelli <f.fainelli@gmail.com>,
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
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <f8de2514-081a-0e6e-fbe2-bcafcd459646@gmail.com>
Date:   Sun, 4 Aug 2019 18:06:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hrUDaSxKpsy9TuWqwgaxKYaoXHyhgS=xSoAcPwxXzvrHg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.08.2019 17:59, Vladimir Oltean wrote:
> On Sun, 4 Aug 2019 at 17:52, Andrew Lunn <andrew@lunn.ch> wrote:
>>
>>>> The patchset looks better now. But is it ok, I wonder, to keep
>>>> PHY_BCM_FLAGS_MODE_1000BX in phydev->dev_flags, considering that
>>>> phy_attach_direct is overwriting it?
>>>
>>
>>> I checked ftgmac100 driver (used on my machine) and it calls
>>> phy_connect_direct which passes phydev->dev_flags when calling
>>> phy_attach_direct: that explains why the flag is not cleared in my
>>> case.
>>
>> Yes, that is the way it is intended to be used. The MAC driver can
>> pass flags to the PHY. It is a fragile API, since the MAC needs to
>> know what PHY is being used, since the flags are driver specific.
>>
>> One option would be to modify the assignment in phy_attach_direct() to
>> OR in the flags passed to it with flags which are already in
>> phydev->dev_flags.
>>
>>         Andrew
> 
> Even if that were the case (patching phy_attach_direct to apply a
> logical-or to dev_flags), it sounds fishy to me that the genphy code
> is unable to determine that this PHY is running in 1000Base-X mode.
> 
> In my opinion it all boils down to this warning:
> 
> "PHY advertising (0,00000200,000062c0) more modes than genphy
> supports, some modes not advertised".
> 
The genphy code deals with Clause 22 + Gigabit BaseT only.
Question is whether you want aneg at all in 1000Base-X mode and
what you want the config_aneg callback to do.
There may be some inspiration in the Marvel PHY drivers.

> You see, the 0x200 in the above advertising mask corresponds exactly
> to this definition from ethtool.h:
>     ETHTOOL_LINK_MODE_1000baseX_Full_BIT    = 41,
> 
> But it gets truncated and hence lost.
> 
> Regards,
> -Vladimir
> 
Heiner
