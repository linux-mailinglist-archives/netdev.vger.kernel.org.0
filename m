Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6095F412A16
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 02:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343744AbhIUAu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 20:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235734AbhIUAs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 20:48:56 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55ED5C103094;
        Mon, 20 Sep 2021 10:57:11 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id m3so68596836lfu.2;
        Mon, 20 Sep 2021 10:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wYL3SLwNI6SeKALlSdWrAbcvjXkGqMTL79ltgMb/k/s=;
        b=A1hZTeaPAXYcFPjIXt1EWMmHe70ns/vajAnqwTl2JRcBkYKeEi2eWefdzasUoJQPTd
         Fzoj3x/Eyu0m+Oi75xB6Js1RbHHEsX6hNgnoYh3iN4oWa1Agg7MiFLe9aUvlJFdmm7FX
         9S/PMI2H359wuV4FdjYtePPrfQh2zPVXXLWC93Fqp1Ac+y/hCXIowy+K6UEBjIg1YmGo
         jhm3USvBZA2Q00gzdJxZDQlXcncdhGh+gTTpbcRa3AAbVJdIJ2JItBpWKseA6MFU6dEP
         aXumpZGRpZBxPGrTUGqPTnKk+27oQojqc8KwIoOA/xbSnXM7MF9+ra5zb6G6nH4YOA/i
         JCPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wYL3SLwNI6SeKALlSdWrAbcvjXkGqMTL79ltgMb/k/s=;
        b=YLB6gkBT5NB77HM9fdVnSfpIHPt2TrEGMT5ceEopq/03ROaTxq6pw8n499jc+FixqZ
         LZu1RBhR/d6VqAQu+5Tz2xeCvbMRE3qcAP1MiNU+nMnSeHkBwbBZIKAPfRupxHWYAfDe
         ULKB5ZlBV1sdaw24EA/Pieg6DoIaSfbAGrPbuLvdE6+IUI6nNtC8gcsPuqFd1L/2dsc+
         88Ydqav4Dwn8V9WO2afEWN+yACxiXvBT8llyZfjiYC2+BGGFgY2Q16Wo4Tl0Fb8SO9YE
         Fm57l2YJGcJ2f9DKpdrFrjtDi960SK3gL0hNnTgl9QX4QvnVRD+XcSB9LF3nXhv+Kkil
         FUUw==
X-Gm-Message-State: AOAM532pScncRGj+mfvn20R9rSXGzy60MZBC0wVOpVrS6+bXCITlyTHm
        XjDx3OyqZE69KM8JESW+wQvgq7BK9wM=
X-Google-Smtp-Source: ABdhPJzX2OpBv3c5HrO7w+YYEX99mIFFcUmmRDVxoZscr6ij7Dn49VEncZ+HNvkjG5dgNYbUwPpyrg==
X-Received: by 2002:a2e:1618:: with SMTP id w24mr20143132ljd.441.1632160628176;
        Mon, 20 Sep 2021 10:57:08 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id d7sm1837222ljc.129.2021.09.20.10.57.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 10:57:07 -0700 (PDT)
Subject: Re: [PATCH net-next] net: bgmac: support MDIO described in DT
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210920123441.9088-1-zajec5@gmail.com>
 <168e00d3-f335-4e62-341f-224e79a08558@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <79c91b0e-7f6a-ef40-9ab2-ee8212bf5791@gmail.com>
Date:   Mon, 20 Sep 2021 19:57:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <168e00d3-f335-4e62-341f-224e79a08558@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.09.2021 18:11, Florian Fainelli wrote:
> On 9/20/21 5:34 AM, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> Check ethernet controller DT node for "mdio" subnode and use it with
>> of_mdiobus_register() when present. That allows specifying MDIO and its
>> PHY devices in a standard DT based way.
>>
>> This is required for BCM53573 SoC support which has an MDIO attached
>> switch.
>>
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> ---
>>   drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c b/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c
>> index 6ce80cbcb48e..086739e4f40a 100644
>> --- a/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c
>> +++ b/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c
>> @@ -10,6 +10,7 @@
>>   
>>   #include <linux/bcma/bcma.h>
>>   #include <linux/brcmphy.h>
>> +#include <linux/of_mdio.h>
>>   #include "bgmac.h"
>>   
>>   static bool bcma_mdio_wait_value(struct bcma_device *core, u16 reg, u32 mask,
>> @@ -211,6 +212,7 @@ struct mii_bus *bcma_mdio_mii_register(struct bgmac *bgmac)
>>   {
>>   	struct bcma_device *core = bgmac->bcma.core;
>>   	struct mii_bus *mii_bus;
>> +	struct device_node *np;
>>   	int err;
>>   
>>   	mii_bus = mdiobus_alloc();
>> @@ -229,7 +231,9 @@ struct mii_bus *bcma_mdio_mii_register(struct bgmac *bgmac)
>>   	mii_bus->parent = &core->dev;
>>   	mii_bus->phy_mask = ~(1 << bgmac->phyaddr);
>>   
>> -	err = mdiobus_register(mii_bus);
>> +	np = of_get_child_by_name(core->dev.of_node, "mdio");
> 
> I believe this leaks np and the use case is not exactly clear to me
> here. AFAICT the Northstar SoCs have two MDIO controllers: one for
> internal PHYs and one for external PHYs which how you would attach a
> switch to the chip (in chipcommonA). Is 53573 somewhat different here?
> What is the MDIO bus driver that is being used?

of_get_child_by_name() doesn't seem to increase refcount or anything and
I think it's how most drivers handle it. I don't think it should leak.

BCM53573 is a built with some older blocks. Please check:

4ebd50472899 ("ARM: BCM53573: Initial support for Broadcom BCM53573 SoCs")
     BCM53573 series is a new family with embedded wireless. By marketing
     people it's sometimes called Northstar but it uses different CPU and has
     different architecture so we need a new symbol for it.
     Fortunately it shares some peripherals with other iProc based SoCs so we
     will be able to reuse some drivers/bindings.

e90d2d51c412 ("ARM: BCM5301X: Add basic dts for BCM53573 based Tenda AC9")
     BCM53573 seems to be low priced alternative for Northstar chipsts. It
     uses single core Cortex-A7 and doesn't have SDU or local (TWD) timer. It
     was also stripped out of independent SPI controller and 2 GMACs.

Northstar uses SRAB which is some memory based (0x18007000) access to
switch register space.
BCM53573 uses different blocks & mappings and it doesn't include SRAB at
0x18007000. Accessing switch registers is handled over MDIO.
