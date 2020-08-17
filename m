Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8976247458
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 21:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392023AbgHQTIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 15:08:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57768 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404136AbgHQTIX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 15:08:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k7kUX-009m7Y-8j; Mon, 17 Aug 2020 21:08:21 +0200
Date:   Mon, 17 Aug 2020 21:08:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 0/7] net: dsa: mv88e6xxx: Add devlink regions
 support
Message-ID: <20200817190821.GE2291654@lunn.ch>
References: <20200816194316.2291489-1-andrew@lunn.ch>
 <021a1883-0f6e-d8ab-49b4-bb85973540f8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <021a1883-0f6e-d8ab-49b4-bb85973540f8@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 17, 2020 at 10:08:07AM -0700, Florian Fainelli wrote:
> On 8/16/20 12:43 PM, Andrew Lunn wrote:
> > Make use of devlink regions to allow read access to some of the
> > internal of the switches. The switch itself will never trigger a
> > region snapshot, it is assumed it is performed from user space as
> > needed.
> > 
> > Andrew Lunn (7):
> >   net: dsa: Add helper to convert from devlink to ds
> >   net: dsa: Add devlink regions support to DSA
> >   net: dsa: mv88e6xxx: Move devlink code into its own file
> >   net: dsa: mv88e6xxx: Create helper for FIDs in use
> >   net: dsa: mv88e6xxx: Add devlink regions
> >   net: dsa: wire up devlink info get
> >   net: dsa: mv88e6xxx: Implement devlink info get callback
> 
> Andrew, do you mind copying all DSA maintainers on this patch series
> since it potentially affects other drivers given the standard
> representation you want to see adopted?

Hi Florian

I'm not proposing anything standard at all here. This is all specific
to the mv88e6xxx. As i pointed out to Vladimir, devlink regions are
supposed to be very device or driver specific.

	 Andrew

