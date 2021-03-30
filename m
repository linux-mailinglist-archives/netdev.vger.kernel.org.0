Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BCB34E85A
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 15:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbhC3NEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 09:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231910AbhC3NEe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 09:04:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44FF2619B4;
        Tue, 30 Mar 2021 13:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617109473;
        bh=Ai+ioablpsVCP2atsV7c8O/Yf3FVTPamywu1gCQBwQI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HhMpk57DFGVpx4ab+L1MraoUiLI5kQLI2sEy2eeVU34m/M9hnmwHSf1BSYHb+BN7B
         OH/3kLJ4LRy/KSa51z3LwWQBZHM4JRe/0movK0avHRIMyQnkvWZ6oW5mEj0UPhv8kQ
         tn65df3bajqTqdrmTJ67rxDd1vixWUxfqPUxOhITAvzITPwIDd2ssDWDcbGhabIZQv
         5Bfl/YURDw2+T3/H6P/OVMEBHQMNsqzXCjXk8HuSfMiFNJSlcJ5meb25/4prvxBxMN
         lxUV8mLtcIaNFm0+8MyEBCfE8BxCcQpHQtJSeqiecPNHliWDi0EAvdK2kf87cH0eE7
         7QTL4O7hg9h0Q==
Date:   Tue, 30 Mar 2021 14:04:27 +0100
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
Subject: Re: [PATCH 14/18] iommu: remove DOMAIN_ATTR_NESTING
Message-ID: <20210330130427.GN5908@willie-the-truck>
References: <20210316153825.135976-1-hch@lst.de>
 <20210316153825.135976-15-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316153825.135976-15-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 04:38:20PM +0100, Christoph Hellwig wrote:
> Use an explicit enable_nesting method instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Li Yang <leoyang.li@nxp.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 43 ++++++++-------------
>  drivers/iommu/arm/arm-smmu/arm-smmu.c       | 30 +++++++-------
>  drivers/iommu/intel/iommu.c                 | 31 +++++----------
>  drivers/iommu/iommu.c                       | 10 +++++
>  drivers/vfio/vfio_iommu_type1.c             |  5 +--
>  include/linux/iommu.h                       |  4 +-
>  6 files changed, 55 insertions(+), 68 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
