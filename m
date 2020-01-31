Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5AE414F37C
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 21:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgAaU4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 15:56:37 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44124 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgAaU4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 15:56:36 -0500
Received: by mail-wr1-f65.google.com with SMTP id m16so10217119wrx.11;
        Fri, 31 Jan 2020 12:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pDSC9P7JGdB1vjktr1qRbOtvxNmLiv67d/n70snEkzA=;
        b=mS4cuAoRl6iBYW+3nU2NHaxoshadxv/bNXyiCAovrHuDRI92WpUVNzg4BhG6aty6Lb
         bDbhCtMeaq34gtVVNFDHNhe+NKrXkawz6vZrz2jpQjqeyqKecbiDT7kpw341sdyQoj5p
         sxiXLlgdnxxtmtWlRmCUjyVlbBthFOwbFF46hW7FlVQB0yf8/Qq4mnry+DCDWEVy51r3
         3sM/t/tsb1a0CR7Ipn1G22goD3K9l5UqR8dKhdDjgrYEVNLh/4BL7/NjLIDSURaoFmI9
         vkymwh8AuOVu18WB1Q6gu9IL6pGPS1C502GijuO6ne/iVcYLF0Dxg87y46dkYQ4Bq9MK
         CwvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pDSC9P7JGdB1vjktr1qRbOtvxNmLiv67d/n70snEkzA=;
        b=D1NEzlLpXwkPlho2VogCBI//6hNeuvUct+yAdiv1npo0GJzdn4mBiUXZlayyB4wrdg
         l2gnbOmllRFjfJ0H2f+mxz2JCzKXOryTa+yekSOCbIZVTOjhjEnPVDXODrPgPpeWRi+S
         CXN6KtCKtq5KSIo5hW7K0h/qXNTp0ZbGXm03oDTpNRjCWAelDU3IGudzYY0oxh0h1YSv
         VXgCvwRHdr6cUPHxQluFI5j+FinIJSH5yYURRWRxiwOiTbI0SqSdKk/S94fnA2bhNj+2
         2GYw5EM7qpgU4yzh4pO4oyedZ2i7Tav3Z4gYYCsg1bd6wwe/jMKwyM09D5amp0vvnx0h
         Qykg==
X-Gm-Message-State: APjAAAWMA+Z8BCRt1+bUw+7BDQqrZQrxPNVBoWi5NXco5ZxlM9Y3le2V
        QUfZoSM3H3nYN8ozIhCtjlk=
X-Google-Smtp-Source: APXvYqwywSqz6hsbDgFgEs50YGI4+lySVourtilE3SCqpEFvwIuXF25wuMhw1DJi2UGB+ddzAvl+xA==
X-Received: by 2002:adf:eb8e:: with SMTP id t14mr255288wrn.384.1580504194450;
        Fri, 31 Jan 2020 12:56:34 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:8922:4c51:f8d2:7862? (p200300EA8F29600089224C51F8D27862.dip0.t-ipconnect.de. [2003:ea:8f29:6000:8922:4c51:f8d2:7862])
        by smtp.googlemail.com with ESMTPSA id a22sm12430161wmd.20.2020.01.31.12.56.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 12:56:33 -0800 (PST)
Subject: Re: [PATCH net-master 1/1] net: phy: dp83867: Add speed optimization
 feature
To:     Dan Murphy <dmurphy@ti.com>, andrew@lunn.ch, f.fainelli@gmail.com,
        bunk@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, grygorii.strashko@ti.com
References: <20200131151110.31642-1-dmurphy@ti.com>
 <20200131151110.31642-2-dmurphy@ti.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7e8080f7-3825-98f5-2465-c536ecbb8146@gmail.com>
Date:   Fri, 31 Jan 2020 21:56:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200131151110.31642-2-dmurphy@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.01.2020 16:11, Dan Murphy wrote:
> Set the speed optimization bit on the DP83867 PHY.
> This feature can also be strapped on the 64 pin PHY devices
> but the 48 pin devices do not have the strap pin available to enable
> this feature in the hardware.  PHY team suggests to have this bit set.
> 
It's ok to enable downshift by default, however it would be good to
make it configurable. Best implement the downshift tunable, you can
use the Marvell PHY driver as reference.
Can the number of attempts until downshifts happens be configured?


