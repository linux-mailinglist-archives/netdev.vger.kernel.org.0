Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4610302E67
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 22:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732909AbhAYVxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 16:53:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732641AbhAYVxL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 16:53:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A03F821D94;
        Mon, 25 Jan 2021 21:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611611551;
        bh=JGG1bE8MlyryqwGafdFSgT8Qxw2vxdbrkHYyYdvV+EQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TKwv8KGnaI9D04adY4vICWW5uWRwD2/xIAfG9RjXy5AWgnHguauYjfI6oefaFWjQN
         wks/FdG9rw+VbPOSajWB5eQod972TkjA1Jjt7MAGlOLVwAL5ythNMRHiyIPNG68lzX
         L0haHpZtt35BcfSGg6DuX8w/xw7FnivalZLZEH75LmrSid4PznqrNiwG1unst0gtVx
         hv6HXB0F+ImRleLChPzoIN7rWD5nZFEyPAFQ8STgEcy0nWnyMlBWoNFbOrgiNnYBXk
         pHLuftHDfpFI5+eLSiMr2t4Ce5NCuJDG7D/aW8WGt/kE1xH5gRV888nv7+ezO0IXdw
         0U5PpvDKl9u7Q==
Date:   Mon, 25 Jan 2021 13:52:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH mlx5-next v4 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <20210125135229.6193f783@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210124131119.558563-2-leon@kernel.org>
References: <20210124131119.558563-1-leon@kernel.org>
        <20210124131119.558563-2-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Jan 2021 15:11:16 +0200 Leon Romanovsky wrote:
> +static int pci_enable_vfs_overlay(struct pci_dev *dev) { return 0; }
> +static void pci_disable_vfs_overlay(struct pci_dev *dev) {}

s/static /static inline /
