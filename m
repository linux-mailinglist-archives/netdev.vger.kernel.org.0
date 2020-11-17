Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3014C2B5A2E
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 08:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgKQHQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 02:16:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:36342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbgKQHQr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 02:16:47 -0500
Received: from localhost (thunderhill.nvidia.com [216.228.112.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 668112463B;
        Tue, 17 Nov 2020 07:16:45 +0000 (UTC)
Date:   Tue, 17 Nov 2020 09:16:41 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Dave Ertman <david.m.ertman@intel.com>,
        alsa-devel@alsa-project.org, tiwai@suse.de, broonie@kernel.org,
        linux-rdma@vger.kernel.org, jgg@nvidia.com, dledford@redhat.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        parav@mellanox.com, shiraz.saleem@intel.com,
        dan.j.williams@intel.com, kiran.patil@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 01/10] Add auxiliary bus support
Message-ID: <20201117071641.GN47002@unreal>
References: <20201113161859.1775473-1-david.m.ertman@intel.com>
 <20201113161859.1775473-2-david.m.ertman@intel.com>
 <20201117053000.GM47002@unreal>
 <X7N1naYOXodPsP/I@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X7N1naYOXodPsP/I@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 08:02:53AM +0100, Greg KH wrote:
> On Tue, Nov 17, 2020 at 07:30:00AM +0200, Leon Romanovsky wrote:
> > On Fri, Nov 13, 2020 at 08:18:50AM -0800, Dave Ertman wrote:
> > > Add support for the Auxiliary Bus, auxiliary_device and auxiliary_driver.
> > > It enables drivers to create an auxiliary_device and bind an
> > > auxiliary_driver to it.
> > >
> > > The bus supports probe/remove shutdown and suspend/resume callbacks.
> > > Each auxiliary_device has a unique string based id; driver binds to
> > > an auxiliary_device based on this id through the bus.
> > >
> > > Co-developed-by: Kiran Patil <kiran.patil@intel.com>
> > > Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> > > Co-developed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > > Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > > Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
> > > Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
> > > Co-developed-by: Leon Romanovsky <leonro@nvidia.com>
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > > Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > Reviewed-by: Parav Pandit <parav@mellanox.com>
> > > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > > ---
> >
> > Greg,
> >
> > This horse was beaten to death, can we please progress with this patch?
> > Create special topic branch or ack so I'll prepare this branch.
> >
> > We are in -rc4 now and we (Mellanox) can't hold our submissions anymore.
> > My mlx5_core probe patches [1] were too intrusive and they are ready to
> > be merged, Parav's patches got positive review as well [2] and will be
> > taken next.
> >
> > We delayed and have in our internal queues the patches for VDPA, eswitch
> > and followup for mlx5_core probe rework, but trapped due to this AUX bus
> > patch.
>
> There are no deadlines for kernel patches here, sorry.  Give me some
> time to properly review this, core kernel changes should not be rushed.

And here comes the difference between our views, from my POV it is not
core kernel change that must to be done perfectly from the beginning,
but change that will need to be improved/extended over time once more
users will come.

>
> Also, if you really want to blame someone for the delay, look at the
> patch submitters, not the reviewers, as they are the ones that took a
> very long time with this over the lifecycle of this patchset, not me.  I
> have provided many "instant" reviews of this patchset, and then months
> went by between updates from them.

I'm not blaming anyone and especially you. It is just unfair that I
found myself in the middle of this disaster while care enough to remind
about the series.

Thanks

>
> greg k-h
