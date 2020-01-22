Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEEA145B75
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 19:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgAVSVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 13:21:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:39804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbgAVSVM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 13:21:12 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BF2C21835;
        Wed, 22 Jan 2020 18:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579717271;
        bh=fak4diNzYzmkJG2eI2N8qeH76Xj61Nu8P50V/PmTtJI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uPh8nisU58/GrabcofjZazzJQPZSlJNz1F9NBS0NrZEkWSQLYKaqfMCYplWMymuNj
         HQGkI2y/10HmQik+lCwT0n2MiDNZZjJ4fq7z7/Ip11on9nFNT4CTTNex0i38fHM70y
         zejVGtvUpAc3+P89EA+Dqn+CxhYKZe/OgwZrIIEY=
Date:   Wed, 22 Jan 2020 20:21:07 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Michal Kalderon <mkalderon@marvell.com>
Cc:     Ariel Elior <aelior@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH net-next 14/14] qed: bump driver version
Message-ID: <20200122182107.GI7018@unreal>
References: <20200122152627.14903-1-michal.kalderon@marvell.com>
 <20200122152627.14903-15-michal.kalderon@marvell.com>
 <20200122161353.GG7018@unreal>
 <MN2PR18MB31821C711CBB377437F3EECCA10C0@MN2PR18MB3182.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR18MB31821C711CBB377437F3EECCA10C0@MN2PR18MB3182.namprd18.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 04:39:26PM +0000, Michal Kalderon wrote:
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Wednesday, January 22, 2020 6:14 PM
> >
> > ----------------------------------------------------------------------
> > On Wed, Jan 22, 2020 at 05:26:27PM +0200, Michal Kalderon wrote:
> > > The FW brings along a large set of fixes and features which will be
> > > added at a later phase. This is an adaquete point to bump the driver
> > version.
> > >
> > > Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
> > > Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
> > > ---
> > >  drivers/net/ethernet/qlogic/qed/qed.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> >
> > We discussed this a lot, those driver version bumps are stupid and have
> > nothing close to the reality. Distro kernels are based on some kernel version
> > with extra patches on top, in RedHat world this "extra"
> > is a lot. For them your driver version say nothing. For users who run vanilla
> > kernel, those versions are not relevant too, because running such kernels
> > requires knowledge and understanding.
> >
> > You definitely should stop this enterprise cargo cult of "releasing software"
> > by updating versions in non-controlled by you distribution chain.
> >
> > Thanks
> Due to past discussions on this topic, qedr driver version was not added and not bumped.
> However, customers are used to seeing a driver version for qed/qede
> We only bump major version changes (37 -> 42)  and not the minor versions anymore.
> This does give a high-level understanding of the driver supports, helps us and the customers.

It is worth to talk with customers instead of adding useless work for
everyone involved here.

Thanks

>
