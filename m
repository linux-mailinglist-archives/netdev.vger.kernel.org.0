Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014ED2E06BB
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 08:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgLVHcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 02:32:03 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:37558 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLVHcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 02:32:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1608622321; x=1640158321;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fiSj1G3bsRHVgJi4A4NbaPKhuzCrlQNF4M9ZnyJ3ZQQ=;
  b=YRrzDwtMRgpamRvi+UFNV6xn0ktuJS3YpiSOU4DSVbE7EtmBdtriNc9n
   T0nPVajxpv2Hrrod3KEE8uvU0b+S0+vUESb0zTJ1ADigFFMs5UUHG7psC
   IXWZnOr1I+ImCtu8+ds7MSigk+f+yEHsjXT2JXrQnJj0ci3nnSlBu83aG
   ZR7MkFvU2y+PcPZ2zQ7EVvZQ770hYJsNOY1raXA9FPCVwL1twxueO5pvu
   j7kF9Z2tE3/F6+m6r94qEnZZB7ssuwZkt26iDmoVlCs8CpJWDRE+JFURW
   s2i5Yw3ul/uZ2IwrooggkenHNiP15Hv8gI2fF8CCtJt2GTxZao/tCMT2F
   A==;
IronPort-SDR: Y+yNfPyybZTRusIEJfIptk1cWNyIdlvvxhNu0kFNxnzKm3ay01vsX7KAid0fIjOB5JWvZUmJuh
 hIhvVwQMVyLjgb7muGBJ5+gRKR0yR6CPpm5C3+e+wOiXsRET18WTajWg5bx9BDm/MJR++uNTzn
 iAazcKX8K9FbGDJzooTD56RO9b4sSFMQOG9fSzhhz3FIsMtxN0uLhcbAJYJK0eVkq1ghzRILrC
 fgme//W0hSsXg1Hp0C5Pr+CAjjT16T832ZAdXY56JaM08JFuthZ0Uw8aRbx3qjswJvwQWgmBKr
 wVA=
X-IronPort-AV: E=Sophos;i="5.78,438,1599548400"; 
   d="scan'208";a="108551061"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Dec 2020 00:30:45 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 22 Dec 2020 00:30:45 -0700
