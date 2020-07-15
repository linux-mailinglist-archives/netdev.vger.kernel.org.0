Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432A222094A
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 11:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730927AbgGOJxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 05:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730583AbgGOJxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 05:53:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82257C061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 02:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=e0XKqJc9GvVeCfRUye3YytvXHPQ31iTc20+UW4fyd4g=; b=GcFzuMbu1a/Uj2vre63xaTuNb
        QH2/W+vC8Z5V8/2TmZ3w5lMAPzuo6jFDHJsFAYx05r42riRynQLH5PrnLfg8umPmV8FUnHO7thU5z
        bC+j/Njys9NDoGyoWcycxRb5OGp4MXiJtzNlxZCtu/ngbPidWvjSkLFU47Kk6MIIuWQ/D6ziWu8G2
        hf81jXBGk1Rj9Cewy4hFuO3vrf6LBsp3j/tQm+jv8diPfw56LCEd6W8XudDffkE1c7FVUaNhXtVFm
        XvQv73CgGvgGQYXzmoIomDlvIMXCOAZ4XVOgNKukKXbP9DVZaLX9JVXBa+UdKjWreGC2sM9wX5N5e
        XpuP+LbOQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39762)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jve6X-0006SO-Lo; Wed, 15 Jul 2020 10:53:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jve6O-0008DH-Ug; Wed, 15 Jul 2020 10:53:24 +0100
Date:   Wed, 15 Jul 2020 10:53:24 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "michael@walle.cc" <michael@walle.cc>, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH RFC net-next 00/13] Phylink PCS updates
Message-ID: <20200715095324.GF1551@shell.armlinux.org.uk>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <20200714084958.to4n52cnk32prn4v@skbuf>
 <20200714131832.GC1551@shell.armlinux.org.uk>
 <e56160da-9a17-d69b-25f0-b564b5959377@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e56160da-9a17-d69b-25f0-b564b5959377@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 02:22:08PM -0700, Florian Fainelli wrote:
> 
> 
> On 7/14/2020 6:18 AM, Russell King - ARM Linux admin wrote:
> > On Tue, Jul 14, 2020 at 11:49:58AM +0300, Vladimir Oltean wrote:
> >> Are you going to post a non-RFC version?
> > 
> > I'm waiting for the remaining patches to be reviewed; Florian reviewed
> > the first six patches (which are not the important ones in the series)
> > and that seems to be where things have stopped. There has been no
> > change, so I don't see there's much point to reposting the series.
> 
> Sorry for giving an impression that this had stalled, I reviewed the
> obvious changes and am now reviewing the not so obvious changes, would
> certainly appreciate if other NXP folks as well as Andrew and Heiner
> looked at those changes obviously.

Thanks Florian.  Yes, it would be useful to have reviewed-bys or
acked-bys from those who are using it, and would take some of the
load off yourself, Andrew and Heiner.

It also makes sense when some of the changes to phylink are made
in response to improving things for other use cases. For example,
splitting the PCS in phylink is not something I'm doing for my own
self-interest (apart from a desire to keep phylink maintainable),
but is to support NXP's and others platforms where the PCS would
logically be a separate block of code from the MAC. So, to me it
would make sense for NXP to get involved with the review of this
set.

If anything, splitting the PCS has meant that I've had to go back
and re-examine Marvell NETA and PP2 (in fact, several times) to
adapt them to solidly test this approach and make sure I haven't
missed anything - these two drivers are my main test-bed for
phylink at the moment, they're also hardware where the PCS is
completely indistinguishable from the MAC at register level, so
you can't say "this group of registers are definitely PCS only
functions".

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
