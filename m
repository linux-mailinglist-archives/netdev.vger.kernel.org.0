Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA0E6B3D68
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 12:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjCJLNT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Mar 2023 06:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbjCJLNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 06:13:12 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DE835245;
        Fri, 10 Mar 2023 03:13:07 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id 5D2AF24E13A;
        Fri, 10 Mar 2023 19:13:06 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 10 Mar
 2023 19:13:06 +0800
Received: from [192.168.120.42] (171.223.208.138) by EXMBX162.cuchost.com
 (172.16.6.72) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 10 Mar
 2023 19:13:05 +0800
Message-ID: <fd75b81f-9d9d-b6f7-02b2-06d982204cdc@starfivetech.com>
Date:   Fri, 10 Mar 2023 19:13:04 +0800
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
 <CAJM55Z_YUXbny3NR7xLRu1ekzkgOsx2wgBWmCoQ5peMkN+fV_Q@mail.gmail.com>
 <CAJM55Z-xojA5onmQu+suwaB2F4e8imBRqVFeLScuZQ1ixdv_EA@mail.gmail.com>
 <49bf9e1d-95ac-8cf5-ca43-43bb82ace690@starfivetech.com>
 <CAJM55Z9EwR_zmtBwvue+dSQ+ngiOdVqbFmuK9wiN3bm0i1LHqA@mail.gmail.com>
From:   Guo Samin <samin.guo@starfivetech.com>
In-Reply-To: <CAJM55Z9EwR_zmtBwvue+dSQ+ngiOdVqbFmuK9wiN3bm0i1LHqA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS064.cuchost.com (172.16.6.24) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



-------- 原始信息 --------
主题: Re: [PATCH v5 06/12] net: stmmac: Add glue layer for StarFive JH7110 SoC
From: Emil Renner Berthing <emil.renner.berthing@canonical.com>
收件人: Guo Samin <samin.guo@starfivetech.com>
日期: 2023/3/10

