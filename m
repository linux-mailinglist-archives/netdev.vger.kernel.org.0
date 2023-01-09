Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625A4662F50
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbjAIShZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237757AbjAISgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:36:42 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5F95F486
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:34:58 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id ay40so6954501wmb.2
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nut8pVk5fOGNWWeY/9WgxAZr+sZ34pqrVl56mvsfpZA=;
        b=nYsZ97f02CBDlnmJODzWxykWn8vTMdHAvyLa0D2n5Ehc4GU/spL6TEDkZtI06dmy+B
         NeFA5H4zKJst502j1PDxrGS3Qjhxiv39OonbFXIfbnwEHqalujq/5BWVUyv1GsQ6FzXp
         3e+Tzo2myIkVe73v6I/gKXnMINWVNh/nyLwGJKcY50psW08Nk3vgBMFRYqCkymdzhfXc
         CqwCnW3mo2dTzHRH5PxJsQ2JAGWhxwr89GKSrFhUbRW9xNMOFI1uLvwuhLJC24ecx3R/
         UCbch1vXS+qfMK/iDNrEzu8q4WLN1sx6bVty4CFQqzGkSFJhf6Ee5zvGDysa7GAkSfl5
         d1Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nut8pVk5fOGNWWeY/9WgxAZr+sZ34pqrVl56mvsfpZA=;
        b=j/YgZ9vjhJXVhvYyN5KK7jcue55PuoZhnpz3ZHmjEOi3pbwAfsu6ctQgNVY127tvZz
         OnvZDOpkDmC5BRsuy9gEe2LoDRl5cARYLDdKzdD3v4dMjLXOqdlk21uM25z0qVw4hTr/
         0jK1GmbivRYQHRqXUaPvEe45APZRQbcRc5PZejNxARQfMqm21QEEwNWgbiMg7bhGQciA
         +aRZGhtV8qWMZPG8zH1uzZBFQ9Cf2l2PjGcK6ftBmJF3f9K1Dalu9y7zYEyjpK5uzFbM
         +SGAw85DygKSs2ZSPq+iLRDR3UdfRuanoJzau/eE/yDJjchhBeCTc9egG275uiCPFsBB
         1GfA==
X-Gm-Message-State: AFqh2kpIj+2AFxu5n2FcOAxbubU0jkKqdqxxwYAGq9ghIRuoUdMRMFt7
        TzTr3vG6i8kpiAuMBHh+QE8wtw==
X-Google-Smtp-Source: AMrXdXtESr0DvS3mv9LHqJ6/ZvZrBqzczlfoQwj1k2u8TNR93LTTDdRAmMLokVs305lv8ZQyzj70Vg==
X-Received: by 2002:a05:600c:1d16:b0:3d1:fe93:f1d3 with SMTP id l22-20020a05600c1d1600b003d1fe93f1d3mr48397591wms.36.1673289297438;
        Mon, 09 Jan 2023 10:34:57 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id bi22-20020a05600c3d9600b003d208eb17ecsm12226845wmb.26.2023.01.09.10.34.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 10:34:57 -0800 (PST)
Message-ID: <f3a87b5b-5a9f-b19f-b16f-cd5a7394f4f0@linaro.org>
Date:   Mon, 9 Jan 2023 19:34:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 18/18] arm64: dts: qcom: add initial support for qcom
 sa8775p-ride
Content-Language: en-US
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
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
        Vinod Koul <vkoul@kernel.org>, Alex Elder <elder@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux.dev, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20230109174511.1740856-1-brgl@bgdev.pl>
 <20230109174511.1740856-19-brgl@bgdev.pl>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230109174511.1740856-19-brgl@bgdev.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/01/2023 18:45, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> This adds basic support for the Qualcomm sa8775p platform and the
