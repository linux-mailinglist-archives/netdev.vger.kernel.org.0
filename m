Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C2445499D
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 16:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhKQPOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 10:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbhKQPOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 10:14:30 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFEAC061570;
        Wed, 17 Nov 2021 07:11:31 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id 133so2581809wme.0;
        Wed, 17 Nov 2021 07:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=i2fGpCFq5dlk4KXZv+j/KK/kGkCDdNyv44HSjPDhCjo=;
        b=lw0AVF9yy05NUBv2qeb6GmI0remHWso9tJGVs+EYbznT/z8rcz3a/niCt4ELu05UCY
         bttPQwfzhHTv8WY4/K//hizyuOUQlZQM5YgHOrTThDO9r5UPiDsbfdP1EQilVAX1zphf
         Hky6ChA9CTIVBGpsyloUbSmIxpF9aE1tmz9YpmBNiflo+8bxpDga5c2D2TdDSsGtFzA0
         40HsgloHXC9HD9DM/ss170vkzHOG7rGEB618CQr5HldippEqVpeMCM30j1adh+FbUg6J
         hJCEnlOvbkwLngR0qs+kijtYn7TTngIWsitXw9PFCweQZKl2+S1dz8K0Dv3mat6p1U+d
         ZZxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=i2fGpCFq5dlk4KXZv+j/KK/kGkCDdNyv44HSjPDhCjo=;
        b=pwAfxhrrrZ4mIZybVqAnl8Q691WzaGWwu1ip9g/k09wRKV2wJ63t1eo7OK7/A/VuZs
         E06KmLF13ZHSX7gbU6heeUoejT0BsXdqRH2XI8+e4SbQkT7TVekYevqWdoFOlg5Qj3Cx
         f5Jvc5Sf8msdOf84cU/DR+pka0gRvUyd6JE0vOttYbsN9fqTPmvPixLSV8PckPolAv+j
         IEV1IBeibYtIBcDOgbcGVmLdA+9ubDU5w7KMDJPyjxBrl1+8VKSvWDhQ854IbqPO58IW
         v72FXF2tCQm7eveBYIhPBC+8Am7O6QIESU51VP3eaPrFumGwWD3iaD5AZ40Vpe2l+OBD
         79EA==
X-Gm-Message-State: AOAM532ppM0z8VqY+kI1gsc2FMLxb7s2M1+2Nsw3+J+HGaKELfOuO21X
        p9Rm4bSJHRWMmryHy2xL1pk=
X-Google-Smtp-Source: ABdhPJyGqCR2lyV+TqKa1Hs7R6vHMvtjlsk4SjUFBqqmAplr58wrwIKwyXfOHg8BiIloQHL7gHEf3w==
X-Received: by 2002:a7b:cf0f:: with SMTP id l15mr471604wmg.92.1637161889941;
        Wed, 17 Nov 2021 07:11:29 -0800 (PST)
Received: from [192.168.0.18] (static-160-219-86-188.ipcom.comunitel.net. [188.86.219.160])
        by smtp.gmail.com with ESMTPSA id z12sm121240wrv.78.2021.11.17.07.11.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 07:11:29 -0800 (PST)
Message-ID: <04051f18-a955-9397-d94e-0c61fc8f595b@gmail.com>
Date:   Wed, 17 Nov 2021 16:11:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 4/7] net-next: dt-bindings: dwmac: Convert
 mediatek-dwmac to DT schema
Content-Language: en-US
To:     Biao Huang <biao.huang@mediatek.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        srv_heupstream@mediatek.com, macpaul.lin@mediatek.com,
        angelogioacchino.delregno@collabora.com, dkirjanov@suse.de
References: <20211112093918.11061-1-biao.huang@mediatek.com>
 <20211112093918.11061-5-biao.huang@mediatek.com>
