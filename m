Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B6B1FD80C
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 00:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgFQV7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 17:59:45 -0400
Received: from gloria.sntech.de ([185.11.138.130]:48644 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbgFQV7p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 17:59:45 -0400
Received: from ip5f5aa64a.dynamic.kabel-deutschland.de ([95.90.166.74] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1jlg5t-0006Nk-A6; Wed, 17 Jun 2020 23:59:41 +0200
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, robh+dt@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        christoph.muellner@theobroma-systems.com
Subject: Re: [PATCH v4 2/3] dt-bindings: net: ethernet-phy: add enet-phy-clock-out-frequency
Date:   Wed, 17 Jun 2020 23:59:40 +0200
Message-ID: <2463406.V3ZL2uFT5d@diego>
In-Reply-To: <20200617213326.1532365-3-heiko@sntech.de>
References: <20200617213326.1532365-1-heiko@sntech.de> <20200617213326.1532365-3-heiko@sntech.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Mittwoch, 17. Juni 2020, 23:33:25 CEST schrieb Heiko Stuebner:
> From: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
> 
> Some ethernet phys have a configurable clock output, so add a generic
> property to describe its target rate.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>

just now Rob wrote for v3:

----- 8< ------
The correct thing to do here is make the phy a clock provider and then 
the client side use 'assigned-clock-rate' to set the rate. That has the 
advantage that it also describes the connection of the clock signal. You 
might not need that for a simple case, but I could imagine needing that 
in a more complex case.

Rob
----- 8< ------



>  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> index 9b1f1147ca36..4dcf93f1c555 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> @@ -84,6 +84,11 @@ properties:
>        the turn around line low at end of the control phase of the
>        MDIO transaction.
>  
> +  enet-phy-clock-out-frequency:
> +    $ref: /schemas/types.yaml#definitions/uint32
> +    description:
> +      Frequency in Hz to set an available clock output to.
> +
>    enet-phy-lane-swap:
>      $ref: /schemas/types.yaml#definitions/flag
>      description:
> 




