Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33982D40EB
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 12:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730655AbgLILVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 06:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729904AbgLILU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 06:20:57 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A80C0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 03:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jj6/R+UGJmF449AsREm9R/aHELYa3eNEcswBIxLflfY=; b=koHM+FUzJaB6GI9q5+VWQUEPf
        sJ4B2Z/3JovvubTp35tp0Pa/XFvJ4IFtKEsGpN8oXxSVK4dZZSG9LesYbTD8YSxuFzScRrBdl1DDX
        jxlbN5El8fEjFKHjvX0hr8pIm4He3Sbxo2VXkmQAKQ6hl/qLIubSiqf5/3szw8ngYc5t05Fk/4dYf
        ++k+QrtScw6s2jfBb8FnJBTomu/kVMv/DaxAViPKZq1yPrW2OQsP6awUTqGSJ3KMay3A1TLJ3OFBe
        RLXLE5sWYvfDNSYpoKKKsUXuFZvrjJSHgi61kfEeXhCdifhmg1fvpYMAXDNBUj26MsKwha3IzzicN
        Vk0MtROYg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41730)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kmxW1-0002In-Fo; Wed, 09 Dec 2020 11:20:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kmxW1-0006yq-9G; Wed, 09 Dec 2020 11:20:13 +0000
Date:   Wed, 9 Dec 2020 11:20:13 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: sfp: VSOL V2801F / CarlitoxxPro
 CPGOS03-0490 v2.0 workaround
Message-ID: <20201209112013.GS1551@shell.armlinux.org.uk>
References: <20201204143451.GL1551@shell.armlinux.org.uk>
 <E1klCB8-0001sW-Ma@rmk-PC.armlinux.org.uk>
 <20201204153152.GC2400258@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204153152.GC2400258@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 04:31:52PM +0100, Andrew Lunn wrote:
> > +/* Some modules (Nokia 3FE46541AA) lock up if byte 0x51 is read as a
> > + * single read. Switch back to reading 16 byte blocks unless we have
> > + * a CarlitoxxPro module (rebranded VSOL V2801F). Even more annoyingly,
> > + * some VSOL V2801F have the vendor name changed to OEM.
> 
> Hi Russell
> 
> I guess it is more likely, the vendor name has not been changed _from_
> OEM.

That is very unclear what happened: it seems older dated modules used
VSOL and later ones use OEM, so I think the way I describe it is
likely accurate from what we can observe.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
