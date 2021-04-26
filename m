Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED1036AB58
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 06:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhDZEFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 00:05:52 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:33568 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhDZEFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 00:05:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1619409910; x=1650945910;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ew3Sf0HcQYvaKUezB+Bez+wWZZtVY9eZkJqX8iLPHSk=;
  b=YI4nKwmXvcBPTxdFG8YyiJH4OBXZFeD9cbHkAyr39zjDrSbhzdY/Y9aE
   XAmRTTIoJ6WR0NKoM/QkqSj237x+UIjIzB4dYYrqbHb1dyrRmeFZSWPKA
   /QRCqAu/HQAt6yoZw/Uj5IC/+xpg3dPUCsH4GabaItOT+nb/m3Gp2Q89p
   WAEDJE6TYNfGVUdQrPrA86c4gHzAE1lZ8KTD8+Y8GLqKBmnQF+GMecrap
   MKQwUUgF7cHVyMVXnZqiUd2M9h7Vt5MS3SiVIpL2JMt3bW34m5q69FJnl
   Vrum0yVH9BtYt6EJhqc4kOObaL9GDizZa3xqs5rws7axztkvMsuu44Il2
   Q==;
IronPort-SDR: ukytGFW2cTM/SUYZgx9ce5V6oE5UU7eEoq2yADhAqpdUZEfpDmrghr7an/vO02R+365qL8Zy+7
 aA4a1VEC8ia9mdIylWeffNtwkFp1IbdfSGSX95nLrfhNoi0Q8TyO+WLWpblUlSIbp2HjqC0VEY
 rmRYDlXUVkUc6mQ07W1ULNkld0X0E3EqY4ymTAFYe6fqRbBYJuW9nLiDubD1/sNa9yITlMWPm4
 OVjZArNG+ii2UeOxHKFHyE7jU/DHADn/O6VuIPx/pcIKtNY0CfQoFwNaUqKrYXySH2+gnODUXv
 uFk=
X-IronPort-AV: E=Sophos;i="5.82,251,1613458800"; 
   d="scan'208";a="118330410"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Apr 2021 21:05:09 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 25 Apr 2021 21:05:09 -0700
Received: from INB-LOAN0158.mchp-main.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Sun, 25 Apr 2021 21:05:04 -0700
Message-ID: <2f1e011ba458d493f34ea38c9e7e9753226ccab2.camel@microchip.com>
Subject: Re: [PATCH v2 net-next 1/9] dt-bindings: net: dsa: dt bindings for
 microchip lan937x
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Rob Herring <robh@kernel.org>
CC:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Mon, 26 Apr 2021 09:35:03 +0530
In-Reply-To: <20210422173844.GA3227277@robh.at.kernel.org>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
         <20210422094257.1641396-2-prasanna.vengateshan@microchip.com>
         <20210422173844.GA3227277@robh.at.kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-04-22 at 12:38 -0500, Rob Herring wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> On Thu, Apr 22, 2021 at 03:12:49PM +0530, Prasanna Vengateshan wrote:
> > Documentation in .yaml format and updates to the MAINTAINERS
> > Also 'make dt_binding_check' is passed
> > 
> > Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> > ---
> >  .../bindings/net/dsa/microchip,lan937x.yaml   | 142 ++++++++++++++++++
> >  MAINTAINERS                                   |   1 +
> >  2 files changed, 143 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> > 
> > diff --git
> > a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> > b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> > new file mode 100644
> > index 000000000000..22128a52d699
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> > @@ -0,0 +1,142 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/dsa/microchip,lan937x.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: LAN937x Ethernet Switch Series Tree Bindings
> > +
> > +maintainers:
> > +  - UNGLinuxDriver@microchip.com
> > +
> > +allOf:
> > +  - $ref: dsa.yaml#
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - microchip,lan9370
> > +      - microchip,lan9371
> > +      - microchip,lan9372
> > +      - microchip,lan9373
> > +      - microchip,lan9374
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  spi-max-frequency:
> > +    maximum: 50000000
> > +
> > +  reset-gpios:
> > +    description: Optional gpio specifier for a reset line
> > +    maxItems: 1
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +
> > +unevaluatedProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/gpio/gpio.h>
> > +
> > +    //Ethernet switch connected via spi to the host
> 
> If this is on SPI, why is it not under the spi bus node?
Thanks for reviewing the patch. I will move this comment to above the spi node.

> 
> > +    ethernet {
> > +      #address-cells = <1>;
> > +      #size-cells = <0>;
> > +
> > +      fixed-link {
> > +        speed = <1000>;
> > +        full-duplex;
> > +      };
> > +    };
> > +
> > +    spi {
> > +      #address-cells = <1>;
> > +      #size-cells = <0>;
> > +
> > +      lan9374: switch@0 {
> > +        compatible = "microchip,lan9374";
> > +        reg = <0>;
> > +
> > +        spi-max-frequency = <44000000>;
> > +
> > +        ethernet-ports {
> > +          #address-cells = <1>;
> > +          #size-cells = <0>;
> > +          port@0 {
> > +            reg = <0>;
> > +            label = "lan1";
> > +            phy-handle = <&t1phy0>;
> > +          };
> > +          port@1 {
> > +            reg = <1>;
> > +            label = "lan2";
> > +            phy-handle = <&t1phy1>;
> > +          };
> > +          port@2 {
> > +            reg = <2>;
> > +            label = "lan4";
> > +            phy-handle = <&t1phy2>;
> > +          };
> > +          port@3 {
> > +            reg = <3>;
> > +            label = "lan6";
> > +            phy-handle = <&t1phy3>;
> > +          };
> > +          port@4 {
> > +            reg = <4>;
> > +            phy-mode = "rgmii";
> > +            ethernet = <&ethernet>;
> 
> You are missing 'ethernet' label.
This is the cpu port and label is not used anywhere. i received this feedback in
last patch version. 

> 
> > 
> > +          };
> > +        };
> > +
> > +        mdio {
> > +          compatible = "microchip,lan937x-mdio";
> 
> You can just drop this to make the example pass. Or convert that binding
> to schema.
Okay, will remove in the next revision. Also i have received an alternate
suggestion in the other patch to avoid usage of compatible string.

> 
> > 
> > --
> > 2.27.0
> > 


