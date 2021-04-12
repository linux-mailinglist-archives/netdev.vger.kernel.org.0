Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601EB35BA8E
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 09:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236762AbhDLHFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 03:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236569AbhDLHFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 03:05:08 -0400
X-Greylist: delayed 457 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 12 Apr 2021 00:04:50 PDT
Received: from mx.i2x.nl (mx.i2x.nl [IPv6:2a04:52c0:101:921::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D3BAC061574;
        Mon, 12 Apr 2021 00:04:50 -0700 (PDT)
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd00::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mx.i2x.nl (Postfix) with ESMTPS id 7DC8A5FB39;
        Mon, 12 Apr 2021 09:04:49 +0200 (CEST)
Authentication-Results: mx.i2x.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="KOH61tZq";
        dkim-atps=neutral
Received: from www (unknown [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 33C67BCA030;
        Mon, 12 Apr 2021 09:04:49 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 33C67BCA030
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1618211089;
        bh=M3JQj7NzQ2CBv+j5XuKuVWBX0H8tPiRu38YIUIPNjSc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KOH61tZqHiukrLYL9orX2yh2BVHg/y8DgL5igT2aG+TF571PC/ImF29hG0/4PBw/7
         3Di7yXomrnD8HlzijAEPIKkRf58yfY75kRFmqmk3ZNvkIIB8fsIsus7DL2xMnnZFtu
         mCrKmG/p3wBBnxrPZuFBlODuczwfhpwFJsxpABR0sBp2X1G6MwFdI4Js43WlaXRhqL
         FbZaQUo8fm00uX0EJKouhWyspLxMyH81yxtvbP4UKXeBNmLddqZUy6sLusKEXXu6oI
         Al3jwshnr79LRIAbUGE7OatklqNrl4RgNnM4XE1P9ArFAWIDktsHtvwRfp9BB1pM6D
         EPFXRfrMGg+rQ==
Received: from 48.79.2.5.in-addr.arpa (48.79.2.5.in-addr.arpa [5.2.79.48])
 by www.vdorst.com (Horde Framework) with HTTPS; Mon, 12 Apr 2021 07:04:49
 +0000
Date:   Mon, 12 Apr 2021 07:04:49 +0000
Message-ID: <20210412070449.Horde.wg9CWXW8V9o0P-heKYtQpVh@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC v4 net-next 1/4] net: phy: add MediaTek PHY driver
References: <20210412034237.2473017-1-dqfext@gmail.com>
 <20210412034237.2473017-2-dqfext@gmail.com>
In-Reply-To: <20210412034237.2473017-2-dqfext@gmail.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Qingfang,

Quoting DENG Qingfang <dqfext@gmail.com>:

> Add support for MediaTek PHYs found in MT7530 and MT7531 switches.
> The initialization procedure is from the vendor driver, but due to lack
> of documentation, the function of some register values remains unknown.
>
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
> RFC v3 -> RFC v4:
> - Remove unused include.
>
>  drivers/net/phy/Kconfig    |   5 ++
>  drivers/net/phy/Makefile   |   1 +
>  drivers/net/phy/mediatek.c | 111 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 117 insertions(+)
>  create mode 100644 drivers/net/phy/mediatek.c
>
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index a615b3660b05..edd858cec9ec 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -207,6 +207,11 @@ config MARVELL_88X2222_PHY
>  	  Support for the Marvell 88X2222 Dual-port Multi-speed Ethernet
>  	  Transceiver.
>
> +config MEDIATEK_PHY
> +	tristate "MediaTek PHYs"
> +	help
> +	  Supports the MediaTek switch integrated PHYs.
> +
>  config MICREL_PHY
>  	tristate "Micrel PHYs"
>  	help
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index de683e3abe63..9ed7dbab7770 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -64,6 +64,7 @@ obj-$(CONFIG_LXT_PHY)		+= lxt.o
>  obj-$(CONFIG_MARVELL_10G_PHY)	+= marvell10g.o
>  obj-$(CONFIG_MARVELL_PHY)	+= marvell.o
>  obj-$(CONFIG_MARVELL_88X2222_PHY)	+= marvell-88x2222.o
> +obj-$(CONFIG_MEDIATEK_PHY)	+= mediatek.o
>  obj-$(CONFIG_MESON_GXL_PHY)	+= meson-gxl.o
>  obj-$(CONFIG_MICREL_KS8995MA)	+= spi_ks8995.o
>  obj-$(CONFIG_MICREL_PHY)	+= micrel.o
> diff --git a/drivers/net/phy/mediatek.c b/drivers/net/phy/mediatek.c
> new file mode 100644
> index 000000000000..1627b7c04345
> --- /dev/null
> +++ b/drivers/net/phy/mediatek.c
> @@ -0,0 +1,111 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +#include <linux/module.h>
> +#include <linux/phy.h>
> +
> +#define MTK_EXT_PAGE_ACCESS		0x1f
> +#define MTK_PHY_PAGE_STANDARD		0x0000
> +#define MTK_PHY_PAGE_EXTENDED		0x0001
> +#define MTK_PHY_PAGE_EXTENDED_2		0x0002
> +#define MTK_PHY_PAGE_EXTENDED_3		0x0003
> +#define MTK_PHY_PAGE_EXTENDED_2A30	0x2a30
> +#define MTK_PHY_PAGE_EXTENDED_52B5	0x52b5
> +
> +static int mtk_phy_read_page(struct phy_device *phydev)
> +{
> +	return __phy_read(phydev, MTK_EXT_PAGE_ACCESS);
> +}
> +
> +static int mtk_phy_write_page(struct phy_device *phydev, int page)
> +{
> +	return __phy_write(phydev, MTK_EXT_PAGE_ACCESS, page);
> +}
> +
> +static void mtk_phy_config_init(struct phy_device *phydev)
> +{
> +	/* Disable EEE */
> +	phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0);

For my EEE patch I changed this line to:

genphy_config_eee_advert(phydev);

So PHY EEE part is setup properly at boot, instead enable it manual  
via ethtool.
This function also takes the DTS parameters "eee-broken-xxxx" in to  
account while
setting-up the PHY.

> +
> +	/* Enable HW auto downshift */
> +	phy_modify_paged(phydev, MTK_PHY_PAGE_EXTENDED, 0x14, 0, BIT(4));
> +
> +	/* Increase SlvDPSready time */
> +	phy_select_page(phydev, MTK_PHY_PAGE_EXTENDED_52B5);
> +	__phy_write(phydev, 0x10, 0xafae);
> +	__phy_write(phydev, 0x12, 0x2f);
> +	__phy_write(phydev, 0x10, 0x8fae);
> +	phy_restore_page(phydev, MTK_PHY_PAGE_STANDARD, 0);
> +
> +	/* Adjust 100_mse_threshold */
> +	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x123, 0xffff);
> +
> +	/* Disable mcc */
> +	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0xa6, 0x300);
> +}
> +

Greats,

René


