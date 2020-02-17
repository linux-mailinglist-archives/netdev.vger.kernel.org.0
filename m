Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A72EB160B6F
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 08:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgBQHN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 02:13:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbgBQHN4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 02:13:56 -0500
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2AF2206D5;
        Mon, 17 Feb 2020 07:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581923635;
        bh=hNNQ7EW2DTEy+3Ocofe3DueBNLAmCBoc6dingHCT/5c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fVZSRGH/A46ZK9OhEmBwiCmZy7aHWRs4Zn4IrLm2REuJ0YHUto8JmxAC75DbtbsPm
         mJnzuehAlQ2SlmexdnrM68XDyHG7FWJQOBvSmhS7+OQB1g7a72/Nr1SCB1i7jXwdRU
         7PV386E+kMDouw7Kwfx/DQRZDK6Jm0C0AK+A0CjU=
Date:   Mon, 17 Feb 2020 15:13:50 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, wg@grandegger.com,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        Pankaj Bansal <pankaj.bansal@nxp.com>
Subject: Re: [PATCH 0/8] can: flexcan: add CAN FD support for NXP Flexcan
Message-ID: <20200217071349.GC7973@dragon>
References: <24eb5c67-4692-1002-2468-4ae2e1a6b68b@pengutronix.de>
 <20200213192027.4813-1-michael@walle.cc>
 <DB7PR04MB461896B6CC3EDC7009BCD741E6150@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <2322fb83486c678917957d9879e27e63@walle.cc>
 <DB7PR04MB46187A6B5A8EC3A1D73D69FFE6150@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <bf671072ce479049eb354d44f3617383@walle.cc>
 <DB7PR04MB46183F74C137B644A229B632E6150@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <78789949f2a9dc532ec461768fbd3a60@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <78789949f2a9dc532ec461768fbd3a60@walle.cc>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 11:02:46AM +0100, Michael Walle wrote:
