Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D884523709
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 17:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343506AbiEKPUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 11:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343509AbiEKPUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 11:20:42 -0400
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53237224066;
        Wed, 11 May 2022 08:20:32 -0700 (PDT)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-ed9a75c453so3159779fac.11;
        Wed, 11 May 2022 08:20:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5ZJJEi0T6avsQcNuZ76OzoU8pxCTrsB//m+bCucO+9U=;
        b=NFSxyyvOEp4jn7x6TxNuF5z/tIPDEPmNR2u+m7Qw62L1ds/YtrBGl5vTJunHjtuTyR
         zfUvvXWWmaxoScee4LtOa9FzDVmEIUuXKbrQNizI0oaGtKFVl6VTnTPYzn5156RmowOn
         PmH8pT5Qy8Cwlz7v2KNswHmz/gNwaUlrhEYSJTMjKUuZJSMLOIyfh5EeUPhA2YRCA1UH
         UjQhVWKjKPwNWJdAv+Yef5KCiiWQRkme49+zHf1Ds7THFU6wxUICj4PtthI6tZf78Rv5
         /Yqe8WoRbgTtfARxfj3HwW23jvW+DfGNHseiCJcsOtcUXIpGGuH/AhmYDG2yC3eZVdbr
         JAJA==
X-Gm-Message-State: AOAM5327wIeMvKv6ChIBMx8/0K8X2Vwt1KYbYU5RcWybMr8gyr7UutIo
        B1okarzWc20YAdRDZtiKPQ==
X-Google-Smtp-Source: ABdhPJzHG2G6iJ/w1YHF54ZZrwalnAdU7u6SfKtXTyPPxCiPfEfPDWLIDd8rgbeHklBkkzoPAseC1A==
X-Received: by 2002:a05:6870:818a:b0:f1:1223:3afd with SMTP id k10-20020a056870818a00b000f112233afdmr1711883oae.271.1652282431852;
        Wed, 11 May 2022 08:20:31 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id q2-20020a4adc42000000b0035eb4e5a6b3sm1031492oov.9.2022.05.11.08.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 08:20:31 -0700 (PDT)
Received: (nullmailer pid 333836 invoked by uid 1000);
        Wed, 11 May 2022 15:20:29 -0000
Date:   Wed, 11 May 2022 10:20:29 -0500
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
Subject: Re: [PATCH net-next v4 03/12] dt-bindings: net: pcs: add bindings
 for Renesas RZ/N1 MII converter
Message-ID: <20220511152029.GA330075-robh@kernel.org>
References: <20220509131900.7840-1-clement.leger@bootlin.com>
 <20220509131900.7840-4-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220509131900.7840-4-clement.leger@bootlin.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 03:18:51PM +0200, Clément Léger wrote:
> This MII converter can be found on the RZ/N1 processor family. The MII
> converter ports are declared as subnodes which are then referenced by
> users of the PCS driver such as the switch.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  .../bindings/net/pcs/renesas,rzn1-miic.yaml   | 162 ++++++++++++++++++
>  include/dt-bindings/net/pcs-rzn1-miic.h       |  33 ++++
>  2 files changed, 195 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml
>  create mode 100644 include/dt-bindings/net/pcs-rzn1-miic.h
> 
> diff --git a/Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml b/Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml
> new file mode 100644
> index 000000000000..c3f5f772c885
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml
> @@ -0,0 +1,162 @@
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
> +  '#address-cells':
> +    const: 1
> +
> +  '#size-cells':
> +    const: 0
> +
> +  compatible:
> +    items:
> +      - enum:
> +          - renesas,r9a06g032-miic
> +      - const: renesas,rzn1-miic
> +
> +  reg:
> +    maxItems: 1
> +
> +  clocks:
> +    items:
> +      - description: MII reference clock
> +      - description: RGMII reference clock
> +      - description: RMII reference clock
> +      - description: AHB clock used for the MII converter register interface
> +
> +  renesas,miic-switch-portin:
> +    description: MII Switch PORTIN configuration. This value should use one of
> +      the values defined in dt-bindings/net/pcs-rzn1-miic.h.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [1, 2]
> +
> +  power-domains:
> +    maxItems: 1
> +
> +patternProperties:
> +  "^mii-conv@[0-9]+$":

^mii-conv@[0-5]$

> +    type: object
> +    description: MII converter port
> +
> +    properties:
> +      reg:
> +        description: MII Converter port number.
> +        enum: [1, 2, 3, 4, 5]
> +
> +      renesas,miic-input:
> +        description: Converter input port configuration. This value should use
> +          one of the values defined in dt-bindings/net/pcs-rzn1-miic.h.
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +
> +    required:
> +      - reg
> +      - renesas,miic-input
> +
> +    additionalProperties: false
> +
> +    allOf:
> +      - if:
> +          properties:
> +            reg:
> +              const: 1
> +        then:
> +          properties:
> +            renesas,miic-input:
> +              enum: [0]

const: 0

With those fixes,

Reviewed-by: Rob Herring <robh@kernel.org>
