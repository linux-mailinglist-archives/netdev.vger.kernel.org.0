Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597F83D4D00
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 11:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhGYJKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 05:10:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230305AbhGYJKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 05:10:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F0236069E;
        Sun, 25 Jul 2021 09:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627206679;
        bh=hyDjtkF5eCcWkADXAB8rrXfHqOep6tJmcaDVlottAjM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UcHBjYhHkRvNFCR4CdHvCdWWKNWeM7lDfj+yZCIoXN35uoSWLbiLjnpI86ER6Z4ev
         MJQaWOhLCGWcI/tLT13yaUl2ir2HpYPkpDV6zOT1eUw636FBc2Bd05wAMwDgxzusaO
         VjsNOdFMMcThgim+LhDj+hkz7acuKNaKxLDSV623Hbmo2MPcecr5zcQxu2AQbGTF2K
         SisM+Qqhg6mrVDh5teydoYCYvI7yxxWLWrH/QLWYxwPtCI+PLMkHS+DCJsgKNH/85Y
         TI6CB4ed9uEoHM4qndkP+VXc6yg82KZ85QyZoGoSdTslai20DmL3r+uIU9DV9L/B53
         n7aPfed4zAGeA==
Date:   Sun, 25 Jul 2021 12:51:15 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tal Gilboa <talgi@nvidia.com>
Subject: Re: [PATCH mlx5-next] IB/mlx5: Rename is_apu_thread_cq function to
 is_apu_cq
Message-ID: <YP00E/bLM+RTY3u7@unreal>
References: <0e3364dab7e0e4eea5423878b01aa42470be8d36.1626609184.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e3364dab7e0e4eea5423878b01aa42470be8d36.1626609184.git.leonro@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 18, 2021 at 02:54:13PM +0300, Leon Romanovsky wrote:
> From: Tal Gilboa <talgi@nvidia.com>
> 
> is_apu_thread_cq() used to detect CQs which are attached to APU
> threads. This was extended to support other elements as well,
> so the function was renamed to is_apu_cq().
> 
> c_eqn_or_apu_element was extended from 8 bits to 32 bits, which wan't
> reflected when the APU support was first introduced.
> 
> Signed-off-by: Tal Gilboa <talgi@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/hw/mlx5/cq.c                            | 2 +-
>  drivers/infiniband/hw/mlx5/devx.c                          | 7 +++----
>  drivers/net/ethernet/mellanox/mlx5/core/cq.c               | 3 ++-
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c          | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c        | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 2 +-
>  drivers/vdpa/mlx5/net/mlx5_vnet.c                          | 2 +-
>  include/linux/mlx5/mlx5_ifc.h                              | 5 ++---
>  8 files changed, 12 insertions(+), 13 deletions(-)

Applied to mlx5-next.
616d57693455 ("IB/mlx5: Rename is_apu_thread_cq function to is_apu_cq")

Jason, please pull.

Thanks
