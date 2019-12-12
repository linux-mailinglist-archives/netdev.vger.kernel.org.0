Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF5B411C47C
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 04:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbfLLD56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 22:57:58 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41401 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbfLLD55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 22:57:57 -0500
Received: by mail-pf1-f196.google.com with SMTP id s18so25459pfd.8;
        Wed, 11 Dec 2019 19:57:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zAqBwSAEjVBVcJbtUn42ZmrLmkYi+ObYmXAQBM0wBg0=;
        b=uGqq6vlv/rR/Wp6JstxQ+BoqUe04G6Bt7ojtGSbn0kgrvsnoHm+dQTtbnXootKC3SB
         RVdE3rk2KhqgL017zeBkcCHKgmD33sxrR5hYyQ0N6ZvL/oxE6b3i9TFMipW9YJ/AWmDS
         qveIMN2jw45LtiDM9Iench75GXDFU0ji3378BHzbBze7bcWpaEQ9/luz6dSZO+L5SBI9
         UD4ykB7dFRnW3srU/RcUABbLEwwJNiA9aNkomWttJYnWR0ok7wrp8oj//xxvMsmYHoZH
         yF9cpfrXmVFMVAZVNydm1kDWgnKBxjPd7wea+JT2Cob06NAJEt2nZFjEu3SxPNUttM9H
         +PCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=zAqBwSAEjVBVcJbtUn42ZmrLmkYi+ObYmXAQBM0wBg0=;
        b=XjH/7x6Kjx4H91nDWtjFNWOsLuOtddp49YTvGMcq8I18qcGhLCv1ew+6P7IOYdBonp
         i+P4Ohti5IVWJXukzwpaW9nRzFFy7jytYErlqfZIWpo8MzYVxGYxh0ujPcWMawwQ9h13
         Ijm+zdvOjSDajKxiEJuxsf2cyUIrT3GHcrvn0YqKC2/wCOnv7ewn8bO6kX8b3xjJXPB5
         mVHwU2rBjJZH3XVeK7hjMJH5ZI6kI1jezlTx4AIqpzFrobRBYbyStY/si7jDXH/oqLb/
         oPo0Vt4RtbzsSDaB2XWoKdjzLkPDfOm4gj3q/XaQ4OpUMVP9w26bz8jGpV2Nz2/JxstD
         lXQQ==
X-Gm-Message-State: APjAAAX1keSZ6kXnYiYgdFcgcuBJ+YUFTA6xc2rEL/u0/PPsadQtPVcb
        oHGF9UzCveEftiSi+glrt4s=
X-Google-Smtp-Source: APXvYqzBkRh3cwSyPQsZa5nDsKSRf+bLljilwo6YWX2fCXsu5TpTQhyEMggR3clwFExZgUd6zL095g==
X-Received: by 2002:a62:1bd0:: with SMTP id b199mr7738199pfb.172.1576123076758;
        Wed, 11 Dec 2019 19:57:56 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id a19sm4716127pfn.50.2019.12.11.19.57.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 19:57:56 -0800 (PST)
Subject: Re: [PATCH net-next 4/6] net: dsa: mt7530: Add the support of MT7531
 switch
To:     Landen Chao <landen.chao@mediatek.com>, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, matthias.bgg@gmail.com,
        robh+dt@kernel.org, mark.rutland@arm.com
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        davem@davemloft.net, sean.wang@mediatek.com, opensource@vdorst.com,
        frank-w@public-files.de
References: <cover.1575914275.git.landen.chao@mediatek.com>
 <6d608dd024edc90b09ba4fe35417b693847f973c.1575914275.git.landen.chao@mediatek.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <0eb12ad8-0484-feb5-d912-40e052315739@gmail.com>
Date:   Wed, 11 Dec 2019 19:57:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <6d608dd024edc90b09ba4fe35417b693847f973c.1575914275.git.landen.chao@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/10/2019 12:14 AM, Landen Chao wrote:
> Add new support for MT7531:
> 
> MT7531 is the next generation of MT7530. It is also a 7-ports switch with
> 5 giga embedded phys, 2 cpu ports, and the same MAC logic of MT7530. Cpu
> port 6 only supports HSGMII interface. Cpu port 5 supports either RGMII
> or HSGMII in different HW sku. Due to HSGMII interface support, pll, and
> pad setting are different from MT7530. This patch adds different initial
> setting of MT7531.
> 
> Signed-off-by: Landen Chao <landen.chao@mediatek.com>
> Signed-off-by: Sean Wang <sean.wang@mediatek.com>
> ---

[snip]

> +	/* Enable PHY power, since phy_device has not yet been created
> +	 * provided for phy_[read,write]_mmd_indirect is called, we provide
> +	 * our own mt7531_ind_mmd_phy_[read,write] to complete this
> +	 * function.
> +	 */
> +	val = mt7531_ind_mmd_phy_read(priv, 0, PHY_DEV1F,
> +				      MT7531_PHY_DEV1F_REG_403);
> +	val |= MT7531_PHY_EN_BYPASS_MODE;
> +	val &= ~MT7531_PHY_POWER_OFF;
> +	mt7531_ind_mmd_phy_write(priv, 0, PHY_DEV1F,
> +				 MT7531_PHY_DEV1F_REG_403, val);

