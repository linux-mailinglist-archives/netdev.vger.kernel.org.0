Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBE626E0FB
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 18:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbgIQQmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 12:42:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728491AbgIQQfZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 12:35:25 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD71C214D8;
        Thu, 17 Sep 2020 16:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600360524;
        bh=Uz6xePWXVQihMLxMXZSK/OgsLyUGo4M1rBM8krJvvR8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GBTx4oXeYHOqEHjiTQ1uInC8eD0l4QXjC5CiZX5qWlmiSvGHIJxftSHcROfH6I7uE
         of98ql93MxNYFsOqRuEH3J2OgLdC8qJL81HBmgPEQ7xzIFqztyRFZMHic3r2FIbFBz
         naL98if9SWuYGb6ySPp7vxfMkDZOi9l+ntF4HKfU=
Date:   Thu, 17 Sep 2020 19:35:20 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Achiad Shochat <achiad@mellanox.com>,
        Adit Ranadive <aditr@vmware.com>,
        Aharon Landau <aharonl@mellanox.com>,
        Ariel Elior <aelior@marvell.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>
Subject: Re: [PATCH rdma-next v2 0/3] Fix in-kernel active_speed type
Message-ID: <20200917163520.GH869610@unreal>
References: <20200917090223.1018224-1-leon@kernel.org>
 <20200917114154.GH3699@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917114154.GH3699@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 08:41:54AM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 17, 2020 at 12:02:20PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > Changelog:
> > v2:
> >  * Changed WARN_ON casting to be saturated value instead while returning active_speed
> >    to the user.
> > v1: https://lore.kernel.org/linux-rdma/20200902074503.743310-1-leon@kernel.org
> >  * Changed patch #1 to fix memory corruption to help with bisect. No
> >    change in series, because the added code is changed anyway in patch
> >    #3.
> > v0:
> >  * https://lore.kernel.org/linux-rdma/20200824105826.1093613-1-leon@kernel.org
> >
> >
> > IBTA declares speed as 16 bits, but kernel stores it in u8. This series
> > fixes in-kernel declaration while keeping external interface intact.
> >
> > Thanks
> >
> > Aharon Landau (3):
> >   net/mlx5: Refactor query port speed functions
> >   RDMA/mlx5: Delete duplicated mlx5_ptys_width enum
> >   RDMA: Fix link active_speed size
>
> Look OK, can you update the shared branch?

I pushed first two patches to mlx5-next branch:

e27014bdb47e RDMA/mlx5: Delete duplicated mlx5_ptys_width enum
639bf4415cad net/mlx5: Refactor query port speed functions

Thanks

>
> Thanks,
> Jason
