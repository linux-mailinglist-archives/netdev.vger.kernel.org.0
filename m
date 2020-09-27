Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDD4279D2E
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 02:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgI0AdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 20:33:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57536 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgI0AdF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 20:33:05 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMKcg-00GKo9-EB; Sun, 27 Sep 2020 02:33:02 +0200
Date:   Sun, 27 Sep 2020 02:33:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
Message-ID: <20200927003302.GB3889809@lunn.ch>
References: <20200926210632.3888886-1-andrew@lunn.ch>
 <20200926210632.3888886-2-andrew@lunn.ch>
 <20200926220034.ols6bayu73ae7in6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926220034.ols6bayu73ae7in6@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 27, 2020 at 01:00:34AM +0300, Vladimir Oltean wrote:
> On Sat, Sep 26, 2020 at 11:06:26PM +0200, Andrew Lunn wrote:
> > Not all ports of a switch need to be used, particularly in embedded
> > systems. Add a port flavour for ports which physically exist in the
> > switch, but are not connected to the front panel etc, and so are
> > unused.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> 
> You also have an iproute2 patch prepared, right?

https://github.com/lunn/iproute2 port-regions

	 Andrew
 
