Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E05552AF65
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 02:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbiERAw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 20:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbiERAw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 20:52:27 -0400
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C269527E5;
        Tue, 17 May 2022 17:52:26 -0700 (PDT)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-d39f741ba0so740638fac.13;
        Tue, 17 May 2022 17:52:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p/MnfFetCNPy/OGaJyPe/9LawJdkP2TbRs1icnabz0g=;
        b=0hSRJAmywelMurkmvorrwdM8kP4n8TlwqFnZ1s8TfJDN7Nt9BwRJLkqwhoBNlkz2ou
         bM3dV3eesbvIOFspqDq8vzRJcLmZfUekd7wc2E3yOhJ8O4fEqVh9XcZClFNUglC4MBaW
         0P+QTJwlA45J3pnFEKVeFs8o+IQPh0rRrfbGS4vITosipMPR6ZYR69aehMh5P0adSgdq
         QDvc8D76u/nYEEqmdeex3mASTkN/Ty6V2QAf1HgxDQftXTMoIFhxN/FA8aBmSdYgxWu0
         fCCYpkzAUspJEXDOzV/83RACIe+JXrNmWUoZq6rcOs6/uXmmyc0/CdrbogJ5EHWvrFJU
         +gEg==
X-Gm-Message-State: AOAM533uhMCqORYMTC2qdKzpLyrw+W6m28ES1EYbL+TAncnNcmOMyB28
        jbfkLAM67ev7X7LCzHM7YsPX7cNQ2w==
X-Google-Smtp-Source: ABdhPJzrZJlKes6PsY7+V0jGexlBqAaNhNYOWvSJc4RNos3ZrWmW0m4fxZ4fU1Xy/k9EsmytiBDLvw==
X-Received: by 2002:a05:6870:5ba6:b0:f1:5840:f3a5 with SMTP id em38-20020a0568705ba600b000f15840f3a5mr12208951oab.254.1652835145409;
        Tue, 17 May 2022 17:52:25 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id i3-20020a056870044300b000ead8b89484sm408601oak.5.2022.05.17.17.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 17:52:24 -0700 (PDT)
Received: (nullmailer pid 1974016 invoked by uid 1000);
        Wed, 18 May 2022 00:52:23 -0000
Date:   Tue, 17 May 2022 19:52:23 -0500
From:   Rob Herring <robh@kernel.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v2 4/5] net: dt-bindings: Introduce the Qualcomm
 IPQESS Ethernet controller
Message-ID: <20220518005223.GA1970862-robh@kernel.org>
References: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
 <20220514150656.122108-5-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220514150656.122108-5-maxime.chevallier@bootlin.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 14, 2022 at 05:06:55PM +0200, Maxime Chevallier wrote:
> Add the DT binding for the IPQESS Ethernet Controller. This is a simple
> controller, only requiring the phy-mode, interrupts, clocks, and
> possibly a MAC address setting.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> V1->V2:
>  - Fixed the example
>  - Added reset and clocks
>  - Removed generic ethernet attributes
> 
>  .../devicetree/bindings/net/qcom,ipqess.yaml  | 104 ++++++++++++++++++
>  1 file changed, 104 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/qcom,ipqess.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipqess.yaml b/Documentation/devicetree/bindings/net/qcom,ipqess.yaml
> new file mode 100644
> index 000000000000..ea0023509737
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/qcom,ipqess.yaml
> @@ -0,0 +1,104 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/qcom,ipqess.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm IPQ ESS EDMA Ethernet Controller
> +
> +maintainers:
> +  - Maxime Chevallier <maxime.chevallier@bootlin.com>
> +
> +allOf:
> +  - $ref: "ethernet-controller.yaml#"
> +
> +properties:
> +  compatible:
> +    const: qcom,ipq4019e-ess-edma
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    minItems: 2
> +    maxItems: 32
> +    description: One interrupt per tx and rx queue, with up to 16 queues.
> +
> +  clocks:
> +    maxItems: 1
> +
> +  clock-names:
> +    const: ess

Always kind of pointless to have a single *-names entry when it's just 
the block name.

> +
> +  resets:
> +    maxItems: 1
> +
> +  reset-names:
> +    const: ess

ditto

> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +  - clock-names
> +  - resets
> +  - phy-mode
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/qcom,gcc-ipq4019.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    gmac: ethernet@c080000 {
> +        compatible = "qcom,ipq4019-ess-edma";
> +        reg = <0xc080000 0x8000>;
> +        resets = <&gcc ESS_RESET>;
> +        reset-names = "ess";
> +        clocks = <&gcc GCC_ESS_CLK>;
> +        clock-names = "ess";
> +        interrupts = <GIC_SPI  65 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  66 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  67 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  68 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  69 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  70 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  71 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  72 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  73 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  74 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  75 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  76 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  77 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  78 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  79 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  80 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 240 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 241 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 242 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 243 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 244 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 245 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 246 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 247 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 248 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 249 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 250 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 251 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 252 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 253 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 254 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 255 IRQ_TYPE_EDGE_RISING>;
> +
> +        phy-mode = "internal";
> +        fixed-link {
> +            speed = <1000>;
> +            full-duplex;
> +            pause;
> +            asym-pause;
> +        };
> +    };
> +
> +...
> -- 
> 2.36.1
> 
> 
