Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFA66AB499
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 03:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjCFCTZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 5 Mar 2023 21:19:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjCFCTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 21:19:24 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8156DCA02;
        Sun,  5 Mar 2023 18:19:22 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id EED2624E34B;
        Mon,  6 Mar 2023 10:19:18 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 6 Mar
 2023 10:19:19 +0800
Received: from [192.168.120.42] (171.223.208.138) by EXMBX162.cuchost.com
 (172.16.6.72) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 6 Mar
 2023 10:19:17 +0800
Message-ID: <9093ee69-eee3-7a6c-794e-3df2be11496e@starfivetech.com>
Date:   Mon, 6 Mar 2023 10:19:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 05/12] riscv: dts: starfive: jh7110: Add ethernet
 device nodes
To:     Andrew Lunn <andrew@lunn.ch>
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
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
References: <20230303085928.4535-1-samin.guo@starfivetech.com>
 <20230303085928.4535-6-samin.guo@starfivetech.com> <ZAH6CGoXBKz0FmW3@lunn.ch>
Content-Language: en-US
From:   Guo Samin <samin.guo@starfivetech.com>
In-Reply-To: <ZAH6CGoXBKz0FmW3@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS064.cuchost.com (172.16.6.24) To EXMBX162.cuchost.com
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



在 2023/3/3 21:45:44, Andrew Lunn 写道:
>> +		gmac0: ethernet@16030000 {
>> +			compatible = "starfive,jh7110-dwmac", "snps,dwmac-5.20";
>> +			reg = <0x0 0x16030000 0x0 0x10000>;
>> +			clocks = <&aoncrg JH7110_AONCLK_GMAC0_AXI>,
>> +				 <&aoncrg JH7110_AONCLK_GMAC0_AHB>,
>> +				 <&syscrg JH7110_SYSCLK_GMAC0_PTP>,
>> +				 <&aoncrg JH7110_AONCLK_GMAC0_TX_INV>,
>> +				 <&syscrg JH7110_SYSCLK_GMAC0_GTXC>;
>> +			clock-names = "stmmaceth", "pclk", "ptp_ref",
>> +				      "tx", "gtx";
>> +			resets = <&aoncrg JH7110_AONRST_GMAC0_AXI>,
>> +				 <&aoncrg JH7110_AONRST_GMAC0_AHB>;
>> +			reset-names = "stmmaceth", "ahb";
>> +			interrupts = <7>, <6>, <5>;
>> +			interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
>> +			phy-mode = "rgmii-id";
> 
> phy-mode is a board property, not a SoC property. It should be in the
> board .dts file, not the SoC .dtsi file.

Thanks. I will fix it in the next version.
> 
>> +			snps,multicast-filter-bins = <64>;
>> +			snps,perfect-filter-entries = <8>;
>> +			rx-fifo-depth = <2048>;
>> +			tx-fifo-depth = <2048>;
>> +			snps,fixed-burst;
>> +			snps,no-pbl-x8;
>> +			snps,force_thresh_dma_mode;
>> +			snps,axi-config = <&stmmac_axi_setup>;
>> +			snps,tso;
>> +			snps,en-tx-lpi-clockgating;
>> +			snps,txpbl = <16>;
>> +			snps,rxpbl = <16>;
>> +			status = "disabled";
>> +			phy-handle = <&phy0>;
> 
> The PHY is external, so this is also a board property, not a SoC
> property. 
Will fix, thanks.
> 
>> +
>> +			mdio {
>> +				#address-cells = <1>;
>> +				#size-cells = <0>;
>> +				compatible = "snps,dwmac-mdio";
>> +
>> +				phy0: ethernet-phy@0 {
>> +					reg = <0>;
>> +				};
> 
> The PHY is also a board property. You could for example design a board
> where both PHYs are on one MDIO bus, in order to save two SoC pins.

Sounds like a good idea.
> 
>       Andrew

Thank you for taking the time to review.
-- 
Best regards,
Samin
