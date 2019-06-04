Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9307A33E76
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 07:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfFDFhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 01:37:53 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55743 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbfFDFhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 01:37:53 -0400
Received: by mail-wm1-f68.google.com with SMTP id 16so8972398wmg.5
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 22:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=e76xViDNQk0bhQoAbZugdImBNTpHXT0zgCtjznge9R4=;
        b=QU3dznp5N5DarshMP3iP/UKha7PvLNDeY4fWdZ1wr0anDND8Hn8/DYur0WcOUL8+id
         jpN+K94MRUa0KLrt+0Q8Zr4msJKD8gBX4XyrXwZ0f7asBXE53wRls6O7C01VAjfMkYpJ
         bYRmZLwMEnxGQ82y1Nb2IGKlCOa+uXOg6lCT6+zHQMraF0/kkuPWZsz3d4UejqbFM5mX
         Cl3q0SwHoWgeeYQ6eGUYNYp5APi3afm2pu48uYmSePPP7ftoXqnIhaZsd/+ogPGwmVNY
         d89bVNwmSWL2ggPMqDD9OIEGAugmimnede5/7Azv0jhWDK4wWNXpuaO4dTlu3sDanTIg
         6S8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e76xViDNQk0bhQoAbZugdImBNTpHXT0zgCtjznge9R4=;
        b=PL/Nn3dQYS6LKfDw1ci+rY8gId1nzzXVAVAyijWcBxjafi7WAdz0e/leCm5Ou47K+a
         exy9lWqZaXX8Lr+dmo2EWe9HUit6S7Fw+wpAV0xXZDjiNRemIzYoC2wCXdt3jSe9IgWS
         6IVuVNoAIUFHSb1nvedQwmVJK4BzUuUwRZR0G3sqBZ47RnRCqf3nqd6K4rnfrAed/2z1
         KCaociZGeZ2QIC0AXdKOT39PvMxrqwzRpOxzyAnXU0V2Be+DA7vAW3Mxtcp1TTnVjMeJ
         KNyhaeEzQJMjIncwwQVq5aa4mYy53eLgv0wxtTSLaumwaM3pXj4JeAZT+zPAGiE7aISM
         /fNg==
X-Gm-Message-State: APjAAAX3dp8AktxcvrrXeBwwJrKNHOD3QAKHLGPcFtAYmYg4nZWNHJQM
        uJt+aPjaMr6rBX/4AI+CeHU=
X-Google-Smtp-Source: APXvYqzu6YyM9LBURjTikT8I4ZrJpEmaWnKoSeWOHZiAHhcz8YXhge3uoJmQGo58SqK1FhLnnu6PJA==
X-Received: by 2002:a1c:b757:: with SMTP id h84mr11668172wmf.127.1559626669880;
        Mon, 03 Jun 2019 22:37:49 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:15c:4632:d703:a1f7? (p200300EA8BF3BD00015C4632D703A1F7.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:15c:4632:d703:a1f7])
        by smtp.googlemail.com with ESMTPSA id x11sm11776878wmg.23.2019.06.03.22.37.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 22:37:49 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: phy: xilinx: add Xilinx PHY driver
