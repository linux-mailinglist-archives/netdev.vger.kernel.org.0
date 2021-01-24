Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78EA1301E61
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 20:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbhAXTM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 14:12:26 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57034 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726164AbhAXTMY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Jan 2021 14:12:24 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l3knT-002Pg1-CC; Sun, 24 Jan 2021 20:11:39 +0100
Date:   Sun, 24 Jan 2021 20:11:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: Re: [EXT] Re: [PATCH v2 RFC net-next 08/18] net: mvpp2: add FCA
 periodic timer configurations
Message-ID: <YA3GazNlINcNUBXZ@lunn.ch>
References: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
 <1611488647-12478-9-git-send-email-stefanc@marvell.com>
 <20210124121443.GU1551@shell.armlinux.org.uk>
 <CO6PR18MB3873F47DE5BD28951CC3D2E9B0BE9@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB3873F47DE5BD28951CC3D2E9B0BE9@CO6PR18MB3873.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 02:43:30PM +0000, Stefan Chulski wrote:
> > 
> > ----------------------------------------------------------------------
> > On Sun, Jan 24, 2021 at 01:43:57PM +0200, stefanc@marvell.com wrote:
> > > +/* Set Flow Control timer x140 faster than pause quanta to ensure
> > > +that link
> > > + * partner won't send taffic if port in XOFF mode.
> > 
> > Can you explain more why 140 times faster is desirable here? Why 140 times
> > and not, say, 10 times faster? Where does this figure come from, and what is
> > the reasoning? Is there a switch that requires it?
> 
> I tested with 140.
> Actually regarding to spec each quanta should be equal to 512 bit times.
> In 10G bit time is 0.1ns.

And if the link has been negotiated to 10Mbps? Or is the clock already
scaled to the link speed?

       Andrew
