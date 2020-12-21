Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA452E0222
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 22:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgLUVl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 16:41:26 -0500
Received: from mail-oo1-f46.google.com ([209.85.161.46]:43071 "EHLO
        mail-oo1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLUVlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 16:41:25 -0500
Received: by mail-oo1-f46.google.com with SMTP id y14so2527697oom.10;
        Mon, 21 Dec 2020 13:41:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MsDWEDLGUo2wKHbTPaKIbDp1wp/1cG8iI898N+T9yX0=;
        b=DKwmgpTZ60JfohWIfFOPFEEOBgWYhAOf6GvDT3kz6Peu6ZRBaxnwtqAAuWAvWiuX72
         jVHGqDBDR9VRElp84CEIi/joiOS3Jrimnd0oO4DlH7qeQopnR2o2JAXQdYxIEMfpYpV2
         xfdHSwzY4O4vvV2K5WFJLrVfxJUDaXCEFEHZsgRu2My8HbCADQsw8gkK++0muDMmWgYi
         JzBaSRYKnBcDdmOcvtPc1iq9fUWytOLDQWPavZ5VHgAINcS53yVHrfnYwEoszpfV/3B2
         WW4ZjXzdqNtNDbwcdJ1VEAePWLj7InH+1/4/2f6VaQ3pAxsJEnARM7Qsll4w4jUuoDQt
         yIhA==
X-Gm-Message-State: AOAM532QsGdz8gFPG7LnWGdKpfKeFrvx2XqQ5ibXfSQk8N6Lj/NX61GV
        kihICdj/udJtMZ/sM0v7lt89vexoFw==
X-Google-Smtp-Source: ABdhPJwZTgbrOGmtRx8F0ujJe3gRA4dzDPzK6IRuMUd+wKSPdctcWIf9jtmEn7jQQdQ3MVHh7WHLjQ==
X-Received: by 2002:a4a:751a:: with SMTP id j26mr12971469ooc.68.1608586844312;
        Mon, 21 Dec 2020 13:40:44 -0800 (PST)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id n22sm3840304oig.32.2020.12.21.13.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 13:40:43 -0800 (PST)
Received: (nullmailer pid 609332 invoked by uid 1000);
        Mon, 21 Dec 2020 21:40:41 -0000
Date:   Mon, 21 Dec 2020 14:40:41 -0700
From:   Rob Herring <robh@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v2 1/8] dt-bindings: net: sparx5: Add sparx5-switch
 bindings
Message-ID: <20201221214041.GA599050@robh.at.kernel.org>
References: <20201217075134.919699-1-steen.hegelund@microchip.com>
 <20201217075134.919699-2-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217075134.919699-2-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 08:51:27AM +0100, Steen Hegelund wrote:
> Document the Sparx5 switch device driver bindings
> 
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> ---
>  .../bindings/net/microchip,sparx5-switch.yaml | 178 ++++++++++++++++++
>  1 file changed, 178 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
> new file mode 100644
> index 000000000000..6e3ef8285e9a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
> @@ -0,0 +1,178 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/microchip,sparx5-switch.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Microchip Sparx5 Ethernet switch controller
> +
> +maintainers:
> +  - Lars Povlsen <lars.povlsen@microchip.com>
> +  - Steen Hegelund <steen.hegelund@microchip.com>
> +
> +description: |
> +  The SparX-5 Enterprise Ethernet switch family provides a rich set of
> +  Enterprise switching features such as advanced TCAM-based VLAN and
> +  QoS processing enabling delivery of differentiated services, and
> +  security through TCAM-based frame processing using versatile content
> +  aware processor (VCAP).
> +
> +  IPv4/IPv6 Layer 3 (L3) unicast and multicast routing is supported
> +  with up to 18K IPv4/9K IPv6 unicast LPM entries and up to 9K IPv4/3K
> +  IPv6 (S,G) multicast groups.
> +
> +  L3 security features include source guard and reverse path
> +  forwarding (uRPF) tasks. Additional L3 features include VRF-Lite and
> +  IP tunnels (IP over GRE/IP).
> +
> +  The SparX-5 switch family targets managed Layer 2 and Layer 3
> +  equipment in SMB, SME, and Enterprise where high port count
> +  1G/2.5G/5G/10G switching with 10G/25G aggregation links is required.
> +
> +properties:
> +  $nodename:
> +    pattern: "^switch@[0-9a-f]+$"
> +
> +  compatible:
> +    const: microchip,sparx5-switch
> +
> +  reg:
> +    minItems: 2
> +
> +  reg-names:
> +    minItems: 2

