Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C1A2B696D
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgKQQIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:08:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:40708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726433AbgKQQIp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 11:08:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4726924655;
        Tue, 17 Nov 2020 16:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605629324;
        bh=g4vB3mdu+chdNCAjY+sz6l9E1Ab2sYs0J3DRDQUTmw8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N6mnx5J1ajFlk7nf3GPVAtAaEeGioyhfHPcOpXrf0e/MQ3hIKdhv4Yv/4fPKKT0uV
         Ch3fWm6duvtgpVxRBepEVXCzH79fbvDkQidB7nXk/L5+S6QW5ryytTFy0s1Sgk+kOL
         MV8BJOxmCISOyFxQGhTTS08EQ/hyYbRFeL+XRLds=
Date:   Tue, 17 Nov 2020 16:48:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Dave Ertman <david.m.ertman@intel.com>,
        alsa-devel@alsa-project.org, tiwai@suse.de,
        linux-rdma@vger.kernel.org, jgg@nvidia.com, dledford@redhat.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        parav@mellanox.com, shiraz.saleem@intel.com,
        dan.j.williams@intel.com, kiran.patil@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 01/10] Add auxiliary bus support
Message-ID: <X7Pw3GQr80BAE1L1@kroah.com>
References: <20201113161859.1775473-1-david.m.ertman@intel.com>
 <20201113161859.1775473-2-david.m.ertman@intel.com>
 <20201117053000.GM47002@unreal>
 <20201117134808.GC5142@sirena.org.uk>
 <20201117135724.GA2160964@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117135724.GA2160964@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 03:57:24PM +0200, Leon Romanovsky wrote:
> On Tue, Nov 17, 2020 at 01:48:08PM +0000, Mark Brown wrote:
> > On Tue, Nov 17, 2020 at 07:30:00AM +0200, Leon Romanovsky wrote:
> > > On Fri, Nov 13, 2020 at 08:18:50AM -0800, Dave Ertman wrote:
> >
> > > > Add support for the Auxiliary Bus, auxiliary_device and auxiliary_driver.
> > > > It enables drivers to create an auxiliary_device and bind an
> > > > auxiliary_driver to it.
> >
> > > This horse was beaten to death, can we please progress with this patch?
> > > Create special topic branch or ack so I'll prepare this branch.
> >
> > It's been about 2 working days since the patch was last posted.
> 
> There is no code changes between v3 and v4 except docs improvements.
> The v3 was posted almost 3-4 weeks ago.

But everything else that came in since then needs to be reviewed first,
right?  It's a fifo queue, no jumping the line.  And, to be frank, if
people complain, that's a sure way for it to get dumped to the end of
the line, as you know.

thanks,

greg k-h
