Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F5B2A7AF7
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 10:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgKEJrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 04:47:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgKEJrY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 04:47:24 -0500
Received: from localhost (searspoint.nvidia.com [216.228.112.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A6012080D;
        Thu,  5 Nov 2020 09:47:22 +0000 (UTC)
Date:   Thu, 5 Nov 2020 11:47:19 +0200
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
Message-ID: <20201105094719.GQ5429@unreal>
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
 <20201023003338.1285642-2-david.m.ertman@intel.com>
 <CAPcyv4i9s=CsO5VJOhPnS77K=bD0LTQ8TUAbhLd+0OmyU8YQ3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4i9s=CsO5VJOhPnS77K=bD0LTQ8TUAbhLd+0OmyU8YQ3g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 01:19:09AM -0800, Dan Williams wrote:
> Some doc fixups, and minor code feedback. Otherwise looks good to me.
>
> On Thu, Oct 22, 2020 at 5:35 PM Dave Ertman <david.m.ertman@intel.com> wrote:
> >

<...>

> >
> > +config AUXILIARY_BUS
> > +       bool
>
> tristate? Unless you need non-exported symbols, might as well let this
> be a module.

I asked it to be "bool", because bus as a module is an invitation for
a disaster. For example if I compile-in mlx5 which is based on this bus,
and won't add auxiliary_bus as a module to initramfs, the system won't boot.

<...>

>
> Per above SPDX is v2 only, so...

Isn't it default for the Linux kernel?

>
> MODULE_LICENSE("GPL v2");

Thanks
