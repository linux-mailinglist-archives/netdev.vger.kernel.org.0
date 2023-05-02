Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B0C6F3B59
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 02:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbjEBAUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 20:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjEBAUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 20:20:30 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C72DE9;
        Mon,  1 May 2023 17:20:28 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3420Jwmp070588;
        Mon, 1 May 2023 19:19:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682986798;
        bh=YPo3G+O2eNb5kCnGEM20hSWgWUlJO5PPCrrYZP1vQt8=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=agCTe61KyoQ+nKtYl31PuRlkorU5QF5IzV9imSErt8Ou3JwpDRJ119aeCTOrBATtI
         nP2eIikUarqhRIM69GoljEaD/6LwM1WVSo27wsO1G1baFGi2j7jHhUF1AuDVO4mV/Z
         c9JDQFH+Dbr9HVrGTVoxEy/8Pny9rJwGiEDOSs7A=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3420JwNn116921
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 1 May 2023 19:19:58 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 1
 May 2023 19:19:58 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 1 May 2023 19:19:58 -0500
Received: from localhost (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3420JwK2012934;
        Mon, 1 May 2023 19:19:58 -0500
Date:   Mon, 1 May 2023 19:19:58 -0500
From:   Nishanth Menon <nm@ti.com>
To:     Judith Mendez <jm@ti.com>
CC:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v3 4/4] arm64: dts: ti: Enable MCU MCANs for AM62x
Message-ID: <20230502001958.6ehl2u5oqqu4wq6n@specked>
References: <20230501223121.21663-1-jm@ti.com>
 <20230501223121.21663-5-jm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230501223121.21663-5-jm@ti.com>
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17:31-20230501, Judith Mendez wrote:
> On AM62x there are no hardware interrupts routed to A53 GIC
> interrupt controller for MCU MCAN IPs, so MCU MCANs were not
> added to the MCU dtsi. In this patch series an hrtimer is introduced
> to MCAN driver to generate software interrupts. Now add MCU MCAN
> nodes to the MCU dtsi but disable the MCAN devices by default.
> 
> AM62x does not carry on-board CAN transceivers, so instead of
> changing DTB permanently use an overlay to enable MCU MCANs and to
> add CAN transceiver nodes.
> 
> If there is no hardware interrupt and timer method is used, remove
> interrupt properties and add poll-interval to enable the hrtimer
> per MCAN node.
> 
> This DT overlay can be used with the following EVM:
> Link: https://www.ti.com/tool/TCAN1042DEVM
> 
> Signed-off-by: Judith Mendez <jm@ti.com>
> ---
> Changelog:
> v3:
>  1. Add link for specific board
> 
>  arch/arm64/boot/dts/ti/Makefile               |  2 +-
>  arch/arm64/boot/dts/ti/k3-am62-mcu.dtsi       | 24 ++++++++
>  .../boot/dts/ti/k3-am625-sk-mcan-mcu.dtso     | 57 +++++++++++++++++++
NAK - I dont see "DO NOT MERGE" in $subject.

please send this patch addressing previous comments with arch maintainer
tree not the mcan tree.

