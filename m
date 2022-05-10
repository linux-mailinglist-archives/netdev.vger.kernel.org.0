Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013BF52244E
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 20:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349115AbiEJSpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 14:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349061AbiEJSov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 14:44:51 -0400
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D062BE527;
        Tue, 10 May 2022 11:44:46 -0700 (PDT)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-e93bbb54f9so15280fac.12;
        Tue, 10 May 2022 11:44:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MPXufwJAh41IRd4r3GKaRJRRh2QCesjvbaZhsgLi68g=;
        b=yQD1eRiI8T1IS9ZyzRoroZl3NnOIq+UY/Ksu5aDDiQ6+kb6rBbQS6op7ln3NaXgpOf
         zNgMGdSLT/ExGHjTBPnN2vT1od8TeNsN2PmOcnggBFtCbJX5eXreQlLOABKZqVUCNW3m
         I55MTcQopFebiHvlJQ9V/qJ80yI5+sqZ9DJvy+21s8QkAJ1uWtUQErkF5DDQnc2jb4en
         VrRlQ01V3fKKf121hgBuSwfbQ4XijBQQQWHns5S+iqnIdsLmHExk6BTymEdXXatXpEo+
         +5JhXa/NTGcGT/9GuHQ82oc3BEXvRFhHLpC6FxGHTFBUWTpEq+/uNzJZ3OTFxFRRFpnn
         7edA==
X-Gm-Message-State: AOAM532OfN5VgA1RI0KHvSBGiHbEPGsszZZjYNCdeOQe6fi+qn1ZLja3
        CVpScUjM0Hoaqs/XOQF52w==
X-Google-Smtp-Source: ABdhPJzEeQ30XaAC+XdOP/iCCrqRWxt4H+g5o3r0bi8VUx/PK0GuMt+t8NV0yPKGTMCLEYpNeWLYhQ==
X-Received: by 2002:a05:6870:80cb:b0:ed:aaeb:27e0 with SMTP id r11-20020a05687080cb00b000edaaeb27e0mr883725oab.187.1652208285415;
        Tue, 10 May 2022 11:44:45 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id b7-20020aca1b07000000b0032698578409sm4324592oib.38.2022.05.10.11.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 11:44:44 -0700 (PDT)
Received: (nullmailer pid 2376194 invoked by uid 1000);
        Tue, 10 May 2022 18:44:43 -0000
Date:   Tue, 10 May 2022 13:44:43 -0500
From:   Rob Herring <robh@kernel.org>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     linux-rockchip@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@kernel.org>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [PATCH v3 1/6] dt-bindings: net: dsa: convert binding for
 mediatek switches
Message-ID: <YnqymzCbabEjV7GQ@robh.at.kernel.org>
References: <20220507170440.64005-1-linux@fw-web.de>
 <20220507170440.64005-2-linux@fw-web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220507170440.64005-2-linux@fw-web.de>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 07, 2022 at 07:04:35PM +0200, Frank Wunderlich wrote:
> From: Frank Wunderlich <frank-w@public-files.de>
> 
> Convert txt binding to yaml binding for Mediatek switches.
> 
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> ---
> v3:
> - include standalone patch in mt7530 series
> - drop some descriptions (gpio-cells,reset-gpios,reset-names)
> - drop | from descriptions
> - move patternProperties above allOf
> 
> v2:
> - rename mediatek.yaml => mediatek,mt7530.yaml
> - drop "boolean" in description
> - drop description for interrupt-properties
> - drop #interrupt-cells as requirement
> - example: eth=>ethernet,mdio0=>mdio,comment indention
> - replace 0 by GPIO_ACTIVE_HIGH in first example
> - use port(s)-pattern from dsa.yaml
> - adress/size-cells not added to required because this
>   is defined at mdio-level inc current dts , not switch level
> ---
>  .../bindings/net/dsa/mediatek,mt7530.yaml     | 423 ++++++++++++++++++
>  .../devicetree/bindings/net/dsa/mt7530.txt    | 327 --------------
>  2 files changed, 423 insertions(+), 327 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/dsa/mt7530.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> new file mode 100644
> index 000000000000..a7696d1b4a8c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -0,0 +1,423 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/mediatek,mt7530.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Mediatek MT7530 Ethernet switch
> +
> +maintainers:
> +  - Sean Wang <sean.wang@mediatek.com>
> +  - Landen Chao <Landen.Chao@mediatek.com>
> +  - DENG Qingfang <dqfext@gmail.com>
> +
> +description: |
> +  Port 5 of mt7530 and mt7621 switch is muxed between:
> +  1. GMAC5: GMAC5 can interface with another external MAC or PHY.
> +  2. PHY of port 0 or port 4: PHY interfaces with an external MAC like 2nd GMAC
> +     of the SOC. Used in many setups where port 0/4 becomes the WAN port.
> +     Note: On a MT7621 SOC with integrated switch: 2nd GMAC can only connected to
> +       GMAC5 when the gpios for RGMII2 (GPIO 22-33) are not used and not
> +       connected to external component!
> +
> +  Port 5 modes/configurations:
> +  1. Port 5 is disabled and isolated: An external phy can interface to the 2nd
> +     GMAC of the SOC.
> +     In the case of a build-in MT7530 switch, port 5 shares the RGMII bus with 2nd
> +     GMAC and an optional external phy. Mind the GPIO/pinctl settings of the SOC!
> +  2. Port 5 is muxed to PHY of port 0/4: Port 0/4 interfaces with 2nd GMAC.
> +     It is a simple MAC to PHY interface, port 5 needs to be setup for xMII mode
> +     and RGMII delay.
> +  3. Port 5 is muxed to GMAC5 and can interface to an external phy.
> +     Port 5 becomes an extra switch port.
> +     Only works on platform where external phy TX<->RX lines are swapped.
> +     Like in the Ubiquiti ER-X-SFP.
> +  4. Port 5 is muxed to GMAC5 and interfaces with the 2nd GAMC as 2nd CPU port.
> +     Currently a 2nd CPU port is not supported by DSA code.
> +
> +  Depending on how the external PHY is wired:
> +  1. normal: The PHY can only connect to 2nd GMAC but not to the switch
> +  2. swapped: RGMII TX, RX are swapped; external phy interface with the switch as
> +     a ethernet port. But can't interface to the 2nd GMAC.
> +
> +    Based on the DT the port 5 mode is configured.
> +
> +  Driver tries to lookup the phy-handle of the 2nd GMAC of the master device.
> +  When phy-handle matches PHY of port 0 or 4 then port 5 set-up as mode 2.
> +  phy-mode must be set, see also example 2 below!
> +  * mt7621: phy-mode = "rgmii-txid";
> +  * mt7623: phy-mode = "rgmii";
> +
> +  CPU-Ports need a phy-mode property:
> +    Allowed values on mt7530 and mt7621:
> +      - "rgmii"
> +      - "trgmii"
> +    On mt7531:
> +      - "1000base-x"
> +      - "2500base-x"
> +      - "sgmii"
> +
> +
> +properties:
> +  compatible:
> +    enum:
> +      - mediatek,mt7530
> +      - mediatek,mt7531
> +      - mediatek,mt7621
> +

