Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8E92B594A
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 06:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgKQFaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 00:30:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgKQFaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 00:30:05 -0500
Received: from localhost (thunderhill.nvidia.com [216.228.112.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A3B9246AE;
        Tue, 17 Nov 2020 05:30:04 +0000 (UTC)
Date:   Tue, 17 Nov 2020 07:30:00 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Dave Ertman <david.m.ertman@intel.com>, gregkh@linuxfoundation.org
Cc:     alsa-devel@alsa-project.org, tiwai@suse.de, broonie@kernel.org,
        linux-rdma@vger.kernel.org, jgg@nvidia.com, dledford@redhat.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        parav@mellanox.com, shiraz.saleem@intel.com,
        dan.j.williams@intel.com, kiran.patil@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 01/10] Add auxiliary bus support
Message-ID: <20201117053000.GM47002@unreal>
References: <20201113161859.1775473-1-david.m.ertman@intel.com>
 <20201113161859.1775473-2-david.m.ertman@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113161859.1775473-2-david.m.ertman@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 08:18:50AM -0800, Dave Ertman wrote:
> Add support for the Auxiliary Bus, auxiliary_device and auxiliary_driver.
> It enables drivers to create an auxiliary_device and bind an
> auxiliary_driver to it.
>
> The bus supports probe/remove shutdown and suspend/resume callbacks.
> Each auxiliary_device has a unique string based id; driver binds to
> an auxiliary_device based on this id through the bus.
>
> Co-developed-by: Kiran Patil <kiran.patil@intel.com>
> Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> Co-developed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
> Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
> Co-developed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
> Reviewed-by: Parav Pandit <parav@mellanox.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> ---

Greg,

This horse was beaten to death, can we please progress with this patch?
Create special topic branch or ack so I'll prepare this branch.

We are in -rc4 now and we (Mellanox) can't hold our submissions anymore.
My mlx5_core probe patches [1] were too intrusive and they are ready to
be merged, Parav's patches got positive review as well [2] and will be
taken next.

We delayed and have in our internal queues the patches for VDPA, eswitch
and followup for mlx5_core probe rework, but trapped due to this AUX bus
patch.

Thanks

[1] https://lore.kernel.org/linux-rdma/20201101201542.2027568-1-leon@kernel.org/
[2] https://lore.kernel.org/linux-rdma/BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com/T/#md25b9a2feb4c60d3fef5d57da41db559af1062d8
