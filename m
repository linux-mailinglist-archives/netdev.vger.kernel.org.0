Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 436C11468BD
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 14:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgAWNKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 08:10:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:48274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbgAWNKi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 08:10:38 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AF9224655;
        Thu, 23 Jan 2020 13:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579785037;
        bh=FSWKZcFA/Vwq3RHRtlC1Whegf88VRvThrppzMK9KEO0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=auTB68Zjup0xQteHO53gPvevArx6EJLGzPr5BHUQDkFJj6oWC+v7aAZAgZ2/vdviI
         uFFa0RXGWjI2ls2xrFvYcE1X1RNJxsKOlXzXGgESDtQuogfgkeWqfcgasuRBK0c9bm
         yS+GxaFTYIfHyR5scNYA2qyDimmN9rt6y1wva1uU=
Date:   Thu, 23 Jan 2020 15:10:34 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Michal Kalderon <mkalderon@marvell.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH net-next 14/14] qed: bump driver version
Message-ID: <20200123131034.GM7018@unreal>
References: <20200122152627.14903-1-michal.kalderon@marvell.com>
 <20200122152627.14903-15-michal.kalderon@marvell.com>
 <20200122161353.GG7018@unreal>
 <MN2PR18MB31821C711CBB377437F3EECCA10C0@MN2PR18MB3182.namprd18.prod.outlook.com>
 <20200122182107.GI7018@unreal>
 <MN2PR18MB31829FA8377460DDB9675596A10F0@MN2PR18MB3182.namprd18.prod.outlook.com>
 <20200123121203.GL7018@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123121203.GL7018@unreal>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 02:12:03PM +0200, Leon Romanovsky wrote:
> On Thu, Jan 23, 2020 at 08:18:08AM +0000, Michal Kalderon wrote:
> > > From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> > > owner@vger.kernel.org> On Behalf Of Leon Romanovsky
> > > Sent: Wednesday, January 22, 2020 8:21 PM
> > > To: Michal Kalderon <mkalderon@marvell.com>
> > > Cc: Ariel Elior <aelior@marvell.com>; davem@davemloft.net;
> > > netdev@vger.kernel.org; linux-rdma@vger.kernel.org; linux-
> > > scsi@vger.kernel.org
> > > Subject: Re: [EXT] Re: [PATCH net-next 14/14] qed: bump driver version
> > >
> > > On Wed, Jan 22, 2020 at 04:39:26PM +0000, Michal Kalderon wrote:
> > > > > From: Leon Romanovsky <leon@kernel.org>
> > > > > Sent: Wednesday, January 22, 2020 6:14 PM
> > > > >
> > > > > --------------------------------------------------------------------
> > > > > -- On Wed, Jan 22, 2020 at 05:26:27PM +0200, Michal Kalderon wrote:
> > > > > > The FW brings along a large set of fixes and features which will
> > > > > > be added at a later phase. This is an adaquete point to bump the
> > > > > > driver
> > > > > version.
> > > > > >
> > > > > > Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
> > > > > > Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
> > > > > > ---
> > > > > >  drivers/net/ethernet/qlogic/qed/qed.h | 2 +-
> > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > >
> > > > >
> > > > > We discussed this a lot, those driver version bumps are stupid and
> > > > > have nothing close to the reality. Distro kernels are based on some
> > > > > kernel version with extra patches on top, in RedHat world this "extra"
> > > > > is a lot. For them your driver version say nothing. For users who
> > > > > run vanilla kernel, those versions are not relevant too, because
> > > > > running such kernels requires knowledge and understanding.
> > > > >
> > > > > You definitely should stop this enterprise cargo cult of "releasing
> > > software"
> > > > > by updating versions in non-controlled by you distribution chain.
> > > > >
> > > > > Thanks
> > > > Due to past discussions on this topic, qedr driver version was not added
> > > and not bumped.
> > > > However, customers are used to seeing a driver version for qed/qede We
> > > > only bump major version changes (37 -> 42)  and not the minor versions
> > > anymore.
> > > > This does give a high-level understanding of the driver supports, helps us
> > > and the customers.
> > >
> > > It is worth to talk with customers instead of adding useless work for
> > > everyone involved here.
> > Hi Leon,
> >
> > I understand your arguments, and for new drivers I agree it is best to start without a driver version, having said that
> > Customers are used to what is already out there.
> >
> > Ethtool displays a driver version, and  customers go by driver version, not kernel version.
> > Mlx drivers haven't bumped the driver version, but it is still displayed when running ethtool.
>
> Yes, it is needed to be fixed.

Done.

https://patchwork.ozlabs.org/patch/1227912/

Thanks