> With this bit set the PHY will auto negotiate and report the link
> parameters in the PHYSTS register and not in the BMCR.  So we need to
> over ride the genphy_read_status with a DP83867 specific read status.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  drivers/net/phy/dp83867.c | 48 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index 967f57ed0b65..695aaf4f942f 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -21,6 +21,7 @@
>  #define DP83867_DEVADDR		0x1f
>  
>  #define MII_DP83867_PHYCTRL	0x10
> +#define MII_DP83867_PHYSTS	0x11
>  #define MII_DP83867_MICR	0x12
>  #define MII_DP83867_ISR		0x13
>  #define DP83867_CFG2		0x14
> @@ -118,6 +119,15 @@
>  #define DP83867_IO_MUX_CFG_CLK_O_SEL_MASK	(0x1f << 8)
>  #define DP83867_IO_MUX_CFG_CLK_O_SEL_SHIFT	8
>  
> +/* PHY STS bits */
> +#define DP83867_PHYSTS_1000			BIT(15)
> +#define DP83867_PHYSTS_100			BIT(14)
> +#define DP83867_PHYSTS_DUPLEX			BIT(13)
> +#define DP83867_PHYSTS_LINK			BIT(10)
> +
> +/* CFG2 bits */
> +#define DP83867_SPEED_OPTIMIZED_EN		(BIT(8) | BIT(9))
> +
>  /* CFG3 bits */
>  #define DP83867_CFG3_INT_OE			BIT(7)
>  #define DP83867_CFG3_ROBUST_AUTO_MDIX		BIT(9)
> @@ -287,6 +297,36 @@ static int dp83867_config_intr(struct phy_device *phydev)
>  	return phy_write(phydev, MII_DP83867_MICR, micr_status);
>  }
>  
> +static int dp83867_read_status(struct phy_device *phydev)
> +{
> +	int status = phy_read(phydev, MII_DP83867_PHYSTS);
> +
> +	if (status < 0)
> +		return status;
> +
> +	if (status & DP83867_PHYSTS_DUPLEX)
> +		phydev->duplex = DUPLEX_FULL;
> +	else
> +		phydev->duplex = DUPLEX_HALF;
> +
> +	if (status & DP83867_PHYSTS_1000)
> +		phydev->speed = SPEED_1000;
> +	else if (status & DP83867_PHYSTS_100)
> +		phydev->speed = SPEED_100;
> +	else
> +		phydev->speed = SPEED_10;
> +
> +	if (status & DP83867_PHYSTS_LINK)
> +		phydev->link = 1;
> +	else
> +		phydev->link = 0;
> +
> +	phydev->pause = 0;
> +	phydev->asym_pause = 0;
> +
> +	return 0;
> +}
> +
>  static int dp83867_config_port_mirroring(struct phy_device *phydev)
>  {
>  	struct dp83867_private *dp83867 =
> @@ -467,6 +507,12 @@ static int dp83867_config_init(struct phy_device *phydev)
>  	int ret, val, bs;
>  	u16 delay;
>  
> +	/* Force speed optimization for the PHY even if it strapped */
> +	ret = phy_modify(phydev, DP83867_CFG2, DP83867_SPEED_OPTIMIZED_EN,
> +			 DP83867_SPEED_OPTIMIZED_EN);

Here phy_set_bits() would be easier.

> +	if (ret)
> +		return ret;
> +
>  	ret = dp83867_verify_rgmii_cfg(phydev);
>  	if (ret)
>  		return ret;
> @@ -655,6 +701,8 @@ static struct phy_driver dp83867_driver[] = {
>  		.config_init	= dp83867_config_init,
>  		.soft_reset	= dp83867_phy_reset,
>  
> +		.read_status	= dp83867_read_status,
> +
>  		.get_wol	= dp83867_get_wol,
>  		.set_wol	= dp83867_set_wol,
>  
> 