> On Fri, 10 Mar 2023 at 02:55, Guo Samin <samin.guo@starfivetech.com> wrote:
>> -------- 原始信息 --------
>> 主题: Re: [PATCH v5 06/12] net: stmmac: Add glue layer for StarFive JH7110 SoC
>> From: Emil Renner Berthing <emil.renner.berthing@canonical.com>
>> 收件人: Samin Guo <samin.guo@starfivetech.com>
>> 日期: 2023/3/10
>>
>>> On Fri, 10 Mar 2023 at 01:02, Emil Renner Berthing
>>> <emil.renner.berthing@canonical.com> wrote:
>>>> On Fri, 3 Mar 2023 at 10:01, Samin Guo <samin.guo@starfivetech.com> wrote:
>>>>>
>>>>> This adds StarFive dwmac driver support on the StarFive JH7110 SoC.
>>>>>
>>>>> Co-developed-by: Emil Renner Berthing <kernel@esmil.dk>
>>>>> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
>>>>> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
>>>>> ---
>>>>>  MAINTAINERS                                   |   1 +
>>>>>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |  12 ++
>>>>>  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
>>>>>  .../ethernet/stmicro/stmmac/dwmac-starfive.c  | 125 ++++++++++++++++++
>>>>>  4 files changed, 139 insertions(+)
>>>>>  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
>>>>>
>>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>>> index 4e236b7c7fd2..91a4f190c827 100644
>>>>> --- a/MAINTAINERS
>>>>> +++ b/MAINTAINERS
>>>>> @@ -19916,6 +19916,7 @@ STARFIVE DWMAC GLUE LAYER
>>>>>  M:     Emil Renner Berthing <kernel@esmil.dk>
>>>>>  M:     Samin Guo <samin.guo@starfivetech.com>
>>>>>  S:     Maintained
>>>>> +F:     Documentation/devicetree/bindings/net/dwmac-starfive.c
>>>>>  F:     Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
>>>>>
>>>>>  STARFIVE JH71X0 CLOCK DRIVERS
>>>>> diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
>>>>> index f77511fe4e87..47fbccef9d04 100644
>>>>> --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
>>>>> +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
>>>>> @@ -165,6 +165,18 @@ config DWMAC_SOCFPGA
>>>>>           for the stmmac device driver. This driver is used for
>>>>>           arria5 and cyclone5 FPGA SoCs.
>>>>>
>>>>> +config DWMAC_STARFIVE
>>>>> +       tristate "StarFive dwmac support"
>>>>> +       depends on OF  && (ARCH_STARFIVE || COMPILE_TEST)
>>>>> +       depends on STMMAC_ETH
>>>>> +       default ARCH_STARFIVE
>>>>> +       help
>>>>> +         Support for ethernet controllers on StarFive RISC-V SoCs
>>>>> +
>>>>> +         This selects the StarFive platform specific glue layer support for
>>>>> +         the stmmac device driver. This driver is used for StarFive JH7110
>>>>> +         ethernet controller.
>>>>> +
>>>>>  config DWMAC_STI
>>>>>         tristate "STi GMAC support"
>>>>>         default ARCH_STI
>>>>> diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
>>>>> index 057e4bab5c08..8738fdbb4b2d 100644
>>>>> --- a/drivers/net/ethernet/stmicro/stmmac/Makefile
>>>>> +++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
>>>>> @@ -23,6 +23,7 @@ obj-$(CONFIG_DWMAC_OXNAS)     += dwmac-oxnas.o
>>>>>  obj-$(CONFIG_DWMAC_QCOM_ETHQOS)        += dwmac-qcom-ethqos.o
>>>>>  obj-$(CONFIG_DWMAC_ROCKCHIP)   += dwmac-rk.o
>>>>>  obj-$(CONFIG_DWMAC_SOCFPGA)    += dwmac-altr-socfpga.o
>>>>> +obj-$(CONFIG_DWMAC_STARFIVE)   += dwmac-starfive.o
>>>>>  obj-$(CONFIG_DWMAC_STI)                += dwmac-sti.o
>>>>>  obj-$(CONFIG_DWMAC_STM32)      += dwmac-stm32.o
>>>>>  obj-$(CONFIG_DWMAC_SUNXI)      += dwmac-sunxi.o
>>>>> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
>>>>> new file mode 100644
>>>>> index 000000000000..566378306f67
>>>>> --- /dev/null
>>>>> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
>>>>> @@ -0,0 +1,125 @@
>>>>> +// SPDX-License-Identifier: GPL-2.0+
>>>>> +/*
>>>>> + * StarFive DWMAC platform driver
>>>>> + *
>>>>> + * Copyright (C) 2022 StarFive Technology Co., Ltd.
>>>>> + * Copyright (C) 2022 Emil Renner Berthing <kernel@esmil.dk>
>>>>> + *
>>>>> + */
>>>>> +
>>>>> +#include <linux/of_device.h>
>>>>> +
>>>>> +#include "stmmac_platform.h"
>>>>> +
>>>>> +struct starfive_dwmac {
>>>>> +       struct device *dev;
>>>>> +       struct clk *clk_tx;
>>>>> +       struct clk *clk_gtx;
>>>>> +       bool tx_use_rgmii_rxin_clk;
>>>>> +};
>>>>> +
>>>>> +static void starfive_eth_fix_mac_speed(void *priv, unsigned int speed)
>>>>> +{
>>>>> +       struct starfive_dwmac *dwmac = priv;
>>>>> +       unsigned long rate;
>>>>> +       int err;
>>>>> +
>>>>> +       /* Generally, the rgmii_tx clock is provided by the internal clock,
>>>>> +        * which needs to match the corresponding clock frequency according
>>>>> +        * to different speeds. If the rgmii_tx clock is provided by the
>>>>> +        * external rgmii_rxin, there is no need to configure the clock
>>>>> +        * internally, because rgmii_rxin will be adaptively adjusted.
>>>>> +        */
>>>>> +       if (dwmac->tx_use_rgmii_rxin_clk)
>>>>> +               return;
>>>>> +
>>>>> +       switch (speed) {
>>>>> +       case SPEED_1000:
>>>>> +               rate = 125000000;
>>>>> +               break;
>>>>> +       case SPEED_100:
>>>>> +               rate = 25000000;
>>>>> +               break;
>>>>> +       case SPEED_10:
>>>>> +               rate = 2500000;
>>>>> +               break;
>>>>> +       default:
>>>>> +               dev_err(dwmac->dev, "invalid speed %u\n", speed);
>>>>> +               break;
>>>>> +       }
>>>>> +
>>>>> +       err = clk_set_rate(dwmac->clk_tx, rate);
>>>>
>>>> Hi Samin,
>>>>
>>>> I tried exercising this code by forcing the interface to downgrade
>>>> from 1000Mbps to 100Mbps (ethtool -s end0 speed 100), and it doesn't
>>>> seem to work. The reason is that clk_tx is a mux, and when you call
>>>> clk_set_rate it will try to find the parent with the closest clock
>>>> rate instead of adjusting the current parent as is needed here.
>>>> However that is easily fixed by calling clk_set_rate on clk_gtx which
>>>> is just a gate that *will* propagate the rate change to the parent.
>>>>
>>>> With this change, this piece of code and downgrading from 1000Mbps to
>>>> 100Mbps works on the JH7100. However on the JH7110 there is a second
>>>> problem. The parent of clk_gtx, confusingly called
>>>> clk_gmac{0,1}_gtxclk is a divider (and gate) that takes the 1GHz PLL0
>>>> clock and divides it by some integer. But according to [1] it can at
>>>> most divide by 15 which is not enough to generate the 25MHz clock
>>>> needed for 100Mbps. So now I wonder how this is supposed to work on
>>>> the JH7110.
>>>>
>>>> [1]: https://doc-en.rvspace.org/JH7110/TRM/JH7110_TRM/sys_crg.html#sys_crg__section_skz_fxm_wsb
>>>
>>> Ah, I see now that gmac0_gtxclk is only used by gmac0 on the
>>> VisionFive 2 v1.2A, where I think it's a known problem that only
>>> 1000Mbps works.
>>> On the 1.3B this function is not used at all, and I guess it also
>>> ought to be skipped for gmac1 of the 1.2A using the rmii interface so
>>> it doesn't risk changing the parent of the tx clock.
>>>
>> Hi Emil,
>>
>> V1.2A gmac0 only supports 1000M due to known problem, and v1.2A gmac1 supports 100M/10M.
>>
>> V1.2A gmac1 uses a parent clock from gmac1_rmii_rtx, whose parent clock is from external phy clock gmac1_rmii_refin (fixed is 50M).
>> The default frequency division value of gmac1_rmii_rtx is 2, so it can work in 100M mode. （clk_tx: 50/2=25M ===> 100M mode）.
>> When gmac1 switches to 10M mode, the clock frequency of gmac1_rmii_rtx needs to be modified to 2.5M.
>> So,if 1.2A gmac1 is skipped the starfive_eth_fix_mac_speed, 10M mode will be unavailable.
>>
>>         gmac1_rmii_refin（50M) ==> gmac1_rmii_rtx（div 2, by default) ==>  clk_tx (25M)  （100M mode）
>>         gmac1_rmii_refin（50M）==> gmac1_rmii_rtx（div 20) ==> clk_tx (2.5M)  （10M mode）
>>
> 
> I see. So on the JH7110 it is only when using gmac{0,1}_rmii_rtx ->
> clk_tx with the rmii interface that this function is needed?
> 
> As noted above using the current fix_mac_speed with gmac{0,1}_gtxclk
> -> clk_tx will produce wrong results, so for the VF2 v1.2A you
> probably just want something like this in the device tree
> &gmac0 {
>   assigned-clocks = <&aoncrg JH7110_AONCLK_GMAC0_TX>, <&syscrg
> JH7110_SYSCLK_GMAC0_GTXCLK>;
>   assigned-clock-parents = <&syscrg JH7110_SYSCLK_GMAC0_GTXCLK>;
>   assigned-clock-rates = <0> <125000000>;
> };
> 
> ..and then don't set the fix_mac_speed callback.
> 

