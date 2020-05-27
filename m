Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DDD1E35EE
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 04:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgE0Cyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 22:54:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgE0Cyc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 22:54:32 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A0B22075F;
        Wed, 27 May 2020 02:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590548071;
        bh=iobn6UAMLhlS4rd0Hoku5ofXoZ4xvWgXEA28d9pI2xw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RuFvhdYG9bFFWXzoVX0X6V1+nicrOsfFmBhCKX9WczeD697OjxjjfWuIebCB5E3ZZ
         QhrtgadvkBAH0crZT+vpc8Qt/ECgV+STynVX2ECC0MophCS4LMlg7egZ09uQIp4lbS
         LvtBx1WZf7okz1+KnCJGf/em5MNjWm+LQ/lYtXsY=
Date:   Wed, 27 May 2020 05:54:28 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH rdma-next v3 0/8] Driver part of the ECE
Message-ID: <20200527025428.GG100179@unreal>
References: <20200526115440.205922-1-leon@kernel.org>
 <20200526190419.GA18519@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526190419.GA18519@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 04:04:20PM -0300, Jason Gunthorpe wrote:
> On Tue, May 26, 2020 at 02:54:32PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Changelog:
> > v3:
> >  * Squashed patch "RDMA/mlx5: Advertise ECE support" into
> >  "RDMA/mlx5: Set ECE options during modify QP".
> > v2:
> > https://lore.kernel.org/linux-rdma/20200525174401.71152-1-leon@kernel.org
> >  * Rebased on latest wip/jgg-rdma-next branch, commit a94dae867c56
> >  * Fixed wrong setting of pm_state field in mlx5 conversion patch
> >  * Removed DC support for now
> > v1:
> > https://lore.kernel.org/linux-rdma/20200523132243.817936-1-leon@kernel.org
> >  * Fixed compatibility issue of "old" kernel vs. "new" rdma-core. This
> >    is handled in extra patch.
> >  * Improved comments and commit messages after feedback from Yishai.
> >  * Added Mark Z. ROB tags
> > v0:
> > https://lore.kernel.org/linux-rdma/20200520082919.440939-1-leon@kernel.org
> >
> >
> > Hi,
> >
> > This is driver part of the RDMA-CM ECE series [1].
> > According to the IBTA, ECE data is completely vendor specific, so this
> > series extends mlx5_ib create_qp and modify_qp structs with extra field
> > to pass ECE options to/from the application.
> >
> > Thanks
> >
> > [1]
> > https://lore.kernel.org/linux-rdma/20200413141538.935574-1-leon@kernel.org
> >
> > Leon Romanovsky (8):
> >   net/mlx5: Add ability to read and write ECE options
> >   RDMA/mlx5: Get ECE options from FW during create QP
> >   RDMA/mlx5: Set ECE options during QP create
> >   RDMA/mlx5: Use direct modify QP implementation
> >   RDMA/mlx5: Remove manually crafted QP context the query call
> >   RDMA/mlx5: Convert modify QP to use MLX5_SET macros
> >   RDMA/mlx5: Set ECE options during modify QP
> >   RDMA/mlx5: Return ECE data after modify QP
>
> It seems fine, can you add the one patch to the shared branch please

First patch is applied to the mlx5-next.

f55ece0e11c1 net/mlx5: Add ability to read and write ECE options

Thanks

>
> Thanks,
> Jason
