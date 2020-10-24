Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348E4297CFD
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 17:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760373AbgJXPEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 11:04:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26973 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758455AbgJXPED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Oct 2020 11:04:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603551840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H9MFfO8od2aiFCz3CMwI5BriTDlUJh0SREwJpQ4f9ng=;
        b=iLHRrqiL6vRRwDcgAYyYvXid7oRUYLhVqptyiwJCy0ilWuOJSBF72tlAAWUqd29VQzLvtN
        j9/G7fGER6AGyU9ItR7x2QcZ8QSHoB2HL60a+QASCxSgSS8rlPgaLJb391j8bvqkkzQN59
        GSgLHITSmK0i06DaO5CEwVt1P4GSEzA=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-8VvebVbNPfy-TRbGhC6b2w-1; Sat, 24 Oct 2020 11:03:55 -0400
X-MC-Unique: 8VvebVbNPfy-TRbGhC6b2w-1
Received: by mail-oi1-f199.google.com with SMTP id r83so3254408oia.19
        for <netdev@vger.kernel.org>; Sat, 24 Oct 2020 08:03:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=H9MFfO8od2aiFCz3CMwI5BriTDlUJh0SREwJpQ4f9ng=;
        b=hvBf2ouunhQF2iAnvUlFanlArVUjFiHyOJ7qJv+BtaINwoTj6tqpaz2zKBWACD2q0b
         xe3ISHISjsr8ruX42Wznl82umU8ll7inxTs7t8QXk5hRbyg9ww+qoMTgzoFNGZ/UZkxU
         gMywKOHSYFaSOi72qxJfSiUwDx6cO0SBM+MPDGzjTyshNTQYKKFSKx/hWp2aF9fuTe4b
         K7rGIJH+aHxMVV2xaKLZd/5+BGZdgTpcTsStOxYHROSAI9CTd9xmJbYLG7xQtNfOEplM
         ql8+3JC9CwQWDgbMJaa3J4j+JmMQFd46hKL/19HiRgoJIaNf2DrxG3MHc01tJXyMKFKy
         PJPQ==
X-Gm-Message-State: AOAM531iaA1zVRntWBIWNpR1eWNeB38tlr4/5f+2nVOObANyN1HqE+3e
        OlavOUGTTSHwhLrzrHhYRWFApwdFx8bSkgrEUvH9orHT5hPmUqXTH7BaC9Q23sblkDgRd5LE6wA
        kCcZQeTtKbPdCnwBD
X-Received: by 2002:aca:f557:: with SMTP id t84mr5127862oih.13.1603551834790;
        Sat, 24 Oct 2020 08:03:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxekjvzUfY2oWS++ceFKMHvtDCgNIiUJNJXWgfcROoUeFyKHxSbDVw1kQoSKAy1bq9C/M3oaQ==
X-Received: by 2002:aca:f557:: with SMTP id t84mr5127820oih.13.1603551834447;
        Sat, 24 Oct 2020 08:03:54 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id f2sm1268532ots.64.2020.10.24.08.03.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Oct 2020 08:03:53 -0700 (PDT)
Subject: Re: [RFC PATCH 4/6] ethernet: m10-retimer: add support for retimers
 on Intel MAX 10 BMC
To:     Xu Yilun <yilun.xu@intel.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        mdf@kernel.org, lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, linux-fpga@vger.kernel.org,
        netdev@vger.kernel.org, lgoncalv@redhat.com, hao.wu@intel.com
References: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
 <1603442745-13085-5-git-send-email-yilun.xu@intel.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <dbc77c18-8076-bcfd-b4f7-03e62dc46a97@redhat.com>
Date:   Sat, 24 Oct 2020 08:03:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1603442745-13085-5-git-send-email-yilun.xu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/23/20 1:45 AM, Xu Yilun wrote:
> This driver supports the ethernet retimers (Parkvale) for the Intel PAC
> (Programmable Acceleration Card) N3000, which is a FPGA based Smart NIC.

Parkvale is a code name, it would be better if the public name was used.

As this is a physical chip that could be used on other cards,

I think the generic parts should be split out of intel-m10-bmc-retimer.c

into a separate file, maybe retimer-c827.c

Tom

