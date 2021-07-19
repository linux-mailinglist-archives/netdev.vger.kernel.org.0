Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5BE3CF03A
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 01:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377642AbhGSXGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 19:06:49 -0400
Received: from mail-il1-f181.google.com ([209.85.166.181]:40562 "EHLO
        mail-il1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391985AbhGSWFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 18:05:05 -0400
Received: by mail-il1-f181.google.com with SMTP id b14so17496771ilf.7;
        Mon, 19 Jul 2021 15:45:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UgKCluu06sIWq4HIhRmQcnhaz8MJ1fMfRsS8AIHxuDI=;
        b=o2VEunsOiKD/3TiPQTPkk71BnNUjtdeguoRgJvc2JVsDGHj+uk+0SDCLxVxaoVqkGG
         UBNtn7MsRyUBY+6FidXcjmwRdRNIyftLQfqd3dGfI10EwpoMmc+5i041KwtLqZu1qME5
         2CEF1lv206DPxihQim26hIF5UYZcsYcgoUbZW6u7vRgC7iXb+/CqGwJQf14/dzKWMYww
         33QOJuhIlZxWPpAtQ/zXVUz6ahIwzIbmvD7qjR0FdQ7mNC6H618diOSz4EdOYE8mxNFz
         ALfTN+1Exyz7IkjIqvdf+fQwnIw6WnPnlodUte+sMwDyoB+XOzzre3NoF0YA3zQbEmT1
         1gjg==
X-Gm-Message-State: AOAM531LNegaLgx6rryiIvSrZS9JC9l8RMsyVQ5Gtn9S3HZTVC27YVO5
        nefgqDxsMOd2hC+C7dI1/g==
X-Google-Smtp-Source: ABdhPJw4eWpTeuNqpoZmxkhzAEy06fVdvVfXKlIBCx5V165VInggDLf7EHWiqjP2L00vk9/1IqIxgg==
X-Received: by 2002:a92:d305:: with SMTP id x5mr19164682ila.150.1626734712817;
        Mon, 19 Jul 2021 15:45:12 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id p19sm11320032iob.7.2021.07.19.15.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 15:45:12 -0700 (PDT)
Received: (nullmailer pid 2763300 invoked by uid 1000);
        Mon, 19 Jul 2021 22:45:07 -0000
Date:   Mon, 19 Jul 2021 16:45:07 -0600
From:   Rob Herring <robh@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com,
        bruno.thomsen@gmail.com, linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V1 1/3] dt-bindings: net: fec: convert fsl,*fec bindings
 to yaml
Message-ID: <20210719224507.GA2740161@robh.at.kernel.org>
References: <20210716102911.23694-1-qiangqing.zhang@nxp.com>
 <20210716102911.23694-2-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716102911.23694-2-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 06:29:09PM +0800, Joakim Zhang wrote:
> In order to automate the verification of DT nodes convert fsl-fec.txt to
> fsl,fec.yaml, and pass binding check with below command.
> 
> $ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- dt_binding_check DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/fsl,fec.yaml
>   DTEX    Documentation/devicetree/bindings/net/fsl,fec.example.dts
>   DTC     Documentation/devicetree/bindings/net/fsl,fec.example.dt.yaml
>   CHECK   Documentation/devicetree/bindings/net/fsl,fec.example.dt.yaml
> 
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  .../devicetree/bindings/net/fsl,fec.yaml      | 213 ++++++++++++++++++
>  .../devicetree/bindings/net/fsl-fec.txt       |  95 --------
>  2 files changed, 213 insertions(+), 95 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/fsl,fec.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/fsl-fec.txt

Since the networking maintainers can't wait for actual binding reviews, 
you get to send a follow-up patch...

