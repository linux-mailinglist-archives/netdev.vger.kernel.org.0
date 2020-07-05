Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A95214DF9
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 18:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgGEQYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 12:24:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47282 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726956AbgGEQYX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 12:24:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1js7RF-003iCT-6a; Sun, 05 Jul 2020 18:24:21 +0200
Date:   Sun, 5 Jul 2020 18:24:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH ethtool v4 0/6] ethtool(1) cable test support
Message-ID: <20200705162421.GA884423@lunn.ch>
References: <20200701010743.730606-1-andrew@lunn.ch>
 <20200705004447.ook7vkzffa5ejb2v@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200705004447.ook7vkzffa5ejb2v@lion.mk-sys.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 05, 2020 at 02:44:47AM +0200, Michal Kubecek wrote:
> On Wed, Jul 01, 2020 at 03:07:37AM +0200, Andrew Lunn wrote:
> > Add the user space side of the ethtool cable test.
> > 
> > The TDR output is most useful when fed to some other tool which can
> > visualize the data. So add JSON support, by borrowing code from
> > iproute2.
> > 
> > v2:
> > man page fixes.
> > 
> > v3:
> > More man page fixes.
> > Use json_print from iproute2.
> > 
> > v4:
> > checkpatch cleanup
> > ethtool --cable-test dev
> > Place breakout into cable_test_context
> > Remove Pair: Pair output
> 
> Hello Andrew,
> 
> could you please test this update of netlink/desc-ethtool.c on top of
> your series? The userspace messages look as expected but I'm not sure if
> I have a device with cable test support available to test pretty
> printing of kernel messages. (And even if I do, I almost certainly won't
> have physical access to it.)

Hi Michal

Currently there are three PHY drivers with support: Marvell, Atheros
at803x, and bcm54140. And you can do some amount of testing without
physical access, you can expect the test results to indicate the cable
is O.K.

However, i will give these a go.

Some sort of capture and reply would be interesting for this, and for
regression testing. The ability to do something like

ethtool --monitor -w test.cap

To dump the netlink socket data to a file,  and

ethtool --monitor -r test.cap

to read from the file and decode its contents. Maybe this is already
possible via nlmon?

	 Andrew
