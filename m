Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8042CF92
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 21:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfE1Tfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 15:35:44 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53179 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbfE1Tfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 15:35:44 -0400
Received: by mail-wm1-f65.google.com with SMTP id y3so4249817wmm.2;
        Tue, 28 May 2019 12:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ie+CvfEsAvuDAFXyLiLfQfQeeNA0t/HW/00/zsoAb6M=;
        b=IgWw4affR3/yGQr8rExC01oqZROW9QnegTrjeTVs7unzlA/ATjOHGgUtAVEUu1wIB0
         JbSOZwBJaYa8wsJ82iwX7iokhPi3fdVEIG9gJlE7RSiT0peexvlspqVk3nK46U2tqcOh
         xlKqAX/iJs6lsYXdY5a4/fOahNXrTL2ZeW+UIKnQc9fani7ItXy8RytGfNEvJrivL7WD
         WqUnur2oSypaX7emwTmIvVoA0SiAPa+/3X4CkPBQLlP0vtFPgT4H2heTSTk+ScUgxHXh
         dmVokXpk58m7pWzRwW5mlpOHi53aV1QtRaC+JQp7I2JucY0ST7A8MJuZL9lJrBneFM9F
         YVGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ie+CvfEsAvuDAFXyLiLfQfQeeNA0t/HW/00/zsoAb6M=;
        b=k1/GVDTLMTMtKVhvwdOsnxb+BBzujIV0yZTWL1LWgi6bhx0jRGb9Yn3v/JXZhkzS5g
         7FGq7VYEijXww4q/q7HXR1WdNfQPMTa1OFWUqg/FIkDUfIjPJZ4O75fNucEALBHW1cKL
         dVhJ7uf1ff7u0VOqxQYe5/qT0ON1M3+BKrk94wHRMC33Uu+mF6MqbqN77ukBgN69uoiL
         2TjTYDMEXsjq2rKFIui+FaKm8RoV1ltaTqbSQjBccrVtRYhmiF977UwZUbh7vQfpF+tq
         drEjAUUTpeGZdXALI5Kaot8yV4lkwpiN6OtXSI/AwPqB2HW4qTMl3KJVedDOzO0dPKna
         Z6cQ==
X-Gm-Message-State: APjAAAW833rev4m+KsBBOaNOeSb/EN+FqAAEPt7I9HKdWsv3qIUw9p9O
        SDhB0nSI+aXR6pwdy+Uu6hIqgbuw
X-Google-Smtp-Source: APXvYqw4ekHgz9yhbRAiJBfMuzDQhK8ZTopLy7ipJueNMVhcs5m+MAGaiQ6jnaisEIM0jjDeIC1xBw==
X-Received: by 2002:a7b:c549:: with SMTP id j9mr4510746wmk.114.1559072141590;
        Tue, 28 May 2019 12:35:41 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:fcc3:3d8b:511a:9137? (p200300EA8BF3BD00FCC33D8B511A9137.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:fcc3:3d8b:511a:9137])
        by smtp.googlemail.com with ESMTPSA id n10sm16211197wrr.11.2019.05.28.12.35.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 12:35:41 -0700 (PDT)
Subject: Re: [PATCH V2] net: phy: tja11xx: Add IRQ support to the driver
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
References: <20190528192324.28862-1-marex@denx.de>
 <96793717-a55c-7844-f7c0-cc357c774a19@gmail.com>
 <4f33b529-6c3c-07ee-6177-2d332de514c6@denx.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <cc8db234-4534-674d-eece-5a797a530cdf@gmail.com>