> reference board: sa8775p-ride. The dt files describe the basics of the
> SoC and enable booting to shell.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>  arch/arm64/boot/dts/qcom/Makefile         |   1 +
>  arch/arm64/boot/dts/qcom/sa8775p-ride.dts |  39 +
>  arch/arm64/boot/dts/qcom/sa8775p.dtsi     | 841 ++++++++++++++++++++++
>  3 files changed, 881 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/qcom/sa8775p-ride.dts
>  create mode 100644 arch/arm64/boot/dts/qcom/sa8775p.dtsi
> 
> diff --git a/arch/arm64/boot/dts/qcom/Makefile b/arch/arm64/boot/dts/qcom/Makefile
> index 3e79496292e7..39b8206f7131 100644
> --- a/arch/arm64/boot/dts/qcom/Makefile
> +++ b/arch/arm64/boot/dts/qcom/Makefile
> @@ -61,6 +61,7 @@ dtb-$(CONFIG_ARCH_QCOM)	+= qrb5165-rb5-vision-mezzanine.dtb
>  dtb-$(CONFIG_ARCH_QCOM)	+= sa8155p-adp.dtb
>  dtb-$(CONFIG_ARCH_QCOM)	+= sa8295p-adp.dtb
>  dtb-$(CONFIG_ARCH_QCOM)	+= sa8540p-ride.dtb
> +dtb-$(CONFIG_ARCH_QCOM) += sa8775p-ride.dtb
>  dtb-$(CONFIG_ARCH_QCOM)	+= sc7180-idp.dtb
>  dtb-$(CONFIG_ARCH_QCOM)	+= sc7180-trogdor-coachz-r1.dtb
>  dtb-$(CONFIG_ARCH_QCOM)	+= sc7180-trogdor-coachz-r1-lte.dtb
> diff --git a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
> new file mode 100644
> index 000000000000..d4dae32a84cc
> --- /dev/null
> +++ b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
> @@ -0,0 +1,39 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2023, Linaro Limited
> + */
> +
> +/dts-v1/;
> +
> +#include "sa8775p.dtsi"
> +
> +/ {
> +	model = "Qualcomm SA8875P Ride";
> +	compatible = "qcom,sa8775p-ride", "qcom,sa8775p";
> +
> +	aliases {
> +		serial0 = &uart10;
> +	};
> +
> +	chosen {
> +		stdout-path = "serial0:115200n8";
> +	};
> +};
> +
> +&qupv3_id_1 {
> +	status = "okay";
> +};
> +
> +&uart10 {
> +	compatible = "qcom,geni-debug-uart";
> +	status = "okay";
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&qup_uart10_state>;
> +};
> +
> +&tlmm {
> +	qup_uart10_state: qup_uart10_state {

Does not look like you tested the DTS against bindings. Please run `make
dtbs_check` (see Documentation/devicetree/bindings/writing-schema.rst
for instructions).

> +		pins = "gpio46", "gpio47";
> +		function = "qup1_se3";
> +	};
> +};
> diff --git a/arch/arm64/boot/dts/qcom/sa8775p.dtsi b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
> new file mode 100644
> index 000000000000..1a3b11628e38
> --- /dev/null
> +++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
> @@ -0,0 +1,841 @@
> +// SPDX-License-Identifier: GPL-2.0-only

Why GPL-2.0-only? Isn't this based on other code which is either
dual-licensed or BSD license?