From:   Matthias Brugger <matthias.bgg@gmail.com>
In-Reply-To: <20211112093918.11061-5-biao.huang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/11/2021 10:39, Biao Huang wrote:
> Convert mediatek-dwmac to DT schema, and delete old mediatek-dwmac.txt.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>   .../bindings/net/mediatek-dwmac.txt           |  91 ----------
>   .../bindings/net/mediatek-dwmac.yaml          | 157 ++++++++++++++++++
>   2 files changed, 157 insertions(+), 91 deletions(-)
>   delete mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.txt
>   create mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> 

 From a quick look you are converting the binding to yaml and in the same patch 
change the binding. Please do that in two different patches as otherwise it's 
dificult to review.

Regards,
Matthias

> diff --git a/Documentation/devicetree/bindings/net/mediatek-dwmac.txt b/Documentation/devicetree/bindings/net/mediatek-dwmac.txt
> deleted file mode 100644
> index afbcaebf062e..000000000000
> --- a/Documentation/devicetree/bindings/net/mediatek-dwmac.txt
> +++ /dev/null
> @@ -1,91 +0,0 @@
> -MediaTek DWMAC glue layer controller
> -
> -This file documents platform glue layer for stmmac.
> -Please see stmmac.txt for the other unchanged properties.
> -
> -The device node has following properties.
> -
> -Required properties:
> -- compatible:  Should be "mediatek,mt2712-gmac" for MT2712 SoC
> -- reg:  Address and length of the register set for the device
> -- interrupts:  Should contain the MAC interrupts
> -- interrupt-names: Should contain a list of interrupt names corresponding to
> -	the interrupts in the interrupts property, if available.
> -	Should be "macirq" for the main MAC IRQ
> -- clocks: Must contain a phandle for each entry in clock-names.
> -- clock-names: The name of the clock listed in the clocks property. These are
> -	"axi", "apb", "mac_main", "ptp_ref", "rmii_internal" for MT2712 SoC.
> -- mac-address: See ethernet.txt in the same directory
> -- phy-mode: See ethernet.txt in the same directory
> -- mediatek,pericfg: A phandle to the syscon node that control ethernet
> -	interface and timing delay.
> -
> -Optional properties:
> -- mediatek,tx-delay-ps: TX clock delay macro value. Default is 0.
> -	It should be defined for RGMII/MII interface.
> -	It should be defined for RMII interface when the reference clock is from MT2712 SoC.
> -- mediatek,rx-delay-ps: RX clock delay macro value. Default is 0.
> -	It should be defined for RGMII/MII interface.
> -	It should be defined for RMII interface.
> -Both delay properties need to be a multiple of 170 for RGMII interface,
> -or will round down. Range 0~31*170.
> -Both delay properties need to be a multiple of 550 for MII/RMII interface,
> -or will round down. Range 0~31*550.
> -
> -- mediatek,rmii-rxc: boolean property, if present indicates that the RMII
> -	reference clock, which is from external PHYs, is connected to RXC pin
> -	on MT2712 SoC.
> -	Otherwise, is connected to TXC pin.
> -- mediatek,rmii-clk-from-mac: boolean property, if present indicates that
> -	MT2712 SoC provides the RMII reference clock, which outputs to TXC pin only.
> -- mediatek,txc-inverse: boolean property, if present indicates that
> -	1. tx clock will be inversed in MII/RGMII case,
> -	2. tx clock inside MAC will be inversed relative to reference clock
> -	   which is from external PHYs in RMII case, and it rarely happen.
> -	3. the reference clock, which outputs to TXC pin will be inversed in RMII case
> -	   when the reference clock is from MT2712 SoC.
> -- mediatek,rxc-inverse: boolean property, if present indicates that
> -	1. rx clock will be inversed in MII/RGMII case.
> -	2. reference clock will be inversed when arrived at MAC in RMII case, when
> -	   the reference clock is from external PHYs.
> -	3. the inside clock, which be sent to MAC, will be inversed in RMII case when
> -	   the reference clock is from MT2712 SoC.
> -- assigned-clocks: mac_main and ptp_ref clocks
> -- assigned-clock-parents: parent clocks of the assigned clocks
> -
> -Example:
> -	eth: ethernet@1101c000 {
> -		compatible = "mediatek,mt2712-gmac";
> -		reg = <0 0x1101c000 0 0x1300>;
> -		interrupts = <GIC_SPI 237 IRQ_TYPE_LEVEL_LOW>;
> -		interrupt-names = "macirq";
> -		phy-mode ="rgmii-rxid";
> -		mac-address = [00 55 7b b5 7d f7];
> -		clock-names = "axi",
> -			      "apb",
> -			      "mac_main",
> -			      "ptp_ref",
> -			      "rmii_internal";
> -		clocks = <&pericfg CLK_PERI_GMAC>,
> -			 <&pericfg CLK_PERI_GMAC_PCLK>,
> -			 <&topckgen CLK_TOP_ETHER_125M_SEL>,
> -			 <&topckgen CLK_TOP_ETHER_50M_SEL>,
> -			 <&topckgen CLK_TOP_ETHER_50M_RMII_SEL>;
> -		assigned-clocks = <&topckgen CLK_TOP_ETHER_125M_SEL>,
> -				  <&topckgen CLK_TOP_ETHER_50M_SEL>,
> -				  <&topckgen CLK_TOP_ETHER_50M_RMII_SEL>;
> -		assigned-clock-parents = <&topckgen CLK_TOP_ETHERPLL_125M>,
> -					 <&topckgen CLK_TOP_APLL1_D3>,
> -					 <&topckgen CLK_TOP_ETHERPLL_50M>;
> -		power-domains = <&scpsys MT2712_POWER_DOMAIN_AUDIO>;
> -		mediatek,pericfg = <&pericfg>;
> -		mediatek,tx-delay-ps = <1530>;
> -		mediatek,rx-delay-ps = <1530>;
> -		mediatek,rmii-rxc;
> -		mediatek,txc-inverse;
> -		mediatek,rxc-inverse;
> -		snps,txpbl = <1>;
> -		snps,rxpbl = <1>;
> -		snps,reset-gpio = <&pio 87 GPIO_ACTIVE_LOW>;
> -		snps,reset-active-low;
> -	};
> diff --git a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> new file mode 100644
> index 000000000000..2eb4781536f7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> @@ -0,0 +1,157 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/mediatek-dwmac.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: MediaTek DWMAC glue layer controller
> +
> +maintainers:
> +  - Biao Huang <biao.huang@mediatek.com>
> +
> +description:
> +  This file documents platform glue layer for stmmac.
> +
> +# We need a select here so we don't match all nodes with 'snps,dwmac'
> +select:
> +  properties:
> +    compatible:
> +      contains:
> +        enum:
> +          - mediatek,mt2712-gmac
> +  required:
> +    - compatible
> +
> +allOf:
> +  - $ref: "snps,dwmac.yaml#"
> +  - $ref: "ethernet-controller.yaml#"
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - items:
> +          - enum:
> +              - mediatek,mt2712-gmac
> +          - const: snps,dwmac-4.20a
> +
> +  clocks:
> +    items:
> +      - description: AXI clock
> +      - description: APB clock
> +      - description: MAC Main clock
> +      - description: PTP clock
> +      - description: RMII reference clock provided by MAC
> +
> +  clock-names:
> +    items:
> +      - const: axi
> +      - const: apb
> +      - const: mac_main
> +      - const: ptp_ref
> +      - const: rmii_internal
> +
> +  mediatek,pericfg:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      The phandle to the syscon node that control ethernet
> +      interface and timing delay.
> +
> +  mediatek,tx-delay-ps:
> +    description:
> +      The internal TX clock delay (provided by this driver) in nanoseconds.
> +      For MT2712 RGMII interface, Allowed value need to be a multiple of 170,
> +      or will round down. Range 0~31*170.
> +      For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
> +      or will round down. Range 0~31*550.
> +
> +  mediatek,rx-delay-ps:
> +    description:
> +      The internal RX clock delay (provided by this driver) in nanoseconds.
> +      For MT2712 RGMII interface, Allowed value need to be a multiple of 170,
> +      or will round down. Range 0~31*170.
> +      For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
> +      or will round down. Range 0~31*550.
> +
> +  mediatek,rmii-rxc:
> +    type: boolean
> +    description:
> +      If present, indicates that the RMII reference clock, which is from external
> +      PHYs, is connected to RXC pin. Otherwise, is connected to TXC pin.
> +
> +  mediatek,rmii-clk-from-mac:
> +    type: boolean
> +    description:
> +      If present, indicates that MAC provides the RMII reference clock, which
> +      outputs to TXC pin only.
> +
> +  mediatek,txc-inverse:
> +    type: boolean
> +    description:
> +      If present, indicates that
> +      1. tx clock will be inversed in MII/RGMII case,
> +      2. tx clock inside MAC will be inversed relative to reference clock
> +         which is from external PHYs in RMII case, and it rarely happen.
> +      3. the reference clock, which outputs to TXC pin will be inversed in RMII case
> +         when the reference clock is from MAC.
> +
> +  mediatek,rxc-inverse:
> +    type: boolean
> +    description:
> +      If present, indicates that
> +      1. rx clock will be inversed in MII/RGMII case.
> +      2. reference clock will be inversed when arrived at MAC in RMII case, when
> +         the reference clock is from external PHYs.
> +      3. the inside clock, which be sent to MAC, will be inversed in RMII case when
> +         the reference clock is from MAC.
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - interrupt-names
> +  - clocks
> +  - clock-names
> +  - phy-mode
> +  - mediatek,pericfg
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/mt2712-clk.h>
> +    #include <dt-bindings/gpio/gpio.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    #include <dt-bindings/power/mt2712-power.h>
> +
> +    eth: ethernet@1101c000 {
> +        compatible = "mediatek,mt2712-gmac", "snps,dwmac-4.20a";
> +        reg = <0x1101c000 0x1300>;
> +        interrupts = <GIC_SPI 237 IRQ_TYPE_LEVEL_LOW>;
> +        interrupt-names = "macirq";
> +        phy-mode ="rgmii-rxid";
> +        mac-address = [00 55 7b b5 7d f7];
> +        clock-names = "axi",
> +                      "apb",
> +                      "mac_main",
> +                      "ptp_ref",
> +                      "rmii_internal";
> +        clocks = <&pericfg CLK_PERI_GMAC>,
> +                 <&pericfg CLK_PERI_GMAC_PCLK>,
> +                 <&topckgen CLK_TOP_ETHER_125M_SEL>,
> +                 <&topckgen CLK_TOP_ETHER_50M_SEL>,
> +                 <&topckgen CLK_TOP_ETHER_50M_RMII_SEL>;
> +        assigned-clocks = <&topckgen CLK_TOP_ETHER_125M_SEL>,
> +                          <&topckgen CLK_TOP_ETHER_50M_SEL>,
> +                          <&topckgen CLK_TOP_ETHER_50M_RMII_SEL>;
> +        assigned-clock-parents = <&topckgen CLK_TOP_ETHERPLL_125M>,
> +                                 <&topckgen CLK_TOP_APLL1_D3>,
> +                                 <&topckgen CLK_TOP_ETHERPLL_50M>;
> +        power-domains = <&scpsys MT2712_POWER_DOMAIN_AUDIO>;
> +        mediatek,pericfg = <&pericfg>;
> +        mediatek,tx-delay-ps = <1530>;
> +        snps,txpbl = <1>;
> +        snps,rxpbl = <1>;
> +        snps,reset-gpio = <&pio 87 GPIO_ACTIVE_LOW>;
> +        snps,reset-delays-us = <0 10000 10000>;
> +    };
> 