Hi Emil,

This works on v1.2a with gmac0, but gmac1 does not. gmac1 have to setting the fix_mac_speed as mentioned above。

Moreover，fix_mac_speed is also can be used on JH7100 I guess.
So, keeping fix_mac_speed callback can make the code more compatible?

Best regards,
Samin

>> Of course, as you mentioned earlier, we need to add gmac1_clk_tx uses CLK_SET_RATE_PARENT flag.
> 
> Yes, I'm not too sure how clk_set_rate on mux'es are supposed to work,
> but if you can convince Hal and Stephen (the clock maintainer) that
> clk_set_rate should always propagate the rate change to the current
> parent, then I'm fine with it.
> I tested it with CLK_SET_RATE_PARENT flag in gmacX_clk_tx with HAL's clktree driver,
Setting the frequency of gmacX_clk_tx can take effect on clk_rmii_rtx.

Tested on v1.2A:
# mount -t debugfs none /sys/kernel/debug
# cat /sys/kernel/debug/clk/gmac1_tx/clk_parent 
gmac1_rmii_rtx
# cat /sys/kernel/debug/clk/gmac1_tx/clk_rate
25000000
# cat /sys/kernel/debug/clk/gmac1_rmii_rtx/clk_rate 
25000000
# ethtool -s eth1 speed 10 duplex full
# starfive-dwmac 16040000.ethernet eth1: Link is Down
  starfive-dwmac 16040000.ethernet eth1: Link is Up - 10Mbps/Full - flow control rx/tx
# cat /sys/kernel/debug/clk/gmac1_tx/clk_rate
2500000
# cat /sys/kernel/debug/clk/gmac1_rmii_rtx/clk_rate
2500000


