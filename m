Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265952A151D
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 11:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgJaKS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 06:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgJaKS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 06:18:28 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EEAC0613D5;
        Sat, 31 Oct 2020 03:18:26 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id b3so3132263wrx.11;
        Sat, 31 Oct 2020 03:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bBWed7R/d4RzVxBWtktfpkTmcagn0Z+KKOrOtD1H+1Q=;
        b=EHbR3sgzJLKtqYGA/ZqJ9rVVYLYGEz99q6H/a5xbav4jzbPABW9cfk8C/GwLAW+dvq
         xE3ithMhpnN29rl6eq4X5IFzDtS3aV2lCwNcRWp0oCAZuK2Q6jO2cCM0oyW+5sjsambi
         IhAQOfbbL/Ecf7GQoRt/cz82oc0iuTkj0N++vZJhChgmHy/vROKKVyLs4xvdrc4nhQsM
         WMo8+vaXoKlaDh6hCFW0bzbpcQOD1lkEykX0QQgZZllk7P3ypcaVdfb5H5fBf2Mp40VZ
         /YZx+NZzV7ji0qW6QqeIlJW6O4JX0bHPYY3v5JvuqCQf3e9qr5LFl5EwA5xgfLeQqdkx
         qzbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bBWed7R/d4RzVxBWtktfpkTmcagn0Z+KKOrOtD1H+1Q=;
        b=iiyQpn5ifP1dnnIDogdJJTDqeRyoC7afk4H39HEnVMH/UgMZXC9KHeKcEJnahVxJsu
         WtM/mQ650pQ7xKSxAOZO/D1uDJnUNo2a74IRNE4u/RH45vOu7qqpwG472p8V/i8FFG45
         KVu6xyFsOWly8KeO1MCo1xLQ6liAeLoq6QSxJ5GHuz4aJPh2cissblQv6m6wHt5JQ+Qc
         SxvCH1Q1uZbxw2UafuWPkG4EioJ6vNYeficxsIZmxpduHoJ8mdUmn4FKNMheLky75NEK
         kDVBtp8EjNVQ/d89B6i0Vzgs+qzz/8KF1YzNKbtUVLAEpm8faCx+i+W21+A0cheqLOxA
         LlFQ==
X-Gm-Message-State: AOAM5331hGPKV8pGxyyIZe31KkshkADYxoTsBFXlWZYQtvRKcoXIyLhj
        bcD3uvp0AUcam0gz/gBpDIQ=
X-Google-Smtp-Source: ABdhPJy2UDydJW6l5sa13Z/fVhTcgg7ZMdaCUG6UTAOvY+EGxkBpfE80rwyp7bqYhDzLSmOfH0XisA==
X-Received: by 2002:adf:c101:: with SMTP id r1mr8188182wre.87.1604139504412;
        Sat, 31 Oct 2020 03:18:24 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:354c:e90a:781b:bae1? (p200300ea8f232800354ce90a781bbae1.dip0.t-ipconnect.de. [2003:ea:8f23:2800:354c:e90a:781b:bae1])
        by smtp.googlemail.com with ESMTPSA id j127sm8180311wma.31.2020.10.31.03.18.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 03:18:23 -0700 (PDT)
Subject: Re: [PATCH net-next 00/19] net: phy: add support for shared
 interrupts (part 1)
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Andre Edich <andre.edich@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Dan Murphy <dmurphy@ti.com>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Mathias Kresin <dev@kresin.me>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Michael Walle <michael@walle.cc>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Nisar Sayed <Nisar.Sayed@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Willy Liu <willy.liu@realtek.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
References: <20201029100741.462818-1-ciorneiioana@gmail.com>
 <d05587fc-0cec-59fb-4e84-65386d0b3d6b@gmail.com>
 <20201030233627.GA1054829@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <fee0997d-f4bc-dfc3-9423-476f04218614@gmail.com>
Date:   Sat, 31 Oct 2020 11:18:18 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201030233627.GA1054829@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.10.2020 00:36, Andrew Lunn wrote:
>>> - Every PHY driver gains a .handle_interrupt() implementation that, for
>>>   the most part, would look like below:
>>>
>>> 	irq_status = phy_read(phydev, INTR_STATUS);
>>> 	if (irq_status < 0) {
>>> 		phy_error(phydev);
>>> 		return IRQ_NONE;
>>> 	}
>>>
>>> 	if (irq_status == 0)
>>
>> Here I have a concern, bits may be set even if the respective interrupt
>> source isn't enabled. Therefore we may falsely blame a device to have
>> triggered the interrupt. irq_status should be masked with the actually
>> enabled irq source bits.
> 
> Hi Heiner
> 
Hi Andrew,

> I would say that is a driver implementation detail, for each driver to
> handle how it needs to handle it. I've seen some hardware where the
> interrupt status is already masked with the interrupt enabled
> bits. I've soon other hardware where it is not.
> 
Sure, I just wanted to add the comment before others simply copy and
paste this (pseudo) code. And in patch 9 (aquantia) and 18 (realtek)
it is used as is. And IIRC at least the Aquantia PHY doesn't mask
the interrupt status.

> For example code, what is listed above is O.K. The real implementation
> in a driver need knowledge of the hardware.
> 
>       Andrew
> .
> 
Heiner