>  3 files changed, 82 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/boot/dts/ti/k3-am625-sk-mcan-mcu.dtso
> 
> diff --git a/arch/arm64/boot/dts/ti/Makefile b/arch/arm64/boot/dts/ti/Makefile
> index abe15e76b614..c76be3888e4d 100644
> --- a/arch/arm64/boot/dts/ti/Makefile
> +++ b/arch/arm64/boot/dts/ti/Makefile
> @@ -9,7 +9,7 @@
>  # alphabetically.
>  
>  # Boards with AM62x SoC
> -k3-am625-sk-mcan-dtbs := k3-am625-sk.dtb k3-am625-sk-mcan-main.dtbo
> +k3-am625-sk-mcan-dtbs := k3-am625-sk.dtb k3-am625-sk-mcan-main.dtbo k3-am625-sk-mcan-mcu.dtbo
>  dtb-$(CONFIG_ARCH_K3) += k3-am625-beagleplay.dtb
>  dtb-$(CONFIG_ARCH_K3) += k3-am625-sk.dtb
>  dtb-$(CONFIG_ARCH_K3) += k3-am625-sk-mcan.dtb
> diff --git a/arch/arm64/boot/dts/ti/k3-am62-mcu.dtsi b/arch/arm64/boot/dts/ti/k3-am62-mcu.dtsi
> index 076601a41e84..20462f457643 100644
> --- a/arch/arm64/boot/dts/ti/k3-am62-mcu.dtsi
> +++ b/arch/arm64/boot/dts/ti/k3-am62-mcu.dtsi
> @@ -141,4 +141,28 @@
>  		/* Tightly coupled to M4F */
>  		status = "reserved";
>  	};
> +
> +	mcu_mcan1: can@4e00000 {
> +		compatible = "bosch,m_can";
> +		reg = <0x00 0x4e00000 0x00 0x8000>,
> +			  <0x00 0x4e08000 0x00 0x200>;
> +		reg-names = "message_ram", "m_can";
> +		power-domains = <&k3_pds 188 TI_SCI_PD_EXCLUSIVE>;
> +		clocks = <&k3_clks 188 6>, <&k3_clks 188 1>;
> +		clock-names = "hclk", "cclk";
> +		bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
> +		status = "disabled";
> +	};
> +
> +	mcu_mcan2: can@4e10000 {
> +		compatible = "bosch,m_can";
> +		reg = <0x00 0x4e10000 0x00 0x8000>,
> +			  <0x00 0x4e18000 0x00 0x200>;
> +		reg-names = "message_ram", "m_can";
> +		power-domains = <&k3_pds 189 TI_SCI_PD_EXCLUSIVE>;
> +		clocks = <&k3_clks 189 6>, <&k3_clks 189 1>;
> +		clock-names = "hclk", "cclk";
> +		bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
> +		status = "disabled";
> +	};
>  };
> diff --git a/arch/arm64/boot/dts/ti/k3-am625-sk-mcan-mcu.dtso b/arch/arm64/boot/dts/ti/k3-am625-sk-mcan-mcu.dtso
> new file mode 100644
> index 000000000000..5145b3de4f9b
> --- /dev/null
> +++ b/arch/arm64/boot/dts/ti/k3-am625-sk-mcan-mcu.dtso
> @@ -0,0 +1,57 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/**
> + * DT overlay for MCAN in MCU domain on AM625 SK
> + *
> + * Copyright (C) 2022 Texas Instruments Incorporated - https://www.ti.com/
> + */
> +
> +/dts-v1/;
> +/plugin/;
> +
> +#include "k3-pinctrl.h"
> +
> +&{/} {
> +	transceiver2: can-phy1 {
> +		compatible = "ti,tcan1042";
> +		#phy-cells = <0>;
> +		max-bitrate = <5000000>;
> +	};
> +
> +	transceiver3: can-phy2 {
> +		compatible = "ti,tcan1042";
> +		#phy-cells = <0>;
> +		max-bitrate = <5000000>;
> +	};
> +};
> +
> +&mcu_pmx0 {
> +	mcu_mcan1_pins_default: mcu-mcan1-pins-default {
> +		pinctrl-single,pins = <
> +			AM62X_IOPAD(0x038, PIN_INPUT, 0) /* (B3) MCU_MCAN0_RX */
> +			AM62X_IOPAD(0x034, PIN_OUTPUT, 0) /* (D6) MCU_MCAN0_TX */
> +		>;
> +	};
> +
> +	mcu_mcan2_pins_default: mcu-mcan2-pins-default {
> +		pinctrl-single,pins = <
> +			AM62X_IOPAD(0x040, PIN_INPUT, 0) /* (D4) MCU_MCAN1_RX */
> +			AM62X_IOPAD(0x03C, PIN_OUTPUT, 0) /* (E5) MCU_MCAN1_TX */
> +		>;
> +	};
> +};
> +
> +&mcu_mcan1 {
> +	poll-interval;
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&mcu_mcan1_pins_default>;
> +	phys = <&transceiver2>;
> +	status = "okay";
> +};
> +
> +&mcu_mcan2 {
> +	poll-interval;
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&mcu_mcan2_pins_default>;
> +	phys = <&transceiver3>;
> +	status = "okay";
> +};
> -- 
> 2.17.1
> 

-- 
Regards,
Nishanth Menon
Key (0xDDB5849D1736249D) / Fingerprint: F8A2 8693 54EB 8232 17A3  1A34 DDB5 849D 1736 249D
