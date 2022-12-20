Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706E9652476
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 17:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbiLTQOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 11:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbiLTQN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 11:13:59 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EE91C419
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 08:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=F5BlML5hELdIjvdpayAX0v1C/9XDVWt1TyP3aI4eXC4=; b=u2FT0qYjLjD6ChhrzaVEdeaaGj
        nRHs9Cg4SGo+tFcJ2n6eARfcZKD212JIGXAyhxducSHY9GGPGKmd6ybe9RU81SI1OYeyuBNwXmDbE
        +oNxUViVLAoNVrmcpNHTR2TrCicUP8Wv3LsyeuNH6P6yoN7XNy7FZQPmy5AJB859t68DzEv155FRb
        RAd+5h5zmgZEfCdkT+ll0vgCpLhP78p3AbNUGiIcWKtiYQihj/nRfp8jlyk90fVUM2a3XNF31TcKW
        4lUX591/KREY/BpDmw02U58JhccC03hsmWqFKtxwQUNyQCQfh+zfnSWCHN7zMyJgbBP/XeP5sWT0e
        5UKR7QMQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35790)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p7fFG-0008Jq-4n; Tue, 20 Dec 2022 16:13:34 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p7fFD-0005hf-SW; Tue, 20 Dec 2022 16:13:31 +0000
Date:   Tue, 20 Dec 2022 16:13:31 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        woojung huh <woojung.huh@microchip.com>,
        davem <davem@davemloft.net>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
 phy_disable_interrupts()
Message-ID: <Y6HfK7bnkL2uyp3m@shell.armlinux.org.uk>
References: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com>
 <20221220131921.806365-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
 <7ac42bd4-3088-5bd5-dcfc-c1e74466abb5@gmail.com>
 <1721908413.470634.1671548576554.JavaMail.zimbra@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1721908413.470634.1671548576554.JavaMail.zimbra@savoirfairelinux.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

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
> 
> Unfortunately, I don't have the cables to test the code without the workaround
> and it's description doesn't explain what problem happens more precisely.
> 
> The PHY the original author used is a LAN8835. The workaround code directly
> modified the interrupt configuration registers of this LAN8835 PHY within
> lan78xx_link_status_change(). This caused problems if a different PHY was used
> because the register at this address did not correspond to the interrupts
> configuration. As suggested by the lan78xx.c maintainer, a generic function
> should be used instead to toggle the interrupts of the PHY. However, it seems
> that maybe the MAC driver shouldn't meddle with the PHY's interrupts according
> to you. Would you consider this use case a valid one?

This sounds to me like you're just trying to get a workaround merged
upstream using a different approach, but you can't actually test to
see whether it does work or not. Would that be a fair assessment?

Do you know anyone who would be able to test? If not, I would suggest
not trying to upstream code for a workaround that can't be tested as
working.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
