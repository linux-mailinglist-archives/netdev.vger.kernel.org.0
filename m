Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1511DB8EF
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 18:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgETQDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 12:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgETQDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 12:03:55 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE56C061A0E;
        Wed, 20 May 2020 09:03:55 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id d10so1640823pgn.4;
        Wed, 20 May 2020 09:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OOwuxWEO/Sl8yx5TsqcCpHvO91TmRIyEZirMBX+Uvb0=;
        b=tqYfNJBqFCzIdnyTQnESaY2EhitXzArebVnBxAmiWUH31YSwGkyxGT0bxmjdCnNP3I
         doqAT4kPg0MYs4+BiQ1Z3U1ofhnEK7ta3Pg1xLEAVVEBIzepp2mPu65oNVqpTA9bQB8b
         BH5ZCfTfUNCJzdtBjLYpmc20KA7BhcXfs8NywHaFaxxnayfjpnQLC9neSD3GFyRNHM89
         NCu07RBOShh6FI8LU3twTebMt0uAnwfJJTbpsKJHe1sUBcZIRdUKl5PcTpo7c2QFxqZZ
         QO2rjpg22xaV7mFRc5Iowj9Z6nkp2FIIOKvZ947SgpukLUqvIo+PwalmnOLcrrr6llAB
         P0Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OOwuxWEO/Sl8yx5TsqcCpHvO91TmRIyEZirMBX+Uvb0=;
        b=T18iy+PF1ETZQ8uWvFNV2KApObosuFGblXWl9pA8/LSOI4sySzDQpaBHONwST/fvo9
         lkENUP2EJ2WuvctEtYo/EHNZVuoXqdg3aCjnWc4zEgVE2C4M5YpPCbh4w4FmtEpR8CoD
         VpErf4N+rba5ef9D0AUeKZDHfObWIzkGyUYBerQI/hBVsgrCyctLq6v1NCFYMSFw3y7N
         k+CX/ZcL/btsFE9hQxpS1VCVUojq6wy7S80Kpdq3akLOp6FhaolEV0oNJc00TYO0WmfG
         h66YhiO33gVgzhmZ9I3cdthVZzzX6SocQX/QKbgbZggy5biJpyIvuspTaaM6gLO8lnzl
         vsQA==
X-Gm-Message-State: AOAM53257m8vzqvYKfvZD91iF8EKUGMNthUgOYTb1VMKDBFGatFa4EJn
        3JYAHb4s2j1pGSql+tw7nqMru/sL
X-Google-Smtp-Source: ABdhPJyzKgk4okw2I5EAYp6yP9oqV+jg1QwGBzglmgRe4hDbyE6yihw912kZx/Hr1COTy0fgNciqFw==
X-Received: by 2002:a63:2347:: with SMTP id u7mr4590793pgm.183.1589990634413;
        Wed, 20 May 2020 09:03:54 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w7sm2381841pfw.82.2020.05.20.09.03.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 09:03:53 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/4] dt-bindings: net: Add RGMII internal
 delay for DP83869
To:     Dan Murphy <dmurphy@ti.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <20200520121835.31190-1-dmurphy@ti.com>
 <20200520121835.31190-4-dmurphy@ti.com> <20200520135624.GC652285@lunn.ch>
 <770e42bb-a5d7-fb3e-3fc1-b6f97a9aeb83@ti.com>
 <20200520153631.GH652285@lunn.ch>
 <95ab99bf-2fb5-c092-ad14-1b0a47c782a4@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0d80a7f6-35a9-9b3f-2a8f-65b793d1ce98@gmail.com>
Date:   Wed, 20 May 2020 09:03:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <95ab99bf-2fb5-c092-ad14-1b0a47c782a4@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/20/2020 8:56 AM, Dan Murphy wrote:
> Andrew
> 
> On 5/20/20 10:36 AM, Andrew Lunn wrote:
>>>> Hi Dan
>>>>
>>>> Having it required with PHY_INTERFACE_MODE_RGMII_ID or
>>>> PHY_INTERFACE_MODE_RGMII_RXID is pretty unusual. Normally these
>>>> properties are used to fine tune the delay, if the default of 2ns does
>>>> not work.
>>> Also if the MAC phy-mode is configured with RGMII-ID and no internal
>>> delay
>>> values defined wouldn't that be counter intuitive?
>> Most PHYs don't allow the delay to be fine tuned. You just pass for
>> example PHY_INTERFACE_MODE_RGMII_ID to the PHY driver and it enables a
>> 2ns delay. That is what people expect, and is documented.
> 
>> Being able to tune the delay is an optional extra, which some PHYs
>> support, but that is always above and beyond
>> PHY_INTERFACE_MODE_RGMII_ID.
> 
> I am interested in knowing where that is documented.  I want to RTM I
> grepped for a few different words but came up empty
> 
> Since this is a tuneable phy we need to program the ID.  2ns is the
> default value
> 
> Maybe I can change it from Required to Configurable or Used.

I do not think this is properly documented, it is an established
practice, but it should be clearly documented somewhere, I do not know
whether that belongs in the PHY Device Tree binding or if this belongs
to the PHY documentation.
-- 
Florian
