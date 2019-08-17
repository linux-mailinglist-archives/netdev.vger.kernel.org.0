Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD4BF90FFA
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 12:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbfHQK2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 06:28:34 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37046 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbfHQK2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 06:28:34 -0400
Received: by mail-wm1-f65.google.com with SMTP id z23so6021059wmf.2
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 03:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OFTu4dNHPCWGqkF2+IGESK+lqJtRG6YJaLJ0oTLY9QA=;
        b=DIHlndiECbnYS1YXBGJdCw+NNCyHG/GfozNfa62/WjJACuOX5n/wUpov5XAs2OOLDc
         +ww+EDbmVTKxOcanzGoAEZ1/KcD7wdR77gAxjZRMRiS6JGtQuMfm8BqfOuXPEYIJ68ts
         xkjF4FFJYttutHQXWipkktOFaHa0DMKxN4lRlW7qrNO+w7yHHl45D6xBhafp95pyUIS0
         MD2DxV57K/Uxp2hAeEM5VqadUW22lR6Nr09xIgM8WzxMvNcrc0DAQet9rZ7SbmbmnotF
         gJiKW6UkB7GE86I77oHTeuEqnIAwW5jnpCy7cmbQRAUBXGK/ZQRmErMHnYyMcdJfwlWR
         oaWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OFTu4dNHPCWGqkF2+IGESK+lqJtRG6YJaLJ0oTLY9QA=;
        b=af0igm0Kvt6FBH9R0mer73oysVXz2yi9AutZDVc9OVlGonBSy5TH0lLl4Xff4+6ikG
         c53Dhz+eDGns2MLiLVWjShPa8TBMAPR8PFefj0fP8aRYSkDbDz3HtfgHYfCC8vllrGV9
         OHQJ68qzwTTFCn9FVtx4uWCscZQo7oHatLQwx43qh2tRy16ff1H1MF9zfBPmVXiesizx
         Wyz2RhQkZjrlVvRT+sXhgJeCCjpxQpy+95uyxtHJMDA35FTE/9oCKhcjrfmEME4nl67P
         CvZ7yA0OEmzztNevtB7TMZRj8W0ouPWD8yCr4+5rYeUXhYsGQgKOSBzB+U2IYJ6ywD4N
         nF0A==
X-Gm-Message-State: APjAAAUAUAwofFsd4fRWelHRhbiy22LBd254C5enjgO5ZlP0c1/36okK
        Tm3dlu2gXrxXTYvcjceKrr4=
X-Google-Smtp-Source: APXvYqxK7OuTqcMVaNIFg0Iw6hzxpcWv258PeHroh3x0eLh3tkb7RCFYCr0P5++bsRoGlUdembLrqQ==
X-Received: by 2002:a7b:ce1a:: with SMTP id m26mr11392723wmc.60.1566037712315;
        Sat, 17 Aug 2019 03:28:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f47:db00:ec01:10b1:c9a3:2488? ([2003:ea:8f47:db00:ec01:10b1:c9a3:2488])
        by smtp.googlemail.com with ESMTPSA id f17sm5547279wmf.27.2019.08.17.03.28.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 03:28:31 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/3] net: phy: remove calls to
 genphy_config_init
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        Kevin Hilman <khilman@baylibre.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
References: <62de47ba-0624-28c0-56a1-e2fc39a36061@gmail.com>
 <cf0de135-516c-c3e4-6fc7-bf4dbef6462d@gmail.com>
 <cc12c859-2572-02f9-3303-6a8bffad0a96@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <b2b3c2a0-6bc5-c59e-2dd6-cd6bbaa3b3f7@gmail.com>
Date:   Sat, 17 Aug 2019 12:25:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <cc12c859-2572-02f9-3303-6a8bffad0a96@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.08.2019 23:58, Florian Fainelli wrote:
> On 8/16/19 1:31 PM, Heiner Kallweit wrote:
>> Supported PHY features are either auto-detected or explicitly set.
>> In both cases calling genphy_config_init isn't needed. All that
>> genphy_config_init does is removing features that are set as
>> supported but can't be auto-detected. Basically it duplicates the
>> code in genphy_read_abilities. Therefore remove such calls from
>> all PHY drivers.
>>
>> v2:
>> - remove call also from new adin PHY driver
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> Looks good, just one question below:
> 
>> +static int dummy_config_init(struct phy_device *phydev)
>> +{
>> +	return 0;
>> +}
>> +
>>  static struct mdio_device_id __maybe_unused dp83848_tbl[] = {
>>  	{ TI_DP83848C_PHY_ID, 0xfffffff0 },
>>  	{ NS_DP83848C_PHY_ID, 0xfffffff0 },
>> @@ -113,13 +113,13 @@ MODULE_DEVICE_TABLE(mdio, dp83848_tbl);
>>  
>>  static struct phy_driver dp83848_driver[] = {
>>  	DP83848_PHY_DRIVER(TI_DP83848C_PHY_ID, "TI DP83848C 10/100 Mbps PHY",
>> -			   genphy_config_init),
>> +			   dummy_config_init),
>>  	DP83848_PHY_DRIVER(NS_DP83848C_PHY_ID, "NS DP83848C 10/100 Mbps PHY",
>> -			   genphy_config_init),
>> +			   dummy_config_init),
>>  	DP83848_PHY_DRIVER(TI_DP83620_PHY_ID, "TI DP83620 10/100 Mbps PHY",
>>  			   dp83848_config_init),
>>  	DP83848_PHY_DRIVER(TLK10X_PHY_ID, "TI TLK10X 10/100 Mbps PHY",
>> -			   genphy_config_init),
>> +			   dummy_config_init),
> 
> drv->config_init is an optional callback so you could just either pass
> NULL as an argument to the macro, or simply remove that parameter?
> 
Yes, this can be simplified. Let's pass NULL. Thanks!
