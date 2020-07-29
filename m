Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310D02316B9
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730687AbgG2AZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730449AbgG2AZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:25:42 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACECC061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 17:25:42 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id g26so20672562qka.3
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 17:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TYzse1rNmca228oh6Sb7csnu4dtun3Fr9+LTuztyKsA=;
        b=Zl+QZPfnGur0dfMJ+8/4H9PfKkMKIC6IoMwPkSK7qeJ+q3LRCgM+jgQR0wnhh2DG5j
         ZnWNwb3ApeDY6T0NwyQBz4gs+sBTW7U2wmW2BS7xSuAL6gT8CO4lz8hUlgQcxZDFYc5t
         cSGcEW7gSW3ZNEoVbSLmYHNFnX9LAk2/Epl+EoBJjigi6XSEK9v6b3MvjuY+mXNdaxfr
         FgrkJa8ukVvUTSAh0g1a15HW3h58hndNOlxs47wSOukh01JxIZUS9snAGKmmJZVMcrir
         i/csmMaOhLdej7L+ORgpmJhLJaw0pySd3X9TRxQZ5gxZicf9TnbPxXvohsVXcJdPnjnV
         Bu4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TYzse1rNmca228oh6Sb7csnu4dtun3Fr9+LTuztyKsA=;
        b=AjMVsVq5kKDZ64sgUKnt3OAiG7zlAzOPBGPNkNY0d7M5aeCBDiSwfmZZNhJROWUM79
         MDvRLCNv9BpKFjMBCIkTTcbAWgLaApc2pcr0VW+/RjB31725I5b1bYfUHAArX5CRy0Uj
         IxAveOinM5VWS6rCrS2JIBm4dSEJyT5DCvAl/qh31/IDuGzgqi5ZSkWcPIJIZb0GSftx
         QWqhhyhBlLlsNgVFQlBbFz/LQSeW+p5jbDtlvJ/mLpEG9OEwqjchN6EbPoFRhfF6GnK2
         U8iUt5uZ3mONW/DK/HLF4ZgJZbKCl2jDTXr10dZPOrDw/U2t01+C722rLChD/3JBargd
         2jZQ==
X-Gm-Message-State: AOAM533H5GEIa+8sSj9cn9sOYw35hwZ+KRZ8UstozfL50LV6yccugd0h
        mPv+jl61AWjMslOmKFMO7dw=
X-Google-Smtp-Source: ABdhPJwbUegbYnSL7CDI8EEsEbthV5DViW8N9I9C3ByrM3AcrrPECpaFQp/pBjkrsESwOnrHOnKs2w==
X-Received: by 2002:a05:620a:16c8:: with SMTP id a8mr30449288qkn.81.1595982341800;
        Tue, 28 Jul 2020 17:25:41 -0700 (PDT)
Received: from [10.69.56.142] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m17sm343316qkn.45.2020.07.28.17.25.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2020 17:25:40 -0700 (PDT)
Subject: Re: [PATCH RFC net-next 0/3] Restructure drivers/net/phy
To:     Ioana Ciornei <ioana.ciornei@nxp.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20200727204731.1705418-1-andrew@lunn.ch>
 <VI1PR0402MB3871906F6381418258CC7AEBE0730@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200728160802.GI1705504@lunn.ch>
 <VI1PR0402MB38714D71435CC4DF99AE5A20E0730@VI1PR0402MB3871.eurprd04.prod.outlook.com>
From:   Doug Berger <opendmb@gmail.com>
Message-ID: <1c484c7b-1988-20dc-9433-3f322e81280c@gmail.com>
Date:   Tue, 28 Jul 2020 17:28:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <VI1PR0402MB38714D71435CC4DF99AE5A20E0730@VI1PR0402MB3871.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/2020 9:28 AM, Ioana Ciornei wrote:
>> Subject: Re: [PATCH RFC net-next 0/3] Restructure drivers/net/phy
>>
>>> I think that the MAINTAINERS file should also be updated to mention
>>> the new path to the drivers. Just did a quick grep after 'drivers/net/phy':
>>> F:      drivers/net/phy/adin.c
>>> F:      drivers/net/phy/mdio-xgene.c
>>> F:      drivers/net/phy/
>>> F:      drivers/net/phy/marvell10g.c
>>> F:      drivers/net/phy/mdio-mvusb.c
>>> F:      drivers/net/phy/dp83640*
>>> F:      drivers/net/phy/phylink.c
>>> F:      drivers/net/phy/sfp*
>>> F:      drivers/net/phy/mdio-xpcs.c
>>
>> Hi Ioana
>>
>> Thanks, I will take care of that.
>>
>>> Other than that, the new 'drivers/net/phy/phy/' path is somewhat
>>> repetitive but unfortunately I do not have another better suggestion.
>>
>> Me neither.
>>
>> I wonder if we are looking at the wrong part of the patch.
>> drivers/net/X/phy/
>> drivers/net/X/mdio/
>> drivers/net/X/pcs/
>>
>> Question is, what would X be?
>>
>>    Andrew
> 
> It may not be a popular suggestion but can't we take the drivers/net/phy,
> drivers/net/pcs and drivers/net/mdio route?
> 
> Ioana
> 
> 
> 
That sounds preferable to me as well.
-Doug
