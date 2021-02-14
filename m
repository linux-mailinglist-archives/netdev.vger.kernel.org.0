Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CC731AF27
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 06:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhBNFZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 00:25:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:48950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229494AbhBNFZb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Feb 2021 00:25:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA92D64DCC;
        Sun, 14 Feb 2021 05:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613280290;
        bh=z5Z3JlNpwpUDgDfAYZVeMCMo8ei6ew55eOm/HIEimhk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g6AeeLTOKwIeat8dkqEPb/4TKT/5+soiw7FDsOE5wuc38fN6Tdv1/H2P6ZNGVIap+
         oN5CsXgHFLfM2H9q0R91Fo5I4gLsaj822ekK3KughKGCAwwAGKwtkpNcFn95UVKpEd
         wDKvGWvG0lmsf6ZG1b/lkp0p/oF5zbrufCWgnJy3A76Y4ajgBdCpTWibewYClASsR5
         te8Z0ppstmAWsdsk4NgIPhTn41uW/BjksNxGGwy3rWXET7AQ7pvBO6CfFue68imEF8
         ADjWnCOlc6HdS4NUKOSC5PkbQxN6UvetNj+6n4hhICHnE89V0Ci6rQpFzfTbBQFNzo
         EPVmwyO4e0EdA==
Date:   Sun, 14 Feb 2021 07:24:46 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH mlx5-next v6 0/4] Dynamically assign MSI-X vectors count
Message-ID: <YCi0HvqizRp+Nhgh@unreal>
References: <20210209133445.700225-1-leon@kernel.org>
 <CAKgT0Ud+c6wzo3n_8VgtVBQm-2UPic6U2QFuqqN-P9nEv_Y+JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Ud+c6wzo3n_8VgtVBQm-2UPic6U2QFuqqN-P9nEv_Y+JQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 01:06:25PM -0800, Alexander Duyck wrote:
> On Tue, Feb 9, 2021 at 5:34 AM Leon Romanovsky <leon@kernel.org> wrote:
> >

<...>

> > Leon Romanovsky (4):
> >   PCI: Add sysfs callback to allow MSI-X table size change of SR-IOV VFs
> >   net/mlx5: Add dynamic MSI-X capabilities bits
> >   net/mlx5: Dynamically assign MSI-X vectors count
> >   net/mlx5: Allow to the users to configure number of MSI-X vectors
> >
> >  Documentation/ABI/testing/sysfs-bus-pci       |  28 ++++
> >  .../net/ethernet/mellanox/mlx5/core/main.c    |  17 ++
> >  .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  27 ++++
> >  .../net/ethernet/mellanox/mlx5/core/pci_irq.c |  72 +++++++++
> >  .../net/ethernet/mellanox/mlx5/core/sriov.c   |  58 ++++++-
> >  drivers/pci/iov.c                             | 153 ++++++++++++++++++
> >  include/linux/mlx5/mlx5_ifc.h                 |  11 +-
> >  include/linux/pci.h                           |  12 ++
> >  8 files changed, 375 insertions(+), 3 deletions(-)
> >
>
> This seems much improved from the last time I reviewed the patch set.
> I am good with the drop of the folder in favor of using "sriov" in the
> naming of the fields.
>
> For the series:
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

Bjorn,

Can I get your Ack too, so we won't miss this merge window?

Thanks
