Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78BA46521C
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 16:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351160AbhLAPzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 10:55:54 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:59132 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351181AbhLAPzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 10:55:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638373943; x=1669909943;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8aUAYkpSMCeWdf7ablqR06ST4zL7CRWspHdgQt2snTk=;
  b=Ew3rRoz7K8bsC68Lp/cmNiGpLdmgy0PRw7PTHqi3u8hsUZLVm5q1zY8+
   S0X5ap9fNsGnue9PCfRY6uELjU9qX9MMjlmIJ+oVw0ecsYJ5PmbSPPLXS
   8X62e3yx5IGlQZMkomE+URT99u8KyEr9JAUFYe0HIdKrrFGDNEw42J+dz
   MaFzzhSb1vtM5p64631KOG5vEN0dtDTrjp14ymOYED6+GZL7BIcFh0I2w
   1bEJOD7wVmE6jOiJZDEnX6GsfU9/4DuxiSyTxcN2JcIDqZoXW1mLw38HY
   nKwhfmFjLqdzA5ikzOqSEgHqLj9qCua92TCQrxRd1MHF6RH6L9POKg+kA
   g==;
IronPort-SDR: VIbyQ/zEoNEXoXJxFlXMv4/N45wyi5hA7qymNOV5WcSYRjC6N8jRN8uyNy96k40Rr2UpxS1F4M
 x/o6AxwOthPFQpCGKOtNr6YClfBmk5D8A+WWSi9SY5Ar0ldLqmw2sPjX/xrHHgCJasUl61+5Ys
 xKhtZMboYgO7oateDBpgbaOpVqbc7xEN0E41HTkfhTGbW2B1qcOloBmLOEg6mMEBEqQ54/mPzX
 YySiN2FOJOoLG/5hzc09uAZyPCEfi0hog6KYdaYzt2yS5kSVjBi98opOlrJE2xGVMI5Z/gX+6C
 GMHpi4QhhhBu9OABg1kpfyHY
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="140888894"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Dec 2021 08:52:18 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 1 Dec 2021 08:52:17 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Wed, 1 Dec 2021 08:52:17 -0700
Date:   Wed, 1 Dec 2021 16:54:11 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Rob Herring <robh@kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v5 1/6] dt-bindings: net: lan966x: Add
 lan966x-switch bindings
Message-ID: <20211201155411.cwwftmnbku6slspp@soft-dev3-1.localhost>
References: <20211129124359.4069432-1-horatiu.vultur@microchip.com>
 <20211129124359.4069432-2-horatiu.vultur@microchip.com>
 <YaaIMizLkPG81gAO@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YaaIMizLkPG81gAO@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/30/2021 14:23, Rob Herring wrote:

Hi Rob,

> 
> > +    items:
> > +      - const: switch
> > +      - const: phy
> > +
> > +  ethernet-ports:
> > +    type: object
> 
>        additionalProperties: false

Yes, I will add then. But then I will need to add also:

properties:
  '#address-cells':
    const: 1
  '#size-cells':
    const: 0

> 
> > +    patternProperties:
> > +      "^port@[0-9a-f]+$":
> > +        type: object
> > +
> > +        allOf:
> 
> Don't need allOf here.
> 
> > +          - $ref: "http://devicetree.org/schemas/net/ethernet-controller.yaml#"
> 
> Drop 'http://devicetree.org'. (If you copied that from somewhere, please
> fix them too.)
> 
>            unevaluatedProperties: false

I will fix this and I would send also a patch for dsa.yaml.

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
> > +            enum:
> > +              - gmii
> > +              - sgmii
> > +              - qsgmii
> > +              - 1000base-x
> > +              - 2500base-x
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
