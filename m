Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9A62C035A
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 11:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbgKWKcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 05:32:31 -0500
Received: from relay-us1.mymailcheap.com ([51.81.35.219]:45458 "EHLO
        relay-us1.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgKWKcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 05:32:31 -0500
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.248.207])
        by relay-us1.mymailcheap.com (Postfix) with ESMTPS id 526E320E8E
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 10:32:29 +0000 (UTC)
Received: from relay3.mymailcheap.com (relay3.mymailcheap.com [217.182.119.155])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 2EE03260EB;
        Mon, 23 Nov 2020 10:32:25 +0000 (UTC)
Received: from filter2.mymailcheap.com (filter2.mymailcheap.com [91.134.140.82])
        by relay3.mymailcheap.com (Postfix) with ESMTPS id DF77D3F1CC;
        Mon, 23 Nov 2020 11:32:22 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by filter2.mymailcheap.com (Postfix) with ESMTP id C28D52A510;
        Mon, 23 Nov 2020 11:32:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1606127542;
        bh=nR44s1ffX1zi1t1RClhq0lZgdzVFVuAyCQlMhZqex0M=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=IRGDagK5ZIjW2L4sw3HeKK4sdRF8ad/L16MFKp71XzIbhUNpHDsaCxTTavcRFwfAg
         iUCU4+Enp65c3preirZcY6BHeoprf/k5zFfK363EyiugdH8LGJ8d9zAIbAuXqzEtC/
         G3w7WAoIM7xs3m7TjlgCNH/AEaVkFfnrTxuOr75M=
