Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57DB2EA7C1
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 00:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbfJ3X2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 19:28:09 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41999 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbfJ3X2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 19:28:09 -0400
Received: by mail-ed1-f67.google.com with SMTP id s20so3248582edq.9;
        Wed, 30 Oct 2019 16:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BlYopNUsFRAdjg3wcJutkL1mfyGctHwyIsU+buix7WU=;
        b=JFKNgr2nq9eu+YsIbwv+pAHs7QcJvHjXXeYaTnBwVHCAfItuJW2aPC9z7lWnDyiLnp
         Kei+HL4EMOqeT74FsqttZl8EvMxfvxOscmc++wa8R9ba+DLYlatQZuWPDiKDvEq/Stxo
         L8wflxVh/QFjmsdX9gzqkNKxrNjPjRMsUPcSDbo5tUEHVRM38zPL5lCr/rAz4zdeYamC
         L4IIPR2Mq/5igaF73apUtO6Qntr0JZhyjMJllIbPaAdxyYW8luZpj6ojvALYtmS13tOF
         aly5cAX6OvOgc/44lZ9h2Oe4Ex/YI/6yXT8ukmgvvbmBp9eILvD9P4JDuDmL500kZEW9
         keAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=BlYopNUsFRAdjg3wcJutkL1mfyGctHwyIsU+buix7WU=;
        b=kCvyjMs7lxOz4qjfqDBa4A0ngZTDdzgBx+cUzTRbKa4xYq3yv2Np7ijCwFuAXNb1OD
         dxlwpSfcu8JS5Pr4ifoMuHM4nCythqijak3G/ziEP++fp4XKFWCzO1/35FNJPT3amnAR
         bVZPCfcc6pNwIK+VEJva5Eq3fLHd3HBU0mx6pMTSXMjlrxkL4Iv3FT1eexkDfEB0uUN5
         Sv/Lbuh42XgGYdmpbodoGUpqRkroYajYCkLWeGbaE1spZKVtbmEgxxtulI2HJ3Ds48rR
         24A16EjPyl3/FgtXkL5WHOyHUqZAlEfuJNQrfbk8/HqPqBwYtYmddvpcyVM9zdgn1B3D
         PO2A==
X-Gm-Message-State: APjAAAXC4yfDHomG8E7GflFZuGwR0EKFzbaIzYjR+gmSKtAjPQZcfrlI
        CFB5MZ/9qGGesubVjeBlZyg=
X-Google-Smtp-Source: APXvYqxtaWVvDN1AsxoMXbQY2mMWBT1mimfks9Dl7WAzAV38XtY4C59dwKRgYFrM2ekYW2yg9RpM8w==
X-Received: by 2002:a17:906:7212:: with SMTP id m18mr870652ejk.88.1572478086201;
        Wed, 30 Oct 2019 16:28:06 -0700 (PDT)
