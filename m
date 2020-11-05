Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9ED92A876E
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 20:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732141AbgKEThq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 14:37:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732020AbgKEThq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 14:37:46 -0500
Received: from localhost (searspoint.nvidia.com [216.228.112.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A51B320704;
        Thu,  5 Nov 2020 19:37:44 +0000 (UTC)
Date:   Thu, 5 Nov 2020 21:37:41 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     "Ertman, David M" <david.m.ertman@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
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
        Fred Oh <fred.oh@linux.intel.com>,
        Parav Pandit <parav@mellanox.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/10] Add auxiliary bus support
Message-ID: <20201105193741.GC5475@unreal>
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
 <20201023003338.1285642-2-david.m.ertman@intel.com>
 <CAPcyv4i9s=CsO5VJOhPnS77K=bD0LTQ8TUAbhLd+0OmyU8YQ3g@mail.gmail.com>
 <DM6PR11MB284191BAA817540E52E4E2C4DDEE0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <f37a2b37-2fda-948d-1b8f-617395d43a08@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f37a2b37-2fda-948d-1b8f-617395d43a08@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 01:32:40PM -0600, Pierre-Louis Bossart wrote:
>
> > > > +module_init(auxiliary_bus_init);
> > > > +module_exit(auxiliary_bus_exit);
> > > > +
> > > > +MODULE_LICENSE("GPL");
> > >
> > > Per above SPDX is v2 only, so...
> > >
> > > MODULE_LICENSE("GPL v2");
> > >
> >
> > added v2.
>
> "GPL v2" is the same as "GPL" here, it does not have any additional meaning.
>
> https://www.kernel.org/doc/html/latest/process/license-rules.html
>
> “GPL”	Module is licensed under GPL version 2. This does not express any
> distinction between GPL-2.0-only or GPL-2.0-or-later. The exact license
> information can only be determined via the license information in the
> corresponding source files.

+1,
https://lore.kernel.org/lkml/20201105193009.GA5475@unreal

>
> “GPL v2”	Same as “GPL”. It exists for historic reasons.
>
