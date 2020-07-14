Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FB321F24F
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 15:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgGNNSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 09:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728075AbgGNNSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 09:18:43 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03687C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WP4jXFL4Jovu0eEUOaEb3UVu8wGCdlZ5tnf9zGVi/iw=; b=Mmx+WuWjtNVcxKRhzkeRk/AFE
        MtlHZBL2UXqjQfiW9DGfvCYTH035RdcTUUYZfzRLKpsEEvd+OP6gjhH47mLslQtLH9G8acwVlK3te
        3gc+tUbYzMLqmsbDwc3TjLiIOdUvZ1MatBoytzzs4YEEUmUp4xj9w8hbLjf1hKobQtqQm05uKnmgA
        DVvDABePYg/N1Qt2Cqc/RKQSxCYxL9UMbtLBPFJCWgcBvn0SnAvQDZFsLScTufSwOAiSCN1iI16tU
        wLKBk1gGDYsK5Vsg2Qu5/Ij49byoL0EuETnQfr8ewFopyDV9XJ5axapRFOeQTCF0AV05iBX7wdIg6
        6Rrw77Sug==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39410)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jvKpQ-0005HV-71; Tue, 14 Jul 2020 14:18:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jvKpM-0007Ko-6h; Tue, 14 Jul 2020 14:18:32 +0100
Date:   Tue, 14 Jul 2020 14:18:32 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "michael@walle.cc" <michael@walle.cc>, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH RFC net-next 00/13] Phylink PCS updates
Message-ID: <20200714131832.GC1551@shell.armlinux.org.uk>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <20200714084958.to4n52cnk32prn4v@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714084958.to4n52cnk32prn4v@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 11:49:58AM +0300, Vladimir Oltean wrote:
> Are you going to post a non-RFC version?

I'm waiting for the remaining patches to be reviewed; Florian reviewed
the first six patches (which are not the important ones in the series)
and that seems to be where things have stopped. There has been no
change, so I don't see there's much point to reposting the series.

I'd actually given up pushing this further; I've seen patches go by that
purpetuate the idea that the PCS is handled by phylib.  I feel like I'm
wasting my time with this.

> I think this series makes a lot of sense overall and is a good
> consolidation for the type of interfaces that are already established in
> Linux.
> 
> This changes the landscape of how Linux is dealing with a MAC-side
> clause 37 PCS, and should constitute a workable base even for clause 49
> PCSs when those use a clause 37 auto-negotiation system (like USXGMII
> and its various multi-port variants).

Yes.

> Where I have some doubts is a
> clause 49 PCS which uses a clause 73 auto-negotiation system, I would
> like to understand your vision of how deep phylink is going to go into
> the PMD layer, especially where it is not obvious that said layer is
> integrated with the MAC.

I have only considered up to 10GBASE-R based systems as that is the
limit of what I can practically test here.  I have one system that
offers a QSFP+ cage, and I have a QSFP+ to 4x SFP+ (10G) splitter
cable - so that's basically 4x 10GBASE-CR rather than 40GBASE-CR.

I am anticipating that clause 73 will be handled in a very similar way
to clause 37.  The clause 73 "technology ability" field defines the
capabilities of the link, but as we are finding with 10GBASE-R based
setups with copper PHYs, the capabilities of the link may not be what
we want to report to the user, especially if the copper PHY is capable
of rate adaption.  Hence, it may be possible to have a backplane link
that connects to a copper PHY that does rate adaption:

MAC <--> Clause 73 PCS <--backplane--> PHY <--base-T--> remote system

This is entirely possible from what I've seen in one NBASE-T PHY
datasheet.  The PHY is documented as being capable of negotiating a
10GBASE-KR link with the host system, while offering 10GBASE-R,
1000BASE-X, 10GBASE-T, 5GBASE-T, 2.5GBASE-T, 1GBASE-T, 100BASE-T, and
10BASE-T on the media side.  The follow-on question is whether that
PHY is likely to be accessible to the system on the other end of the
backplane link somehow - either through some kind of firmware link
or direct access.  That is not possible to know without having
experience with such systems.

That said, with the splitting of the PCS from the MAC in phylink, there
is the possibility for the PCS to be implemented as an entirely
separate driver to the MAC driver, although there needs to be some
infrastructure to make that work sanely.  Right now, it is the MAC
responsibility to attach the PCS to phylink, which is the right way
to handle it for setups where the PCS is closely tied to the MAC, such
as Marvell NETA and PP2 where the PCS is indistinguishable from the
MAC, and will likely remain so for such setups.  However, if we need
to also support entirely separate PCS, I don't see any big issues
with that now that we have this split.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
