Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51C332AEE6
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 08:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfE0Gob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 02:44:31 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36069 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbfE0Goa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 02:44:30 -0400
Received: by mail-wr1-f65.google.com with SMTP id s17so15705266wru.3
        for <netdev@vger.kernel.org>; Sun, 26 May 2019 23:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1RPwY7Il95WAG22/afH0eUgTf/2uqyGeXJxJxo90M2Y=;
        b=YaDsolWn5q/BexiZMkTD3IE+XgZ0eMN9KZlNSQrpKNltunl/A6uPGGyDHmtBjdrjIS
         8mkLp8gazarRHfnnqmp1nTqo31+vveEDVQL8x7an5+qY/y1WnL5fu+EN/tiJkAiQYy5P
         Y31Jic3VRiF68JBO4FEhYzA/efbY1js7QQON0GUXER1f9YapCzeQRGH3Lqxu8+SxtAau
         H5JxSLoUDXLaIRf0uZ9E33hyw+0t+N/2eKctxbkioc3GHmHnzrK7LLvjZjSxN87oEkFV
         xehLgyvRiwpMcFdr+upX97NdCqiaASGstYBFYjgPXHSee7jhN4PfUnbSJKlfx/3SGDjE
         ZRaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1RPwY7Il95WAG22/afH0eUgTf/2uqyGeXJxJxo90M2Y=;
        b=VDKVM2116ZorpqmM36yyJknEiY/16Dwo+mj45lpi8WvXZ9HB+zxHueO9UVi3Wz7ngp
         WMMlSYX2hn2KZHJkIfM4/b1/YDAwrra0MFrNWyDaDb/oc70BN5aPzHdlPFvwKXGdINwD
         lCPjVmm4xahRPOSeROKLWsPthb2tDGO+/UV+ii4g815u//9um1idc/MLGu6by2ztiwoX
         e+t1BQSxc4y9+0XGxcKVhUOZQcpk/YimLHvnSi+KjIx1a90jkULwXokM++2tqslwmcVn
         0ZOnvxoUEVzwTjOmmR+gWe0D/2LNyOiWcCm7wwKwvT+SPAXKBUOfK1BHzVUjpy1BJo2c
         i43Q==
X-Gm-Message-State: APjAAAXrI5pxKihvAPDvrl/cLQWYeFtdGaflQK/zSiU6ldGxiY7UKPVo
        SqaU0DOYb79Wi5LtK1qabD8=
X-Google-Smtp-Source: APXvYqwwIQu5bO0rs5mHa94Mw5r7kd82meAkLGR5NNgV+lWXHb9RBfi+GxZBAI5yqciz7N/wQ2N24Q==
X-Received: by 2002:a5d:5590:: with SMTP id i16mr21142242wrv.307.1558939468677;
        Sun, 26 May 2019 23:44:28 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:c874:5a1e:7ae5:49ce? (p200300EA8BE97A00C8745A1E7AE549CE.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:c874:5a1e:7ae5:49ce])
        by smtp.googlemail.com with ESMTPSA id s9sm3087733wmc.1.2019.05.26.23.44.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 23:44:28 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] net: phy: dp83867: increase SGMII autoneg timer
 duration
To:     Max Uvarov <muvarov@gmail.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net
References: <20190527061607.30030-1-muvarov@gmail.com>
 <20190527061607.30030-3-muvarov@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7da7b818-9006-6208-4d1c-23623a735fb0@gmail.com>
Date:   Mon, 27 May 2019 08:44:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190527061607.30030-3-muvarov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.05.2019 08:16, Max Uvarov wrote:
> After reset SGMII Autoneg timer is set to 2us (bits 6 and 5 are 01).
> That us not enough to finalize autonegatiation on some devices.
> Increase this timer duration to maximum supported 16ms.
> 
> Signed-off-by: Max Uvarov <muvarov@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/dp83867.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index 75861b8f3b4d..5fafcc091525 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -295,6 +295,16 @@ static int dp83867_config_init(struct phy_device *phydev)
>  				    DP83867_10M_SGMII_CFG, val);
>  		if (ret)
>  			return ret;
> +
> +		/* After reset SGMII Autoneg timer is set to 2us (bits 6 and 5
> +		 * are 01). That us not enough to finalize autoneg on some
> +		 * devices. Increase this timer duration to maximum 16ms.
> +		 */
> +		val = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4);
> +		val &= ~(BIT(5) | BIT(6));

Using bit numbers directly isn't nice. Better define a mask and constants for
the different combinations of bit 5 and 6 like:
#define FOO_SGMII_ANEG_TIMER_MASK 0x60
#define FOO_SGMII_ANEG_TIMER_2US 0x20
#define FOO_SGMII_ANEG_TIMER_16MS 0x60
And then use the constants in phy_modify_mmd().

> +		ret = phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4, val);
> +		if (ret)
> +			return ret;
>  	}
>  
>  	/* Enable Interrupt output INT_OE in CFG3 register */
> 

