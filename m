Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B00F3EA25C
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 11:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235608AbhHLJrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 05:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236200AbhHLJq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 05:46:57 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BC1C06179C;
        Thu, 12 Aug 2021 02:46:31 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so14273803pji.5;
        Thu, 12 Aug 2021 02:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p0S9yd93hJUofIaZXMuYLRgaJwtt+ZTGW3IkG7IjUxU=;
        b=uvTtjzE0Tvzea+40xzT+Bfl1jRcID8I6G5PPXSe9YrETNMQh9u+S/mSgBc1qsvBa14
         6ePX1rGUx0dyeKu4s912qN1gZQYW26r1NRoUQKlKNXmesBq7kQtCYjuiFyjBslarVmlg
         4e2868roiHYqd8XmXkCrvPFnVivZwkhdFk/EwQjHi+D+poVA4Ta97ICT6GZxrEd8gYiO
         c3Ft1MPUSEpx4YqtLVJ2KagOBofiOBSjrfprDIEwjNSZDRwJWiy9kS38+mKKD2KwvO83
         Sn9GizpoVicS5v+EOJslexNllWHa6OburK7uk61QFwkHg2ygyP9mdfX0EGqPVOf060/9
         LdxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p0S9yd93hJUofIaZXMuYLRgaJwtt+ZTGW3IkG7IjUxU=;
        b=BIWsmVTu2yVOxE/R8sY+a0+VL9cA8j7HS7CSLVJ9aY95YapxYmQSkOTVhBWAlpHHJy
         hm4iaA+08YnYaKA/fJdC7ZUASPkY+ZvE8UiJBa2/4S6qfLSHjvuMaW3Oma19fshJDBE1
         bv/Rfimxe52ryhwxxcLYEYQdLQeTkAecfPNs5ApSfZsGXMgIPZcqEM62k4uYL+Og4r/a
         uebkuSCXBaMuE8thu8sIcbh2T3SDGU/0/nuZ93C20wX1U1VQgzGGu7TzOKeDiLC6qIy/
         YlFXJiHJlhSM8mGjFwwLDLG5H95IPK6B1tPrNFJbKWUFCwPvde8qnI376sXzbM9OrzcX
         FDAg==
X-Gm-Message-State: AOAM533vVRSJP2uYD5FcI9IT0ENvlCtZvG7r4H6HaMSsEQ29d9FAPlyH
        xoM4jmqSTn0Uaf+Uij1axrw=
X-Google-Smtp-Source: ABdhPJwYVE1aRoDJBlM9YFZACF6QXIh1Dv9KdlDpwcV3qdKEKdxWGL2X/2hCGYIzd2BZ0sYlfQPsZQ==
X-Received: by 2002:a63:33c9:: with SMTP id z192mr3124473pgz.42.1628761591096;
        Thu, 12 Aug 2021 02:46:31 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g26sm2856071pgb.45.2021.08.12.02.46.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 02:46:30 -0700 (PDT)
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
 <90af8051-512d-1230-72a7-8bbcee984939@gmail.com>
 <VI1PR04MB6800F8425473916A82F050F5E6F89@VI1PR04MB6800.eurprd04.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e3834192-249a-576e-daa0-fb2fac177397@gmail.com>