You are doing this for port 0 only, is that because this broadcasts to
all internal PHYs as well, or is it enough to somehow do it just for
port 0? It sounds like you might want to make this operation a bit more
scoped, if you have an external PHY that also responds to broadcast MDIO
writes this could possibly cause some unattended effects, no?

[snip]

> +static int mt7531_rgmii_setup(struct mt7530_priv *priv, u32 port)
> +{
> +	u32 val;
> +
> +	if (port != 5) {
> +		dev_err(priv->dev, "RGMII mode is not available for port %d\n",
> +			port);
> +		return -EINVAL;
> +	}
> +
> +	val = mt7530_read(priv, MT7531_CLKGEN_CTRL);
> +	val |= GP_CLK_EN;
> +	val &= ~GP_MODE_MASK;
> +	val |= GP_MODE(MT7531_GP_MODE_RGMII);
> +	val |= TXCLK_NO_REVERSE;
> +	val |= RXCLK_NO_DELAY;

You actually need to look at the port's phy_interface_t value to
determine whether the delays should be set/clear in either RX or TX
directions.

[snip]

> -	if (phylink_autoneg_inband(mode)) {
> +	if (phylink_autoneg_inband(mode) &&
> +	    state->interface != PHY_INTERFACE_MODE_SGMII) {

So you don't support in-band auto-negotiation for 1000BaseX either?

[snip]

> @@ -1590,9 +2197,20 @@ static void mt753x_phylink_validate(struct dsa_switch *ds, int port,
>  	phylink_set_port_modes(mask);
>  	phylink_set(mask, Autoneg);
>  
> -	if (state->interface == PHY_INTERFACE_MODE_TRGMII) {
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_TRGMII:
>  		phylink_set(mask, 1000baseT_Full);
> -	} else {
> +		break;
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +	case PHY_INTERFACE_MODE_2500BASEX:
> +		phylink_set(mask, 1000baseX_Full);
> +		phylink_set(mask, 2500baseX_Full);

Did you intend this to be:

	case PHY_INTERFACE_MODE_2500BASEX:
		phylink_set(mask, 2500baseX_Full);
		/* fall through */
	case PHY_INTERFACE_MODE_1000BASEX:
		phylink_set(mask, 1000baseX_Full);
		break;

?
[snip]

> +/* Register for PHY Indirect Access Control */
> +#define MT7531_PHY_IAC			0x701C
> +#define  PHY_ACS_ST			BIT(31)
> +#define  MDIO_REG_ADDR_MASK		(0x1f << 25)
> +#define  MDIO_PHY_ADDR_MASK		(0x1f << 20)
> +#define  MDIO_CMD_MASK			(0x3 << 18)
> +#define  MDIO_ST_MASK			(0x3 << 16)
> +#define  MDIO_RW_DATA_MASK		(0xffff)
> +#define  MDIO_REG_ADDR(x)		(((x) & 0x1f) << 25)
> +#define  MDIO_DEV_ADDR(x)		(((x) & 0x1f) << 25)
> +#define  MDIO_PHY_ADDR(x)		(((x) & 0x1f) << 20)
> +#define  MDIO_CMD(x)			(((x) & 0x3) << 18)
> +#define  MDIO_ST(x)			(((x) & 0x3) << 16)

I would suggest names that are more scoped because these could easily
collide with existing of future definitions from include/linux/mdio.h.

> +
> +enum mt7531_phy_iac_cmd {
> +	MT7531_MDIO_ADDR = 0,
> +	MT7531_MDIO_WRITE = 1,
> +	MT7531_MDIO_READ = 2,
> +	MT7531_MDIO_READ_CL45 = 3,
> +};
> +
> +/* MDIO_ST: MDIO start field */
> +enum mt7531_mdio_st {
> +	MT7531_MDIO_ST_CL45 = 0,
> +	MT7531_MDIO_ST_CL22 = 1,
> +};
> +
> +#define  MDIO_CL22_READ			(MDIO_ST(MT7531_MDIO_ST_CL22) | \
> +					 MDIO_CMD(MT7531_MDIO_READ))
> +#define  MDIO_CL22_WRITE		(MDIO_ST(MT7531_MDIO_ST_CL22) | \
> +					 MDIO_CMD(MT7531_MDIO_WRITE))
> +#define  MDIO_CL45_ADDR			(MDIO_ST(MT7531_MDIO_ST_CL45) | \
> +					 MDIO_CMD(MT7531_MDIO_ADDR))
> +#define  MDIO_CL45_READ			(MDIO_ST(MT7531_MDIO_ST_CL45) | \
> +					 MDIO_CMD(MT7531_MDIO_READ))
> +#define  MDIO_CL45_WRITE		(MDIO_ST(MT7531_MDIO_ST_CL45) | \
> +					 MDIO_CMD(MT7531_MDIO_WRITE))

Likewise.
-- 
Florian
