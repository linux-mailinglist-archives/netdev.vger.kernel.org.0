Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18802F80ED
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 17:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732291AbhAOQgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 11:36:36 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:49307 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729927AbhAOQgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 11:36:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610728594; x=1642264594;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z2H0BjrpObl9GtrGBY5W/zw/ynjQNTC5+M/q2W6Kguw=;
  b=dymVs9//t9II+vdH5cn7fEkvHxIHZWk1uC3lRjvFZe/iJ79tZEAnSlbb
   F5m9XWz/RD56GlhTwDVLAy5HfqlUycMqR4+OKCItmrskagYlzUS+fmLMj
   Rc5c86clxqWqP/FSRrMpnvozhb6I0w+FCTmuWLPp2FtT1eCr/J1Hc8vqE
   GCUIEzPhhp2MoYMZh4ZyzHEGG3RCSaN/9Keh/rL6IYZ6poOcGQBCPaM6d
   JPkho9TwTUgKQohAHq1wgsPbTB8Kh7eLyVXFm9IhP3Zl4McSUOTiBWUX5
   sHU3TJNafT+mSvqd+2KcnSRpjbSk6xDgFMYwPMZzm9u8Ur4iGvK1Htufg
   w==;
IronPort-SDR: CWleVI2TpkeimUocOW3Pb+7EyQE1GtnNxholLJOu7MM8gL+xn+DZ7k0decbT+KK3OxdF8NNh+w
 EQyhbZGl9IYm1w4GlgEJJ9JxoVGO05NYlkF9bXyjvg8QKhkRbVcUiXNVLN6Uuwh5Qtk3iXnvV8
 STEZuC3PlldK7ofvElwh13Q0zyDby+OmfcbstGgqqkG/TPgKnk1PASUCWsI+xZ6Z7Kg1VVtjRu
 +t2YH/FLOkJStV4/rRplBWxXq6oqjxKNenpVwwIwcauu5Yqa3WhJqO3nDM4VS2YRnwSFaB3Vwu
 Ro8=
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="100231246"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jan 2021 09:35:18 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 15 Jan 2021 09:35:02 -0700
Received: from tyr.hegelund-hansen.dk (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 15 Jan 2021 09:34:59 -0700
Message-ID: <8111bc9a89f0706f8fdc416b6bcc4be348f2c560.camel@microchip.com>
Subject: Re: [RFC PATCH v3 1/8] dt-bindings: net: sparx5: Add sparx5-switch
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
Date:   Fri, 15 Jan 2021 17:34:58 +0100
In-Reply-To: <20210115160409.GA1330811@robh.at.kernel.org>
References: <20210115135339.3127198-1-steen.hegelund@microchip.com>
         <20210115135339.3127198-2-steen.hegelund@microchip.com>
         <20210115160409.GA1330811@robh.at.kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Fri, 2021-01-15 at 10:04 -0600, Rob Herring wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you
> know the content is safe
> 
> On Fri, Jan 15, 2021 at 02:53:32PM +0100, Steen Hegelund wrote:
> > Document the Sparx5 switch device driver bindings
> > 
> > Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> > Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> > ---
> >  .../bindings/net/microchip,sparx5-switch.yaml | 211
> > ++++++++++++++++++
> >  1 file changed, 211 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
> > 
> > diff --git
> > a/Documentation/devicetree/bindings/net/microchip,sparx5-
> > switch.yaml
> > b/Documentation/devicetree/bindings/net/microchip,sparx5-
> > switch.yaml
> > new file mode 100644
> > index 000000000000..479a36874fe5
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/microchip,sparx5-
> > switch.yaml
> > @@ -0,0 +1,211 @@
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
> > +    items:
> > +      - const: devices
> > +      - const: gcb
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +    description: Interrupt used for reception of packets to the
> > CPU
> > +
> > +  mac-address:
> > +    maxItems: 1
> 
> The MAC address is 1 byte?

So this is a byte array?

    $ref: /schemas/types.yaml#/definitions/uint8-array
    items:
      - minItems: 6
        maxItems: 6


> 
> > +    description:
> > +      Specifies the MAC address that is used as the template for
> > the MAC
> > +      addresses assigned to the ports provided by the driver.  If
> > not provided
> > +      a randomly generated MAC address will be used.
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
> 
> Unit-addresses are hex.

Yes. I will change that...

> 
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
> > +          bandwidth:
> 
> Needs a vendor prefix.

OK, I will add that.

> 
> > +            maxItems: 1
> 
> Not an array. Drop.

OK - I am totally clear on the usage of maxItems.  This is only
intended for arrays, and for single values I should omit any
min/maxItems?

> 
> > +            $ref: /schemas/types.yaml#definitions/uint32
> > +            description: Specifies bandwidth in Mbit/s allocated
> > to the port.
> 
> 0-2^32 allowed?

How can I add limit?
I did not succeed using minimum/maximum (see below)...

> 
> > +
> > +          phys:
> > +            maxItems: 1
> > +            description:
> > +              phandle of a Ethernet SerDes PHY.  This defines
> > which SerDes
> > +              instance will handle the Ethernet traffic.
> > +
> > +          phy-handle:
> > +            maxItems: 1
> 
> Always a single item. (Note phys is not, so that's correct.)

So no maxItems for single instance items?

> 
> > +            description:
> > +               phandle of a Ethernet PHY.  This is optional and if
> > provided it
> > +               points to the cuPHY used by the Ethernet SerDes.
> > +
> > +          phy-mode:
> > +            maxItems: 1
> 
> Not an array. Drop.

Hmmm, I really misunderstood this...

> 
> I'd assume it's some subset of modes?
> 
> > +            description:
> > +              This specifies the interface used by the Ethernet
> > SerDes towards the
> > +              phy or SFP.
> > +
> > +          sfp:
> > +            maxItems: 1
> 
> 'sfp' is already defined as a single item. Drop

OK

> 
> > +            description:
> > +              phandle of an SFP.  This is optional and used when
> > not specifying
> > +              a cuPHY.  It points to the SFP node that describes
> > the SFP used by
> > +              the Ethernet SerDes.
> > +
> > +          managed:
> > +            maxItems: 1
> > +            description:
> > +              SFP management. This must be provided when
> > specifying an SFP.
> 
> 'managed: true' is sufficient. It's already described in
> ethernet-controller.yaml and the schema expresses the 2nd sentence.

OK.

> 
> > +
> > +          sd_sgpio:
> 
> Vendor specific? Then needs a vendor prefix.

Yes, I will add a prefix.

> 
> s/_/-/

Oops - yes.

> 
> > +            $ref: /schemas/types.yaml#/definitions/uint32
> > +            maxItems: 1
> 
> A uint32 is always 1 item. Drop.

OK

> 
> > +            description:
> > +              Index of the ports Signal Detect SGPIO in the set of
> > 384 SGPIOs
> > +              This is optional, and only needed if the default
> > used index is
> > +              is not correct.
> 
> Sounds like constraints?:
> 
> minimum: 0
> maximum: 383

I tried adding minimum and maximum, but I got an error from the
validation tool:

Ignoring, error in schema: properties: ethernet-ports:
patternProperties: ^port@[0-9]+$: properties: sd_sgpio: maximum

So what is the syntax for this?

> 
> > +
> > +        required:
> > +          - reg
> > +          - bandwidth
> > +          - phys
> > +          - phy-mode
> > +
> > +        oneOf:
> > +          - required:
> > +              - phy-handle
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
> > +          bandwidth = <1000>;
> > +          phys = <&serdes 13>;
> > +          phy-handle = <&phy0>;
> > +          phy-mode = "qsgmii";
> > +        };
> > +        /* ... */
> > +        /* Then the 25G interfaces */
> > +        port60: port@60 {
> > +          reg = <60>;
> > +          bandwidth = <25000>;
> > +          phys = <&serdes 29>;
> > +          phy-mode = "10gbase-r";
> > +          sfp = <&sfp_eth60>;
> > +          managed = "in-band-status";
> > +        };
> > +        port61: port@61 {
> > +          reg = <61>;
> > +          bandwidth = <25000>;
> > +          phys = <&serdes 30>;
> > +          phy-mode = "10gbase-r";
> > +          sfp = <&sfp_eth61>;
> > +          managed = "in-band-status";
> > +        };
> > +        port62: port@62 {
> > +          reg = <62>;
> > +          bandwidth = <25000>;
> > +          phys = <&serdes 31>;
> > +          phy-mode = "10gbase-r";
> > +          sfp = <&sfp_eth62>;
> > +          managed = "in-band-status";
> > +        };
> > +        port63: port@63 {
> > +          reg = <63>;
> > +          bandwidth = <25000>;
> > +          phys = <&serdes 32>;
> > +          phy-mode = "10gbase-r";
> > +          sfp = <&sfp_eth63>;
> > +          managed = "in-band-status";
> > +        };
> > +        /* Finally the Management interface */
> > +        port64: port@64 {
> > +          reg = <64>;
> > +          bandwidth = <1000>;
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

Thanks for your comments - I still have a bit of learning to do
clearly...

BR
Steen


