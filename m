Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA122AFEF8
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgKLFeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:34:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgKLF0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 00:26:34 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF68C0613D6;
        Wed, 11 Nov 2020 21:26:32 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id o24so4669943ljj.6;
        Wed, 11 Nov 2020 21:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y18tg1OISg55wvq3NOymzl7C6vnWaTWWeKcGa+GeTnI=;
        b=mGxwMKTItKRlzliZgSF8lFcusrdQUsLEYCbTkNfWEkgBYXtqmZP175R4IoRV4YyOuX
         Vzjs6NxvKryq8WN0A0iS2CmYGtQ8Euj+FxDk7nqsuY63R0wU+rVa3RH1iZLnmgdNR7bE
         AWFOKWKmNWGQNri5DNiN6047gu9VzbGbc+MaiFRE+bKzMP/40GbSt6EYt45UCvjr1Q4v
         DDGVLzP0JQm94KEo3bRcUBdgm2S9XfLDUtuEnv54PgZ6W7thkJ8dTvvgKgh5QYU2ZC0V
         gzscZ/U3ATAw32Yd2EHyYgiYcKnJBFbhX4oPfkyf2ESIFGHq91iQiPvwIbOWsQuVFK3l
         iAVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y18tg1OISg55wvq3NOymzl7C6vnWaTWWeKcGa+GeTnI=;
        b=mcMD9vmAVIZM1xJ4NquT0LOB6ORI/AAXq2ZJSw73uziOReKZVcmTl0BPzLuSNq9apf
         JItqnNa9lP7KCQDsTZAVF51uO+0XllyTc6w+FvNGmXtkUZPxj78Gpkrs6NH6k0Maoc67
         XX2YUkSOF81Hcg6x9hBuoM7A2ufSrKd/B/SeoQlRHdhzqD7dWPNGkqYwT5/wK5eCVMJD
         IZStjbXBON0G0EdCQYviTeDDalOYVHGAuleiuvA1c0s2iDxvQ3j/5KgodIDAJKTQU3Kc
         hb0OMySDJWzX50EG5AZrxPWqnQlJh1Q1v3UnuFgUv7JmanAGkaDmZzanzJGiY8/tHpmi
         TmAw==
X-Gm-Message-State: AOAM531XpLTuhpjdWiCfFR/lcqqg9sk2zIXY9lWC3ynWXnj4HQWt+yqR
        juGm6VF1LfLw2f8qKxSoXZc=
X-Google-Smtp-Source: ABdhPJyLcOhuR3f55cMmzQaMCx1mD/egzjT1OijCT1kFY0KoCDgJUTYkp4uMbherAT8JDB39jAL5lA==
X-Received: by 2002:a2e:6c0a:: with SMTP id h10mr8183453ljc.247.1605158791292;
        Wed, 11 Nov 2020 21:26:31 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id y12sm9316ljd.89.2020.11.11.21.26.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 21:26:30 -0800 (PST)
Subject: Re: [PATCH v2 05/10] ARM: dts: BCM5301X: Provide defaults ports
 container node
To:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer:BROADCOM IPROC ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Kurt Kanzenbach <kurt@kmk-computers.de>
References: <20201112045020.9766-1-f.fainelli@gmail.com>
 <20201112045020.9766-6-f.fainelli@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <222bba75-386b-ccba-8b90-5d82b8db957a@gmail.com>
Date:   Thu, 12 Nov 2020 06:26:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201112045020.9766-6-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.11.2020 05:50, Florian Fainelli wrote:
> Provide an empty 'ports' container node with the correct #address-cells
> and #size-cells properties. This silences the following warning:
> 
> arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dt.yaml:
> ethernet-switch@18007000: 'oneOf' conditional failed, one must be fixed:
>          'ports' is a required property
>          'ethernet-ports' is a required property
>          From schema:
> Documentation/devicetree/bindings/net/dsa/b53.yaml
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Nice!

Acked-by: Rafał Miłecki <rafal@milecki.pl>
