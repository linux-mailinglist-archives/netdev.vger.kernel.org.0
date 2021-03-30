Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B5834E8AE
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 15:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhC3NPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 09:15:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231848AbhC3NOz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 09:14:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CC5561969;
        Tue, 30 Mar 2021 13:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617110094;
        bh=/N2/wqR7fHjSlaXvMJl1cBMXpKNT/xsesoTMSv6L4kI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H6MULnqd9QB+NK7wZgljGNSyugWhqntzuA7hl6JZlcXm+z2v3zoJChkrFgo2shzTp
         7kWpdutfdv00Me8uRq6k4CXKfRgdJaXG0FfA9YbsG7wlg+Z7r07gTIgQWxT1LkYSkp
         DWVbOk8SbfrQM2yIud8rcAqs2GuTEOcAwOUAIWj8VuZr3tlHjGMQxciGj89GTcsI+6
         wA3QIpJx15k5zaCAI2i0QTwhK5h7hVXzLMWRdWcVoJrrjF7aHn1fmW9gVtnH0wdl2V
         3tX5hH0qrjR/RU13f5CzrPtpxHRIDR3ndCSVxdrE0CM6hBMj0APadZ/nh/M/gdHzKH
         JgeNVk/teVZHA==
Date:   Tue, 30 Mar 2021 14:14:49 +0100
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
Subject: Re: [PATCH 17/18] iommu: remove DOMAIN_ATTR_IO_PGTABLE_CFG
Message-ID: <20210330131448.GQ5908@willie-the-truck>
References: <20210316153825.135976-1-hch@lst.de>
 <20210316153825.135976-18-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316153825.135976-18-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 04:38:23PM +0100, Christoph Hellwig wrote:
> Use an explicit set_pgtable_quirks method instead that just passes
> the actual quirk bitmask instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Li Yang <leoyang.li@nxp.com>
> ---
>  drivers/gpu/drm/msm/adreno/adreno_gpu.c |  5 +-
>  drivers/iommu/arm/arm-smmu/arm-smmu.c   | 64 +++++--------------------
>  drivers/iommu/arm/arm-smmu/arm-smmu.h   |  2 +-
>  drivers/iommu/iommu.c                   | 11 +++++
>  include/linux/io-pgtable.h              |  4 --
>  include/linux/iommu.h                   | 12 ++++-
>  6 files changed, 35 insertions(+), 63 deletions(-)

I'm fine with this for now, although there has been talk about passing
things other than boolean flags as page-table quirks. We can cross that
bridge when we get there, so:

Acked-by: Will Deacon <will@kernel.org>

Will
