Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA39D1AE24A
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 18:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgDQQ3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 12:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgDQQ3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 12:29:13 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7507FC061A0C;
        Fri, 17 Apr 2020 09:29:13 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id t14so3705797wrw.12;
        Fri, 17 Apr 2020 09:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NofTrmVDYyLBbejpdgwinjWSh4mIkTyrqtoNVevMhns=;
        b=b6VVxgJvRatmHpf5Q7+LxH5xFXkKequl3/2X2cT9330vCyrosv3/sdyjJp37+49EoK
         sFfJeFrPLIFw1j1sDY7LDT3mfK25BZNOndqhj5Qc3nh24Z8UWmoZtM/L9DjN91TChI52
         3lzjvEmYYByE0KktCbphxTXfB5oEe+i0YHz8UHn0wb9AdpAeNMRQ21OcV7mnVZpDvfef
         Yc9F5Jw06dZNV8wKw3kyW5TJj0Cmpp1kP107I71hkCqAWv3gMLTvwPf5rXIhJG9+e/OM
         6dznA8huU48ssmubIHcxa6XYpDjAluuiOQ5nvmbGbKazyv0rmrxqcwnCaYBbDZr1T6/Q
         R0Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NofTrmVDYyLBbejpdgwinjWSh4mIkTyrqtoNVevMhns=;
        b=kPNX8VNyI61QnWHmNL1PxcBW1QTD/Iu2WbPiJL25sSJnA4Wj10LVNDgCFo0Es+LAB9
         j8Dgm/7zlQbmwbE88gWfCQoadrNv/xKPn1bLQ6u+5bGKnVnc2VEb+l5eboZ+pUMv9MRg
         96UgTow1B57PvwJBm2YwH/gfveHRief1QRp9xLDA11sITQ6rjfxTqL2CJgC0e2jp6FSX
         iE1SwChwNpo5TdHagt7ebWvNVOWNwvF86jD0BEND6JeB1CnWvEDyL+Dpa7v5YIcodimG
         86yYoJqr5eLveoUD+IQ6ZM05pRPDibuyxhRDyJmPgDdQcsHj+PmP29LAo69cgXZLy4CF
         aiRA==
X-Gm-Message-State: AGi0Pubo6X2+sUK72lYTKyiVme8pwHz9fvF8nNcxm+cTOS8juYg9swQn
        Tu2aM5WlbRvkzpee12hEZEwWUwBZ
X-Google-Smtp-Source: APiQypLeEfN9cpMNCmZ6kg4klLh3J3SVkr36MK55uJQmQFnORgs+ZYaMzjuzg7y3BYm/b+jovcIrkw==
X-Received: by 2002:adf:ee4c:: with SMTP id w12mr5273583wro.347.1587140951993;
        Fri, 17 Apr 2020 09:29:11 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:adc2:161e:aba7:d360? (p200300EA8F296000ADC2161EABA7D360.dip0.t-ipconnect.de. [2003:ea:8f29:6000:adc2:161e:aba7:d360])
        by smtp.googlemail.com with ESMTPSA id k133sm8953987wma.0.2020.04.17.09.29.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 09:29:11 -0700 (PDT)
Subject: Re: [RFC PATCH 2/4] net: phy: Add support for AC200 EPHY
To:     =?UTF-8?Q?Jernej_=c5=a0krabec?= <jernej.skrabec@siol.net>,
        robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com
Cc:     mripard@kernel.org, wens@csie.org, lee.jones@linaro.org,
        linux@armlinux.org.uk, davem@davemloft.net,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20200416185758.1388148-1-jernej.skrabec@siol.net>
 <20200416185758.1388148-3-jernej.skrabec@siol.net>
 <0340f85c-987f-900b-53c8-d29b4672a8fa@gmail.com>
 <6176364.4vTCxPXJkl@jernej-laptop>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <74ab97a9-adbc-6a50-d710-eb50017aa47b@gmail.com>
Date:   Fri, 17 Apr 2020 18:16:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <6176364.4vTCxPXJkl@jernej-laptop>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.04.2020 18:15, Jernej Škrabec wrote:
> Dne četrtek, 16. april 2020 ob 22:18:52 CEST je Heiner Kallweit napisal(a):
>> On 16.04.2020 20:57, Jernej Skrabec wrote:
>>> AC200 MFD IC supports Fast Ethernet PHY. Add a driver for it.
>>>
>>> Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
>>> ---
>>>
>>>  drivers/net/phy/Kconfig  |   7 ++
>>>  drivers/net/phy/Makefile |   1 +
>>>  drivers/net/phy/ac200.c  | 206 +++++++++++++++++++++++++++++++++++++++
>>>  3 files changed, 214 insertions(+)
>>>  create mode 100644 drivers/net/phy/ac200.c
>>>
>>> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
>>> index 3fa33d27eeba..16af69f69eaf 100644
>>> --- a/drivers/net/phy/Kconfig
>>> +++ b/drivers/net/phy/Kconfig
>>> @@ -288,6 +288,13 @@ config ADIN_PHY
>>>
>>>  	  - ADIN1300 - Robust,Industrial, Low Latency 10/100/1000 Gigabit
>>>  	  
>>>  	    Ethernet PHY
>>>
>>> +config AC200_PHY
>>> +	tristate "AC200 EPHY"
>>> +	depends on NVMEM
>>> +	depends on OF
>>> +	help
>>> +	  Fast ethernet PHY as found in X-Powers AC200 multi-function 
> device.
>>> +
>>>
>>>  config AMD_PHY
>>>  
>>>  	tristate "AMD PHYs"
>>>  	---help---
>>>
>>> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
>>> index 2f5c7093a65b..b0c5b91900fa 100644
>>> --- a/drivers/net/phy/Makefile
>>> +++ b/drivers/net/phy/Makefile
>>> @@ -53,6 +53,7 @@ obj-$(CONFIG_SFP)		+= sfp.o
>>>
>>>  sfp-obj-$(CONFIG_SFP)		+= sfp-bus.o
>>>  obj-y				+= $(sfp-obj-y) $(sfp-obj-m)
>>>
>>> +obj-$(CONFIG_AC200_PHY)		+= ac200.o
>>>
>>>  obj-$(CONFIG_ADIN_PHY)		+= adin.o
>>>  obj-$(CONFIG_AMD_PHY)		+= amd.o
>>>  aquantia-objs			+= aquantia_main.o
>>>
>>> diff --git a/drivers/net/phy/ac200.c b/drivers/net/phy/ac200.c
>>> new file mode 100644
>>> index 000000000000..3d7856ff8f91
>>> --- /dev/null
>>> +++ b/drivers/net/phy/ac200.c
>>> @@ -0,0 +1,206 @@
>>> +// SPDX-License-Identifier: GPL-2.0+
>>> +/**
>>> + * Driver for AC200 Ethernet PHY
>>> + *
>>> + * Copyright (c) 2020 Jernej Skrabec <jernej.skrabec@siol.net>
>>> + */
>>> +
>>> +#include <linux/kernel.h>
>>> +#include <linux/module.h>
>>> +#include <linux/mfd/ac200.h>
>>> +#include <linux/nvmem-consumer.h>
>>> +#include <linux/of.h>
>>> +#include <linux/phy.h>
>>> +#include <linux/platform_device.h>
>>> +
>>> +#define AC200_EPHY_ID			0x00441400
>>> +#define AC200_EPHY_ID_MASK		0x0ffffff0
>>> +
>>
>> You could use PHY_ID_MATCH_MODEL() here.
> 
> Hm... This doesn't work with dynamically allocated memory, right?
> 
Right ..

> Best regards,
> Jernej
> 
> 

