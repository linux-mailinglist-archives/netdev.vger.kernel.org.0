Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CDF1C9859
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 19:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgEGRwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 13:52:01 -0400
Received: from muru.com ([72.249.23.125]:53490 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbgEGRwB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 13:52:01 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id CCE4480CD;
        Thu,  7 May 2020 17:52:49 +0000 (UTC)
Date:   Thu, 7 May 2020 10:51:58 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     Philippe Schenker <philippe.schenker@toradex.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH next] ARM: dts: am57xx: fix networking on boards with
 ksz9031 phy
Message-ID: <20200507175158.GW37466@atomide.com>
References: <20200506191124.31569-1-grygorii.strashko@ti.com>
 <eab549aed345683a3ee79835369169c99e003488.camel@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eab549aed345683a3ee79835369169c99e003488.camel@toradex.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Philippe Schenker <philippe.schenker@toradex.com> [200507 08:43]:
> On Wed, 2020-05-06 at 22:11 +0300, Grygorii Strashko wrote:
> > Since commit bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for
> > the
> > KSZ9031 PHY") the networking is broken on boards:
> >  am571x-idk
> >  am572x-idk
> >  am574x-idk
> >  am57xx-beagle-x15
> > 
> > All above boards have phy-mode = "rgmii" and this is worked before
> > because
> > KSZ9031 PHY started with default RGMII internal delays configuration
> > (TX
> > off, RX on 1.2 ns) and MAC provided TX delay. After above commit, the
> > KSZ9031 PHY starts handling phy mode properly and disables RX delay,
> > as
> > result networking is become broken.
> > 
> > Fix it by switching to phy-mode = "rgmii-rxid" to reflect previous
> > behavior.
> > 
> > Cc: Oleksij Rempel <o.rempel@pengutronix.de>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Philippe Schenker <philippe.schenker@toradex.com>
> > Fixes: commit bcf3440c6dd7 ("net: phy: micrel: add phy-mode support
> > for the KSZ9031 PHY")
> > Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> Thanks Grygorii!
> 
> Reviewed-by: Philippe Schenker <
> philippe.schenker@toradex.com>

Thanks applying this into fixes.

Tony
