Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879342A1101
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 23:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgJ3Wmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 18:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgJ3Wmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 18:42:42 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987A1C0613D5;
        Fri, 30 Oct 2020 15:42:42 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id c18so4202181wme.2;
        Fri, 30 Oct 2020 15:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gPVCkimDSde9NDOHVzmfZuIkAyViqLXXwudj3/IcjzA=;
        b=SUlEi+TZCkdpCMY6i9McihVn/upESRR2wXK+YTou9HmFMrTzDn9XwBZjSkQX9o6XhJ
         IySRtT4q/49KnJDF9agP6CDwm9shrjtl7utLcNg96Tatc4GAQEKQBPPhqTre2/o3eY0l
         inCVwA38GlBXTNNz6ZG0rtkafwoMRVSUyhfd/NbbODzO4LeZioxQHZx+rp/vFE1qfQMU
         z7n4DZ8dLYGnxLQBWYay2+G6lqSY9uJqr7ucxmS6d1FIS7kvle1dZkML2IqNPVk5RFE0
         JOlnmrBEmnNtnNgupAODtqQcPLTe1qA0RPpb+QKFaxpzMHTISNpCbMaOU/OAHpxyxIU/
         HA6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gPVCkimDSde9NDOHVzmfZuIkAyViqLXXwudj3/IcjzA=;
        b=XX61Csz/M8OBRhWS7S0EPZy7VZDGpXhKr7FN39mfb7JhxCuaNdTU32V9277j9s5n2U
         BmtzIj54brGk4cWOSKUQjHyfIgx3tlvsE0V1nnWkUND8+RfhQenhmhbvynJuMmMP1dQO
         L95Qll+Quq9SLiXqAsxagp5cy6loj+HiBEV0XEK03T+E1Y926Hp+ndxyAtCnKVJwp2dG
         3pz1l+pKNbfFgRAU++Yqp94L/TSFRBEWrvheKQOJ9I1GENugcRHeCXE6rpliFIrq6QWr
         l+Ik2c7YhCDhRyw4atlzuFN///NLBMV655kLXzk7Wu2AotB65ru1B6WG0XE6Kb8nTv5Y
         dJ1Q==
X-Gm-Message-State: AOAM530IotcZctboACDaIuZkLvAL53LgymM5MLCc6f7XlpD6yYGin3VI
        a/CRW8Dmo1sTK7w+y+y9PTo=
X-Google-Smtp-Source: ABdhPJzS9p0fe6AYF2H85TKcYaS5v2pKzFtc5ULo5MbnjzaZ0m3Mr6ozmSq/8SAxzIFileUc9QO8Rg==
X-Received: by 2002:a1c:ac87:: with SMTP id v129mr5076778wme.119.1604097761249;
        Fri, 30 Oct 2020 15:42:41 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:9d19:4c77:c465:2524? (p200300ea8f2328009d194c77c4652524.dip0.t-ipconnect.de. [2003:ea:8f23:2800:9d19:4c77:c465:2524])
        by smtp.googlemail.com with ESMTPSA id t12sm12371719wrm.25.2020.10.30.15.42.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 15:42:40 -0700 (PDT)
Subject: Re: [PATCH net-next 00/19] net: phy: add support for shared
 interrupts (part 1)
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
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
 <43d672ae-c089-6621-5ab3-3a0f0303e51a@gmail.com>
 <20201030220642.ctkt2pitdvri3byt@skbuf>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <b9d74b13-1b6a-1fa1-700e-c1aa82eab956@gmail.com>
Date:   Fri, 30 Oct 2020 23:33:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201030220642.ctkt2pitdvri3byt@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.10.2020 23:06, Vladimir Oltean wrote:
> On Fri, Oct 30, 2020 at 10:56:24PM +0100, Heiner Kallweit wrote:
>> I'd just like to avoid the term "shared interrupt", because it has
>> a well-defined meaning. Our major concern isn't shared interrupts
>> but support for multiple interrupt sources (in addition to
>> link change) in a PHY.
> 
> You may be a little bit confused Heiner.
> This series adds support for exactly _that_ meaning of shared interrupts.
> Shared interrupts (aka wired-OR on the PCB) don't work today with the
> PHY library. I have a board that won't even boot to prompt when the
> interrupt lines of its 2 PHYs are enabled, that this series fixes.
> You might need to take another look through the commit messages I'm afraid.
> 
Right, I was focusing on the PTP irq use case.
