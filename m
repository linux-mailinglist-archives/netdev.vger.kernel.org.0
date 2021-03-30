Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827B734E8B9
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 15:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbhC3NQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 09:16:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232114AbhC3NQM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 09:16:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC2AD600CD;
        Tue, 30 Mar 2021 13:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617110172;
        bh=oFXOyKxZKWj8q01FK45XVtCIPwg3akZJbcVTrbuBLVo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l1jGuJCF4w1qP0WDBFRJLJbU4g/DIEbv74dOL2tJmCIJybKQT/Nk25Yv0qXeq5IaC
         EisAJbuKCJR8lIBRsfnD7dSAWI3QM8tCB0T4wmdwHhk0eojOnRHrf3takMiJpJwGys
         qw9rVNUl438UrVnp+OEcnv9h6o59f29jn7JL4MjeriTt710N2VzyfvUgJkzuLUdgJx
         4Y2jHOJXj+PRMj3LOs3p9/SoE/WlKyknigr1X7t5UGpaPbgNBBHfe0p2oKPY6K334d
         WE4pAmPZzxHYIndqKqgDdIvzbqUmJFYVOWwBPIBWWv8bjLCKMWwTnaXYTxNqTxJ/U6
         pwVpVBFdgZ8rw==
Date:   Tue, 30 Mar 2021 14:16:06 +0100
From:   Will Deacon <will@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Joerg Roedel <joro@8bytes.org>, Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 18/18] iommu: remove iommu_domain_{get,set}_attr
Message-ID: <20210330131606.GA6122@willie-the-truck>
References: <20210316153825.135976-1-hch@lst.de>
 <20210316153825.135976-19-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316153825.135976-19-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 04:38:24PM +0100, Christoph Hellwig wrote:
> Remove the now unused iommu attr infrastructure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/iommu/iommu.c | 26 --------------------------
>  include/linux/iommu.h | 36 ------------------------------------
>  2 files changed, 62 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
