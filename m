Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D7569D877
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 03:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbjBUC15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 21:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbjBUC14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 21:27:56 -0500
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99B922013;
        Mon, 20 Feb 2023 18:27:47 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 338E624E202;
        Tue, 21 Feb 2023 10:27:18 +0800 (CST)
Received: from EXMBX073.cuchost.com (172.16.6.83) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 21 Feb
 2023 10:27:07 +0800
Received: from [192.168.120.49] (171.223.208.138) by EXMBX073.cuchost.com
 (172.16.6.83) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 21 Feb
 2023 10:27:06 +0800
Message-ID: <dfddde90-ddce-d0e5-d31c-bbbbecaf7323@starfivetech.com>
Date:   Tue, 21 Feb 2023 10:27:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v4 5/7] net: stmmac: Add glue layer for StarFive JH7110
 SoCs
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
        Peter Geis <pgwipeout@gmail.com>, <samin.guo@starfivetech.com>
References: <20230118061701.30047-1-yanhong.wang@starfivetech.com>
 <20230118061701.30047-6-yanhong.wang@starfivetech.com>
 <CAJM55Z-zvb5CJq4PU4c=YKvY0xPY216MAALFsmWTcVFjSd=wEA@mail.gmail.com>
From:   yanhong wang <yanhong.wang@starfivetech.com>
In-Reply-To: <CAJM55Z-zvb5CJq4PU4c=YKvY0xPY216MAALFsmWTcVFjSd=wEA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS062.cuchost.com (172.16.6.22) To EXMBX073.cuchost.com
 (172.16.6.83)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add  samin.guo@starfivetech.com  to loop.

On 2023/2/16 18:53, Emil Renner Berthing wrote:
> On Wed, 18 Jan 2023 at 07:20, Yanhong Wang
> <yanhong.wang@starfivetech.com> wrote:
>>
>> This adds StarFive dwmac driver support on the StarFive JH7110 SoCs.
>>
>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>> Co-developed-by: Emil Renner Berthing <kernel@esmil.dk>
>> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
>> ---
>>  MAINTAINERS                                   |   1 +
>>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |  12 ++
>>  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
>>  .../stmicro/stmmac/dwmac-starfive-plat.c      | 118 ++++++++++++++++++
>>  4 files changed, 132 insertions(+)
>>  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 56be59bb09f7..5b50b52d3dbb 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -19609,6 +19609,7 @@ F:      include/dt-bindings/clock/starfive*
>>  STARFIVE DWMAC GLUE LAYER
>>  M:     Yanhong Wang <yanhong.wang@starfivetech.com>
>>  S:     Maintained
>> +F:     Documentation/devicetree/bindings/net/dwmac-starfive-plat.c
>>  F:     Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
>>
>>  STARFIVE PINCTRL DRIVER
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
>> index 31ff35174034..f9a4ad4abd54 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
>> +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
>> @@ -235,6 +235,18 @@ config DWMAC_INTEL_PLAT
>>           the stmmac device driver. This driver is used for the Intel Keem Bay
>>           SoC.
>>
>> +config DWMAC_STARFIVE_PLAT
>> +       tristate "StarFive dwmac support"
>> +       depends on OF && COMMON_CLK
>> +       depends on STMMAC_ETH
>> +       default SOC_STARFIVE
>> +       help
>> +         Support for ethernet controllers on StarFive RISC-V SoCs
>> +
>> +         This selects the StarFive platform specific glue layer support for
>> +         the stmmac device driver. This driver is used for StarFive JH7110
>> +         ethernet controller.
>> +
>>  config DWMAC_VISCONTI
>>         tristate "Toshiba Visconti DWMAC support"
>>         default ARCH_VISCONTI
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
>> index d4e12e9ace4f..a63ab0ab5071 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/Makefile
>> +++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
>> @@ -31,6 +31,7 @@ obj-$(CONFIG_DWMAC_DWC_QOS_ETH)       += dwmac-dwc-qos-eth.o
>>  obj-$(CONFIG_DWMAC_INTEL_PLAT) += dwmac-intel-plat.o
>>  obj-$(CONFIG_DWMAC_GENERIC)    += dwmac-generic.o
>>  obj-$(CONFIG_DWMAC_IMX8)       += dwmac-imx.o
>> +obj-$(CONFIG_DWMAC_STARFIVE_PLAT)      += dwmac-starfive-plat.o
> 
> Hi Yanhong,
> 
> For the next version could you please drop the _PLAT from the config
> symbol and -plat from filename. I know the intel wrapper does the
> same, but it's the only one, so lets do like the majority of other
> wrappers and not add more different ways of doing things.
> 

