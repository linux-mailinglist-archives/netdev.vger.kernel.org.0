Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5825022C955
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 17:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgGXPer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 11:34:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53932 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbgGXPer (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 11:34:47 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jyzif-006h4x-1L; Fri, 24 Jul 2020 17:34:45 +0200
Date:   Fri, 24 Jul 2020 17:34:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andre.Edich@microchip.com
Cc:     Parthiban.Veerasooran@microchip.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, steve.glendinning@shawell.net
Subject: Re: [PATCH net-next v2 3/6] smsc95xx: add PAL support to use
 external PHY drivers
Message-ID: <20200724153445.GG1594328@lunn.ch>
References: <20200723115507.26194-1-andre.edich@microchip.com>
 <20200723115507.26194-4-andre.edich@microchip.com>
 <20200723223956.GL1553578@lunn.ch>
 <c2cb789ac1beebc5c337e97c05e462202d19abcf.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2cb789ac1beebc5c337e97c05e462202d19abcf.camel@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +static void smsc95xx_handle_link_change(struct net_device *net)
> > > +{
> > > +     phy_print_status(net->phydev);
> > 
> > So the MAC does not care about the speed? The pause configuration?
> > Duplex?
> 
> Now, I'm wondering how those "care about speed", "pause", and "duplex"
> work in the current smsc95xx.  I guess, we did not touch any of those
> activities with our patches.

Yes, this patchset itself is not necessarily wrong. It seems more like
the driver could be broken with respect to these things. It is
something you might want to put on your TODO list to look at later.

	  Andrew
