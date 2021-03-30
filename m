Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FA234E75C
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 14:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhC3MRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 08:17:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232018AbhC3MRN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 08:17:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCFD861613;
        Tue, 30 Mar 2021 12:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617106632;
        bh=R1A+HSQkC8e4xAjjBa78+nl1HCzgHqTXI4btq91BvAY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c25S81BmNCVGy2OObw4tONoA0BojMCxtSOklHDKSIj3LBTHzA1/vu4ULOtdwrhaKd
         WDRfAnsEctJcADLUnZE7e4rCMh20iy3euLeexNN3WbVyaj2Jtsudf1lTE+dAEff4Na
         EbBkVoLWPCMK4kXmg1lZUi472g/zewPckNo6IUv1xppwSMzqP67IcdaAjBBbbJIPdj
         bAU/Cefcsji1sn251Az9hG84M4pKR8GSzh27H1MZGWktXOEdnAXajGUbYVkL8ZQkNK
         2pHZBINx71bFOqfhE2/GG/OPglg0+vCFbhdOxQ2PvsQfLAlsrPgsJIVJGbkCeEVtuv
         jx7d9GgoKNuyg==
Date:   Tue, 30 Mar 2021 13:17:06 +0100
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
Subject: Re: [PATCH 04/18] iommu/fsl_pamu: merge iommu_alloc_dma_domain into
 fsl_pamu_domain_alloc
Message-ID: <20210330121706.GD5908@willie-the-truck>
References: <20210316153825.135976-1-hch@lst.de>
 <20210316153825.135976-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316153825.135976-5-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 04:38:10PM +0100, Christoph Hellwig wrote:
> Keep the functionality to allocate the domain together.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Li Yang <leoyang.li@nxp.com>
> ---
>  drivers/iommu/fsl_pamu_domain.c | 34 ++++++++++-----------------------
>  1 file changed, 10 insertions(+), 24 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
