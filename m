Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6449E5B6DE4
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 15:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiIMNCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 09:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiIMNCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 09:02:41 -0400
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0436D43611;
        Tue, 13 Sep 2022 06:02:40 -0700 (PDT)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-127f5411b9cso31872902fac.4;
        Tue, 13 Sep 2022 06:02:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=OgnINX3gYcstW1evxH4c9tGrrNpe5XBwb2TjVnDG0QI=;
        b=TIg9bPCaOXBH00VhQ4rUG5hbXBUqD+f6BsXKMFi6uBMRnyTbMgDyzbv54aHXcXBiWJ
         IM9hZjy0e2lfj1gEM+4qFmUNsgwUEI4jBYhE/sX8wk6SUFD4hdH4409gKp3vhjok9Szk
         J5VNuYk0JmKdctn/mmgGLiQ6FvL5rUcbtiS+nIZqic2ywzJMBq6kYXVHPJlPXQ3nsHaW
         noUq/iwU3tBDjkFZQL2lpllURS0Ac0EFsm1f/C0u5v6iACZNFNecAEzC07WIrNpYzdvo
         3bgHlEWa7UhgDBkC+6X8fDcdIblw8wSqFRejsJmBJa5gKewehkiJ/v3tE1rKv40mnexn
         wCXw==
X-Gm-Message-State: ACgBeo1vkK3lMoQP9WCB0IgDhYGUoJ8NYw+UJSf8YM2WWcbPkwKKU16L
        KCXVqHhQ+A1NSbcc3aVRhA==
X-Google-Smtp-Source: AA6agR4uCX2BHaqbqlBF8DTJ9Smk5/pE3HR04TnTTDMAIDX38owBddvZg873IHTo02S2GViD1abMJQ==
X-Received: by 2002:a05:6870:f721:b0:12b:f4bc:9ee3 with SMTP id ej33-20020a056870f72100b0012bf4bc9ee3mr900973oab.106.1663074159082;
        Tue, 13 Sep 2022 06:02:39 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id bl32-20020a05680830a000b0034d9042758fsm5168189oib.24.2022.09.13.06.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 06:02:38 -0700 (PDT)
Received: (nullmailer pid 3488951 invoked by uid 1000);
        Tue, 13 Sep 2022 13:02:37 -0000
Date:   Tue, 13 Sep 2022 08:02:37 -0500
From:   Rob Herring <robh@kernel.org>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        geert+renesas@glider.be, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 2/5] dt-bindings: net: renesas: Document Renesas Ethernet
 Switch
Message-ID: <20220913130237.GA3475975-robh@kernel.org>
References: <20220909132614.1967276-1-yoshihiro.shimoda.uh@renesas.com>
 <20220909132614.1967276-3-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909132614.1967276-3-yoshihiro.shimoda.uh@renesas.com>
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

On Fri, Sep 09, 2022 at 10:26:11PM +0900, Yoshihiro Shimoda wrote:
> Document Renesas Etherent Switch for R-Car S4-8 (r8a779f0).
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  .../bindings/net/renesas,etherswitch.yaml     | 252 ++++++++++++++++++
>  1 file changed, 252 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/renesas,etherswitch.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/renesas,etherswitch.yaml b/Documentation/devicetree/bindings/net/renesas,etherswitch.yaml
> new file mode 100644
> index 000000000000..1affbf208829
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/renesas,etherswitch.yaml
> @@ -0,0 +1,252 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/renesas,etherswitch.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Renesas Ethernet Switch
> +
> +maintainers:
> +  - Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> +
> +properties:
> +  compatible:
> +    const: renesas,r8a779f0-ether-switch
> +
> +  reg:
> +    maxItems: 3
> +
> +  reg-names:
> +    items:
> +      - const: base
> +      - const: secure_base
> +      - const: serdes

Is serdes really the same h/w block? Based on addresses, doesn't seem 
like it.

> +
> +  interrupts:
> +    maxItems: 47
> +
> +  interrupt-names:
> +    items:
> +      - const: mfwd_error
> +      - const: race_error
> +      - const: coma_error
> +      - const: gwca0_error
> +      - const: gwca1_error
> +      - const: etha0_error
> +      - const: etha1_error
> +      - const: etha2_error
> +      - const: gptp0_status
> +      - const: gptp1_status
> +      - const: mfwd_status
> +      - const: race_status
> +      - const: coma_status
> +      - const: gwca0_status
> +      - const: gwca1_status
> +      - const: etha0_status
> +      - const: etha1_status
> +      - const: etha2_status
> +      - const: rmac0_status
> +      - const: rmac1_status
> +      - const: rmac2_status
> +      - const: gwca0_rxtx0
> +      - const: gwca0_rxtx1
> +      - const: gwca0_rxtx2
> +      - const: gwca0_rxtx3
> +      - const: gwca0_rxtx4
> +      - const: gwca0_rxtx5
> +      - const: gwca0_rxtx6
> +      - const: gwca0_rxtx7
> +      - const: gwca1_rxtx0
> +      - const: gwca1_rxtx1
> +      - const: gwca1_rxtx2
> +      - const: gwca1_rxtx3
> +      - const: gwca1_rxtx4
> +      - const: gwca1_rxtx5
> +      - const: gwca1_rxtx6
> +      - const: gwca1_rxtx7
> +      - const: gwca0_rxts0
> +      - const: gwca0_rxts1
> +      - const: gwca1_rxts0
> +      - const: gwca1_rxts1
> +      - const: rmac0_mdio
> +      - const: rmac1_mdio
> +      - const: rmac2_mdio
> +      - const: rmac0_phy
> +      - const: rmac1_phy
> +      - const: rmac2_phy
> +
> +  clocks:
> +    maxItems: 2
> +
> +  clock-names:
> +    items:
> +      - const: fck
> +      - const: tsn
> +
> +  resets:
> +    maxItems: 2

