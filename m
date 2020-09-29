Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB3A27D7BB
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgI2ULB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:11:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34378 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728884AbgI2ULA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 16:11:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNLxY-00Gno4-QO; Tue, 29 Sep 2020 22:10:48 +0200
Date:   Tue, 29 Sep 2020 22:10:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Radu-andrei Bulie <radu-andrei.bulie@nxp.com>,
        "fido_max@inbox.ru" <fido_max@inbox.ru>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v2 devicetree 2/2] powerpc: dts: t1040rdb: add ports for
 Seville Ethernet switch
Message-ID: <20200929201048.GG3996795@lunn.ch>
References: <20200929113209.3767787-1-vladimir.oltean@nxp.com>
 <20200929113209.3767787-3-vladimir.oltean@nxp.com>
 <20200929191153.GF3996795@lunn.ch>
 <20200929193953.rgibttgt6lh5huef@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929193953.rgibttgt6lh5huef@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 07:39:54PM +0000, Vladimir Oltean wrote:
> On Tue, Sep 29, 2020 at 09:11:53PM +0200, Andrew Lunn wrote:
> > > +&seville_port0 {
> > > +	managed = "in-band-status";
> > > +	phy-handle = <&phy_qsgmii_0>;
> > > +	phy-mode = "qsgmii";
> > > +	/* ETH4 written on chassis */
> > > +	label = "swp4";
> >
> > If ETH4 is on the chassis why not use ETH4?
> 
> You mean all-caps, just like that?

Yes.

DSA is often used in WiFI access point, etc. The user is not a
computer professional. If the WebGUI says ETH4, and the label on the
front says ETH4, they probably think the two are the same, and are
happy.

I have one box which does not have an labels on the front panels, but
the industrial sockets for Ethernet are colour coded. So the interface
names are red, blue, green, to match the socket colour, and the cable
set is also colour coded the same.

So long as it is unique, the kernel does not care. So make it easy for
the user.

    Andrew

