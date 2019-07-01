Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68CE05C162
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729464AbfGAQpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:45:19 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33385 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbfGAQpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:45:18 -0400
Received: by mail-wm1-f66.google.com with SMTP id h19so455809wme.0;
        Mon, 01 Jul 2019 09:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8Wrak9T/dqG3Cj1so+ph+ncSMKddxwdFBJ2/cQ9fA/w=;
        b=Ea4BqHthzHUPUeD7zqotXw+WJ/OTt8xMa//IS2ZjZ6YqPom1EHWnCr6JAB+w38gK8f
         sKSlXOxc7ZE6+w1q3s2VVNjkG6Xn0oX5fCqxF4FGX4qfL/l94S7dia2bOcEEr9rU6Mcr
         8k3ZwE/Jl2R7CV4sARe1N3zDeDwmNgu1EQTz7ZA73MdlrvLx0mdGZDPyIjyEY0BNGt8H
         m7Nv2fSz4hpbSV1K5n+uQWCtc3YW7w2M9UdF2O1pdZIjQ+5XbAdOGubtIYlaTxK0ckkp
         HUQkCjtbAEbBBJRzyl/tbIQ1HmVcxqmdUyJfKyVZxPB9hRaP0DjFaSzM3kBLpsERPUbS
         89Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=8Wrak9T/dqG3Cj1so+ph+ncSMKddxwdFBJ2/cQ9fA/w=;
        b=KuA0FauEKZPWIQnEA1AW25+KjvYYkCI5qDG0XD56ZtfVDJ5OvOj6z66VRgv3tuQdcO
         QLhFF1dHFZzYuPthpcQ2cNlw8pkSx4gCLaItT7oLyNe2ZkyBOClZfGdhbcNFU5W9fqcg
         F6zvMKYe0dWQFwAR2t2lj304XAYnenhBBzI1npR5/xFxeHWR0fhJW/fidJTaMpnM3ooo
         Yo7ZiA+QV10/b8Jt1ZmnLpT9mKRYgjoe34jlomAWoz6AnfC1AEnBI2hIk8KLUmg24qnb
         5IL8owfyjefYJv47oMCfrQsBtyANUJhiXsgftffs2wl6iuc2Lwr/EE9oKF+0UwTxjH4W
         Kfiw==
X-Gm-Message-State: APjAAAWXZ/v7kK8Rixh4BU7t62kDeBGuIvgJiR+xT4+i6B9tdodmnGO7
        dbWdWzc0IYAzHOK/JB1J/npfqhVs
X-Google-Smtp-Source: APXvYqwaurz4/UAR0mTocZnDtauJ2EKslJ/980SxMWg/w3dbNntT2diwvIhHRkidDfUjw2T38oWRxw==
X-Received: by 2002:a1c:e108:: with SMTP id y8mr125291wmg.65.1561999515553;
        Mon, 01 Jul 2019 09:45:15 -0700 (PDT)
Received: from [10.67.50.91] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t14sm9558475wrr.33.2019.07.01.09.45.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 09:45:15 -0700 (PDT)
Subject: Re: [PATCH 3/4] net: dsa: vsc73xx: add support for parallel mode
To:     Pawel Dembicki <paweldembicki@gmail.com>
Cc:     linus.walleij@linaro.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190701152723.624-1-paweldembicki@gmail.com>
 <20190701152723.624-3-paweldembicki@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <b7afaf2e-ca4e-2795-658d-2f0289203833@gmail.com>
Date:   Mon, 1 Jul 2019 09:45:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190701152723.624-3-paweldembicki@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/19 8:27 AM, Pawel Dembicki wrote:
> This patch add platform part of vsc73xx driver.
> It allows to use chip connected by PI interface.
> 
> Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
> ---

[snip]

> +	struct vsc73xx_platform *vsc_platform = vsc->priv;
> +	u32 offset;
> +
> +	if (!vsc73xx_is_addr_valid(block, subblock))
> +		return -EINVAL;
> +
> +	offset = vsc73xx_make_addr(block, subblock, reg);
> +
> +	mutex_lock(&vsc->lock);
> +		iowrite32be(val, vsc_platform->base_addr + offset);
> +	mutex_unlock(&vsc->lock);

Similar question from Andrew, why is the locking done in the platform
layer, should not that be done in the core I/O operation instead?

> +
> +	return 0;
> +}
> +
> +static int vsc73xx_platform_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct vsc73xx_platform *vsc_platform;
> +	struct resource *res = NULL;
> +	int ret;
> +
> +	vsc_platform = devm_kzalloc(dev, sizeof(*vsc_platform), GFP_KERNEL);
> +	if (!vsc_platform)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, vsc_platform);
> +	vsc_platform->pdev = pdev;
> +	vsc_platform->vsc.dev = dev;
> +	vsc_platform->vsc.priv = vsc_platform;
> +	vsc_platform->vsc.ops = &vsc73xx_platform_ops;
> +
> +	/* obtain I/O memory space */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "cannot obtain I/O memory space\n");
> +		ret = -ENXIO;
> +		return ret;
> +	}
> +
> +	vsc_platform->base_addr = devm_ioremap_resource(&pdev->dev, res);

devm_ioremap_resource takes care of checking that the resource pointer
is valid, no need to do that here.

> +	if (!vsc_platform->base_addr) {

if (IS_ERR(vsc_platform->base_addr))
-- 
Florian