>
> Parkvale is an Intel(R) Ethernet serdes transceiver chip that supports up
> to 100G transfer. On Intel PAC N3000 there are 2 Parkvale chips managed
> by the Intel MAX 10 BMC firmware. They are configured in 4 ports 10G/25G
> retimer mode. Host could query their link status via retimer interfaces
> (Shared registers) on Intel MAX 10 BMC.
>
> The driver adds the phy device for each port of the 2 retimer chips.
> Since the phys are not accessed by the real MDIO bus, it creates a virtual
> mdio bus for each NIC device instance, and a dedicated phy driver which
> only provides the supported features and link state.
>
> A DFL Ether Group driver will create net devices and connect to these
> phys.
>
> Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> ---
>  drivers/fpga/dfl-n3000-nios.c                      |  11 +-
>  drivers/mfd/intel-m10-bmc.c                        |  18 ++
>  drivers/net/ethernet/intel/Kconfig                 |  12 ++
>  drivers/net/ethernet/intel/Makefile                |   2 +
>  drivers/net/ethernet/intel/intel-m10-bmc-retimer.c | 229 +++++++++++++++++++++
>  include/linux/mfd/intel-m10-bmc.h                  |  16 ++
>  6 files changed, 286 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/net/ethernet/intel/intel-m10-bmc-retimer.c
>
> diff --git a/drivers/fpga/dfl-n3000-nios.c b/drivers/fpga/dfl-n3000-nios.c
> index 4983a2b..096931a 100644
> --- a/drivers/fpga/dfl-n3000-nios.c
> +++ b/drivers/fpga/dfl-n3000-nios.c
> @@ -16,6 +16,7 @@
>  #include <linux/io-64-nonatomic-lo-hi.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/mfd/intel-m10-bmc.h>
>  #include <linux/platform_device.h>
>  #include <linux/regmap.h>
>  #include <linux/stddef.h>
> @@ -159,6 +160,8 @@ struct n3000_nios {
>  	struct regmap *regmap;
>  	struct device *dev;
>  	struct platform_device *altera_spi;
> +	struct intel_m10bmc_platdata m10bmc_pdata;
> +	struct intel_m10bmc_retimer_pdata m10bmc_retimer_pdata;
>  };
>  
>  static ssize_t nios_fw_version_show(struct device *dev,
> @@ -412,7 +415,8 @@ static struct spi_board_info m10_n3000_info = {
>  	.chip_select = 0,
>  };
>  
> -static int create_altera_spi_controller(struct n3000_nios *nn)
> +static int create_altera_spi_controller(struct n3000_nios *nn,
> +					struct device *retimer_master)
>  {
>  	struct altera_spi_platform_data pdata = { 0 };
>  	struct platform_device_info pdevinfo = { 0 };
> @@ -431,6 +435,9 @@ static int create_altera_spi_controller(struct n3000_nios *nn)
>  	pdata.bits_per_word_mask =
>  		SPI_BPW_RANGE_MASK(1, FIELD_GET(N3000_NS_PARAM_DATA_WIDTH, v));
>  
> +	nn->m10bmc_retimer_pdata.retimer_master = retimer_master;
> +	nn->m10bmc_pdata.retimer = &nn->m10bmc_retimer_pdata;
> +	m10_n3000_info.platform_data = &nn->m10bmc_pdata;
>  	pdata.num_devices = 1;
>  	pdata.devices = &m10_n3000_info;
>  
> @@ -549,7 +556,7 @@ static int n3000_nios_probe(struct dfl_device *ddev)
>  	if (ret)
>  		return ret;
>  
> -	ret = create_altera_spi_controller(nn);
> +	ret = create_altera_spi_controller(nn, dfl_dev_get_base_dev(ddev));
>  	if (ret)
>  		dev_err(dev, "altera spi controller create failed: %d\n", ret);
>  
> diff --git a/drivers/mfd/intel-m10-bmc.c b/drivers/mfd/intel-m10-bmc.c
> index b84579b..adbfb177 100644
> --- a/drivers/mfd/intel-m10-bmc.c
> +++ b/drivers/mfd/intel-m10-bmc.c
> @@ -23,6 +23,21 @@ static struct mfd_cell m10bmc_pacn3000_subdevs[] = {
>  	{ .name = "n3000bmc-secure" },
>  };
>  
> +static void
> +m10bmc_init_cells_platdata(struct intel_m10bmc_platdata *pdata,
> +			   struct mfd_cell *cells, int n_cell)
> +{
> +	int i;
> +
> +	for (i = 0; i < n_cell; i++) {
> +		if (!strcmp(cells[i].name, "n3000bmc-retimer")) {
> +			cells[i].platform_data = pdata->retimer;
> +			cells[i].pdata_size =
> +				pdata->retimer ? sizeof(*pdata->retimer) : 0;
> +		}
> +	}
> +}
> +
>  static struct regmap_config intel_m10bmc_regmap_config = {
>  	.reg_bits = 32,
>  	.val_bits = 32,
> @@ -97,6 +112,7 @@ static int check_m10bmc_version(struct intel_m10bmc *ddata)
>  
>  static int intel_m10_bmc_spi_probe(struct spi_device *spi)
>  {
> +	struct intel_m10bmc_platdata *pdata = dev_get_platdata(&spi->dev);
>  	const struct spi_device_id *id = spi_get_device_id(spi);
>  	struct device *dev = &spi->dev;
>  	struct mfd_cell *cells;
> @@ -134,6 +150,8 @@ static int intel_m10_bmc_spi_probe(struct spi_device *spi)
>  		return -ENODEV;
>  	}
>  
> +	m10bmc_init_cells_platdata(pdata, cells, n_cell);
> +
>  	ret = devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, cells, n_cell,
>  				   NULL, 0, NULL);
>  	if (ret)
> diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
> index 5aa8631..81c43d4 100644
> --- a/drivers/net/ethernet/intel/Kconfig
> +++ b/drivers/net/ethernet/intel/Kconfig
> @@ -343,4 +343,16 @@ config IGC
>  	  To compile this driver as a module, choose M here. The module
>  	  will be called igc.
>  
> +config INTEL_M10_BMC_RETIMER
> +	tristate "Intel(R) MAX 10 BMC ethernet retimer support"
> +	depends on MFD_INTEL_M10_BMC
> +	select PHYLIB
> +        help
> +          This driver supports the ethernet retimer (Parkvale) on
> +	  Intel(R) MAX 10 BMC, which is used by Intel PAC N3000 FPGA based
> +	  Smart NIC.
> +
> +	  To compile this driver as a module, choose M here. The module
> +	  will be called intel-m10-bmc-retimer.
> +
>  endif # NET_VENDOR_INTEL
> diff --git a/drivers/net/ethernet/intel/Makefile b/drivers/net/ethernet/intel/Makefile
> index 3075290..5965447 100644
> --- a/drivers/net/ethernet/intel/Makefile
> +++ b/drivers/net/ethernet/intel/Makefile
> @@ -16,3 +16,5 @@ obj-$(CONFIG_IXGB) += ixgb/
>  obj-$(CONFIG_IAVF) += iavf/
>  obj-$(CONFIG_FM10K) += fm10k/
>  obj-$(CONFIG_ICE) += ice/
> +
> +obj-$(CONFIG_INTEL_M10_BMC_RETIMER) += intel-m10-bmc-retimer.o
> diff --git a/drivers/net/ethernet/intel/intel-m10-bmc-retimer.c b/drivers/net/ethernet/intel/intel-m10-bmc-retimer.c
> new file mode 100644
> index 0000000..c7b0558
> --- /dev/null
> +++ b/drivers/net/ethernet/intel/intel-m10-bmc-retimer.c
> @@ -0,0 +1,229 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Intel Max10 BMC Retimer Interface Driver
> + *
> + * Copyright (C) 2018-2020 Intel Corporation. All rights reserved.
> + *
> + */
> +#include <linux/device.h>
> +#include <linux/mfd/intel-m10-bmc.h>
> +#include <linux/module.h>
> +#include <linux/phy.h>
> +#include <linux/platform_device.h>
> +
> +#define NUM_CHIP	2
> +#define MAX_LINK	4
> +
> +#define BITS_MASK(nbits)	((1 << (nbits)) - 1)
> +
> +#define N3000BMC_RETIMER_DEV_NAME "n3000bmc-retimer"
> +#define M10BMC_RETIMER_MII_NAME "m10bmc retimer mii"
> +
> +struct m10bmc_retimer {
> +	struct device *dev;
> +	struct intel_m10bmc *m10bmc;
> +	int num_devs;
> +	struct device *base_dev;
> +	struct mii_bus *retimer_mii_bus;
> +};
> +
> +#define RETIMER_LINK_STAT_BIT(retimer_id, link_id) \
> +	BIT(((retimer_id) << 2) + (link_id))
> +
> +static u32 retimer_get_link(struct m10bmc_retimer *retimer, int index)
> +{
> +	unsigned int val;
> +
> +	if (m10bmc_sys_read(retimer->m10bmc, PKVL_LINK_STATUS, &val)) {
> +		dev_err(retimer->dev, "fail to read PKVL_LINK_STATUS\n");
> +		return 0;
> +	}
> +
> +	if (val & BIT(index))
> +		return 1;
> +
> +	return 0;
> +}
> +
> +static int m10bmc_retimer_phy_match(struct phy_device *phydev)
> +{
> +	if (phydev->mdio.bus->name &&
> +	    !strcmp(phydev->mdio.bus->name, M10BMC_RETIMER_MII_NAME)) {
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int m10bmc_retimer_phy_probe(struct phy_device *phydev)
> +{
> +	struct m10bmc_retimer *retimer = phydev->mdio.bus->priv;
> +
> +	phydev->priv = retimer;
> +
> +	return 0;
> +}
> +
> +static void m10bmc_retimer_phy_remove(struct phy_device *phydev)
> +{
> +	if (phydev->attached_dev)
> +		phy_disconnect(phydev);
> +}
> +
> +static int m10bmc_retimer_read_status(struct phy_device *phydev)
> +{
> +	struct m10bmc_retimer *retimer = phydev->priv;
> +
> +	phydev->link = retimer_get_link(retimer, phydev->mdio.addr);
> +
> +	phydev->duplex = DUPLEX_FULL;
> +
> +	return 0;
> +}
> +
> +static int m10bmc_retimer_get_features(struct phy_device *phydev)
> +{
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
> +			 phydev->supported);
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
> +			 phydev->supported);
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseLR_Full_BIT,
> +			 phydev->supported);
> +
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
> +			 phydev->supported);
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
> +			 phydev->supported);
> +
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
> +			 phydev->supported);
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
> +			 phydev->supported);
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
> +			 phydev->supported);
> +
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, phydev->supported);
> +
> +	return 0;
> +}
> +
> +static struct phy_driver m10bmc_retimer_phy_driver = {
> +	.phy_id			= 0xffffffff,
> +	.phy_id_mask		= 0xffffffff,
> +	.name			= "m10bmc retimer PHY",
> +	.match_phy_device	= m10bmc_retimer_phy_match,
> +	.probe			= m10bmc_retimer_phy_probe,
> +	.remove			= m10bmc_retimer_phy_remove,
> +	.read_status		= m10bmc_retimer_read_status,
> +	.get_features		= m10bmc_retimer_get_features,
> +	.read_mmd		= genphy_read_mmd_unsupported,
> +	.write_mmd		= genphy_write_mmd_unsupported,
> +};
> +
> +static int m10bmc_retimer_read(struct mii_bus *bus, int addr, int regnum)
> +{
> +	struct m10bmc_retimer *retimer = bus->priv;
> +
> +	if (addr < retimer->num_devs &&
> +	    (regnum == MII_PHYSID1 || regnum == MII_PHYSID2))
> +		return 0;
> +
> +	return 0xffff;
> +}
> +
> +static int m10bmc_retimer_write(struct mii_bus *bus, int addr, int regnum, u16 val)
> +{
> +	return 0;
> +}
> +
> +static int m10bmc_retimer_mii_bus_init(struct m10bmc_retimer *retimer)
> +{
> +	struct mii_bus *bus;
> +	int ret;
> +
> +	bus = devm_mdiobus_alloc(retimer->dev);
> +	if (!bus)
> +		return -ENOMEM;
> +
> +	bus->priv = (void *)retimer;
> +	bus->name = M10BMC_RETIMER_MII_NAME;
> +	bus->read = m10bmc_retimer_read;
> +	bus->write = m10bmc_retimer_write;
> +	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mii",
> +		 dev_name(retimer->base_dev));
> +	bus->parent = retimer->dev;
> +	bus->phy_mask = ~(BITS_MASK(retimer->num_devs));
> +
> +	ret = mdiobus_register(bus);
> +	if (ret)
> +		return ret;
> +
> +	retimer->retimer_mii_bus = bus;
> +
> +	return 0;
> +}
> +
> +static void m10bmc_retimer_mii_bus_uinit(struct m10bmc_retimer *retimer)
> +{
> +	mdiobus_unregister(retimer->retimer_mii_bus);
> +}
> +
> +static int intel_m10bmc_retimer_probe(struct platform_device *pdev)
> +{
> +	struct intel_m10bmc_retimer_pdata *pdata = dev_get_platdata(&pdev->dev);
> +	struct intel_m10bmc *m10bmc = dev_get_drvdata(pdev->dev.parent);
> +	struct m10bmc_retimer *retimer;
> +
> +	retimer = devm_kzalloc(&pdev->dev, sizeof(*retimer), GFP_KERNEL);
> +	if (!retimer)
> +		return -ENOMEM;
> +
> +	dev_set_drvdata(&pdev->dev, retimer);
> +
> +	retimer->dev = &pdev->dev;
> +	retimer->m10bmc = m10bmc;
> +	retimer->base_dev = pdata->retimer_master;
> +	retimer->num_devs = NUM_CHIP * MAX_LINK;
> +
> +	return m10bmc_retimer_mii_bus_init(retimer);
> +}
> +
> +static int intel_m10bmc_retimer_remove(struct platform_device *pdev)
> +{
> +	struct m10bmc_retimer *retimer = dev_get_drvdata(&pdev->dev);
> +
> +	m10bmc_retimer_mii_bus_uinit(retimer);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver intel_m10bmc_retimer_driver = {
> +	.probe = intel_m10bmc_retimer_probe,
> +	.remove = intel_m10bmc_retimer_remove,
> +	.driver = {
> +		.name = N3000BMC_RETIMER_DEV_NAME,
> +	},
> +};
> +
> +static int __init intel_m10bmc_retimer_init(void)
> +{
> +	int ret;
> +
> +	ret = phy_driver_register(&m10bmc_retimer_phy_driver, THIS_MODULE);
> +	if (ret)
> +		return ret;
> +
> +	return platform_driver_register(&intel_m10bmc_retimer_driver);
> +}
> +module_init(intel_m10bmc_retimer_init);
> +
> +static void __exit intel_m10bmc_retimer_exit(void)
> +{
> +	platform_driver_unregister(&intel_m10bmc_retimer_driver);
> +	phy_driver_unregister(&m10bmc_retimer_phy_driver);
> +}
> +module_exit(intel_m10bmc_retimer_exit);
> +
> +MODULE_ALIAS("platform:" N3000BMC_RETIMER_DEV_NAME);
> +MODULE_AUTHOR("Intel Corporation");
> +MODULE_DESCRIPTION("Intel MAX 10 BMC retimer driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/mfd/intel-m10-bmc.h b/include/linux/mfd/intel-m10-bmc.h
> index c8ef2f1..3d9d22c 100644
> --- a/include/linux/mfd/intel-m10-bmc.h
> +++ b/include/linux/mfd/intel-m10-bmc.h
> @@ -21,6 +21,22 @@
>  #define M10BMC_VER_PCB_INFO_MSK		GENMASK(31, 24)
>  #define M10BMC_VER_LEGACY_INVALID	0xffffffff
>  
> +/* PKVL related registers, in system register region */
> +#define PKVL_LINK_STATUS		0x164
> +
> +/**
> + * struct intel_m10bmc_retimer_pdata - subdev retimer platform data
> + *
> + * @retimer_master: the NIC device which connects to the retimers on m10bmc
> + */
> +struct intel_m10bmc_retimer_pdata {
> +	struct device *retimer_master;
> +};
> +
> +struct intel_m10bmc_platdata {
> +	struct intel_m10bmc_retimer_pdata *retimer;
> +};
> +
>  /**
>   * struct intel_m10bmc - Intel MAX 10 BMC parent driver data structure
>   * @dev: this device

