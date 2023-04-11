Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2098F6DDB27
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjDKMs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjDKMs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:48:56 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95C2449A
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 05:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bm7+APzZBRnQ9GfgygCcGHZaBBjcEQuh0vRffeflhQU=; b=gvm+pVd0+XVhq1j6OfeZRfDw0P
        PRd+NEjkYhsrIIHrqNuQ/S6K83Clp7UT04zh2lhcHerqswC0gBSJoCPNlU/F8WH/3BCljk1LLX3Zh
        NpmoVCiYP3e3ce3vBPPFVkcIvtqFJVTlMgNFl91I2sPRyjKz6lqv7LuSEG8joPWhY4Bs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pmDQX-009zOb-Cj; Tue, 11 Apr 2023 14:48:49 +0200
Date:   Tue, 11 Apr 2023 14:48:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Correct cmode to
 PHY_INTERFACE_
Message-ID: <a7a0dc51-c3dd-49e5-b66e-da9ddcc9e071@lunn.ch>
References: <20230411023541.2372609-1-andrew@lunn.ch>
 <20230411023541.2372609-1-andrew@lunn.ch>
 <20230411113857.f4i7drf7573r6vmg@skbuf>
 <123b198a-f810-a096-137b-fcf433a13b96@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <123b198a-f810-a096-137b-fcf433a13b96@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 4/11/2023 4:38 AM, Vladimir Oltean wrote:
> > On Tue, Apr 11, 2023 at 04:35:41AM +0200, Andrew Lunn wrote:
> > > The switch can either take the MAC or the PHY role in an MII or RMII
> > > link. There are distinct PHY_INTERFACE_ macros for these two roles.
> > > Correct the mapping so that the `REV` version is used for the PHY
> > > role.

> > >   static const u8 mv88e6xxx_phy_interface_modes[] = {
> > > -	[MV88E6XXX_PORT_STS_CMODE_MII_PHY]	= PHY_INTERFACE_MODE_MII,
> > > +	[MV88E6XXX_PORT_STS_CMODE_MII_PHY]	= PHY_INTERFACE_MODE_REVMII,
> 
> Is this hunk correct?

Hi Florian

I don't see why it is wrong, but you can be blind to bugs in your own
code. What do you think is wrong?

Thanks
	Andrew
