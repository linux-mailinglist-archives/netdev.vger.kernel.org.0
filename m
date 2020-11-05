Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578B22A873C
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 20:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732181AbgKETaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 14:30:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:42656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727836AbgKETaO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 14:30:14 -0500
Received: from localhost (searspoint.nvidia.com [216.228.112.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EB7A20728;
        Thu,  5 Nov 2020 19:30:12 +0000 (UTC)
Date:   Thu, 5 Nov 2020 21:30:09 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Dave Ertman <david.m.ertman@intel.com>,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Parav Pandit <parav@mellanox.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/10] Add auxiliary bus support
Message-ID: <20201105193009.GA5475@unreal>
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
 <20201023003338.1285642-2-david.m.ertman@intel.com>
 <CAPcyv4i9s=CsO5VJOhPnS77K=bD0LTQ8TUAbhLd+0OmyU8YQ3g@mail.gmail.com>
 <20201105094719.GQ5429@unreal>
 <CAPcyv4hmBhkFjSA2Q_p=Ss40CLFs86N7FugJOpq=sZ-NigoSRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hmBhkFjSA2Q_p=Ss40CLFs86N7FugJOpq=sZ-NigoSRw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 09:12:51AM -0800, Dan Williams wrote:
> On Thu, Nov 5, 2020 at 1:47 AM Leon Romanovsky <leonro@nvidia.com> wrote:
> >
> > On Thu, Nov 05, 2020 at 01:19:09AM -0800, Dan Williams wrote:
> > > Some doc fixups, and minor code feedback. Otherwise looks good to me.
> > >
> > > On Thu, Oct 22, 2020 at 5:35 PM Dave Ertman <david.m.ertman@intel.com> wrote:
> > > >
> >
> > <...>
> >
> > > >
> > > > +config AUXILIARY_BUS
> > > > +       bool
> > >
> > > tristate? Unless you need non-exported symbols, might as well let this
> > > be a module.
> >
> > I asked it to be "bool", because bus as a module is an invitation for
> > a disaster. For example if I compile-in mlx5 which is based on this bus,
> > and won't add auxiliary_bus as a module to initramfs, the system won't boot.
>
> Something is broken if module dependencies don't arrange for
> auxiliary_bus.ko to be added to the initramfs automatically, but yes,
> it is another degree of freedom for something to go wrong if you build
> the initramfs by hand.

And this is something that I would like to avoid for now.

>
> >
> > <...>
> >
> > >
> > > Per above SPDX is v2 only, so...
> >
> > Isn't it default for the Linux kernel?
>
> SPDX eliminated the need to guess a default, and MODULE_LICENSE("GPL")
> implies the "or later" language. The only default assumption is that
> the license is GPL v2 compatible, those possibilities are myriad, but
> v2-only is the first preference.

I mean that plain GPL == GPL v2 in the kernel.

Thanks
