Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276343F9239
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 04:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244018AbhH0CMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 22:12:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44202 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241128AbhH0CMG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 22:12:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CZAl2d77Ht15SARXwtHBnTj5q6I65Bl6hgGHiA77reA=; b=yWuP8aKLExX1fnPAlpWZ99iSk4
        Vc2zyl1uK02K/oiZeuNM2Dh7XomQZQhnF8DZCWtWU4irRB2YduWXHefVEucdTPzzM7/usSbvh/4sn
        gbcBWiC/zAPKgG3vEHeSAB0XZ3DGRN6Jdb/5elDwTH3sFnTGNtt8iGcbp7+l0sRgPmwo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mJRKp-0042gK-Do; Fri, 27 Aug 2021 04:11:11 +0200
Date:   Fri, 27 Aug 2021 04:11:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joel Stanley <joel@jms.id.au>
Cc:     "Gabriel L. Somlo" <gsomlo@gmail.com>,
        Florent Kermarrec <florent@enjoy-digital.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree <devicetree@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Shah <dave@ds0.me>, Stafford Horne <shorne@gmail.com>
Subject: Re: [PATCH v2 2/2] net: Add driver for LiteX's LiteEth network
 interface
Message-ID: <YShJv2XRud7pSseZ@lunn.ch>
References: <20210820074726.2860425-3-joel@jms.id.au>
 <YSVLz0Se+hTVr0DA@errol.ini.cmu.edu>
 <CACPK8Xf9LGQBUHmS9sQ4zG1akk5SoQ-31MD-GMWVSRuByAT7KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACPK8Xf9LGQBUHmS9sQ4zG1akk5SoQ-31MD-GMWVSRuByAT7KQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 06:35:17AM +0000, Joel Stanley wrote:
> On Tue, 24 Aug 2021 at 19:43, Gabriel L. Somlo <gsomlo@gmail.com> wrote:
> >
> > Hi Joel,
> >
> > Couple of comments below:
> >
> > On Fri, Aug 20, 2021 at 05:17:26PM +0930, Joel Stanley wrote:
> 
> > > diff --git a/drivers/net/ethernet/litex/Kconfig b/drivers/net/ethernet/litex/Kconfig
> > > new file mode 100644
> > > index 000000000000..265dba414b41
> > > --- /dev/null
> > > +++ b/drivers/net/ethernet/litex/Kconfig
> 
> > > +
> > > +config LITEX_LITEETH
> > > +     tristate "LiteX Ethernet support"
> >
> > Mostly cosmetic, but should there be a "depends on LITEX" statement in here?
> 
> No, there's as there is no dependency on the litex soc driver.

Which is good, you will get more build coverage that way, it will be
built of x86, arm, mips, etc...

> 
> > Maybe also "select MII" and "select PHYLIB"?
> 
> Again, there is no mii or phy code so the driver doesn't need these.

Yet.

At some point i expect you will need these, but you don't need them
now.

	Andrew
