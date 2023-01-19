Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7AF6740BE
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 19:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjASSUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 13:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjASSUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 13:20:00 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F171449F;
        Thu, 19 Jan 2023 10:19:58 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id f12-20020a7bc8cc000000b003daf6b2f9b9so4159590wml.3;
        Thu, 19 Jan 2023 10:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oHH+KmVkm4uaS5su6DhQGdf280FMF9BCxat013P5oGQ=;
        b=GqKp2vOVQlufREuR+mxKuUX/qXUZVhR/2fU4TQRP7zRuP3onF9SvxcIZUU12qbKKO3
         GA74CUGvcgfj6xg9d0591RN7dfxwN3w4OPiF9QfYA/Fw4pL64+hAXaHEGkCtBr/nsHZ/
         Ta7SSWWR89aEi1FET0Hx9aJPYmJmFGAedLZKagiMBQ5+tZcMP6WFARpaGl3pAQAoAnO3
         FDJVcuUvZxnnBxSsfze+rlI0Wpe4dIqXmHjPYSUh6EooRGvn/QDZ1pEXoGwi0l2z5zPo
         cAmbd+2ubz9AZW7mbV4O3DqfDoIXPKkCGf9foK+oJZ/Oe/3hM2+FeStvV+iIhkqCcEfZ
         UNww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oHH+KmVkm4uaS5su6DhQGdf280FMF9BCxat013P5oGQ=;
        b=0yfpIhrIXWCeNMGsyzan+BFOMBcTDF0hAWAlzSlqykx9QRLLhADlgJ7poMRAYmSLsp
         AbEWU0SAS4S6vrz0h1+8IUwFdDErsWX4vJbtierN/kqzkLBCYRxCw62LSHbvLrev5FPw
         6DElSNSa5tU/ELk9UXBCLXOkSWYpA7P88rcC3IaKZ3lkDu8HclHNju5WcComZFfz4rni
         +JqEOfqcBXqd5mqBAqJ0F0oG/yj2ju+A1dUGz84plrNWiItA7Ob50cS95dIov1JQSYKU
         N6DAQ/WdYYlIN7gUEhdfcFv/ivvHa5wAewF7UaWroBziMfcloKGX9cH1uPy0Ocb7d+Kx
         +6Lg==
X-Gm-Message-State: AFqh2kp6wi0/5bGYSKAxM73tPtje8e0b+7KYKrKMrffVt8lNmwAEJ791
        ikxIbBaBMzK1Yr7xLfQmQ5k=
X-Google-Smtp-Source: AMrXdXutKZIpKraeZQVfKb2+7pXev/RBBlJWtd2oCakLdYQqUCD5lRtEWIx2JODT4tXHXXYajoe+mg==
X-Received: by 2002:a05:600c:510d:b0:3da:f719:50cd with SMTP id o13-20020a05600c510d00b003daf71950cdmr10826371wms.18.1674152397010;
        Thu, 19 Jan 2023 10:19:57 -0800 (PST)
Received: from [192.168.2.177] ([207.188.167.132])
        by smtp.gmail.com with ESMTPSA id s7-20020a1cf207000000b003db11dfc687sm5464787wmc.36.2023.01.19.10.19.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 10:19:56 -0800 (PST)
Message-ID: <d580f1dc-e49f-48c9-30be-a0ef25ad1435@gmail.com>
Date:   Thu, 19 Jan 2023 19:19:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 2/2] arm64: dts: mt8195: Add Ethernet controller
Content-Language: en-US
To:     Biao Huang <biao.huang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        macpaul.lin@mediatek.com, netdev@vger.kernel.org
References: <20230105010712.10116-1-biao.huang@mediatek.com>
 <20230105010712.10116-3-biao.huang@mediatek.com>
From:   Matthias Brugger <matthias.bgg@gmail.com>
In-Reply-To: <20230105010712.10116-3-biao.huang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/01/2023 02:07, Biao Huang wrote:
> Add Ethernet controller node for mt8195.
> 
> Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>

Applied, thanks!

