Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 527432A8762
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 20:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732176AbgKETfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 14:35:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbgKETfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 14:35:17 -0500
Received: from localhost (searspoint.nvidia.com [216.228.112.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C91620728;
        Thu,  5 Nov 2020 19:35:14 +0000 (UTC)
Date:   Thu, 5 Nov 2020 21:35:11 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     "Ertman, David M" <david.m.ertman@intel.com>
Cc:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
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
Message-ID: <20201105193511.GB5475@unreal>
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
 <20201023003338.1285642-2-david.m.ertman@intel.com>
 <CAPcyv4i9s=CsO5VJOhPnS77K=bD0LTQ8TUAbhLd+0OmyU8YQ3g@mail.gmail.com>
 <DM6PR11MB284191BAA817540E52E4E2C4DDEE0@DM6PR11MB2841.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB284191BAA817540E52E4E2C4DDEE0@DM6PR11MB2841.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 07:27:56PM +0000, Ertman, David M wrote:
> > -----Original Message-----
> > From: Dan Williams <dan.j.williams@intel.com>
> > Sent: Thursday, November 5, 2020 1:19 AM
> > To: Ertman, David M <david.m.ertman@intel.com>
> > Cc: alsa-devel@alsa-project.org; Takashi Iwai <tiwai@suse.de>; Mark Brown
> > <broonie@kernel.org>; linux-rdma <linux-rdma@vger.kernel.org>; Jason
> > Gunthorpe <jgg@nvidia.com>; Doug Ledford <dledford@redhat.com>;
> > Netdev <netdev@vger.kernel.org>; David Miller <davem@davemloft.net>;
> > Jakub Kicinski <kuba@kernel.org>; Greg KH <gregkh@linuxfoundation.org>;
> > Ranjani Sridharan <ranjani.sridharan@linux.intel.com>; Pierre-Louis Bossart
> > <pierre-louis.bossart@linux.intel.com>; Fred Oh <fred.oh@linux.intel.com>;
> > Parav Pandit <parav@mellanox.com>; Saleem, Shiraz
> > <shiraz.saleem@intel.com>; Patil, Kiran <kiran.patil@intel.com>; Linux
> > Kernel Mailing List <linux-kernel@vger.kernel.org>; Leon Romanovsky
> > <leonro@nvidia.com>
> > Subject: Re: [PATCH v3 01/10] Add auxiliary bus support
> >
> > Some doc fixups, and minor code feedback. Otherwise looks good to me.
> >
> > On Thu, Oct 22, 2020 at 5:35 PM Dave Ertman <david.m.ertman@intel.com>
> > wrote:

<...>

>
> Again, thanks for the review Dan.  Changes will be in next release (v4) once I give
> stake-holders a little time to respond.

Everything here can go as a Fixes, the review comments are valuable and need
to be fixed, but they don't change anything dramatically that prevent from
merging v3.

Thanks

>
> -DaveE
