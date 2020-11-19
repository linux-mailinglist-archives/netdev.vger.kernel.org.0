Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F522B9BF3
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 21:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgKSUYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 15:24:08 -0500
Received: from mailout04.rmx.de ([94.199.90.94]:58237 "EHLO mailout04.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgKSUYH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 15:24:07 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout04.rmx.de (Postfix) with ESMTPS id 4CcWNg2QjBz3qwyG;
        Thu, 19 Nov 2020 21:24:03 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CcWNQ4tzJz2xD8;
        Thu, 19 Nov 2020 21:23:50 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.21) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 19 Nov
 2020 21:22:49 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Rob Herring <robh@kernel.org>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 01/12] dt-bindings: net: dsa: convert ksz bindings document to yaml
Date:   Thu, 19 Nov 2020 21:22:48 +0100
Message-ID: <7240026.1JJ2HCEDZb@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201119134801.GB3149565@bogus>
References: <20201118203013.5077-1-ceggers@arri.de> <20201118203013.5077-2-ceggers@arri.de> <20201119134801.GB3149565@bogus>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.21]
X-RMX-ID: 20201119-212350-4CcWNQ4tzJz2xD8-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, 19 November 2020, 14:48:01 CET, Rob Herring wrote:
> On Wed, Nov 18, 2020 at 09:30:02PM +0100, Christian Eggers wrote:
> > Convert the bindings document for Microchip KSZ Series Ethernet switches
> > from txt to yaml.
> > 
> > Signed-off-by: Christian Eggers <ceggers@arri.de>
> > ---
> > 
> >  .../devicetree/bindings/net/dsa/ksz.txt       | 125 --------------
> >  .../bindings/net/dsa/microchip,ksz.yaml       | 152 ++++++++++++++++++
> >  MAINTAINERS                                   |   2 +-
> >  3 files changed, 153 insertions(+), 126 deletions(-)
> >  delete mode 100644 Documentation/devicetree/bindings/net/dsa/ksz.txt
> >  create mode 100644
> >  Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml> 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/ksz.txt
> > b/Documentation/devicetree/bindings/net/dsa/ksz.txt deleted file mode
> > 100644
> > index 95e91e84151c..000000000000
> > --- a/Documentation/devicetree/bindings/net/dsa/ksz.txt
> > +++ /dev/null
>> [...]
> > diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> > b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml new file
> > mode 100644
> > index 000000000000..010adb09a68f
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> > @@ -0,0 +1,152 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/dsa/microchip,ksz.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Microchip KSZ Series Ethernet switches
> > +
> > +allOf:
> > +  - $ref: dsa.yaml#
> 
> Move this after 'maintainers'.
changed for v4

> 
> > +
> > +maintainers:
> > +  - Marek Vasut <marex@denx.de>
> > +  - Woojung Huh <Woojung.Huh@microchip.com>
> > +
> > +properties:
> > +  # See Documentation/devicetree/bindings/net/dsa/dsa.yaml for a list of
> > additional +  # required and optional properties.
> > +  compatible:
> > +    enum:
> > +      - microchip,ksz8765
> > +      - microchip,ksz8794
> > +      - microchip,ksz8795
> > +      - microchip,ksz9477
> > +      - microchip,ksz9897
> > +      - microchip,ksz9896
> > +      - microchip,ksz9567
> > +      - microchip,ksz8565
> > +      - microchip,ksz9893
> > +      - microchip,ksz9563
> > +      - microchip,ksz8563
> > +
> > +  reset-gpios:
> > +    description:
> > +      Should be a gpio specifier for a reset line.
> > +    maxItems: 1
> > +
> > +  microchip,synclko-125:
> > +    $ref: /schemas/types.yaml#/definitions/flag
> > +    description:
> > +      Set if the output SYNCLKO frequency should be set to 125MHz instead
> > of 25MHz. +
> > +required:
> > +  - compatible
> > +  - reg
> > +
> > +additionalProperties: false
> 
> You need to use unevaluatedProperties instead.
dt_binding_check is happy now

> 
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/gpio/gpio.h>
> > +
> > +    // Ethernet switch connected via SPI to the host, CPU port wired to
> > eth0: +    eth0 {
> > +        fixed-link {
> > +            speed = <1000>;
> > +            full-duplex;
> > +        };
> > +    };
> > +
> > +    spi0 {
> > +        #address-cells = <1>;
> > +        #size-cells = <0>;
> > +
> > +        pinctrl-0 = <&pinctrl_spi_ksz>;
> > +        cs-gpios = <&pioC 25 0>;
> > +        id = <1>;
> > +
> > +        ksz9477: switch@0 {
> > +            compatible = "microchip,ksz9477";
> > +            reg = <0>;
> > +            reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
> > +
> > +            spi-max-frequency = <44000000>;
> > +            spi-cpha;
> > +            spi-cpol;
> 
> Are these 2 optional or required? Being optional is rare as most
> devices support 1 mode, but not unheard of.
From the data sheet:
"Input data on SDI is latched on the rising edge of serial clock SCL. Output
data on SDO is clocked on the falling edge of SCL." Clock has inverted 
polarity in all diagrams.

> In general, you shouldn't
> need them as the driver should know how to configure the mode if the h/w
> is fixed.
I will check this in the driver. This also requires updating
at91-sama5d2_icp.dts. I personally use I2C instead of SPI on this chip.

> > [...]



