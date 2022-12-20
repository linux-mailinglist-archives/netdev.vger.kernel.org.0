Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C446652392
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 16:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbiLTPRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 10:17:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbiLTPRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 10:17:38 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0C5DF2C
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 07:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6hg2VMEm9x3omXu2DuJ9/zeaoEaktK9UGxjzfz+L8gs=; b=sIyELflVlNvNjz8a44O1GFZcYf
        dTlMzSf+hI7TCBu5s8SUu9j+Ze1Xh4av3M5yEW2mtFDURi/w/EzL/5AUDXri4o74vQhbbkZFGZyD0
        sLcEfu91dm90kDrC3inesXxe7irK68jg0TnWXvn53jNZpx5FvFLO4yJ0zHKVnTWqF0fE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p7eN0-0006Ah-4V; Tue, 20 Dec 2022 16:17:30 +0100
Date:   Tue, 20 Dec 2022 16:17:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        woojung huh <woojung.huh@microchip.com>,
        davem <davem@davemloft.net>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
 phy_disable_interrupts()
Message-ID: <Y6HSCkdtgUlJXxDh@lunn.ch>
References: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com>
 <20221220131921.806365-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
 <7ac42bd4-3088-5bd5-dcfc-c1e74466abb5@gmail.com>
 <1721908413.470634.1671548576554.JavaMail.zimbra@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1721908413.470634.1671548576554.JavaMail.zimbra@savoirfairelinux.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 10:02:56AM -0500, Enguerrand de Ribaucourt wrote:
> > From: "Heiner Kallweit" <hkallweit1@gmail.com>
> > To: "Enguerrand de Ribaucourt" <enguerrand.de-ribaucourt@savoirfairelinux.com>,
> > "netdev" <netdev@vger.kernel.org>
> > Cc: "Paolo Abeni" <pabeni@redhat.com>, "woojung huh"
> > <woojung.huh@microchip.com>, "davem" <davem@davemloft.net>, "UNGLinuxDriver"
> > <UNGLinuxDriver@microchip.com>, "Andrew Lunn" <andrew@lunn.ch>, "Russell King -
> > ARM Linux" <linux@armlinux.org.uk>
> > Sent: Tuesday, December 20, 2022 3:40:15 PM
> > Subject: Re: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
> > phy_disable_interrupts()
> 
> > On 20.12.2022 14:19, Enguerrand de Ribaucourt wrote:
> > > It seems EXPORT_SYMBOL was forgotten when phy_disable_interrupts() was
> > > made non static. For consistency with the other exported functions in
> > > this file, EXPORT_SYMBOL should be used.
> 
> > No, it wasn't forgotten. It's intentional. The function is supposed to
> > be used within phylib only.
> 
> > None of the phylib maintainers was on the addressee list of your patch.
> > Seems you didn't check with get_maintainers.pl.
> 
> > You should explain your use case to the phylib maintainers. Maybe lan78xx
> > uses phylib in a wrong way, maybe an extension to phylib is needed.
> > Best start with explaining why lan78xx_link_status_change() needs to
> > fiddle with the PHY interrupt. It would help be helpful to understand
> > what "chip" refers to in the comment. The MAC, or the PHY?
> > Does the lan78xx code assume that a specific PHY is used, and the
> > functionality would actually belong to the respective PHY driver?
> 
> Thank you for your swift reply,
> 
> The requirement to toggle the PHY interrupt in lan78xx_link_status_change() (the
> LAN7801 MAC driver) comes from a workaround by the original author which resets
> the fixed speed in the PHY when the Ethernet cable is swapped. According to his
> message, the link could not be correctly setup without this workaround.

This seems like a PHY bug, so the workaround should be in the PHY
driver, not the MAC driver. It will then apply to all MAC:PHY
combinations, not just the lan78xx paired with this PHY.

The PHY driver has the callback link_change_notify. You might be able
to use that.

   Andrew
