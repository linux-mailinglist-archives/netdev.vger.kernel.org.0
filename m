Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792312F8038
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 17:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbhAOQEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 11:04:54 -0500
Received: from mail-oi1-f177.google.com ([209.85.167.177]:39913 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbhAOQEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 11:04:53 -0500
Received: by mail-oi1-f177.google.com with SMTP id w124so10029523oia.6;
        Fri, 15 Jan 2021 08:04:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ShSnUe+9WTImJyQhOT5uKGsicu6ArTHKSvqTEazVYd8=;
        b=WYdiavOw66MkPMpIdzesRGzBE3cy7yoVdvHUNULdgX3gy49+DkIJIKrRQBgM+IpHGW
         +xfhy6tFcfH7x4UshIimk7/ltKDTGcISs14feMkNSrdFm60fAU2CG8RcTysXIDM/JQU8
         mK1Wd2SgGLd5JTCMFu32gaWtT8rL0uV2/aN2XS7rAvG9xB1dwqWmi5H1PCnUEXSTU1ni
         lSl1jppgEFa/BGErr+/4vTEGzae8v/Xdn33edeJ4WWi0zQIs1jlUR8CbaoQhPNNA44r3
         YpL4rxlc2qQLHFWLiI7cCLpI7Vl/3wl8ljvpIM/PVcP2rNuXdb4LEcy4eysmnWMGXM9n
         sYtQ==
X-Gm-Message-State: AOAM533VyKPnO6NppvjDy/nvqvcQbPRUKrP/8X4qPxdjNK1Fw7odx7xW
        lTjE+tzTtjjmCrbinUk1jlZAFcBMMQ==
X-Google-Smtp-Source: ABdhPJx55jPXIZn1uAJZRoWflJzeNMatDGVWwgmelR8lnL13eYi7gg8hX86jpxTEE5hHF5aO/oJKaw==
X-Received: by 2002:aca:4ad8:: with SMTP id x207mr6149985oia.173.1610726652236;
        Fri, 15 Jan 2021 08:04:12 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id h93sm1868318otb.29.2021.01.15.08.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 08:04:10 -0800 (PST)
Received: (nullmailer pid 1352888 invoked by uid 1000);
        Fri, 15 Jan 2021 16:04:09 -0000
Date:   Fri, 15 Jan 2021 10:04:09 -0600
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
Subject: Re: [RFC PATCH v3 1/8] dt-bindings: net: sparx5: Add sparx5-switch
 bindings
Message-ID: <20210115160409.GA1330811@robh.at.kernel.org>
References: <20210115135339.3127198-1-steen.hegelund@microchip.com>
 <20210115135339.3127198-2-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115135339.3127198-2-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 02:53:32PM +0100, Steen Hegelund wrote:
> Document the Sparx5 switch device driver bindings
> 
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> ---
>  .../bindings/net/microchip,sparx5-switch.yaml | 211 ++++++++++++++++++
>  1 file changed, 211 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
> new file mode 100644
> index 000000000000..479a36874fe5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
> @@ -0,0 +1,211 @@
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
> +    items:
> +      - const: devices
> +      - const: gcb
> +
> +  interrupts:
> +    maxItems: 1
> +    description: Interrupt used for reception of packets to the CPU
> +
> +  mac-address:
> +    maxItems: 1

The MAC address is 1 byte?

> +    description:
> +      Specifies the MAC address that is used as the template for the MAC
> +      addresses assigned to the ports provided by the driver.  If not provided
> +      a randomly generated MAC address will be used.
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

Unit-addresses are hex.

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
> +          bandwidth:

Needs a vendor prefix.

> +            maxItems: 1

Not an array. Drop.

> +            $ref: /schemas/types.yaml#definitions/uint32
> +            description: Specifies bandwidth in Mbit/s allocated to the port.

0-2^32 allowed?

> +
> +          phys:
> +            maxItems: 1
> +            description:
> +              phandle of a Ethernet SerDes PHY.  This defines which SerDes
> +              instance will handle the Ethernet traffic.
> +
> +          phy-handle:
> +            maxItems: 1

Always a single item. (Note phys is not, so that's correct.)

> +            description:
> +               phandle of a Ethernet PHY.  This is optional and if provided it
> +               points to the cuPHY used by the Ethernet SerDes.
> +
> +          phy-mode:
> +            maxItems: 1

Not an array. Drop.

I'd assume it's some subset of modes?

> +            description:
> +              This specifies the interface used by the Ethernet SerDes towards the
> +              phy or SFP.
> +
> +          sfp:
> +            maxItems: 1

'sfp' is already defined as a single item. Drop

> +            description:
> +              phandle of an SFP.  This is optional and used when not specifying
> +              a cuPHY.  It points to the SFP node that describes the SFP used by
> +              the Ethernet SerDes.
> +
> +          managed:
> +            maxItems: 1
> +            description:
> +              SFP management. This must be provided when specifying an SFP.

'managed: true' is sufficient. It's already described in 
ethernet-controller.yaml and the schema expresses the 2nd sentence.

> +
> +          sd_sgpio:

Vendor specific? Then needs a vendor prefix.

s/_/-/

> +            $ref: /schemas/types.yaml#/definitions/uint32
> +            maxItems: 1

A uint32 is always 1 item. Drop.

> +            description:
> +              Index of the ports Signal Detect SGPIO in the set of 384 SGPIOs
> +              This is optional, and only needed if the default used index is
> +              is not correct.

Sounds like constraints?:

minimum: 0
maximum: 383

> +
> +        required:
> +          - reg
> +          - bandwidth
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
> +          bandwidth = <1000>;
> +          phys = <&serdes 13>;
> +          phy-handle = <&phy0>;
> +          phy-mode = "qsgmii";
> +        };
> +        /* ... */
> +        /* Then the 25G interfaces */
> +        port60: port@60 {
> +          reg = <60>;
> +          bandwidth = <25000>;
> +          phys = <&serdes 29>;
> +          phy-mode = "10gbase-r";
> +          sfp = <&sfp_eth60>;
> +          managed = "in-band-status";
> +        };
> +        port61: port@61 {
> +          reg = <61>;
> +          bandwidth = <25000>;
> +          phys = <&serdes 30>;
> +          phy-mode = "10gbase-r";
> +          sfp = <&sfp_eth61>;
> +          managed = "in-band-status";
> +        };
> +        port62: port@62 {
> +          reg = <62>;
> +          bandwidth = <25000>;
> +          phys = <&serdes 31>;
> +          phy-mode = "10gbase-r";
> +          sfp = <&sfp_eth62>;
> +          managed = "in-band-status";
> +        };
> +        port63: port@63 {
> +          reg = <63>;
> +          bandwidth = <25000>;
> +          phys = <&serdes 32>;
> +          phy-mode = "10gbase-r";
> +          sfp = <&sfp_eth63>;
> +          managed = "in-band-status";
> +        };
> +        /* Finally the Management interface */
> +        port64: port@64 {
> +          reg = <64>;
> +          bandwidth = <1000>;
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
