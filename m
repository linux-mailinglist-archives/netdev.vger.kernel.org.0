Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5787C4612F8
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 11:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353720AbhK2K7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 05:59:00 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:61171 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354053AbhK2K47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 05:56:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638183222; x=1669719222;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=R9q8ZY+4y741nMzmbZ39VvreAq/x6X3LyAqZ012x52g=;
  b=vzxyZHdNxuQYXpzaoLJyED8NxeD2B5pNHoTsTZzSLwK2FTtRZ92vmM9O
   J0sFF5/lHHyl+XecJyA5qTIDfvv44NOISGuQkPQUc0eIcMLyO7KSv/iAm
   EgusNMugBrCYZbEIS4LH4ThyOlFBr6pcv7nMNYR7uHFHe7YolSB8vrHcy
   jSIlzd8p/olh3nh01Jnaps22NvqCV1WKmi9XcQqj5Y6yaMfoze5qH8qT+
   7ZZhXJL/6/F5S8O7DwWmXdVn38tqEQhwhWZgp05ap0LWBwIcn+WhRQqfR
   4S/S4Mu64oej93CbocbdzDVT41HA18DiZKud2cW6WthKnevHDHP7w2ih9
   Q==;
IronPort-SDR: MK7wi5yjSHmP1bE+nIW0rQVbEccW9k9jBa8xPjop6r0EDbg6tuY3b2dt9axMVRM9gnn7mBhnce
 VYhTO1lEclxv/jcFqEV0lqY8UddkxON4Hi5kfNkHVKbfe8inYd5ip2hHGcnIMbb3E/Aa00g4Bm
 Pap2dX56C5gfKdCULlohQxPnNSc6ACsxqdhMosVJBBjbZeZvEPyP0YA0tSCL0Xw8q2fxYEBaMY
 6A6qcLNomAFUuR8fF4tHNqvFs2HpnEf4jRGl/YdNewEgBt9HnH7+4VIASZUwpBvUT2f6iva79U
 Ax400hbZKbVURmxT+Iz9JKes
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="145416852"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Nov 2021 03:53:41 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 29 Nov 2021 03:53:41 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Mon, 29 Nov 2021 03:53:41 -0700
Date:   Mon, 29 Nov 2021 11:55:37 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Rob Herring <robh@kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v4 1/6] dt-bindings: net: lan966x: Add
 lan966x-switch bindings
Message-ID: <20211129105537.p3elvh5bztyhner2@soft-dev3-1.localhost>
References: <20211126090540.3550913-1-horatiu.vultur@microchip.com>
 <20211126090540.3550913-2-horatiu.vultur@microchip.com>
 <YaQTWG6g8nNP7GGX@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YaQTWG6g8nNP7GGX@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/28/2021 17:40, Rob Herring wrote:

Hi Rob,

> 
> On Fri, Nov 26, 2021 at 10:05:35AM +0100, Horatiu Vultur wrote:
> > Document the lan966x switch device driver bindings
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  .../net/microchip,lan966x-switch.yaml         | 149 ++++++++++++++++++
> >  1 file changed, 149 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> > new file mode 100644
> > index 000000000000..9367491dd2d5
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> > @@ -0,0 +1,149 @@
> > +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/microchip,lan966x-switch.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Microchip Lan966x Ethernet switch controller
> > +
> > +maintainers:
> > +  - Horatiu Vultur <horatiu.vultur@microchip.com>
> > +
> > +description: |
> > +  The lan966x switch is a multi-port Gigabit AVB/TSN Ethernet Switch with
> > +  two integrated 10/100/1000Base-T PHYs. In addition to the integrated PHYs,
> > +  it supports up to 2RGMII/RMII, up to 3BASE-X/SERDES/2.5GBASE-X and up to
> > +  2 Quad-SGMII/Quad-USGMII interfaces.
> > +
> > +properties:
> > +  $nodename:
> > +    pattern: "^switch@[0-9a-f]+$"
> > +
> > +  compatible:
> > +    const: microchip,lan966x-switch
> > +
> > +  reg:
> > +    items:
> > +      - description: cpu target
> > +      - description: general control block target
> > +
> > +  reg-names:
> > +    items:
> > +      - const: cpu
> > +      - const: gcb
> > +
> > +  interrupts:
> > +    minItems: 1
> > +    items:
> > +      - description: register based extraction
> > +      - description: frame dma based extraction
> > +
> > +  interrupt-names:
> > +    minItems: 1
> > +    items:
> > +      - const: xtr
> > +      - const: fdma
> > +
> > +  resets:
> > +    items:
> > +      - description: Reset controller used for switch core reset (soft reset)
> > +      - description: Reset controller used for releasing the phy from reset
> > +
> > +  reset-names:
> > +    items:
> > +      - const: switch
> > +      - const: phy
> > +
> > +  ethernet-ports:
> > +    type: object
> > +    patternProperties:
> > +      "^port@[0-9a-f]+$":
> > +        type: object
> 
> This needs a reference to ethernet-controller.yaml so that all the
> properties have a type applied.
> 
> See dsa.yaml for an example.

Yes, I will do that in the next version.

> 
> > +
> > +        properties:
> > +          '#address-cells':
> > +            const: 1
> > +          '#size-cells':
> > +            const: 0
> > +
> > +          reg:
> > +            description:
> > +              Switch port number
> > +
> > +          phys:
> > +            description:
> > +              Phandle of a Ethernet SerDes PHY
> > +
> > +          phy-mode:
> > +            description:
> > +              This specifies the interface used by the Ethernet SerDes towards
> > +              the PHY or SFP.
> 
> Presumably only some subset of all defined modes are possible on this
> h/w?

That is correct, I will add an enum with the supported modes. Something
like in ethernet-controller.yaml.

> 
> > +
> > +          phy-handle:
> > +            description:
> > +              Phandle of a Ethernet PHY.
> > +
> > +          sfp:
> > +            description:
> > +              Phandle of an SFP.
> > +
> > +          managed: true
> > +
> > +        required:
> > +          - reg
> > +          - phys
> > +          - phy-mode
> > +
> > +        oneOf:
> > +          - required:
> > +              - phy-handle
> > +          - required:
> > +              - sfp
> > +              - managed
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - reg-names
> > +  - interrupts
> > +  - interrupt-names
> > +  - resets
> > +  - reset-names
> > +  - ethernet-ports
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +    switch: switch@e0000000 {
> > +      compatible = "microchip,lan966x-switch";
> > +      reg =  <0xe0000000 0x0100000>,
> > +             <0xe2000000 0x0800000>;
> > +      reg-names = "cpu", "gcb";
> > +      interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
> > +      interrupt-names = "xtr";
> > +      resets = <&switch_reset 0>, <&phy_reset 0>;
> > +      reset-names = "switch", "phy";
> > +      ethernet-ports {
> > +        #address-cells = <1>;
> > +        #size-cells = <0>;
> > +
> > +        port0: port@0 {
> > +          reg = <0>;
> > +          phy-handle = <&phy0>;
> > +          phys = <&serdes 0 0>;
> > +          phy-mode = "gmii";
> > +        };
> > +
> > +        port1: port@1 {
> > +          reg = <1>;
> > +          sfp = <&sfp_eth1>;
> > +          managed = "in-band-status";
> > +          phys = <&serdes 2 4>;
> > +          phy-mode = "sgmii";
> > +        };
> > +      };
> > +    };
> > +
> > +...
> > --
> > 2.33.0
> >
> >

-- 
/Horatiu