In addition, I have tested that all the following modes can work:
For v1.2A:
gmac0: 1000M
gmac1: 100M/10M

For v1.3B:
gmac0: 1000M/100M/10M
gmac1: 1000M/100M/10M

Best regards,
Samin

> Alternatively you can add an optional clock to the bindings, and only
> if the optional clock is set then set the fix_mac_speed callback to
> modify the rate of that clock. This way you won't need the special
> "starfive,tx-use-rgmii-clk" flag either.
> 
> /Emil
>>
>> Best regards,
>> Samin
>>
>>>>> +       if (err)
>>>>> +               dev_err(dwmac->dev, "failed to set tx rate %lu\n", rate);
>>>>> +}
>>>>> +
>>>>> +static int starfive_dwmac_probe(struct platform_device *pdev)
>>>>> +{
>>>>> +       struct plat_stmmacenet_data *plat_dat;
>>>>> +       struct stmmac_resources stmmac_res;
>>>>> +       struct starfive_dwmac *dwmac;
>>>>> +       int err;
>>>>> +
>>>>> +       err = stmmac_get_platform_resources(pdev, &stmmac_res);
>>>>> +       if (err)
>>>>> +               return err;
>>>>> +
>>>>> +       plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
>>>>> +       if (IS_ERR(plat_dat)) {
>>>>> +               dev_err(&pdev->dev, "dt configuration failed\n");
>>>>> +               return PTR_ERR(plat_dat);
>>>>> +       }
>>>>> +
>>>>> +       dwmac = devm_kzalloc(&pdev->dev, sizeof(*dwmac), GFP_KERNEL);
>>>>> +       if (!dwmac)
>>>>> +               return -ENOMEM;
>>>>> +
>>>>> +       dwmac->clk_tx = devm_clk_get_enabled(&pdev->dev, "tx");
>>>>> +       if (IS_ERR(dwmac->clk_tx))
>>>>> +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_tx),
>>>>> +                                   "error getting tx clock\n");
>>>>> +
>>>>> +       dwmac->clk_gtx = devm_clk_get_enabled(&pdev->dev, "gtx");
>>>>> +       if (IS_ERR(dwmac->clk_gtx))
>>>>> +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_gtx),
>>>>> +                                   "error getting gtx clock\n");
>>>>> +
>>>>> +       if (device_property_read_bool(&pdev->dev, "starfive,tx-use-rgmii-clk"))
>>>>> +               dwmac->tx_use_rgmii_rxin_clk = true;
>>>>> +
>>>>> +       dwmac->dev = &pdev->dev;
>>>>> +       plat_dat->fix_mac_speed = starfive_eth_fix_mac_speed;
>>>>> +       plat_dat->init = NULL;
>>>>> +       plat_dat->bsp_priv = dwmac;
>>>>> +       plat_dat->dma_cfg->dche = true;
>>>>> +
>>>>> +       err = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
>>>>> +       if (err) {
>>>>> +               stmmac_remove_config_dt(pdev, plat_dat);
>>>>> +               return err;
>>>>> +       }
>>>>> +
>>>>> +       return 0;
>>>>> +}
>>>>> +
>>>>> +static const struct of_device_id starfive_dwmac_match[] = {
>>>>> +       { .compatible = "starfive,jh7110-dwmac" },
>>>>> +       { /* sentinel */ }
>>>>> +};
>>>>> +MODULE_DEVICE_TABLE(of, starfive_dwmac_match);
>>>>> +
>>>>> +static struct platform_driver starfive_dwmac_driver = {
>>>>> +       .probe  = starfive_dwmac_probe,
>>>>> +       .remove = stmmac_pltfr_remove,
>>>>> +       .driver = {
>>>>> +               .name = "starfive-dwmac",
>>>>> +               .pm = &stmmac_pltfr_pm_ops,
>>>>> +               .of_match_table = starfive_dwmac_match,
>>>>> +       },
>>>>> +};
>>>>> +module_platform_driver(starfive_dwmac_driver);
>>>>> +
>>>>> +MODULE_LICENSE("GPL");
>>>>> +MODULE_DESCRIPTION("StarFive DWMAC platform driver");
>>>>> +MODULE_AUTHOR("Emil Renner Berthing <kernel@esmil.dk>");
>>>>> +MODULE_AUTHOR("Samin Guo <samin.guo@starfivetech.com>");
>>>>> --
>>>>> 2.17.1
>>>>>
>>>>>
>>>>> _______________________________________________
>>>>> linux-riscv mailing list
>>>>> linux-riscv@lists.infradead.org
>>>>> http://lists.infradead.org/mailman/listinfo/linux-riscv
>>
>>

-- 
Best regards,
Samin
