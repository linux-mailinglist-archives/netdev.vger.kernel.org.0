Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0902A6B14A6
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 22:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjCHV7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 16:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjCHV7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 16:59:20 -0500
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129F366D1C;
        Wed,  8 Mar 2023 13:59:17 -0800 (PST)
Received: by mail-ot1-f42.google.com with SMTP id l15-20020a9d7a8f000000b0069447f0db6fso19085otn.4;
        Wed, 08 Mar 2023 13:59:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678312756;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8zlXSnMRJPYfLbixN9EXHHN0qB6jtGkytaRGS5ki5aI=;
        b=GAowi4RRzbsNwzcoj8tlHtmtCX95llXN6jLSkF33CHimkm++9MOjzDTb/GctDMEWli
         HOuWt22aovc1IIXTF/iXDhb4WuS2c8RswrU2q3590rOZAfkkcDlBxVbr0PwODFvbFcrf
         hGOgIfplFnGzQIZsNrOG/Rx25527ft2N+2eQG2rLyc8uc+DqAzWCPzMI47DMio37gwZB
         OoiOidyKwSnnkC6BnVGGXCsC4qVs/Uc4Gb7r0DUnPtLICQ4gYa5IxlpWNEBIwnn6Cddj
         n7bQhzGPqdvCGVa6xw+kujlekqCONiqRYl2pSXtJUwRdoyupOiH3guvkq5PdID6LaRu5
         Eqag==
X-Gm-Message-State: AO0yUKWTaQyhdskteUfjOkccBYRrs4od04oz0+/jPFoBqzyFXiKvmJzL
        Uz/esm50gaRlXNtrQaAzDVfAbpHFcg==
X-Google-Smtp-Source: AK7set+Df1FSt526SUD1t+1ggqqkwsSf4k6oWoLoO/zuzY//dQhI/mu1F1AFSzIePg/LVfuSOjZVhA==
X-Received: by 2002:a9d:855:0:b0:68d:7a7b:bd61 with SMTP id 79-20020a9d0855000000b0068d7a7bbd61mr9263669oty.23.1678312756277;
        Wed, 08 Mar 2023 13:59:16 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id n25-20020a9d7119000000b0068bd922a244sm7007247otj.20.2023.03.08.13.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 13:59:15 -0800 (PST)
Received: (nullmailer pid 3914250 invoked by uid 1000);
        Wed, 08 Mar 2023 21:59:15 -0000
Date:   Wed, 8 Mar 2023 15:59:15 -0600
From:   Rob Herring <robh@kernel.org>
To:     Samin Guo <samin.guo@starfivetech.com>
Cc:     linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Subject: Re: [PATCH v5 04/12] dt-bindings: net: Add support StarFive dwmac
Message-ID: <20230308215915.GA3911690-robh@kernel.org>
References: <20230303085928.4535-1-samin.guo@starfivetech.com>
 <20230303085928.4535-5-samin.guo@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303085928.4535-5-samin.guo@starfivetech.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 04:59:20PM +0800, Samin Guo wrote:
