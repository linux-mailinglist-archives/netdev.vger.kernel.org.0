Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8F3B82669
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 22:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730714AbfHEUyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 16:54:12 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37686 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfHEUyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 16:54:11 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so60645143wrr.4;
        Mon, 05 Aug 2019 13:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/S9Kt+BqSQBovM2arBE72fycxozvSt0swdfnmydIKdo=;
        b=SX31o+rdeKsINkIpBra12M79BEKbgV/EiXclH6COaePnFGVBxEOH4xJb+bBIXIWfXY
         YRPkzYhlJbERDwq53rSVmDRPoeofeNvjqcy0U1pGdcxcGQ7CP9KbpfUbEzRHurF/8U02
         R9KDLZ6slFZ+30TlRfdr+rzbDyaciBNzgpVasRwjykHXFywRSc6oA2FrzJAjilXyuNDY
         FVpMf/MHFrswpRsJ2wuUHrIjS2MLmAGLtqjAPgAxq3cHcnrWcPNwow0TO9Rx0W2vS2rH
         KwIkPLT6ECnQ9juKvmSHTUNYpMe12WCQSpfUzmGTDEBMH5V11oRKdkB2zaQjOn4I3EwA
         Y3Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/S9Kt+BqSQBovM2arBE72fycxozvSt0swdfnmydIKdo=;
        b=je+3a05wvWzI8mkLsz1y8Scw0aNY67rR/qoiEAu2IrMDU/LB8d3Qrek42z8u+UTFjq
         6Pv51XFbTuVgdk3CplmckCJ6bteP4pd+bItFik/yA0VxapOtY+yF9xjcBDOLQ/0oplY+
         9ycHy72V0uhal8ue9T500k+03EOV0euvwbusCLwQdu6OQld6TJ9453jNs2uf7iHhe0bu
         OtBPplDpbEcXLNfPWZVPgo3FXTkk2cLAWw7KGx5aUeBXqR6TftG1afbEGj7exteQoKu6
         myylAcsifJDiuw62AvONPX6rjtwZL58SVwP9q91YXMhyhgdpGVDAn1Ky8sQarsyAp2zN
         pD7w==
X-Gm-Message-State: APjAAAX4FTa9XpCQ4ErO28J6ZBrZ3fbeAUaqytpp3zwZ3JXzEunFFSfo
        eYbQWLWdZDGV2QfNhWCyz98=
X-Google-Smtp-Source: APXvYqyFOzP2If6HCt51OFwBncPleleOR8TrpWuB7KQC0EFnq5gP0wtyhxQKu9XzqxW/HVbBfOvIsw==
X-Received: by 2002:a5d:4e8a:: with SMTP id e10mr49334wru.26.1565038449174;
        Mon, 05 Aug 2019 13:54:09 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f05:8600:d16c:62d1:98de:d1e5? (p200300EA8F058600D16C62D198DED1E5.dip0.t-ipconnect.de. [2003:ea:8f05:8600:d16c:62d1:98de:d1e5])
        by smtp.googlemail.com with ESMTPSA id c11sm145384717wrq.45.2019.08.05.13.54.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 13:54:08 -0700 (PDT)
Subject: Re: [PATCH 01/16] net: phy: adin: add support for Analog Devices PHYs
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        f.fainelli@gmail.com, andrew@lunn.ch
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
 <20190805165453.3989-2-alexandru.ardelean@analog.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <206ec97f-3115-9a2c-91a0-e5f7aec4a39e@gmail.com>
