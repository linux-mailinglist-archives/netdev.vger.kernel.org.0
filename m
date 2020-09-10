Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE834264CFD
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 20:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgIJScL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:32:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55876 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726853AbgIJScG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 14:32:06 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kGRMQ-00E6zh-Hd; Thu, 10 Sep 2020 20:31:54 +0200
Date:   Thu, 10 Sep 2020 20:31:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 6/7] net: phy: marvell: add support
 for LEDs controlled by Marvell PHYs
Message-ID: <20200910183154.GF3354160@lunn.ch>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909162552.11032-7-marek.behun@nic.cz>
 <20200910122341.GC7907@duo.ucw.cz>
 <20200910131541.GD3316362@lunn.ch>
 <20200910182434.GA22845@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200910182434.GA22845@duo.ucw.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 08:24:34PM +0200, Pavel Machek wrote:
> On Thu 2020-09-10 15:15:41, Andrew Lunn wrote:
> > On Thu, Sep 10, 2020 at 02:23:41PM +0200, Pavel Machek wrote:
> > > On Wed 2020-09-09 18:25:51, Marek Behún wrote:
> > > > This patch adds support for controlling the LEDs connected to several
> > > > families of Marvell PHYs via the PHY HW LED trigger API. These families
> > > > are: 88E1112, 88E1121R, 88E1240, 88E1340S, 88E1510 and 88E1545. More can
> > > > be added.
> > > > 
> > > > This patch does not yet add support for compound LED modes. This could
> > > > be achieved via the LED multicolor framework.
> > > > 
> > > > Settings such as HW blink rate or pulse stretch duration are not yet
> > > > supported.
> > > > 
> > > > Signed-off-by: Marek Behún <marek.behun@nic.cz>
> > > 
> > > I suggest limiting to "useful" hardware modes, and documenting what
> > > those modes do somewhere.
> > 
> > I think to keep the YAML DT verification happy, they will need to be
> > listed in the marvell PHY binding documentation.
> 
> Well, this should really go to the sysfs documenation. Not sure what
> to do with DT.

In DT you can set how you want the LED to blink by default. I expect
that will be the most frequent use cases, and nearly nobody will
change it at runtime.

> But perhaps driver can set reasonable defaults without DT input?

Generally the driver will default to the hardware reset blink
pattern. There are a few PHY drivers which change this at probe, but
not many. The silicon defaults are pretty good.

    Andrew