> +  "#address-cells":
> +    const: 1
> +
> +  "#size-cells":
> +    const: 0

I don't see any child nodes with addresses, so these can be removed.

> +
> +  core-supply:
> +    description:
> +      Phandle to the regulator node necessary for the core power.
> +
> +  "#gpio-cells":
> +    const: 2
> +
> +  gpio-controller:
> +    type: boolean
> +    description:
> +      if defined, MT7530's LED controller will run on GPIO mode.
> +
> +  "#interrupt-cells":
> +    const: 1
> +
> +  interrupt-controller:
> +    type: boolean

Already has a type. Just:

interrupt-controller: true

> +
> +  interrupts:
> +    maxItems: 1
> +
> +  io-supply:
> +    description:
> +      Phandle to the regulator node necessary for the I/O power.
> +      See Documentation/devicetree/bindings/regulator/mt6323-regulator.txt
> +      for details for the regulator setup on these boards.
> +
> +  mediatek,mcm:
> +    type: boolean
> +    description:
> +      if defined, indicates that either MT7530 is the part on multi-chip
> +      module belong to MT7623A has or the remotely standalone chip as the
> +      function MT7623N reference board provided for.
> +
> +  reset-gpios:
> +    maxItems: 1
> +
> +  reset-names:
> +    const: mcm
> +
> +  resets:
> +    description:
> +      Phandle pointing to the system reset controller with line index for
> +      the ethsys.
> +    maxItems: 1
> +
> +patternProperties:
> +  "^(ethernet-)?ports$":
> +    type: object

       additionalProperties: false

> +
> +    patternProperties:
> +      "^(ethernet-)?port@[0-9]+$":
> +        type: object
> +        description: Ethernet switch ports
> +
> +        unevaluatedProperties: false
> +
> +        properties:
> +          reg:
> +            description:
> +              Port address described must be 5 or 6 for CPU port and from 0
> +              to 5 for user ports.
> +
> +        allOf:
> +          - $ref: dsa-port.yaml#
> +          - if:
> +              properties:
> +                label:
> +                  items:
> +                    - const: cpu
> +            then:
> +              required:
> +                - reg
> +                - phy-mode
> +
> +required:
> +  - compatible
> +  - reg
> +
> +allOf:
> +  - $ref: "dsa.yaml#"
> +  - if:
> +      required:
> +        - mediatek,mcm
> +    then:
> +      required:
> +        - resets
> +        - reset-names
> +    else:
> +      required:
> +        - reset-gpios
> +
> +  - if:
> +      required:
> +        - interrupt-controller
> +    then:
> +      required:
> +        - interrupts

This can be expressed as:

dependencies:
  interrupt-controller: [ interrupts ]
    
> +
> +  - if:
> +      properties:
> +        compatible:
> +          items:
> +            - const: mediatek,mt7530
> +    then:
> +      required:
> +        - core-supply
> +        - io-supply
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +    mdio {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        switch@0 {
> +            compatible = "mediatek,mt7530";
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +            reg = <0>;
> +
> +            core-supply = <&mt6323_vpa_reg>;
> +            io-supply = <&mt6323_vemc3v3_reg>;
> +            reset-gpios = <&pio 33 GPIO_ACTIVE_HIGH>;
> +
> +            ports {

Use the preferred form: ethernet-ports

> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +                port@0 {