Date:   Mon, 5 Aug 2019 22:54:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805165453.3989-2-alexandru.ardelean@analog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.08.2019 18:54, Alexandru Ardelean wrote:
> This change adds support for Analog Devices Industrial Ethernet PHYs.
> Particularly the PHYs this driver adds support for:
>  * ADIN1200 - Robust, Industrial, Low Power 10/100 Ethernet PHY
>  * ADIN1300 - Robust, Industrial, Low Latency 10/100/1000 Gigabit
>    Ethernet PHY
> 
> The 2 chips are pin & register compatible with one another. The main
> difference being that ADIN1200 doesn't operate in gigabit mode.
> 
> The chips can be operated by the Generic PHY driver as well via the
> standard IEEE PHY registers (0x0000 - 0x000F) which are supported by the
> kernel as well. This assumes that configuration of the PHY has been done
> required.
> 
> Configuration can also be done via registers, which will be implemented by
> the driver in the next changes.
> 
> Datasheets:
>   https://www.analog.com/media/en/technical-documentation/data-sheets/ADIN1300.pdf
>   https://www.analog.com/media/en/technical-documentation/data-sheets/ADIN1200.pdf
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> ---
>  MAINTAINERS              |  7 +++++
>  drivers/net/phy/Kconfig  |  9 ++++++
>  drivers/net/phy/Makefile |  1 +
>  drivers/net/phy/adin.c   | 59 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 76 insertions(+)
>  create mode 100644 drivers/net/phy/adin.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ee663e0e2f2e..faf5723610c8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -938,6 +938,13 @@ S:	Supported
>  F:	drivers/mux/adgs1408.c
>  F:	Documentation/devicetree/bindings/mux/adi,adgs1408.txt
>  
> +ANALOG DEVICES INC ADIN DRIVER
> +M:	Alexandru Ardelean <alexaundru.ardelean@analog.com>
> +L:	netdev@vger.kernel.org
> +W:	http://ez.analog.com/community/linux-device-drivers
> +S:	Supported
> +F:	drivers/net/phy/adin.c
> +
>  ANALOG DEVICES INC ADIS DRIVER LIBRARY
>  M:	Alexandru Ardelean <alexandru.ardelean@analog.com>
>  S:	Supported
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 206d8650ee7f..5966d3413676 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -257,6 +257,15 @@ config SFP
>  	depends on HWMON || HWMON=n
>  	select MDIO_I2C
>  
> +config ADIN_PHY
> +	tristate "Analog Devices Industrial Ethernet PHYs"
> +	help
> +	  Adds support for the Analog Devices Industrial Ethernet PHYs.
> +	  Currently supports the:
> +	  - ADIN1200 - Robust,Industrial, Low Power 10/100 Ethernet PHY
> +	  - ADIN1300 - Robust,Industrial, Low Latency 10/100/1000 Gigabit
> +	    Ethernet PHY
> +
>  config AMD_PHY
>  	tristate "AMD PHYs"
>  	---help---
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index ba07c27e4208..a03437e091f3 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -47,6 +47,7 @@ obj-$(CONFIG_SFP)		+= sfp.o
>  sfp-obj-$(CONFIG_SFP)		+= sfp-bus.o
>  obj-y				+= $(sfp-obj-y) $(sfp-obj-m)
>  
> +obj-$(CONFIG_ADIN_PHY)		+= adin.o
>  obj-$(CONFIG_AMD_PHY)		+= amd.o
>  aquantia-objs			+= aquantia_main.o
>  ifdef CONFIG_HWMON
> diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
> new file mode 100644
> index 000000000000..6a610d4563c3
> --- /dev/null
> +++ b/drivers/net/phy/adin.c
> @@ -0,0 +1,59 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/**
> + *  Driver for Analog Devices Industrial Ethernet PHYs
> + *
> + * Copyright 2019 Analog Devices Inc.
> + */
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/mii.h>
> +#include <linux/phy.h>
> +
> +#define PHY_ID_ADIN1200				0x0283bc20
> +#define PHY_ID_ADIN1300				0x0283bc30
> +
> +static int adin_config_init(struct phy_device *phydev)
> +{
> +	int rc;
> +
> +	rc = genphy_config_init(phydev);
> +	if (rc < 0)
> +		return rc;
> +
> +	return 0;
> +}
> +
> +static struct phy_driver adin_driver[] = {
> +	{
> +		.phy_id		= PHY_ID_ADIN1200,

You could use PHY_ID_MATCH_MODEL here.

> +		.name		= "ADIN1200",
> +		.phy_id_mask	= 0xfffffff0,
> +		.features	= PHY_BASIC_FEATURES,

Setting features is deprecated, instead the get_features callback
should be implemented if the default genphy_read_abilities needs
to be extended / replaced. You say that the PHY's work with the
genphy driver, so I suppose the default feature detection is ok
in your case. Then you could simply remove setting "features".

> +		.config_init	= adin_config_init,
> +		.config_aneg	= genphy_config_aneg,
> +		.read_status	= genphy_read_status,
> +	},
> +	{
> +		.phy_id		= PHY_ID_ADIN1300,
> +		.name		= "ADIN1300",
> +		.phy_id_mask	= 0xfffffff0,
> +		.features	= PHY_GBIT_FEATURES,
> +		.config_init	= adin_config_init,
> +		.config_aneg	= genphy_config_aneg,
> +		.read_status	= genphy_read_status,
> +	},
> +};
> +
> +module_phy_driver(adin_driver);
> +
> +static struct mdio_device_id __maybe_unused adin_tbl[] = {
> +	{ PHY_ID_ADIN1200, 0xfffffff0 },
> +	{ PHY_ID_ADIN1300, 0xfffffff0 },

PHY_ID_MATCH_MODEL could be used here too.

> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE(mdio, adin_tbl);
> +MODULE_DESCRIPTION("Analog Devices Industrial Ethernet PHY driver");
> +MODULE_LICENSE("GPL");
> 

