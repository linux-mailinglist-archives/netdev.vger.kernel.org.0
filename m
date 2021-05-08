Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834FA377391
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 20:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhEHSP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 14:15:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59588 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhEHSP5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 May 2021 14:15:57 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lfRTS-003IBt-3T; Sat, 08 May 2021 20:14:46 +0200
Date:   Sat, 8 May 2021 20:14:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "Jisheng.Zhang@synaptics.com" <Jisheng.Zhang@synaptics.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH V4 net] net: stmmac: Fix MAC WoL not working if PHY does
 not support WoL
Message-ID: <YJbVFphLjG0U3c9Q@lunn.ch>
References: <20210506050658.9624-1-qiangqing.zhang@nxp.com>
 <20210506175522.49a2ad5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DB8PR04MB6795107C0B25B2E199FE0A0EE6579@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210507154624.31186614@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210507154624.31186614@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 07, 2021 at 03:46:24PM -0700, Jakub Kicinski wrote:
> On Fri, 7 May 2021 10:59:12 +0000 Joakim Zhang wrote:
> > > On Thu,  6 May 2021 13:06:58 +0800 Joakim Zhang wrote:  
> > > > Both get and set WoL will check device_can_wakeup(), if MAC supports
> > > > PMT, it will set device wakeup capability. After commit 1d8e5b0f3f2c ("net:
> > > > stmmac: Support WOL with phy"), device wakeup capability will be
> > > > overwrite in stmmac_init_phy() according to phy's Wol feature. If phy
> > > > doesn't support WoL, then MAC will lose wakeup capability.  
> > > 
> > > Let's take a step back. Can we get a minimal fix for losing the config in
> > > stmmac_init_phy(), and then extend the support for WoL for devices which do
> > > support wake up themselves?  
> > 
> > Sure, please review the V1, I think this is a minimal fix, then we
> > can extend this as a new feature.
> > https://www.spinics.net/lists/netdev/msg733531.html
> 
> Something like that, yes (you can pull the get_wol call into the same
> if block).
> 
> Andrew, would that be acceptable to you?

A minimal fix for stable is good.

  Andrew