> From: Yanhong Wang <yanhong.wang@starfivetech.com>
> 
> Add documentation to describe StarFive dwmac driver(GMAC).
> 
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
>  .../bindings/net/starfive,jh7110-dwmac.yaml   | 117 ++++++++++++++++++
>  MAINTAINERS                                   |   6 +
>  3 files changed, 124 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index 89099a888f0b..395f081161ce 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -91,6 +91,7 @@ properties:
>          - snps,dwmac-5.20
>          - snps,dwxgmac
>          - snps,dwxgmac-2.10
> +        - starfive,jh7110-dwmac
>  
>    reg:
>      minItems: 1
> diff --git a/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml b/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
> new file mode 100644
> index 000000000000..ca49f08d50dd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
> @@ -0,0 +1,117 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +# Copyright (C) 2022 StarFive Technology Co., Ltd.
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/starfive,jh7110-dwmac.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: StarFive JH7110 DWMAC glue layer
> +
> +maintainers:
> +  - Emil Renner Berthing <kernel@esmil.dk>
> +  - Samin Guo <samin.guo@starfivetech.com>
> +
> +select:
> +  properties:
> +    compatible:
> +      contains:
> +        enum:
> +          - starfive,jh7110-dwmac
> +  required:
> +    - compatible
> +
> +properties:
> +  compatible:
> +    items:
> +      - enum:
> +          - starfive,jh7110-dwmac
> +      - const: snps,dwmac-5.20
> +
> +  clocks:
> +    items:
> +      - description: GMAC main clock
> +      - description: GMAC AHB clock
> +      - description: PTP clock
> +      - description: TX clock
> +      - description: GTX clock
> +
> +  clock-names:
> +    items:
> +      - const: stmmaceth
> +      - const: pclk
> +      - const: ptp_ref
> +      - const: tx
> +      - const: gtx
> +
> +  resets:
> +    items:
> +      - description: MAC Reset signal.
> +      - description: AHB Reset signal.
> +
> +  reset-names:
> +    items:
> +      - const: stmmaceth
> +      - const: ahb
> +
> +  starfive,tx-use-rgmii-clk:
> +    description:
> +      Tx clock is provided by external rgmii clock.
> +    type: boolean
> +
> +allOf:
> +  - $ref: snps,dwmac.yaml#
> +
> +unevaluatedProperties: true

This must be false.

> +
> +required:
> +  - compatible
> +  - clocks
> +  - clock-names
> +  - resets
> +  - reset-names
> +
> +examples:
> +  - |
> +    ethernet@16030000 {
> +        compatible = "starfive,jh7110-dwmac", "snps,dwmac-5.20";
> +        reg = <0x16030000 0x10000>;
> +        clocks = <&clk 3>, <&clk 2>, <&clk 109>,
> +                 <&clk 6>, <&clk 111>;
> +        clock-names = "stmmaceth", "pclk", "ptp_ref",
> +                      "tx", "gtx";
> +        resets = <&rst 1>, <&rst 2>;
> +        reset-names = "stmmaceth", "ahb";
> +        interrupts = <7>, <6>, <5>;
> +        interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
> +        phy-mode = "rgmii-id";
> +        snps,multicast-filter-bins = <64>;
> +        snps,perfect-filter-entries = <8>;
> +        rx-fifo-depth = <2048>;
> +        tx-fifo-depth = <2048>;
> +        snps,fixed-burst;
> +        snps,no-pbl-x8;
> +        snps,tso;
> +        snps,force_thresh_dma_mode;
> +        snps,axi-config = <&stmmac_axi_setup>;
> +        snps,en-tx-lpi-clockgating;
> +        snps,txpbl = <16>;
> +        snps,rxpbl = <16>;
> +        phy-handle = <&phy0>;
> +
> +        mdio {
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +            compatible = "snps,dwmac-mdio";
> +
> +            phy0: ethernet-phy@0 {
> +                reg = <0>;
> +            };
> +        };
> +
> +        stmmac_axi_setup: stmmac-axi-config {
> +            snps,lpi_en;
> +            snps,wr_osr_lmt = <4>;
> +            snps,rd_osr_lmt = <4>;
> +            snps,blen = <256 128 64 32 0 0 0>;
> +        };
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5c67c75a940f..4e236b7c7fd2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19912,6 +19912,12 @@ M:	Emil Renner Berthing <kernel@esmil.dk>
>  S:	Maintained
>  F:	arch/riscv/boot/dts/starfive/
>  
> +STARFIVE DWMAC GLUE LAYER
> +M:	Emil Renner Berthing <kernel@esmil.dk>
> +M:	Samin Guo <samin.guo@starfivetech.com>
> +S:	Maintained
> +F:	Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
> +
>  STARFIVE JH71X0 CLOCK DRIVERS
>  M:	Emil Renner Berthing <kernel@esmil.dk>
>  M:	Hal Feng <hal.feng@starfivetech.com>
> -- 
> 2.17.1
> 
