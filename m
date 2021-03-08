Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32EF331631
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 19:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhCHSeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 13:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbhCHSeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 13:34:13 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F94C06174A;
        Mon,  8 Mar 2021 10:34:13 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id u187so103332wmg.4;
        Mon, 08 Mar 2021 10:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rsbh2VyaG0gxQFku78W7wv/Ifk3wzTsrpxU99pOPI7Q=;
        b=eLjoiXzvFYUlydEr1mL26NjQricM7ajy6V35HgnQ7PZlN97cXeF/ejHmHTYjYVA9uf
         /VG4YdtkAWA4vvVS9AGa50n3ubpKCFXIs+dHyUYlJ/fjfETDBqQxujlAXiIcoKQkSvpG
         17naGcrc4jSRBdoqgZDFd+gwGO6pz8vU7iaXjibekNLUdVabvht31VI0RgwI2+bKomKF
         O9jvEvc5E1oHdz/LUAyoLSsadCwSBUlcYpWJgRCU53mgDmYs+/hQGsdOqjALNu7wlvt1
         zTzrb1pzmxcdfAZt2V9TC1uCk0WDxokkEHms8u66FSNToN4F5E8M2keGNMEv7Oh6Wdc9
         xmvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rsbh2VyaG0gxQFku78W7wv/Ifk3wzTsrpxU99pOPI7Q=;
        b=PUhV9RP+1qfvekeLQKtPyd8v8/w+b/LZVDjYX1YalF5fk7qatrU1INiYJRcEjBYIDs
         0OmlVheKZQ7OZT6XV0UvuyZ6Hxw9HAYmy0Rpk5O2gvDWwGStYd1DJ3ejHYbi4jNfyr5l
         Q/CbhezSldB80R0w3sruXnlOxFfAiudIu++y7D2wWBgXUsHScP3YVTEBOdTmh19Gr/2T
         SQr7EEl3WA5hfNvTU/sf15cvLmTOMbiGPtKDkGN+eonFjGwl4LrpuXFxXHuagMgg5H87
         DADUYS9ABj728j33UiNNMf2oF4K1/zDnsi+t2I1mTI6eXyYVhFQImCFiLy0zRx6CefGz
         RhgA==
X-Gm-Message-State: AOAM532PpzEzQcx9AAyVhjv3HTL5SH9yYXK/732E9P0t2iv+Gn1kohSd
        s5DoaevQU0mjE7nd+KmZdlJ+eSUrbz9QHg==
X-Google-Smtp-Source: ABdhPJxlH58mGb6tXk/oZLsXj6O933r3iKoUYgdKuswvqDFZxbaRsEoMOoNtmZZMAQ7ZB48mqMRJjA==
X-Received: by 2002:a7b:c34a:: with SMTP id l10mr157519wmj.46.1615228451559;
        Mon, 08 Mar 2021 10:34:11 -0800 (PST)
Received: from [192.168.1.10] (224.red-2-138-103.dynamicip.rima-tde.net. [2.138.103.224])
        by smtp.gmail.com with ESMTPSA id g16sm20257057wrs.76.2021.03.08.10.34.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 10:34:11 -0800 (PST)
Subject: Re: [PATCH] net: dsa: b53: mmap: Add device tree support
To:     Florian Fainelli <f.fainelli@gmail.com>, jonas.gorski@gmail.com,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210308180715.18571-1-noltari@gmail.com>
 <06dab800-d554-e807-8a72-427c6e99e4de@gmail.com>
From:   =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>
Message-ID: <15aa76d9-9399-b41b-151a-856597046af4@gmail.com>
Date:   Mon, 8 Mar 2021 19:34:10 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <06dab800-d554-e807-8a72-427c6e99e4de@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: es-ES
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

El 08/03/2021 a las 19:29, Florian Fainelli escribió:
> On 3/8/21 10:07 AM, Álvaro Fernández Rojas wrote:
>> Add device tree support to b53_mmap.c while keeping platform devices support.
>>
>> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
>> ---
>>   drivers/net/dsa/b53/b53_mmap.c | 36 ++++++++++++++++++++++++++++++++++
>>   1 file changed, 36 insertions(+)
>>
>> diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
>> index c628d0980c0b..b897b4263930 100644
>> --- a/drivers/net/dsa/b53/b53_mmap.c
>> +++ b/drivers/net/dsa/b53/b53_mmap.c
>> @@ -228,12 +228,48 @@ static const struct b53_io_ops b53_mmap_ops = {
>>   	.write64 = b53_mmap_write64,
>>   };
>>   
>> +static int b53_mmap_probe_of(struct platform_device *pdev,
>> +			     struct b53_platform_data **ppdata)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct device_node *np = dev->of_node;
>> +	struct b53_platform_data *pdata;
>> +	void __iomem *mem;
>> +
>> +	mem = devm_platform_ioremap_resource(pdev, 0);
>> +	if (IS_ERR(mem))
>> +		return PTR_ERR(mem);
>> +
>> +	pdata = devm_kzalloc(dev, sizeof(struct b53_platform_data),
>> +			     GFP_KERNEL);
>> +	if (!pdata)
>> +		return -ENOMEM;
>> +
>> +	pdata->regs = mem;
>> +	pdata->chip_id = BCM63XX_DEVICE_ID;
>> +	pdata->big_endian = of_property_read_bool(np, "big-endian");
>> +	of_property_read_u16(np, "brcm,ports", &pdata->enabled_ports);
>> +
>> +	*ppdata = pdata;
>> +
>> +	return 0;
>> +}
>> +
>>   static int b53_mmap_probe(struct platform_device *pdev)
>>   {
>> +	struct device_node *np = pdev->dev.of_node;
>>   	struct b53_platform_data *pdata = pdev->dev.platform_data;
>>   	struct b53_mmap_priv *priv;
>>   	struct b53_device *dev;
>>   
>> +	if (np) {
>> +		int ret = b53_mmap_probe_of(pdev, &pdata);
>> +		if (ret) {
>> +			dev_err(&pdev->dev, "OF probe error\n");
>> +			return ret;
>> +		}
>> +	}
> 
> I would be keen on making this less "OF-centric" and just have it happen
> whenever pdata is NULL such that we have an easier transition path if we
> wanted to migrate bcm63xx to passing down the switch base register
> address a platform_device source in the future (not that I expect it to
> happen though).

Honestly, it's probably easier to switch to bmips instead of migrating 
bcm63xx...

> 
> Other than that, the logic looks sound.
> 

Best regards,
Álvaro.
