Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7462E304796
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbhAZRAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 12:00:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:41176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729662AbhAZGCU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 01:02:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B397522A84;
        Tue, 26 Jan 2021 06:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611640899;
        bh=UJTUpQslFeeTwA/ZmcZRakfjPhEw6pZ2rj5imXYRts0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TrWdhnpwMrvgAp08gWlyJCXdRyA25BAJGGBA32snrUBjgj+p3vuJyLQpjvhrk//Is
         9se71PPkl4ab2gO1B1ICfJmkAbg0aJftIdBLJocs7IXEe2bvM0X19bnOjoHYyzc+8p
         BOm8YyJpFmH+bP1bJl5wfy+R4HwhhmvkbTxEXi1PWiSVvWAZrx+9tUXgnFgxsDRL7A
         vbCQv524tsSXD2eO7FgRPuw/9RykCHMPVOxYL73lNcmSxLxoM6Msj58sQ2veI/ZCku
         wD0po+tXIsTc+H8gDPAZDZDd4QTlKLswety7jk6tOIgBtYGvuYXf0YRiJCMzUv9KXm
         Om7tX5fg8Mn8w==
Date:   Tue, 26 Jan 2021 08:01:35 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, Joe Perches <joe@perches.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH mlx5-next v4 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <20210126060135.GQ579511@unreal>
References: <20210124131119.558563-1-leon@kernel.org>
 <20210124131119.558563-2-leon@kernel.org>
 <20210125135229.6193f783@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125135229.6193f783@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 01:52:29PM -0800, Jakub Kicinski wrote:
> On Sun, 24 Jan 2021 15:11:16 +0200 Leon Romanovsky wrote:
> > +static int pci_enable_vfs_overlay(struct pci_dev *dev) { return 0; }
> > +static void pci_disable_vfs_overlay(struct pci_dev *dev) {}
>
> s/static /static inline /

Thanks a lot, I think that we should extend checkpatch.pl to catch such
mistakes.

Joe,

How hard is it to extend checkpatch.pl to do regexp and warn if in *.h file
someone declared function with implementation but didn't add "inline" word?

Thanks
