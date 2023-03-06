Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16966AB6D5
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 08:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCFHPf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 6 Mar 2023 02:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCFHPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 02:15:34 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3436CDE4;
        Sun,  5 Mar 2023 23:15:31 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id B8C3124E2B9;
        Mon,  6 Mar 2023 15:15:24 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 6 Mar
 2023 15:15:24 +0800
Received: from [192.168.120.42] (171.223.208.138) by EXMBX162.cuchost.com
 (172.16.6.72) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 6 Mar
 2023 15:15:23 +0800
Message-ID: <9c9bd26c-b548-1011-9025-ae95107551ba@starfivetech.com>
Date:   Mon, 6 Mar 2023 15:15:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 06/12] net: stmmac: Add glue layer for StarFive JH7110
 SoC
Content-Language: en-US
To:     Emil Renner Berthing <emil.renner.berthing@canonical.com>
CC:     <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
References: <20230303085928.4535-1-samin.guo@starfivetech.com>
 <20230303085928.4535-7-samin.guo@starfivetech.com>
 <CAJM55Z_Ze3mD4UVtUFTRYN_n6WnobcFB5evgYZi9zBRNR2dU4w@mail.gmail.com>
From:   Guo Samin <samin.guo@starfivetech.com>
In-Reply-To: <CAJM55Z_Ze3mD4UVtUFTRYN_n6WnobcFB5evgYZi9zBRNR2dU4w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2023/3/4 0:18:20, Emil Renner Berthing 写道:
> On Fri, 3 Mar 2023 at 10:01, Samin Guo <samin.guo@starfivetech.com> wrote:
>> This adds StarFive dwmac driver support on the StarFive JH7110 SoC.
>>
>> Co-developed-by: Emil Renner Berthing <kernel@esmil.dk>
>> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
>> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
>> ---
>>  MAINTAINERS                                   |   1 +
>>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |  12 ++
>>  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
>>  .../ethernet/stmicro/stmmac/dwmac-starfive.c  | 125 ++++++++++++++++++
>>  4 files changed, 139 insertions(+)
>>  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 4e236b7c7fd2..91a4f190c827 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -19916,6 +19916,7 @@ STARFIVE DWMAC GLUE LAYER
>>  M:     Emil Renner Berthing <kernel@esmil.dk>
>>  M:     Samin Guo <samin.guo@starfivetech.com>
>>  S:     Maintained
>> +F:     Documentation/devicetree/bindings/net/dwmac-starfive.c
>>  F:     Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
>>
>>  STARFIVE JH71X0 CLOCK DRIVERS
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
>> index f77511fe4e87..47fbccef9d04 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
>> +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
>> @@ -165,6 +165,18 @@ config DWMAC_SOCFPGA
>>           for the stmmac device driver. This driver is used for
>>           arria5 and cyclone5 FPGA SoCs.
>>
>> +config DWMAC_STARFIVE
>> +       tristate "StarFive dwmac support"
>> +       depends on OF  && (ARCH_STARFIVE || COMPILE_TEST)
> 
> There is an extra space between "OF" and "&&" here.
>
will drop it
> 
>> +       depends on STMMAC_ETH
> 
> It's not visible in this patch context, but this whole config option
> is surrounded by "if STMMAC_ETH" and "if STMMAC_PLATFORM", so "depends
> on STMMAC_ETH" should not be needed.
> 
will drop it.
>> +       default ARCH_STARFIVE
> 
> This driver is not required to boot the JH7110, so we should just
> default to building it as a module. Eg.
> default m if ARCH_STARFIVE

Yes, this driver is not required to boot the JH7110, but the network is a very basic module,
it seems that other dwmac-platforms have been compiled into the kernel instead of modules.