> ---
>   arch/arm64/boot/dts/mediatek/mt8195-demo.dts | 77 ++++++++++++++++
>   arch/arm64/boot/dts/mediatek/mt8195.dtsi     | 92 ++++++++++++++++++++
>   2 files changed, 169 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/mediatek/mt8195-demo.dts b/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
> index 4fbd99eb496a..6a48c135f0da 100644
> --- a/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
> +++ b/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
> @@ -78,6 +78,23 @@ optee_reserved: optee@43200000 {
>   	};
>   };
>   
> +&eth {
> +	phy-mode ="rgmii-id";
> +	phy-handle = <&ethernet_phy0>;
> +	snps,reset-gpio = <&pio 93 GPIO_ACTIVE_HIGH>;
> +	snps,reset-delays-us = <0 10000 80000>;
> +	pinctrl-names = "default", "sleep";
> +	pinctrl-0 = <&eth_default_pins>;
> +	pinctrl-1 = <&eth_sleep_pins>;
> +	status = "okay";
> +
> +	mdio {
> +		ethernet_phy0: ethernet-phy@1 {
> +			reg = <0x1>;
> +		};
> +	};
> +};
> +
>   &i2c6 {
>   	clock-frequency = <400000>;
>   	pinctrl-0 = <&i2c6_pins>;
> @@ -258,6 +275,66 @@ &mt6359_vsram_others_ldo_reg {
>   };
>   
>   &pio {
> +	eth_default_pins: eth-default-pins {
> +		pins-txd {
> +			pinmux = <PINMUX_GPIO77__FUNC_GBE_TXD3>,
> +				 <PINMUX_GPIO78__FUNC_GBE_TXD2>,
> +				 <PINMUX_GPIO79__FUNC_GBE_TXD1>,
> +				 <PINMUX_GPIO80__FUNC_GBE_TXD0>;
> +			drive-strength = <MTK_DRIVE_8mA>;
> +		};
> +		pins-cc {
> +			pinmux = <PINMUX_GPIO85__FUNC_GBE_TXC>,
> +				 <PINMUX_GPIO88__FUNC_GBE_TXEN>,
> +				 <PINMUX_GPIO87__FUNC_GBE_RXDV>,
> +				 <PINMUX_GPIO86__FUNC_GBE_RXC>;
> +			drive-strength = <MTK_DRIVE_8mA>;
> +		};
> +		pins-rxd {
> +			pinmux = <PINMUX_GPIO81__FUNC_GBE_RXD3>,
> +				 <PINMUX_GPIO82__FUNC_GBE_RXD2>,
> +				 <PINMUX_GPIO83__FUNC_GBE_RXD1>,
> +				 <PINMUX_GPIO84__FUNC_GBE_RXD0>;
> +		};
> +		pins-mdio {
> +			pinmux = <PINMUX_GPIO89__FUNC_GBE_MDC>,
> +				 <PINMUX_GPIO90__FUNC_GBE_MDIO>;
> +			input-enable;
> +		};
> +		pins-power {
> +			pinmux = <PINMUX_GPIO91__FUNC_GPIO91>,
> +				 <PINMUX_GPIO92__FUNC_GPIO92>;
> +			output-high;
> +		};
> +	};
> +
> +	eth_sleep_pins: eth-sleep-pins {
> +		pins-txd {
> +			pinmux = <PINMUX_GPIO77__FUNC_GPIO77>,
> +				 <PINMUX_GPIO78__FUNC_GPIO78>,
> +				 <PINMUX_GPIO79__FUNC_GPIO79>,
> +				 <PINMUX_GPIO80__FUNC_GPIO80>;
> +		};
> +		pins-cc {
> +			pinmux = <PINMUX_GPIO85__FUNC_GPIO85>,
> +				 <PINMUX_GPIO88__FUNC_GPIO88>,
> +				 <PINMUX_GPIO87__FUNC_GPIO87>,
> +				 <PINMUX_GPIO86__FUNC_GPIO86>;
> +		};
> +		pins-rxd {
> +			pinmux = <PINMUX_GPIO81__FUNC_GPIO81>,
> +				 <PINMUX_GPIO82__FUNC_GPIO82>,
> +				 <PINMUX_GPIO83__FUNC_GPIO83>,
> +				 <PINMUX_GPIO84__FUNC_GPIO84>;
> +		};
> +		pins-mdio {
> +			pinmux = <PINMUX_GPIO89__FUNC_GPIO89>,
> +				 <PINMUX_GPIO90__FUNC_GPIO90>;
> +			input-disable;
> +			bias-disable;
> +		};
> +	};
> +
>   	gpio_keys_pins: gpio-keys-pins {
>   		pins {
>   			pinmux = <PINMUX_GPIO106__FUNC_GPIO106>;
> diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
> index 5d31536f4c48..28b3ebd145bf 100644
> --- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
> @@ -1046,6 +1046,98 @@ spis1: spi@1101e000 {
>   			status = "disabled";
>   		};
>   
> +		eth: ethernet@11021000 {
> +			compatible = "mediatek,mt8195-gmac", "snps,dwmac-5.10a";
> +			reg = <0 0x11021000 0 0x4000>;
> +			interrupts = <GIC_SPI 716 IRQ_TYPE_LEVEL_HIGH 0>;
> +			interrupt-names = "macirq";
> +			clock-names = "axi",
> +				      "apb",
> +				      "mac_main",
> +				      "ptp_ref",
> +				      "rmii_internal",
> +				      "mac_cg";
> +			clocks = <&pericfg_ao CLK_PERI_AO_ETHERNET>,
> +				 <&pericfg_ao CLK_PERI_AO_ETHERNET_BUS>,
> +				 <&topckgen CLK_TOP_SNPS_ETH_250M>,
> +				 <&topckgen CLK_TOP_SNPS_ETH_62P4M_PTP>,
> +				 <&topckgen CLK_TOP_SNPS_ETH_50M_RMII>,
> +				 <&pericfg_ao CLK_PERI_AO_ETHERNET_MAC>;
> +			assigned-clocks = <&topckgen CLK_TOP_SNPS_ETH_250M>,
> +					  <&topckgen CLK_TOP_SNPS_ETH_62P4M_PTP>,
> +					  <&topckgen CLK_TOP_SNPS_ETH_50M_RMII>;
> +			assigned-clock-parents = <&topckgen CLK_TOP_ETHPLL_D2>,
> +						 <&topckgen CLK_TOP_ETHPLL_D8>,
> +						 <&topckgen CLK_TOP_ETHPLL_D10>;
> +			power-domains = <&spm MT8195_POWER_DOMAIN_ETHER>;
> +			mediatek,pericfg = <&infracfg_ao>;
> +			snps,axi-config = <&stmmac_axi_setup>;
> +			snps,mtl-rx-config = <&mtl_rx_setup>;
> +			snps,mtl-tx-config = <&mtl_tx_setup>;
> +			snps,txpbl = <16>;
> +			snps,rxpbl = <16>;
> +			snps,clk-csr = <0>;
> +			status = "disabled";
> +
> +			mdio {
> +				compatible = "snps,dwmac-mdio";
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +			};
> +
> +			stmmac_axi_setup: stmmac-axi-config {
> +				snps,wr_osr_lmt = <0x7>;
> +				snps,rd_osr_lmt = <0x7>;
> +				snps,blen = <0 0 0 0 16 8 4>;
> +			};
> +
> +			mtl_rx_setup: rx-queues-config {
> +				snps,rx-queues-to-use = <4>;
> +				snps,rx-sched-sp;
> +				queue0 {
> +					snps,dcb-algorithm;
> +					snps,map-to-dma-channel = <0x0>;
> +				};
> +				queue1 {
> +					snps,dcb-algorithm;
> +					snps,map-to-dma-channel = <0x0>;
> +				};
> +				queue2 {
> +					snps,dcb-algorithm;
> +					snps,map-to-dma-channel = <0x0>;
> +				};
> +				queue3 {
> +					snps,dcb-algorithm;
> +					snps,map-to-dma-channel = <0x0>;
> +				};
> +			};
> +
> +			mtl_tx_setup: tx-queues-config {
> +				snps,tx-queues-to-use = <4>;
> +				snps,tx-sched-wrr;
> +				queue0 {
> +					snps,weight = <0x10>;
> +					snps,dcb-algorithm;
> +					snps,priority = <0x0>;
> +				};
> +				queue1 {
> +					snps,weight = <0x11>;
> +					snps,dcb-algorithm;
> +					snps,priority = <0x1>;
> +				};
> +				queue2 {
> +					snps,weight = <0x12>;
> +					snps,dcb-algorithm;
> +					snps,priority = <0x2>;
> +				};
> +				queue3 {
> +					snps,weight = <0x13>;
> +					snps,dcb-algorithm;
> +					snps,priority = <0x3>;
> +				};
> +			};
> +		};
> +
>   		xhci0: usb@11200000 {
>   			compatible = "mediatek,mt8195-xhci",
>   				     "mediatek,mtk-xhci";
