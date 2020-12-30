Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF412E7B87
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 18:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgL3RS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 12:18:26 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44806 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbgL3RSZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 12:18:25 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kuf6T-00F3tD-Jn; Wed, 30 Dec 2020 18:17:41 +0100
Date:   Wed, 30 Dec 2020 18:17:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] net: sfp: assume that LOS is not implemented if both
 LOS normal and inverted is set
Message-ID: <X+y2NZ4LFy31aZ6M@lunn.ch>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-4-pali@kernel.org>
 <20201230161310.GT1551@shell.armlinux.org.uk>
 <20201230165758.jqezvxnl44cvvodw@pali>
 <20201230170623.GV1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201230170623.GV1551@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 05:06:23PM +0000, Russell King - ARM Linux admin wrote:
> On Wed, Dec 30, 2020 at 05:57:58PM +0100, Pali Rohár wrote:
> > On Wednesday 30 December 2020 16:13:10 Russell King - ARM Linux admin wrote:
> > > On Wed, Dec 30, 2020 at 04:47:54PM +0100, Pali Rohár wrote:
> > > > Some GPON SFP modules (e.g. Ubiquiti U-Fiber Instant) have set both
> > > > SFP_OPTIONS_LOS_INVERTED and SFP_OPTIONS_LOS_NORMAL bits in their EEPROM.
> > > > 
> > > > Such combination of bits is meaningless so assume that LOS signal is not
> > > > implemented.
> > > > 
> > > > This patch fixes link carrier for GPON SFP module Ubiquiti U-Fiber Instant.
> > > > 
> > > > Co-developed-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > 
> > > No, this is not co-developed. The patch content is exactly what _I_
> > > sent you, only the commit description is your own.
> > 
> > Sorry, in this case I misunderstood usage of this Co-developed-by tag.
> > I will remove it in next iteration of patches.
> 
> You need to mark me as the author of the code at the very least...

Hi Pali

You also need to keep your own Signed-off-by, since the patch is
coming through you.

So basically, git commit --am --author="Russell King <rmk+kernel@armlinux.org.uk>"
and then two Signed-off-by: lines.

   Andrew
