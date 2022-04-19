Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC186506F23
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 15:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352981AbiDSNvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 09:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352935AbiDSNvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 09:51:03 -0400
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2C23C700;
        Tue, 19 Apr 2022 06:43:50 -0700 (PDT)
Received: by mail-oi1-f173.google.com with SMTP id t15so10476402oie.1;
        Tue, 19 Apr 2022 06:43:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=XqDuHpmLDFntsP2jEBxil35GSt8HrLq9Yvn71vpOLkE=;
        b=ZF0gdgoTKdteJguyQzcrkOi0Hz2vLOhn2Iu6vWJ3mkVIxmkFqyDPb/Zl9MjjOahQv2
         D3ri5kn6HpVVISgepWLTr4pUbKJw//gKFNTAfCiPQAwSekRptDgbq9MoTehJrFiyqH7G
         pnHHe51ObdRLSOLQAwV91k1KCH7/VOhm36QdDJaP/KcYOhzoL6Skc2wyPqBXlhnHkxq2
         3uC+Mr+SOupG+5Hn8un8yqj2xN+AGugVOoVtMuk/AUwysKN78dS5kf9GXQxi10f8JLEJ
         KquIbVUdgagSXpKE4QEd735GTaudIrJNzOrVs0N389JIb6paf0WJhIbAMMe3EavkOQC6
         jEqg==
X-Gm-Message-State: AOAM533gEzLp5p+JVrzyhQBabhpg5dN11WFfZM97JP5DoRSGn872wBrB
        kYx34ZdIm3IPbc3x7+MffbDK3nr9gw==
X-Google-Smtp-Source: ABdhPJwPfM5JI/GH9JHg/IyrnQypQWW+jegdpZSSR4xN+LpwoqACSVtKbya0y5LQJGFb821UIOU0wQ==
X-Received: by 2002:a05:6808:1402:b0:2da:b72:74f2 with SMTP id w2-20020a056808140200b002da0b7274f2mr9184543oiv.113.1650375829070;
        Tue, 19 Apr 2022 06:43:49 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id j9-20020a056808056900b0032252797ea4sm4159323oig.6.2022.04.19.06.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 06:43:48 -0700 (PDT)
Received: (nullmailer pid 2431059 invoked by uid 1000);
        Tue, 19 Apr 2022 13:43:47 -0000
Date:   Tue, 19 Apr 2022 08:43:47 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 03/12] dt-bindings: net: pcs: add bindings for
 Renesas RZ/N1 MII converter
Message-ID: <Yl68k22fUw7uBgV9@robh.at.kernel.org>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-4-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220414122250.158113-4-clement.leger@bootlin.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 02:22:41PM +0200, Clément Léger wrote:
> This MII converter can be found on the RZ/N1 processor family. The MII
> converter ports are declared as subnodes which are then referenced by
> users of the PCS driver such as the switch.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  .../bindings/net/pcs/renesas,rzn1-miic.yaml   | 95 +++++++++++++++++++
>  include/dt-bindings/net/pcs-rzn1-miic.h       | 19 ++++
>  2 files changed, 114 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml
>  create mode 100644 include/dt-bindings/net/pcs-rzn1-miic.h
> 
> diff --git a/Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml b/Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml
> new file mode 100644
> index 000000000000..ccb25ce6cbde
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml
> @@ -0,0 +1,95 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/pcs/renesas,rzn1-miic.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Renesas RZ/N1 MII converter
> +
> +maintainers:
> +  - Clément Léger <clement.leger@bootlin.com>
> +
> +description: |
> +  This MII converter is present on the Renesas RZ/N1 SoC family. It is
> +  responsible to do MII passthrough or convert it to RMII/RGMII.
> +
> +properties:
> +  compatible:
> +      const: renesas,rzn1-miic

Need SoC specific compatibles.

> +
> +  reg:
> +    maxItems: 1
> +
> +  "#address-cells":
> +    const: 1
> +
> +  "#size-cells":
> +    const: 0
> +
> +  clocks:
> +    items:
> +      - description: MII reference clock
> +      - description: RGMII reference clock
> +      - description: RMII reference clock
> +      - description: AHB clock used for the MII converter register interface
> +
> +  renesas,miic-cfg-mode:
> +    description: MII mux configuration mode. This value should use one of the
> +                 value defined in dt-bindings/net/pcs-rzn1-miic.h.

Describe possible values here as constraints. At present, I don't see 
the point of this property if there is only 1 possible value and it is 
required.

> +    $ref: /schemas/types.yaml#/definitions/uint32
> +  
> +patternProperties:
> +  "^mii-conv@[0-4]$":
> +    type: object

       additionalProperties: false

> +    description: MII converter port
> +
> +    properties:
> +      reg:
> +        maxItems: 1

Why do you need sub-nodes? They don't have any properties. A simple mask 
property could tell you which ports are present/active/enabled if that's 
what you are tracking. Or the SoC specific compatibles you need to add 
can imply the ports if they are SoC specific.

> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - renesas,miic-cfg-mode
> +  - "#address-cells"
> +  - "#size-cells"
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/net/pcs-rzn1-miic.h>
> +    #include <dt-bindings/clock/r9a06g032-sysctrl.h>
> +
> +    eth-miic@44030000 {
> +      compatible = "renesas,rzn1-miic";
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +      reg = <0x44030000 0x10000>;
> +      clocks = <&sysctrl R9A06G032_CLK_MII_REF>,
> +              <&sysctrl R9A06G032_CLK_RGMII_REF>,
> +              <&sysctrl R9A06G032_CLK_RMII_REF>,
> +              <&sysctrl R9A06G032_HCLK_SWITCH_RG>;
> +      renesas,miic-cfg-mode = <MIIC_MUX_MAC2_MAC1_SWD_SWC_SWB_SWA>;
> +
> +      mii_conv0: mii-conv@0 {
> +        reg = <0>;
> +      };
> +
> +      mii_conv1: mii-conv@1 {
> +        reg = <1>;
> +      };
> +
> +      mii_conv2: mii-conv@2 {
> +        reg = <2>;
> +      };
> +
> +      mii_conv3: mii-conv@3 {
> +        reg = <3>;
> +      };
> +
> +      mii_conv4: mii-conv@4 {
> +        reg = <4>;
> +      };
> +    };
> \ No newline at end of file

Fix this.

> diff --git a/include/dt-bindings/net/pcs-rzn1-miic.h b/include/dt-bindings/net/pcs-rzn1-miic.h
> new file mode 100644
> index 000000000000..c5a0f382967b
> --- /dev/null
> +++ b/include/dt-bindings/net/pcs-rzn1-miic.h
> @@ -0,0 +1,19 @@
> +/* SPDX-License-Identifier: GPL-2.0 */

Dual license please.

> +/*
> + * Copyright (C) 2022 Schneider-Electric
> + *
> + * Clément Léger <clement.leger@bootlin.com>
> + */
> +
> +#ifndef _DT_BINDINGS_PCS_RZN1_MIIC
> +#define _DT_BINDINGS_PCS_RZN1_MIIC
> +
> +/*
> + * Reefer to the datasheet [1] section 8.2.1, Internal Connection of Ethernet
> + * Ports to check the meaning of these values.
> + *
> + * [1] REN_r01uh0750ej0140-rzn1-introduction_MAT_20210228.pdf
> + */
> +#define MIIC_MUX_MAC2_MAC1_SWD_SWC_SWB_SWA	0x13
> +
> +#endif
> -- 
> 2.34.1
> 
> 
