Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF2C3C36CB
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 22:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhGJUhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 16:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhGJUhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 16:37:01 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B729C0613DD;
        Sat, 10 Jul 2021 13:34:15 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id c17so23840989ejk.13;
        Sat, 10 Jul 2021 13:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MPITH6hW87Dzz+BA0F4dfZufHvIwz3mBp2b8LY0PIYI=;
        b=decWn1Dd9gN9XIO9xOLyFCgQ7wDLRDEsezyAG4ecduWDshNQWqfBo/xQRN3AcXMEg9
         SqTs2IclFYAJGCm4fETpjeT22ZBJyL5mQHhrOk4aMn7JyAD/jMpW/puSJK1f5lU/ndgz
         /JeZy2jp+h2jr0sh0WLZRKYycqrD3MDw8rx8VxEitN95VRFkCU+Ccvs7twNF/L6cIJow
         BW71fNxOCCXXn5H+KkQGqzWC4tTB4XC6812HgwkrrFs0Cnd3wPo7tNjBKXmv3vaRwZze
         KmJUQQrNhaBsja5DtppWpqD/Sni0NoSsx0LbCvIKHHqU4SUNvTNkI/uKhe9pt+LAI9Gj
         98BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MPITH6hW87Dzz+BA0F4dfZufHvIwz3mBp2b8LY0PIYI=;
        b=U4cSsERGTFPHWKAJJehbnI6Iz7oLM+ANkARv+RwtgxoavLhrGlx21Jb447hIafmFSH
         OjBbvbPO8NZlDegUpjxXgyqO2q1fZ8dRCWMJ9jQfRqJzmyylHqPKourAPdZCT4P9OwHQ
         qG+m+fVfVe9+/QA5o8O6B+pXJsfRFLMDBcQT0cJYnY5hvLR/JL2vGpnqbq1JoDij//6x
         +fDOyoLXWHB0MIzvWBctBATGDIRyuEGxcdo8INI1bzoHjOcSPNYEyfmHfWuIo2HiHOjB
         xqCl8PY/fWLEWYHZqCXq7YqaNJ1NlOXr3cv53eYPmBAIYlReqxaJXblq+KacG4l3ZrB6
         llqw==
X-Gm-Message-State: AOAM532ppkq2tLQZSQ0UImt3+oEYseHiWj/COOcN1O2V5ufKaGlKT6Ft
        FYhcuSBR3mIIxBUs8rL/yNg=
X-Google-Smtp-Source: ABdhPJyn+eqeGLvY0gTYmezpnwhOahOq/E7NuaQ1DLn6l7tVFb18HFvb58ZhcaUI6Y+tsf9Afnh/2g==
X-Received: by 2002:a17:906:c34b:: with SMTP id ci11mr18969519ejb.223.1625949253688;
        Sat, 10 Jul 2021 13:34:13 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id n13sm4159652ejk.97.2021.07.10.13.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 13:34:13 -0700 (PDT)
Date:   Sat, 10 Jul 2021 23:34:11 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 net-next 8/8] Update documentation for the VSC7512
 SPI device
Message-ID: <20210710203411.nahqkyy4umqbtfwm@skbuf>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
 <20210710192602.2186370-9-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710192602.2186370-9-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 12:26:02PM -0700, Colin Foster wrote:
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  .../devicetree/bindings/net/dsa/ocelot.txt    | 68 +++++++++++++++++++
>  1 file changed, 68 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/ocelot.txt b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
> index 7a271d070b72..f5d05bf8b093 100644
> --- a/Documentation/devicetree/bindings/net/dsa/ocelot.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
> @@ -8,6 +8,7 @@ Currently the switches supported by the felix driver are:
>  
>  - VSC9959 (Felix)
>  - VSC9953 (Seville)
> +- VSC7511, VSC7512, VSC7513, VSC7514 via SPI
>  
>  The VSC9959 switch is found in the NXP LS1028A. It is a PCI device, part of the
>  larger ENETC root complex. As a result, the ethernet-switch node is a sub-node
> @@ -211,3 +212,70 @@ Example:
>  		};
>  	};
>  };
> +
> +The VSC7513 and VSC7514 switches can be controlled internally via the MIPS
> +processor. The VSC7511 and VSC7512 don't have this internal processor, but all
> +four chips can be controlled externally through SPI with the following required
> +properties:
> +
> +- compatible:
> +	Can be "mscc,vsc7511", "mscc,vsc7512", "mscc,vsc7513", or
> +	"mscc,vsc7514".
> +
> +Supported phy modes for all chips are:
> +
> +* phy_mode = "internal": on ports 0, 1, 2, 3
> +
> +Additionally, the VSC7512 and VSC7514 support SGMII and QSGMII on various ports,
> +though that is currently untested.
> +
> +Example for control from a BeagleBone Black
> +
> +&spi0 {
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +	status = "okay";
> +
> +	vsc7512: vsc7512@0 {

ethernet-switch@0

> +		compatible = "mscc,vsc7512";
> +		spi-max-frequency = <250000>;
> +		reg = <0>;
> +
> +		ports {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			port@0 {
> +				reg = <0>;
> +				ethernet = <&mac>;
> +				phy-mode = "internal";
> +
> +				fixed-link {
> +					speed = <100>;
> +					full-duplex;
> +				};
> +			};
> +
> +			port@1 {
> +				reg = <1>;
> +				label = "swp1";
> +				status = "okay";

I am not convinced that the status = "okay" lines are useful in the
example.

> +				phy-mode = "internal";

This syntax is ambiguous and does not obviously mean that the port has
an internal copper PHY. Please see this discussion for other meanings of
no 'phy-handle' and no 'fixed-link'.

https://www.mail-archive.com/u-boot@lists.denx.de/msg409571.html

I think it would be in the best interest of everyone to go through
phylink_of_phy_connect() instead of phylink_connect_phy(), aka use the
standard phy-handle property and create an mdio node under
ethernet-switch@0 where the internal PHY OF nodes are defined.

I don't know if this is true for VSC7512 or not, but for example on
NXP SJA1110, the internal PHYs can be accessed in 2 modes:
(a) through SPI transfers
(b) through an MDIO slave access point exposed by the switch chip, which
    can be connected to an external MDIO controller

Some boards will use method (a), and others will use method (b).

Requiring a phy-handle under the port property is an absolutely generic
way to seamlessly deal with both cases. In case (a), the phy-handle
points to a child of an MDIO bus provided by the ocelot driver, in case
(b) the phy-handle points to a child provided by some other MDIO
controller driver.

> +			};
> +
> +			port@2 {
> +				reg = <2>;
> +				label = "swp2";
> +				status = "okay";
> +				phy-mode = "internal";
> +			};
> +
> +			port@3 {
> +				reg = <3>;
> +				label = "swp3";
> +				status = "okay";
> +				phy-mode = "internal";
> +			};
> +		};
> +	};
> +};
> -- 
> 2.25.1
> 
