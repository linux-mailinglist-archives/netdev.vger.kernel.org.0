Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5283463F2A
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 21:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343656AbhK3U0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 15:26:41 -0500
Received: from mail-ot1-f48.google.com ([209.85.210.48]:38818 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235402AbhK3U0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 15:26:36 -0500
Received: by mail-ot1-f48.google.com with SMTP id n104-20020a9d2071000000b005799790cf0bso31919393ota.5;
        Tue, 30 Nov 2021 12:23:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GP0G3mi93Tk0S+zMq1Y9xib6nRVOzxT1ojVllfCzEjM=;
        b=4NoXyFnPMSX1h96EbjnvVMuMvRk5PtBqlrfXYN3nzRywb/l5b15u0SV6UQf6Liccdy
         HpJ/8Jkz4X2JjzMwipb9fupNbka2jnTmElx3gr7NNZxujI+KcaqO9/84rj8323/bp5uU
         YmyBS9bdJWMhhYlin4Ks/vTxukmdAEJ1uQCJ5BAQy/RpnQW0eU4AmEwrSWBaa4bLGz4y
         ixeFSO3TN7lw9PUK50hr1lEQGwzQkRTTDL/TdEepIMVy+ewPdf67BzJ32OHDj0ZSBEeC
         JlC6aAePAyjofPYzojLBVp3vObSpED5giHeOPei360gfrvTi5iyppLu93qN+T9/ykOzp
         VxiA==
X-Gm-Message-State: AOAM533f7VKFPH0+Rzmnnm56cuwVgVL/VFN/b5Q94jRFGYQUkkuVpwgI
        CXi49vNx6/grcfe6It39sw==
X-Google-Smtp-Source: ABdhPJxafuv3dfSoZyGP/ll4kbKKe7HdaoPWJoDp5p9QG50ZG8BdF4d9x4h3in9L+azPVeB8SNWC6w==
X-Received: by 2002:a9d:326:: with SMTP id 35mr1437970otv.41.1638303796864;
        Tue, 30 Nov 2021 12:23:16 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id v2sm3264639oto.3.2021.11.30.12.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 12:23:15 -0800 (PST)
Received: (nullmailer pid 2948128 invoked by uid 1000);
        Tue, 30 Nov 2021 20:23:14 -0000
Date:   Tue, 30 Nov 2021 14:23:14 -0600
From:   Rob Herring <robh@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, UNGLinuxDriver@microchip.com,
        p.zabel@pengutronix.de, linux@armlinux.org.uk, andrew@lunn.ch,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5 1/6] dt-bindings: net: lan966x: Add
 lan966x-switch bindings
Message-ID: <YaaIMizLkPG81gAO@robh.at.kernel.org>
References: <20211129124359.4069432-1-horatiu.vultur@microchip.com>
 <20211129124359.4069432-2-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129124359.4069432-2-horatiu.vultur@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 01:43:54PM +0100, Horatiu Vultur wrote:
> Document the lan966x switch device driver bindings
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../net/microchip,lan966x-switch.yaml         | 158 ++++++++++++++++++
>  1 file changed, 158 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> new file mode 100644
> index 000000000000..d54dc183a033
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> @@ -0,0 +1,158 @@
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

       additionalProperties: false

> +    patternProperties:
> +      "^port@[0-9a-f]+$":
> +        type: object
> +
> +        allOf:

Don't need allOf here.

> +          - $ref: "http://devicetree.org/schemas/net/ethernet-controller.yaml#"

Drop 'http://devicetree.org'. (If you copied that from somewhere, please 
fix them too.)

           unevaluatedProperties: false

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
> +            enum:
> +              - gmii
> +              - sgmii
> +              - qsgmii
> +              - 1000base-x
> +              - 2500base-x
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