Date:   Tue, 28 May 2019 21:35:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <4f33b529-6c3c-07ee-6177-2d332de514c6@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.05.2019 21:31, Marek Vasut wrote:
> On 5/28/19 9:28 PM, Heiner Kallweit wrote:
>> On 28.05.2019 21:23, Marek Vasut wrote:
>>> Add support for handling the TJA11xx PHY IRQ signal.
>>>
>>> Signed-off-by: Marek Vasut <marex@denx.de>
>>> Cc: Andrew Lunn <andrew@lunn.ch>
>>> Cc: Florian Fainelli <f.fainelli@gmail.com>
>>> Cc: Guenter Roeck <linux@roeck-us.net>
>>> Cc: Heiner Kallweit <hkallweit1@gmail.com>
>>> Cc: Jean Delvare <jdelvare@suse.com>
>>> Cc: linux-hwmon@vger.kernel.org
>>> ---
>>> V2: - Define each bit of the MII_INTEN register and a mask
>>>     - Drop IRQ acking from tja11xx_config_intr()
>>> ---
>>>  drivers/net/phy/nxp-tja11xx.c | 48 +++++++++++++++++++++++++++++++++++
>>>  1 file changed, 48 insertions(+)
>>>
>>> diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
>>> index b705d0bd798b..b41af609607d 100644
>>> --- a/drivers/net/phy/nxp-tja11xx.c
>>> +++ b/drivers/net/phy/nxp-tja11xx.c
>>> @@ -40,6 +40,29 @@
>>>  #define MII_INTSRC_TEMP_ERR		BIT(1)
>>>  #define MII_INTSRC_UV_ERR		BIT(3)
>>>  
>>> +#define MII_INTEN			22
>>> +#define MII_INTEN_PWON_EN		BIT(15)
>>> +#define MII_INTEN_WAKEUP_EN		BIT(14)
>>> +#define MII_INTEN_PHY_INIT_FAIL_EN	BIT(11)
>>> +#define MII_INTEN_LINK_STATUS_FAIL_EN	BIT(10)
>>> +#define MII_INTEN_LINK_STATUS_UP_EN	BIT(9)
>>> +#define MII_INTEN_SYM_ERR_EN		BIT(8)
>>> +#define MII_INTEN_TRAINING_FAILED_EN	BIT(7)
>>> +#define MII_INTEN_SQI_WARNING_EN	BIT(6)
>>> +#define MII_INTEN_CONTROL_ERR_EN	BIT(5)
>>> +#define MII_INTEN_UV_ERR_EN		BIT(3)
>>> +#define MII_INTEN_UV_RECOVERY_EN	BIT(2)
>>> +#define MII_INTEN_TEMP_ERR_EN		BIT(1)
>>> +#define MII_INTEN_SLEEP_ABORT_EN	BIT(0)
>>> +#define MII_INTEN_MASK							\
>>> +	(MII_INTEN_PWON_EN | MII_INTEN_WAKEUP_EN |			\
>>> +	MII_INTEN_PHY_INIT_FAIL_EN | MII_INTEN_LINK_STATUS_FAIL_EN |	\
>>> +	MII_INTEN_LINK_STATUS_UP_EN | MII_INTEN_SYM_ERR_EN |		\
>>> +	MII_INTEN_TRAINING_FAILED_EN | MII_INTEN_SQI_WARNING_EN |	\
>>> +	MII_INTEN_CONTROL_ERR_EN | MII_INTEN_UV_ERR_EN |		\
>>> +	MII_INTEN_UV_RECOVERY_EN | MII_INTEN_TEMP_ERR_EN |		\
>>> +	MII_INTEN_SLEEP_ABORT_EN)
>>
>> Why do you enable all these interrupt sources? As I said, phylib needs
>> link change info only.
> 
> Because I need them to reliably detect that the link state changed.
> 

Hmm, e.g. this one MII_INTEN_TEMP_ERR_EN doesn't seem to be related
to a link status change. Name sounds like it just reports exceeding
a temperature threshold.

>>> +
>>>  #define MII_COMMSTAT			23
>>>  #define MII_COMMSTAT_LINK_UP		BIT(15)
>>>  
>>> @@ -239,6 +262,25 @@ static int tja11xx_read_status(struct phy_device *phydev)
>>>  	return 0;
>>>  }
>>>  
>>> +static int tja11xx_config_intr(struct phy_device *phydev)
>>> +{
>>> +	int ret;
>>> +
>>> +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
>>> +		ret = phy_write(phydev, MII_INTEN, MII_INTEN_MASK);
>>> +	else
>>> +		ret = phy_write(phydev, MII_INTEN, 0);
>>> +
>>> +	return ret < 0 ? ret : 0;
>>
>> phy_write returns only 0 or negative errno. You don't need
>> variable ret.
> 
> OK
> 

