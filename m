Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFBD33359F
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 06:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhCJF6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 00:58:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230373AbhCJF6e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 00:58:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BECE64FEF;
        Wed, 10 Mar 2021 05:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615355914;
        bh=oKAzncBdG8ATSVc9xU+M2M2wid2Yp5AptqtxCYKZt7I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e9hlh0OjilzV7vVhu7KfBVDWN5a+KpzIFgSivBW0Ej1H3h4C7GUykufOavoqAi9Zq
         zHPcoHudR4265ahRikuTewj0VzZx1a0ADW7xgrPH3jwuFQoL/wFSVcEk30Pd5K6jY7
         UI7Fbd2grkDRtxDp3prQZc74ZSOayzEQxAovtLfc5IPdIV+5yBigXRlxmp5K3BNQat
         rbVyDOKIhjFc7RDuCn9G43TUMWt0uz7V4hY8OlRl+i+7BTwCSbYqxvlk4Ld7TwKof2
         ijniBYokBe8h5oTd8nmRfOtlNYne/zXJAltm8m8Z/99EY2AmjwvTJ4KOpX4lkD0NcD
         FsOUZtUoBgZLw==
Date:   Wed, 10 Mar 2021 07:58:30 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <YEhgBlWIfxu6Hjl/@unreal>
References: <20210301075524.441609-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301075524.441609-1-leon@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 09:55:20AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>

<...>

> Leon Romanovsky (4):
>   PCI: Add a sysfs file to change the MSI-X table size of SR-IOV VFs
>   net/mlx5: Add dynamic MSI-X capabilities bits
>   net/mlx5: Dynamically assign MSI-X vectors count
>   net/mlx5: Implement sriov_get_vf_total_msix/count() callbacks

Bjorn,

This is gentle reminder, can we please progress with this series?

Thanks

>
>  Documentation/ABI/testing/sysfs-bus-pci       |  29 +++++
>  .../net/ethernet/mellanox/mlx5/core/main.c    |   6 ++
>  .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  12 +++
>  .../net/ethernet/mellanox/mlx5/core/pci_irq.c |  73 +++++++++++++
>  .../net/ethernet/mellanox/mlx5/core/sriov.c   |  48 ++++++++-
>  drivers/pci/iov.c                             | 102 ++++++++++++++++--
>  drivers/pci/pci-sysfs.c                       |   3 +-
>  drivers/pci/pci.h                             |   3 +-
>  include/linux/mlx5/mlx5_ifc.h                 |  11 +-
>  include/linux/pci.h                           |   8 ++
>  10 files changed, 284 insertions(+), 11 deletions(-)
>
> --
> 2.29.2
>
