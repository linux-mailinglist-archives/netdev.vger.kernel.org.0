Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE49B6C6E33
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbjCWQ5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjCWQ5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:57:39 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2405B5;
        Thu, 23 Mar 2023 09:57:38 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id bc12so22285902plb.0;
        Thu, 23 Mar 2023 09:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679590658;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rZDCRTtQWBLw+FUDg3W6YJwrAVga8k1yA3fsIRRtWaY=;
        b=KJ6YK/o2Kd1fjUrg2bcHCziIdmFE8VlqE0PrV3nEp1tgEcmcxzDRwDfQq0jyH/5EtK
         cXdUUNcHFCN0UFXRGn1R5AjTAx/gVATVfk8QhsLYhOL1896cBRC9s0UDMWyVcEX3vbc/
         /OGJFqG2vBM5hyA2nZADj5wnuX9Vozf302gTsPUf0K3L6BZ5+5fgwuYImTFAqYKkjv64
         BzfN5hvDjlOr6GQ4NY8qeB3AxY6FTz2Z+lNvsN40/QbQsjZf44KZPPQZVufamB/EDR1S
         tBjqbWpRnnnNSYCDlDiHhxwhd+qTSWvop2gvraK29z7RBwgXro/E7ytQkRkGTs9pmcon
         5TFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679590658;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rZDCRTtQWBLw+FUDg3W6YJwrAVga8k1yA3fsIRRtWaY=;
        b=r7V45eymEO0A3svyysbcg8XvkJwnp8hHBa+ILxrukigxsCi/k0JENsCO3M6dRhTvwM
         tiOPgJQuYiQDyJMgoV9mEn4cDLOV6woTc8hpWbvnG4SVF3W0KKlu5Ole0nvdLLzafh84
         AF2wsPpSCz5eva2gj6agpqtXClz1/Q94kCBQ1hDVjB+CeI7Ot+j68j1YG0R9VOSzRms3
         oHlegbRp7pcjF/5b3y6XFr7P2JPuc0FXO4CxrmQpjb7zMiOSvuDq/evZizOATay2g4B/
         2kxE0Cyst+BCkpsoqb1Qnc/FTxVBm2vbt4DPMQJ5km38AiwvEYnwFRSwxWJi9Khb8tVS
         n/GQ==
X-Gm-Message-State: AO0yUKX1PlBw9V3JQVb6ad23qG7FITZd6CG80XvxwcNi/CuHo/pFOjdN
        tVoQ1OYnbt+eysac7dBMwvA=
X-Google-Smtp-Source: AK7set+1sucQTgjcVmHuzA+BYMGeAY1zagmQQSf7J3zSCnSCWJi3gPcMMYtMVymGYRYDOXynOsEG1g==
X-Received: by 2002:a17:902:e54f:b0:1a0:4531:af58 with SMTP id n15-20020a170902e54f00b001a04531af58mr8532780plf.63.1679590658093;
        Thu, 23 Mar 2023 09:57:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p10-20020a1709026b8a00b0019ab151eb90sm12483996plk.139.2023.03.23.09.57.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 09:57:37 -0700 (PDT)
Message-ID: <37d626f7-d38d-69b4-d57c-73ddd47163a5@gmail.com>
Date:   Thu, 23 Mar 2023 09:57:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 2/2] net: dsa: b53: mdio: add support for BCM53134
Content-Language: en-US
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>
Cc:     paul.geurts@prodrive-technologies.com, jonas.gorski@gmail.com,
        andrew@lunn.ch, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230323121804.2249605-1-noltari@gmail.com>
 <20230323121804.2249605-3-noltari@gmail.com>
 <ee867960-91bb-659b-a87b-6c04613608c5@gmail.com>
 <CAKR-sGdhVTH__KT2bu3NM56QoJgiM0JuKXGabW5uLRg8NMwGmA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAKR-sGdhVTH__KT2bu3NM56QoJgiM0JuKXGabW5uLRg8NMwGmA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/23 09:49, Álvaro Fernández Rojas wrote:
> El jue, 23 mar 2023 a las 17:43, Florian Fainelli
> (<f.fainelli@gmail.com>) escribió:
>>
>> On 3/23/23 05:18, Álvaro Fernández Rojas wrote:
>>> From: Paul Geurts <paul.geurts@prodrive-technologies.com>
>>>
>>> Add support for the BCM53134 Ethernet switch in the existing b53 dsa driver.
>>> BCM53134 is very similar to the BCM58XX series.
>>>
>>> Signed-off-by: Paul Geurts <paul.geurts@prodrive-technologies.com>
>>> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
>>> ---
>>>    drivers/net/dsa/b53/b53_common.c | 53 +++++++++++++++++++++++++++++++-
>>>    drivers/net/dsa/b53/b53_mdio.c   |  5 ++-
>>>    drivers/net/dsa/b53/b53_priv.h   |  9 +++++-
>>>    3 files changed, 64 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
>>> index 1f9b251a5452..aaa0813e6f59 100644
>>> --- a/drivers/net/dsa/b53/b53_common.c
>>> +++ b/drivers/net/dsa/b53/b53_common.c
>>> @@ -1282,6 +1282,42 @@ static void b53_adjust_link(struct dsa_switch *ds, int port,
>>>        if (is63xx(dev) && port >= B53_63XX_RGMII0)
>>>                b53_adjust_63xx_rgmii(ds, port, phydev->interface);
>>>
>>> +     if (is53134(dev) && phy_interface_is_rgmii(phydev)) {
>>
>> Why is not this in the same code block as the one for the is531x5()
>> device like this:
> 
> This is what I asked on the cover letter:
>> I also added a separate RGMII handling block for is53134() since according to
>> Paul, BCM53134 doesn't support RGMII_CTRL_TIMING_SEL as opposed to is531x5().
> 
> Should I add it to the same block and avoid adding
> RGMII_CTRL_TIMING_SEL if is53134() or is it compatible with
> RGMII_CTRL_TIMING_SEL?

RGMII_CTRL_TIMING_SEL is not defined for the 53125 or 53128, and for 
53115, the register 0x60 is not even defined in the datasheet. 
RGMII_CTRL_TIMING_SEL is defined for the 53134 however and would control 
how the two other bits behave with respect to RGMII timing. My guess is 
that if we removed it entirely we would not be breaking anything, and we 
could just support all of the 531x5() and 53134 families within the same 
block.

Jonas, do you remember why setting RGMII_CTRL_TIMING_SEL might have been 
necessary?
--
Florian

