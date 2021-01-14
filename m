Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252B72F5FB1
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 12:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbhANLTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 06:19:22 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:53162 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbhANLTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 06:19:20 -0500
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 148523B2D11;
        Thu, 14 Jan 2021 11:03:39 +0000 (UTC)
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 5EAE2FF802;
        Thu, 14 Jan 2021 11:02:15 +0000 (UTC)
Date:   Thu, 14 Jan 2021 12:02:14 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v12 1/4] dt-bindings: phy: Add sparx5-serdes bindings
Message-ID: <20210114110214.GY3654@piout.net>
References: <20210107091924.1569575-1-steen.hegelund@microchip.com>
 <20210107091924.1569575-2-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107091924.1569575-2-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/01/2021 10:19:21+0100, Steen Hegelund wrote:
> Document the Sparx5 ethernet serdes phy driver bindings.
> 
> Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  .../bindings/phy/microchip,sparx5-serdes.yaml | 100 ++++++++++++++++++
>  1 file changed, 100 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/microchip,sparx5-serdes.yaml
> 
> diff --git a/Documentation/devicetree/bindings/phy/microchip,sparx5-serdes.yaml b/Documentation/devicetree/bindings/phy/microchip,sparx5-serdes.yaml
> new file mode 100644
> index 000000000000..bdbdb3bbddbe
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/microchip,sparx5-serdes.yaml
> @@ -0,0 +1,100 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/phy/microchip,sparx5-serdes.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Microchip Sparx5 Serdes controller
> +
> +maintainers:
> +  - Steen Hegelund <steen.hegelund@microchip.com>
> +
> +description: |
> +  The Sparx5 SERDES interfaces share the same basic functionality, but
> +  support different operating modes and line rates.
> +
> +  The following list lists the SERDES features:
> +
> +  * RX Adaptive Decision Feedback Equalizer (DFE)
> +  * Programmable continuous time linear equalizer (CTLE)
> +  * Rx variable gain control
> +  * Rx built-in fault detector (loss-of-lock/loss-of-signal)
> +  * Adjustable tx de-emphasis (FFE)
> +  * Tx output amplitude control
> +  * Supports rx eye monitor
> +  * Multiple loopback modes
> +  * Prbs generator and checker
> +  * Polarity inversion control
> +
> +  SERDES6G:
> +
> +  The SERDES6G is a high-speed SERDES interface, which can operate at
> +  the following data rates:
> +
> +  * 100 Mbps (100BASE-FX)
> +  * 1.25 Gbps (SGMII/1000BASE-X/1000BASE-KX)
> +  * 3.125 Gbps (2.5GBASE-X/2.5GBASE-KX)
> +  * 5.15625 Gbps (5GBASE-KR/5G-USXGMII)
> +
> +  SERDES10G
> +
> +  The SERDES10G is a high-speed SERDES interface, which can operate at
> +  the following data rates:
> +
> +  * 100 Mbps (100BASE-FX)
> +  * 1.25 Gbps (SGMII/1000BASE-X/1000BASE-KX)
> +  * 3.125 Gbps (2.5GBASE-X/2.5GBASE-KX)
> +  * 5 Gbps (QSGMII/USGMII)
> +  * 5.15625 Gbps (5GBASE-KR/5G-USXGMII)
> +  * 10 Gbps (10G-USGMII)
> +  * 10.3125 Gbps (10GBASE-R/10GBASE-KR/USXGMII)
> +
> +  SERDES25G
> +
> +  The SERDES25G is a high-speed SERDES interface, which can operate at
> +  the following data rates:
> +
> +  * 1.25 Gbps (SGMII/1000BASE-X/1000BASE-KX)
> +  * 3.125 Gbps (2.5GBASE-X/2.5GBASE-KX)
> +  * 5 Gbps (QSGMII/USGMII)
> +  * 5.15625 Gbps (5GBASE-KR/5G-USXGMII)
> +  * 10 Gbps (10G-USGMII)
> +  * 10.3125 Gbps (10GBASE-R/10GBASE-KR/USXGMII)
> +  * 25.78125 Gbps (25GBASE-KR/25GBASE-CR/25GBASE-SR/25GBASE-LR/25GBASE-ER)
> +
> +properties:
> +  $nodename:
> +    pattern: "^serdes@[0-9a-f]+$"
> +
> +  compatible:
> +    const: microchip,sparx5-serdes
> +
> +  reg:
> +    minItems: 1
> +
> +  '#phy-cells':
> +    const: 1
> +    description: |
> +      - The main serdes input port
> +
> +  clocks:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - '#phy-cells'
> +  - clocks
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    serdes: serdes@10808000 {
> +      compatible = "microchip,sparx5-serdes";
> +      #phy-cells = <1>;
> +      clocks = <&sys_clk>;
> +      reg = <0x10808000 0x5d0000>;
> +    };
> +
> +...
> -- 
> 2.29.2
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
