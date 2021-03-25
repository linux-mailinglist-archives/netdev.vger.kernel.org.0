Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81780349339
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhCYNnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbhCYNm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 09:42:56 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18D6C06174A;
        Thu, 25 Mar 2021 06:42:55 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id o16so2393515wrn.0;
        Thu, 25 Mar 2021 06:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r8VujCEl1M2jspW4zhAHvPpPLFXt2mPappg2/9V9Kdk=;
        b=I1Wd/Nb3x6i2s9ghMxJ2C3bRIG9M4RYMKVpSP3HSeNxNnnZc4CkIwDaSD+RrCKclC4
         ItWmB/SFnpmSOnDes8A+HUOjMHCdiPKmiK2orql4DeRXACaErSictst6XA4tRMDsDgCG
         zLKqteNOktNVQM0JaTFKFrMxzN+wMG4Pe76U7d6siwl0b2YpPcnmmvLWidGzztqzpnAB
         m4yHpg65N/0XFLx341byW9muUdNw+xmzdvZTXvVpyVTVlqNJL2MVCLHswz7FMFR/7fYr
         o5aDQa9T5sJV/VBh11PD4itKyBmBre0f7kBTLaoDMWPthlxC63UG6qiaIalisnv0GgET
         thiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r8VujCEl1M2jspW4zhAHvPpPLFXt2mPappg2/9V9Kdk=;
        b=McrFRwjSQrRi9Owf8kbjONRtToMVHdFbb7Z1mxHYEi9Xnfi5wugrtn09ORNtut6i5S
         cPhUs8/OY+d8gNyLRhSN6hxldysVF1C+NUDL09//h/q47i/BVZRfXsJ3i+h0ZG34Eaik
         tO60Hw5kaheD/ecLhPSkAJWgPTlltiqC+QQZA48r0Wg6dasPNx3Q1yf3jkgxJ1re2EuU
         l/H9/AGLg8IH9NwG8LZ7/wEw0bmvQjqvyKNLtIge/8DAlUeIBidF+etSjyc5H6uQSC2a
         ZzhA1GIrVuZA6huwlqnxye/54XONqIjS/9BHXSA5TOlzd3gtoubzIIJgUUtjpiwwvl+g
         zgpg==
X-Gm-Message-State: AOAM530u7hBKH+TjcikyXNHpmuROX2E1qbxY0wfp77qNNwVIHHzhDLXH
        Lz68R2MUT7r1WgH8nkcljBs=
X-Google-Smtp-Source: ABdhPJy7eF3+00qnRsn9jcb+jRT1qpgWOl4NqrO/iftOAJ30pEX0ydIf/4rSj9pMIR853F4NdGejfw==
X-Received: by 2002:adf:fd48:: with SMTP id h8mr9218484wrs.229.1616679774308;
        Thu, 25 Mar 2021 06:42:54 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:88ed:8e49:4b12:e7de? (p200300ea8f1fbb0088ed8e494b12e7de.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:88ed:8e49:4b12:e7de])
        by smtp.googlemail.com with ESMTPSA id r1sm8420757wrj.63.2021.03.25.06.42.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 06:42:53 -0700 (PDT)
Subject: Re: [PATCHv1 1/6] dt-bindings: net: ethernet-phy: Fix the parsing of
 ethernet-phy compatible string
To:     Anand Moon <linux.amoon@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org, devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-amlogic@lists.infradead.org, Rob Herring <robh@kernel.org>
References: <20210325124225.2760-1-linux.amoon@gmail.com>
 <20210325124225.2760-2-linux.amoon@gmail.com> <YFyIvxOHwIs3R/IT@lunn.ch>
 <CANAwSgRHHwOtWb87aeqF=kio53xCO0_c_ZkF+9hKohWoyji6dg@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <9c06a3f6-e2c4-e30a-977c-1f50a8aab328@gmail.com>
Date:   Thu, 25 Mar 2021 14:42:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CANAwSgRHHwOtWb87aeqF=kio53xCO0_c_ZkF+9hKohWoyji6dg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.03.2021 14:33, Anand Moon wrote:
> Hi Andrew,
> 
> On Thu, 25 Mar 2021 at 18:27, Andrew Lunn <andrew@lunn.ch> wrote:
>>
>> On Thu, Mar 25, 2021 at 12:42:20PM +0000, Anand Moon wrote:
>>> Fix the parsing of check of pattern ethernet-phy-ieee802.3 used
>>> by the device tree to initialize the mdio phy.
>>>
>>> As per the of_mdio below 2 are valid compatible string
>>>       "ethernet-phy-ieee802.3-c22"
>>>       "ethernet-phy-ieee802.3-c45"
>>
>> Nope, this is not the full story. Yes, you can have these compatible
>> strings. But you can also use the PHY ID,
>> e.g. ethernet-phy-idAAAA.BBBB, where AAAA and BBBB are what you find in
>> registers 2 and 3 of the PHY.
>>
> 
> Oops I did not read the drivers/net/mdio/of_mdio.c completely.
> Thanks for letting me know so in the next series,
> I will try to add the below compatible string as per the description in the dts.

That's not needed, typically the PHY ID is auto-detected.
Before sending a new series, please describe in detail what
your problem is. Simply there shouldn't be a need for such a
series. As I said: e.g. Odroid-C2 worked fine for me with
a mainline kernel.

> 
>                compatible = "ethernet-phy-id001c.c916",
>                             "ethernet-phy-ieee802.3-c22";
> 
>>> Cc: Rob Herring <robh@kernel.org>
>>> Signed-off-by: Anand Moon <linux.amoon@gmail.com>
>>> ---
>>>  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 6 +++---
>>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
>>> index 2766fe45bb98..cfc7909d3e56 100644
>>> --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
>>> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
>>> @@ -33,7 +33,7 @@ properties:
>>>          description: PHYs that implement IEEE802.3 clause 22
>>>        - const: ethernet-phy-ieee802.3-c45
>>>          description: PHYs that implement IEEE802.3 clause 45
>>> -      - pattern: "^ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}$"
>>> +      - pattern: "^ethernet-phy-ieee[0-9]{3}\\.[0-9][-][a-f0-9]{4}$"
>>
>> So here you need, in addition to, not instead of.
>>
>> Please test you change on for example imx6ul-14x14-evk.dtsi
>>
> 
> Yes I have gone through the test case.
> 
>>    Andrew
> 
> - Anand
> 

