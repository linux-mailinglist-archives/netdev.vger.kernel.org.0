Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F131A8877
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407772AbgDNSEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:04:24 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:36372 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503176AbgDNSER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:04:17 -0400
Received: by mail-oi1-f194.google.com with SMTP id s202so8008179oih.3;
        Tue, 14 Apr 2020 11:04:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zQ0PimyRdMABhjhHh/Gv5/rP+w4JWlh3TdDCCaak8Qg=;
        b=h8gB/AfV1bECQFTSRSe4DA82VFQgAMK7GAVKxdbtSlrOPusEjEAbM7VhU8goP6xA1B
         V9Um/1q+82gJWZo1DgJ/s2zxCKo9dWYQBysU3q0DSTuDuTT+vHkArQQE3kHIeuMOWItS
         bWh50w/Ul5h308HMOi8Wi6DI9Yvx3gjJ2TqrZ+HKj3i+6m/o4CqyyPyZOXI9sjXs5Ty1
         W9dbBwRy9ytIlrWypdA6NVfcW7s8IFfugc/VkacICLRmXjtOJxL2JX+QzhyWAsugET8d
         68jV89QV/+MR+4/ex1wwg9MIIJnE6P6oH1mpEXk7lrZHYe0/sffXVAWL5bhMuNvlUwWi
         zieA==
X-Gm-Message-State: AGi0PuYcwf9GCdTvyVr+zJZ5np11EvbSZ3T4ATEN3aSw+vzMq4XpvCmU
        hQtNH9B8VmZSNz4ONJXvtA==
X-Google-Smtp-Source: APiQypKFUIbErgo20KGe3E34B2dSQ+p6+Rq8KlCqQOyTgLPxoH4qjOuY/QFqublHD1xJYLoIqVNeSg==
X-Received: by 2002:aca:b104:: with SMTP id a4mr14281712oif.103.1586887455780;
        Tue, 14 Apr 2020 11:04:15 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id o204sm5707995oib.12.2020.04.14.11.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 11:04:15 -0700 (PDT)
Received: (nullmailer pid 18713 invoked by uid 1000);
        Tue, 14 Apr 2020 18:04:13 -0000
Date:   Tue, 14 Apr 2020 13:04:13 -0500
From:   Rob Herring <robh@kernel.org>
To:     Christophe Roullier <christophe.roullier@st.com>
Cc:     davem@davemloft.net, mark.rutland@arm.com, mripard@kernel.org,
        martin.blumenstingl@googlemail.com, alexandru.ardelean@analog.com,
        narmstrong@baylibre.com, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 2/2] dt-bindings: net: dwmac: Convert stm32 dwmac to
 DT schema
Message-ID: <20200414180413.GB4816@bogus>
References: <20200403140415.29641-1-christophe.roullier@st.com>
 <20200403140415.29641-3-christophe.roullier@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403140415.29641-3-christophe.roullier@st.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 03, 2020 at 04:04:15PM +0200, Christophe Roullier wrote:
