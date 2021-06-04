Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D613E39BEE0
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 19:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhFDRee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 13:34:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230185AbhFDRee (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 13:34:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 743ED61400;
        Fri,  4 Jun 2021 17:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622827967;
        bh=a5isDehEudac8CyR2HZE1gI9Wve6E9W6CiVt055MqQI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oxwiF4nZxQ/b7p8BNP/PiIQXi+nFKiMXwGXug/6MEsZ6c41FePwwtM7mqcB7KViyq
         rFTdSJGYKWUDkg4CL+tWbpAb8pYvbDdnBJ4mckYht5plojekusly9vfUpWIgdBJ7KC
         FRb01Oi09iHmr1pe4hVKD4Ye3DNlKFLYDWxPbU66N/skaboEQkSHf+xUEpqNA313Xc
         Il6Ywgnr/Ftta+jZ+n+FwxYPtLjDlJ+ENr0Te4dSIU5tSgxpmeJ9+fSBw9Fvw8CvwP
         kCHZ1HGCchNOvnukeKkSeZGc/Wla+hQnzNolCjGWuXAO5egR08CKUMCUzm+wRXvQU1
         ohJmjn0VGkZKw==
Received: by pali.im (Postfix)
        id 1ED85990; Fri,  4 Jun 2021 19:32:45 +0200 (CEST)
Date:   Fri, 4 Jun 2021 19:32:44 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Madalin Bucur <madalin.bucur@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Igal Liberman <Igal.Liberman@freescale.com>,
        Shruti Kanetkar <Shruti@freescale.com>,
        Emil Medve <Emilian.Medve@freescale.com>,
        Scott Wood <oss@buserror.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>
Subject: Re: Unsupported phy-connection-type sgmii-2500 in
 arch/powerpc/boot/dts/fsl/t1023rdb.dts
Message-ID: <20210604173244.qonw5wsn3pq6gyjf@pali>
References: <20210603143453.if7hgifupx5k433b@pali>
 <YLjxX/XPDoRRIvYf@lunn.ch>
 <20210603194853.ngz4jdso3kfncnj4@pali>
 <AM6PR04MB3976B62084EC462BA02F0C4CEC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AM6PR04MB3976B62084EC462BA02F0C4CEC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On Friday 04 June 2021 07:35:33 Madalin Bucur wrote:
> > -----Original Message-----
> > From: Pali Rohár <pali@kernel.org>
> > Sent: 03 June 2021 22:49
> > To: Andrew Lunn <andrew@lunn.ch>
> > Cc: Igal Liberman <Igal.Liberman@freescale.com>; Shruti Kanetkar
> > <Shruti@freescale.com>; Emil Medve <Emilian.Medve@freescale.com>; Scott
> > Wood <oss@buserror.net>; Rob Herring <robh+dt@kernel.org>; Michael
> > Ellerman <mpe@ellerman.id.au>; Benjamin Herrenschmidt
> > <benh@kernel.crashing.org>; Madalin Bucur <madalin.bucur@nxp.com>; Russell
> > King <rmk+kernel@armlinux.org.uk>; netdev@vger.kernel.org;
> > devicetree@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: Unsupported phy-connection-type sgmii-2500 in
> > arch/powerpc/boot/dts/fsl/t1023rdb.dts
> > 
> > On Thursday 03 June 2021 17:12:31 Andrew Lunn wrote:
> > > On Thu, Jun 03, 2021 at 04:34:53PM +0200, Pali Rohár wrote:
> > > > Hello!
> > > >
> > > > In commit 84e0f1c13806 ("powerpc/mpc85xx: Add MDIO bus muxing support
> > to
> > > > the board device tree(s)") was added following DT property into DT
> > node:
> > > > arch/powerpc/boot/dts/fsl/t1023rdb.dts fm1mac3: ethernet@e4000
> > > >
> > > >     phy-connection-type = "sgmii-2500";
> > > >
> > > > But currently kernel does not recognize this "sgmii-2500" phy mode.
> > See
> > > > file include/linux/phy.h. In my opinion it should be "2500base-x" as
> > > > this is mode which operates at 2.5 Gbps.
> > > >
> > > > I do not think that sgmii-2500 mode exist at all (correct me if I'm
> > > > wrong).
> > >
> > > Kind of exist, unofficially. Some vendors run SGMII over clocked at
> > > 2500. But there is no standard for it, and it is unclear how inband
> > > signalling should work. Whenever i see code saying 2.5G SGMII, i
> > > always ask, are you sure, is it really 2500BaseX? Mostly it gets
> > > changed to 2500BaseX after review.
> > 
> > So this is question for authors of that commit 84e0f1c13806. But it
> > looks like I cannot send them emails because of following error:
> > 
> > <Minghuan.Lian@freescale.com>: connect to freescale.com[192.88.156.33]:25:
> > Connection timed out
> > 
> > Do you have other way how to contact maintainers of that DTS file?
> > arch/powerpc/boot/dts/fsl/t1023rdb.dts
> > 
> > > PHY mode sgmii-2500 does not exist in mainline.
> > 
> > Yes, this is reason why I sent this email. In DTS is specified this mode
> > which does not exist.
> > 
> > > 	Andrew
> 
> Hi, the Freescale emails no longer work, years after Freescale joined NXP.
> Also, the first four recipients no longer work for NXP.
> 
> In regards to the sgmii-2500 you see in the device tree, it describes SGMII
> overclocked to 2.5Gbps, with autonegotiation disabled. 
> 
> A quote from a long time ago, from someone from the HW team on this:
> 
> 	The industry consensus is that 2.5G SGMII is overclocked 1G SGMII
> 	using XAUI electricals. For the PCS and MAC layers, it looks exactly
> 	like 1G SGMII, just with a faster clock.

SGMII supports 1 Gbps speed and also 100 / 10 Mbps by repeating frame 10
or 100 times.

So... if this HW has 2.5G SGMII (sgmii-2500) as 2.5x overclocked SGMII,
does it mean that 2.5G SGMII supports 25 Mbps and 250 Mbps speeds by
repeating frame 10 and 100 times (like for 1G SGMII)?

> The statement that it does not exist is not accurate, it exists in HW, and
> it is described as such in the device tree. Whether or not it is properly
> treated in SW it's another discussion. In 2015, when this was submitted,
> there were no other 2.5G compatibles in use, if I'm not mistaken.

Yea, I understand. If at that time there was no sw support, "something"
was chosen.

> 2500Base-X started to be added to device trees four years later, it should
> be compatible/interworking but it is less specific on the actual implementation
> details (denotes 2.5G speed, 8b/10b coding, which is true for this overclocked
> SGMII). If they are compatible, SW should probably treat them in the same manner.

1000base-x and SGMII are not same modes. E.g. SGMII support 10 Mbps
while 1000base-x not. So in my opinion 1000base-x and SGMII should not
be treated as the same mode (in SW).

I'm not sure how what exactly SGMII-2500 supports, but as 2500base-x
does not support 25 Mbps speed I do not think that SGMII-2500 is same as
2500base-x.

But now I'm totally confused by all these modes, so I hope that somebody
else tries to explain what kernel expects and how kernel treats these
modes.

> There were some discussions a while ago about the mix or even confusion between
> the actual HW description (that's what the dts is supposed to do) and the settings
> one wants to represent in SW (i.e. speed) denoted loosely by denominations like
> 10G Base-R. 
> 
> Regards,
> Madalin