> 
> Hi Joakim, Hi Shawn,
> 
> 
> Am 2020-02-14 10:56, schrieb Joakim Zhang:
> > > -----Original Message-----
> > > From: Michael Walle <michael@walle.cc>
> > > Sent: 2020年2月14日 17:33
> > > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > > Cc: Marc Kleine-Budde <mkl@pengutronix.de>; wg@grandegger.com;
> > > netdev@vger.kernel.org; linux-can@vger.kernel.org; Pankaj Bansal
> > > <pankaj.bansal@nxp.com>; Shawn Guo <shawnguo@kernel.org>
> > > Subject: Re: [PATCH 0/8] can: flexcan: add CAN FD support for NXP
> > > Flexcan
> > > 
> > > Am 2020-02-14 10:18, schrieb Joakim Zhang:
> > > > Best Regards,
> > > > Joakim Zhang
> > > >
> > > >> -----Original Message-----
> > > >> From: Michael Walle <michael@walle.cc>
> > > >> Sent: 2020年2月14日 16:43
> > > >> To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > > >> Cc: Marc Kleine-Budde <mkl@pengutronix.de>; wg@grandegger.com;
> > > >> netdev@vger.kernel.org; linux-can@vger.kernel.org; Pankaj Bansal
> > > >> <pankaj.bansal@nxp.com>
> > > >> Subject: Re: [PATCH 0/8] can: flexcan: add CAN FD support for NXP
> > > >> Flexcan
> > > >>
> > > >> Hi Joakim,
> > > >>
> > > >> Am 2020-02-14 02:55, schrieb Joakim Zhang:
> > > >> > Hi Michal,
> > > >> >
> > > >> >> -----Original Message-----
> > > >> >> From: Michael Walle <michael@walle.cc>
> > > >> >> Sent: 2020年2月14日 3:20
> > > >> >> To: Marc Kleine-Budde <mkl@pengutronix.de>
> > > >> >> Cc: Joakim Zhang <qiangqing.zhang@nxp.com>; wg@grandegger.com;
> > > >> >> netdev@vger.kernel.org; linux-can@vger.kernel.org; Pankaj Bansal
> > > >> >> <pankaj.bansal@nxp.com>; Michael Walle <michael@walle.cc>
> > > >> >> Subject: Re: [PATCH 0/8] can: flexcan: add CAN FD support for NXP
> > > >> >> Flexcan
> > > >> >>
> > > >> >> Hi,
> > > >> >>
> > > >> >> >>> Are you prepared to add back these patches as they are
> > > >> >> >>> necessary for Flexcan CAN FD? And this Flexcan CAN FD patch
> > > >> >> >>> set is based on these patches.
> > > >> >> >>
> > > >> >> >> Yes, these patches will be added back.
> > > >> >> >
> > > >> >> >I've cleaned up the first patch a bit, and pushed everything to
> > > >> >> >the testing branch. Can you give it a test.
> > > >> >>
> > > >> >> What happend to that branch? FWIW I've just tried the patches on a
> > > >> >> custom board with a LS1028A SoC. Both CAN and CAN-FD are working.
> > > >> >> I've tested against a Peaktech USB CAN adapter. I'd love to see
> > > >> >> these patches upstream, because our board also offers CAN and
> > > >> >> basic support for it just made it upstream [1].
> > > >> > The FlexCAN CAN FD related patches have stayed in
> > > >> > linux-can-next/flexcan branch for a long time, I still don't know
> > > >> > why Marc doesn't merge them into Linux mainline.
> > > >> > https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.
> > > >> >
> > > >>
> > > kernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Fmkl%2Flinux-can-next.
> > > >> g
> > > >> >
> > > >>
> > > it%2Ftree%2F%3Fh%3Dflexcan&amp;data=02%7C01%7Cqiangqing.zhang%40n
> > > >> xp.co
> > > >> >
> > > >>
> > > m%7C94dca4472a584410b3b908d7b129db27%7C686ea1d3bc2b4c6fa92cd99c
> > > >> 5c30163
> > > >> >
> > > >>
> > > 5%7C0%7C0%7C637172665642079192&amp;sdata=77tG6VuQCi%2FZXBKb23
> > > >> 8%2FdNSV3
> > > >> > NUIFrM5Y0e9yj0J3os%3D&amp;reserved=0
> > > >> > Also must hope that this patch set can be upstreamed soon. :-)
> > > >>
> > > >> I've took them from this branch and applied them to the latest linux
> > > >> master.
> > > >>
> > > >> Thus,
> > > >>
> > > >> Tested-by: Michael Walle <michael@walle.cc>
> > > >>
> > > >>
> > > >> >> If these patches are upstream, only the device tree nodes seems to
> > > >> >> be missing.
> > > >> >> I don't know what has happened to [2]. But the patch doesn't seem
> > > >> >> to be necessary.
> > > >> > Yes, this patch is unnecessary. I have NACKed this patch for that,
> > > >> > according to FlexCAN Integrated Guide, CTRL1[CLKSRC]=0 select
> > > >> > oscillator clock and CTRL1[CLKSRC]=1 select peripheral clock.
> > > >> > But it is actually decided by SoC integration, for i.MX, the design
> > > >> > is different.
> > > >>
> > > >> ok thanks for clarifying.
> > > >>
> > > >> > I have not upstream i.MX FlexCAN device tree nodes, since it's
> > > >> > dependency have not upstreamed yet.
> > > >> >
> > > >> >> Pankaj already send a patch to add the device node to the LS1028A [3].
> > > >> >> Thats basically the same I've used, only that mine didn't had the
> > > >> >> "fsl,ls1028ar1-flexcan" compatiblity string, but only the
> > > >> >> "lx2160ar1-flexcan"
> > > >> >> which is the correct way to use it, right?
> > > >> > You can see below table from FlexCAN driver, "fsl,lx2160ar1-flexcan"
> > > >> > supports CAN FD, you can use this compatible string.
> > > >>
> > > >> correct. I've already a patch that does exactly this ;) Who would
> > > >> take the patch for adding the LS1028A can device tree nodes to
> > > >> ls1028a.dtsi? You or Shawn Guo?
> > > > Sorry, I missed the link[3], we usually write it this way:
> > > > 			compatible = "fsl,ls1028ar1-flexcan","fsl,lx2160ar1-flexcan";
> > > > Please send patch to Shawn Guo, he will review the device tree.
> > > 
> > > As far as I know, there should be no undocumented binding. Eg. the
> > > ls1028ar1-flexcan is neither in the source nor in the device tree
> > > binding
> > > documentation, thus wouldn't be accepted.
> > > 
> > > Thus either there should be another ls1028ar1-flexcan in the
> > > flexcan_of_match
> > > table and the node should only contain that string or the node
> > > should only
> > > contain fsl,lx2160ar1-flexcan. Is there any advantage of the first
> > > option?
> > From the FlexCAN
> > binding(Documentation/devicetree/bindings/net/can/fsl-flexcan.txt)
> > - compatible : Should be "fsl,<processor>-flexcan"
> > 
> >   An implementation should also claim any of the following compatibles
> >   that it is fully backwards compatible with:
> > 
> >   - fsl,p1010-flexcan
> > 
> > You also can check imx6ul.dtsi imx7s.dtsi etc.
> > 
> > Sorry :-(, I also don't know the advantage, it's just that we're used
> > to writing it that way. You can check nodes of other devices.
> > It's unnecessary to add compatible string for each SoCs since they may
> > share the same IP. And dts had batter have a SoC specific compatible
> > string. It's just my understanding.
> 
> Ah thanks. So Pankaj's patch [1] seems to be correct (at least according
> to the description in the device tree documentation).
> 
> Shawn, whats your opinion?

My opinion is that all compatibles should be defined explicitly in
bindings doc.  In above example, the possible values of <processor>
should be given.  This must be done anyway, as we are moving to
json-schema bindings.

Shawn
