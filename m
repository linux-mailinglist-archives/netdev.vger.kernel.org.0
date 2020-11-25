Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4802C39C4
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 08:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbgKYHHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 02:07:49 -0500
Received: from mail.loongson.cn ([114.242.206.163]:50304 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726760AbgKYHHr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 02:07:47 -0500
Received: from [10.130.0.150] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9AxqtC4Ar5f+mwWAA--.36698S3;
        Wed, 25 Nov 2020 15:07:36 +0800 (CST)
Subject: Re: [PATCH] stmmac: pci: Add support for LS7A bridge chip
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>, davem@davemloft.net,
        kuba@kernel.org, mcoquelin.stm32@gmail.com
References: <1606125828-15742-1-git-send-email-lizhi01@loongson.cn>
 <38b7eede-18de-f37c-eed9-8b59c2daf3dd@flygoat.com>
Cc:     lixuefeng@loongson.com, gaojuxin@loongson.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
From:   Zhi Li <lizhi01@loongson.cn>
Message-ID: <a218ab75-4c0c-62bb-f5b9-a9d692d38880@loongson.cn>
Date:   Wed, 25 Nov 2020 15:07:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <38b7eede-18de-f37c-eed9-8b59c2daf3dd@flygoat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9AxqtC4Ar5f+mwWAA--.36698S3
X-Coremail-Antispam: 1UD129KBjvJXoW3JrykJF1UXFy5AF47KFWDCFg_yoWfXr4kpF
        Z5Aa98Gry8Xr1xKw1vqrWDXF90yrWftryj9rW7ta4a9Fyqyry0qFyDKrWUur97ArWDGF12
        v3WjkrsF9Fs8Ga7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9ab7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x2
        0xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18Mc
        Ij6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2
        V7IY0VAS07AlzVAYIcxG8wCY02Avz4vE14v_GF4l42xK82IYc2Ij64vIr41l4I8I3I0E4I
        kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
        WwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
        0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWr
        Zr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_Gr
        UvcSsGvfC2KfnxnUUI43ZEXa7IU8J3ktUUUUU==
X-CM-SenderInfo: xol2xxqqr6z05rqj20fqof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiaxun,

It's my fault, I didn't know to send mail to the mailing list.

We will discuss your suggestions and correct the errors in the code.

I will send a new patch to the mailing list.

Thanks.

-Lizhi


On 11/23/2020 06:31 PM, Jiaxun Yang wrote:
> Hi Lizhi,
>
> You didn't send the patch to any mail list, is this intentional?
>
> 在 2020/11/23 18:03, lizhi01 写道:
>> Add gmac driver to support LS7A bridge chip.
>>
>> Signed-off-by: lizhi01 <lizhi01@loongson.cn>
>> ---
>>   arch/mips/configs/loongson3_defconfig              |   4 +-
>>   drivers/net/ethernet/stmicro/stmmac/Kconfig        |   8 +
>>   drivers/net/ethernet/stmicro/stmmac/Makefile       |   1 +
>>   .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   | 194 
>> +++++++++++++++++++++
>>   4 files changed, 206 insertions(+), 1 deletion(-)
>>   create mode 100644 
>> drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
>>
>> diff --git a/arch/mips/configs/loongson3_defconfig 
>> b/arch/mips/configs/loongson3_defconfig
>> index 38a817e..2e8d2be 100644
>> --- a/arch/mips/configs/loongson3_defconfig
>> +++ b/arch/mips/configs/loongson3_defconfig
>> @@ -225,7 +225,9 @@ CONFIG_R8169=y
>>   # CONFIG_NET_VENDOR_SILAN is not set
>>   # CONFIG_NET_VENDOR_SIS is not set
>>   # CONFIG_NET_VENDOR_SMSC is not set
>> -# CONFIG_NET_VENDOR_STMICRO is not set
>> +CONFIG_NET_VENDOR_STMICR=y
>> +CONFIG_STMMAC_ETH=y
>> +CONFIG_DWMAC_LOONGSON=y
>>   # CONFIG_NET_VENDOR_SUN is not set
>>   # CONFIG_NET_VENDOR_TEHUTI is not set
>>   # CONFIG_NET_VENDOR_TI is not set
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig 
>> b/drivers/net/ethernet/stmicro/stmmac/Kconfig
>> index 53f14c5..30117cb 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
>> +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
>> @@ -230,6 +230,14 @@ config DWMAC_INTEL
>>         This selects the Intel platform specific bus support for the
>>         stmmac driver. This driver is used for Intel Quark/EHL/TGL.
>>   +config DWMAC_LOONGSON
>> +    tristate "Intel GMAC support"
>> +    depends on STMMAC_ETH && PCI
>> +    depends on COMMON_CLK
>> +    help
>> +      This selects the Intel platform specific bus support for the
>> +      stmmac driver.
>
> Intel ???
>
>> +
>>   config STMMAC_PCI
>>       tristate "STMMAC PCI bus support"
>>       depends on STMMAC_ETH && PCI
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile 
>> b/drivers/net/ethernet/stmicro/stmmac/Makefile
>> index 24e6145..11ea4569 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/Makefile
>> +++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
>> @@ -34,4 +34,5 @@ dwmac-altr-socfpga-objs := altr_tse_pcs.o 
>> dwmac-socfpga.o
>>     obj-$(CONFIG_STMMAC_PCI)    += stmmac-pci.o
>>   obj-$(CONFIG_DWMAC_INTEL)    += dwmac-intel.o
>> +obj-$(CONFIG_DWMAC_LOONGSON)    += dwmac-loongson.o
>>   stmmac-pci-objs:= stmmac_pci.o
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c 
>> b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
>> new file mode 100644
>> index 0000000..765412e
>> --- /dev/null
>> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
>> @@ -0,0 +1,194 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c) 2020, Loongson Corporation
>> + */
>> +
>> +#include <linux/clk-provider.h>
>> +#include <linux/pci.h>
>> +#include <linux/dmi.h>
>> +#include <linux/device.h>
>> +#include <linux/of_irq.h>
>> +#include "stmmac.h"
>> +
>> +struct stmmac_pci_info {
>> +    int (*setup)(struct pci_dev *pdev, struct plat_stmmacenet_data 
>> *plat);
>> +};
>> +
>> +static void common_default_data(struct plat_stmmacenet_data *plat)
>> +{
>> +    plat->clk_csr = 2;
>> +    plat->has_gmac = 1;
>> +    plat->force_sf_dma_mode = 1;
>> +
>> +    plat->mdio_bus_data->needs_reset = true;
>> +
>> +    plat->multicast_filter_bins = HASH_TABLE_SIZE;
>> +
>> +    plat->unicast_filter_entries = 1;
>> +
>> +    plat->maxmtu = JUMBO_LEN;
>> +
>> +    plat->tx_queues_to_use = 1;
>> +    plat->rx_queues_to_use = 1;
>> +
>> +    plat->tx_queues_cfg[0].use_prio = false;
>> +    plat->rx_queues_cfg[0].use_prio = false;
>> +
>> +    plat->rx_queues_cfg[0].pkt_route = 0x0;
>> +}
>> +
>> +static int loongson_default_data(struct pci_dev *pdev, struct 
>> plat_stmmacenet_data *plat)
>> +{
>> +    common_default_data(plat);
>> +
>> +    plat->bus_id = pci_dev_id(pdev);
>> +    plat->phy_addr = -1;
>> +    plat->interface = PHY_INTERFACE_MODE_GMII;
>> +
>> +    plat->dma_cfg->pbl = 32;
>> +    plat->dma_cfg->pblx8 = true;
>> +
>> +    plat->multicast_filter_bins = 256;
>> +
>> +    return 0;
>> +}
>
>
> You can merge common and Loongson config as the driver is solely used 
> by Loongson.
>
> The callback is not necessary as well...
>
>
>> +
>> +static const struct stmmac_pci_info loongson_pci_info = {
>> +    .setup = loongson_default_data,
>> +};
>> +
>> +static int loongson_gmac_probe(struct pci_dev *pdev, const struct 
>> pci_device_id *id)
>> +{
>> +    struct stmmac_pci_info *info = (struct stmmac_pci_info 
>> *)id->driver_data;
>> +    struct plat_stmmacenet_data *plat;
>> +    struct stmmac_resources res;
>> +    int ret, i, lpi_irq;
>> +    struct device_node *np;
>> +
>> +    plat = devm_kzalloc(&pdev->dev, sizeof(struct 
>> plat_stmmacenet_data), GFP_KERNEL);
>> +    if (!plat)
>> +        return -ENOMEM;
>> +
>> +    plat->mdio_bus_data = devm_kzalloc(&pdev->dev, sizeof(struct 
>> stmmac_mdio_bus_data), GFP_KERNEL);
>> +    if (!plat->mdio_bus_data) {
>> +        kfree(plat);
>> +        return -ENOMEM;
>> +    }
>> +
>> +    plat->dma_cfg = devm_kzalloc(&pdev->dev, sizeof(struct 
>> stmmac_dma_cfg), GFP_KERNEL);
>> +    if (!plat->dma_cfg)    {
>> +        kfree(plat);
>> +        return -ENOMEM;
>> +    }
>> +
>> +    ret = pci_enable_device(pdev);
>> +    if (ret) {
>> +        dev_err(&pdev->dev, "%s: ERROR: failed to enable device\n", 
>> __func__);
>> +        kfree(plat);
>> +        return ret;
>> +    }
>> +
>> +    for (i = 0; i < PCI_STD_NUM_BARS; i++) {
>> +        if (pci_resource_len(pdev, i) == 0)
>> +            continue;
>> +        ret = pcim_iomap_regions(pdev, BIT(0), pci_name(pdev));
>> +        if (ret)
>> +            return ret;
>> +        break;
>> +    }
>
>
> The BAR order is fixed on Loongson so there is no need to check it one 
> by one.
>
> Simply use BAR0 instead.
>
>
>> +
>> +    pci_set_master(pdev);
>> +
>> +    ret = info->setup(pdev, plat);
>> +    if (ret)
>> +        return ret;
>> +
>> +    pci_enable_msi(pdev);
>> +
>> +    memset(&res, 0, sizeof(res));
>> +    res.addr = pcim_iomap_table(pdev)[i];
>> +    res.irq = pdev->irq;
>> +    res.wol_irq = pdev->irq;
>> +
>> +    np = dev_of_node(&pdev->dev);
>
>
> Please check the node earlier and bailing out in case if there is no 
> node.
>
> Also you should get both IRQs via DT to avoid misordering.
>
>
>> +    lpi_irq = of_irq_get_byname(np, "eth_lpi");
>> +    res.lpi_irq = lpi_irq;
>> +
>> +    return stmmac_dvr_probe(&pdev->dev, plat, &res);
>> +}
>> +
>> +static void loongson_gmac_remove(struct pci_dev *pdev)
>> +{
>> +    int i;
>> +
>> +    stmmac_dvr_remove(&pdev->dev);
>> +
>> +    for (i = 0; i < PCI_STD_NUM_BARS; i++) {
>> +        if (pci_resource_len(pdev, i) == 0)
>> +            continue;
>> +        pcim_iounmap_regions(pdev, BIT(i));
>> +        break;
>> +    }
>> +
>> +    pci_disable_device(pdev);
>> +}
>> +
>> +static int __maybe_unused loongson_eth_pci_suspend(struct device *dev)
>> +{
>> +    struct pci_dev *pdev = to_pci_dev(dev);
>> +    int ret;
>> +
>> +    ret = stmmac_suspend(dev);
>> +    if (ret)
>> +        return ret;
>> +
>> +    ret = pci_save_state(pdev);
>> +    if (ret)
>> +        return ret;
>> +
>> +    pci_disable_device(pdev);
>> +    pci_wake_from_d3(pdev, true);
>> +    return 0;
>> +}
>> +
>> +static int __maybe_unused loongson_eth_pci_resume(struct device *dev)
>> +{
>> +    struct pci_dev *pdev = to_pci_dev(dev);
>> +    int ret;
>> +
>> +    pci_restore_state(pdev);
>> +    pci_set_power_state(pdev, PCI_D0);
>> +
>> +    ret = pci_enable_device(pdev);
>> +    if (ret)
>> +        return ret;
>> +
>> +    pci_set_master(pdev);
>> +
>> +    return stmmac_resume(dev);
>> +}
>> +
>> +static SIMPLE_DEV_PM_OPS(loongson_eth_pm_ops, 
>> loongson_eth_pci_suspend, loongson_eth_pci_resume);
>> +
>> +#define PCI_DEVICE_ID_LOONGSON_GMAC 0x7a03
>> +
>> +static const struct pci_device_id loongson_gmac_table[] = {
>> +    { PCI_DEVICE_DATA(LOONGSON, GMAC, &loongson_pci_info) },
>> +    {}
>> +};
>> +MODULE_DEVICE_TABLE(pci, loongson_gmac_table);
>> +
>> +struct pci_driver loongson_gmac_driver = {
>> +    .name = "loongson gmac",
>> +    .id_table = loongson_gmac_table,
>> +    .probe = loongson_gmac_probe,
>> +    .remove = loongson_gmac_remove,
>> +    .driver = {
>> +        .pm = &loongson_eth_pm_ops,
>> +    },
>> +};
>> +
>> +module_pci_driver(loongson_gmac_driver);
>> +
>> +MODULE_DESCRIPTION("Loongson DWMAC PCI driver");
>> +MODULE_AUTHOR("Zhi Li <lizhi01@loongson.com>");
>> +MODULE_LICENSE("GPL v2");
>
>
> Thanks
>
> - Jiaxun

