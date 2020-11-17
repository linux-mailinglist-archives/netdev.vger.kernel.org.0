Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4632B5A9A
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 08:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgKQH4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 02:56:41 -0500
Received: from mailout09.rmx.de ([94.199.88.74]:51416 "EHLO mailout09.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726511AbgKQH4l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 02:56:41 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout09.rmx.de (Postfix) with ESMTPS id 4CZyv72fsqzbgVh;
        Tue, 17 Nov 2020 08:56:35 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CZytk4lHHz2xbk;
        Tue, 17 Nov 2020 08:56:14 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.122) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 17 Nov
 2020 08:55:11 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Rob Herring <robh@kernel.org>
CC:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Woojung Huh" <woojung.huh@microchip.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Marek Vasut <marex@denx.de>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        Paul Barker <pbarker@konsulko.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v2 01/11] dt-bindings: net: dsa: convert ksz bindings document to yaml
Date:   Tue, 17 Nov 2020 08:55:10 +0100
Message-ID: <7522726.5jB9HK481P@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201116143720.GA1611573@bogus>
References: <20201112153537.22383-1-ceggers@arri.de> <20201112153537.22383-2-ceggers@arri.de> <20201116143720.GA1611573@bogus>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.122]
X-RMX-ID: 20201117-085616-4CZytk4lHHz2xbk-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, 16 November 2020, 15:37:20 CET, Rob Herring wrote:
> On Thu, 12 Nov 2020 16:35:27 +0100, Christian Eggers wrote:
> > Convert the bindings document for Microchip KSZ Series Ethernet switches
> > from txt to yaml.
> > 
> > Signed-off-by: Christian Eggers <ceggers@arri.de>
> > ---
> > 
> >  .../devicetree/bindings/net/dsa/ksz.txt       | 125 ---------------
> >  .../bindings/net/dsa/microchip,ksz.yaml       | 150 ++++++++++++++++++
> >  MAINTAINERS                                   |   2 +-
> >  3 files changed, 151 insertions(+), 126 deletions(-)
> >  delete mode 100644 Documentation/devicetree/bindings/net/dsa/ksz.txt
> >  create mode 100644
> >  Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> My bot found errors running 'make dt_binding_check' on your patch:
> 
> yamllint warnings/errors:
> 
> dtschema/dtc warnings/errors:
> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa
> /microchip,ksz.yaml: 'oneOf' conditional failed, one must be fixed:
> 'unevaluatedProperties' is a required property
> 	'additionalProperties' is a required property
> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa
> /microchip,ksz.yaml: ignoring, error in schema: warning: no schema found in
> file: ./Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> 
> 
> See https://patchwork.ozlabs.org/patch/1399036
> 
> The base for the patch is generally the last rc1. Any dependencies
> should be noted.
> 
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to
> date:
> 
> pip3 install dtschema --upgrade
> 
> Please check and re-submit.

with the latest dtschema I get further warnings:

/home/.../build-net-next/Documentation/devicetree/bindings/net/dsa/microchip,ksz.example.dt.yaml: switch@0: 'ethernet-ports', 'reg', 'spi-cpha', 'spi-cpol', 'spi-max-frequency' do not match any of the regexes: 'pinctrl-[0-9]+'
	From schema: /home/.../Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
/home/.../build-net-next/Documentation/devicetree/bindings/net/dsa/microchip,ksz.example.dt.yaml: switch@1: 'ethernet-ports', 'reg', 'spi-cpha', 'spi-cpol', 'spi-max-frequency' do not match any of the regexes: 'pinctrl-[0-9]+'
	From schema: /home/.../Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml

Which schema requires the regex 'pinctrl-[0-9]+'? I have tried to add pinctrl-0
properties to the switch@0 and switch@1 nodes, but that didn't help.

Current version of microchip,ksz.yaml is below.

regards
Christian


# SPDX-License-Identifier: GPL-2.0-only
%YAML 1.2
---
$id: http://devicetree.org/schemas/net/dsa/microchip,ksz.yaml#
$schema: http://devicetree.org/meta-schemas/core.yaml#

title: Microchip KSZ Series Ethernet switches

allOf:
  - $ref: dsa.yaml#

maintainers:
  - Marek Vasut <marex@denx.de>
  - Woojung Huh <Woojung.Huh@microchip.com>

properties:
  # See Documentation/devicetree/bindings/net/dsa/dsa.yaml for a list of additional
  # required and optional properties.
  compatible:
    enum:
      - microchip,ksz8765
      - microchip,ksz8794
      - microchip,ksz8795
      - microchip,ksz9477
      - microchip,ksz9897
      - microchip,ksz9896
      - microchip,ksz9567
      - microchip,ksz8565
      - microchip,ksz9893
      - microchip,ksz9563
      - microchip,ksz8563

  reset-gpios:
    description:
      Should be a gpio specifier for a reset line.
    maxItems: 1

  interrupts:
    description:
      Interrupt specifier for the INTRP_N line from the device.
    maxItems: 1

  microchip,synclko-125:
    $ref: /schemas/types.yaml#/definitions/flag
    description:
      Set if the output SYNCLKO frequency should be set to 125MHz instead of 25MHz.

required:
  - compatible
  - reg

additionalProperties: false

examples:
  - |
    #include <dt-bindings/gpio/gpio.h>
    #include <dt-bindings/interrupt-controller/irq.h>

    // Ethernet switch connected via SPI to the host, CPU port wired to eth0:
    eth0 {
        fixed-link {
            speed = <1000>;
            full-duplex;
        };
    };

    spi0 {
        #address-cells = <1>;
        #size-cells = <0>;

        pinctrl-0 = <&pinctrl_spi_ksz>;
        cs-gpios = <&pioC 25 0>;
        id = <1>;

        ksz9477: switch@0 {
            compatible = "microchip,ksz9477";
            reg = <0>;
            reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
            interrupts-extended = <&gpio5 1 IRQ_TYPE_LEVEL_LOW>;  /* INTRP_N line */

            spi-max-frequency = <44000000>;
            spi-cpha;
            spi-cpol;

            ethernet-ports {
                #address-cells = <1>;
                #size-cells = <0>;
                port@0 {
                    reg = <0>;
                    label = "lan1";
                };
                port@1 {
                    reg = <1>;
                    label = "lan2";
                };
                port@2 {
                    reg = <2>;
                    label = "lan3";
                };
                port@3 {
                    reg = <3>;
                    label = "lan4";
                };
                port@4 {
                    reg = <4>;
                    label = "lan5";
                };
                port@5 {
                    reg = <5>;
                    label = "cpu";
                    ethernet = <&eth0>;
                    fixed-link {
                        speed = <1000>;
                        full-duplex;
                    };
                };
            };
        };

        ksz8565: switch@1 {
            compatible = "microchip,ksz8565";
            reg = <1>;

            spi-max-frequency = <44000000>;
            spi-cpha;
            spi-cpol;

            ethernet-ports {
                #address-cells = <1>;
                #size-cells = <0>;
                port@0 {
                    reg = <0>;
                    label = "lan1";
                };
                port@1 {
                    reg = <1>;
                    label = "lan2";
                };
                port@2 {
                    reg = <2>;
                    label = "lan3";
                };
                port@3 {
                    reg = <3>;
                    label = "lan4";
                };
                port@6 {
                    reg = <6>;
                    label = "cpu";
                    ethernet = <&eth0>;
                    fixed-link {
                        speed = <1000>;
                        full-duplex;
                    };
                };
            };
        };
    };
...



