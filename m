Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181E2585861
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 05:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239832AbiG3DzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 23:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiG3DzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 23:55:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF78814D2E;
        Fri, 29 Jul 2022 20:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gjwGvuIYlf7YURpygwYL3YCCMDNSe/5O6oVE1XLk23k=; b=ZYUfs1+1e4ls90l1z7FI1IjfsV
        y6HXSTTXO7KiFdvT1ncL/nrAV0qzX9copWCDrD4jsLPOBJ0DXiSmDKjs2GmgTEiDOKhAxFHVYTPW4
        u7RAi7MtzrxbdSacHnD7VIKCqzLMo2j5I/3An1YCyxid+o0Oo7feza5JE8fVY3ffckOc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oHdZN-00BzR1-Tv; Sat, 30 Jul 2022 05:55:17 +0200
Date:   Sat, 30 Jul 2022 05:55:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Richard Cochran <richardcochran@gmail.com>,
        Horatiu.Vultur@microchip.com, Allan.Nielsen@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v3 1/4] net: phy: Introduce QUSGMII PHY mode
Message-ID: <YuSrpbUrcZh5QotE@lunn.ch>
References: <20220729153356.581444-1-maxime.chevallier@bootlin.com>
 <20220729153356.581444-2-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729153356.581444-2-maxime.chevallier@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 05:33:53PM +0200, Maxime Chevallier wrote:
> The QUSGMII mode is a derivative of Cisco's USXGMII standard. This
> standard is pretty similar to SGMII, but allows for faster speeds, and
> has the build-in bits for Quad and Octa variants (like QSGMII).
> 
> The main difference with SGMII/QSGMII is that USXGMII/QUSGMII re-uses
> the preamble to carry various information, named 'Extensions'.
> 
> As of today, the USXGMII standard only mentions the "PCH" extension,
> which is used to convey timestamps, allowing in-band signaling of PTP
> timestamps without having to modify the frame itself.
> 
> This commit adds support for that mode. When no extension is in use, it
> behaves exactly like QSGMII, although it's not compatible with QSGMII.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
