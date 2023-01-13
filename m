Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165F2669EEB
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjAMQ7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjAMQ7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:59:13 -0500
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972CC72D16;
        Fri, 13 Jan 2023 08:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1673629148; x=1705165148;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JPiHzzRV1B8HaL9yM6E3MJxcZz2dy885iNt7C0hDdZE=;
  b=R22Cv2dYw48Akjtk7yQEAYTqFbm2Bc7r4sbSZtGchEZE3wkNeqTSWJE4
   zWyMUfaQy2w3t2PBfVe6OrHCtA8heSoLKnCoyoy9yhKBl5Xo2wMXuAd3t
   HyxGsMnetaL+B8l3n/q6Xjyj+BD/NSCfLYlcG1t3j3HgD6YbbA8FtYPco
   s=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 13 Jan 2023 08:59:08 -0800
X-QCInternal: smtphost
Received: from nasanex01b.na.qualcomm.com ([10.46.141.250])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2023 08:59:07 -0800
Received: from [10.110.64.161] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:59:06 -0800
Message-ID: <cfe35932-948e-1dc0-a686-c4f80d70396a@quicinc.com>
Date:   Fri, 13 Jan 2023 08:58:44 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 18/18] arm64: dts: qcom: add initial support for qcom
 sa8775p-ride
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Alex Elder <elder@kernel.org>,
        <quic_psodagud@quicinc.com>
CC:     <linux-arm-msm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux.dev>, <linux-gpio@vger.kernel.org>,
        <netdev@vger.kernel.org>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20230109174511.1740856-1-brgl@bgdev.pl>
 <20230109174511.1740856-19-brgl@bgdev.pl>
 <f3a87b5b-5a9f-b19f-b16f-cd5a7394f4f0@linaro.org>
