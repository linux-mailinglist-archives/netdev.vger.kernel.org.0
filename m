Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFD6E88243
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407422AbfHISVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:21:39 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39092 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbfHISVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:21:39 -0400
Received: by mail-wr1-f67.google.com with SMTP id t16so8946321wra.6;
        Fri, 09 Aug 2019 11:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aP8Kc4uvHMSQzWbLylsngp8OYflz47E7d1X9Y5Fo04s=;
        b=beUFa9U/HYxwIUdd79nCzh0PKzYV3sVHmJO+qRMCz78V3E1bG9QN5+WQaArWoX63W7
         +jtK00rNsCDaHzaBwseYAjX/MUpgTr3LjesTgcuMOrUadQ/qPa7UH0COCrTwK8wmJLgC
         OKNCl4ennrI8/kkkVXjz6etv5QJNdZyKVV3tw7fiNl4WkN3k+5kobDQgo7Izkexhtfjj
         1Z/7cE4xcR/qAcpcKQaAURZDUCWLgPAjG73PzZwuYLkVTwtLjT87H3gExrBlXpJ4MKa0
         sXbJwFjsd6l4jV/Fja34PRlqgnwhaWAG+QnbLQB2WtItQT4k6KjfE0WwBpJxfx1R9knm
         gLxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aP8Kc4uvHMSQzWbLylsngp8OYflz47E7d1X9Y5Fo04s=;
        b=DVYL30S5sSVA569A3JQ+7S+rZKfM0i/1cqTQRXXKhIK2p5GcVA437nTG3oNZUFAb+l
         h1kQi9nMlMk16NKo+LsY7CxsD00lFRD7F2oCileDNldTV5KtN2HHQs5Yv+0dy+PYbCYW
         fNyEM0SR+33YEXlW9CmZyhhKLrpB8613z1ddFXSRCp2CbadOg2zyhDcGyr6Y8qBLbdlp
         cGh1zp84gTv576+4Bh3ZeVNfzqtmsuNLYP/G+kBAOXnqlavnkZ8kI50otenWajAbjmNA
         5EYkof8wTK+ghE1zpg7zQmSKR3J8LZbf7JEf8sLtVerKhivdYPV5f1IqHcsyR23JvpIl
         ZZ6w==
X-Gm-Message-State: APjAAAWphHMfo/sogGeWZ2+XG15/xywqye297bg6r18Eq6XAV7ZxPDu2
        ZDy0Q+8AgHJwlfB5r7gdEv8=
X-Google-Smtp-Source: APXvYqxkj2SPJKAl4OYgtXkdm6opMOEqyymIOnT5O14Zj6dO7xelBlPrsBzwdcfKxZ/r2wMyiYQlFA==
X-Received: by 2002:a5d:628d:: with SMTP id k13mr25564008wru.69.1565374896167;
        Fri, 09 Aug 2019 11:21:36 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:2994:d24a:66a1:e0e5? (p200300EA8F2F32002994D24A66A1E0E5.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:2994:d24a:66a1:e0e5])
        by smtp.googlemail.com with ESMTPSA id r16sm8811803wrc.81.2019.08.09.11.21.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 11:21:35 -0700 (PDT)
Subject: Re: [PATCH v3 04/14] net: phy: adin: add {write,read}_mmd hooks
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        f.fainelli@gmail.com, andrew@lunn.ch
References: <20190809133552.21597-1-alexandru.ardelean@analog.com>
 <20190809133552.21597-5-alexandru.ardelean@analog.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <eb89d746-cf4a-6586-f4c7-101e00765c08@gmail.com>
