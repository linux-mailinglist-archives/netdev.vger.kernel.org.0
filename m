Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F082B65A3
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 14:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731936AbgKQN5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 08:57:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:38998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731321AbgKQN5a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 08:57:30 -0500
Received: from localhost (thunderhill.nvidia.com [216.228.112.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C374206F1;
        Tue, 17 Nov 2020 13:57:28 +0000 (UTC)
Date:   Tue, 17 Nov 2020 15:57:24 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Dave Ertman <david.m.ertman@intel.com>, gregkh@linuxfoundation.org,
        alsa-devel@alsa-project.org, tiwai@suse.de,
        linux-rdma@vger.kernel.org, jgg@nvidia.com, dledford@redhat.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        parav@mellanox.com, shiraz.saleem@intel.com,
        dan.j.williams@intel.com, kiran.patil@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 01/10] Add auxiliary bus support
Message-ID: <20201117135724.GA2160964@unreal>
References: <20201113161859.1775473-1-david.m.ertman@intel.com>
 <20201113161859.1775473-2-david.m.ertman@intel.com>
 <20201117053000.GM47002@unreal>
 <20201117134808.GC5142@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117134808.GC5142@sirena.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 01:48:08PM +0000, Mark Brown wrote:
> On Tue, Nov 17, 2020 at 07:30:00AM +0200, Leon Romanovsky wrote:
> > On Fri, Nov 13, 2020 at 08:18:50AM -0800, Dave Ertman wrote:
>
> > > Add support for the Auxiliary Bus, auxiliary_device and auxiliary_driver.
> > > It enables drivers to create an auxiliary_device and bind an
> > > auxiliary_driver to it.
>
> > This horse was beaten to death, can we please progress with this patch?
> > Create special topic branch or ack so I'll prepare this branch.
>
> It's been about 2 working days since the patch was last posted.

There is no code changes between v3 and v4 except docs improvements.
The v3 was posted almost 3-4 weeks ago.

Thanks