From:   Prasad Sodagudi <quic_psodagud@quicinc.com>
In-Reply-To: <f3a87b5b-5a9f-b19f-b16f-cd5a7394f4f0@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/9/2023 10:34 AM, Krzysztof Kozlowski wrote:
> On 09/01/2023 18:45, Bartosz Golaszewski wrote:
>> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>>
>> This adds basic support for the Qualcomm sa8775p platform and the
>> reference board: sa8775p-ride. The dt files describe the basics of the
>> SoC and enable booting to shell.
>>
>> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>> ---
>>   arch/arm64/boot/dts/qcom/Makefile         |   1 +
>>   arch/arm64/boot/dts/qcom/sa8775p-ride.dts |  39 +
>>   arch/arm64/boot/dts/qcom/sa8775p.dtsi     | 841 ++++++++++++++++++++++
>>   3 files changed, 881 insertions(+)
>>   create mode 100644 arch/arm64/boot/dts/qcom/sa8775p-ride.dts
>>   create mode 100644 arch/arm64/boot/dts/qcom/sa8775p.dtsi
>>
>> diff --git a/arch/arm64/boot/dts/qcom/Makefile b/arch/arm64/boot/dts/qcom/Makefile
>> index 3e79496292e7..39b8206f7131 100644
>> --- a/arch/arm64/boot/dts/qcom/Makefile
>> +++ b/arch/arm64/boot/dts/qcom/Makefile
>> @@ -61,6 +61,7 @@ dtb-$(CONFIG_ARCH_QCOM)	+= qrb5165-rb5-vision-mezzanine.dtb
>>   dtb-$(CONFIG_ARCH_QCOM)	+= sa8155p-adp.dtb
>>   dtb-$(CONFIG_ARCH_QCOM)	+= sa8295p-adp.dtb
>>   dtb-$(CONFIG_ARCH_QCOM)	+= sa8540p-ride.dtb
>> +dtb-$(CONFIG_ARCH_QCOM) += sa8775p-ride.dtb
>>   dtb-$(CONFIG_ARCH_QCOM)	+= sc7180-idp.dtb
>>   dtb-$(CONFIG_ARCH_QCOM)	+= sc7180-trogdor-coachz-r1.dtb
>>   dtb-$(CONFIG_ARCH_QCOM)	+= sc7180-trogdor-coachz-r1-lte.dtb
>> diff --git a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
>> new file mode 100644
>> index 000000000000..d4dae32a84cc
>> --- /dev/null
>> +++ b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
>> @@ -0,0 +1,39 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (c) 2023, Linaro Limited
>> + */
>> +
>> +/dts-v1/;
>> +
>> +#include "sa8775p.dtsi"
>> +
>> +/ {
>> +	model = "Qualcomm SA8875P Ride";
>> +	compatible = "qcom,sa8775p-ride", "qcom,sa8775p";
>> +
>> +	aliases {
>> +		serial0 = &uart10;
>> +	};
>> +
>> +	chosen {
>> +		stdout-path = "serial0:115200n8";
>> +	};
>> +};
>> +
>> +&qupv3_id_1 {
>> +	status = "okay";
>> +};
>> +
>> +&uart10 {
>> +	compatible = "qcom,geni-debug-uart";
>> +	status = "okay";
>> +	pinctrl-names = "default";
>> +	pinctrl-0 = <&qup_uart10_state>;
>> +};
>> +
>> +&tlmm {
>> +	qup_uart10_state: qup_uart10_state {
> 
> Does not look like you tested the DTS against bindings. Please run `make
> dtbs_check` (see Documentation/devicetree/bindings/writing-schema.rst
> for instructions).
> 
>> +		pins = "gpio46", "gpio47";
>> +		function = "qup1_se3";
>> +	};
>> +};
>> diff --git a/arch/arm64/boot/dts/qcom/sa8775p.dtsi b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
>> new file mode 100644
>> index 000000000000..1a3b11628e38
>> --- /dev/null
>> +++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
>> @@ -0,0 +1,841 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
> 
> Why GPL-2.0-only? Isn't this based on other code which is either
> dual-licensed or BSD license?
> 
>> +/*
>> + * Copyright (c) 2023, Linaro Limited
>> + */
>> +
>> +#include <dt-bindings/interrupt-controller/arm-gic.h>
>> +#include <dt-bindings/clock/qcom,gcc-sa8775p.h>
>> +#include <dt-bindings/clock/qcom,rpmh.h>
>> +#include <dt-bindings/interconnect/qcom,sa8775p.h>
>> +#include <dt-bindings/power/qcom-rpmpd.h>
>> +#include <dt-bindings/soc/qcom,rpmh-rsc.h>
>> +
>> +/ {
>> +	interrupt-parent = <&intc>;
>> +
>> +	#address-cells = <2>;
>> +	#size-cells = <2>;
>> +
>> +	clocks {
>> +		xo_board_clk: xo-board-clk {
>> +			compatible = "fixed-clock";
>> +			#clock-cells = <0>;
> 
> Your board needs clock frequency.
> 
>> +		};
>> +
>> +		sleep_clk: sleep-clk {
>> +			compatible = "fixed-clock";
>> +			#clock-cells = <0>;
>> +			clock-frequency = <32764>;
> 
> Usual comment: this (entire clock or at least its frequency) is usually
> not a property of a SoC, but board. Did something change here in SA8775?
> 
> 
>> +		};
>> +	};
>> +
>> +	cpus {
>> +		#address-cells = <2>;
>> +		#size-cells = <0>;
>> +
>> +		CPU0: cpu@0 {
>> +			device_type = "cpu";
>> +			compatible = "qcom,kryo";
>> +			reg = <0x0 0x0>;
>> +			enable-method = "psci";
>> +			next-level-cache = <&L2_0>;
>> +			L2_0: l2-cache {
>> +			      compatible = "cache";
>> +			      next-level-cache = <&L3_0>;
> 
> Messed indentation.
> 
>> +				L3_0: l3-cache {
>> +				      compatible = "cache";
>> +				};
>> +			};
>> +		};
>> +
>> +		CPU1: cpu@100 {
>> +			device_type = "cpu";
>> +			compatible = "qcom,kryo";
>> +			reg = <0x0 0x100>;
>> +			enable-method = "psci";
>> +			cpu-release-addr = <0x0 0x90000000>;
>> +			next-level-cache = <&L2_1>;
>> +			L2_1: l2-cache {
>> +			      compatible = "cache";
>> +			      next-level-cache = <&L3_0>;
>> +			};
>> +		};
>> +
>> +		CPU2: cpu@200 {
>> +			device_type = "cpu";
>> +			compatible = "qcom,kryo";
>> +			reg = <0x0 0x200>;
>> +			enable-method = "psci";
>> +			next-level-cache = <&L2_2>;
>> +			L2_2: l2-cache {
>> +			      compatible = "cache";
>> +			      next-level-cache = <&L3_0>;
>> +			};
>> +		};
>> +
>> +		CPU3: cpu@300 {
>> +			device_type = "cpu";
>> +			compatible = "qcom,kryo";
>> +			reg = <0x0 0x300>;
>> +			enable-method = "psci";
>> +			next-level-cache = <&L2_3>;
>> +			L2_3: l2-cache {
>> +			      compatible = "cache";
>> +			      next-level-cache = <&L3_0>;
>> +			};
>> +		};
>> +
>> +		CPU4: cpu@10000 {
>> +			device_type = "cpu";
>> +			compatible = "qcom,kryo";
>> +			reg = <0x0 0x10000>;
>> +			enable-method = "psci";
>> +			next-level-cache = <&L2_4>;
>> +			L2_4: l2-cache {
>> +			      compatible = "cache";
>> +			      next-level-cache = <&L3_1>;
>> +				L3_1: l3-cache {
>> +				      compatible = "cache";
>> +				};
>> +
>> +			};
>> +		};
>> +
>> +		CPU5: cpu@10100 {
>> +			device_type = "cpu";
>> +			compatible = "qcom,kryo";
>> +			reg = <0x0 0x10100>;
>> +			enable-method = "psci";
>> +			next-level-cache = <&L2_5>;
>> +			L2_5: l2-cache {
>> +			      compatible = "cache";
>> +			      next-level-cache = <&L3_1>;
>> +			};
>> +		};
>> +
>> +		CPU6: cpu@10200 {
>> +			device_type = "cpu";
>> +			compatible = "qcom,kryo";
>> +			reg = <0x0 0x10200>;
>> +			enable-method = "psci";
>> +			next-level-cache = <&L2_6>;
>> +			L2_6: l2-cache {
>> +			      compatible = "cache";
>> +			      next-level-cache = <&L3_1>;
>> +			};
>> +		};
>> +
>> +		CPU7: cpu@10300 {
>> +			device_type = "cpu";
>> +			compatible = "qcom,kryo";
>> +			reg = <0x0 0x10300>;
>> +			enable-method = "psci";
>> +			next-level-cache = <&L2_7>;
>> +			L2_7: l2-cache {
>> +			      compatible = "cache";
>> +			      next-level-cache = <&L3_1>;
>> +			};
>> +		};
>> +
>> +		cpu-map {
>> +			cluster0 {
>> +				core0 {
>> +					cpu = <&CPU0>;
>> +				};
>> +
>> +				core1 {
>> +					cpu = <&CPU1>;
>> +				};
>> +
>> +				core2 {
>> +					cpu = <&CPU2>;
>> +				};
>> +
>> +				core3 {
>> +					cpu = <&CPU3>;
>> +				};
>> +			};
>> +
>> +			cluster1 {
>> +				core0 {
>> +					cpu = <&CPU4>;
>> +				};
>> +
>> +				core1 {
>> +					cpu = <&CPU5>;
>> +				};
>> +
>> +				core2 {
>> +					cpu = <&CPU6>;
>> +				};
>> +
>> +				core3 {
>> +					cpu = <&CPU7>;
>> +				};
>> +			};
>> +		};
>> +	};
>> +
>> +	/* Will be updated by the bootloader. */
>> +	memory {
>> +		device_type = "memory";
>> +		reg = <0 0 0 0>;
>> +	};
>> +
>> +	reserved-memory {
>> +		#address-cells = <2>;
>> +		#size-cells = <2>;
>> +		ranges;
>> +
>> +		sail_ss_mem: sail_ss_region@80000000 {
> 
> No underscores in node names.
> 
> (...)
> 
>> +
>> +	qup_opp_table_100mhz: qup-100mhz-opp-table {
> 
> opp-table-....
> 
> Does not look like you tested the DTS against bindings. Please run `make
> dtbs_check` (see Documentation/devicetree/bindings/writing-schema.rst
> for instructions).
> 
>> +		compatible = "operating-points-v2";
>> +
>> +		opp-100000000 {
>> +			opp-hz = /bits/ 64 <100000000>;
>> +			required-opps = <&rpmhpd_opp_svs_l1>;
>> +		};
>> +	};
>> +
>> +	soc: soc@0 {
>> +		compatible = "simple-bus";
>> +		#address-cells = <1>;
>> +		#size-cells = <1>;

Can you please update address-cells and size-cells as <2> and update sub 
nodes accordingly?
                 #address-cells = <2>;
                 #size-cells = <2>;

>> +		ranges = <0 0 0 0xffffffff>;
>> +
>> +		gcc: clock-controller@100000 {
>> +			compatible = "qcom,gcc-sa8775p";
>> +			reg = <0x100000 0xc7018>;
>> +			#clock-cells = <1>;
>> +			#reset-cells = <1>;
>> +			#power-domain-cells = <1>;
>> +			clocks = <&rpmhcc RPMH_CXO_CLK>,
>> +				 <&sleep_clk>,
>> +				 <0>,
>> +				 <0>,
>> +				 <0>,
>> +				 <0>,
>> +				 <0>,
>> +				 <0>,
>> +				 <0>,
>> +				 <0>,
>> +				 <0>, /* TODO: usb_0_ssphy */
>> +				 <0>,
>> +				 <0>,
>> +				 <0>,
>> +				 <0>;
>> +			power-domains = <&rpmhpd SA8775P_CX>;
>> +		};
>> +
>> +		ipcc: mailbox@408000 {
>> +			compatible = "qcom,sa8775p-ipcc", "qcom,ipcc";
>> +			reg = <0x408000 0x1000>;
>> +			interrupts = <GIC_SPI 229 IRQ_TYPE_LEVEL_HIGH>;
>> +			interrupt-controller;
>> +			#interrupt-cells = <3>;
>> +			#mbox-cells = <2>;
>> +		};
>> +
>> +		aggre1_noc:interconnect-aggre1-noc {
> 
> Missing space after :
> 
>> +			compatible = "qcom,sa8775p-aggre1-noc";
> 
> This does not match your bindings, so nothing here was tested against
> your own files which you sent.
> 
>> +			#interconnect-cells = <2>;
>> +			qcom,bcm-voters = <&apps_bcm_voter>;
>> +		};
>> +
>> +		aggre2_noc: interconnect-aggre2-noc {
>> +			compatible = "qcom,sa8775p-aggre2-noc";
>> +			#interconnect-cells = <2>;
>> +			qcom,bcm-voters = <&apps_bcm_voter>;
>> +		};
>> +
>> +		clk_virt: interconnect-clk-virt {
>> +			compatible = "qcom,sa8775p-clk-virt";
>> +			#interconnect-cells = <2>;
>> +			qcom,bcm-voters = <&apps_bcm_voter>;
>> +		};
>> +
>> +		config_noc: interconnect-config-noc {
>> +			compatible = "qcom,sa8775p-config-noc";
>> +			#interconnect-cells = <2>;
>> +			qcom,bcm-voters = <&apps_bcm_voter>;
>> +		};
>> +
>> +		dc_noc: interconnect-dc-noc {
>> +			compatible = "qcom,sa8775p-dc-noc";
>> +			#interconnect-cells = <2>;
>> +			qcom,bcm-voters = <&apps_bcm_voter>;
>> +		};
>> +
>> +		gem_noc: interconnect-gem-noc {
>> +			compatible = "qcom,sa8775p-gem-noc";
>> +			#interconnect-cells = <2>;
>> +			qcom,bcm-voters = <&apps_bcm_voter>;
>> +		};
>> +
>> +		gpdsp_anoc: interconnect-gpdsp-anoc {
>> +			compatible = "qcom,sa8775p-gpdsp-anoc";
>> +			#interconnect-cells = <2>;
>> +			qcom,bcm-voters = <&apps_bcm_voter>;
>> +		};
>> +
>> +		lpass_ag_noc: interconnect-lpass-ag-noc {
>> +			compatible = "qcom,sa8775p-lpass-ag-noc";
>> +			#interconnect-cells = <2>;
>> +			qcom,bcm-voters = <&apps_bcm_voter>;
>> +		};
>> +
>> +		mc_virt: interconnect-mc-virt {
>> +			compatible = "qcom,sa8775p-mc-virt";
>> +			#interconnect-cells = <2>;
>> +			qcom,bcm-voters = <&apps_bcm_voter>;
>> +		};
>> +
>> +		mmss_noc: interconnect-mmss-noc {
>> +			compatible = "qcom,sa8775p-mmss-noc";
>> +			#interconnect-cells = <2>;
>> +			qcom,bcm-voters = <&apps_bcm_voter>;
>> +		};
>> +
>> +		nspa_noc: interconnect-nspa-noc {
>> +			compatible = "qcom,sa8775p-nspa-noc";
>> +			#interconnect-cells = <2>;
>> +			qcom,bcm-voters = <&apps_bcm_voter>;
>> +		};
>> +
>> +		nspb_noc: interconnect-nspb-noc {
>> +			compatible = "qcom,sa8775p-nspb-noc";
>> +			#interconnect-cells = <2>;
>> +			qcom,bcm-voters = <&apps_bcm_voter>;
>> +		};
>> +
>> +		pcie_anoc: interconnect-pcie-anoc {
>> +			compatible = "qcom,sa8775p-pcie-anoc";
>> +			#interconnect-cells = <2>;
>> +			qcom,bcm-voters = <&apps_bcm_voter>;
>> +		};
>> +
>> +		system_noc: interconnect-system-noc {
>> +			compatible = "qcom,sa8775p-system-noc";
>> +			#interconnect-cells = <2>;
>> +			qcom,bcm-voters = <&apps_bcm_voter>;
>> +		};
>> +
>> +		intc: interrupt-controller@17a00000 {
>> +			compatible = "arm,gic-v3";
>> +			#interrupt-cells = <3>;
>> +			interrupt-controller;
>> +			#address-cells = <1>;
>> +			#size-cells = <1>;
>> +			ranges;
>> +			#redistributor-regions = <1>;
>> +			redistributor-stride = <0x0 0x20000>;
>> +			reg = <0x17a00000 0x10000>,     /* GICD */
>> +			      <0x17a60000 0x100000>;    /* GICR * 8 */
> 
> Compatible goes first, then reg, then ranges.
> 
>> +			interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_HIGH>;
>> +		};
>> +
>> +		apps_rsc: rsc@18200000 {
>> +			compatible = "qcom,rpmh-rsc";
>> +			reg = <0x18200000 0x10000>,
>> +			      <0x18210000 0x10000>,
>> +			      <0x18220000 0x10000>;
>> +			reg-names = "drv-0", "drv-1", "drv-2";
>> +			interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>,
>> +			      <GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>,
>> +			      <GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>;
>> +			qcom,tcs-offset = <0xd00>;
>> +			qcom,drv-id = <2>;
>> +			qcom,tcs-config = <ACTIVE_TCS 2>,
>> +					  <SLEEP_TCS 3>,
>> +					  <WAKE_TCS 3>,
>> +					  <CONTROL_TCS 0>;
>> +			label = "apps_rsc";
>> +
>> +			apps_bcm_voter: bcm_voter {
> 
> Does not look like you tested the DTS against bindings. Please run `make
> dtbs_check` (see Documentation/devicetree/bindings/writing-schema.rst
> for instructions).
> 
>> +				compatible = "qcom,bcm-voter";
>> +			};
>> +
>> +			rpmhcc: clock-controller {
>> +				compatible = "qcom,sa8775p-rpmh-clk";
>> +				#clock-cells = <1>;
>> +				clock-names = "xo";
>> +				clocks = <&xo_board_clk>;
>> +			};
>> +
>> +			rpmhpd: power-controller {
>> +				compatible = "qcom,sa8775p-rpmhpd";
>> +				#power-domain-cells = <1>;
>> +				operating-points-v2 = <&rpmhpd_opp_table>;
>> +
>> +				rpmhpd_opp_table: opp-table {
>> +					compatible = "operating-points-v2";
>> +
>> +					rpmhpd_opp_ret: opp1 {
> 
> opp-0
> (so numbering from 0 and hyphen)
> 
>> +						opp-level = <RPMH_REGULATOR_LEVEL_RETENTION>;
>> +					};
>> +
>> +					rpmhpd_opp_min_svs: opp2 {
> 
> opp-1
> 
>> +						opp-level = <RPMH_REGULATOR_LEVEL_MIN_SVS>;
>> +					};
>> +
>> +					rpmhpd_opp_low_svs: opp3 {
>> +						opp-level = <RPMH_REGULATOR_LEVEL_LOW_SVS>;
>> +					};
>> +
>> +					rpmhpd_opp_svs: opp4 {
>> +						opp-level = <RPMH_REGULATOR_LEVEL_SVS>;
>> +					};
>> +
>> +					rpmhpd_opp_svs_l1: opp5 {
>> +						opp-level = <RPMH_REGULATOR_LEVEL_SVS_L1>;
>> +					};
>> +
>> +					rpmhpd_opp_nom: opp6 {
>> +						opp-level = <RPMH_REGULATOR_LEVEL_NOM>;
>> +					};
>> +
>> +					rpmhpd_opp_nom_l1: opp7 {
>> +						opp-level = <RPMH_REGULATOR_LEVEL_NOM_L1>;
>> +					};
>> +
>> +					rpmhpd_opp_nom_l2: opp8 {
>> +						opp-level = <RPMH_REGULATOR_LEVEL_NOM_L2>;
>> +					};
>> +
>> +					rpmhpd_opp_turbo: opp9 {
>> +						opp-level = <RPMH_REGULATOR_LEVEL_TURBO>;
>> +					};
>> +
>> +					rpmhpd_opp_turbo_l1: opp10 {
>> +						opp-level = <RPMH_REGULATOR_LEVEL_TURBO_L1>;
>> +					};
>> +				};
>> +			};
>> +		};
>> +
>> +		arch_timer: timer {
>> +			compatible = "arm,armv8-timer";
>> +			interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>,
>> +				     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>,
>> +				     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>,
>> +				     <GIC_PPI 12 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>;
>> +			clock-frequency = <19200000>;
>> +		};
>> +
>> +		memtimer: timer@17c20000 {
> 
> Why this one is outside of soc node? Or are we inside soc? But then
> ARMv8 timer cannot be here... dtbs W=1 would warn you, wouldn't it?
> 
> 
>> +			#address-cells = <1>;
>> +			#size-cells = <1>;
>> +			ranges;
>> +			compatible = "arm,armv7-timer-mem";
> 
> Weird order of properties.
> 
>> +			reg = <0x17c20000 0x1000>;
>> +			clock-frequency = <19200000>;
>> +
>> +			frame@17c21000 {
>> +				frame-number = <0>;
>> +				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
>> +					     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
>> +				reg = <0x17c21000 0x1000>,
>> +				      <0x17c22000 0x1000>;
>> +			};
>> +
>> +			frame@17c23000 {
>> +				frame-number = <1>;
>> +				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
>> +				reg = <0x17c23000 0x1000>;
>> +				status = "disabled";
>> +			};
>> +
>> +			frame@17c25000 {
>> +				frame-number = <2>;
>> +				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
>> +				reg = <0x17c25000 0x1000>;
>> +				status = "disabled";
>> +			};
>> +
>> +			frame@17c27000 {
>> +				frame-number = <3>;
>> +				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
>> +				reg = <0x17c27000 0x1000>;
>> +				status = "disabled";
>> +			};
>> +
>> +			frame@17c29000 {
>> +				frame-number = <4>;
>> +				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
>> +				reg = <0x17c29000 0x1000>;
>> +				status = "disabled";
>> +			};
>> +
>> +			frame@17c2b000 {
>> +				frame-number = <5>;
>> +				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
>> +				reg = <0x17c2b000 0x1000>;
>> +				status = "disabled";
>> +			};
>> +
>> +			frame@17c2d000 {
>> +				frame-number = <6>;
>> +				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
>> +				reg = <0x17c2d000 0x1000>;
>> +				status = "disabled";
>> +			};
>> +		};
>> +
>> +		tcsr_mutex: hwlock@1f40000 {
>> +			compatible = "qcom,tcsr-mutex";
>> +			reg = <0x1f40000 0x20000>;
>> +			#hwlock-cells = <1>;
>> +		};
>> +
>> +		tlmm: pinctrl@f000000 {
>> +			compatible = "qcom,sa8775p-pinctrl";
>> +			reg = <0xf000000 0x1000000>;
>> +			interrupts = <GIC_SPI 208 IRQ_TYPE_LEVEL_HIGH>;
>> +			gpio-controller;
>> +			#gpio-cells = <2>;
>> +			interrupt-controller;
>> +			#interrupt-cells = <2>;
>> +			gpio-ranges = <&tlmm 0 0 149>;
>> +		};
>> +
>> +		qcom-wdt@17c10000 {
> 
> Node names should be generic.
> https://devicetree-specification.readthedocs.io/en/latest/chapter2-devicetree-basics.html#generic-names-recommendation
> 
>> +			compatible = "qcom,kpss-wdt";
>> +			reg = <0x17c10000 0x1000>;
>> +			clocks = <&sleep_clk>;
>> +			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
>> +		};
>> +
>> +		qupv3_id_1: geniqup@ac0000 {
>> +			compatible = "qcom,geni-se-qup";
>> +			reg = <0xac0000 0x6000>;
>> +			#address-cells = <1>;
>> +			#size-cells = <1>;
>> +			ranges;
>> +			clock-names = "m-ahb", "s-ahb";
>> +			clocks = <&gcc GCC_QUPV3_WRAP_1_M_AHB_CLK>,
>> +				 <&gcc GCC_QUPV3_WRAP_1_S_AHB_CLK>;
>> +			iommus = <&apps_smmu 0x443 0x0>;
>> +			status = "disabled";
>> +
>> +			uart10: serial@a8c000 {
>> +				compatible = "qcom,geni-uart";
>> +				reg = <0xa8c000 0x4000>;
>> +				interrupts = <GIC_SPI 356 IRQ_TYPE_LEVEL_HIGH>;
>> +				clock-names = "se";
>> +				clocks = <&gcc GCC_QUPV3_WRAP1_S3_CLK>;
>> +				interconnect-names = "qup-core", "qup-config", "qup-memory";
>> +				interconnects = <&clk_virt MASTER_QUP_CORE_1 0 &clk_virt SLAVE_QUP_CORE_1 0>,
>> +						<&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_QUP_1 0>,
>> +						<&aggre2_noc MASTER_QUP_1 0 &mc_virt SLAVE_EBI1 0>;
>> +				power-domains = <&rpmhpd SA8775P_CX>;
>> +				operating-points-v2 = <&qup_opp_table_100mhz>;
>> +				status = "disabled";
>> +			};
>> +		};
>> +
>> +		apps_smmu: apps-smmu@15000000 {
> 
> iommu, node names should be generic.
> https://devicetree-specification.readthedocs.io/en/latest/chapter2-devicetree-basics.html#generic-names-recommendation
> 
> and probably also fails dtbs_check...
> 
>> +			compatible = "qcom,sa8775p-smmu-500", "arm,mmu-500";
>> +			reg = <0x15000000 0x100000>, <0x15182000 0x28>;
>> +			reg-names = "base", "tcu-base";
>> +			#iommu-cells = <2>;
>> +			qcom,skip-init;
>> +			qcom,use-3-lvl-tables;
>> +			#global-interrupts = <2>;
>> +			#size-cells = <1>;
> 
> Best regards,
> Krzysztof
> 
> 
> 