> 
> diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
> new file mode 100644
> index 000000000000..7fa11f6622b1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
> @@ -0,0 +1,213 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/fsl,fec.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Freescale Fast Ethernet Controller (FEC)
> +
> +maintainers:
> +  - Joakim Zhang <qiangqing.zhang@nxp.com>
> +
> +allOf:
> +  - $ref: ethernet-controller.yaml#
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - enum:
> +          - fsl,imx25-fec
> +          - fsl,imx27-fec
> +          - fsl,imx28-fec
> +          - fsl,imx6q-fec
> +          - fsl,mvf600-fec
> +      - items:
> +          - enum:
> +              - fsl,imx53-fec
> +              - fsl,imx6sl-fec
> +          - const: fsl,imx25-fec
> +      - items:
> +          - enum:
> +              - fsl,imx35-fec
> +              - fsl,imx51-fec
> +          - const: fsl,imx27-fec
> +      - items:
> +          - enum:
> +              - fsl,imx6ul-fec
> +              - fsl,imx6sx-fec
> +          - const: fsl,imx6q-fec
> +      - items:
> +          - enum:
> +              - fsl,imx7d-fec
> +          - const: fsl,imx6sx-fec
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    minItems: 1
> +    maxItems: 4
> +
> +  interrupt-names:
> +    description:
> +      Names of the interrupts listed in interrupts property in the same order.
> +      The defaults if not specified are
> +      __Number of interrupts__   __Default__
> +            1                       "int0"
> +            2                       "int0", "pps"
> +            3                       "int0", "int1", "int2"
> +            4                       "int0", "int1", "int2", "pps"
> +      The order may be changed as long as they correspond to the interrupts
> +      property. 

Why? None of the existing dts files do that and there is no reason to 
support random order. You can do this:

oneOf:
  - minItems: 1
    items:
      - const: int0
      - const: pps
  - minItems: 3
    items:
      - const: int0
      - const: int1
      - const: int2
      - const: pps
      


> Currently, only i.mx7 uses "int1" and "int2". They correspond to

Sounds like another constraint under an if/then schema.

> +      tx/rx queues 1 and 2. "int0" will be used for queue 0 and ENET_MII interrupts.
> +      For imx6sx, "int0" handles all 3 queues and ENET_MII. "pps" is for the pulse
> +      per second interrupt associated with 1588 precision time protocol(PTP).
> +
> +  clocks:
> +    minItems: 2
> +    maxItems: 5
> +    description:
> +      The "ipg", for MAC ipg_clk_s, ipg_clk_mac_s that are for register accessing.
> +      The "ahb", for MAC ipg_clk, ipg_clk_mac that are bus clock.
> +      The "ptp"(option), for IEEE1588 timer clock that requires the clock.
> +      The "enet_clk_ref"(option), for MAC transmit/receiver reference clock like
> +      RGMII TXC clock or RMII reference clock. It depends on board design,
> +      the clock is required if RGMII TXC and RMII reference clock source from
> +      SOC internal PLL.
> +      The "enet_out"(option), output clock for external device, like supply clock
> +      for PHY. The clock is required if PHY clock source from SOC.
> +
> +  clock-names:
> +    minItems: 2
> +    maxItems: 5
> +    contains:
> +      enum:
> +      - ipg
> +      - ahb
> +      - ptp
> +      - enet_clk_ref
> +      - enet_out

This means clock-names contains one of these strings and then anything 
else is valid.

s/contains/items/


> +
> +  phy-mode: true
> +
> +  phy-handle: true
> +
> +  fixed-link: true
> +
> +  local-mac-address: true
> +
> +  mac-address: true
> +
> +  phy-supply:
> +    description:
> +      Regulator that powers the Ethernet PHY.
> +
> +  fsl,num-tx-queues:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description:
> +      The property is valid for enet-avb IP, which supports hw multi queues.
> +      Should specify the tx queue number, otherwise set tx queue number to 1.

constraints? 2^32 queues are valid?

> +
> +  fsl,num-rx-queues:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description:
> +      The property is valid for enet-avb IP, which supports hw multi queues.
> +      Should specify the rx queue number, otherwise set rx queue number to 1.

constraints?

> +
> +  fsl,magic-packet:
> +    $ref: /schemas/types.yaml#/definitions/flag
> +    description:
> +      If present, indicates that the hardware supports waking up via magic packet.
> +
> +  fsl,err006687-workaround-present:
> +    $ref: /schemas/types.yaml#/definitions/flag
> +    description:
> +      If present indicates that the system has the hardware workaround for
> +      ERR006687 applied and does not need a software workaround.
> +
> +  fsl,stop-mode:
> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> +    description:
> +      Register bits of stop mode control, the format is <&gpr req_gpr req_bit>.