Received: from tyr.hegelund-hansen.dk (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 22 Dec 2020 00:30:42 -0700
Message-ID: <daaae525cf3715068f6d0851a3dfce2466dc2ff0.camel@microchip.com>
Subject: Re: [RFC PATCH v2 1/8] dt-bindings: net: sparx5: Add sparx5-switch
 bindings
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Rob Herring <robh@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
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
        "Arnd Bergmann" <arnd@arndb.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Date:   Tue, 22 Dec 2020 08:30:41 +0100
In-Reply-To: <20201221214041.GA599050@robh.at.kernel.org>
References: <20201217075134.919699-1-steen.hegelund@microchip.com>
         <20201217075134.919699-2-steen.hegelund@microchip.com>
         <20201221214041.GA599050@robh.at.kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Mon, 2020-12-21 at 14:40 -0700, Rob Herring wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you
> know the content is safe
> 
> On Thu, Dec 17, 2020 at 08:51:27AM +0100, Steen Hegelund wrote:
> > Document the Sparx5 switch device driver bindings
> > 
> > Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> > Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> > ---
> >  .../bindings/net/microchip,sparx5-switch.yaml | 178
> > ++++++++++++++++++
> >  1 file changed, 178 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
> > 
> > diff --git
> > a/Documentation/devicetree/bindings/net/microchip,sparx5-
> > switch.yaml
> > b/Documentation/devicetree/bindings/net/microchip,sparx5-
> > switch.yaml
> > new file mode 100644
> > index 000000000000..6e3ef8285e9a
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/microchip,sparx5-
> > switch.yaml
> > @@ -0,0 +1,178 @@
> > +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> > +%YAML 1.2
> > +---
> > +$id: 
> > http://devicetree.org/schemas/net/microchip,sparx5-switch.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Microchip Sparx5 Ethernet switch controller
> > +
> > +maintainers:
> > +  - Lars Povlsen <lars.povlsen@microchip.com>
> > +  - Steen Hegelund <steen.hegelund@microchip.com>
> > +
> > +description: |
> > +  The SparX-5 Enterprise Ethernet switch family provides a rich
> > set of
> > +  Enterprise switching features such as advanced TCAM-based VLAN
> > and
> > +  QoS processing enabling delivery of differentiated services, and
> > +  security through TCAM-based frame processing using versatile
> > content
> > +  aware processor (VCAP).
> > +
> > +  IPv4/IPv6 Layer 3 (L3) unicast and multicast routing is
> > supported
> > +  with up to 18K IPv4/9K IPv6 unicast LPM entries and up to 9K
> > IPv4/3K
> > +  IPv6 (S,G) multicast groups.
> > +
> > +  L3 security features include source guard and reverse path
> > +  forwarding (uRPF) tasks. Additional L3 features include VRF-Lite
> > and
> > +  IP tunnels (IP over GRE/IP).
> > +
> > +  The SparX-5 switch family targets managed Layer 2 and Layer 3
> > +  equipment in SMB, SME, and Enterprise where high port count
> > +  1G/2.5G/5G/10G switching with 10G/25G aggregation links is
> > required.
> > +
> > +properties:
> > +  $nodename:
> > +    pattern: "^switch@[0-9a-f]+$"
> > +
> > +  compatible:
> > +    const: microchip,sparx5-switch
> > +
> > +  reg:
> > +    minItems: 2
> > +
> > +  reg-names:
> > +    minItems: 2
> 
> This is the default based on 'items' length.

Does that mean that I should omit minItems here?

> 
> > +    items:
> > +      - const: devices
> > +      - const: gcb
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +    description: Interrupt used for reception of packets to the
> > CPU
> > +
> > +  ethernet-ports:
> > +    type: object
> > +    properties:
> > +      '#address-cells':
> > +        const: 1
> > +      '#size-cells':
> > +        const: 0
> > +
> > +    patternProperties:
> > +      "^port@[0-9]+$":
> > +        type: object
> > +        description: Switch ports
> > +
> > +        allOf:
> > +          - $ref: ethernet-controller.yaml#
> > +
> > +        properties:
> > +          reg:
> > +            description: Switch port number
> > +
> > +          max-speed:
> > +            maxItems: 1
> 
> Is that an array?

No it is just a single value.
> 
> > +            description: Bandwidth allocated to this port
> > +
> > +          phys:
> 
> How many? (maxItems)

I will add "maxItems: 1"

> 
> > +            description: phandle of a Ethernet Serdes PHY
> > +
> > +          phy-handle:
> > +            description: phandle of a Ethernet PHY
> > +
> > +          phy-mode:
> > +            description: Interface between the serdes and the phy
> 
> The whole set of modes defined is supported?

This driver does not impose any limits on phy-mode.  It is passed on to
the phy, so all modes are supported as I see it.

> 
> > +
> > +          sfp:
> > +            description: phandle of an SFP
> > +
> > +          managed:
> > +            maxItems: 1
> 
> An array?

No just a single item.


Thanks for your comments.

BR
Steen

> 
> > +            description: SFP management
> > +
> > +        required:
> > +          - reg
> > +          - max-speed
> > +          - phys
> > +
> > +        oneOf:
> > +          - required:
> > +              - phy-handle
> > +              - phy-mode
> > +          - required:
> > +              - sfp
> > +              - managed
> > +
> > +        additionalProperties: false
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - reg-names
> > +  - interrupts
> > +  - ethernet-ports
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +    switch: switch@600000000 {
> > +      compatible = "microchip,sparx5-switch";
> > +      reg =  <0x10000000 0x800000>,
> > +             <0x11010000 0x1b00000>;
> > +      reg-names = "devices", "gcb";
> > +
> > +      interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
> > +      ethernet-ports {
> > +        #address-cells = <1>;
> > +        #size-cells = <0>;
> > +
> > +        port0: port@0 {
> > +          reg = <0>;
> > +          max-speed = <1000>;
> > +          phys = <&serdes 13>;
> > +          phy-handle = <&phy0>;
> > +          phy-mode = "qsgmii";
> > +        };
> > +        /* ... */
> > +        /* Then the 25G interfaces */
> > +        port60: port@60 {
> > +          reg = <60>;
> > +          max-speed = <25000>;
> > +          phys = <&serdes 29>;
> > +          sfp = <&sfp_eth60>;
> > +          managed = "in-band-status";
> > +        };
> > +        port61: port@61 {
> > +          reg = <61>;
> > +          max-speed = <25000>;
> > +          phys = <&serdes 30>;
> > +          sfp = <&sfp_eth61>;
> > +          managed = "in-band-status";
> > +        };
> > +        port62: port@62 {
> > +          reg = <62>;
> > +          max-speed = <25000>;
> > +          phys = <&serdes 31>;
> > +          sfp = <&sfp_eth62>;
> > +          managed = "in-band-status";
> > +        };
> > +        port63: port@63 {
> > +          reg = <63>;
> > +          max-speed = <25000>;
> > +          phys = <&serdes 32>;
> > +          sfp = <&sfp_eth63>;
> > +          managed = "in-band-status";
> > +        };
> > +        /* Finally the Management interface */
> > +        port64: port@64 {
> > +          reg = <64>;
> > +          max-speed = <1000>;
> > +          phys = <&serdes 0>;
> > +          phy-handle = <&phy64>;
> > +          phy-mode = "sgmii";
> > +        };
> > +      };
> > +    };
> > +
> > +...
> > --
> > 2.29.2
> > 


