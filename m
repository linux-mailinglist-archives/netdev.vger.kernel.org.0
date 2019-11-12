Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93BCDF9958
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 20:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfKLTHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 14:07:01 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:36487 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfKLTHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 14:07:01 -0500
Received: by mail-oi1-f193.google.com with SMTP id j7so15857209oib.3;
        Tue, 12 Nov 2019 11:06:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZbYRwN+7S2Z3fzFKODaK+X8nOcOEXmXKRrMF20np2Co=;
        b=Sx3fiOX4zyfIS8QXulExKMgrbEkuVeqNLtHvcr0R1g6GtjPccPi3LKZISIq8bk3gdr
         hHKKLDw7mN6FsaR29wH4BX3UJurUDPrPY0qDK2H6pxaYV9WBuN80j8ut4vCpX861Gr6c
         mIK2Rq1LfPyuqeG2rRpeFSK21Ky8ox8VKqJRvrGQuItn5TlN0lWLq9sgS24e/j6xPOSy
         9uH0+KHTbjCY3P3Vry986+voPxMwX0z08byyjThP/2et9RKRZ5nAytQqwfysmx9xwutz
         NfLJEJVvgDuKnWDoJN0binAAd61YEUB45Gf7ciqKfF7RBHqi0zugdX7DW6/f6LO+KgA3
         odIA==
X-Gm-Message-State: APjAAAV0WxdYKuVlPI3aDUCVsBE80ptXmsr0JFKbAkjRlv8C7VJI7AP9
        b+qOCZr563G0yuHqEXopzg==
X-Google-Smtp-Source: APXvYqwDPWEDB92G/WShgIif6U2Pe5q4wctY8VhSkbJ2uVywbq4zTrHFod+Pon6ga4Z2t5cbWdCwGw==
X-Received: by 2002:aca:fc0d:: with SMTP id a13mr432093oii.83.1573585618452;
        Tue, 12 Nov 2019 11:06:58 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id n5sm4351536oie.16.2019.11.12.11.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 11:06:57 -0800 (PST)
Date:   Tue, 12 Nov 2019 13:06:57 -0600
From:   Rob Herring <robh@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>, Sekhar Nori <nsekhar@ti.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v6 net-next 06/13] dt-bindings: net: ti: add new cpsw
 switch driver bindings
Message-ID: <20191112190657.GA5578@bogus>
References: <20191109151525.18651-1-grygorii.strashko@ti.com>
 <20191109151525.18651-7-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191109151525.18651-7-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 09, 2019 at 05:15:18PM +0200, Grygorii Strashko wrote:
> Add bindings for the new TI CPSW switch driver. Comparing to the legacy
> bindings (net/cpsw.txt):
> - ports definition follows DSA bindings (net/dsa/dsa.txt) and ports can be
> marked as "disabled" if not physically wired.
> - all deprecated properties dropped;
> - all legacy propertiies dropped which represent constant HW cpapbilities
> (cpdma_channels, ale_entries, bd_ram_size, mac_control, slaves,
> active_slave)
> - TI CPTS DT properties are reused as is, but grouped in "cpts" sub-node
> - TI Davinci MDIO DT bindings are reused as is, because Davinci MDIO is
> reused.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  .../bindings/net/ti,cpsw-switch.yaml          | 245 ++++++++++++++++++
>  1 file changed, 245 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
> new file mode 100644
> index 000000000000..afeb6a4f1ada
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
> @@ -0,0 +1,245 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/ti,cpsw-switch.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: TI SoC Ethernet Switch Controller (CPSW) Device Tree Bindings
> +
> +maintainers:
> +  - Grygorii Strashko <grygorii.strashko@ti.com>
> +  - Sekhar Nori <nsekhar@ti.com>
> +
> +description:
> +  The 3-port switch gigabit ethernet subsystem provides ethernet packet
> +  communication and can be configured as an ethernet switch. It provides the
> +  gigabit media independent interface (GMII),reduced gigabit media
> +  independent interface (RGMII), reduced media independent interface (RMII),
> +  the management data input output (MDIO) for physical layer device (PHY)
> +  management.
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - const: ti,cpsw-switch
> +      - items:
> +         - const: ti,am335x-cpsw-switch
> +         - const: ti,cpsw-switch
> +      - items:
> +        - const: ti,am4372-cpsw-switch
> +        - const: ti,cpsw-switch
> +      - items:
> +        - const: ti,dra7-cpsw-switch
> +        - const: ti,cpsw-switch
> +
> +  reg:
> +    maxItems: 1
> +    description:
> +       The physical base address and size of full the CPSW module IO range
> +
> +  ranges: true
> +
> +  clocks:
> +    maxItems: 1
> +    description: CPSW functional clock
> +
> +  clock-names:
> +    maxItems: 1
> +    items:
> +      - const: fck
> +
> +  interrupts:
> +    maxItems: 4

Implied by 'items' list.

> +    items:
> +      - description: RX_THRESH interrupt
> +      - description: RX interrupt
> +      - description: TX interrupt
> +      - description: MISC interrupt
> +
> +  interrupt-names:
> +    maxItems: 4

Implied by 'items' list.

> +    items:
> +      - const: "rx_thresh"
> +      - const: "rx"
> +      - const: "tx"
> +      - const: "misc"
> +
> +  pinctrl-names: true
> +
> +  syscon:
> +    $ref: /schemas/types.yaml#definitions/phandle
> +    maxItems: 1

