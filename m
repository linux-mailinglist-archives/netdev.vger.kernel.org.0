Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2896C35675B
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 10:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349741AbhDGI5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 04:57:36 -0400
Received: from 8bytes.org ([81.169.241.247]:33784 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345782AbhDGI5b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 04:57:31 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 29AFC418; Wed,  7 Apr 2021 10:57:21 +0200 (CEST)
Date:   Wed, 7 Apr 2021 10:57:19 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Will Deacon <will@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: cleanup unused or almost unused IOMMU APIs and the FSL PAMU
 driver v3
Message-ID: <YG1z7/b0i8WYOMHA@8bytes.org>
References: <20210401155256.298656-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401155256.298656-1-hch@lst.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 01, 2021 at 05:52:36PM +0200, Christoph Hellwig wrote:
> Diffstat:
>  arch/powerpc/include/asm/fsl_pamu_stash.h   |   12 
>  drivers/gpu/drm/msm/adreno/adreno_gpu.c     |    5 
>  drivers/iommu/amd/iommu.c                   |   23 
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |   75 ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |    1 
>  drivers/iommu/arm/arm-smmu/arm-smmu.c       |  111 +---
>  drivers/iommu/arm/arm-smmu/arm-smmu.h       |    2 
>  drivers/iommu/dma-iommu.c                   |    9 
>  drivers/iommu/fsl_pamu.c                    |  293 -----------
>  drivers/iommu/fsl_pamu.h                    |   12 
>  drivers/iommu/fsl_pamu_domain.c             |  688 ++--------------------------
>  drivers/iommu/fsl_pamu_domain.h             |   46 -
>  drivers/iommu/intel/iommu.c                 |   95 ---
>  drivers/iommu/iommu.c                       |  118 +---
>  drivers/soc/fsl/qbman/qman_portal.c         |   55 --
>  drivers/vfio/vfio_iommu_type1.c             |   31 -
>  drivers/vhost/vdpa.c                        |   10 
>  include/linux/io-pgtable.h                  |    4 
>  include/linux/iommu.h                       |   76 ---
>  19 files changed, 203 insertions(+), 1463 deletions(-)

Applied, thanks.