Received: from [10.67.50.53] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o26sm30879edt.55.2019.10.30.16.28.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 16:28:05 -0700 (PDT)
Subject: Re: [RFC PATCH 3/3] net: phy: at803x: add device tree binding
To:     Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20191030224251.21578-1-michael@walle.cc>
 <20191030224251.21578-4-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 mQGiBEjPuBIRBACW9MxSJU9fvEOCTnRNqG/13rAGsj+vJqontvoDSNxRgmafP8d3nesnqPyR
 xGlkaOSDuu09rxuW+69Y2f1TzjFuGpBk4ysWOR85O2Nx8AJ6fYGCoeTbovrNlGT1M9obSFGQ
 X3IzRnWoqlfudjTO5TKoqkbOgpYqIo5n1QbEjCCwCwCg3DOH/4ug2AUUlcIT9/l3pGvoRJ0E
 AICDzi3l7pmC5IWn2n1mvP5247urtHFs/uusE827DDj3K8Upn2vYiOFMBhGsxAk6YKV6IP0d
 ZdWX6fqkJJlu9cSDvWtO1hXeHIfQIE/xcqvlRH783KrihLcsmnBqOiS6rJDO2x1eAgC8meAX
 SAgsrBhcgGl2Rl5gh/jkeA5ykwbxA/9u1eEuL70Qzt5APJmqVXR+kWvrqdBVPoUNy/tQ8mYc
 nzJJ63ng3tHhnwHXZOu8hL4nqwlYHRa9eeglXYhBqja4ZvIvCEqSmEukfivk+DlIgVoOAJbh
 qIWgvr3SIEuR6ayY3f5j0f2ejUMYlYYnKdiHXFlF9uXm1ELrb0YX4GMHz7QnRmxvcmlhbiBG
 YWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+iGYEExECACYCGyMGCwkIBwMCBBUCCAME
 FgIDAQIeAQIXgAUCVF/S8QUJHlwd3wAKCRBhV5kVtWN2DvCVAJ4u4/bPF4P3jxb4qEY8I2gS
 6hG0gACffNWlqJ2T4wSSn+3o7CCZNd7SLSC5BA0ESM+4EhAQAL/o09boR9D3Vk1Tt7+gpYr3
 WQ6hgYVON905q2ndEoA2J0dQxJNRw3snabHDDzQBAcqOvdi7YidfBVdKi0wxHhSuRBfuOppu
 pdXkb7zxuPQuSveCLqqZWRQ+Cc2QgF7SBqgznbe6Ngout5qXY5Dcagk9LqFNGhJQzUGHAsIs
 hap1f0B1PoUyUNeEInV98D8Xd/edM3mhO9nRpUXRK9Bvt4iEZUXGuVtZLT52nK6Wv2EZ1TiT
 OiqZlf1P+vxYLBx9eKmabPdm3yjalhY8yr1S1vL0gSA/C6W1o/TowdieF1rWN/MYHlkpyj9c
 Rpc281gAO0AP3V1G00YzBEdYyi0gaJbCEQnq8Vz1vDXFxHzyhgGz7umBsVKmYwZgA8DrrB0M
 oaP35wuGR3RJcaG30AnJpEDkBYHznI2apxdcuTPOHZyEilIRrBGzDwGtAhldzlBoBwE3Z3MY
 31TOpACu1ZpNOMysZ6xiE35pWkwc0KYm4hJA5GFfmWSN6DniimW3pmdDIiw4Ifcx8b3mFrRO
 BbDIW13E51j9RjbO/nAaK9ndZ5LRO1B/8Fwat7bLzmsCiEXOJY7NNpIEpkoNoEUfCcZwmLrU
 +eOTPzaF6drw6ayewEi5yzPg3TAT6FV3oBsNg3xlwU0gPK3v6gYPX5w9+ovPZ1/qqNfOrbsE
 FRuiSVsZQ5s3AAMFD/9XjlnnVDh9GX/r/6hjmr4U9tEsM+VQXaVXqZuHKaSmojOLUCP/YVQo
 7IiYaNssCS4FCPe4yrL4FJJfJAsbeyDykMN7wAnBcOkbZ9BPJPNCbqU6dowLOiy8AuTYQ48m
 vIyQ4Ijnb6GTrtxIUDQeOBNuQC/gyyx3nbL/lVlHbxr4tb6YkhkO6shjXhQh7nQb33FjGO4P
 WU11Nr9i/qoV8QCo12MQEo244RRA6VMud06y/E449rWZFSTwGqb0FS0seTcYNvxt8PB2izX+
 HZA8SL54j479ubxhfuoTu5nXdtFYFj5Lj5x34LKPx7MpgAmj0H7SDhpFWF2FzcC1bjiW9mjW
 HaKaX23Awt97AqQZXegbfkJwX2Y53ufq8Np3e1542lh3/mpiGSilCsaTahEGrHK+lIusl6mz
 Joil+u3k01ofvJMK0ZdzGUZ/aPMZ16LofjFA+MNxWrZFrkYmiGdv+LG45zSlZyIvzSiG2lKy
 kuVag+IijCIom78P9jRtB1q1Q5lwZp2TLAJlz92DmFwBg1hyFzwDADjZ2nrDxKUiybXIgZp9
 aU2d++ptEGCVJOfEW4qpWCCLPbOT7XBr+g/4H3qWbs3j/cDDq7LuVYIe+wchy/iXEJaQVeTC
 y5arMQorqTFWlEOgRA8OP47L9knl9i4xuR0euV6DChDrguup2aJVU4hPBBgRAgAPAhsMBQJU
 X9LxBQkeXB3fAAoJEGFXmRW1Y3YOj4UAn3nrFLPZekMeqX5aD/aq/dsbXSfyAKC45Go0YyxV
 HGuUuzv+GKZ6nsysJ7kCDQRXG8fwARAA6q/pqBi5PjHcOAUgk2/2LR5LjjesK50bCaD4JuNc
 YDhFR7Vs108diBtsho3w8WRd9viOqDrhLJTroVckkk74OY8r+3t1E0Dd4wHWHQZsAeUvOwDM
 PQMqTUBFuMi6ydzTZpFA2wBR9x6ofl8Ax+zaGBcFrRlQnhsuXLnM1uuvS39+pmzIjasZBP2H
 UPk5ifigXcpelKmj6iskP3c8QN6x6GjUSmYx+xUfs/GNVSU1XOZn61wgPDbgINJd/THGdqiO
 iJxCLuTMqlSsmh1+E1dSdfYkCb93R/0ZHvMKWlAx7MnaFgBfsG8FqNtZu3PCLfizyVYYjXbV
 WO1A23riZKqwrSJAATo5iTS65BuYxrFsFNPrf7TitM8E76BEBZk0OZBvZxMuOs6Z1qI8YKVK
 UrHVGFq3NbuPWCdRul9SX3VfOunr9Gv0GABnJ0ET+K7nspax0xqq7zgnM71QEaiaH17IFYGS
 sG34V7Wo3vyQzsk7qLf9Ajno0DhJ+VX43g8+AjxOMNVrGCt9RNXSBVpyv2AMTlWCdJ5KI6V4
 KEzWM4HJm7QlNKE6RPoBxJVbSQLPd9St3h7mxLcne4l7NK9eNgNnneT7QZL8fL//s9K8Ns1W
 t60uQNYvbhKDG7+/yLcmJgjF74XkGvxCmTA1rW2bsUriM533nG9gAOUFQjURkwI8jvMAEQEA
 AYkCaAQYEQIACQUCVxvH8AIbAgIpCRBhV5kVtWN2DsFdIAQZAQIABgUCVxvH8AAKCRCH0Jac
 RAcHBIkHD/9nmfog7X2ZXMzL9ktT++7x+W/QBrSTCTmq8PK+69+INN1ZDOrY8uz6htfTLV9+
 e2W6G8/7zIvODuHk7r+yQ585XbplgP0V5Xc8iBHdBgXbqnY5zBrcH+Q/oQ2STalEvaGHqNoD
 UGyLQ/fiKoLZTPMur57Fy1c9rTuKiSdMgnT0FPfWVDfpR2Ds0gpqWePlRuRGOoCln5GnREA/
 2MW2rWf+CO9kbIR+66j8b4RUJqIK3dWn9xbENh/aqxfonGTCZQ2zC4sLd25DQA4w1itPo+f5
 V/SQxuhnlQkTOCdJ7b/mby/pNRz1lsLkjnXueLILj7gNjwTabZXYtL16z24qkDTI1x3g98R/
 xunb3/fQwR8FY5/zRvXJq5us/nLvIvOmVwZFkwXc+AF+LSIajqQz9XbXeIP/BDjlBNXRZNdo
 dVuSU51ENcMcilPr2EUnqEAqeczsCGpnvRCLfVQeSZr2L9N4svNhhfPOEscYhhpHTh0VPyxI
 pPBNKq+byuYPMyk3nj814NKhImK0O4gTyCK9b+gZAVvQcYAXvSouCnTZeJRrNHJFTgTgu6E0
 caxTGgc5zzQHeX67eMzrGomG3ZnIxmd1sAbgvJUDaD2GrYlulfwGWwWyTNbWRvMighVdPkSF
 6XFgQaosWxkV0OELLy2N485YrTr2Uq64VKyxpncLh50e2RnyAJ9Za0Dx0yyp44iD1OvHtkEI
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <754a493b-a557-c369-96e1-6701ba5d5a30@gmail.com>
Date:   Wed, 30 Oct 2019 16:28:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191030224251.21578-4-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/30/19 3:42 PM, Michael Walle wrote:
> Add support for configuring the CLK_25M pin as well as the RGMII I/O
> voltage by the device tree.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/net/phy/at803x.c | 156 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 154 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 1eb5d4fb8925..32be4c72cf4b 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -13,7 +13,9 @@
>  #include <linux/netdevice.h>
>  #include <linux/etherdevice.h>
>  #include <linux/of_gpio.h>
> +#include <linux/bitfield.h>
>  #include <linux/gpio/consumer.h>
> +#include <dt-bindings/net/atheros-at803x.h>
>  
>  #define AT803X_SPECIFIC_STATUS			0x11
>  #define AT803X_SS_SPEED_MASK			(3 << 14)
> @@ -62,6 +64,37 @@
>  #define AT803X_DEBUG_REG_5			0x05
>  #define AT803X_DEBUG_TX_CLK_DLY_EN		BIT(8)
>  
> +#define AT803X_DEBUG_REG_1F			0x1F
> +#define AT803X_DEBUG_PLL_ON			BIT(2)
> +#define AT803X_DEBUG_RGMII_1V8			BIT(3)
> +
> +/* AT803x supports either the XTAL input pad, an internal PLL or the
> + * DSP as clock reference for the clock output pad. The XTAL reference
> + * is only used for 25 MHz output, all other frequencies need the PLL.
> + * The DSP as a clock reference is used in synchronous ethernet
> + * applications.

How does that tie in the mode in which the PHY is configured? In reverse
MII mode, the PHY provides the TX clock which can be either 25Mhz or
50Mhz AFAIR, in RGMII mode, the TXC provided by the MAC is internally
resynchronized and then fed back to the MAC as a 125Mhz clock.

Do you possibly need to cross check the clock output selection with the
PHY interface?

[snip]
> +static int at803x_parse_dt(struct phy_device *phydev)
> +{
> +	struct device_node *node = phydev->mdio.dev.of_node;
> +	struct at803x_priv *priv = phydev->priv;
> +	u32 freq, strength;
> +	unsigned int sel;
> +	int ret;
> +
> +	if (!IS_ENABLED(CONFIG_OF_MDIO))
> +		return 0;
> +
> +	if (!node)
> +		return 0;

I don't think you need either of those two things, every of_* function
would check whether the node reference is non-NULL.

> +
> +	if (of_property_read_bool(node, "atheros,keep-pll-enabled"))
> +		priv->flags |= AT803X_KEEP_PLL_ENABLED;

This should probably be a PHY tunable rather than a Device Tree property
as this delves more into the policy than the pure hardware description.

> +
> +	if (of_property_read_bool(node, "atheros,rgmii-io-1v8"))
> +		priv->flags |= AT803X_RGMII_1V8;> +
> +	ret = of_property_read_u32(node, "atheros,clk-out-frequency", &freq);
> +	if (!ret) {
> +		switch (freq) {
> +		case 25000000:
> +			sel = AT803X_CLK_OUT_25MHZ_XTAL;
> +			break;
> +		case 50000000:
> +			sel = AT803X_CLK_OUT_50MHZ_PLL;
> +			break;
> +		case 62500000:
> +			sel = AT803X_CLK_OUT_62_5MHZ_PLL;
> +			break;
> +		case 125000000:
> +			sel = AT803X_CLK_OUT_125MHZ_PLL;
> +			break;
> +		default:
> +			phydev_err(phydev,
> +				   "invalid atheros,clk-out-frequency\n");
> +			return -EINVAL;
> +		}

Maybe the PHY should be a clock provider of some sort, this might be
especially important if the PHY supplies the Ethernet MAC's RXC (which
would be the case in a RGMII configuration).
-- 
Florian
