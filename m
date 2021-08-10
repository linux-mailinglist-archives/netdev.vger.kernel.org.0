Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF913E82A9
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 20:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237732AbhHJSRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 14:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238209AbhHJSOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 14:14:43 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE711C03388C;
        Tue, 10 Aug 2021 10:45:22 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so5428270pjs.0;
        Tue, 10 Aug 2021 10:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qPru0sCmL8DtJv7eFS70iXmqGyt6Q3lHX79vcTkPn7w=;
        b=eQmIw8OQtAqgaPX//R3JZ7dIbxySX6+e8LwelnFgLV4/nZugjxZWjSb63/1KKc45mv
         jCG07W4PL2MAkVBilPeziSyW0U7lrmx8mgN1HNhEZMetkFtG35YxDYHh8VG7lIAfPgd2
         F6Ba3SgDHoAXNwSp0DWSXs92qW9dA4Be+yu7fhZMgLEgIUk/EgN2AEv8CQtZ2SpJsO5t
         VLAunCXPgjq0rRmmaMZlzdEM/SyykU7anrZTJz9CAg3hxBofkj6riN4NveBxkZV7qicV
         UaQLdFrHbozABqF3wHUstrSwkJeIf6FlEefOlPkfVG6+t5oKknmY2LvE+4iSUWmU2Wkv
         okEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qPru0sCmL8DtJv7eFS70iXmqGyt6Q3lHX79vcTkPn7w=;
        b=YODJsLIdC7pz095GuTlapkJtvGaQOROIGfSFR2GFOWbcA5nsr6BdxMEMoXumQecJBD
         q+KyL9bG6bBXaolSJy3Gpm90IfplIrJWVPmLPGREU+mNepyl4RRKTOL+/R4PVzjrEXum
         wW/ffregu7/hihPlsM57pKid50HxErlInUhl7esf2X++y7hXdrVgTYU3mDFFQAuN22uH
         gOnhJ1atNnkzlzCBci6hK6IH8TBY/7h+CPTauVghEGfi6oLbZL7PdsEI4POW7f1nbk6q
         gYyOK2aTiKjloxKzK9VBCIe5RYg4O4a9R+P8KJvTvb5wv/CkobMJWXikf3Gga0YhJWaB
         VkcA==
X-Gm-Message-State: AOAM530ghG8cVfLIMHIyTSOOR3A0zwkJb/i06zrncwJvwB/MZGuWnCsO
        LnILjwdDPrFU4jfGr7uSuvc=
X-Google-Smtp-Source: ABdhPJwP7p+a+pvC2sYjAD5cAdkngEEdQx2aG/5pgBqZMKP3gLWqBXOag+PGTAiIrhChyeUq3jgE6w==
X-Received: by 2002:a63:5641:: with SMTP id g1mr373182pgm.33.1628617522136;
        Tue, 10 Aug 2021 10:45:22 -0700 (PDT)
Received: from [192.168.1.22] (amarseille-551-1-7-65.w92-145.abo.wanadoo.fr. [92.145.152.65])
        by smtp.gmail.com with ESMTPSA id nr6sm3625453pjb.39.2021.08.10.10.45.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 10:45:21 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: fsl, fec: add "fsl,
 wakeup-irq" property
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Cc:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <20210805074615.29096-1-qiangqing.zhang@nxp.com>
 <20210805074615.29096-2-qiangqing.zhang@nxp.com>
 <2e1a14bf-2fa8-ed39-d133-807c4e14859c@gmail.com>
 <DB8PR04MB67950F6863A8FEE6745CBC68E6F69@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <498f3cee-8f37-2ab1-93c4-5472572ecc37@gmail.com>
 <DB8PR04MB6795DC35D0387637052E64A1E6F79@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <90af8051-512d-1230-72a7-8bbcee984939@gmail.com>
