Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010D02A68EB
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbgKDQBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgKDQBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 11:01:47 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9F5C0613D3;
        Wed,  4 Nov 2020 08:01:47 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id c20so17625014pfr.8;
        Wed, 04 Nov 2020 08:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2u1iCwu3NUExL8v9uHwy0KlSiN494f+zV9SSy+u0HpA=;
        b=Fn5jqnTJCAviROi/YLFeUOFV9JK+CsbPo5Q7hWQTh0o7ltr2I3IsSPlZTRSl7jZnE6
         9DO3aobg6ksT/EwJyT/rAViPpeelmCu3GZKq+YGsjRcUZOCMbNzwMuTvKrkcU49sXqav
         EQbUTn2qh9Z6FD1iD/Eg2Y8zYooSW1luC2GSwOHe6TOCltfhACqnWTju+70qmGlb1B57
         qtKEiWj7wfg/Csz6qdTdwcv2tSNbM8cRQWe4ZuSDRJuWrOXxDgrKoHK+kdN8Mr744BFo
         aUkJXBSH4RsPLKO2VrBlYpQbA383yzYpj0zBYIe/kCGuwJH+TGR7xua7oWH4X2rCRhOC
         P56g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2u1iCwu3NUExL8v9uHwy0KlSiN494f+zV9SSy+u0HpA=;
        b=gRoN3CKpDSqvxtcJ178aqfNohEB9qQPhdqeTL/JpckK9pJN4L/CoZdvi8ZrKroMdtd
         zUcPDGECjryvTSoV8kflaQznSmkltzwrA3+FtMQoLi3mDqR/IFviqMv7RsLdFregMxLO
         s5tB5IZ8tdjsVMW1i2o90EmXoEdxsvlKQPufVL8tRvmPYk5o8m82mYvU4rXCam1vN2uA
         QnUxVwTwUxY3SjYqCgqL560ZNZPrwjPjsLikdVJxf8x67kJj6gRAVQkOBQEIx6tfWcqo
         RGpDl7VOb5fdnnf05zRanIWVaAECt2fK6x5CRrl9HaBj7Yl8CjFXIAW9nvvH7vvRI1l8
         TkEg==
X-Gm-Message-State: AOAM532FFHwfPVLYM+dRE0XTDB7Rm6Ct5FrKvPeIT/5wXPLsQ43R1tSk
        vVN1JkgsEUewO1i/XK6mqP0=
X-Google-Smtp-Source: ABdhPJyX05Y9HcDtz4Imtc3239h3VaP7aGo3GntRwUCM8jkGOlxSbh69LBp8l9NLQJxAIu+SoAaYQg==
X-Received: by 2002:a63:2b53:: with SMTP id r80mr22106711pgr.439.1604505706821;
        Wed, 04 Nov 2020 08:01:46 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id j19sm2855155pfn.107.2020.11.04.08.01.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 08:01:46 -0800 (PST)
Subject: Re: [EXTERNAL] Re: [PATCH net 2/4] net:phy:smsc: expand documentation
 of clocks property
To:     "Badel, Laurent" <LaurentBadel@eaton.com>,
        Rob Herring <robh@kernel.org>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "m.felsch@pengutronix.de" <m.felsch@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Quette, Arnaud" <ArnaudQuette@Eaton.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <CY4PR1701MB187834A07970380742371D78DF160@CY4PR1701MB1878.namprd17.prod.outlook.com>
 <20201030191910.GA4174476@bogus>
 <CY4PR1701MB18789E4C1FE2C3FBCB1FC010DFEF0@CY4PR1701MB1878.namprd17.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <da87e8d5-01f9-50c2-5583-3876f9c12c8f@gmail.com>
Date:   Wed, 4 Nov 2020 08:01:44 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CY4PR1701MB18789E4C1FE2C3FBCB1FC010DFEF0@CY4PR1701MB1878.namprd17.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/2020 4:11 AM, Badel, Laurent wrote:
> ﻿> 
> 
> -----------------------------
> Eaton Industries Manufacturing GmbH ~ Registered place of business: Route de la Longeraie 7, 1110, Morges, Switzerland 
> 
> -----------------------------
> 
> -----Original Message-----
>> From: Rob Herring <robh@kernel.org>
>> Sent: Friday, October 30, 2020 8:19 PM
>> To: Badel, Laurent <LaurentBadel@eaton.com>
>> Cc: davem@davemloft.net; fugang.duan@nxp.com; andrew@lunn.ch;
>> lgirdwood@gmail.com; m.felsch@pengutronix.de; robh+dt@kernel.org;
>> kuba@kernel.org; linux@armlinux.org.uk; richard.leitner@skidata.com;
>> netdev@vger.kernel.org; Quette, Arnaud <ArnaudQuette@Eaton.com>;
>> p.zabel@pengutronix.de; devicetree@vger.kernel.org; f.fainelli@gmail.com;
>> broonie@kernel.org; Heiner Kallweit <hkallweit1@gmail.com>
>> Subject: [EXTERNAL] Re: [PATCH net 2/4] net:phy:smsc: expand
>> documentation of clocks property
>>
>> On Tue, 27 Oct 2020 23:27:42 +0000, Badel, Laurent wrote:
>>> ﻿Subject: [PATCH net 2/4] net:phy:smsc: expand documentation of clocks
>>> property
>>>
>>> Description: The ref clock is managed differently when added to the DT
>>> entry for SMSC PHY. Thus, specify this more clearly in the documentation.
>>>
>>> Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
>>> ---
>>>  Documentation/devicetree/bindings/net/smsc-lan87xx.txt | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>
>> Acked-by: Rob Herring <robh@kernel.org>
> 
> Thank you very much.
> I'm guessing perhaps I should re-send this as a single patch since there 
> are issues with the patch series?
> I realize now that I should have splitted things differently.

There are several things with your patch series that make it very hard
to be followed or to even know what is the latest version of your patch
series. If you can resubmit everything targeting the 'net' tree along
with a cover letter explaining the differences between v1 and v2 that
would help. Please make sure that all of your patches reference the
cover letter's Message-Id which is the default if you use git
format-patch --cover-letter .

Thanks
-- 
Florian
