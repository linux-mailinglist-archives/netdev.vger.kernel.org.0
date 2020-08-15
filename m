Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B7A2454D3
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbgHOWuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:50:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54852 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbgHOWuV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Aug 2020 18:50:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k750C-009WQY-KP; Sun, 16 Aug 2020 00:50:16 +0200
Date:   Sun, 16 Aug 2020 00:50:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Clemens Gruber <clemens.gruber@pqgruber.com>
Cc:     netdev <netdev@vger.kernel.org>, fugang.duan@nxp.com,
        Chris Healy <cphealy@gmail.com>,
        David Miller <davem@davemloft.net>, Dave Karr <dkarr@vyex.com>
Subject: Re: [PATCH net-next v5] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Message-ID: <20200815225016.GG2238071@lunn.ch>
References: <20200502152504.154401-1-andrew@lunn.ch>
 <20200815165556.GA503896@workstation.tuxnet>
 <20200815175349.GG2239279@lunn.ch>
 <20200815205340.GA37931@workstation.tuxnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200815205340.GA37931@workstation.tuxnet>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 15, 2020 at 10:53:40PM +0200, Clemens Gruber wrote:
> Hi Andrew,
> 
> On Sat, Aug 15, 2020 at 07:53:49PM +0200, Andrew Lunn wrote:
> > On Sat, Aug 15, 2020 at 06:55:56PM +0200, Clemens Gruber wrote:
> > > Hi,
> > > 
> > > this patch / commit f166f890c8 ("net: ethernet: fec: Replace interrupt
> > > driven MDIO with polled IO") broke networking on i.MX6Q boards with
> > > Marvell 88E1510 PHYs (Copper / 1000Base-T).
> > 
> > Hi Clemens
> > 
> > Please could you try:
> > 
> > https://www.spinics.net/lists/netdev/msg675568.html
> > 
> > 	Andrew
> 
> Thanks, this fixes it! I'll send a Tested-by in reply to the patch.

Thanks.

I think the final version will have one more change, as suggeted by
Fugang Duan.

       Andrew
