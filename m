Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718F82CCDB1
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729693AbgLCEBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:01:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35522 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727449AbgLCEBH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 23:01:07 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkfn7-009ycf-D8; Thu, 03 Dec 2020 05:00:25 +0100
Date:   Thu, 3 Dec 2020 05:00:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grant Edwards <grant.b.edwards@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: net: macb: fail when there's no PHY
Message-ID: <20201203040025.GB2333853@lunn.ch>
References: <20170921195905.GA29873@grante>
 <66c0a032-4d20-69f1-deb4-6c65af6ec740@gmail.com>
 <CAK=1mW6Gti0QpUjirB6PfMCiQvnDjkbb56pVKkQmpCSkRU6wtA@mail.gmail.com>
 <6a9c1d4a-ed73-3074-f9fa-158c697c7bfe@gmail.com>
 <X8fb4zGoxcS6gFsc@grante>
 <20201202183531.GJ2324545@lunn.ch>
 <rq8p74$2l0$1@ciao.gmane.io>
 <20201202211134.GM2324545@lunn.ch>
 <rq9ki2$uqk$1@ciao.gmane.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rq9ki2$uqk$1@ciao.gmane.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 03:03:30AM -0000, Grant Edwards wrote:
> On 2020-12-02, Andrew Lunn <andrew@lunn.ch> wrote:
> 
> >>> So it will access the MDIO bus of the PHY that is attached to the
> >>> MAC.
> >>
> >> If that's the case, wouldn't the ioctl() calls "just work" even when
> >> only the fixed-phy mdio bus and fake PHY are declared in the device
> >> tree?
> >
> > The fixed-link PHY is connected to the MAC. So the IOCTL calls will be
> > made to the fixed-link fake MDIO bus.
> 
> Ah! When you said "the PHY that is attached to the MAC" above, I
> thought you meant electrically attached to the MAC via the mdio bus.

Ah, sorry. phylib and phylink have API calls to connect a MAC and a
PHY. phylink_connect_phy(), phy_connect(). I was thinking in those
terms. But if you don't know you way around this subsystem, the
misunderstanding is understanding.

	 Andrew
