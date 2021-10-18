Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4260A431F2D
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbhJRORa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:17:30 -0400
Received: from mail-oi1-f169.google.com ([209.85.167.169]:41699 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbhJROR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 10:17:26 -0400
Received: by mail-oi1-f169.google.com with SMTP id r64so1344040oih.8;
        Mon, 18 Oct 2021 07:15:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ua0iRFPoYQJvns/PNH0V8FLbOTwAvkKWkQruqc5XXps=;
        b=Nl4kcZoIrVI5rGl0EKPK28bJyc0OxplxlIJbEWwm3pRUoGSCD7+ktWuaVlTNqr1znN
         k+Eq1coPq+jhkWoqsf1kxjIS4GuaHD5By+tuaE06mavGJabphlBzrpm4bYvuoVBECYWy
         u9KgaNU5lJ2iIb9dbxwJJzFkq19CGFEVKfyb72uCOj406d2h1LAWqUhIsSeMqlvIO3qW
         z3DXzxVwTtnhVJ3RsquWy+nyunhfCZ7ya/OpBXvMXbA3Sp5TaGU03ZZKlwh4bWPuqg+r
         WByx4aUOHeWE4rhEn0KlGJ0ahI08ACa6cwijaHkAQ7RcGIFoYviuNHkGrR6oeoZby8SR
         097Q==
X-Gm-Message-State: AOAM531GwmcU6N41nD+d9pJsU0gCQq4UB05i6MM/uwVjENBwvpwMWTnE
        v5NmjVUD6GlDV8ChGHF21w==
X-Google-Smtp-Source: ABdhPJyTOeKPmy2kcFcT3QpV5RN/rq1X8SUGD5Yj1DFHwSjLhp7SbPTjkvmPFo1IgJgDyixBC2YxQg==
X-Received: by 2002:aca:783:: with SMTP id 125mr15953oih.29.1634566514475;
        Mon, 18 Oct 2021 07:15:14 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id w18sm2021335ott.29.2021.10.18.07.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 07:15:13 -0700 (PDT)
Received: (nullmailer pid 2296740 invoked by uid 1000);
        Mon, 18 Oct 2021 14:15:12 -0000
Date:   Mon, 18 Oct 2021 09:15:12 -0500
From:   Rob Herring <robh@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Matthew Hagan <mnhagan88@gmail.com>
Subject: Re: [net-next PATCH v7 16/16] dt-bindings: net: dsa: qca8k: convert
 to YAML schema
Message-ID: <YW2BcC2izFM6HjG5@robh.at.kernel.org>
References: <20211013223921.4380-1-ansuelsmth@gmail.com>
 <20211013223921.4380-17-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013223921.4380-17-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 14, 2021 at 12:39:21AM +0200, Ansuel Smith wrote:
> From: Matthew Hagan <mnhagan88@gmail.com>
> 
> Convert the qca8k bindings to YAML format.
> 
> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> Co-developed-by: Ansuel Smith <ansuelsmth@gmail.com>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  .../devicetree/bindings/net/dsa/qca8k.txt     | 245 ------------
>  .../devicetree/bindings/net/dsa/qca8k.yaml    | 362 ++++++++++++++++++
>  2 files changed, 362 insertions(+), 245 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/dsa/qca8k.txt
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/qca8k.yaml



> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> new file mode 100644
> index 000000000000..48de0ace265d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> @@ -0,0 +1,362 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/qca8k.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm Atheros QCA83xx switch family
> +
> +maintainers:
> +  - John Crispin <john@phrozen.org>
> +
> +description:
> +  If the QCA8K switch is connect to an SoC's external mdio-bus, each subnode
> +  describing a port needs to have a valid phandle referencing the internal PHY
> +  it is connected to. This is because there is no N:N mapping of port and PHY
> +  ID. To declare the internal mdio-bus configuration, declare an MDIO node in
> +  the switch node and declare the phandle for the port, referencing the internal
> +  PHY it is connected to. In this config, an internal mdio-bus is registered and
> +  the MDIO master is used for communication. Mixed external and internal
> +  mdio-bus configurations are not supported by the hardware.
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - enum:

Don't need oneOf with one entry.

> +          - qca,qca8327
> +          - qca,qca8328
> +          - qca,qca8334
> +          - qca,qca8337
> +    description: |
> +      qca,qca8328: referenced as AR8328(N)-AK1(A/B) QFN 176 pin package
> +      qca,qca8327: referenced as AR8327(N)-AL1A DR-QFN 148 pin package
> +      qca,qca8334: referenced as QCA8334-AL3C QFN 88 pin package
> +      qca,qca8337: referenced as QCA8337N-AL3(B/C) DR-QFN 148 pin package
> +
> +  reg:
> +    maxItems: 1
> +
> +  reset-gpios:
> +    description:
> +      GPIO to be used to reset the whole device
> +    maxItems: 1
> +
> +  qca,ignore-power-on-sel:
> +    $ref: /schemas/types.yaml#/definitions/flag
> +    description:
> +      Ignore power-on pin strapping to configure LED open-drain or EEPROM
> +      presence. This is needed for devices with incorrect configuration or when
> +      the OEM has decided not to use pin strapping and falls back to SW regs.
> +
> +  qca,led-open-drain:
> +    $ref: /schemas/types.yaml#/definitions/flag
> +    description:
> +      Set LEDs to open-drain mode. This requires the qca,ignore-power-on-sel to
> +      be set, otherwise the driver will fail at probe. This is required if the
> +      OEM does not use pin strapping to set this mode and prefers to set it
> +      using SW regs. The pin strappings related to LED open-drain mode are
> +      B68 on the QCA832x and B49 on the QCA833x.
> +
> +  mdio:
> +    type: object
> +    description: Qca8k switch have an internal mdio to access switch port.
> +                 If this is not present, the legacy mapping is used and the
> +                 internal mdio access is used.
> +                 With the legacy mapping the reg corresponding to the internal
> +                 mdio is the switch reg with an offset of -1.

2 spaces more than description.

> +
> +    properties:
> +      '#address-cells':
> +        const: 1
> +      '#size-cells':
> +        const: 0

The mdio bus provides these constraints already.

> +
> +    patternProperties:
> +      "^(ethernet-)?phy@[0-4]$":
> +        type: object
> +
> +        allOf:

Don't need allOf.

> +          - $ref: "http://devicetree.org/schemas/net/mdio.yaml#"

The phy is an mdio bus? 

You don't need any of this. Just:

mdio:
  $ref: /schemas/net/mdio.yaml#
  unevaluatedProperties: false
  description: ...

> +
> +        properties:
> +          reg:
> +            maxItems: 1
> +
> +        required:
> +          - reg
> +
> +patternProperties:
> +  "^(ethernet-)?ports$":
> +    type: object
> +    properties:
> +      '#address-cells':
> +        const: 1
> +      '#size-cells':
> +        const: 0
> +
> +    patternProperties:
> +      "^(ethernet-)?port@[0-6]$":
> +        type: object
> +        description: Ethernet switch ports
> +
> +        properties:
> +          reg:
> +            description: Port number
> +
> +          label:
> +            description:
> +              Describes the label associated with this port, which will become
> +              the netdev name
> +            $ref: /schemas/types.yaml#/definitions/string
> +
> +          link:
> +            description:
> +              Should be a list of phandles to other switch's DSA port. This
> +              port is used as the outgoing port towards the phandle ports. The
> +              full routing information must be given, not just the one hop
> +              routes to neighbouring switches
> +            $ref: /schemas/types.yaml#/definitions/phandle-array
> +
> +          ethernet:
> +            description:
> +              Should be a phandle to a valid Ethernet device node.  This host
> +              device is what the switch port is connected to
> +            $ref: /schemas/types.yaml#/definitions/phandle

All of this is defined in dsa.yaml. Add a $ref to it and don't duplicate 
it here.

> +
> +          phy-handle: true
> +
> +          phy-mode: true
> +
> +          fixed-link: true
> +
> +          mac-address: true
> +
> +          sfp: true
> +
> +          qca,sgmii-rxclk-falling-edge:
> +            $ref: /schemas/types.yaml#/definitions/flag
> +            description:
> +              Set the receive clock phase to falling edge. Mostly commonly used on
> +              the QCA8327 with CPU port 0 set to SGMII.
> +
> +          qca,sgmii-txclk-falling-edge:
> +            $ref: /schemas/types.yaml#/definitions/flag
> +            description:
> +              Set the transmit clock phase to falling edge.
> +
> +          qca,sgmii-enable-pll:
> +            $ref: /schemas/types.yaml#/definitions/flag
> +            description:
> +              For SGMII CPU port, explicitly enable PLL, TX and RX chain along with
> +              Signal Detection. On the QCA8327 this should not be enabled, otherwise
> +              the SGMII port will not initialize. When used on the QCA8337, revision 3
> +              or greater, a warning will be displayed. When the CPU port is set to
> +              SGMII on the QCA8337, it is advised to set this unless a communication
> +              issue is observed.
> +
> +        required:
> +          - reg
> +
> +        additionalProperties: false
> +
> +oneOf:
> +  - required:
> +      - ports
> +  - required:
> +      - ethernet-ports
> +
> +required:
> +  - compatible
> +  - reg
> +
> +additionalProperties: true
> +
> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +
> +    mdio {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        external_phy_port1: ethernet-phy@0 {
> +            reg = <0>;
> +        };
> +
> +        external_phy_port2: ethernet-phy@1 {
> +            reg = <1>;
> +        };
> +
> +        external_phy_port3: ethernet-phy@2 {
> +            reg = <2>;
> +        };
> +
> +        external_phy_port4: ethernet-phy@3 {
> +            reg = <3>;
> +        };
> +
> +        external_phy_port5: ethernet-phy@4 {
> +            reg = <4>;
> +        };
> +
> +        switch@10 {
> +            compatible = "qca,qca8337";
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +            reset-gpios = <&gpio 42 GPIO_ACTIVE_LOW>;
> +            reg = <0x10>;
> +
> +            ports {

Use the preferred 'ethernet-ports'.

> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +
> +                port@0 {
> +                    reg = <0>;
> +                    label = "cpu";
> +                    ethernet = <&gmac1>;
> +                    phy-mode = "rgmii";
> +
> +                    fixed-link {
> +                        speed = <1000>;
> +                        full-duplex;
> +                    };
> +                };
> +
> +                port@1 {
> +                    reg = <1>;
> +                    label = "lan1";
> +                    phy-handle = <&external_phy_port1>;
> +                };
> +
> +                port@2 {
> +                    reg = <2>;
> +                    label = "lan2";
> +                    phy-handle = <&external_phy_port2>;
> +                };
> +
> +                port@3 {
> +                    reg = <3>;
> +                    label = "lan3";
> +                    phy-handle = <&external_phy_port3>;
> +                };
> +
> +                port@4 {
> +                    reg = <4>;
> +                    label = "lan4";
> +                    phy-handle = <&external_phy_port4>;
> +                };
> +
> +                port@5 {
> +                    reg = <5>;
> +                    label = "wan";
> +                    phy-handle = <&external_phy_port5>;
> +                };
> +            };
> +        };
> +    };
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +
> +    mdio {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        switch@10 {
> +            compatible = "qca,qca8337";
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +            reset-gpios = <&gpio 42 GPIO_ACTIVE_LOW>;
> +            reg = <0x10>;
> +
> +            ports {
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +
> +                port@0 {
> +                    reg = <0>;
> +                    label = "cpu";
> +                    ethernet = <&gmac1>;
> +                    phy-mode = "rgmii";
> +
> +                    fixed-link {
> +                        speed = <1000>;
> +                        full-duplex;
> +                    };
> +                };
> +
> +                port@1 {
> +                    reg = <1>;
> +                    label = "lan1";
> +                    phy-mode = "internal";
> +                    phy-handle = <&internal_phy_port1>;
> +                };
> +
> +                port@2 {
> +                    reg = <2>;
> +                    label = "lan2";
> +                    phy-mode = "internal";
> +                    phy-handle = <&internal_phy_port2>;
> +                };
> +
> +                port@3 {
> +                    reg = <3>;
> +                    label = "lan3";
> +                    phy-mode = "internal";
> +                    phy-handle = <&internal_phy_port3>;
> +                };
> +
> +                port@4 {
> +                    reg = <4>;
> +                    label = "lan4";
> +                    phy-mode = "internal";
> +                    phy-handle = <&internal_phy_port4>;
> +                };
> +
> +                port@5 {
> +                    reg = <5>;
> +                    label = "wan";
> +                    phy-mode = "internal";
> +                    phy-handle = <&internal_phy_port5>;
> +                };
> +
> +                port@6 {
> +                    reg = <0>;
> +                    label = "cpu";
> +                    ethernet = <&gmac1>;
> +                    phy-mode = "sgmii";
> +
> +                    qca,sgmii-rxclk-falling-edge;
> +
> +                    fixed-link {
> +                        speed = <1000>;
> +                        full-duplex;
> +                    };
> +                };
> +            };
> +
> +            mdio {
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +
> +                internal_phy_port1: ethernet-phy@0 {
> +                    reg = <0>;
> +                };
> +
> +                internal_phy_port2: ethernet-phy@1 {
> +                    reg = <1>;
> +                };
> +
> +                internal_phy_port3: ethernet-phy@2 {
> +                    reg = <2>;
> +                };
> +
> +                internal_phy_port4: ethernet-phy@3 {
> +                    reg = <3>;
> +                };
> +
> +                internal_phy_port5: ethernet-phy@4 {
> +                    reg = <4>;
> +                };
> +            };
> +        };
> +    };
> -- 
> 2.32.0
> 
> 
