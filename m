Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1AD647B42
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 02:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiLIBUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 20:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiLIBUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 20:20:10 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2C9941AD;
        Thu,  8 Dec 2022 17:20:06 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id DB57824E041;
        Fri,  9 Dec 2022 09:19:53 +0800 (CST)
Received: from EXMBX173.cuchost.com (172.16.6.93) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 9 Dec
 2022 09:19:51 +0800
Received: from [192.168.120.49] (171.223.208.138) by EXMBX173.cuchost.com
 (172.16.6.93) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 9 Dec
 2022 09:19:49 +0800
Message-ID: <ed2f5df6-66c4-26b4-b650-48a128760965@starfivetech.com>
Date:   Fri, 9 Dec 2022 09:19:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 7/7] riscv: dts: starfive: visionfive-v2: Add phy
 delay_chain configuration
Content-Language: en-US
To:     Conor Dooley <conor@kernel.org>
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
 <20221201090242.2381-8-yanhong.wang@starfivetech.com> <Y4jpDvXo/uj9ygLR@spud>
From:   yanhong wang <yanhong.wang@starfivetech.com>
In-Reply-To: <Y4jpDvXo/uj9ygLR@spud>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS064.cuchost.com (172.16.6.24) To EXMBX173.cuchost.com
 (172.16.6.93)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/12/2 1:49, Conor Dooley wrote:
> On Thu, Dec 01, 2022 at 05:02:42PM +0800, Yanhong Wang wrote:
>> Add phy delay_chain configuration to support motorcomm phy driver for
>> StarFive VisionFive 2 board.
>> 
>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>> ---
>>  .../jh7110-starfive-visionfive-v2.dts         | 46 +++++++++++++++++++
>>  1 file changed, 46 insertions(+)
>> 
>> diff --git a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-v2.dts b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-v2.dts
>> index c8946cf3a268..2868ef4c74ef 100644
>> --- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-v2.dts
>> +++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-v2.dts
>> @@ -15,6 +15,8 @@
>>  
>>  	aliases {
>>  		serial0 = &uart0;
>> +		ethernet0=&gmac0;
>> +		ethernet1=&gmac1;
> 
> Please match the whitespace usage of the existing entry.
> 

Will fix in the next version.

>>  	};
>>  
>>  	chosen {
>> @@ -114,3 +116,47 @@
>>  	pinctrl-0 = <&uart0_pins>;
>>  	status = "okay";
>>  };
>> +
>> +&gmac0 {
>> +	status = "okay";
>> +	#address-cells = <1>;
>> +	#size-cells = <0>;
>> +	phy-handle = <&phy0>;
>> +	status = "okay";
>> +	mdio0 {
> 
> A line of whitespace before the child nodes too please :)
> 

Will fix.

>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +		compatible = "snps,dwmac-mdio";
>> +		phy0: ethernet-phy@0 {
>> +			reg = <0>;
>> +			rxc_dly_en = <1>;
>> +			tx_delay_sel_fe = <5>;
>> +			tx_delay_sel = <0xa>;
>> +			tx_inverted_10 = <0x1>;
>> +			tx_inverted_100 = <0x1>;
>> +			tx_inverted_1000 = <0x1>;
>> +		};
>> +	};
>> +};
>> +
>> +&gmac1 {
>> +	status = "okay";
>> +	#address-cells = <1>;
>> +	#size-cells = <0>;
>> +	phy-handle = <&phy1>;
>> +	status = "okay";
>> +	mdio1 {
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +		compatible = "snps,dwmac-mdio";
>> +		phy1: ethernet-phy@1 {
>> +			reg = <1>;
>> +			tx_delay_sel_fe = <5>;
>> +			tx_delay_sel = <0>;
>> +			rxc_dly_en = <0>;
>> +			tx_inverted_10 = <0x1>;
>> +			tx_inverted_100 = <0x1>;
>> +			tx_inverted_1000 = <0x0>;
>> +		};
>> +	};
>> +};
>> -- 
>> 2.17.1
>> 