> +/*
> + * Copyright (c) 2023, Linaro Limited
> + */
> +
> +#include <dt-bindings/interrupt-controller/arm-gic.h>
> +#include <dt-bindings/clock/qcom,gcc-sa8775p.h>
> +#include <dt-bindings/clock/qcom,rpmh.h>
> +#include <dt-bindings/interconnect/qcom,sa8775p.h>
> +#include <dt-bindings/power/qcom-rpmpd.h>
> +#include <dt-bindings/soc/qcom,rpmh-rsc.h>
> +
> +/ {
> +	interrupt-parent = <&intc>;
> +
> +	#address-cells = <2>;
> +	#size-cells = <2>;
> +
> +	clocks {
> +		xo_board_clk: xo-board-clk {
> +			compatible = "fixed-clock";
> +			#clock-cells = <0>;

Your board needs clock frequency.

> +		};
> +
> +		sleep_clk: sleep-clk {
> +			compatible = "fixed-clock";
> +			#clock-cells = <0>;
> +			clock-frequency = <32764>;

Usual comment: this (entire clock or at least its frequency) is usually
not a property of a SoC, but board. Did something change here in SA8775?


> +		};
> +	};
> +
> +	cpus {
> +		#address-cells = <2>;
> +		#size-cells = <0>;
> +
> +		CPU0: cpu@0 {
> +			device_type = "cpu";
> +			compatible = "qcom,kryo";
> +			reg = <0x0 0x0>;
> +			enable-method = "psci";
> +			next-level-cache = <&L2_0>;
> +			L2_0: l2-cache {
> +			      compatible = "cache";
> +			      next-level-cache = <&L3_0>;

Messed indentation.

> +				L3_0: l3-cache {
> +				      compatible = "cache";
> +				};
> +			};
> +		};
> +
> +		CPU1: cpu@100 {
> +			device_type = "cpu";
> +			compatible = "qcom,kryo";
> +			reg = <0x0 0x100>;
> +			enable-method = "psci";
> +			cpu-release-addr = <0x0 0x90000000>;
> +			next-level-cache = <&L2_1>;
> +			L2_1: l2-cache {
> +			      compatible = "cache";
> +			      next-level-cache = <&L3_0>;
> +			};
> +		};
> +
> +		CPU2: cpu@200 {
> +			device_type = "cpu";
> +			compatible = "qcom,kryo";
> +			reg = <0x0 0x200>;
> +			enable-method = "psci";
> +			next-level-cache = <&L2_2>;
> +			L2_2: l2-cache {
> +			      compatible = "cache";
> +			      next-level-cache = <&L3_0>;
> +			};
> +		};
> +
> +		CPU3: cpu@300 {
> +			device_type = "cpu";
> +			compatible = "qcom,kryo";
> +			reg = <0x0 0x300>;
> +			enable-method = "psci";
> +			next-level-cache = <&L2_3>;
> +			L2_3: l2-cache {
> +			      compatible = "cache";
> +			      next-level-cache = <&L3_0>;
> +			};
> +		};
> +
> +		CPU4: cpu@10000 {
> +			device_type = "cpu";
> +			compatible = "qcom,kryo";
> +			reg = <0x0 0x10000>;
> +			enable-method = "psci";
> +			next-level-cache = <&L2_4>;
> +			L2_4: l2-cache {
> +			      compatible = "cache";
> +			      next-level-cache = <&L3_1>;
> +				L3_1: l3-cache {
> +				      compatible = "cache";
> +				};
> +
> +			};
> +		};
> +
> +		CPU5: cpu@10100 {
> +			device_type = "cpu";
> +			compatible = "qcom,kryo";
> +			reg = <0x0 0x10100>;
> +			enable-method = "psci";
> +			next-level-cache = <&L2_5>;
> +			L2_5: l2-cache {
> +			      compatible = "cache";
> +			      next-level-cache = <&L3_1>;
> +			};
> +		};
> +
> +		CPU6: cpu@10200 {
> +			device_type = "cpu";
> +			compatible = "qcom,kryo";
> +			reg = <0x0 0x10200>;
> +			enable-method = "psci";
> +			next-level-cache = <&L2_6>;
> +			L2_6: l2-cache {
> +			      compatible = "cache";
> +			      next-level-cache = <&L3_1>;
> +			};
> +		};
> +
> +		CPU7: cpu@10300 {
> +			device_type = "cpu";
> +			compatible = "qcom,kryo";
> +			reg = <0x0 0x10300>;
> +			enable-method = "psci";
> +			next-level-cache = <&L2_7>;
> +			L2_7: l2-cache {
> +			      compatible = "cache";
> +			      next-level-cache = <&L3_1>;
> +			};
> +		};
> +
> +		cpu-map {
> +			cluster0 {
> +				core0 {
> +					cpu = <&CPU0>;
> +				};
> +
> +				core1 {
> +					cpu = <&CPU1>;
> +				};
> +
> +				core2 {
> +					cpu = <&CPU2>;
> +				};
> +
> +				core3 {
> +					cpu = <&CPU3>;
> +				};
> +			};
> +
> +			cluster1 {
> +				core0 {
> +					cpu = <&CPU4>;
> +				};
> +
> +				core1 {
> +					cpu = <&CPU5>;
> +				};
> +
> +				core2 {
> +					cpu = <&CPU6>;
> +				};
> +
> +				core3 {
> +					cpu = <&CPU7>;
> +				};
> +			};
> +		};
> +	};
> +
> +	/* Will be updated by the bootloader. */
> +	memory {
> +		device_type = "memory";
> +		reg = <0 0 0 0>;
> +	};
> +
> +	reserved-memory {
> +		#address-cells = <2>;
> +		#size-cells = <2>;
> +		ranges;
> +
> +		sail_ss_mem: sail_ss_region@80000000 {

No underscores in node names.

(...)

> +
> +	qup_opp_table_100mhz: qup-100mhz-opp-table {

opp-table-....

Does not look like you tested the DTS against bindings. Please run `make
dtbs_check` (see Documentation/devicetree/bindings/writing-schema.rst
for instructions).

> +		compatible = "operating-points-v2";
> +
> +		opp-100000000 {
> +			opp-hz = /bits/ 64 <100000000>;
> +			required-opps = <&rpmhpd_opp_svs_l1>;
> +		};
> +	};
> +
> +	soc: soc@0 {
> +		compatible = "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges = <0 0 0 0xffffffff>;
> +
> +		gcc: clock-controller@100000 {
> +			compatible = "qcom,gcc-sa8775p";
> +			reg = <0x100000 0xc7018>;
> +			#clock-cells = <1>;
> +			#reset-cells = <1>;
> +			#power-domain-cells = <1>;
> +			clocks = <&rpmhcc RPMH_CXO_CLK>,
> +				 <&sleep_clk>,
> +				 <0>,
> +				 <0>,
> +				 <0>,
> +				 <0>,
> +				 <0>,
> +				 <0>,
> +				 <0>,
> +				 <0>,
> +				 <0>, /* TODO: usb_0_ssphy */
> +				 <0>,
> +				 <0>,
> +				 <0>,
> +				 <0>;
> +			power-domains = <&rpmhpd SA8775P_CX>;
> +		};
> +
> +		ipcc: mailbox@408000 {
> +			compatible = "qcom,sa8775p-ipcc", "qcom,ipcc";
> +			reg = <0x408000 0x1000>;
> +			interrupts = <GIC_SPI 229 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupt-controller;
> +			#interrupt-cells = <3>;
> +			#mbox-cells = <2>;
> +		};
> +
> +		aggre1_noc:interconnect-aggre1-noc {

Missing space after :

> +			compatible = "qcom,sa8775p-aggre1-noc";

This does not match your bindings, so nothing here was tested against
your own files which you sent.

> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		aggre2_noc: interconnect-aggre2-noc {
> +			compatible = "qcom,sa8775p-aggre2-noc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		clk_virt: interconnect-clk-virt {
> +			compatible = "qcom,sa8775p-clk-virt";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		config_noc: interconnect-config-noc {
> +			compatible = "qcom,sa8775p-config-noc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		dc_noc: interconnect-dc-noc {
> +			compatible = "qcom,sa8775p-dc-noc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		gem_noc: interconnect-gem-noc {
> +			compatible = "qcom,sa8775p-gem-noc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		gpdsp_anoc: interconnect-gpdsp-anoc {
> +			compatible = "qcom,sa8775p-gpdsp-anoc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		lpass_ag_noc: interconnect-lpass-ag-noc {
> +			compatible = "qcom,sa8775p-lpass-ag-noc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		mc_virt: interconnect-mc-virt {
> +			compatible = "qcom,sa8775p-mc-virt";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		mmss_noc: interconnect-mmss-noc {
> +			compatible = "qcom,sa8775p-mmss-noc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		nspa_noc: interconnect-nspa-noc {
> +			compatible = "qcom,sa8775p-nspa-noc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		nspb_noc: interconnect-nspb-noc {
> +			compatible = "qcom,sa8775p-nspb-noc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		pcie_anoc: interconnect-pcie-anoc {
> +			compatible = "qcom,sa8775p-pcie-anoc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		system_noc: interconnect-system-noc {
> +			compatible = "qcom,sa8775p-system-noc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		intc: interrupt-controller@17a00000 {
> +			compatible = "arm,gic-v3";
> +			#interrupt-cells = <3>;
> +			interrupt-controller;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges;
> +			#redistributor-regions = <1>;
> +			redistributor-stride = <0x0 0x20000>;
> +			reg = <0x17a00000 0x10000>,     /* GICD */
> +			      <0x17a60000 0x100000>;    /* GICR * 8 */

Compatible goes first, then reg, then ranges.

> +			interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_HIGH>;
> +		};
> +
> +		apps_rsc: rsc@18200000 {
> +			compatible = "qcom,rpmh-rsc";
> +			reg = <0x18200000 0x10000>,
> +			      <0x18210000 0x10000>,
> +			      <0x18220000 0x10000>;
> +			reg-names = "drv-0", "drv-1", "drv-2";
> +			interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>,
> +			      <GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>,
> +			      <GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>;
> +			qcom,tcs-offset = <0xd00>;
> +			qcom,drv-id = <2>;
> +			qcom,tcs-config = <ACTIVE_TCS 2>,
> +					  <SLEEP_TCS 3>,
> +					  <WAKE_TCS 3>,
> +					  <CONTROL_TCS 0>;
> +			label = "apps_rsc";
> +
> +			apps_bcm_voter: bcm_voter {

Does not look like you tested the DTS against bindings. Please run `make
dtbs_check` (see Documentation/devicetree/bindings/writing-schema.rst
for instructions).

> +				compatible = "qcom,bcm-voter";
> +			};
> +
> +			rpmhcc: clock-controller {
> +				compatible = "qcom,sa8775p-rpmh-clk";
> +				#clock-cells = <1>;
> +				clock-names = "xo";
> +				clocks = <&xo_board_clk>;
> +			};
> +
> +			rpmhpd: power-controller {
> +				compatible = "qcom,sa8775p-rpmhpd";
> +				#power-domain-cells = <1>;
> +				operating-points-v2 = <&rpmhpd_opp_table>;
> +
> +				rpmhpd_opp_table: opp-table {
> +					compatible = "operating-points-v2";
> +
> +					rpmhpd_opp_ret: opp1 {

opp-0
(so numbering from 0 and hyphen)

> +						opp-level = <RPMH_REGULATOR_LEVEL_RETENTION>;
> +					};
> +
> +					rpmhpd_opp_min_svs: opp2 {

opp-1

> +						opp-level = <RPMH_REGULATOR_LEVEL_MIN_SVS>;
> +					};
> +
> +					rpmhpd_opp_low_svs: opp3 {
> +						opp-level = <RPMH_REGULATOR_LEVEL_LOW_SVS>;
> +					};
> +
> +					rpmhpd_opp_svs: opp4 {
> +						opp-level = <RPMH_REGULATOR_LEVEL_SVS>;
> +					};
> +
> +					rpmhpd_opp_svs_l1: opp5 {
> +						opp-level = <RPMH_REGULATOR_LEVEL_SVS_L1>;
> +					};
> +
> +					rpmhpd_opp_nom: opp6 {
> +						opp-level = <RPMH_REGULATOR_LEVEL_NOM>;
> +					};
> +
> +					rpmhpd_opp_nom_l1: opp7 {
> +						opp-level = <RPMH_REGULATOR_LEVEL_NOM_L1>;
> +					};
> +
> +					rpmhpd_opp_nom_l2: opp8 {
> +						opp-level = <RPMH_REGULATOR_LEVEL_NOM_L2>;
> +					};
> +
> +					rpmhpd_opp_turbo: opp9 {
> +						opp-level = <RPMH_REGULATOR_LEVEL_TURBO>;
> +					};
> +
> +					rpmhpd_opp_turbo_l1: opp10 {
> +						opp-level = <RPMH_REGULATOR_LEVEL_TURBO_L1>;
> +					};
> +				};
> +			};
> +		};
> +
> +		arch_timer: timer {
> +			compatible = "arm,armv8-timer";
> +			interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>,
> +				     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>,
> +				     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>,
> +				     <GIC_PPI 12 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>;
> +			clock-frequency = <19200000>;
> +		};
> +
> +		memtimer: timer@17c20000 {

Why this one is outside of soc node? Or are we inside soc? But then
ARMv8 timer cannot be here... dtbs W=1 would warn you, wouldn't it?


> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges;
> +			compatible = "arm,armv7-timer-mem";

Weird order of properties.

> +			reg = <0x17c20000 0x1000>;
> +			clock-frequency = <19200000>;
> +
> +			frame@17c21000 {
> +				frame-number = <0>;
> +				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
> +					     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
> +				reg = <0x17c21000 0x1000>,
> +				      <0x17c22000 0x1000>;
> +			};
> +
> +			frame@17c23000 {
> +				frame-number = <1>;
> +				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
> +				reg = <0x17c23000 0x1000>;
> +				status = "disabled";
> +			};
> +
> +			frame@17c25000 {
> +				frame-number = <2>;
> +				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
> +				reg = <0x17c25000 0x1000>;
> +				status = "disabled";
> +			};
> +
> +			frame@17c27000 {
> +				frame-number = <3>;
> +				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
> +				reg = <0x17c27000 0x1000>;
> +				status = "disabled";
> +			};
> +
> +			frame@17c29000 {
> +				frame-number = <4>;
> +				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
> +				reg = <0x17c29000 0x1000>;
> +				status = "disabled";
> +			};
> +
> +			frame@17c2b000 {
> +				frame-number = <5>;
> +				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
> +				reg = <0x17c2b000 0x1000>;
> +				status = "disabled";
> +			};
> +
> +			frame@17c2d000 {
> +				frame-number = <6>;
> +				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
> +				reg = <0x17c2d000 0x1000>;
> +				status = "disabled";
> +			};
> +		};
> +
> +		tcsr_mutex: hwlock@1f40000 {
> +			compatible = "qcom,tcsr-mutex";
> +			reg = <0x1f40000 0x20000>;
> +			#hwlock-cells = <1>;
> +		};
> +
> +		tlmm: pinctrl@f000000 {
> +			compatible = "qcom,sa8775p-pinctrl";
> +			reg = <0xf000000 0x1000000>;
> +			interrupts = <GIC_SPI 208 IRQ_TYPE_LEVEL_HIGH>;
> +			gpio-controller;
> +			#gpio-cells = <2>;
> +			interrupt-controller;
> +			#interrupt-cells = <2>;
> +			gpio-ranges = <&tlmm 0 0 149>;
> +		};
> +
> +		qcom-wdt@17c10000 {

Node names should be generic.
https://devicetree-specification.readthedocs.io/en/latest/chapter2-devicetree-basics.html#generic-names-recommendation

> +			compatible = "qcom,kpss-wdt";
> +			reg = <0x17c10000 0x1000>;
> +			clocks = <&sleep_clk>;
> +			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
> +		};
> +
> +		qupv3_id_1: geniqup@ac0000 {
> +			compatible = "qcom,geni-se-qup";
> +			reg = <0xac0000 0x6000>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges;
> +			clock-names = "m-ahb", "s-ahb";
> +			clocks = <&gcc GCC_QUPV3_WRAP_1_M_AHB_CLK>,
> +				 <&gcc GCC_QUPV3_WRAP_1_S_AHB_CLK>;
> +			iommus = <&apps_smmu 0x443 0x0>;
> +			status = "disabled";
> +
> +			uart10: serial@a8c000 {
> +				compatible = "qcom,geni-uart";
> +				reg = <0xa8c000 0x4000>;
> +				interrupts = <GIC_SPI 356 IRQ_TYPE_LEVEL_HIGH>;
> +				clock-names = "se";
> +				clocks = <&gcc GCC_QUPV3_WRAP1_S3_CLK>;
> +				interconnect-names = "qup-core", "qup-config", "qup-memory";
> +				interconnects = <&clk_virt MASTER_QUP_CORE_1 0 &clk_virt SLAVE_QUP_CORE_1 0>,
> +						<&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_QUP_1 0>,
> +						<&aggre2_noc MASTER_QUP_1 0 &mc_virt SLAVE_EBI1 0>;
> +				power-domains = <&rpmhpd SA8775P_CX>;
> +				operating-points-v2 = <&qup_opp_table_100mhz>;
> +				status = "disabled";
> +			};
> +		};
> +
> +		apps_smmu: apps-smmu@15000000 {

iommu, node names should be generic.
https://devicetree-specification.readthedocs.io/en/latest/chapter2-devicetree-basics.html#generic-names-recommendation

and probably also fails dtbs_check...

> +			compatible = "qcom,sa8775p-smmu-500", "arm,mmu-500";
> +			reg = <0x15000000 0x100000>, <0x15182000 0x28>;
> +			reg-names = "base", "tcu-base";
> +			#iommu-cells = <2>;
> +			qcom,skip-init;
> +			qcom,use-3-lvl-tables;
> +			#global-interrupts = <2>;
> +			#size-cells = <1>;

Best regards,
Krzysztof

