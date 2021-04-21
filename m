Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20C636754A
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 00:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343580AbhDUWos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 18:44:48 -0400
Received: from mail-oo1-f49.google.com ([209.85.161.49]:43541 "EHLO
        mail-oo1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235004AbhDUWor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 18:44:47 -0400
Received: by mail-oo1-f49.google.com with SMTP id c84-20020a4a4f570000b02901e9af00ac1bso3337850oob.10;
        Wed, 21 Apr 2021 15:44:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ccwTC3neOX0xiorVPiV2PK1AQuSwP8rpi8GyFurEX0M=;
        b=WC3ptBAfqlpAhKNsPPRr/vb4ZEjXrS17PrTThE52cuahMwCrUowTc6ZhTNzxN8us7K
         /DxTC55raTMk2KcNhwezdcgfcej/5/1wQH6SEy6RccGqxeLcADw4nia+b9XeibETzsJi
         XUe5vKyvl9+UN2BvnLkH0we7j5Z4Xse4eiKCiB0HXwNaXHkgYCyaD1+4kLfWPl/6s+ob
         7ysdoDTNJ0mCgHmjXkmjATnUVrbhYJEJ34NofeDwE9QNEDDY7SGOoFcE9wfOcmylzMHu
         s3iFIX9je1P8OGHX5nsvHTuRiGH9WezGM20RsaRaY3Gs/hX057RQtw+cWMXhO9skbz6b
         nPEQ==
X-Gm-Message-State: AOAM532dw/L9m1JH5B4Q+zBPJzzfPm9mltR08znC1aLDV6JNBDeaVVeK
        ZJ9n2uwlWIgSwscV4TKFBA==
X-Google-Smtp-Source: ABdhPJyptlu2eKJffP1adI8PWAHI0oQ2kI/lX0QBV5TF1DXpD7yX2ZK2FNDEB5Fpmo2dNXzjKCSsrg==
X-Received: by 2002:a05:6820:381:: with SMTP id r1mr132243ooj.79.1619045053823;
        Wed, 21 Apr 2021 15:44:13 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id d12sm223231ook.1.2021.04.21.15.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 15:44:12 -0700 (PDT)
Received: (nullmailer pid 1750431 invoked by uid 1000);
        Wed, 21 Apr 2021 22:44:11 -0000
Date:   Wed, 21 Apr 2021 17:44:11 -0500
From:   Rob Herring <robh@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Simon Horman <simon.horman@netronome.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>
Subject: Re: [PATCH net-next 01/10] dt-bindings: net: sparx5: Add
 sparx5-switch bindings
Message-ID: <20210421224411.GA1746146@robh.at.kernel.org>
References: <20210416131657.3151464-1-steen.hegelund@microchip.com>
 <20210416131657.3151464-2-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416131657.3151464-2-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 03:16:48PM +0200, Steen Hegelund wrote:
> Document the Sparx5 switch device driver bindings
> 
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
> ---
>  .../bindings/net/microchip,sparx5-switch.yaml | 227 ++++++++++++++++++
>  1 file changed, 227 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
> new file mode 100644
> index 000000000000..2eeb5230d8c8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
> @@ -0,0 +1,227 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/microchip,sparx5-switch.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Microchip Sparx5 Ethernet switch controller
> +
> +maintainers:
> +  - Steen Hegelund <steen.hegelund@microchip.com>
> +  - Lars Povlsen <lars.povlsen@microchip.com>
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
> +    minItems: 3

Drop, that's the default implied by 'items' length.

Otherwise,

Reviewed-by: Rob Herring <robh@kernel.org>

> +    items:
> +      - description: cpu target
> +      - description: devices target
> +      - description: general control block target
> +
> +  reg-names:
> +    items:
> +      - const: cpu
> +      - const: devices
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
> +
> +  reset-names:
> +    items:
> +      - const: switch
> +
> +  mac-address: true
> +
> +  ethernet-ports:
> +    type: object
> +    patternProperties:
> +      "^port@[0-9a-f]+$":
> +        type: object
> +
> +        properties:
> +          '#address-cells':
> +            const: 1
> +          '#size-cells':
> +            const: 0
> +
> +          reg:
> +            description: Switch port number
> +
> +          phys:
> +            maxItems: 1
> +            description:
> +              phandle of a Ethernet SerDes PHY.  This defines which SerDes
> +              instance will handle the Ethernet traffic.
> +
> +          phy-mode:
> +            description:
> +              This specifies the interface used by the Ethernet SerDes towards
> +              the PHY or SFP.
> +
> +          microchip,bandwidth:
> +            description: Specifies bandwidth in Mbit/s allocated to the port.
> +            $ref: "/schemas/types.yaml#/definitions/uint32"
> +            maximum: 25000
> +
> +          phy-handle:
> +            description:
> +              phandle of a Ethernet PHY.  This is optional and if provided it
> +              points to the cuPHY used by the Ethernet SerDes.
> +
> +          sfp:
> +            description:
> +              phandle of an SFP.  This is optional and used when not specifying
> +              a cuPHY.  It points to the SFP node that describes the SFP used by
> +              the Ethernet SerDes.
> +
> +          managed: true
> +
> +          microchip,sd-sgpio:
> +            description:
> +              Index of the ports Signal Detect SGPIO in the set of 384 SGPIOs
> +              This is optional, and only needed if the default used index is
> +              is not correct.
> +            $ref: "/schemas/types.yaml#/definitions/uint32"
> +            minimum: 0
> +            maximum: 383
> +
> +        required:
> +          - reg
> +          - phys
> +          - phy-mode
> +          - microchip,bandwidth
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
> +    switch: switch@600000000 {
> +      compatible = "microchip,sparx5-switch";
> +      reg =  <0 0x401000>,
> +             <0x10004000 0x7fc000>,
> +             <0x11010000 0xaf0000>;
> +      reg-names = "cpu", "devices", "gcb";
> +      interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
> +      interrupt-names = "xtr";
> +      resets = <&reset 0>;
> +      reset-names = "switch";
> +      ethernet-ports {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        port0: port@0 {
> +          reg = <0>;
> +          microchip,bandwidth = <1000>;
> +          phys = <&serdes 13>;
> +          phy-handle = <&phy0>;
> +          phy-mode = "qsgmii";
> +        };
> +        /* ... */
> +        /* Then the 25G interfaces */
> +        port60: port@60 {
> +          reg = <60>;
> +          microchip,bandwidth = <25000>;
> +          phys = <&serdes 29>;
> +          phy-mode = "10gbase-r";
> +          sfp = <&sfp_eth60>;
> +          managed = "in-band-status";
> +          microchip,sd-sgpio = <365>;
> +        };
> +        port61: port@61 {
> +          reg = <61>;
> +          microchip,bandwidth = <25000>;
> +          phys = <&serdes 30>;
> +          phy-mode = "10gbase-r";
> +          sfp = <&sfp_eth61>;
> +          managed = "in-band-status";
> +          microchip,sd-sgpio = <369>;
> +        };
> +        port62: port@62 {
> +          reg = <62>;
> +          microchip,bandwidth = <25000>;
> +          phys = <&serdes 31>;
> +          phy-mode = "10gbase-r";
> +          sfp = <&sfp_eth62>;
> +          managed = "in-band-status";
> +          microchip,sd-sgpio = <373>;
> +        };
> +        port63: port@63 {
> +          reg = <63>;
> +          microchip,bandwidth = <25000>;
> +          phys = <&serdes 32>;
> +          phy-mode = "10gbase-r";
> +          sfp = <&sfp_eth63>;
> +          managed = "in-band-status";
> +          microchip,sd-sgpio = <377>;
> +        };
> +        /* Finally the Management interface */
> +        port64: port@64 {
> +          reg = <64>;
> +          microchip,bandwidth = <1000>;
> +          phys = <&serdes 0>;
> +          phy-handle = <&phy64>;
> +          phy-mode = "sgmii";
> +          mac-address = [ 00 00 00 01 02 03 ];
> +        };
> +      };
> +    };
> +
> +...
> +#  vim: set ts=2 sw=2 sts=2 tw=80 et cc=80 ft=yaml :
> -- 
> 2.31.1
> 