This is the default based on 'items' length.

> +    items:
> +      - const: devices
> +      - const: gcb
> +
> +  interrupts:
> +    maxItems: 1
> +    description: Interrupt used for reception of packets to the CPU
> +
> +  ethernet-ports:
> +    type: object
> +    properties:
> +      '#address-cells':
> +        const: 1
> +      '#size-cells':
> +        const: 0
> +
> +    patternProperties:
> +      "^port@[0-9]+$":
> +        type: object
> +        description: Switch ports
> +
> +        allOf:
> +          - $ref: ethernet-controller.yaml#
> +
> +        properties:
> +          reg:
> +            description: Switch port number
> +
> +          max-speed:
> +            maxItems: 1

Is that an array?

> +            description: Bandwidth allocated to this port
> +
> +          phys:

How many? (maxItems)

> +            description: phandle of a Ethernet Serdes PHY
> +
> +          phy-handle:
> +            description: phandle of a Ethernet PHY
> +
> +          phy-mode:
> +            description: Interface between the serdes and the phy

The whole set of modes defined is supported?

> +
> +          sfp:
> +            description: phandle of an SFP
> +
> +          managed:
> +            maxItems: 1

An array?

> +            description: SFP management
> +
> +        required:
> +          - reg
> +          - max-speed
> +          - phys
> +
> +        oneOf:
> +          - required:
> +              - phy-handle
> +              - phy-mode
> +          - required:
> +              - sfp
> +              - managed
> +
> +        additionalProperties: false
> +
> +required:
> +  - compatible
> +  - reg
> +  - reg-names
> +  - interrupts
> +  - ethernet-ports
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    switch: switch@600000000 {
> +      compatible = "microchip,sparx5-switch";
> +      reg =  <0x10000000 0x800000>,
> +             <0x11010000 0x1b00000>;
> +      reg-names = "devices", "gcb";
> +
> +      interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
> +      ethernet-ports {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        port0: port@0 {
> +          reg = <0>;
> +          max-speed = <1000>;
> +          phys = <&serdes 13>;
> +          phy-handle = <&phy0>;
> +          phy-mode = "qsgmii";
> +        };
> +        /* ... */
> +        /* Then the 25G interfaces */
> +        port60: port@60 {
> +          reg = <60>;
> +          max-speed = <25000>;
> +          phys = <&serdes 29>;
> +          sfp = <&sfp_eth60>;
> +          managed = "in-band-status";
> +        };
> +        port61: port@61 {
> +          reg = <61>;
> +          max-speed = <25000>;
> +          phys = <&serdes 30>;
> +          sfp = <&sfp_eth61>;
> +          managed = "in-band-status";
> +        };
> +        port62: port@62 {
> +          reg = <62>;
> +          max-speed = <25000>;
> +          phys = <&serdes 31>;
> +          sfp = <&sfp_eth62>;
> +          managed = "in-band-status";
> +        };
> +        port63: port@63 {
> +          reg = <63>;
> +          max-speed = <25000>;
> +          phys = <&serdes 32>;
> +          sfp = <&sfp_eth63>;
> +          managed = "in-band-status";
> +        };
> +        /* Finally the Management interface */
> +        port64: port@64 {
> +          reg = <64>;
> +          max-speed = <1000>;
> +          phys = <&serdes 0>;
> +          phy-handle = <&phy64>;
> +          phy-mode = "sgmii";
> +        };
> +      };
> +    };
> +
> +...
> -- 
> 2.29.2
> 