Date:   Tue, 10 Aug 2021 10:45:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB6795DC35D0387637052E64A1E6F79@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/9/2021 7:21 PM, Joakim Zhang wrote:
> 
> Hi Florian,
> 
>> -----Original Message-----
>> From: Florian Fainelli <f.fainelli@gmail.com>
>> Sent: 2021年8月10日 2:40
>> To: Joakim Zhang <qiangqing.zhang@nxp.com>; davem@davemloft.net;
>> kuba@kernel.org; robh+dt@kernel.org; shawnguo@kernel.org;
>> s.hauer@pengutronix.de; festevam@gmail.com; andrew@lunn.ch
>> Cc: kernel@pengutronix.de; dl-linux-imx <linux-imx@nxp.com>;
>> netdev@vger.kernel.org; devicetree@vger.kernel.org;
>> linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
>> Subject: Re: [PATCH net-next 1/3] dt-bindings: net: fsl, fec: add "fsl,
>> wakeup-irq" property
>>
>>
>>
>> On 8/8/2021 10:08 PM, Joakim Zhang wrote:
>>>
>>> Hi Florian,
>>>
>>>> -----Original Message-----
>>>> From: Florian Fainelli <f.fainelli@gmail.com>
>>>> Sent: 2021年8月5日 17:18
>>>> To: Joakim Zhang <qiangqing.zhang@nxp.com>; davem@davemloft.net;
>>>> kuba@kernel.org; robh+dt@kernel.org; shawnguo@kernel.org;
>>>> s.hauer@pengutronix.de; festevam@gmail.com; andrew@lunn.ch
>>>> Cc: kernel@pengutronix.de; dl-linux-imx <linux-imx@nxp.com>;
>>>> netdev@vger.kernel.org; devicetree@vger.kernel.org;
>>>> linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
>>>> Subject: Re: [PATCH net-next 1/3] dt-bindings: net: fsl, fec: add
>>>> "fsl, wakeup-irq" property
>>>>
>>>>
>>>>
>>>> On 8/5/2021 12:46 AM, Joakim Zhang wrote:
>>>>> Add "fsl,wakeup-irq" property for FEC controller to select wakeup
>>>>> irq source.
>>>>>
>>>>> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
>>>>> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
>>>>
>>>> Why are not you making use of the standard interrupts-extended
>>>> property which allows different interrupt lines to be originating
>>>> from different interrupt controllers, e.g.:
>>>>
>>>> interrupts-extended = <&gic GIC_SPI 112 4>, <&wakeup_intc 0>;
>>>
>>> Thanks.
>>>
>>> AFAIK, interrupts-extended should be used instead of interrupts when a
>>> device is connected to multiple interrupt controllers as it encodes a
>>> parent phandle with each interrupt specifier. However, for FEC controller, all
>> interrupt lines are originating from the same interrupt controllers.
>>
>> OK, so why this custom property then?
>>
>>>
>>> 1) FEC controller has up to 4 interrupt lines and all of these are routed to GIC
>> interrupt controller.
>>> 2) FEC has a wakeup interrupt signal and always are mixed with other
>> interrupt signals, and then output to one interrupt line.
>>> 3) For legacy SoCs, wakeup interrupt are mixed to int0 line, but for i.MX8M
>> serials, are mixed to int2 line.
>>> 4) Now driver treat int0 as the wakeup source by default, it is broken for
>> i.MX8M.
>>
>> I don't really know what to make of your response, it seems to me that you are
>> carrying some legacy Device Tree properties that were invented when
>> interrupts-extended did not exist and we did not know any better.
> 
> As I described in former mail, it is not related to interrupts-extended property.
> 
> Let's take a look, e.g.
> 
> 1) arch/arm/boot/dts/imx7d.dtsi
> interrupts = <GIC_SPI 102 IRQ_TYPE_LEVEL_HIGH>,
> 		<GIC_SPI 100 IRQ_TYPE_LEVEL_HIGH>,
> 		<GIC_SPI 101 IRQ_TYPE_LEVEL_HIGH>,
> 		<GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>;
> interrupt-names = "int0", "int1", "int2", "pps";
> 
> For these 4 interrupts are originating from GIC interrupt controller, "int0" for queue 0 and other interrupt signals, containing wakeup;
> "int1" for queue 1; "int2" for queue 2.
> 
> 2) arch/arm64/boot/dts/freescale/imx8mq.dtsi
> interrupts = <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>,
> 	<GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>,
> 	<GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>,
> 	<GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>;
> interrupt-names = "int0", "int1", "int2", "pps";
> 
> For these 4 interrupts are also originating from GIC interrupt controller, "int0" for queue 0; "int1" for queue 1; "int2" for queue 2 and other
> interrupt signals, containing wakeup.
> 
> If we want to use WoL feature, we need invoke enable_irq_wake() to let this specific interrupt line be a wakeup source. For FEC driver now,
> it treats "int0" as wakeup interrupt by default. Obviously it's not fine for i.MX8M serials, since SoC mix wakeup interrupt signal into "int2",
> so I add this "fsl,wakeup-irq" custom property to indicate which interrupt line contains wakeup signal.
> 
> Not sure if I have explained it clearly enough, from my point of view, I think interrupts-extended property can't fix this issue, right?

This is clearer, and indeed interrupts-extended won't fix that, however 
it seems to me that this is a problem that ought to be fixed at the 
interrupt controller/irq_chip level which should know and be told which 
interrupt lines can be made wake-up interrupts or not. From there on, 
the driver can test with enable_irq_wake() whether this has a chance of 
working or not.

It seems to me that the 'fsl,wakeup-irq' property ought to be within the 
interrupt controller Device Tree node (where it would be easier to 
validate that the specific interrupt line is correct) as opposed to 
within the consumer (FEC) Device Tree node.

> 
> If there is any common properties can be used for it, please let me know. Or any other better solutions also be appreciated. Thanks.

There is a standard 'wakeup-source' boolean property that can be added 
to any Device Tree node to indicate it can be a wake-up source, but what 
you need here is a bitmask, so introducing a custom property may be 
appropriate here.
-- 
Florian
