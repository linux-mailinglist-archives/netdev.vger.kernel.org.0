Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E48C309C1B
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 13:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhAaMt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 07:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbhAaL2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 06:28:44 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DA9C0613D6;
        Sun, 31 Jan 2021 03:13:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kSQjaLHPFxjy+Ya8y9DKF26S9zU9JPp8cLq/cCroWFI=; b=XNyFAiFIxhtJLcf9+uvzpxZET
        ZCmnJt6pOrlh3xlfHsqNPdRJ5KAJRKRHWM1xNW6bxRkGdxQKXd7HS/GS8kwXdEMM5TrAaYwNHRI9Y
        dxcQOtfvWz3gpMll5GCCU5lmiOVjI0iduy4zA8gLRsEWP8NMtUspMrDZWFxIKqv7GmOzoQHHSFRsS
        QLieRun62VkqYpJjtQMJDTgT0Y7aUqOxAd459A5DnKYla9w8S+ZTLU8TWbD9ii6Pcv6anBfAp6QLT
        SHLlSRRGWY1CeTJUbp6Vp2dbSmB4vO76LyWeU60d2Na86EyzeIM61aFZSTLfNt+E/6mYJzzNMYj6j
        gpkBcGIeg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37306)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l6Afe-0002MQ-CV; Sun, 31 Jan 2021 11:13:34 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l6Afd-0000yB-Dv; Sun, 31 Jan 2021 11:13:33 +0000
Date:   Sun, 31 Jan 2021 11:13:33 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: ethernet-controller: fix fixed-link
 specification
Message-ID: <20210131111333.GC1463@shell.armlinux.org.uk>
References: <E1l6AQp-00060t-En@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1l6AQp-00060t-En@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NOTE: not all recipients will have received this, because kernel.org
is using bl.spamcop.net, and that currently lists the universe (the
domain has due for renewal and the registry has made *.spamcop.net
resolve to their parking webserver.)

On Sun, Jan 31, 2021 at 10:58:15AM +0000, Russell King wrote:
> The original fixed-link.txt allowed a pause property for fixed link.
> This has been missed in the conversion to yaml format.
> 
> Fixes: 9d3de3c58347 ("dt-bindings: net: Add YAML schemas for the generic Ethernet options")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  .../devicetree/bindings/net/ethernet-controller.yaml         | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> index fdf709817218..39147d33e8c7 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -206,6 +206,11 @@ title: Ethernet Controller Generic Binding
>                  Indicates that full-duplex is used. When absent, half
>                  duplex is assumed.
>  
> +            pause:
> +              $ref: /schemas/types.yaml#definitions/flag
> +              description:
> +                Indicates that pause should be enabled.
> +
>              asym-pause:
>                $ref: /schemas/types.yaml#definitions/flag
>                description:
> -- 
> 2.20.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
