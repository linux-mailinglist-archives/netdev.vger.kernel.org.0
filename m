Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCCC46CD065
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 04:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjC2C5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 22:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjC2C5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 22:57:14 -0400
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403632685;
        Tue, 28 Mar 2023 19:57:12 -0700 (PDT)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 8A5EE24E207;
        Wed, 29 Mar 2023 10:57:03 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 29 Mar
 2023 10:57:03 +0800
Received: from [192.168.120.42] (171.223.208.138) by EXMBX162.cuchost.com
 (172.16.6.72) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 29 Mar
 2023 10:57:02 +0800
Message-ID: <f8be0cf7-fe78-7e63-7fbc-78d083a9f186@starfivetech.com>
Date:   Wed, 29 Mar 2023 10:57:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [net-next v9 5/6] net: stmmac: Add glue layer for StarFive JH7110
 SoC
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Jose Abreu <joabreu@synopsys.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Conor Dooley <conor@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        Tommaso Merciai <tomm.merciai@gmail.com>
References: <20230328062009.25454-1-samin.guo@starfivetech.com>
 <20230328062009.25454-6-samin.guo@starfivetech.com>
 <20230328191716.18a302a1@kernel.org>
From:   Guo Samin <samin.guo@starfivetech.com>
In-Reply-To: <20230328191716.18a302a1@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS061.cuchost.com (172.16.6.21) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-0.0 required=5.0 tests=NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Re: [net-next v9 5/6] net: stmmac: Add glue layer for StarFive JH7110 SoC
From: Jakub Kicinski <kuba@kernel.org>
to: Samin Guo <samin.guo@starfivetech.com>
data: 2023/3/29

> On Tue, 28 Mar 2023 14:20:08 +0800 Samin Guo wrote:
>> This adds StarFive dwmac driver support on the StarFive JH7110 SoC.
>>
>> Tested-by: Tommaso Merciai <tomm.merciai@gmail.com>
>> Co-developed-by: Emil Renner Berthing <kernel@esmil.dk>
>> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
>> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> 
> Excellent, now it applies cleanly :)
> 
> Our clang build with W=1 complains that:
> 
> drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c:37:2: warning: variable 'rate' is used uninitialized whenever switch default is taken [-Wsometimes-uninitialized]
>         default:
>         ^~~~~~~
> drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c:42:36: note: uninitialized use occurs here
>         err = clk_set_rate(dwmac->clk_tx, rate);
>                                           ^~~~
> drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c:24:20: note: initialize the variable 'rate' to silence this warning
>         unsigned long rate;
>                           ^
>                            = 0
> 
> 
> not sure how you prefer to fix this. Maybe return early?

Hi Jakub,

Sorry, gcc I used does not report this error (:, and clang compile checks are more stringent.
Also, if return early at default node, Arun Ramadoss doesn't think it's a good idea because the function is a void type.

I think I can initialize the value of rate first by clk_get_rate (Intel did the same <dwmac-intel-plat.c: kmb_eth_fix_mac_speed >),
like this:


static void starfive_dwmac_fix_mac_speed(void *priv, unsigned int speed)
{
        struct starfive_dwmac *dwmac = priv;
        unsigned long rate;
        int err;

	rate = clk_get_rate(dwmac->tx_clk);

        switch (speed) {
        case SPEED_1000:
                rate = 125000000;
                break;
        case SPEED_100:
                rate = 25000000;
                break;
        case SPEED_10:
                rate = 2500000;
                break;
        default:
                dev_err(dwmac->dev, "invalid speed %u\n", speed);
                break;
        }   

        err = clk_set_rate(dwmac->clk_tx, rate);
        if (err)
                dev_err(dwmac->dev, "failed to set tx rate %lu\n", rate);
}

What do you think?


Best regards,
Samin
