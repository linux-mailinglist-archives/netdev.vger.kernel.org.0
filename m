Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 161F330E02
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 14:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfEaMVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 08:21:50 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:45585 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfEaMVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 08:21:50 -0400
Received: from kresse.hi.pengutronix.de ([2001:67c:670:100:1d::2a])
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <l.stach@pengutronix.de>)
        id 1hWgXa-00084d-Q2; Fri, 31 May 2019 14:21:46 +0200
Message-ID: <1559305305.2557.3.camel@pengutronix.de>
Subject: Re: [PATCH 2/2] ethtool: Add 100BaseT1 and 1000BaseT1 link modes
From:   Lucas Stach <l.stach@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, linville@redhat.com
Date:   Fri, 31 May 2019 14:21:45 +0200
In-Reply-To: <20190531115928.GA18608@lunn.ch>
References: <20190530180616.1418-1-andrew@lunn.ch>
         <20190530180616.1418-3-andrew@lunn.ch>
         <20190531093029.GD15954@unicorn.suse.cz> <20190531115928.GA18608@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::2a
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Freitag, den 31.05.2019, 13:59 +0200 schrieb Andrew Lunn:
> > > @@ -634,10 +636,14 @@ static void dump_link_caps(const char *prefix, const char *an_prefix,
> > > > > >  		  "100baseT/Half" },
> > > > > >  		{ 1, ETHTOOL_LINK_MODE_100baseT_Full_BIT,
> > > > > >  		  "100baseT/Full" },
> > > > > > +		{ 1, ETHTOOL_LINK_MODE_100baseT1_Full_BIT,
> > > > > > +		  "100baseT1/Full" },
> > > > > >  		{ 0, ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
> > > > > >  		  "1000baseT/Half" },
> > > > > >  		{ 1, ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
> > > > > >  		  "1000baseT/Full" },
> > > > > > +		{ 1, ETHTOOL_LINK_MODE_1000baseT1_Full_BIT,
> > > > > > +		  "1000baseT1/Full" },
> > > > > >  		{ 0, ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
> > > > > >  		  "1000baseKX/Full" },
> > >  		{ 0, ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
> > 
> > Does it mean that we could end up with lines like
> > 
> >                                 100baseT/Half 100baseT/Full 100baseT1/Full
> >                                 1000baseT/Full 1000baseT1/Full
> > 
> > if there is a NIC supporting both T and T1?
> 
> Hi Michal
> 
> In theory, it is possible for a PHY to support both plain T and
> T1.

That's not just theory. The Broadcom BCM54811 PHY supports both
100/1000baseT, as well as 100baseT1.

Regards,
Lucas
