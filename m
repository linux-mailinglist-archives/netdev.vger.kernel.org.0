Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D489C2B98C4
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgKSQ7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 11:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbgKSQ7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 11:59:03 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACEAC0613CF;
        Thu, 19 Nov 2020 08:59:03 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id k2so7240911wrx.2;
        Thu, 19 Nov 2020 08:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=+tQ2BXpjik3+doDfIP6ABRAYhXmrT3iSlTSk4pFFTkU=;
        b=XEj7iwUMNcqJjovR5s2ZwAvW1v+LRRbZVk34TPQcu071YWvMcS9NqpGTOUVAbsgbQf
         aNy7pDOToG2/q/Dbv/Qu1klqi+dIi+QHSxPpvt5UZtkUACsqvwNjofh7/qRmPYMCig6q
         gPQoerZzHJcrDxu5KHuDUowz1Tj3Me8ToIn7mxvqaGnlRiWqKswfCTPO1SLI58DY2X/u
         nwDwLE4ReWbiaUjFVpgFFyVq/z5ExDWjsGnIV/3Kr/8lrZT06e10lj+pyYItmssu3Kzv
         A0npQziOhB61zYQ60o5vmKoEt+QGh3xjDdzf70/g3cF2U+1/urk8q1+XrQNtM/Oku+X2
         tW9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=+tQ2BXpjik3+doDfIP6ABRAYhXmrT3iSlTSk4pFFTkU=;
        b=RWtoqncGBKDYZ6leGVpowBRHwMDpwsfoeUOH+0iFqfwu29STvuv16PN1z49NXbKlE5
         FFzYdiXS/3gT9PyWhBJwTf9Y/INrWLuJlgZkYnsBlDik9OhUC4uAvLoY4Ch4IjcWUA4y
         Gek8NdIWXwxG3lUoKjigNFjonvc5mr9fIYZxtpWnNREusQhtVPc1GtggGWemk+8mlgmA
         xD18DrY1032lxaCrv2j/SJUXxl1IRJQgfMwBDnjFwDmuphkLOaed4Fz7dOClNLmP9MCQ
         YdCVc0wcHf547+795kDFAxRNJ0US1S4pTTdcQD+ptWr+CWPtF2UkKFntUoEuH3lwlhva
         QGsw==
X-Gm-Message-State: AOAM533QScjWSNUp6b69hZewt8PsfQv0Ddoq+Sb8CXktzQHQW2ntAtiw
        yTykneey8mRzAENDOm5gchCdhtxGEU1Drg==
X-Google-Smtp-Source: ABdhPJwY73TmmdJzuxgi3bPv2SUvGTyMS1Ria2Xk+7qjHBx5geBd7xJC6hcyC8IxeiNUEVLmwLU3OQ==
X-Received: by 2002:adf:f7c7:: with SMTP id a7mr12235117wrq.347.1605805142047;
        Thu, 19 Nov 2020 08:59:02 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:6d7c:9ea3:dfaa:d617? (p200300ea8f2328006d7c9ea3dfaad617.dip0.t-ipconnect.de. [2003:ea:8f23:2800:6d7c:9ea3:dfaa:d617])
        by smtp.googlemail.com with ESMTPSA id e3sm495182wro.90.2020.11.19.08.59.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 08:59:01 -0800 (PST)
Subject: Re: [PATCH] mdio_bus: suppress err message for reset gpio
 EPROBE_DEFER
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org
References: <20201118142426.25369-1-grygorii.strashko@ti.com>
 <0329ed05-371b-0bb5-4f85-75ecaff6a70b@gmail.com>
 <655ec6e4-6e75-1835-034c-ec18dac505e8@ti.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7c2e8a07-4cb6-ee9c-9d64-9cf68b0390c7@gmail.com>
Date:   Thu, 19 Nov 2020 17:58:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <655ec6e4-6e75-1835-034c-ec18dac505e8@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 19.11.2020 um 14:38 schrieb Grygorii Strashko:
> 
> 
> On 19/11/2020 14:30, Heiner Kallweit wrote:
>> Am 18.11.2020 um 15:24 schrieb Grygorii Strashko:
>>> The mdio_bus may have dependencies from GPIO controller and so got
>>> deferred. Now it will print error message every time -EPROBE_DEFER is
>>> returned from:
>>> __mdiobus_register()
>>>   |-devm_gpiod_get_optional()
>>> without actually identifying error code.
>>>
>>> "mdio_bus 4a101000.mdio: mii_bus 4a101000.mdio couldn't get reset GPIO"
>>>
>>> Hence, suppress error message when devm_gpiod_get_optional() returning
>>> -EPROBE_DEFER case.
>>>
>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>> ---
>>>   drivers/net/phy/mdio_bus.c | 7 ++++---
>>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
>>> index 757e950fb745..54fc13043656 100644
>>> --- a/drivers/net/phy/mdio_bus.c
>>> +++ b/drivers/net/phy/mdio_bus.c
>>> @@ -546,10 +546,11 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>>>       /* de-assert bus level PHY GPIO reset */
>>>       gpiod = devm_gpiod_get_optional(&bus->dev, "reset", GPIOD_OUT_LOW);
>>>       if (IS_ERR(gpiod)) {
>>> -        dev_err(&bus->dev, "mii_bus %s couldn't get reset GPIO\n",
>>> -            bus->id);
>>> +        err = PTR_ERR(gpiod);
>>> +        if (err != -EPROBE_DEFER)
>>> +            dev_err(&bus->dev, "mii_bus %s couldn't get reset GPIO %d\n", bus->id, err);
>>>           device_del(&bus->dev);
>>> -        return PTR_ERR(gpiod);
>>> +        return err;
>>>       } else    if (gpiod) {
>>>           bus->reset_gpiod = gpiod;
>>>  
>>
>> Using dev_err_probe() here would simplify the code.
>>
> 
> this was my first though, but was not sure if it's correct as dev_err_probe() will use dev
> to store defer reason, but the same 'dev' is deleted on the next line.
> 
If you look at device_del() you see that it calls driver_deferred_probe_del()
which frees the reason string. Means you're right in a way that storing
the deferral reason doesn't provide any benefit here, but it also doesn't
hurt.
Good thing about using dev_err_probe() is also that it prints a debug info
in case of deferral what may help people chasing an issue involving this
deferral.

> I also thought about using bus->parent, but it's not always provided.
> 
> So, if you think dev_err_probe(0) can be used - I can change and re-send.
> 

