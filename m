Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB8A42AEE5
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 08:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbfE0Go3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 02:44:29 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41735 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbfE0Go2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 02:44:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so478138wrm.8
        for <netdev@vger.kernel.org>; Sun, 26 May 2019 23:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=31KZ5mUlT+sZE8A5BH+lWo9VXCzlKEZYnjmfcNQ04E0=;
        b=CP30FTdNiSP+2Mkm/hNcjbFxupfMZx6uo2ufF+ey3HT/ljwN1opidc8vb7/PcsjJxd
         iziwuAJUm4pHItrk/MtABD6gNEmXiFsEUsz9blDNcMDyhSzY47tYQglx2V8/T9wOoO5M
         +mmQHvilUf5huBXQQPJesmXa3VZC7Wn6pzIVocd/+CkhD1dftDyxqEoV5ABCgtEce5Hl
         ldNpEkePJ1oTshmgKUVYwUaEMAx6r8CnH2aYsQeSxLTb15fEVHJNop4rL67AXvnotviP
         rQS8qg0BlIAtUI53JeWg301zdFVIunfXOLx8/p8vqMUHB4Fihk2FAACI6chDB34v2EjZ
         qfmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=31KZ5mUlT+sZE8A5BH+lWo9VXCzlKEZYnjmfcNQ04E0=;
        b=Ed563mYtbX7vq8l5gZEqLYes/jm36agpOne9ibIn1rC1ZIL3h+ppQXuz142GNkl5x5
         VlhVG1BKMYbAeD4R7lV8Jt41c7pp0rXye2ryJxTWzfnGcotffoMk5Lna1csP1baShYGF
         xgvI+EjOGWazPdH09WezwHFk3tPsy9IKI3iwrVwMOY0q8cJSMxEto3X/dLVChGoiZ8Ys
         dufkIOybZ7lYqRnoqzekezd9iaqLX7uTDo6xFv/gJw288eFVpH7PcMF8x7Cujv7HuWLt
         Mi5Fg5JyxneV5REoXE1MZ3+/MZKw0p0F/aCzH5azPYQHm/fakyL+v40AS4xHyVC5illf
         9Q7Q==
X-Gm-Message-State: APjAAAWXy1Rcxm5DmeQ0RNxH49PvMTTcUzWyOf2QKG8XAoMxCuNXfG/c
        VjBenXlIFv2hCEwdOhj+ERnTktXN
X-Google-Smtp-Source: APXvYqy8Ge0BvtILykLztrBECXWThivLNFk4SrG+pmHkLdR6t7UUKd8I6MwAIDqW4cYytT5sj6ubZw==
X-Received: by 2002:a5d:4647:: with SMTP id j7mr38539344wrs.280.1558939467271;
        Sun, 26 May 2019 23:44:27 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:c874:5a1e:7ae5:49ce? (p200300EA8BE97A00C8745A1E7AE549CE.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:c874:5a1e:7ae5:49ce])
        by smtp.googlemail.com with ESMTPSA id v5sm20778942wra.83.2019.05.26.23.44.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 23:44:26 -0700 (PDT)
Subject: Re: [PATCH v2 1/4] net: phy: dp83867: fix speed 10 in sgmii mode
To:     Max Uvarov <muvarov@gmail.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net
References: <20190527061607.30030-1-muvarov@gmail.com>
 <20190527061607.30030-2-muvarov@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <2a351166-ae85-eb6d-4fd2-57cfea5fbea9@gmail.com>
Date:   Mon, 27 May 2019 08:39:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190527061607.30030-2-muvarov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.05.2019 08:16, Max Uvarov wrote:
> For support 10Mps sped in SGMII mode DP83867_10M_SGMII_RATE_ADAPT bit
> of DP83867_10M_SGMII_CFG register has to be cleared by software.
> That does not affect speeds 100 and 1000 so can be done on init.
> 
> Signed-off-by: Max Uvarov <muvarov@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/dp83867.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index fd35131a0c39..75861b8f3b4d 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -30,6 +30,7 @@
>  #define DP83867_STRAP_STS1	0x006E
>  #define DP83867_RGMIIDCTL	0x0086
>  #define DP83867_IO_MUX_CFG	0x0170
> +#define DP83867_10M_SGMII_CFG  0x016F
>  
>  #define DP83867_SW_RESET	BIT(15)
>  #define DP83867_SW_RESTART	BIT(14)
> @@ -74,6 +75,9 @@
>  /* CFG4 bits */
>  #define DP83867_CFG4_PORT_MIRROR_EN              BIT(0)
>  
> +/* 10M_SGMII_CFG bits */
> +#define DP83867_10M_SGMII_RATE_ADAPT		 BIT(7)
> +
>  enum {
>  	DP83867_PORT_MIRROING_KEEP,
>  	DP83867_PORT_MIRROING_EN,
> @@ -277,6 +281,22 @@ static int dp83867_config_init(struct phy_device *phydev)
>  				       DP83867_IO_MUX_CFG_IO_IMPEDANCE_CTRL);
>  	}
>  
> +	if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
> +		/* For support SPEED_10 in SGMII mode
> +		 * DP83867_10M_SGMII_RATE_ADAPT bit
> +		 * has to be cleared by software. That
> +		 * does not affect SPEED_100 and
> +		 * SPEED_1000.
> +		 */
> +		val = phy_read_mmd(phydev, DP83867_DEVADDR,
> +				   DP83867_10M_SGMII_CFG);
> +		val &= ~DP83867_10M_SGMII_RATE_ADAPT;
> +		ret = phy_write_mmd(phydev, DP83867_DEVADDR,
> +				    DP83867_10M_SGMII_CFG, val);

I think I mentioned it before: This can be simplified by using
phy_modify_mmd(). Same applies to patch 2.

> +		if (ret)
> +			return ret;
> +	}
> +
>  	/* Enable Interrupt output INT_OE in CFG3 register */
>  	if (phy_interrupt_is_valid(phydev)) {
>  		val = phy_read(phydev, DP83867_CFG3);
> 

