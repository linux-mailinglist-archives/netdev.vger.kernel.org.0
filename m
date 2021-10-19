Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C21433517
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 13:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235439AbhJSLyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230514AbhJSLyM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:54:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1D5B60FED;
        Tue, 19 Oct 2021 11:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634644320;
        bh=//13uDQQNMbNmUnNCr9kAR4vydmZjWPTWfRAMUdlufc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AN+VU2Ma5/yW0PFSIk9Lc28PWbASdoBgmMVEAjz6OhblIjLudNvjQxqb3sBgQSMsC
         onAnybpCzbwZ4U3PM7B0ONJegnS3mlTpqrXb+Lv/KGPJGVD+m3XI18ldSaZ4+M0AwM
         c9057mRb1P/WsG3sH0aSwyIiDFCDaDcGh9uCvm5jL3lM08Lat5hG5MQrb3CUyha9fO
         KjV2VTgqDRf3S5A2IP8GU1Q7Z1mtkbMSzoCmmAixEmVDJAPiRKjJLwJOP2thvl22ku
         eoW+fCG0RhT2VRtlGD7DhItS4RDct82sgdgdGu8dSNDrfL8t61AorqC42btspP8fDG
         Zg7FSPVF2P4cg==
Date:   Tue, 19 Oct 2021 14:51:56 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH mlx5-next 0/7] Clean MR key use across mlx5_* modules
Message-ID: <YW6xXL0WvI1HUczD@unreal>
References: <cover.1634033956.git.leonro@nvidia.com>
 <20211013144303.GF2744544@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013144303.GF2744544@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 11:43:03AM -0300, Jason Gunthorpe wrote:
> On Tue, Oct 12, 2021 at 01:26:28PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Hi,
> > 
> > This is cleanup series of mlx5_* MR mkey management.
> > 
> > Thanks
> > 
> > Aharon Landau (7):
> >   RDMA/mlx5: Don't set esc_size in user mr
> 
> Please sent just this patch to -rc after modifying as I noted, don't
> put this in mlx5-next
> 
> >   RDMA/mlx5: Remove iova from struct mlx5_core_mkey
> >   RDMA/mlx5: Remove size from struct mlx5_core_mkey
> >   RDMA/mlx5: Remove pd from struct mlx5_core_mkey
> >   RDMA/mlx5: Replace struct mlx5_core_mkey by u32 key
> >   RDMA/mlx5: Move struct mlx5_core_mkey to mlx5_ib
> >   RDMA/mlx5: Attach ndescs to mlx5_ib_mkey
> 
> It seems fine to me, other than the little notes, a V2 can go to
> mlx5-next

Applied to vfio-next, to serve as a basis for live migration patches.
https://lore.kernel.org/kvm/20211019105838.227569-1-yishaih@nvidia.com/T/#m89f4f0ec4baddeb2828a2b38dcbbd6900009fb83

ae0579acde81 RDMA/mlx5: Attach ndescs to mlx5_ib_mkey
4123bfb0b28b RDMA/mlx5: Move struct mlx5_core_mkey to mlx5_ib
83fec3f12a59 RDMA/mlx5: Replace struct mlx5_core_mkey by u32 key
c64674168b6a RDMA/mlx5: Remove pd from struct mlx5_core_mkey
062fd731e51e RDMA/mlx5: Remove size from struct mlx5_core_mkey
cf6a8b1b24d6 RDMA/mlx5: Remove iova from struct mlx5_core_mkey

https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=vfio-next

Thanks

> 
> Jason
