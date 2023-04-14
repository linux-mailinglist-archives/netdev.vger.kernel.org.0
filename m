Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10E576E2A15
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 20:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjDNS3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 14:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjDNS3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 14:29:41 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCED44A9;
        Fri, 14 Apr 2023 11:29:39 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33EITPnC119329;
        Fri, 14 Apr 2023 13:29:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1681496966;
        bh=duGXWm/j3nBzRl2n2W7pepgTfc6KT76GkKbo6Tam8xY=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=QoAvJ3muQZL9qdd4rCvaaAubB6BtMFkEeJx+PYr7uIp1IbEt7rDO1fn2gW2tCkkRg
         s3IGCovqkgj+ywn5JVjsEXgBwHC/WgVDK8I8CldrdvTP9YZYsjZEEvSdnp+qEDNvlb
         RLwBVC9axPLUc6qVFcZbqcNXCCjt74l2gRWR/B5I=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33EITPmn032250
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 14 Apr 2023 13:29:25 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 14
 Apr 2023 13:29:25 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 14 Apr 2023 13:29:25 -0500
Received: from localhost (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33EITPdd040108;
        Fri, 14 Apr 2023 13:29:25 -0500
Date:   Fri, 14 Apr 2023 13:29:25 -0500
From:   Nishanth Menon <nm@ti.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
CC:     Judith Mendez <jm@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Andrew Davis <afd@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        <linux-can@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>
Subject: Re: [RFC PATCH 4/5] arm64: dts: ti: Enable multiple MCAN for AM62x
 in MCU MCAN overlay
Message-ID: <20230414182925.ya3fe2n6mtyuqotb@detached>
References: <20230413223051.24455-1-jm@ti.com>
 <20230413223051.24455-5-jm@ti.com>
 <9ab56180-328e-1416-56cb-bbf71af0c26d@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9ab56180-328e-1416-56cb-bbf71af0c26d@linaro.org>
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10:01-20230414, Krzysztof Kozlowski wrote:
> On 14/04/2023 00:30, Judith Mendez wrote:
> > Enable two MCAN in MCU domain. AM62x does not have on-board CAN
> > transcievers, so instead of changing the DTB permanently, add
> > MCU MCAN nodes and transceiver nodes to a MCU MCAN overlay.
> > 
> > If there are no hardware interrupts rounted to the GIC interrupt
> > controller for MCAN IP, A53 Linux will not receive hardware
> > interrupts. If an hrtimer is used to generate software interrupts,
> > the two required interrupt attributes in the MCAN node do not have
> > to be included.
> > 
> > Signed-off-by: Judith Mendez <jm@ti.com>
> > ---
> >  arch/arm64/boot/dts/ti/Makefile               |  2 +-
> >  .../boot/dts/ti/k3-am625-sk-mcan-mcu.dtso     | 75 +++++++++++++++++++
> >  2 files changed, 76 insertions(+), 1 deletion(-)
> >  create mode 100644 arch/arm64/boot/dts/ti/k3-am625-sk-mcan-mcu.dtso
> > 
> > diff --git a/arch/arm64/boot/dts/ti/Makefile b/arch/arm64/boot/dts/ti/Makefile
> > index abe15e76b614..c76be3888e4d 100644
> > --- a/arch/arm64/boot/dts/ti/Makefile
> > +++ b/arch/arm64/boot/dts/ti/Makefile
> > @@ -9,7 +9,7 @@
> >  # alphabetically.
> >  
> >  # Boards with AM62x SoC
> > -k3-am625-sk-mcan-dtbs := k3-am625-sk.dtb k3-am625-sk-mcan-main.dtbo
> > +k3-am625-sk-mcan-dtbs := k3-am625-sk.dtb k3-am625-sk-mcan-main.dtbo k3-am625-sk-mcan-mcu.dtbo
> >  dtb-$(CONFIG_ARCH_K3) += k3-am625-beagleplay.dtb
> >  dtb-$(CONFIG_ARCH_K3) += k3-am625-sk.dtb
> >  dtb-$(CONFIG_ARCH_K3) += k3-am625-sk-mcan.dtb
> > diff --git a/arch/arm64/boot/dts/ti/k3-am625-sk-mcan-mcu.dtso b/arch/arm64/boot/dts/ti/k3-am625-sk-mcan-mcu.dtso
> > new file mode 100644
> > index 000000000000..777705aea546
> > --- /dev/null
> > +++ b/arch/arm64/boot/dts/ti/k3-am625-sk-mcan-mcu.dtso
> > @@ -0,0 +1,75 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/**
> > + * DT overlay for MCAN in MCU domain on AM625 SK
> > + *
> > + * Copyright (C) 2022 Texas Instruments Incorporated - https://www.ti.com/
> > + */
> > +
> > +/dts-v1/;
> > +/plugin/;
> > +
> > +#include <dt-bindings/pinctrl/k3.h>
> > +#include <dt-bindings/soc/ti,sci_pm_domain.h>

NAK.

> > +
> > +
> > +&{/} {
> > +	transceiver2: can-phy1 {
> > +		compatible = "ti,tcan1042";
> > +		#phy-cells = <0>;
> > +		max-bitrate = <5000000>;
> > +	};
> > +
> > +	transceiver3: can-phy2 {
> > +		compatible = "ti,tcan1042";
> > +		#phy-cells = <0>;
> > +		max-bitrate = <5000000>;
> > +	};
> > +};
> > +
> > +&mcu_pmx0 {
> > +	mcu_mcan1_pins_default: mcu-mcan1-pins-default {
> > +		pinctrl-single,pins = <
> > +			AM62X_IOPAD(0x038, PIN_INPUT, 0) /* (B3) MCU_MCAN0_RX */
> > +			AM62X_IOPAD(0x034, PIN_OUTPUT, 0) /* (D6) MCU_MCAN0_TX */
> > +		>;
> > +	};
> > +
> > +	mcu_mcan2_pins_default: mcu-mcan2-pins-default {
> > +		pinctrl-single,pins = <
> > +			AM62X_IOPAD(0x040, PIN_INPUT, 0) /* (D4) MCU_MCAN1_RX */
> > +			AM62X_IOPAD(0x03C, PIN_OUTPUT, 0) /* (E5) MCU_MCAN1_TX */
> > +		>;
> > +	};
> > +};
> > +
> > +&cbass_mcu {
> > +	mcu_mcan1: can@4e00000 {
> > +		compatible = "bosch,m_can";
> > +		reg = <0x00 0x4e00000 0x00 0x8000>,
> > +			  <0x00 0x4e08000 0x00 0x200>;
> > +		reg-names = "message_ram", "m_can";
> > +		power-domains = <&k3_pds 188 TI_SCI_PD_EXCLUSIVE>;
> > +		clocks = <&k3_clks 188 6>, <&k3_clks 188 1>;
> > +		clock-names = "hclk", "cclk";
> > +		bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
> > +		pinctrl-names = "default";
> > +		pinctrl-0 = <&mcu_mcan1_pins_default>;
> > +		phys = <&transceiver2>;
> > +		status = "okay";
> 
> okay is by default. Why do you need it?

mcan is not functional without pinmux, so it has been disabled by
default in SoC. this overlay is supposed to enable it. But this is done
entirely wrongly.


The mcu_mcan1 should first be added to the SoC.dtsi as disabled, then
set to okay with pinctrl and  transciever in the overlay.

-- 
Regards,
Nishanth Menon
Key (0xDDB5849D1736249D) / Fingerprint: F8A2 8693 54EB 8232 17A3  1A34 DDB5 849D 1736 249D
