Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C2B27B786
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgI1XNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:13:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60412 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725272AbgI1XNB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 19:13:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kN1Iw-00Gb6l-Eo; Tue, 29 Sep 2020 00:07:30 +0200
Date:   Tue, 29 Sep 2020 00:07:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
Message-ID: <20200928220730.GD3950513@lunn.ch>
References: <20200926210632.3888886-1-andrew@lunn.ch>
 <20200926210632.3888886-2-andrew@lunn.ch>
 <20200928143155.4b12419d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200928220507.olh77t464bqsc4ll@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928220507.olh77t464bqsc4ll@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 10:05:08PM +0000, Vladimir Oltean wrote:
> On Mon, Sep 28, 2020 at 02:31:55PM -0700, Jakub Kicinski wrote:
> > On Sat, 26 Sep 2020 23:06:26 +0200 Andrew Lunn wrote:
> > > Not all ports of a switch need to be used, particularly in embedded
> > > systems. Add a port flavour for ports which physically exist in the
> > > switch, but are not connected to the front panel etc, and so are
> > > unused.
> >
> > This is missing the explanation of why reporting such ports makes sense.
> 
> Because this is a core devlink patch, we're talking really generalistic
> here.

Hi Vladimir

I don't think Jakub is questioning the why. He just wants it in the
commit message.

       Andrew
