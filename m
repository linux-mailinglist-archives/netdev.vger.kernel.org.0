Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFE41AD039
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 21:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgDPTSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 15:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727774AbgDPTSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 15:18:34 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE21C061A0C;
        Thu, 16 Apr 2020 12:18:34 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u9so2092472pfm.10;
        Thu, 16 Apr 2020 12:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VHahvNrkkFVvNiU/oirb0CgHcyvFxOl5Oabes9gcDEs=;
        b=No4yRRSekwfyTlegsvTl9uyZdM/3LcltD+EUPy+bawJo5eu4IpnWbclgH+2b75KgfO
         /T7DzII+wPx8BZIwrg5x1tgqC4TMeDtozxuQkHTUSvRAFRzqtiUadaxa0USiZcQUuoLJ
         sv0cA9X4cYppb5FZY8zvXHvOGYA0t6II1by4Osn45SFiXLrKfuPS4ZprL7MUFFIJ08E4
         NV+/EeCpByTRLzHmKhJKqFostcV9/ngSewQnomUvayn/mb3RDRmsTX1B5gl9u99ao/6a
         bQorSpViBV5JEeEkmHXr3AFaJoKpWLBa4P2Oi8Hy3hrn24vKRudZ0ZsCFSLiY5bCBTyZ
         LjDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VHahvNrkkFVvNiU/oirb0CgHcyvFxOl5Oabes9gcDEs=;
        b=CU+SZKEUu1Il7/xlhuDUtJEapzSB3IE2Je+yOgT/xnSDPtP3l+kKqSv23dRphTxiUU
         dLT9nRIsYqokg4HeBv+BbvBSryK8pZMMEHx3jT2+Ae2/ndyf37aEuesGCRBpFums4YoH
         RNmjbpdc1r5ElBY5pbplkBR/jyRsz9CPtCNvO7Qljd0ihedhf99GIVK7IB6WKUSbrtdw
         hHlxFaYL2rIZ9MjNCjFJTOEP2a3MKvJ1pjQZg80vLo6zTWg5n6O//50p4wEctCM4aKW9
         sPMWeiMf8htKb7E3TotAKSbpG7Qenefi05fVoogjZACRtkwzOfjDkF8ZjzSmmiAlDrmU
         0TsA==
X-Gm-Message-State: AGi0PubrSs43iuGifOgpn5rO1Xp/KrZHLwPfJ5ruf9QmsglWaYi12tkn
        iseNP4YZk3yOiXIGQjZ4NwQ0gnW4
X-Google-Smtp-Source: APiQypKkDqt7haNqAQjS8aivmzho3DlBr9ezf2dD3Pi6/w+PhgVXzc6/ER6cFkwEzqeL3UDPLbTldg==
X-Received: by 2002:a62:b40e:: with SMTP id h14mr25790079pfn.88.1587064712816;
        Thu, 16 Apr 2020 12:18:32 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f21sm3671712pfn.71.2020.04.16.12.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 12:18:31 -0700 (PDT)
Subject: Re: [RFC PATCH 2/4] net: phy: Add support for AC200 EPHY
To:     Jernej Skrabec <jernej.skrabec@siol.net>, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com
Cc:     mripard@kernel.org, wens@csie.org, lee.jones@linaro.org,
        linux@armlinux.org.uk, davem@davemloft.net,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20200416185758.1388148-1-jernej.skrabec@siol.net>
 <20200416185758.1388148-3-jernej.skrabec@siol.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5062b508-2c68-dc94-add2-038178667c9f@gmail.com>