> Convert stm32 dwmac to DT schema.
> 
> Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
> ---
>  .../devicetree/bindings/net/stm32-dwmac.txt   |  44 -----
>  .../devicetree/bindings/net/stm32-dwmac.yaml  | 150 ++++++++++++++++++
>  2 files changed, 150 insertions(+), 44 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/stm32-dwmac.txt
>  create mode 100644 Documentation/devicetree/bindings/net/stm32-dwmac.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/stm32-dwmac.txt b/Documentation/devicetree/bindings/net/stm32-dwmac.txt
> deleted file mode 100644
> index a90eef11dc46..000000000000
> --- a/Documentation/devicetree/bindings/net/stm32-dwmac.txt
> +++ /dev/null
> @@ -1,44 +0,0 @@
> -STMicroelectronics STM32 / MCU DWMAC glue layer controller
> -
> -This file documents platform glue layer for stmmac.
> -Please see stmmac.txt for the other unchanged properties.
> -
> -The device node has following properties.
> -
> -Required properties:
> -- compatible:  For MCU family should be "st,stm32-dwmac" to select glue, and
> -	       "snps,dwmac-3.50a" to select IP version.
> -	       For MPU family should be "st,stm32mp1-dwmac" to select
> -	       glue, and "snps,dwmac-4.20a" to select IP version.
> -- clocks: Must contain a phandle for each entry in clock-names.
> -- clock-names: Should be "stmmaceth" for the host clock.
> -	       Should be "mac-clk-tx" for the MAC TX clock.
> -	       Should be "mac-clk-rx" for the MAC RX clock.
> -	       For MPU family need to add also "ethstp" for power mode clock
> -- interrupt-names: Should contain a list of interrupt names corresponding to
> -           the interrupts in the interrupts property, if available.
> -		   Should be "macirq" for the main MAC IRQ
> -		   Should be "eth_wake_irq" for the IT which wake up system
> -- st,syscon : Should be phandle/offset pair. The phandle to the syscon node which
> -	       encompases the glue register, and the offset of the control register.
> -
> -Optional properties:
> -- clock-names:     For MPU family "eth-ck" for PHY without quartz
> -- st,eth-clk-sel (boolean) : set this property in RGMII PHY when you want to select RCC clock instead of ETH_CLK125.
> -- st,eth-ref-clk-sel (boolean) :  set this property in RMII mode when you have PHY without crystal 50MHz and want to select RCC clock instead of ETH_REF_CLK.
> -
> -Example:
> -
> -	ethernet@40028000 {
> -		compatible = "st,stm32-dwmac", "snps,dwmac-3.50a";
> -		reg = <0x40028000 0x8000>;
> -		reg-names = "stmmaceth";
> -		interrupts = <0 61 0>, <0 62 0>;
> -		interrupt-names = "macirq", "eth_wake_irq";
> -		clock-names = "stmmaceth", "mac-clk-tx", "mac-clk-rx";
> -		clocks = <&rcc 0 25>, <&rcc 0 26>, <&rcc 0 27>;
> -		st,syscon = <&syscfg 0x4>;
> -		snps,pbl = <8>;
> -		snps,mixed-burst;
> -		dma-ranges;
> -	};
> diff --git a/Documentation/devicetree/bindings/net/stm32-dwmac.yaml b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
> new file mode 100644
> index 000000000000..f559293dbab5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
> @@ -0,0 +1,150 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +# Copyright 2019 BayLibre, SAS
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/net/stm32-dwmac.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: STMicroelectronics STM32 / MCU DWMAC glue layer controller
> +
> +maintainers:
> +  - Alexandre Torgue <alexandre.torgue@st.com>
> +  - Christophe Roullier <christophe.roullier@st.com>
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
> +          - st,stm32-dwmac
> +          - st,stm32mp1-dwmac
> +  required:
> +    - compatible
> +
> +allOf:
> +  - $ref: "snps,dwmac.yaml#"
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - items:
> +          - enum:
> +              - st,stm32mp1-dwmac
> +          - const: snps,dwmac-4.20a
> +      - items:
> +          - enum:
> +              - st,stm32-dwmac
> +          - const: snps,dwmac-4.10a
> +      - items:
> +          - enum:
> +              - st,stm32-dwmac
> +          - const: snps,dwmac-3.50a
> +
> +  clocks:
> +    minItems: 3
> +    maxItems: 5
> +    items:
> +        - description: GMAC main clock
> +        - description: MAC TX clock
> +        - description: MAC RX clock
> +        - description: For MPU family, used for power mode
> +        - description: For MPU family, used for PHY without quartz
> +
> +  clock-names:
> +    minItems: 3
> +    maxItems: 5
> +    contains:
> +      enum:
> +        - stmmaceth
> +        - mac-clk-tx
> +        - mac-clk-rx
> +        - ethstp
> +        - eth-ck
> +
> +  st,syscon:
> +    allOf:
> +      - $ref: "/schemas/types.yaml#/definitions/phandle-array"
> +    description:
> +      Should be phandle/offset pair. The phandle to the syscon node which
> +      encompases the glue register, and the offset of the control register
> +
> +  st,eth-clk-sel:
> +    description:
> +      set this property in RGMII PHY when you want to select RCC clock instead of ETH_CLK125.
> +    type: boolean
> +
> +  st,eth-ref-clk-sel:
> +    description:
> +      set this property in RMII mode when you have PHY without crystal 50MHz and want to
> +      select RCC clock instead of ETH_REF_CLK.
> +    type: boolean
> +
> +required:
> +  - compatible
> +  - clocks
> +  - clock-names
> +  - st,syscon
> +
> +examples:
> + - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/clock/stm32mp1-clks.h>
> +    #include <dt-bindings/reset/stm32mp1-resets.h>
> +    #include <dt-bindings/mfd/stm32h7-rcc.h>
> +    //Example 1
> +     ethernet0: ethernet@5800a000 {
> +           compatible = "st,stm32mp1-dwmac", "snps,dwmac-4.20a";
> +           reg = <0x5800a000 0x2000>;
> +           reg-names = "stmmaceth";
> +           interrupts = <&intc GIC_SPI 61 IRQ_TYPE_LEVEL_HIGH>;
> +           interrupt-names = "macirq";
> +           clock-names = "stmmaceth",
> +                     "mac-clk-tx",
> +                     "mac-clk-rx",
> +                     "ethstp",
> +                     "eth-ck";
> +           clocks = <&rcc ETHMAC>,
> +                <&rcc ETHTX>,
> +                <&rcc ETHRX>,
> +                <&rcc ETHSTP>,
> +                <&rcc ETHCK_K>;
> +           st,syscon = <&syscfg 0x4>;
> +           snps,pbl = <2>;
> +           snps,axi-config = <&stmmac_axi_config_0>;
> +           snps,tso;
> +           phy-mode = "rgmii";
> +       };
> +
> +    //Example 2 (MCU example)
> +     ethernet1: ethernet@40028000 {
> +           compatible = "st,stm32-dwmac", "snps,dwmac-3.50a";
> +           reg = <0x40028000 0x8000>;
> +           reg-names = "stmmaceth";
> +           interrupts = <0 61 0>, <0 62 0>;
> +           interrupt-names = "macirq", "eth_wake_irq";
> +           clock-names = "stmmaceth", "mac-clk-tx", "mac-clk-rx";
> +           clocks = <&rcc 0 25>, <&rcc 0 26>, <&rcc 0 27>;
> +           st,syscon = <&syscfg 0x4>;
> +           snps,pbl = <8>;
> +           snps,mixed-burst;
> +           dma-ranges;

dma-ranges is not valid here. I will drop on applying, but you should 
check your dts files.

Rob