So, maxItems: 3

> +      gpr is the phandle to general purpose register node.
> +      req_gpr is the gpr register offset for ENET stop request.
> +      req_bit is the gpr bit offset for ENET stop request.
> +
> +  mdio:
> +    type: object
> +    description:
> +      Specifies the mdio bus in the FEC, used as a container for phy nodes.
> +
> +  # Deprecated optional properties:
> +  # To avoid these, create a phy node according to ethernet-phy.yaml in the same
> +  # directory, and point the FEC's "phy-handle" property to it. Then use
> +  # the phy's reset binding, again described by ethernet-phy.yaml.
> +
> +  phy-reset-gpios:
> +    deprecated: true
> +    description:
> +      Should specify the gpio for phy reset.
> +
> +  phy-reset-duration:
> +    deprecated: true
> +    description:
> +      Reset duration in milliseconds.  Should present only if property
> +      "phy-reset-gpios" is available.  Missing the property will have the
> +      duration be 1 millisecond.  Numbers greater than 1000 are invalid
> +      and 1 millisecond will be used instead.
> +
> +  phy-reset-active-high:
> +    deprecated: true
> +    description:
> +      If present then the reset sequence using the GPIO specified in the
> +      "phy-reset-gpios" property is reversed (H=reset state, L=operation state).
> +
> +  phy-reset-post-delay:
> +    deprecated: true
> +    description:
> +      Post reset delay in milliseconds. If present then a delay of phy-reset-post-delay
> +      milliseconds will be observed after the phy-reset-gpios has been toggled.
> +      Can be omitted thus no delay is observed. Delay is in range of 1ms to 1000ms.
> +      Other delays are invalid.
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +
> +# FIXME: We had better set additionalProperties to false to avoid invalid or at
> +# least undocumented properties. However, PHY may have a deprecated option to
> +# place PHY OF properties in the MAC node, such as Micrel PHY, and we can find
> +# these boards which is based on i.MX6QDL.
> +additionalProperties: true

Why can't the dts files be updated? Can you point me to an example .dts?