What is each one?

> +
> +  iommus:
> +    maxItems: 16
> +
> +  power-domains:
> +    maxItems: 1
> +
> +  '#address-cells':
> +    description: Number of address cells for the MDIO bus.
> +    const: 1
> +
> +  '#size-cells':
> +    description: Number of size cells on the MDIO bus.
> +    const: 0

It's better if you put MDIO under an 'mdio' node. That also needs a ref 
to mdio.yaml.

> +
> +  ports:
> +    type: object
> +
> +    properties:
> +      '#address-cells':
> +        const: 1
> +      '#size-cells':
> +        const: 0
> +
> +    additionalProperties: false
> +
> +    patternProperties:
> +      "^port@[0-9a-f]+$":
> +        type: object
> +
> +        $ref: "/schemas/net/ethernet-controller.yaml#"
> +        unevaluatedProperties: false
> +
> +        properties:
> +          '#address-cells':
> +            const: 1
> +          '#size-cells':
> +            const: 0
> +
> +          reg:
> +            description:
> +              Switch port number
> +
> +          phy-handle:
> +            description:
> +              Phandle of an Ethernet PHY.
> +
> +          phy-mode:
> +            description:
> +              This specifies the interface used by the Ethernet PHY.
> +            enum:
> +              - mii
> +              - sgmii
> +              - usxgmii
> +
> +        required:
> +          - reg
> +          - phy-handle
> +          - phy-mode
> +
> +required:
> +  - compatible
> +  - reg
> +  - reg-names
> +  - interrupts
> +  - interrupt-names
> +  - clocks
> +  - clock-names
> +  - resets
> +  - power-domains
> +  - '#address-cells'
> +  - '#size-cells'
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/r8a779f0-cpg-mssr.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/power/r8a779f0-sysc.h>
> +
> +    rswitch: ethernet@e6880000 {

Drop unused labels.

> +            compatible = "renesas,r8a779f0-ether-switch";
> +            reg = <0xe6880000 0x20000>, <0xe68c0000 0x20000>,
> +                  <0xe6444000 0xc00>;
> +            reg-names = "base", "secure_base", "serdes";
> +            interrupts = <GIC_SPI 256 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 257 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 258 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 259 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 260 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 261 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 262 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 263 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 266 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 267 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 268 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 269 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 270 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 271 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 273 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 274 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 276 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 277 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 278 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 280 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 281 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 282 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 283 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 284 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 285 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 286 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 287 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 288 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 289 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 290 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 291 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 292 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 293 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 294 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 295 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 296 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 297 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 298 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 299 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 300 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 301 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 302 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 304 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 305 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 306 IRQ_TYPE_LEVEL_HIGH>;
> +            interrupt-names = "mfwd_error", "race_error",
> +                              "coma_error", "gwca0_error",
> +                              "gwca1_error", "etha0_error",
> +                              "etha1_error", "etha2_error",
> +                              "gptp0_status", "gptp1_status",
> +                              "mfwd_status", "race_status",
> +                              "coma_status", "gwca0_status",
> +                              "gwca1_status", "etha0_status",
> +                              "etha1_status", "etha2_status",
> +                              "rmac0_status", "rmac1_status",
> +                              "rmac2_status",
> +                              "gwca0_rxtx0", "gwca0_rxtx1",
> +                              "gwca0_rxtx2", "gwca0_rxtx3",
> +                              "gwca0_rxtx4", "gwca0_rxtx5",
> +                              "gwca0_rxtx6", "gwca0_rxtx7",
> +                              "gwca1_rxtx0", "gwca1_rxtx1",
> +                              "gwca1_rxtx2", "gwca1_rxtx3",
> +                              "gwca1_rxtx4", "gwca1_rxtx5",
> +                              "gwca1_rxtx6", "gwca1_rxtx7",
> +                              "gwca0_rxts0", "gwca0_rxts1",
> +                              "gwca1_rxts0", "gwca1_rxts1",
> +                              "rmac0_mdio", "rmac1_mdio",
> +                              "rmac2_mdio",
> +                              "rmac0_phy", "rmac1_phy",
> +                              "rmac2_phy";
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +            clocks = <&cpg CPG_MOD 1506>, <&cpg CPG_MOD 1505>;
> +            clock-names = "fck", "tsn";
> +            power-domains = <&sysc R8A779F0_PD_ALWAYS_ON>;
> +            resets = <&cpg 1506>, <&cpg 1505>;
> +    };
> -- 
> 2.25.1
> 
> 
