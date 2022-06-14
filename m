Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD5154B8B2
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 20:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbiFNSer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 14:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbiFNSeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 14:34:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4292D48E78
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 11:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ZAf46MHIlpiYiISuQ+pc0VZ/hLiIAOmVXaMY8kchKE8=; b=vQAmlb1Fn+yqxI+wsdoCtl2WN8
        +chzMbRzKEbrLWEqEUe2QfxfyyYzRtdi7FmjBY24OFTxp4RgC5F4V7c9I6+IaKNKprOPOKAC2HGFM
        akWY+wbTRYjkE8YrZQzk0XXm9b4Lf0lxY96T/VIxlJe5Zu8WI3vu0ZQdrjd/sInySJKc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o1BMz-006v2z-Bh; Tue, 14 Jun 2022 20:34:29 +0200
Date:   Tue, 14 Jun 2022 20:34:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 01/15] net: phylink: fix SGMII inband autoneg
 enable
Message-ID: <YqjUtYrHW5qQlVft@lunn.ch>
References: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
 <E1o0jg9-000JY6-Vx@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1o0jg9-000JY6-Vx@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 13, 2022 at 02:00:25PM +0100, Russell King (Oracle) wrote:
> When we are operating in SGMII inband mode, it implies that there is a
> PHY connected, and the ethtool advertisement for autoneg applies to
> the PHY, not the SGMII link. When in 1000base-X mode, then this applies
> to the 802.3z link and needs to be applied to the PCS.
> 
> Fix this.
> 
> Fixes: 92817dad7dcb ("net: phylink: Support disabling autonegotiation for PCS")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
