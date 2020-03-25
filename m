Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED6B192C3F
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgCYPYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:24:10 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33557 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgCYPYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:24:09 -0400
Received: by mail-wm1-f65.google.com with SMTP id w25so2383185wmi.0;
        Wed, 25 Mar 2020 08:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZMzufbtndIxfQmBLHm23V9WfnXjvY8mO2yqPIZB5gDU=;
        b=BWx3uxsIk3pmb2jYX66+b2iKsIcsASs+LIcGSs6TBhRMhO4d47dl5rADijn3UGRvhG
         8SbW3uZcnKsVSII2ZWj3H0gpUbkVkXH5erKpe37NtGfwZgfStOHNHEfhnGACSkzQgyEz
         +B0zcyCDoE2S2hxXdvLrgOFeE5LRidNP56uniTd4uImISpjt/58IUPOpu/uh6ENksJQg
         Tl0ndJnxVQbDI4e1ab/e0zr7Y5Bx/dnfRn2UXDSjAbFh3DI1nmLWOsMA4t+ulkynzqRK
         JR5qnSmRrbE+4C++d7xOu4FP/98FEZ3n24yXMUfIQFf+bL407buCybsBVsB33auHrnMn
         jiHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZMzufbtndIxfQmBLHm23V9WfnXjvY8mO2yqPIZB5gDU=;
        b=q3e7scXMd05fIngk1zLlrX1u5BJ4yJBrnLfZkAhOvdMsGcBelohGZuv/UGp+BhKwy4
         ENcCIXQ1ZSm+vo114BWA7OIR7WyOolK85q4+Udy2555H8s62QSKfCSdFp+eHLzIZStTm
         dF3M73MnotW0XInKVvWH57T+6HugUnGdeqkC2sEMX0g3+Svus31XkWsxyW/dKvKwUJv5
         fNFcT/ZADaeYZLF3awsefIqiKAHIvhpuvdAVM71i9HjMHXxaxrsKOSbSo1mC4n/wC+0N
         iK1y+vOEB1j3CPPRpOvFRY3/t6gH1VNyiwJKeDLoXdCOJ9/tvdRspUb1jeP6ajLH50+W
         +fKA==
X-Gm-Message-State: ANhLgQ1BbprszxZjM/uomUZFfryR7UZWAPMwRiVI55+ioxs5w2v0zIBs
        PC7PLn2j62P+9udQjilCf24=
X-Google-Smtp-Source: ADFU+vsWlzfyvxWYK0fqQ9xx/KR19mVEHdF1RmHNZrFAbD14EJSxOKx23xH5kcAD+ENM2oOknweSgw==
X-Received: by 2002:a1c:4d7:: with SMTP id 206mr3847830wme.5.1585149847168;
        Wed, 25 Mar 2020 08:24:07 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:f4a0:1b38:2faf:56e9? (p200300EA8F296000F4A01B382FAF56E9.dip0.t-ipconnect.de. [2003:ea:8f29:6000:f4a0:1b38:2faf:56e9])
        by smtp.googlemail.com with ESMTPSA id o16sm35397700wrs.44.2020.03.25.08.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 08:24:06 -0700 (PDT)
Subject: Re: [PATCH 1/2] net: phy: micrel.c: add rgmii interface delay
 possibility to ksz9131
To:     Philippe Schenker <philippe.schenker@toradex.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, shawnguo@kernel.org,
        mark.rutland@arm.com
Cc:     o.rempel@pengutronix.de, linux-kernel@vger.kernel.org,
        silvan.murer@gmail.com, s.hauer@pengutronix.de,
        a.fatoum@pengutronix.de, "David S. Miller" <davem@davemloft.net>
References: <20200325150329.228329-1-philippe.schenker@toradex.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d1067087-2cb8-f7c7-7929-2c4c9d2a4cb3@gmail.com>
Date:   Wed, 25 Mar 2020 16:24:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200325150329.228329-1-philippe.schenker@toradex.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.03.2020 16:03, Philippe Schenker wrote:
> The KSZ9131 provides DLL controlled delays on RXC and TXC lines. This
> patch makes use of those delays. The information which delays should
> be enabled or disabled comes from the interface names, documented in
> ethernet-controller.yaml:
> 
> rgmii:      Disable RXC and TXC delays
> rgmii-id:   Enable RXC and TXC delays
> rgmii-txid: Enable only TXC delay, disable RXC delay
> rgmii-rxid: Enable onlx RXC delay, disable TXC delay
> 
> Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>
> ---
> 
>  drivers/net/phy/micrel.c | 45 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 63dedec0433d..d3ad09774847 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -704,6 +704,48 @@ static int ksz9131_of_load_skew_values(struct phy_device *phydev,
>  	return phy_write_mmd(phydev, 2, reg, newval);
>  }
>  
> +/* MMD Address 0x2 */
> +#define KSZ9131RN_RXC_DLL_CTRL		76
> +#define KSZ9131RN_TXC_DLL_CTRL		77
> +#define KSZ9131RN_DLL_CTRL_BYPASS	BIT_MASK(12)
> +#define KSZ9131RN_DLL_ENABLE_DELAY	0
> +#define KSZ9131RN_DLL_DISABLE_DELAY	BIT(12)
> +
> +static int ksz9131_config_rgmii_delay(struct phy_device *phydev)
> +{
> +	int ret;
> +	u16 rxcdll_val, txcdll_val;
> +

Reverse xmas tree order please.

> +	switch (phydev->interface) {
> +	case PHY_INTERFACE_MODE_RGMII:
> +		rxcdll_val = KSZ9131RN_DLL_DISABLE_DELAY;
> +		txcdll_val = KSZ9131RN_DLL_DISABLE_DELAY;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +		rxcdll_val = KSZ9131RN_DLL_ENABLE_DELAY;
> +		txcdll_val = KSZ9131RN_DLL_ENABLE_DELAY;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +		rxcdll_val = KSZ9131RN_DLL_ENABLE_DELAY;
> +		txcdll_val = KSZ9131RN_DLL_DISABLE_DELAY;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +		rxcdll_val = KSZ9131RN_DLL_DISABLE_DELAY;
> +		txcdll_val = KSZ9131RN_DLL_ENABLE_DELAY;
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	ret = phy_modify_mmd_changed(phydev, 2, KSZ9131RN_RXC_DLL_CTRL,
> +				     KSZ9131RN_DLL_CTRL_BYPASS, rxcdll_val);
> +	if (ret < 0)
> +		return ret;
> +
> +	return phy_modify_mmd_changed(phydev, 2, KSZ9131RN_TXC_DLL_CTRL,
> +				     KSZ9131RN_DLL_CTRL_BYPASS, txcdll_val);

phy_modify_mmd_changed() returns 1 if the register value was changed,
and that's not what you want here. Simply use phy_modify_mmd() in both
occurrences. And your function has a return value, but it's not used by
the caller.

> +}
> +
>  static int ksz9131_config_init(struct phy_device *phydev)
>  {
>  	const struct device *dev = &phydev->mdio.dev;
> @@ -730,6 +772,9 @@ static int ksz9131_config_init(struct phy_device *phydev)
>  	if (!of_node)
>  		return 0;
>  
> +	if (phy_interface_is_rgmii(phydev))
> +		ksz9131_config_rgmii_delay(phydev);
> +
>  	ret = ksz9131_of_load_skew_values(phydev, of_node,
>  					  MII_KSZ9031RN_CLK_PAD_SKEW, 5,
>  					  clk_skews, 2);
> 