X-Virus-Scanned: Debian amavisd-new at filter2.mymailcheap.com
Received: from filter2.mymailcheap.com ([127.0.0.1])
        by localhost (filter2.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id O56X_Rp9IBbD; Mon, 23 Nov 2020 11:32:21 +0100 (CET)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter2.mymailcheap.com (Postfix) with ESMTPS;
        Mon, 23 Nov 2020 11:32:21 +0100 (CET)
Received: from [213.133.102.83] (ml.mymailcheap.com [213.133.102.83])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 4194F41AB7;
        Mon, 23 Nov 2020 10:32:20 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="mcl9yEeh";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [192.168.1.203] (unknown [183.157.63.183])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 1CABB41BF5;
        Mon, 23 Nov 2020 10:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1606127527;
        bh=nR44s1ffX1zi1t1RClhq0lZgdzVFVuAyCQlMhZqex0M=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=mcl9yEehnp/jS7op42zY1Mu7tUivT4rqvq++2mSxgx3qWqFCCoNWqbF5Nl1vTtu7j
         H5D2NS1cF6goQi+4yZwUAC8flkQxl7LwCzJlCdHQYOm54xzo3pr787Sv/i3HirO35W
         sVYXFH6s1EkR0O2IwZzjJkW1s0wYRYGkrfaIv/RA=
Subject: Re: [PATCH] stmmac: pci: Add support for LS7A bridge chip
To:     lizhi01 <lizhi01@loongson.cn>, davem@davemloft.net,
        kuba@kernel.org, mcoquelin.stm32@gmail.com
Cc:     lixuefeng@loongson.com, gaojuxin@loongson.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <1606125828-15742-1-git-send-email-lizhi01@loongson.cn>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <38b7eede-18de-f37c-eed9-8b59c2daf3dd@flygoat.com>
Date:   Mon, 23 Nov 2020 18:31:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <1606125828-15742-1-git-send-email-lizhi01@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4194F41AB7
X-Spamd-Result: default: False [1.40 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[flygoat.com:s=default];
         MID_RHS_MATCH_FROM(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         R_SPF_SOFTFAIL(0.00)[~all];
         RECEIVED_SPAMHAUS_PBL(0.00)[183.157.63.183:received];
         ML_SERVERS(-3.10)[213.133.102.83];
         DKIM_TRACE(0.00)[flygoat.com:+];
         DMARC_POLICY_ALLOW(0.00)[flygoat.com,none];
         RCPT_COUNT_SEVEN(0.00)[8];
         DMARC_POLICY_ALLOW_WITH_FAILURES(0.00)[];
         FREEMAIL_TO(0.00)[loongson.cn,davemloft.net,kernel.org,gmail.com];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:213.133.96.0/19, country:DE];
         RCVD_COUNT_TWO(0.00)[2];
         SUSPICIOUS_RECIPS(1.50)[];
         HFILTER_HELO_BAREIP(3.00)[213.133.102.83,1]
X-Rspamd-Server: mail20.mymailcheap.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lizhi,

You didn't send the patch to any mail list, is this intentional?

在 2020/11/23 18:03, lizhi01 写道:
> Add gmac driver to support LS7A bridge chip.
>
> Signed-off-by: lizhi01 <lizhi01@loongson.cn>
> ---
>   arch/mips/configs/loongson3_defconfig              |   4 +-
>   drivers/net/ethernet/stmicro/stmmac/Kconfig        |   8 +
>   drivers/net/ethernet/stmicro/stmmac/Makefile       |   1 +
>   .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   | 194 +++++++++++++++++++++
>   4 files changed, 206 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
>
> diff --git a/arch/mips/configs/loongson3_defconfig b/arch/mips/configs/loongson3_defconfig
> index 38a817e..2e8d2be 100644
> --- a/arch/mips/configs/loongson3_defconfig
> +++ b/arch/mips/configs/loongson3_defconfig
> @@ -225,7 +225,9 @@ CONFIG_R8169=y
>   # CONFIG_NET_VENDOR_SILAN is not set
>   # CONFIG_NET_VENDOR_SIS is not set
>   # CONFIG_NET_VENDOR_SMSC is not set
> -# CONFIG_NET_VENDOR_STMICRO is not set
> +CONFIG_NET_VENDOR_STMICR=y
> +CONFIG_STMMAC_ETH=y
> +CONFIG_DWMAC_LOONGSON=y
>   # CONFIG_NET_VENDOR_SUN is not set
>   # CONFIG_NET_VENDOR_TEHUTI is not set
>   # CONFIG_NET_VENDOR_TI is not set
> diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> index 53f14c5..30117cb 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> @@ -230,6 +230,14 @@ config DWMAC_INTEL
>   	  This selects the Intel platform specific bus support for the
>   	  stmmac driver. This driver is used for Intel Quark/EHL/TGL.
>   
> +config DWMAC_LOONGSON
> +	tristate "Intel GMAC support"
> +	depends on STMMAC_ETH && PCI
> +	depends on COMMON_CLK
> +	help
> +	  This selects the Intel platform specific bus support for the
> +	  stmmac driver.

Intel ???

> +
>   config STMMAC_PCI
>   	tristate "STMMAC PCI bus support"
>   	depends on STMMAC_ETH && PCI
> diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
> index 24e6145..11ea4569 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/Makefile
> +++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
> @@ -34,4 +34,5 @@ dwmac-altr-socfpga-objs := altr_tse_pcs.o dwmac-socfpga.o
>   
>   obj-$(CONFIG_STMMAC_PCI)	+= stmmac-pci.o
>   obj-$(CONFIG_DWMAC_INTEL)	+= dwmac-intel.o
> +obj-$(CONFIG_DWMAC_LOONGSON)	+= dwmac-loongson.o
>   stmmac-pci-objs:= stmmac_pci.o
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
> new file mode 100644
> index 0000000..765412e
> --- /dev/null
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
> @@ -0,0 +1,194 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020, Loongson Corporation
> + */
> +
> +#include <linux/clk-provider.h>
> +#include <linux/pci.h>
> +#include <linux/dmi.h>
> +#include <linux/device.h>
> +#include <linux/of_irq.h>
> +#include "stmmac.h"
> +
> +struct stmmac_pci_info {
> +	int (*setup)(struct pci_dev *pdev, struct plat_stmmacenet_data *plat);
> +};
> +
> +static void common_default_data(struct plat_stmmacenet_data *plat)
> +{
> +	plat->clk_csr = 2;
> +	plat->has_gmac = 1;
> +	plat->force_sf_dma_mode = 1;
> +	
> +	plat->mdio_bus_data->needs_reset = true;
> +
> +	plat->multicast_filter_bins = HASH_TABLE_SIZE;
> +
> +	plat->unicast_filter_entries = 1;
> +
> +	plat->maxmtu = JUMBO_LEN;
> +
> +	plat->tx_queues_to_use = 1;
> +	plat->rx_queues_to_use = 1;
> +
> +	plat->tx_queues_cfg[0].use_prio = false;
> +	plat->rx_queues_cfg[0].use_prio = false;
> +
> +	plat->rx_queues_cfg[0].pkt_route = 0x0;
> +}
> +
> +static int loongson_default_data(struct pci_dev *pdev, struct plat_stmmacenet_data *plat)
> +{
> +	common_default_data(plat);
> +	
> +	plat->bus_id = pci_dev_id(pdev);
> +	plat->phy_addr = -1;
> +	plat->interface = PHY_INTERFACE_MODE_GMII;
> +
> +	plat->dma_cfg->pbl = 32;
> +	plat->dma_cfg->pblx8 = true;
> +
> +	plat->multicast_filter_bins = 256;
> +
> +	return 0;	
> +}


You can merge common and Loongson config as the driver is solely used by 
Loongson.

The callback is not necessary as well...


> +
> +static const struct stmmac_pci_info loongson_pci_info = {
> +	.setup = loongson_default_data,
> +};
> +
> +static int loongson_gmac_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	struct stmmac_pci_info *info = (struct stmmac_pci_info *)id->driver_data;
> +	struct plat_stmmacenet_data *plat;
> +	struct stmmac_resources res;
> +	int ret, i, lpi_irq;
> +	struct device_node *np;	
> +	
> +	plat = devm_kzalloc(&pdev->dev, sizeof(struct plat_stmmacenet_data), GFP_KERNEL);
> +	if (!plat)
> +		return -ENOMEM;
> +
> +	plat->mdio_bus_data = devm_kzalloc(&pdev->dev, sizeof(struct stmmac_mdio_bus_data), GFP_KERNEL);
> +	if (!plat->mdio_bus_data) {
> +		kfree(plat);
> +		return -ENOMEM;
> +	}
> +
> +	plat->dma_cfg = devm_kzalloc(&pdev->dev, sizeof(struct stmmac_dma_cfg), GFP_KERNEL);
> +	if (!plat->dma_cfg)	{
> +		kfree(plat);
> +		return -ENOMEM;
> +	}
> +
> +	ret = pci_enable_device(pdev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "%s: ERROR: failed to enable device\n", __func__);
> +		kfree(plat);
> +		return ret;
> +	}
> +
> +	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
> +		if (pci_resource_len(pdev, i) == 0)
> +			continue;
> +		ret = pcim_iomap_regions(pdev, BIT(0), pci_name(pdev));
> +		if (ret)
> +			return ret;
> +		break;
> +	}