Thanks. I will fix.

>>  obj-$(CONFIG_DWMAC_VISCONTI)   += dwmac-visconti.o
>>  stmmac-platform-objs:= stmmac_platform.o
>>  dwmac-altr-socfpga-objs := altr_tse_pcs.o dwmac-socfpga.o
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c
>> new file mode 100644
>> index 000000000000..e441d920933a
>> --- /dev/null
>> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c
>> @@ -0,0 +1,118 @@
>> +// SPDX-License-Identifier: GPL-2.0+
>> +/*
>> + * StarFive DWMAC platform driver
>> + *
>> + * Copyright(C) 2022 StarFive Technology Co., Ltd.
>> + *
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
>> +       struct clk *clk_gtxc;
>> +};
> 
> I like this name. For the next version could you also
> s/starfive_eth_plat_/starfive_dwmac_/ on the function/struct names
> below for consistency.
> 

I will fix.

>> +
>> +static void starfive_eth_plat_fix_mac_speed(void *priv, unsigned int speed)
>> +{
>> +       struct starfive_dwmac *dwmac = priv;
>> +       unsigned long rate;
>> +       int err;
>> +
>> +       rate = clk_get_rate(dwmac->clk_gtx);
>> +
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
>> +       err = clk_set_rate(dwmac->clk_gtx, rate);
>> +       if (err)
>> +               dev_err(dwmac->dev, "failed to set tx rate %lu\n", rate);
>> +}
>> +
>> +static int starfive_eth_plat_probe(struct platform_device *pdev)
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
>> +                                               "error getting tx clock\n");
>> +
>> +       dwmac->clk_gtx = devm_clk_get_enabled(&pdev->dev, "gtx");
>> +       if (IS_ERR(dwmac->clk_gtx))
>> +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_gtx),
>> +                                               "error getting gtx clock\n");
>> +
>> +       dwmac->clk_gtxc = devm_clk_get_enabled(&pdev->dev, "gtxc");
>> +       if (IS_ERR(dwmac->clk_gtxc))
>> +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_gtxc),
>> +                                               "error getting gtxc clock\n");
>> +
>> +       dwmac->dev = &pdev->dev;
>> +       plat_dat->fix_mac_speed = starfive_eth_plat_fix_mac_speed;
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
>> +static const struct of_device_id starfive_eth_plat_match[] = {
>> +       { .compatible = "starfive,jh7110-dwmac" },
>> +       { }
>> +};
>> +
>> +static struct platform_driver starfive_eth_plat_driver = {
>> +       .probe  = starfive_eth_plat_probe,
>> +       .remove = stmmac_pltfr_remove,
>> +       .driver = {
>> +               .name = "starfive-eth-plat",
>> +               .pm = &stmmac_pltfr_pm_ops,
>> +               .of_match_table = starfive_eth_plat_match,
>> +       },
>> +};
>> +
>> +module_platform_driver(starfive_eth_plat_driver);
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_DESCRIPTION("StarFive DWMAC platform driver");
>> +MODULE_AUTHOR("Yanhong Wang <yanhong.wang@starfivetech.com>");
>> --
>> 2.17.1
>>
>>
>> _______________________________________________
>> linux-riscv mailing list
>> linux-riscv@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-riscv