Date:   Thu, 16 Apr 2020 12:18:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200416185758.1388148-3-jernej.skrabec@siol.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/2020 11:57 AM, Jernej Skrabec wrote:
> AC200 MFD IC supports Fast Ethernet PHY. Add a driver for it.
> 
> Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
> ---
>   drivers/net/phy/Kconfig  |   7 ++
>   drivers/net/phy/Makefile |   1 +
>   drivers/net/phy/ac200.c  | 206 +++++++++++++++++++++++++++++++++++++++
>   3 files changed, 214 insertions(+)
>   create mode 100644 drivers/net/phy/ac200.c
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 3fa33d27eeba..16af69f69eaf 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -288,6 +288,13 @@ config ADIN_PHY
>   	  - ADIN1300 - Robust,Industrial, Low Latency 10/100/1000 Gigabit
>   	    Ethernet PHY
>   
> +config AC200_PHY
> +	tristate "AC200 EPHY"
> +	depends on NVMEM
> +	depends on OF
> +	help
> +	  Fast ethernet PHY as found in X-Powers AC200 multi-function device.
> +
>   config AMD_PHY
>   	tristate "AMD PHYs"
>   	---help---
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index 2f5c7093a65b..b0c5b91900fa 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -53,6 +53,7 @@ obj-$(CONFIG_SFP)		+= sfp.o
>   sfp-obj-$(CONFIG_SFP)		+= sfp-bus.o
>   obj-y				+= $(sfp-obj-y) $(sfp-obj-m)
>   
> +obj-$(CONFIG_AC200_PHY)		+= ac200.o
>   obj-$(CONFIG_ADIN_PHY)		+= adin.o
>   obj-$(CONFIG_AMD_PHY)		+= amd.o
>   aquantia-objs			+= aquantia_main.o
> diff --git a/drivers/net/phy/ac200.c b/drivers/net/phy/ac200.c
> new file mode 100644
> index 000000000000..3d7856ff8f91
> --- /dev/null
> +++ b/drivers/net/phy/ac200.c
> @@ -0,0 +1,206 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/**
> + * Driver for AC200 Ethernet PHY
> + *
> + * Copyright (c) 2020 Jernej Skrabec <jernej.skrabec@siol.net>
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mfd/ac200.h>
> +#include <linux/nvmem-consumer.h>
> +#include <linux/of.h>
> +#include <linux/phy.h>
> +#include <linux/platform_device.h>
> +
> +#define AC200_EPHY_ID			0x00441400
> +#define AC200_EPHY_ID_MASK		0x0ffffff0
> +
> +/* macros for system ephy control 0 register */
> +#define AC200_EPHY_RESET_INVALID	BIT(0)
> +#define AC200_EPHY_SYSCLK_GATING	BIT(1)
> +
> +/* macros for system ephy control 1 register */
> +#define AC200_EPHY_E_EPHY_MII_IO_EN	BIT(0)
> +#define AC200_EPHY_E_LNK_LED_IO_EN	BIT(1)
> +#define AC200_EPHY_E_SPD_LED_IO_EN	BIT(2)
> +#define AC200_EPHY_E_DPX_LED_IO_EN	BIT(3)
> +
> +/* macros for ephy control register */
> +#define AC200_EPHY_SHUTDOWN		BIT(0)
> +#define AC200_EPHY_LED_POL		BIT(1)
> +#define AC200_EPHY_CLK_SEL		BIT(2)
> +#define AC200_EPHY_ADDR(x)		(((x) & 0x1F) << 4)
> +#define AC200_EPHY_XMII_SEL		BIT(11)
> +#define AC200_EPHY_CALIB(x)		(((x) & 0xF) << 12)
> +
> +struct ac200_ephy_dev {
> +	struct phy_driver	*ephy;
> +	struct regmap		*regmap;
> +};
> +
> +static char *ac200_phy_name = "AC200 EPHY";
> +
> +static int ac200_ephy_config_init(struct phy_device *phydev)
> +{
> +	const struct ac200_ephy_dev *priv = phydev->drv->driver_data;
> +	unsigned int value;
> +	int ret;
> +
> +	phy_write(phydev, 0x1f, 0x0100);	/* Switch to Page 1 */

You could define a macro for accessing the page and you may consider 
implementing .read_page and .write_page and use the 
phy_read_paged()/phy_write_paged() helper functions.

> +	phy_write(phydev, 0x12, 0x4824);	/* Disable APS */
> +
> +	phy_write(phydev, 0x1f, 0x0200);	/* Switch to Page 2 */
> +	phy_write(phydev, 0x18, 0x0000);	/* PHYAFE TRX optimization */
> +
> +	phy_write(phydev, 0x1f, 0x0600);	/* Switch to Page 6 */
> +	phy_write(phydev, 0x14, 0x708f);	/* PHYAFE TX optimization */
> +	phy_write(phydev, 0x13, 0xF000);	/* PHYAFE RX optimization */
> +	phy_write(phydev, 0x15, 0x1530);
> +
> +	phy_write(phydev, 0x1f, 0x0800);	/* Switch to Page 6 */

Seems like the comment does not match the code, that should be Page 8, no?

> +	phy_write(phydev, 0x18, 0x00bc);	/* PHYAFE TRX optimization */
> +
> +	phy_write(phydev, 0x1f, 0x0100);	/* switch to page 1 */
> +	phy_clear_bits(phydev, 0x17, BIT(3));	/* disable intelligent IEEE */

Intelligent EEE maybe?
-- 
Florian
