Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF462C11F4
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 18:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390279AbgKWRaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 12:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730399AbgKWRaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 12:30:11 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC55BC0613CF;
        Mon, 23 Nov 2020 09:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+n9i9tL/XgZYnHTbCrgihSYQKPtV9aa5qeJPtl96feU=; b=GAwYE8MfGMdZHxTUgeLNypn3X
        jU/KEpqq2rNd7Owy/IEi9qASrORvEph9WgK6OWsy6c/Sc0UlFUgWLNp8IuKHCpgsVKT57HWMqiVrG
        JZDh9DDrJL3LJtiMPD80vK8gF2BdZuJNu3g4DAYUesrzoihNUshtGmrhw7kScs3bYKu/l3dFaygKF
        7pD8exxWX8vmJ2OMR0AAnQhXmqJ5lAeH0q8lec1vEe5Sm7wicJzfyrhqpVkulFGLHGeIS6WuVQaYo
        gPcPINBvJCvvVyUAzrhN94oJPkJyz2gIJCxykbOV0GdPBVpmZyWKQbAEMMIOU2qyt5alLXBRWOUlF
        bt70fEn0Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35150)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1khFfD-0006N9-US; Mon, 23 Nov 2020 17:30:07 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1khFfB-0006VA-5Q; Mon, 23 Nov 2020 17:30:05 +0000
Date:   Mon, 23 Nov 2020 17:30:05 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [EXT] Re: [PATCH v1] net: mvpp2: divide fifo for dts-active
 ports only
Message-ID: <20201123173005.GY1551@shell.armlinux.org.uk>
References: <1606143160-25589-1-git-send-email-stefanc@marvell.com>
 <20201123151049.GV1551@shell.armlinux.org.uk>
 <CO6PR18MB3873522226E3F9A608371289B0FC0@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20201123153332.GW1551@shell.armlinux.org.uk>
 <CO6PR18MB3873B4205ECAF2383F9539CCB0FC0@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20201123155148.GX1551@shell.armlinux.org.uk>
 <CO6PR18MB3873FC445787E395CCB710E4B0FC0@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB3873FC445787E395CCB710E4B0FC0@CO6PR18MB3873.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 04:03:00PM +0000, Stefan Chulski wrote:
> > -----Original Message-----
> > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > Sent: Monday, November 23, 2020 5:52 PM
> > To: Stefan Chulski <stefanc@marvell.com>
> > Cc: netdev@vger.kernel.org; thomas.petazzoni@bootlin.com;
> > davem@davemloft.net; Nadav Haklai <nadavh@marvell.com>; Yan Markman
> > <ymarkman@marvell.com>; linux-kernel@vger.kernel.org; kuba@kernel.org;
> > mw@semihalf.com; andrew@lunn.ch
> > Subject: Re: [EXT] Re: [PATCH v1] net: mvpp2: divide fifo for dts-active ports
> > only
> > 
> > On Mon, Nov 23, 2020 at 03:44:05PM +0000, Stefan Chulski wrote:
> > > Yes, but this allocation exists also in current code.
> > > From HW point of view(MAC and PPv2) maximum supported speed in CP110:
> > > port 0 - 10G, port 1 - 2.5G, port 2 - 2.5G.
> > > in CP115: port 0 - 10G, port 1 - 5G, port 2 - 2.5G.
> > >
> > > So this allocation looks correct at least for CP115.
> > > Problem that we cannot reallocate FIFO during runtime, after specific speed
> > negotiation.
> > 
> > We could do much better. DT has a "max-speed" property for ethernet
> > controllers. If we have that property, then I think we should use that to
> > determine the initialisation time FIFO allocation.
> > 
> > As I say, on Macchiatobin, the allocations we end up with are just crazy when
> > you consider the port speeds that the hardware supports.
> > Maybe that should be done as a follow-on patch - but I think it needs to be
> > done.
> 
> I agree with you. We can use "max-speed" for better FIFO allocations.
> I plan to upstream more fixes from the "Marvell" devel branch then I can prepare this patch.
> So you OK with this patch and then follow-on improvement?

Yes - but I would like to see the commit description say that this
results in no change the situation where all three ports are in use.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