> 
>> +       help
>> +         Support for ethernet controllers on StarFive RISC-V SoCs
>> +
>> +         This selects the StarFive platform specific glue layer support for
>> +         the stmmac device driver. This driver is used for StarFive JH7110
>> +         ethernet controller.
>> +
>>  config DWMAC_STI
>>         tristate "STi GMAC support"
>>         default ARCH_STI
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
>> index 057e4bab5c08..8738fdbb4b2d 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/Makefile
>> +++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
>> @@ -23,6 +23,7 @@ obj-$(CONFIG_DWMAC_OXNAS)     += dwmac-oxnas.o
>>  obj-$(CONFIG_DWMAC_QCOM_ETHQOS)        += dwmac-qcom-ethqos.o
>>  obj-$(CONFIG_DWMAC_ROCKCHIP)   += dwmac-rk.o
>>  obj-$(CONFIG_DWMAC_SOCFPGA)    += dwmac-altr-socfpga.o
>> +obj-$(CONFIG_DWMAC_STARFIVE)   += dwmac-starfive.o
>>  obj-$(CONFIG_DWMAC_STI)                += dwmac-sti.o
>>  obj-$(CONFIG_DWMAC_STM32)      += dwmac-stm32.o
>>  obj-$(CONFIG_DWMAC_SUNXI)      += dwmac-sunxi.o
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
>> new file mode 100644
>> index 000000000000..566378306f67
>> --- /dev/null
>> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
>> @@ -0,0 +1,125 @@
>> +// SPDX-License-Identifier: GPL-2.0+
>> +/*
>> + * StarFive DWMAC platform driver
>> + *
>> + * Copyright (C) 2022 StarFive Technology Co., Ltd.
>> + * Copyright (C) 2022 Emil Renner Berthing <kernel@esmil.dk>
> 
> Sorry, after looking at my old git branches where this started as a
> driver for the JH7100 this should really be
> * Copyright (C) 2021 Emil Renner Berthing <kernel@esmil.dk>
> * Copyright (C) 2022 StarFive Technology Co., Ltd.
> 
OK, It should be.
>> + */
>> +
>> +#include <linux/of_device.h>
>> +
>> +#include "stmmac_platform.h"
>> +
>> +struct starfive_dwmac {
>> +       struct device *dev;
>> +       struct clk *clk_tx;
>> +       struct clk *clk_gtx;
> 
> This pointer is only set, but never read. Please remove it.
>>
>> +       bool tx_use_rgmii_rxin_clk;
>> +};
>> +
>> +static void starfive_eth_fix_mac_speed(void *priv, unsigned int speed)
> 
> This should be starfive_dwmac_fix_mac_speed for consistency.
> 
Sorry，I missed this, will fix next version.
>> +{
>> +       struct starfive_dwmac *dwmac = priv;
>> +       unsigned long rate;
>> +       int err;
>> +
>> +       /* Generally, the rgmii_tx clock is provided by the internal clock,
>> +        * which needs to match the corresponding clock frequency according
>> +        * to different speeds. If the rgmii_tx clock is provided by the
>> +        * external rgmii_rxin, there is no need to configure the clock
>> +        * internally, because rgmii_rxin will be adaptively adjusted.
>> +        */
>> +       if (dwmac->tx_use_rgmii_rxin_clk)
>> +               return;
> 
> If this function is only needed in certain situations, why not just
> set the plat_dat->fix_mac_speed callback when it is needed?
> 
Sounds good idea.
>> +       switch (speed) {
>> +       case SPEED_1000:
>> +               rate = 125000000;
>> +               break;
>> +       case SPEED_100:
>> +               rate = 25000000;
>> +               break;
>> +       case SPEED_10:
>> +               rate = 2500000;
>> +               break;
>> +       default:
>> +               dev_err(dwmac->dev, "invalid speed %u\n", speed);
>> +               break;
>> +       }
>> +
>> +       err = clk_set_rate(dwmac->clk_tx, rate);
>> +       if (err)
>> +               dev_err(dwmac->dev, "failed to set tx rate %lu\n", rate);
>> +}
>> +
>> +static int starfive_dwmac_probe(struct platform_device *pdev)
>> +{
>> +       struct plat_stmmacenet_data *plat_dat;
>> +       struct stmmac_resources stmmac_res;
>> +       struct starfive_dwmac *dwmac;
>> +       int err;
>> +
>> +       err = stmmac_get_platform_resources(pdev, &stmmac_res);
>> +       if (err)
>> +               return err;
>> +
>> +       plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
>> +       if (IS_ERR(plat_dat)) {
>> +               dev_err(&pdev->dev, "dt configuration failed\n");
>> +               return PTR_ERR(plat_dat);
>> +       }
>> +
>> +       dwmac = devm_kzalloc(&pdev->dev, sizeof(*dwmac), GFP_KERNEL);
>> +       if (!dwmac)
>> +               return -ENOMEM;
>> +
>> +       dwmac->clk_tx = devm_clk_get_enabled(&pdev->dev, "tx");
>> +       if (IS_ERR(dwmac->clk_tx))
>> +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_tx),
>> +                                   "error getting tx clock\n");
>> +
>> +       dwmac->clk_gtx = devm_clk_get_enabled(&pdev->dev, "gtx");
>> +       if (IS_ERR(dwmac->clk_gtx))
>> +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_gtx),
>> +                                   "error getting gtx clock\n");
>> +
>> +       if (device_property_read_bool(&pdev->dev, "starfive,tx-use-rgmii-clk"))
>> +               dwmac->tx_use_rgmii_rxin_clk = true;
>> +
>> +       dwmac->dev = &pdev->dev;
>> +       plat_dat->fix_mac_speed = starfive_eth_fix_mac_speed;
> 
> Eg.:
> if (!device_property_read_bool(&pdev->dev, "starfive,tx_use_rgmii_clk"))
>   plat_dat->fix_mac_speed = starfive_dwmac_fix_mac_speed;
> 
Good idea, so we can remove flag 'tx_use_rgmii_rxin_clk' in struct starfive_dwmac.
>> +       plat_dat->init = NULL;
>> +       plat_dat->bsp_priv = dwmac;
>> +       plat_dat->dma_cfg->dche = true;
>> +
>> +       err = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
>> +       if (err) {
>> +               stmmac_remove_config_dt(pdev, plat_dat);
>> +               return err;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static const struct of_device_id starfive_dwmac_match[] = {
>> +       { .compatible = "starfive,jh7110-dwmac" },
>> +       { /* sentinel */ }
>> +};
>> +MODULE_DEVICE_TABLE(of, starfive_dwmac_match);
>> +
>> +static struct platform_driver starfive_dwmac_driver = {
>> +       .probe  = starfive_dwmac_probe,
>> +       .remove = stmmac_pltfr_remove,
>> +       .driver = {
>> +               .name = "starfive-dwmac",
>> +               .pm = &stmmac_pltfr_pm_ops,
>> +               .of_match_table = starfive_dwmac_match,
>> +       },
>> +};
>> +module_platform_driver(starfive_dwmac_driver);
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_DESCRIPTION("StarFive DWMAC platform driver");
>> +MODULE_AUTHOR("Emil Renner Berthing <kernel@esmil.dk>");
>> +MODULE_AUTHOR("Samin Guo <samin.guo@starfivetech.com>");
>> --
>> 2.17.1
>>
>>
>> _______________________________________________
>> linux-riscv mailing list
>> linux-riscv@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-riscv
Best regards,
Samin

-- 
Best regards,
Samin
