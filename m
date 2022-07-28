Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABFB85847AE
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 23:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbiG1VYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 17:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233209AbiG1VYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 17:24:07 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C567695D;
        Thu, 28 Jul 2022 14:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CVSiwENoDSyrPHB5qMmXbGM8p18BOOMXfI8y4AIXaQQ=; b=L+na748tjlUEOrXQS0TYM1wmHM
        WXLWBe3Aj3HX3oe0p/vIH0TI21XR/Tmsxr9M9e5i+EYrmafpHkIjiRwX+2rTJUIZHMxzhllkE4Sgp
        99Gy2EooIhtK1tFC8Jeb21bsEZI2sefTKLRnw6WAWkD2O+WAxO7qI5qD8FTB5x3ajUcE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oHAz9-00BqKO-Ny; Thu, 28 Jul 2022 23:23:59 +0200
Date:   Thu, 28 Jul 2022 23:23:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Horatiu.Vultur@microchip.com,
        Allan.Nielsen@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/4] net: phy: Introduce QUSGMII PHY mode
Message-ID: <YuL+b47YHw61bnoG@lunn.ch>
References: <20220728145252.439201-1-maxime.chevallier@bootlin.com>
 <20220728145252.439201-2-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728145252.439201-2-maxime.chevallier@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 87638c55d844..6b96b810a4d8 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -152,6 +152,7 @@ typedef enum {
>  	PHY_INTERFACE_MODE_USXGMII,
>  	/* 10GBASE-KR - with Clause 73 AN */
>  	PHY_INTERFACE_MODE_10GKR,
> +	PHY_INTERFACE_MODE_QUSGMII,
>  	PHY_INTERFACE_MODE_MAX,
>  } phy_interface_t;

I _think_ this will give you a kerneldoc warning about
PHY_INTERFACE_MODE_QUSGMII not having any documentation?

	   Andrew

