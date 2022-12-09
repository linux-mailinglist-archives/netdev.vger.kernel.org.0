Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3D5647BD1
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 03:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiLICDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 21:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiLICDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 21:03:51 -0500
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC20C1BE9C;
        Thu,  8 Dec 2022 18:03:46 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 3644024E1CE;
        Fri,  9 Dec 2022 10:03:45 +0800 (CST)
Received: from EXMBX173.cuchost.com (172.16.6.93) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 9 Dec
 2022 10:03:45 +0800
Received: from [192.168.120.49] (171.223.208.138) by EXMBX173.cuchost.com
 (172.16.6.93) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 9 Dec
 2022 10:03:43 +0800
Message-ID: <42da7b33-d3eb-b546-f262-b4485213c028@starfivetech.com>
Date:   Fri, 9 Dec 2022 10:03:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 5/7] net: stmmac: Add StarFive dwmac supoort
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
        Peter Geis <pgwipeout@gmail.com>
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
 <20221201090242.2381-6-yanhong.wang@starfivetech.com>
 <CAJM55Z9bdpxLsKOM8UhE=b5Z2uPzL227N1-x6d8AuvkZHRajqA@mail.gmail.com>
From:   yanhong wang <yanhong.wang@starfivetech.com>
In-Reply-To: <CAJM55Z9bdpxLsKOM8UhE=b5Z2uPzL227N1-x6d8AuvkZHRajqA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS061.cuchost.com (172.16.6.21) To EXMBX173.cuchost.com
 (172.16.6.93)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/12/7 22:16, Emil Renner Berthing wrote:
> Hi Yanhong,
> 
> Thanks for submitting this. Again please don't change the author of
> the commits you cherry-picked from my tree. This is why we have the
> Co-developed-by: tag so you can mark that you added or in this case
> removed code.
> I'd hoped you would still include the support for the JH7100 though.
>

Hi Emil,

  Thank you for your suggestion. If the dwmac-starfive-plat driver supports JH7100 and JH7110, the dt-binding calls "starfive,jh71x0-dwmac.yaml", is this ok?

 
> Also you seem to have changed the name of some of the functions.
> Please at least keep the prefix consistent if you do that. Now it's a
> mix of dwmac_starfive_, starfive_eth_ and starfive_eth_plat.
> 

I will named all the functions with starfive_eth_plat prefix in the next version.