To:     Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <1559603524-18288-1-git-send-email-hancock@sedsystems.ca>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d8c22bc3-0a20-2c24-88bb-b1f5f8cc907a@gmail.com>
Date:   Tue, 4 Jun 2019 07:37:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1559603524-18288-1-git-send-email-hancock@sedsystems.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.06.2019 01:12, Robert Hancock wrote:
> This adds a driver for the PHY device implemented in the Xilinx PCS/PMA
> Core logic. This is mostly a generic gigabit PHY, except that the
> features are explicitly set because the PHY wrongly indicates it has no
> extended status register when it actually does.
> 
> This version is a simplified version of the GPL 2+ version from the
> Xilinx kernel tree.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
> ---
> 
> Differences from v1:
> -Removed unnecessary config_init method
> -Added comment to explain why features are explicitly set
> 
>  drivers/net/phy/Kconfig  |  6 ++++++
>  drivers/net/phy/Makefile |  1 +
>  drivers/net/phy/xilinx.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 58 insertions(+)
>  create mode 100644 drivers/net/phy/xilinx.c
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index db5645b..101c794 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -462,6 +462,12 @@ config VITESSE_PHY
>  	---help---
>  	  Currently supports the vsc8244
>  
> +config XILINX_PHY
> +	tristate "Drivers for Xilinx PHYs"
> +	help
> +	  This module provides a driver for the PHY implemented in the
> +	  Xilinx PCS/PMA Core.
> +
>  config XILINX_GMII2RGMII
>  	tristate "Xilinx GMII2RGMII converter driver"
>  	---help---
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index bac339e..3ee9cdb 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -91,4 +91,5 @@ obj-$(CONFIG_SMSC_PHY)		+= smsc.o
>  obj-$(CONFIG_STE10XP)		+= ste10Xp.o
>  obj-$(CONFIG_TERANETICS_PHY)	+= teranetics.o
>  obj-$(CONFIG_VITESSE_PHY)	+= vitesse.o
> +obj-$(CONFIG_XILINX_PHY)	+= xilinx.o
>  obj-$(CONFIG_XILINX_GMII2RGMII) += xilinx_gmii2rgmii.o
> diff --git a/drivers/net/phy/xilinx.c b/drivers/net/phy/xilinx.c
> new file mode 100644
> index 0000000..0e5509b
> --- /dev/null
> +++ b/drivers/net/phy/xilinx.c
> @@ -0,0 +1,51 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/* Xilinx PCS/PMA Core phy driver
> + *
> + * Copyright (C) 2019 SED Systems, a division of Calian Ltd.
> + *
> + * Based upon Xilinx version of this driver:
> + * Copyright (C) 2015 Xilinx, Inc.
> + *
> + * Description:
> + * This driver is developed for PCS/PMA Core.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mii.h>
> +#include <linux/phy.h>
> +
> +/* Mask used for ID comparisons */
> +#define XILINX_PHY_ID_MASK		0xfffffff0
> +
> +/* Known PHY IDs */
> +#define XILINX_PHY_ID			0x01740c00
> +
> +static struct phy_driver xilinx_drivers[] = {
> +{
> +	.phy_id		= XILINX_PHY_ID,
> +	.phy_id_mask	= XILINX_PHY_ID_MASK,
> +	.name		= "Xilinx PCS/PMA PHY",

Please no slash in the name. This breaks sysfs.

> +	/* Xilinx PHY wrongly indicates BMSR_ESTATEN = 0 even though
> +	 * extended status registers are supported. So we force the PHY
> +	 * features to PHY_GBIT_FEATURES in order to allow gigabit support
> +	 * to be detected.
> +	 */
> +	.features	= PHY_GBIT_FEATURES,

BMSR_ESTATEN is used by genphy_config_advert() too. Means you would
need to implement your own config_aneg callback and basically
copy 99% of genphy_config_advert().

I think the better alternative is to implement a quirk flag in phylib
similar to PHY_RST_AFTER_CLK_EN. Let me come up with a proposal.

Last but not least: Not setting BMSR_ESTATEN for a GBit PHY violates
the standard. Any intention from Xilinx to fix this?

> +	.resume		= genphy_resume,
> +	.suspend	= genphy_suspend,
> +	.set_loopback   = genphy_loopback,
> +},
> +};
> +
> +module_phy_driver(xilinx_drivers);
> +
> +static struct mdio_device_id __maybe_unused xilinx_tbl[] = {
> +	{ XILINX_PHY_ID, XILINX_PHY_ID_MASK },
> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE(mdio, xilinx_tbl);
> +MODULE_DESCRIPTION("Xilinx PCS/PMA PHY driver");
> +MODULE_LICENSE("GPL");
> +
> 

