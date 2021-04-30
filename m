Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000C036FEFA
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 18:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhD3Q5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 12:57:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48256 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229750AbhD3Q5C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 12:57:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lcWQw-001q8G-Hb; Fri, 30 Apr 2021 18:56:06 +0200
Date:   Fri, 30 Apr 2021 18:56:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH net-next v1 1/1] net: selftest: provide option to disable
 generic selftests
Message-ID: <YIw2pkVPb69f3rsm@lunn.ch>
References: <20210430095308.14465-1-o.rempel@pengutronix.de>
 <f0905c84-6bb2-702f-9ae7-614dcd85c458@infradead.org>
 <20210430154153.zhdnxzkm2fhcuogo@pengutronix.de>
 <YIwu+4ywaTI4+eUq@lunn.ch>
 <6865cd7a-7f2e-13f5-a588-8877d771b834@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6865cd7a-7f2e-13f5-a588-8877d771b834@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 30, 2021 at 09:33:42AM -0700, Randy Dunlap wrote:
> On 4/30/21 9:23 AM, Andrew Lunn wrote:
> >>> Thanks for the patch/option. But I think it should just default to n,
> >>> not PHYLIB.
> >>
> >> It should be enabled by default for every device supporting this kind of
> >> selftests.
> > 
> > I agree.
> > 
> > I still wonder if there is confusion about self test here. Maybe
> 
> Probably.
> 
> > putting ethtool into the description will help people understand it
> > has nothing to do with the kernel self test infrastructure and kernel
> > self testing.
> 
> So it's a hardware check that is required to be run if it's implemented
> in a driver?
> 
> Required by who/what?

It is not required, but it is a useful debug tool for the educated
user. Root can run the self tests on the network interface. If the
self test pass, but the interface does not work, you probably have a
cabling or configuration issue. Networking is complex and being able
to eliminate the interface hardware lets you concentrate on some other
part of the problem. You can then maybe next use the cable test option
of ethtool to see if the cable has a problem.

   Andrew
