Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E3D290D12
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 23:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409680AbgJPVDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 17:03:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60368 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392011AbgJPVDf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 17:03:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTWsg-0023ZU-0v; Fri, 16 Oct 2020 23:03:18 +0200
Date:   Fri, 16 Oct 2020 23:03:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kernel test robot <lkp@intel.com>,
        Christian Eggers <ceggers@arri.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        kbuild-all@lists.01.org,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: point out the tail taggers
Message-ID: <20201016210318.GL139700@lunn.ch>
References: <20201016162800.7696-1-ceggers@arri.de>
 <202010170153.fwOuks52-lkp@intel.com>
 <20201016173317.4ihhiamrv5w5am6y@skbuf>
 <20201016201428.GI139700@lunn.ch>
 <20201016201930.2i2lw4aixklyg6j7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016201930.2i2lw4aixklyg6j7@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 11:19:30PM +0300, Vladimir Oltean wrote:
> On Fri, Oct 16, 2020 at 10:14:28PM +0200, Andrew Lunn wrote:
> > On Fri, Oct 16, 2020 at 08:33:17PM +0300, Vladimir Oltean wrote:
> > > On Sat, Oct 17, 2020 at 01:25:08AM +0800, kernel test robot wrote:
> > > > Hi Christian,
> > > >
> > > > Thank you for the patch! Yet something to improve:
> > > >
> > > > [auto build test ERROR on net/master]
> > > >
> > > > url:    https://github.com/0day-ci/linux/commits/Christian-Eggers/net-dsa-point-out-the-tail-taggers/20201017-003007
> > > > base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 2ecbc1f684482b4ed52447a39903bd9b0f222898
> > 
> > > Is the test bot being a bit "slow" today?
> > 
> > It is using the net.git commit from yesterday afternoon. net-next got
> > merged into net yesterday evening, so it is a bit behind, but not too
> > far behind.
> 
> Exactly. The sha1sum it uses _does_ contain the tail_tag member inside
> struct dsa_device_ops. What's it complaining about?

2ecbc1f684482b4ed52447a39903bd9b0f222898 does not have net-next, as
far as i see, and tail_tag only hit net when net-next was merged into
net.

Or i'm reading the git history wrong.

	Andrew
