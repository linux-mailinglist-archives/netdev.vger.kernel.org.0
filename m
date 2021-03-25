Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557B3349B2A
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 21:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhCYUoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 16:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbhCYUob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 16:44:31 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3264C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 13:44:30 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id b9so3600206wrt.8
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 13:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r4pT24opc97sMW28CJlR1MeppYjj9yQ56hgtXclhWko=;
        b=Ok8knq4OBggL8BMA8NndKQ/S9pVx+ZUPeLEYQsYOq2slAZTAhyuLnxNj7m0tQDIsri
         ucGQ0/MYD8rdrJFGvbXbpZ4T/7QvplfrvUGKasc/FLOa0xI0XoGqcIArnQ8rP5s7jv2K
         wnIfPmzJJrdlAZChrmZqA0EjssEfCj3Sfovkq9R63WQc6MSdxZ573PyXlHMjW9gx3dMY
         foxMKX18V1B83Y6U9wBaRg2n5t/Ms6eqIDNMeIDfJLjgS6HuXAWh/WMApD3JsCcn7Yfs
         p35tVvKJSV2MtJ5iKJSZGuIS+QnTVveehiKbDSesgOom7IgODNVoduEzwYbTQt3J+YoI
         2DVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r4pT24opc97sMW28CJlR1MeppYjj9yQ56hgtXclhWko=;
        b=nDlYFFGGPHAS8w+mPBj/egdJHDnkCyr7kjyjGRF2vuPTona516YXRBvZBb+iVB5TQw
         E6K7hRdLwNvjxMShmRcU12myIE+fSGuEnIE4PuKg9vqhzYJVmHG75EBAE4M/4hdc8Kps
         RKJZH8JBkyzispiWh20wbzKsMvUS290HyJaBr0YI2LcKenhwNVDG5bAq3hpbzQCEWZZF
         YsDSBzJjrL8vraTSRcBcnqLg/SSbzIGM0rfF6W6vwQGXa3wNs4oG30jRCESbAsGzmFCQ
         ma/ko6cHL2+5ApMTYkoIymhsResnQUoVTH2U+J2liCT76D3YFyWNOfg2bdzr9t5qQ2O9
         dkWA==
X-Gm-Message-State: AOAM531jWpF59pBofklJ48JQVYnSw+ofwBYqCjBMH4scOGJxJJiY0tnu
        Vy/6G4OmHLZpkbLsjUU1jh079k6YwkSyAA==
X-Google-Smtp-Source: ABdhPJx7YHeRmXK1b1y2hS+JBxAXsl94TYPP9GYMF3uNGhv+JO+l9XVUmMlHaPu9TdGB6KQE/VqZnw==
X-Received: by 2002:adf:e0d1:: with SMTP id m17mr10855541wri.90.1616705069614;
        Thu, 25 Mar 2021 13:44:29 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:835:ce1a:dbdf:db93? (p200300ea8f1fbb000835ce1adbdfdb93.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:835:ce1a:dbdf:db93])
        by smtp.googlemail.com with ESMTPSA id a4sm9155161wrx.86.2021.03.25.13.44.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 13:44:29 -0700 (PDT)
Subject: Re: [PATCH net-next v2 11/12] net: phy: marvell10g: print exact model
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, kuba@kernel.org
References: <20210325131250.15901-1-kabel@kernel.org>
 <20210325131250.15901-12-kabel@kernel.org>
 <20210325155452.GO1463@shell.armlinux.org.uk>
 <20210325212905.3d8f8b39@thinkpad>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <418e86fb-dd7b-acbb-e648-1641f06b254b@gmail.com>
Date:   Thu, 25 Mar 2021 21:44:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210325212905.3d8f8b39@thinkpad>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.03.2021 21:29, Marek Behún wrote:
> On Thu, 25 Mar 2021 15:54:52 +0000
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> 
>> The 88X3310 and 88X3340 can be differentiated by bit 3 in the revision.
>> In other words, 88X3310 is 0x09a0..0x09a7, and 88X3340 is
>> 0x09a8..0x09af. We could add a separate driver structure, which would
>> then allow the kernel to print a more specific string via standard
>> methods, like we do for other PHYs. Not sure whether that would work
>> for the 88X21x0 family though.
> 
> According to release notes it seems that we can also differentiate
> 88E211X from 88E218X (via bit 3 in register 1.3):
>  88E211X has 0x09B9
>  88E218X has 0x09B1
> 
> but not 88E2110 from 88E2111
>     nor 88E2180 from 88E2181.
> 
> These can be differentiated via register
>   3.0004.7
> (bit 7 of MDIO_MMD_PCS.MDIO_SPEED., which says whether device is capable
>  of 5g speed)
> 

If the PHY ID's are the same but you can use this register to
differentiate the two versions, then you could implement the
match_phy_device callback. This would allow you to have separate
PHY drivers. This is just meant to say you have this option, I don't
know the context good enough to state whether it's the better one.


> I propose creating separate structures for mv88x3340 and mv88e218x.
> We can then print the remaining info as
>   "(not) macsec/ptp capable"
> or
>   "(not) 5g capable"
> 
> What do you think?
> 
> Marek
> 

