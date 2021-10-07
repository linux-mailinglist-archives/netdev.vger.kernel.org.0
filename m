Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED40425F58
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 23:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242568AbhJGVnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 17:43:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55340 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241753AbhJGVnm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 17:43:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zNEViZ4F22HFg4Uu4a+UfpGs0GxPWIjVj+B5UlJ5o94=; b=lbM6QdQvarc7KVhE9pbwhxllcs
        QcNF7HO3i1pdelW6SYw4kkjs7znaUSm/3ll9/kdFhc+MB8W5VzwCt0h68Vk/6MBhHb8bP9T/DueR+
        anerbHXzrBy4iZcosJogRDpY7Qs/r80zYmPRkkiiRzcEbueXUO73tu9GAwl+ID6tkBMI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYb91-009zsW-La; Thu, 07 Oct 2021 23:41:39 +0200
Date:   Thu, 7 Oct 2021 23:41:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 net-next 01/10] dt-bindings: net: dsa: dt bindings for
 microchip lan937x
Message-ID: <YV9pk13TT9W7X2i1@lunn.ch>
References: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
 <20211007151200.748944-2-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007151200.748944-2-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +
> +    //Ethernet switch connected via spi to the host
> +    ethernet {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +
> +      fixed-link {
> +        speed = <1000>;
> +        full-duplex;
> +      };
> +    };
> +
> +    spi {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +
> +      lan9374: switch@0 {
> +        compatible = "microchip,lan9374";
> +        reg = <0>;
> +
> +        spi-max-frequency = <44000000>;
> +
> +        ethernet-ports {
> +          #address-cells = <1>;
> +          #size-cells = <0>;
> +          port@0 {
> +            reg = <0>;
> +            label = "lan1";
> +            phy-mode = "internal";
> +            phy-handle = <&t1phy0>;
> +          };

...

> +        mdio {
> +          #address-cells = <1>;
> +          #size-cells = <0>;
> +
> +          t1phy0: ethernet-phy@0{
> +            reg = <0x0>;
> +          };

Does this pass Rob's DT schema proof tools? You don't have any
description of the mdio properties.

Maybe look at nxp,sja1105.yaml

      Andrew