> +
> +examples:
> +  - |
> +    ethernet@83fec000 {
> +      compatible = "fsl,imx51-fec", "fsl,imx27-fec";
> +      reg = <0x83fec000 0x4000>;
> +      interrupts = <87>;
> +      phy-mode = "mii";
> +      phy-reset-gpios = <&gpio2 14 0>;
> +      phy-supply = <&reg_fec_supply>;
> +    };
> +
> +    ethernet@83fed000 {
> +      compatible = "fsl,imx51-fec", "fsl,imx27-fec";
> +      reg = <0x83fed000 0x4000>;
> +      interrupts = <87>;
> +      phy-mode = "mii";
> +      phy-reset-gpios = <&gpio2 14 0>;
> +      phy-supply = <&reg_fec_supply>;
> +      phy-handle = <&ethphy0>;
> +
> +      mdio {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        ethphy0: ethernet-phy@0 {
> +          compatible = "ethernet-phy-ieee802.3-c22";
> +          reg = <0>;
> +        };
> +      };
> +    };
> diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
> deleted file mode 100644
> index 9b543789cd52..000000000000
> --- a/Documentation/devicetree/bindings/net/fsl-fec.txt
> +++ /dev/null
> @@ -1,95 +0,0 @@
> -* Freescale Fast Ethernet Controller (FEC)
> -
> -Required properties:
> -- compatible : Should be "fsl,<soc>-fec"
> -- reg : Address and length of the register set for the device
> -- interrupts : Should contain fec interrupt
> -- phy-mode : See ethernet.txt file in the same directory
> -
> -Optional properties:
> -- phy-supply : regulator that powers the Ethernet PHY.
> -- phy-handle : phandle to the PHY device connected to this device.
> -- fixed-link : Assume a fixed link. See fixed-link.txt in the same directory.
> -  Use instead of phy-handle.
> -- fsl,num-tx-queues : The property is valid for enet-avb IP, which supports
> -  hw multi queues. Should specify the tx queue number, otherwise set tx queue
> -  number to 1.
> -- fsl,num-rx-queues : The property is valid for enet-avb IP, which supports
> -  hw multi queues. Should specify the rx queue number, otherwise set rx queue
> -  number to 1.
> -- fsl,magic-packet : If present, indicates that the hardware supports waking
> -  up via magic packet.
> -- fsl,err006687-workaround-present: If present indicates that the system has
> -  the hardware workaround for ERR006687 applied and does not need a software
> -  workaround.
> -- fsl,stop-mode: register bits of stop mode control, the format is
> -		 <&gpr req_gpr req_bit>.
> -		 gpr is the phandle to general purpose register node.
> -		 req_gpr is the gpr register offset for ENET stop request.
> -		 req_bit is the gpr bit offset for ENET stop request.
> - -interrupt-names:  names of the interrupts listed in interrupts property in
> -  the same order. The defaults if not specified are
> -  __Number of interrupts__   __Default__
> -	1			"int0"
> -	2			"int0", "pps"
> -	3			"int0", "int1", "int2"
> -	4			"int0", "int1", "int2", "pps"
> -  The order may be changed as long as they correspond to the interrupts
> -  property. Currently, only i.mx7 uses "int1" and "int2". They correspond to
> -  tx/rx queues 1 and 2. "int0" will be used for queue 0 and ENET_MII interrupts.
> -  For imx6sx, "int0" handles all 3 queues and ENET_MII. "pps" is for the pulse
> -  per second interrupt associated with 1588 precision time protocol(PTP).
> -
> -Optional subnodes:
> -- mdio : specifies the mdio bus in the FEC, used as a container for phy nodes
> -  according to phy.txt in the same directory
> -
> -Deprecated optional properties:
> -	To avoid these, create a phy node according to phy.txt in the same
> -	directory, and point the fec's "phy-handle" property to it. Then use
> -	the phy's reset binding, again described by phy.txt.
> -- phy-reset-gpios : Should specify the gpio for phy reset
> -- phy-reset-duration : Reset duration in milliseconds.  Should present
> -  only if property "phy-reset-gpios" is available.  Missing the property
> -  will have the duration be 1 millisecond.  Numbers greater than 1000 are
> -  invalid and 1 millisecond will be used instead.
> -- phy-reset-active-high : If present then the reset sequence using the GPIO
> -  specified in the "phy-reset-gpios" property is reversed (H=reset state,
> -  L=operation state).
> -- phy-reset-post-delay : Post reset delay in milliseconds. If present then
> -  a delay of phy-reset-post-delay milliseconds will be observed after the
> -  phy-reset-gpios has been toggled. Can be omitted thus no delay is
> -  observed. Delay is in range of 1ms to 1000ms. Other delays are invalid.
> -
> -Example:
> -
> -ethernet@83fec000 {
> -	compatible = "fsl,imx51-fec", "fsl,imx27-fec";
> -	reg = <0x83fec000 0x4000>;
> -	interrupts = <87>;
> -	phy-mode = "mii";
> -	phy-reset-gpios = <&gpio2 14 GPIO_ACTIVE_LOW>; /* GPIO2_14 */
> -	local-mac-address = [00 04 9F 01 1B B9];
> -	phy-supply = <&reg_fec_supply>;
> -};
> -
> -Example with phy specified:
> -
> -ethernet@83fec000 {
> -	compatible = "fsl,imx51-fec", "fsl,imx27-fec";
> -	reg = <0x83fec000 0x4000>;
> -	interrupts = <87>;
> -	phy-mode = "mii";
> -	phy-reset-gpios = <&gpio2 14 GPIO_ACTIVE_LOW>; /* GPIO2_14 */
> -	local-mac-address = [00 04 9F 01 1B B9];
> -	phy-supply = <&reg_fec_supply>;
> -	phy-handle = <&ethphy>;
> -	mdio {
> -	        clock-frequency = <5000000>;
> -		ethphy: ethernet-phy@6 {
> -			compatible = "ethernet-phy-ieee802.3-c22";
> -			reg = <6>;
> -			max-speed = <100>;
> -		};
> -	};
> -};
> -- 
> 2.17.1
> 
> 
