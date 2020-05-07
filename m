Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72211C985E
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 19:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgEGRwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 13:52:22 -0400
Received: from muru.com ([72.249.23.125]:53506 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgEGRwW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 13:52:22 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id B2F2680CD;
        Thu,  7 May 2020 17:53:10 +0000 (UTC)
Date:   Thu, 7 May 2020 10:52:19 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     Philippe Schenker <philippe.schenker@toradex.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH v2] ARM: dts: am437x: fix networking on boards with
 ksz9031 phy
Message-ID: <20200507175219.GX37466@atomide.com>
References: <20200507151244.24218-1-grygorii.strashko@ti.com>
 <91c1ba87f2dfa66e11681d2660782a2efce2615d.camel@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91c1ba87f2dfa66e11681d2660782a2efce2615d.camel@toradex.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Philippe Schenker <philippe.schenker@toradex.com> [200507 15:17]:
> On Thu, 2020-05-07 at 18:12 +0300, Grygorii Strashko wrote:
> > Since commit bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for
> > the
> > KSZ9031 PHY") the networking is broken on boards:
> >  am437x-gp-evm
> >  am437x-sk-evm
> >  am437x-idk-evm
> > 
> > All above boards have phy-mode = "rgmii" and this is worked before,
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
> Reviewed-by: Philippe Schenker <philippe.schenker@toradex.com>

Thanks applying into fixes.

Tony
