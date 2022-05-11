Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78AD3523715
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 17:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343520AbiEKPW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 11:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234099AbiEKPWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 11:22:25 -0400
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C747338BF0;
        Wed, 11 May 2022 08:22:24 -0700 (PDT)
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-edf3b6b0f2so3177557fac.9;
        Wed, 11 May 2022 08:22:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rhJcAYT2QdBia85ebx0FyNn9tOMltMRrwz+BQyPIYtM=;
        b=f9T4UlkhVvQcQERkfdiLhpQo6lsqT6liHTYZau8kQIv5+kuDqBJGc1WVxu4rUUXT+b
         khU2bL0c87TmjMapkGh2GVVzk609+E0ToxRVUfLnT9NJ3E1XsTMjWtiAAGD3rPKWjhO+
         ur1iujzwhz/HC7Cbp0xHOzhKR4x4yAfD0A9L5EQsZuFe3eccDfEY2VEPCQ6of0UhuTV3
         LmPUF8Sadp9Y9bhprclt2eUGOZevrRlYSTg4V2kTqDbWbTwC9oXK7jaTDRKW3IK2DWaV
         RBPT3nRTmQw+3q7XwHV2NOT1nqxYY+vfpIQZRNMwxoG7MZ8SsedjtKf6k2YlNwiNOAYQ
         hj9Q==
X-Gm-Message-State: AOAM533p3tYT9pIO1dZWCYN8lLvqyRYDIB5OC9Y2xNy0qgI/t/8BV8Sq
        Ya9WycIxB4V/X3oWPEtuRA==
X-Google-Smtp-Source: ABdhPJz+g2OvLutFR2r2Zj+9Qd1sDp5db3Fn1YBWm3l1Xgzc15luw7rLt71fRlE7myTrIrQhtBG5IQ==
X-Received: by 2002:a05:6870:11d0:b0:e6:4f7:f6b with SMTP id 16-20020a05687011d000b000e604f70f6bmr3003921oav.104.1652282544053;
        Wed, 11 May 2022 08:22:24 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id b13-20020a056830104d00b0060603221270sm897581otp.64.2022.05.11.08.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 08:22:23 -0700 (PDT)
Received: (nullmailer pid 336352 invoked by uid 1000);
        Wed, 11 May 2022 15:22:21 -0000
Date:   Wed, 11 May 2022 10:22:21 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 05/12] dt-bindings: net: dsa: add bindings
 for Renesas RZ/N1 Advanced 5 port switch
Message-ID: <20220511152221.GA334055-robh@kernel.org>
References: <20220509131900.7840-1-clement.leger@bootlin.com>
 <20220509131900.7840-6-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220509131900.7840-6-clement.leger@bootlin.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 03:18:53PM +0200, Clément Léger wrote:
> Add bindings for Renesas RZ/N1 Advanced 5 port switch. This switch is
> present on Renesas RZ/N1 SoC and was probably provided by MoreThanIP.
> This company does not exists anymore and has been bought by Synopsys.
> Since this IP can't be find anymore in the Synospsy portfolio, lets use
> Renesas as the vendor compatible for this IP.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  | 132 ++++++++++++++++++
>  1 file changed, 132 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> new file mode 100644
> index 000000000000..f0f6748e1f01
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> @@ -0,0 +1,132 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/renesas,rzn1-a5psw.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Renesas RZ/N1 Advanced 5 ports ethernet switch
> +
> +maintainers:
> +  - Clément Léger <clement.leger@bootlin.com>
> +
> +description: |
> +  The advanced 5 ports switch is present on the Renesas RZ/N1 SoC family and
> +  handles 4 ports + 1 CPU management port.
> +
> +allOf:
> +  - $ref: dsa.yaml#
> +
> +properties:
> +  compatible:
> +    items:
> +      - enum:
> +          - renesas,r9a06g032-a5psw
> +      - const: renesas,rzn1-a5psw
> +
> +  reg:
> +    maxItems: 1
> +
> +  mdio:
> +    $ref: /schemas/net/mdio.yaml#
> +    unevaluatedProperties: false
> +
> +  clocks:
> +    items:
> +      - description: AHB clock used for the switch register interface
> +      - description: Switch system clock
> +
> +  clock-names:
> +    items:
> +      - const: hclk
> +      - const: clk
> +
> +patternProperties:
> +  "^ethernet-ports$":

Move to 'properties', not a pattern.

With that,

Reviewed-by: Rob Herring <robh@kernel.org>