Date:   Thu, 12 Aug 2021 02:46:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <VI1PR04MB6800F8425473916A82F050F5E6F89@VI1PR04MB6800.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/11/2021 1:06 AM, Joakim Zhang wrote:
> 
>> -----Original Message-----
>> From: Florian Fainelli <f.fainelli@gmail.com>
>> Sent: 2021年8月11日 1:45
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
>> On 8/9/2021 7:21 PM, Joakim Zhang wrote:
>>>
>>> Hi Florian,
>>>
>>>> -----Original Message-----
>>>> From: Florian Fainelli <f.fainelli@gmail.com>
>>>> Sent: 2021年8月10日 2:40
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
>>>> On 8/8/2021 10:08 PM, Joakim Zhang wrote:
>>>>>
>>>>> Hi Florian,
>>>>>
>>>>>> -----Original Message-----
>>>>>> From: Florian Fainelli <f.fainelli@gmail.com>
>>>>>> Sent: 2021年8月5日 17:18
>>>>>> To: Joakim Zhang <qiangqing.zhang@nxp.com>; davem@davemloft.net;
>>>>>> kuba@kernel.org; robh+dt@kernel.org; shawnguo@kernel.org;
>>>>>> s.hauer@pengutronix.de; festevam@gmail.com; andrew@lunn.ch
>>>>>> Cc: kernel@pengutronix.de; dl-linux-imx <linux-imx@nxp.com>;
>>>>>> netdev@vger.kernel.org; devicetree@vger.kernel.org;
>>>>>> linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
>>>>>> Subject: Re: [PATCH net-next 1/3] dt-bindings: net: fsl, fec: add
>>>>>> "fsl, wakeup-irq" property
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 8/5/2021 12:46 AM, Joakim Zhang wrote:
>>>>>>> Add "fsl,wakeup-irq" property for FEC controller to select wakeup
>>>>>>> irq source.
>>>>>>>
>>>>>>> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
>>>>>>> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
>>>>>>
>>>>>> Why are not you making use of the standard interrupts-extended
>>>>>> property which allows different interrupt lines to be originating
>>>>>> from different interrupt controllers, e.g.:
>>>>>>
>>>>>> interrupts-extended = <&gic GIC_SPI 112 4>, <&wakeup_intc 0>;
>>>>>
>>>>> Thanks.
>>>>>
>>>>> AFAIK, interrupts-extended should be used instead of interrupts when
>>>>> a device is connected to multiple interrupt controllers as it
>>>>> encodes a parent phandle with each interrupt specifier. However, for
>>>>> FEC controller, all
>>>> interrupt lines are originating from the same interrupt controllers.
>>>>
>>>> OK, so why this custom property then?
>>>>
>>>>>
>>>>> 1) FEC controller has up to 4 interrupt lines and all of these are
>>>>> routed to GIC
>>>> interrupt controller.
>>>>> 2) FEC has a wakeup interrupt signal and always are mixed with other
>>>> interrupt signals, and then output to one interrupt line.
>>>>> 3) For legacy SoCs, wakeup interrupt are mixed to int0 line, but for
>>>>> i.MX8M
>>>> serials, are mixed to int2 line.
>>>>> 4) Now driver treat int0 as the wakeup source by default, it is
>>>>> broken for
>>>> i.MX8M.
>>>>
>>>> I don't really know what to make of your response, it seems to me
>>>> that you are carrying some legacy Device Tree properties that were
>>>> invented when interrupts-extended did not exist and we did not know any
>> better.
>>>
>>> As I described in former mail, it is not related to interrupts-extended
>> property.
>>>
>>> Let's take a look, e.g.
>>>
>>> 1) arch/arm/boot/dts/imx7d.dtsi
>>> interrupts = <GIC_SPI 102 IRQ_TYPE_LEVEL_HIGH>,
>>> 		<GIC_SPI 100 IRQ_TYPE_LEVEL_HIGH>,
>>> 		<GIC_SPI 101 IRQ_TYPE_LEVEL_HIGH>,
>>> 		<GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>;
>>> interrupt-names = "int0", "int1", "int2", "pps";
>>>
>>> For these 4 interrupts are originating from GIC interrupt controller,
>>> "int0" for queue 0 and other interrupt signals, containing wakeup; "int1" for
>> queue 1; "int2" for queue 2.
>>>
>>> 2) arch/arm64/boot/dts/freescale/imx8mq.dtsi
>>> interrupts = <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>,
>>> 	<GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>,
>>> 	<GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>,
>>> 	<GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>;
>>> interrupt-names = "int0", "int1", "int2", "pps";
>>>
>>> For these 4 interrupts are also originating from GIC interrupt
>>> controller, "int0" for queue 0; "int1" for queue 1; "int2" for queue 2 and other
>> interrupt signals, containing wakeup.
>>>
>>> If we want to use WoL feature, we need invoke enable_irq_wake() to let
>>> this specific interrupt line be a wakeup source. For FEC driver now,
>>> it treats "int0" as wakeup interrupt by default. Obviously it's not fine for
>> i.MX8M serials, since SoC mix wakeup interrupt signal into "int2", so I add this
>> "fsl,wakeup-irq" custom property to indicate which interrupt line contains
>> wakeup signal.
>>>
>>> Not sure if I have explained it clearly enough, from my point of view, I think
>> interrupts-extended property can't fix this issue, right?
>>
>> This is clearer, and indeed interrupts-extended won't fix that, however it seems
>> to me that this is a problem that ought to be fixed at the interrupt
>> controller/irq_chip level which should know and be told which interrupt lines
>> can be made wake-up interrupts or not. From there on, the driver can test with
>> enable_irq_wake() whether this has a chance of working or not.
> 
> How can we test with enable_irq_wake()? I agree that interrupt controller can recognize
> wakeup interrupt is better.

If enable_irq_wake() returns -ENOTSUPP you would know that wake-up for 
that interrupt controller's line is not capable of wake-up?

> 
>> It seems to me that the 'fsl,wakeup-irq' property ought to be within the
>> interrupt controller Device Tree node (where it would be easier to validate that
>> the specific interrupt line is correct) as opposed to within the consumer (FEC)
>> Device Tree node.
> 
> Not quite understand, could you explain more?

What I mean is that if you need to express which interrupt lines within 
an interrupt controller are capable of wake-up, then there should be a 
property that tells us that and that property needs to be within the 
interrupt controller, not within the consumer of that interrupt since 
the consumer has no idea how the system is wired up. Andrew's suggestion 
is sort of the same thing, except that it punts the responsibility of 
specifying the interrupt's capability towards the consumer of that 
interrupt.
-- 
Florian
