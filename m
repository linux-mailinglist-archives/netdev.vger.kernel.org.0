Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF07460B3F
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 00:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359700AbhK1Xp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 18:45:29 -0500
Received: from mail-ot1-f46.google.com ([209.85.210.46]:33325 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241517AbhK1Xn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 18:43:28 -0500
Received: by mail-ot1-f46.google.com with SMTP id 35-20020a9d08a6000000b00579cd5e605eso23120246otf.0;
        Sun, 28 Nov 2021 15:40:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V987jWUcwu1zEBDpeF1bKg7l3lsSBlLTX24rVQBKc+k=;
        b=el6DVisk0dQMA98cby+8glDjkuwgz/aqMNw/CgYK0Tr6S2OKM0YK0UY9hqpK91uPpR
         Pi0LD2v7n2pUfS1D6gHcNps7mZxyw254W+dfvDUgN529ghX33G2f8q3tHZClGSKtue0i
         7d7ntvfsPgHZVzKN/NV6CEyr4rkQJqsziVZWYnUsPRmG7dOIFtYOvQE58dGlAyIsXejE
         vWpRbYEXottyRKVN1K5Z67S04KShuGYvj75QY3Ty+7ReyO2/u/ucKnT0csere+MXZk4K
         kYjzP6dGETlQbEoRjb1GcoNbHDPfuXa3XVaaYWqWEuSY+7wX+rhnHt7btodJcF1oPkb+
         J2eQ==
X-Gm-Message-State: AOAM533WxaigykjPI6pUtZyzxY0Yr4a/AVHUBnaZ0zJkaNPra9iHuyJ7
        orDZ/eBGE+6FV81sT6gE6oycZEscdw==
X-Google-Smtp-Source: ABdhPJzm5/DjIBj7g5Z7Q05TRAVUzBX52plVej9XZqyF8OnFiNJZl9JuOET6abxyklxQT3lkl4tq3A==
X-Received: by 2002:a05:6830:2b25:: with SMTP id l37mr41320213otv.298.1638142811679;
        Sun, 28 Nov 2021 15:40:11 -0800 (PST)
Received: from robh.at.kernel.org ([2607:fb90:5fe7:4487:4f99:dbc0:75d1:3e27])
        by smtp.gmail.com with ESMTPSA id p14sm2065193oov.0.2021.11.28.15.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 15:40:10 -0800 (PST)
Received: (nullmailer pid 2830943 invoked by uid 1000);
        Sun, 28 Nov 2021 23:40:08 -0000
Date:   Sun, 28 Nov 2021 17:40:08 -0600
From:   Rob Herring <robh@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, UNGLinuxDriver@microchip.com,
        p.zabel@pengutronix.de, linux@armlinux.org.uk, andrew@lunn.ch,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/6] dt-bindings: net: lan966x: Add
 lan966x-switch bindings
Message-ID: <YaQTWG6g8nNP7GGX@robh.at.kernel.org>
References: <20211126090540.3550913-1-horatiu.vultur@microchip.com>
 <20211126090540.3550913-2-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126090540.3550913-2-horatiu.vultur@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 10:05:35AM +0100, Horatiu Vultur wrote:
> Document the lan966x switch device driver bindings
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../net/microchip,lan966x-switch.yaml         | 149 ++++++++++++++++++
>  1 file changed, 149 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> new file mode 100644
> index 000000000000..9367491dd2d5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> @@ -0,0 +1,149 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/microchip,lan966x-switch.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Microchip Lan966x Ethernet switch controller
> +
> +maintainers:
> +  - Horatiu Vultur <horatiu.vultur@microchip.com>
> +
> +description: |
> +  The lan966x switch is a multi-port Gigabit AVB/TSN Ethernet Switch with
> +  two integrated 10/100/1000Base-T PHYs. In addition to the integrated PHYs,
> +  it supports up to 2RGMII/RMII, up to 3BASE-X/SERDES/2.5GBASE-X and up to
> +  2 Quad-SGMII/Quad-USGMII interfaces.
> +
> +properties:
> +  $nodename:
> +    pattern: "^switch@[0-9a-f]+$"
> +
> +  compatible:
> +    const: microchip,lan966x-switch
> +
> +  reg:
> +    items:
> +      - description: cpu target
> +      - description: general control block target
> +
> +  reg-names:
> +    items:
> +      - const: cpu
> +      - const: gcb
> +
> +  interrupts:
> +    minItems: 1
> +    items:
> +      - description: register based extraction
> +      - description: frame dma based extraction
> +
> +  interrupt-names:
> +    minItems: 1
> +    items:
> +      - const: xtr
> +      - const: fdma
> +
> +  resets:
> +    items:
> +      - description: Reset controller used for switch core reset (soft reset)
> +      - description: Reset controller used for releasing the phy from reset
> +
> +  reset-names:
> +    items:
> +      - const: switch
> +      - const: phy
> +
> +  ethernet-ports:
> +    type: object
> +    patternProperties:
> +      "^port@[0-9a-f]+$":
> +        type: object

This needs a reference to ethernet-controller.yaml so that all the 
properties have a type applied.

See dsa.yaml for an example.

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
> +          phys:
> +            description:
> +              Phandle of a Ethernet SerDes PHY
> +
> +          phy-mode:
> +            description:
> +              This specifies the interface used by the Ethernet SerDes towards
> +              the PHY or SFP.

Presumably only some subset of all defined modes are possible on this 
h/w?

> +
> +          phy-handle:
> +            description:
> +              Phandle of a Ethernet PHY.
> +
> +          sfp:
> +            description:
> +              Phandle of an SFP.
> +
> +          managed: true
> +
> +        required:
> +          - reg
> +          - phys
> +          - phy-mode
> +
> +        oneOf:
> +          - required:
> +              - phy-handle
> +          - required:
> +              - sfp
> +              - managed
> +
> +required:
> +  - compatible
> +  - reg
> +  - reg-names
> +  - interrupts
> +  - interrupt-names
> +  - resets
> +  - reset-names
> +  - ethernet-ports
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    switch: switch@e0000000 {
> +      compatible = "microchip,lan966x-switch";
> +      reg =  <0xe0000000 0x0100000>,
> +             <0xe2000000 0x0800000>;
> +      reg-names = "cpu", "gcb";
> +      interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
> +      interrupt-names = "xtr";
> +      resets = <&switch_reset 0>, <&phy_reset 0>;
> +      reset-names = "switch", "phy";
> +      ethernet-ports {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        port0: port@0 {
> +          reg = <0>;
> +          phy-handle = <&phy0>;
> +          phys = <&serdes 0 0>;
> +          phy-mode = "gmii";
> +        };
> +
> +        port1: port@1 {
> +          reg = <1>;
> +          sfp = <&sfp_eth1>;
> +          managed = "in-band-status";
> +          phys = <&serdes 2 4>;
> +          phy-mode = "sgmii";
> +        };
> +      };
> +    };
> +
> +...
> -- 
> 2.33.0
> 
> 