> On Thu, 1 Dec 2022 at 10:07, Yanhong Wang <yanhong.wang@starfivetech.com> wrote:
>>
>> This adds StarFive dwmac driver support on the StarFive JH7110 SoCs.
>>
>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>> ---
>>  MAINTAINERS                                   |   1 +
>>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |  11 ++
>>  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
>>  .../stmicro/stmmac/dwmac-starfive-plat.c      | 147 ++++++++++++++++++
>>  4 files changed, 160 insertions(+)
>>  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 7eaaec8d3b96..36cb00cf860b 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -19610,6 +19610,7 @@ STARFIVE DWMAC GLUE LAYER
>>  M:     Yanhong Wang <yanhong.wang@starfivetech.com>
>>  S:     Maintained
>>  F:     Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml
>> +F:     drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c
>>
>>  STARFIVE PINCTRL DRIVER
>>  M:     Emil Renner Berthing <kernel@esmil.dk>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
>> index 31ff35174034..1e29cd3770b9 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
>> +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
>> @@ -235,6 +235,17 @@ config DWMAC_INTEL_PLAT
>>           the stmmac device driver. This driver is used for the Intel Keem Bay
>>           SoC.
>>
>> +config DWMAC_STARFIVE_PLAT
> 
> Why did you add the _PLAT suffix? None of the other SoC wrappers have this..
> 
>> +       tristate "StarFive dwmac support"
>> +       depends on OF && COMMON_CLK
>> +       depends on STMMAC_ETH
>> +       default SOC_STARFIVE
>> +       help
>> +         Support for ethernet controllers on StarFive RISC-V SoCs
>> +
>> +         This selects the StarFive platform specific glue layer support for
>> +         the stmmac device driver. This driver is used for StarFive RISC-V SoCs.
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
>>  obj-$(CONFIG_DWMAC_VISCONTI)   += dwmac-visconti.o
>>  stmmac-platform-objs:= stmmac_platform.o
>>  dwmac-altr-socfpga-objs := altr_tse_pcs.o dwmac-socfpga.o
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c
>> new file mode 100644
>> index 000000000000..8fbf584d4e19
>> --- /dev/null
>> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c
>> @@ -0,0 +1,147 @@
>> +// SPDX-License-Identifier: GPL-2.0+
>> +/*
>> + * StarFive DWMAC platform driver
>> + *
>> + * Copyright(C) 2022 StarFive Technology Co., Ltd.
> 
> Hmm.. where did my copyright go?
> 
>> + *
>> + */
>> +
>> +#include <linux/of_device.h>
>> +#include "stmmac_platform.h"
>> +
>> +struct starfive_dwmac {
>> +       struct device *dev;
>> +       struct clk *clk_tx;
>> +       struct clk *clk_gtx;
>> +       struct clk *clk_gtxc;
>> +};
>> +
>> +static void starfive_eth_fix_mac_speed(void *priv, unsigned int speed)
>> +{
>> +       struct starfive_dwmac *dwmac = priv;
>> +       unsigned long rate;
>> +       int err;
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
>> +               return;
>> +       }
>> +
>> +       err = clk_set_rate(dwmac->clk_gtx, rate);
>> +       if (err)
>> +               dev_err(dwmac->dev, "failed to set tx rate %lu\n", rate);
>> +}
>> +
>> +static void dwmac_starfive_clk_disable(void *clk)
>> +{
>> +       clk_disable_unprepare(clk);
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
>> +       dwmac->clk_tx = devm_clk_get(&pdev->dev, "tx");
>> +       if (IS_ERR(dwmac->clk_tx))
>> +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_tx),
>> +                                               "error getting tx clock\n");
>> +
>> +       err = devm_add_action(&pdev->dev, dwmac_starfive_clk_disable,
>> +                             dwmac->clk_tx);
>> +       if (err)
>> +               return err;
>> +
>> +       err = clk_prepare_enable(dwmac->clk_tx);
>> +       if (err)
>> +               return dev_err_probe(&pdev->dev, err, "error enabling tx clock\n");
>> +
>> +       dwmac->clk_gtx = devm_clk_get(&pdev->dev, "gtx");
>> +       if (IS_ERR(dwmac->clk_gtx))
>> +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_gtx),
>> +                                               "error getting gtx clock\n");
>> +
>> +       err = devm_add_action(&pdev->dev, dwmac_starfive_clk_disable,
>> +                             dwmac->clk_gtx);
>> +       if (err)
>> +               return err;
>> +
>> +       err = clk_prepare_enable(dwmac->clk_gtx);
>> +       if (err)
>> +               return dev_err_probe(&pdev->dev, err, "error enabling gtx clock\n");
> 
> I think the 3 calls above can be simplified to devm_clk_get_enabled().
> 
>> +       dwmac->clk_gtxc = devm_clk_get(&pdev->dev, "gtxc");
>> +       if (IS_ERR(dwmac->clk_gtxc))
>> +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_gtxc),
>> +                                               "error getting gtxc clock\n");
>> +
>> +       err = devm_add_action(&pdev->dev, dwmac_starfive_clk_disable,
>> +                             dwmac->clk_gtxc);
>> +       if (err)
>> +               return err;
>> +
>> +       err = clk_prepare_enable(dwmac->clk_gtxc);
>> +       if (err)
>> +               return dev_err_probe(&pdev->dev, err, "error enabling gtxc clock\n");
> 
> Same here.
> 
>> +
>> +       dwmac->dev = &pdev->dev;
>> +       plat_dat->fix_mac_speed = starfive_eth_fix_mac_speed;
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
>> +       {.compatible = "starfive,dwmac"},
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
> 
> Here you also seem to have removed me.
> 
>> +MODULE_AUTHOR("Yanhong Wang <yanhong.wang@starfivetech.com>");
>> --
>> 2.17.1
>>
>>
>> _______________________________________________
>> linux-riscv mailing list
>> linux-riscv@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-riscv
