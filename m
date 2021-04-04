Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951C3353734
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 09:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhDDHdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 03:33:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229550AbhDDHdl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 03:33:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04D0D61245;
        Sun,  4 Apr 2021 07:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617521617;
        bh=ltS7lq4oXwcn7gTInXVuSFeWg967RnQ1h1YAVoS7KHI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IJG0WfniHlbsZb0VDPfNg0+8CCvKmiJinx8bTmTGR0BRexWXAiVtz4k+3oJulYT5S
         Jt8Cw9CyGbxhgz2VIEKzhFoEg6Tk8GP4jNjFzLXw7RjjSuiNqaTmnB/9W+nk081GFx
         wZ0N3f4AzZL22TXMW9Z75EuiTUpklEyNzok+ULisHJSuMshEEn+BJg7tI3Mbzt72nb
         HDBRCZ/b+sFA5gHuaJMLAs86+AYvXfPjylwTI0fuSaqY64dV7OeGdAJbQPHDrhGy9Z
         nzFwQDDDKoeZuiRD1JKg308m8NeDqq3IWZjfv9UPTPaJy4drpSKeIwxKHgshulEE0s
         azjXXcI48ophA==
Date:   Sun, 4 Apr 2021 10:33:33 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v8 0/4] Dynamically assign MSI-X vectors count
Message-ID: <YGlrzXvOJErgcWiz@unreal>
References: <20210314124256.70253-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210314124256.70253-1-leon@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 14, 2021 at 02:42:52PM +0200, Leon Romanovsky wrote:
> ---------------------------------------------------------------------------------
> Changelog
> v8:
>  * Added "physical/virtual function" words near PF and VF acronyms.
> v7: https://lore.kernel.org/linux-pci/20210301075524.441609-1-leon@kernel.org
>  * Rebase on top v5.12-rc1
>  * More english fixes
>  * Returned to static sysfs creation model as was implemented in v0/v1.

<...>

> Leon Romanovsky (4):
>   PCI: Add a sysfs file to change the MSI-X table size of SR-IOV VFs
>   net/mlx5: Add dynamic MSI-X capabilities bits
>   net/mlx5: Dynamically assign MSI-X vectors count
>   net/mlx5: Implement sriov_get_vf_total_msix/count() callbacks

applied to mlx5-next with changes asked by Bjorn.

e71b75f73763 net/mlx5: Implement sriov_get_vf_total_msix/count() callbacks
604774add516 net/mlx5: Dynamically assign MSI-X vectors count
0b989c1e3705 net/mlx5: Add dynamic MSI-X capabilities bits
c3d5c2d96d69 PCI/IOV: Add sysfs MSI-X vector assignment interface

Thanks
