Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B032E3E4C47
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 20:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235432AbhHISkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 14:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbhHISkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 14:40:08 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A8CC0613D3;
        Mon,  9 Aug 2021 11:39:47 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id a8so29389189pjk.4;
        Mon, 09 Aug 2021 11:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=56m5WxF46cuEBqooJdKU5PqcLQQVhGAT5R7cabcEapE=;
        b=tsMQOjYz16wH9fytQh/kRgjgXs8cj3wXFQ5QB7wtsYiqg/2gVo2Yi6KRWhCGqZ1ggd
         s/X5XK5D8aD4kpklPt5PwYL771bY//pQLg0QUogRUh/Re6oPA26YmO1DNx4kW8gj82s5
         kA1UM3yHIe4r8LeYxCz6tZuBiOcyKunYtxFvJ8/ETBugCYMwKVpBfDz1gbFy8x5Ld63T
         YgslmC+eNRldYGqdAYGC8OMPSoQvMvr6K7Gf90SKG9N0okqqWqxl2ddcwoGJJoO4vxwK
         NrIktrJ6FuvF9f0J/jd4kwzc4x7axvQd0eABbg87naV+gqsrCwHkX5G3wyFKHtLXqjsP
         cj+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=56m5WxF46cuEBqooJdKU5PqcLQQVhGAT5R7cabcEapE=;
        b=bI/qO/F3RR0bhrE7f1cPk+2jjZANugw+HqQNMlNlId6mZZl1MOAU7XoWHbquW9ZJRQ
         otMrE1LyAv94L2jbZEy5IGCg6rRBagLDtlhL8ufX/EjyQ5dih/17nAReS6GqLStIWUTa
         8MkK1cDJ18uuVOamuCvZcYC0+Sy/JZ+EEzgFm0i1hPX6iZmitXEivhSDfRE3dzTnKx14
         sLlBM0WFyqAFV5qyIfNhbmJawhCZW1sfFtOQJZODpvFCJOw8H+yXHBDTsHjNbXDhp8kW
         zAsIyr626HIOS1vpfjyulcaFRVC4gkfzSFLVcJD48n54v+uxW0+XKnoy1vB40nn931+a
         q5NA==
X-Gm-Message-State: AOAM532MNcot/O8aU+jRq0pFTlanXeLLWl+jIuwgEElbJA6No9dEyRpe
        N21lbE/EdtWtbWvmiOLENdw=
X-Google-Smtp-Source: ABdhPJzMFbb6956f53hngsq0oj6k2EOrYjUURl6JvtdkeTT1ZSa4W2jxnm/PSbr/G2jFyVog/z4M1g==
X-Received: by 2002:a63:f410:: with SMTP id g16mr563625pgi.201.1628534387435;
        Mon, 09 Aug 2021 11:39:47 -0700 (PDT)
Received: from [192.168.1.22] (amarseille-551-1-7-65.w92-145.abo.wanadoo.fr. [92.145.152.65])
        by smtp.gmail.com with ESMTPSA id e12sm19136138pjh.33.2021.08.09.11.39.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 11:39:46 -0700 (PDT)
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
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <498f3cee-8f37-2ab1-93c4-5472572ecc37@gmail.com>
Date:   Mon, 9 Aug 2021 11:39:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB67950F6863A8FEE6745CBC68E6F69@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/8/2021 10:08 PM, Joakim Zhang wrote:
> 
> Hi Florian,
> 
>> -----Original Message-----
>> From: Florian Fainelli <f.fainelli@gmail.com>
>> Sent: 2021年8月5日 17:18
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
>> On 8/5/2021 12:46 AM, Joakim Zhang wrote:
>>> Add "fsl,wakeup-irq" property for FEC controller to select wakeup irq
>>> source.
>>>
>>> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
>>> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
>>
>> Why are not you making use of the standard interrupts-extended property
>> which allows different interrupt lines to be originating from different interrupt
>> controllers, e.g.:
>>
>> interrupts-extended = <&gic GIC_SPI 112 4>, <&wakeup_intc 0>;
> 
> Thanks.
> 
> AFAIK, interrupts-extended should be used instead of interrupts when a device is connected to multiple interrupt controllers
> as it encodes a parent phandle with each interrupt specifier. However, for FEC controller, all interrupt lines are originating from
> the same interrupt controllers.

OK, so why this custom property then?

> 
> 1) FEC controller has up to 4 interrupt lines and all of these are routed to GIC interrupt controller.
> 2) FEC has a wakeup interrupt signal and always are mixed with other interrupt signals, and then output to one interrupt line.
> 3) For legacy SoCs, wakeup interrupt are mixed to int0 line, but for i.MX8M serials, are mixed to int2 line.
> 4) Now driver treat int0 as the wakeup source by default, it is broken for i.MX8M.

I don't really know what to make of your response, it seems to me that 
you are carrying some legacy Device Tree properties that were invented 
when interrupts-extended did not exist and we did not know any better.
-- 
Florian