Date:   Fri, 9 Aug 2019 20:21:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809133552.21597-5-alexandru.ardelean@analog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.08.2019 15:35, Alexandru Ardelean wrote:
> Both ADIN1200 & ADIN1300 support Clause 45 access for some registers.
> The Extended Management Interface (EMI) registers are accessible via both
> Clause 45 (at register MDIO_MMD_VEND1) and using Clause 22.
> 
> However, the Clause 22 access for MMD regs differs from the standard one
> defined by 802.3. The ADIN PHYs  use registers ExtRegPtr (0x0010) and
> ExtRegData (0x0011) to access Clause 45 & EMI registers.
> 
> The indirect access is done via the following mechanism (for both R/W):
> 1. Write the address of the register in the ExtRegPtr
> 2. Read/write the value of the register (written at ExtRegPtr)
> 
> This mechanism is needed to manage configuration of chip settings and to
> access EEE registers (via Clause 22).
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> ---
>  drivers/net/phy/adin.c | 46 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
> index 91ff26d08fd5..8973ad819b93 100644
> --- a/drivers/net/phy/adin.c
> +++ b/drivers/net/phy/adin.c
> @@ -14,6 +14,9 @@
>  #define PHY_ID_ADIN1200				0x0283bc20
>  #define PHY_ID_ADIN1300				0x0283bc30
>  
> +#define ADIN1300_MII_EXT_REG_PTR		0x0010
> +#define ADIN1300_MII_EXT_REG_DATA		0x0011
> +
>  #define ADIN1300_INT_MASK_REG			0x0018
>  #define   ADIN1300_INT_MDIO_SYNC_EN		BIT(9)
>  #define   ADIN1300_INT_ANEG_STAT_CHNG_EN	BIT(8)
> @@ -53,6 +56,45 @@ static int adin_phy_config_intr(struct phy_device *phydev)
>  			      ADIN1300_INT_MASK_EN);
>  }
>  
> +static int adin_read_mmd(struct phy_device *phydev, int devad, u16 regnum)
> +{
> +	struct mii_bus *bus = phydev->mdio.bus;
> +	int phy_addr = phydev->mdio.addr;
> +	int err;
> +
> +	if (phydev->is_c45) {

Similar to what we discussed regarding feature detection:
Flag is_c45 shouldn't be set with these PHY's, therefore this is dead code.

> +		u32 addr = MII_ADDR_C45 | (devad << 16) | (regnum & 0xffff);
> +
> +		return __mdiobus_read(bus, phy_addr, addr);
> +	}
> +
> +	err = __mdiobus_write(bus, phy_addr, ADIN1300_MII_EXT_REG_PTR, regnum);
> +	if (err)
> +		return err;
> +
> +	return __mdiobus_read(bus, phy_addr, ADIN1300_MII_EXT_REG_DATA);
> +}
> +
> +static int adin_write_mmd(struct phy_device *phydev, int devad, u16 regnum,
> +			  u16 val)
> +{
> +	struct mii_bus *bus = phydev->mdio.bus;
> +	int phy_addr = phydev->mdio.addr;
> +	int err;
> +
> +	if (phydev->is_c45) {
> +		u32 addr = MII_ADDR_C45 | (devad << 16) | (regnum & 0xffff);
> +
> +		return __mdiobus_write(bus, phy_addr, addr, val);
> +	}
> +
> +	err = __mdiobus_write(bus, phy_addr, ADIN1300_MII_EXT_REG_PTR, regnum);
> +	if (err)
> +		return err;
> +
> +	return __mdiobus_write(bus, phy_addr, ADIN1300_MII_EXT_REG_DATA, val);
> +}
> +
>  static struct phy_driver adin_driver[] = {
>  	{
>  		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1200),
> @@ -64,6 +106,8 @@ static struct phy_driver adin_driver[] = {
>  		.config_intr	= adin_phy_config_intr,
>  		.resume		= genphy_resume,
>  		.suspend	= genphy_suspend,
> +		.read_mmd	= adin_read_mmd,
> +		.write_mmd	= adin_write_mmd,
>  	},
>  	{
>  		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1300),
> @@ -75,6 +119,8 @@ static struct phy_driver adin_driver[] = {
>  		.config_intr	= adin_phy_config_intr,
>  		.resume		= genphy_resume,
>  		.suspend	= genphy_suspend,
> +		.read_mmd	= adin_read_mmd,
> +		.write_mmd	= adin_write_mmd,
>  	},
>  };
>  
> 