Not an array, so not needed.

> +    description:
> +      Phandle to the system control device node which provides access to
> +      efuse IO range with MAC addresses
> +
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
> +          type: object
> +          minItems: 1
> +          maxItems: 2
> +          description: CPSW external ports
> +
> +          allOf:
> +            - $ref: ethernet-controller.yaml#
> +
> +          properties:
> +            reg:
> +              maxItems: 1
> +              enum: [1, 2]
> +              description: CPSW port number
> +
> +            phys:
> +              $ref: /schemas/types.yaml#definitions/phandle-array
> +              maxItems: 1
> +              description:  phandle on phy-gmii-sel PHY
> +
> +            label:
> +              $ref: /schemas/types.yaml#/definitions/string-array
> +              maxItems: 1
> +              description: label associated with this port
> +
> +            ti,dual-emac-pvid:
> +              $ref: /schemas/types.yaml#/definitions/uint32
> +              maxItems: 1
> +              minimum: 1
> +              maximum: 1024
> +              description:
> +                Specifies default PORT VID to be used to segregate
> +                ports. Default value - CPSW port number.
> +
> +          required:
> +            - reg
> +            - phys
> +
> +  mdio:
> +    type: object
> +    allOf:
> +      - $ref: "ti,davinci-mdio.yaml#"
> +    description:
> +      CPSW MDIO bus.
> +
> +  cpts:
> +    type: object
> +    description:
> +      The Common Platform Time Sync (CPTS) module
> +
> +    properties:
> +      clocks:
> +        maxItems: 1
> +        description: CPTS reference clock
> +
> +      clock-names:
> +        maxItems: 1
> +        items:
> +          - const: cpts
> +
> +      cpts_clock_mult:
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        maxItems: 1

Not an array, so not needed.

Is there a set or range of values you can define?

> +        description:
> +          Numerator to convert input clock ticks into ns
> +
> +      cpts_clock_shift:
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        maxItems: 1

Same comments here.

> +        description:
> +          Denominator to convert input clock ticks into ns.
> +          Mult and shift will be calculated basing on CPTS rftclk frequency if
> +          both cpts_clock_shift and cpts_clock_mult properties are not provided.
> +
> +    required:
> +      - clocks
> +      - clock-names
> +
> +required:
> +  - compatible
> +  - reg
> +  - ranges
> +  - clocks
> +  - clock-names
> +  - interrupts
> +  - interrupt-names
> +  - '#address-cells'
> +  - '#size-cells'
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/clock/dra7.h>
> +
> +    mac_sw: switch@0 {
> +        compatible = "ti,dra7-cpsw-switch","ti,cpsw-switch";
> +        reg = <0x0 0x4000>;
> +        ranges = <0 0 0x4000>;
> +        clocks = <&gmac_main_clk>;
> +        clock-names = "fck";
> +        #address-cells = <1>;
> +        #size-cells = <1>;
> +        syscon = <&scm_conf>;
> +        inctrl-names = "default", "sleep";
> +
> +        interrupts = <GIC_SPI 334 IRQ_TYPE_LEVEL_HIGH>,
> +                     <GIC_SPI 335 IRQ_TYPE_LEVEL_HIGH>,
> +                     <GIC_SPI 336 IRQ_TYPE_LEVEL_HIGH>,
> +                     <GIC_SPI 337 IRQ_TYPE_LEVEL_HIGH>;
> +        interrupt-names = "rx_thresh", "rx", "tx", "misc";
> +
> +        ethernet-ports {
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +
> +                cpsw_port1: port@1 {
> +                        reg = <1>;
> +                        label = "port1";
> +                        mac-address = [ 00 00 00 00 00 00 ];
> +                        phys = <&phy_gmii_sel 1>;
> +                        phy-handle = <&ethphy0_sw>;
> +                        phy-mode = "rgmii";
> +                        ti,dual_emac_pvid = <1>;
> +                };
> +
> +                cpsw_port2: port@2 {
> +                        reg = <2>;
> +                        label = "wan";
> +                        mac-address = [ 00 00 00 00 00 00 ];
> +                        phys = <&phy_gmii_sel 2>;
> +                        phy-handle = <&ethphy1_sw>;
> +                        phy-mode = "rgmii";
> +                        ti,dual_emac_pvid = <2>;
> +                };
> +        };
> +
> +        davinci_mdio_sw: mdio@1000 {
> +                compatible = "ti,cpsw-mdio","ti,davinci_mdio";
> +                reg = <0x1000 0x100>;
> +                clocks = <&gmac_clkctrl DRA7_GMAC_GMAC_CLKCTRL 0>;
> +                clock-names = "fck";
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +                bus_freq = <1000000>;
> +
> +                ethphy0_sw: ethernet-phy@0 {
> +                        reg = <0>;
> +                };
> +
> +                ethphy1_sw: ethernet-phy@1 {
> +                        reg = <41>;

make dt_binding_check fails:

/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: 
mdio@1000: ethernet-phy@1:reg:0:0: 41 is greater than the maximum of 31
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: 
ethernet-phy@1: reg:0:0: 41 is greater than the maximum of 31

> +                };
> +        };
> +
> +        cpts {
> +                clocks = <&gmac_clkctrl DRA7_GMAC_GMAC_CLKCTRL 25>;
> +                clock-names = "cpts";
> +        };
> +    };
> -- 
> 2.17.1
> 
