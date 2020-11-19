Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C452B9CEA
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 22:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgKSVX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 16:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgKSVX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 16:23:28 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0BBC0613CF;
        Thu, 19 Nov 2020 13:23:28 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id s13so8001601wmh.4;
        Thu, 19 Nov 2020 13:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=45nojBTeJt4PVraKfZt0D1NIKZLgWx65KRx7cLF+qxM=;
        b=Rs+2yB+XML6OukEn+u2TAu39SSlZB5FACzhUTNCmBpaIdseGhdfPQ7prKo2ofWzqsk
         G591dnJfthAqMSi+uA7O3/oUeaHOnezTJgzM6OiCuaV+HSfUSscwGgClZyrfJxoWbfpi
         6BU8CuoXDFcoAn/r2QKsqk46aGOdopZE8flTm7J3oQors03E0YXwAcDSZ3Fo/oOxD/Gs
         vJsQzHroko4CgEqqKhukp00fqUuJoy20oZoXVcP3IU0LRwy2meDmsSWD8OFHAVC73fTA
         xE0FzZq2AzR/AyXrZTW0cp9e8FA57l/HLqKE+JmmfqSL5SRDACpv1G1n3cQMkouA3oM0
         DGdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=45nojBTeJt4PVraKfZt0D1NIKZLgWx65KRx7cLF+qxM=;
        b=UqG16is3UXhvDoaCEZHSRS2uKZ0StJLXR3gFB+dIcIly6Vgu/e/V61zhPXBtVw7UR5
         H/b6qPC2VfC4VARbO3al4AXk8ONtPlHlMjdolwRX6Qdh7LymrErQBuWdjzyt2X13JbIs
         8dRFr+SLFceRbptXXR+vlfhp/y+39LadXCNWgpOgWV3wUTqterp6PKu8WGtRKUGfV0tb
         Jv6VlDptF5UZ5IqmNiZ5+bn56BJrtakugOFpgMdSVA08nFngsHFX4ztDhkMMbfeU6BDM
         38Vt768KqWqTMNfsSEVGp20f+W5t+8iINOmGykGAKdpZpqMBFEAQtMnleHclxDN4m6cx
         WWdw==
X-Gm-Message-State: AOAM5308VaLVOKtW2iTzKX1vCrkHW5d1B2+TeZ5qdsWU3Eq95nneevn5
        Z4N1qadYVGWPKpMk2T5i3wWCuEd2BaccDg==
X-Google-Smtp-Source: ABdhPJxRbxFbCPBOwwh1vjoa5pvhjykTmIMTq3nDpSPZ9B5BYzvf2X2hdsYgrAgQcgUjnCyTle9S3g==
X-Received: by 2002:a1c:f406:: with SMTP id z6mr6393837wma.123.1605821006810;
        Thu, 19 Nov 2020 13:23:26 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:6d7c:9ea3:dfaa:d617? (p200300ea8f2328006d7c9ea3dfaad617.dip0.t-ipconnect.de. [2003:ea:8f23:2800:6d7c:9ea3:dfaa:d617])
        by smtp.googlemail.com with ESMTPSA id t23sm1793699wmn.4.2020.11.19.13.23.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 13:23:26 -0800 (PST)
Subject: Re: [PATCH v2] mdio_bus: suppress err message for reset gpio
 EPROBE_DEFER
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org
References: <20201119203446.20857-1-grygorii.strashko@ti.com>
 <1a59fbe1-6a5d-81a3-4a86-fa3b5dbfdf8e@gmail.com>
 <cabad89e-23cc-18b3-8306-e5ef1ee4bfa6@ti.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <44a3c8c0-9dbd-4059-bde8-98486dde269f@gmail.com>
Date:   Thu, 19 Nov 2020 22:23:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <cabad89e-23cc-18b3-8306-e5ef1ee4bfa6@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 19.11.2020 um 22:17 schrieb Grygorii Strashko:
> 
> 
> On 19/11/2020 23:11, Heiner Kallweit wrote:
>> Am 19.11.2020 um 21:34 schrieb Grygorii Strashko:
>>> The mdio_bus may have dependencies from GPIO controller and so got
>>> deferred. Now it will print error message every time -EPROBE_DEFER is
>>> returned which from:
>>> __mdiobus_register()
>>>   |-devm_gpiod_get_optional()
>>> without actually identifying error code.
>>>
>>> "mdio_bus 4a101000.mdio: mii_bus 4a101000.mdio couldn't get reset GPIO"
>>>
>>> Hence, suppress error message for devm_gpiod_get_optional() returning
>>> -EPROBE_DEFER case by using dev_err_probe().
>>>
>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>> ---
>>>   drivers/net/phy/mdio_bus.c | 6 +++---
>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
>>> index 757e950fb745..83cd61c3dd01 100644
>>> --- a/drivers/net/phy/mdio_bus.c
>>> +++ b/drivers/net/phy/mdio_bus.c
>>> @@ -546,10 +546,10 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>>>       /* de-assert bus level PHY GPIO reset */
>>>       gpiod = devm_gpiod_get_optional(&bus->dev, "reset", GPIOD_OUT_LOW);
>>>       if (IS_ERR(gpiod)) {
>>> -        dev_err(&bus->dev, "mii_bus %s couldn't get reset GPIO\n",
>>> -            bus->id);
>>> +        err = dev_err_probe(&bus->dev, PTR_ERR(gpiod),
>>> +                    "mii_bus %s couldn't get reset GPIO\n", bus->id);
>>
>> Doesn't checkpatch complain about line length > 80 here?
> 
> :)
> 
> commit bdc48fa11e46f867ea4d75fa59ee87a7f48be144
> Author: Joe Perches <joe@perches.com>
> Date:   Fri May 29 16:12:21 2020 -0700
> 
>     checkpatch/coding-style: deprecate 80-column warning
> 

Ah, again something learnt. Thanks for the reference.

>>
>>>           device_del(&bus->dev);
>>> -        return PTR_ERR(gpiod);
>>> +        return err;
>>>       } else    if (gpiod) {
>>>           bus->reset_gpiod = gpiod;
>>>  
>>
>> Last but not least the net or net-next patch annotation is missing.
>> I'd be fine with treating the change as an improvement (net-next).
>>
>> Apart from that change looks good to me.
>>
> 