The BAR order is fixed on Loongson so there is no need to check it one 
by one.

Simply use BAR0 instead.


> +
> +	pci_set_master(pdev);
> +
> +	ret = info->setup(pdev, plat);
> +	if (ret)
> +		return ret;
> +
> +	pci_enable_msi(pdev);
> +
> +	memset(&res, 0, sizeof(res));
> +	res.addr = pcim_iomap_table(pdev)[i];
> +	res.irq = pdev->irq;
> +	res.wol_irq = pdev->irq;	
> +
> +	np = dev_of_node(&pdev->dev);


Please check the node earlier and bailing out in case if there is no node.

Also you should get both IRQs via DT to avoid misordering.


> +	lpi_irq = of_irq_get_byname(np, "eth_lpi");
> +	res.lpi_irq = lpi_irq;
> +	
> +	return stmmac_dvr_probe(&pdev->dev, plat, &res);
> +}
> +
> +static void loongson_gmac_remove(struct pci_dev *pdev)
> +{
> +	int i;
> +	
> +	stmmac_dvr_remove(&pdev->dev);
> +	
> +	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
> +		if (pci_resource_len(pdev, i) == 0)
> +			continue;
> +		pcim_iounmap_regions(pdev, BIT(i));
> +		break;
> +	}
> +
> +	pci_disable_device(pdev);
> +}
> +
> +static int __maybe_unused loongson_eth_pci_suspend(struct device *dev)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	int ret;
> +
> +	ret = stmmac_suspend(dev);
> +	if (ret)
> +		return ret;
> +	
> +	ret = pci_save_state(pdev);
> +	if (ret)
> +		return ret;
> +
> +	pci_disable_device(pdev);
> +	pci_wake_from_d3(pdev, true);
> +	return 0;
> +}
> +
> +static int __maybe_unused loongson_eth_pci_resume(struct device *dev)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	int ret;
> +
> +	pci_restore_state(pdev);
> +	pci_set_power_state(pdev, PCI_D0);
> +
> +	ret = pci_enable_device(pdev);
> +	if (ret)
> +		return ret;
> +	
> +	pci_set_master(pdev);
> +	
> +	return stmmac_resume(dev);
> +}	
> +
> +static SIMPLE_DEV_PM_OPS(loongson_eth_pm_ops, loongson_eth_pci_suspend, loongson_eth_pci_resume);
> +
> +#define PCI_DEVICE_ID_LOONGSON_GMAC 0x7a03
> +
> +static const struct pci_device_id loongson_gmac_table[] = {
> +	{ PCI_DEVICE_DATA(LOONGSON, GMAC, &loongson_pci_info) },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(pci, loongson_gmac_table);
> +
> +struct pci_driver loongson_gmac_driver = {
> +	.name = "loongson gmac",
> +	.id_table = loongson_gmac_table,
> +	.probe = loongson_gmac_probe,
> +	.remove = loongson_gmac_remove,
> +	.driver = {
> +		.pm = &loongson_eth_pm_ops,
> +	},
> +};
> +
> +module_pci_driver(loongson_gmac_driver);
> +
> +MODULE_DESCRIPTION("Loongson DWMAC PCI driver");
> +MODULE_AUTHOR("Zhi Li <lizhi01@loongson.com>");
> +MODULE_LICENSE("GPL v2");


Thanks

- Jiaxun
