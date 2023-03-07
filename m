Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0196AD87B
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 08:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjCGHvA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Mar 2023 02:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCGHuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 02:50:54 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14ED055531;
        Mon,  6 Mar 2023 23:50:36 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id C6EB124E2EF;
        Tue,  7 Mar 2023 15:50:28 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 7 Mar
 2023 15:50:28 +0800
Received: from [192.168.120.42] (171.223.208.138) by EXMBX162.cuchost.com
 (172.16.6.72) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 7 Mar
 2023 15:50:27 +0800
Message-ID: <46773d26-d798-58d9-d5ce-07241bf27478@starfivetech.com>
Date:   Tue, 7 Mar 2023 15:50:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 05/12] riscv: dts: starfive: jh7110: Add ethernet
 device nodes
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
 <20230303085928.4535-6-samin.guo@starfivetech.com>
 <CAJM55Z_SV3ig56JY9BF5LeWt4M+bKYh_HdxSY02CP+9i7F0vCQ@mail.gmail.com>
Content-Language: en-US
From:   Guo Samin <samin.guo@starfivetech.com>
In-Reply-To: <CAJM55Z_SV3ig56JY9BF5LeWt4M+bKYh_HdxSY02CP+9i7F0vCQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX162.cuchost.com
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



在 2023/3/5 6:57:18, Emil Renner Berthing 写道:
> On Fri, 3 Mar 2023 at 10:01, Samin Guo <samin.guo@starfivetech.com> wrote:
>>
>> Add JH7110 ethernet device node to support gmac driver for the JH7110
>> RISC-V SoC.
>>
>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
>> ---
>>  arch/riscv/boot/dts/starfive/jh7110.dtsi | 91 ++++++++++++++++++++++++
>>  1 file changed, 91 insertions(+)
>>
>> diff --git a/arch/riscv/boot/dts/starfive/jh7110.dtsi b/arch/riscv/boot/dts/starfive/jh7110.dtsi
>> index 09806418ed1b..2ce28292b721 100644
>> --- a/arch/riscv/boot/dts/starfive/jh7110.dtsi
>> +++ b/arch/riscv/boot/dts/starfive/jh7110.dtsi
>> @@ -233,6 +233,13 @@
>>                 #clock-cells = <0>;
>>         };
>>
>> +       stmmac_axi_setup: stmmac-axi-config {
>> +               snps,lpi_en;
>> +               snps,wr_osr_lmt = <4>;
>> +               snps,rd_osr_lmt = <4>;
>> +               snps,blen = <256 128 64 32 0 0 0>;
>> +       };
>> +
>>         tdm_ext: tdm-ext-clock {
>>                 compatible = "fixed-clock";
>>                 clock-output-names = "tdm_ext";
>> @@ -518,5 +525,89 @@
>>                         gpio-controller;
>>                         #gpio-cells = <2>;
>>                 };
>> +
>> +               gmac0: ethernet@16030000 {
>> +                       compatible = "starfive,jh7110-dwmac", "snps,dwmac-5.20";
>> +                       reg = <0x0 0x16030000 0x0 0x10000>;
>> +                       clocks = <&aoncrg JH7110_AONCLK_GMAC0_AXI>,
>> +                                <&aoncrg JH7110_AONCLK_GMAC0_AHB>,
>> +                                <&syscrg JH7110_SYSCLK_GMAC0_PTP>,
>> +                                <&aoncrg JH7110_AONCLK_GMAC0_TX_INV>,
>> +                                <&syscrg JH7110_SYSCLK_GMAC0_GTXC>;
>> +                       clock-names = "stmmaceth", "pclk", "ptp_ref",
>> +                                     "tx", "gtx";
>> +                       resets = <&aoncrg JH7110_AONRST_GMAC0_AXI>,
>> +                                <&aoncrg JH7110_AONRST_GMAC0_AHB>;
>> +                       reset-names = "stmmaceth", "ahb";
>> +                       interrupts = <7>, <6>, <5>;
>> +                       interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
>> +                       phy-mode = "rgmii-id";
>> +                       snps,multicast-filter-bins = <64>;
>> +                       snps,perfect-filter-entries = <8>;
>> +                       rx-fifo-depth = <2048>;
>> +                       tx-fifo-depth = <2048>;
>> +                       snps,fixed-burst;
>> +                       snps,no-pbl-x8;
>> +                       snps,force_thresh_dma_mode;
>> +                       snps,axi-config = <&stmmac_axi_setup>;
>> +                       snps,tso;
>> +                       snps,en-tx-lpi-clockgating;
>> +                       snps,txpbl = <16>;
>> +                       snps,rxpbl = <16>;
>> +                       status = "disabled";
>> +                       phy-handle = <&phy0>;
>> +
>> +                       mdio {
>> +                               #address-cells = <1>;
>> +                               #size-cells = <0>;
>> +                               compatible = "snps,dwmac-mdio";
>> +
>> +                               phy0: ethernet-phy@0 {
>> +                                       reg = <0>;
>> +                               };
>> +                       };
>> +               };
>> +
>> +               gmac1: ethernet@16040000 {
>> +                       compatible = "starfive,jh7110-dwmac", "snps,dwmac-5.20";
>> +                       reg = <0x0 0x16040000 0x0 0x10000>;
>> +                       clocks = <&syscrg JH7110_SYSCLK_GMAC1_AXI>,
>> +                                <&syscrg JH7110_SYSCLK_GMAC1_AHB>,
>> +                                <&syscrg JH7110_SYSCLK_GMAC1_PTP>,
>> +                                <&syscrg JH7110_SYSCLK_GMAC1_TX_INV>,
>> +                                <&syscrg JH7110_SYSCLK_GMAC1_GTXC>;
>> +                       clock-names = "stmmaceth", "pclk", "ptp_ref",
>> +                                     "tx", "gtx";
>> +                       resets = <&syscrg JH7110_SYSRST_GMAC1_AXI>,
>> +                                <&syscrg JH7110_SYSRST_GMAC1_AHB>;
>> +                       reset-names = "stmmaceth", "ahb";
>> +                       interrupts = <78>, <77>, <76>;
>> +                       interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
>> +                       phy-mode = "rgmii-id";
>> +                       snps,multicast-filter-bins = <64>;
>> +                       snps,perfect-filter-entries = <8>;
>> +                       rx-fifo-depth = <2048>;
>> +                       tx-fifo-depth = <2048>;
>> +                       snps,fixed-burst;
>> +                       snps,no-pbl-x8;
>> +                       snps,force_thresh_dma_mode;
>> +                       snps,axi-config = <&stmmac_axi_setup>;
>> +                       snps,tso;
>> +                       snps,en-tx-lpi-clockgating;
>> +                       snps,txpbl = <16>;
>> +                       snps,rxpbl = <16>;
>> +                       status = "disabled";
>> +                       phy-handle = <&phy1>;
>> +
>> +                       mdio {
>> +                               #address-cells = <1>;
>> +                               #size-cells = <0>;
>> +                               compatible = "snps,dwmac-mdio";
>> +
>> +                               phy1: ethernet-phy@1 {
>> +                                       reg = <0>;
> 
> I'm getting errors on eth1 unless this is set to <1>. In any case the
> number after @ in the node name should match the reg value.

Hi，Emil，which board are you using?  (v1.2a or v1.3b?). 
I have tested it on v1.2a and 1.3b, all network ports work normally when the phy address is set to 0.
Maybe your eth1 doesn't work for other reasons?

General, the phy address is fixed when the bord is designed.
(For example,the phy address of YT8512 depends on the hardware resistance pull-up or pull-down.
However, some phy addresses can be configured through software, but not yt8512.)

The phy address is a borad-related attribute, and I will follow Andrew's suggestion and put the phy address in borad*.dts


Best regards,
Samin
> 
>> +                               };
>> +                       };
>> +               };
>>         };
>>  };
>> --
>> 2.17.1
>>
>>
>> _______________________________________________
>> linux-riscv mailing list
>> linux-riscv@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-riscv

-- 
Best regards,
Samin
