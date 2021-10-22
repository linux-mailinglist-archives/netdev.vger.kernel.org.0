Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2C5437AE4
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 18:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbhJVQaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 12:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbhJVQaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 12:30:09 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACF2C061348
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 09:27:51 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id nn3-20020a17090b38c300b001a03bb6c4ebso3461703pjb.1
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 09:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JbaJ8xmeU2H4P+9qIU5fLy+tqAMSaU6Q9YGxhokhHTs=;
        b=Zdrqzk9+jg6MyD5z6iEwOr3JIgaxkefFXJZf28Q0JM+mHR1bxuJoCyFk7XuguQKkUC
         MhBsLYcZzTXjmdO4b+PmbdcCG4wZk247VSgYZlKitor+iQVwelF1Ku0tmN5G/Wk/KGVF
         20iYi2qbCrcae7eEcXiEoCHC0oVKf6e80DRjCtXk8/LWdZ7QYfOwmY36Be5QMCiCXnaT
         FFiHiVJbbo11beZJnsrS05fj6Y2C9NxydnK5ce5fwUC/0SHOZljLdSQjktO+kT1wN0AN
         vAqB/gMxQXo+z/a+zfAZnmCKS7REuhlIxafe2hGBfXkCyGykteWqHyAXeoWA0hOV2Ac8
         SpVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JbaJ8xmeU2H4P+9qIU5fLy+tqAMSaU6Q9YGxhokhHTs=;
        b=hO0gLaGIJLE1PoVtR1RHn1O5cHDEKnTxyavZbp4OXbf5yP7ZxdGNf1VccKWE86SIl0
         3ce7ERRB5UqI5AdiL2qO5LFU8uUT7LKml5x9alzBk+qubwT5aXRi3V+LWi4yVsnwdTCJ
         5fEXQJUJVy3yTTS2Pn56yxKmpYoy4VC5b4nMABz3NHSOJ6rg1oikLw/pKOBmEQDsh8Us
         JjFG0A+xM36Vr/BQ6hpnVjlzzi8UIGHoeJw4PLHUy2JdWzJMmIVkDMIvUUliZLL3Md/2
         l19xsvqGqhzUg9DIZaPbkh0cfEWKOM2LPrW18XU3g9rN6G81lE5tHAeuSfDoCCh9P0KG
         bVvQ==
X-Gm-Message-State: AOAM531/Bc45hcHFRZKKOyQYaBaB6ud3qZFJ3GS52bNQ6aa+wUHVFXzi
        3a/tfKUKAy5Sh71FJvQSONc=
X-Google-Smtp-Source: ABdhPJwH7E4ODy2YYUK5OjqgLAyoVgDfPXsiMZCXQxv0fSxt0HVcN3TNtgVCvEguDAUvzAQbZzQaZg==
X-Received: by 2002:a17:90a:6b01:: with SMTP id v1mr15893532pjj.6.1634920071286;
        Fri, 22 Oct 2021 09:27:51 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m28sm9090312pgl.9.2021.10.22.09.27.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 09:27:50 -0700 (PDT)
Subject: Re: GENET and UNIMAC MDIO probe issue?
To:     Stefan Wahren <stefan.wahren@i2se.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Nicolas Saenz Julienne <nsaenz@kernel.org>
References: <20211022143337.jorflirdb6ctc5or@gilmour>
 <150dcf36-959c-36e3-3b35-74b7ec1db774@i2se.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4e230c8c-790a-2a87-ec72-c1d6e166719e@gmail.com>
Date:   Fri, 22 Oct 2021 09:27:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <150dcf36-959c-36e3-3b35-74b7ec1db774@i2se.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/21 8:35 AM, Stefan Wahren wrote:
> Hi Maxime,
> 
> Am 22.10.21 um 16:33 schrieb Maxime Ripard:
>> Hi Florian, Doug,
>>
>> I'm currently trying to make the RaspberryPi CM4 IO board probe its
>> ethernet controller, and it looks like genet doesn't manage to find its
>> PHY and errors out with:
>>
>> [    3.240435] libphy: Fixed MDIO Bus: probed
>> [    3.248849] bcmgenet fd580000.ethernet: GENET 5.0 EPHY: 0x0000
>> [    3.259118] libphy: bcmgenet MII bus: probed
>> [    3.278420] mdio_bus unimac-mdio--19: MDIO device at address 1 is missing.
>> [    3.285661] unimac-mdio unimac-mdio.-19: Broadcom UniMAC MDIO bus
>>
>> ....
>>
>> [   13.082281] could not attach to PHY
>> [   13.089762] bcmgenet fd580000.ethernet eth0: failed to connect to PHY
>> [   74.739621] could not attach to PHY
>> [   74.746492] bcmgenet fd580000.ethernet eth0: failed to connect to PHY
>>
>> Here's the full boot log:
>> https://pastebin.com/8RhuezSn
> 
> looks like you are using the vendor DTB, please use the upstream DTB
> from linux-next:
> 
> bcm2711-rpi-cm4-io.dtb

Stefan beat me to it, but yes, it looked like you had an Ethernet PHY at
MDIO address 25, when arch/arm/boot/dts/bcm2711-rpi-cm4.dtsi indicates
that it should be at address 0, therefore it won't work.

The issue with mdio-bcm-unimac not being loaded would only be applicable
in a modular case anyway, when it is built-in, there would be no such
problem. Let me know if there are other changes that are necessary, DTS
or else.
-- 
Florian
