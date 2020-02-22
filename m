Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB427168E77
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 12:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgBVL3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 06:29:02 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:52341 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgBVL3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 06:29:02 -0500
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id C25BA22F43;
        Sat, 22 Feb 2020 12:28:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1582370938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e0h+j99WGr7wIIbHMLcV3S5aoHAcIz/PdQJyb0wgPnM=;
        b=I8oZj+/HaL1gIkhtRKfWF3mOwkdK9UnbDUhuCokq1OMD1SG0VB+vPxRsbJMhtK5G97O0wl
        Fb5aOlyDjbmhZcyVTw7oCxW61DlgokC9PdAj9GYRqPFAKD9GyyLmnuHvSP6huIutEaKBd/
        GaaRjcFG3DyjHvfQRbpEMvXuEPUC6kg=
From:   Michael Walle <michael@walle.cc>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, davem@davemloft.net, devicetree@vger.kernel.org,
        f.fainelli@gmail.com, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, vivien.didelot@gmail.com,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH v2 net-next/devicetree 3/5] dt-bindings: net: dsa: ocelot: document the vsc9959 core
Date:   Sat, 22 Feb 2020 12:28:41 +0100
Message-Id: <20200222112841.29927-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200219151259.14273-4-olteanv@gmail.com>
References: <20200219151259.14273-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++
X-Spam-Level: ****
X-Rspamd-Server: web
X-Spam-Status: No, score=4.90
X-Spam-Score: 4.90
X-Rspamd-Queue-Id: C25BA22F43
X-Spamd-Result: default: False [4.90 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[dt];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         NEURAL_SPAM(0.00)[0.617];
         DKIM_SIGNED(0.00)[];
         DBL_PROHIBIT(0.00)[0.0.0.2:email,0.0.0.3:email,0.0.0.0:email,0.0.0.4:email,0.0.0.5:email,0.0.0.1:email];
         RCPT_COUNT_TWELVE(0.00)[12];
         MID_CONTAINS_FROM(1.00)[];
         FREEMAIL_TO(0.00)[gmail.com];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c::/31, country:DE];
         FREEMAIL_CC(0.00)[lunn.ch,davemloft.net,vger.kernel.org,gmail.com,arm.com,kernel.org,walle.cc]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This patch adds the required documentation for the embedded L2 switch
> inside the NXP LS1028A chip.
> 
> I've submitted it in the legacy format instead of yaml schema, because
> DSA itself has not yet been converted to yaml, and this driver defines
> no custom bindings.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v2:
> Adapted phy-mode = "gmii" to phy-mode = "internal".
> 
>  .../devicetree/bindings/net/dsa/ocelot.txt    | 96 +++++++++++++++++++
>  1 file changed, 96 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/ocelot.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/ocelot.txt b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
> new file mode 100644
> index 000000000000..a9d86e09dafa
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
> @@ -0,0 +1,96 @@
> +Microchip Ocelot switch driver family
> +=====================================
> +
> +Felix
> +-----
> +
> +The VSC9959 core is currently the only switch supported by the driver, and is
> +found in the NXP LS1028A. It is a PCI device, part of the larger ENETC root
> +complex. As a result, the ethernet-switch node is a sub-node of the PCIe root
> +complex node and its "reg" property conforms to the parent node bindings:
> +
> +* reg: Specifies PCIe Device Number and Function Number of the endpoint device,
> +  in this case for the Ethernet L2Switch it is PF5 (of device 0, bus 0).
> +
> +It does not require a "compatible" string.
> +
> +The interrupt line is used to signal availability of PTP TX timestamps and for
> +TSN frame preemption.
> +
> +For the external switch ports, depending on board configuration, "phy-mode" and
> +"phy-handle" are populated by board specific device tree instances. Ports 4 and
> +5 are fixed as internal ports in the NXP LS1028A instantiation.
> +
> +Any port can be disabled, but the CPU port should be kept enabled.

What is the reason for this? Do you mean if you actually want to use it? In
fact, I'd would like to see it disabled by default in the .dtsi file. It
doesn't make sense to just have the CPU port enabled, but not any of the
outgoing ports. It'd just confuse the user if there is an additional
network port which cannot be used.

-michael

> +
> +The CPU port property ("ethernet"), which is assigned by default to the 2.5Gbps
> +port@4, can be moved to the 1Gbps port@5, depending on the specific use case.
> +DSA tagging is supported on a single port at a time.
> +
> +For the rest of the device tree binding definitions, which are standard DSA and
> +PCI, refer to the following documents:
> +
> +Documentation/devicetree/bindings/net/dsa/dsa.txt
> +Documentation/devicetree/bindings/pci/pci.txt
> +
> +Example:
> +
> +&soc {
> +	pcie@1f0000000 { /* Integrated Endpoint Root Complex */
> +		ethernet-switch@0,5 {
> +			reg = <0x000500 0 0 0 0>;
> +			/* IEP INT_B */
> +			interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>;
> +
> +			ports {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +
> +				/* External ports */
> +				port@0 {
> +					reg = <0>;
> +					label = "swp0";
> +				};
> +
> +				port@1 {
> +					reg = <1>;
> +					label = "swp1";
> +				};
> +
> +				port@2 {
> +					reg = <2>;
> +					label = "swp2";
> +				};
> +
> +				port@3 {
> +					reg = <3>;
> +					label = "swp3";
> +				};
> +
> +				/* Tagging CPU port */
> +				port@4 {
> +					reg = <4>;
> +					ethernet = <&enetc_port2>;
> +					phy-mode = "internal";
> +
> +					fixed-link {
> +						speed = <2500>;
> +						full-duplex;
> +					};
> +				};
> +
> +				/* Non-tagging CPU port */
> +				port@5 {
> +					reg = <5>;
> +					phy-mode = "internal";
> +					status = "disabled";
> +
> +					fixed-link {
> +						speed = <1000>;
> +						full-duplex;
> +					};
> +				};
> +			};
> +		};
> +	};
> +};
> -- 
> 2.17.1


