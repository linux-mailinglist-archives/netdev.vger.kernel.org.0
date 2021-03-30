Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A3B34E7B8
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 14:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhC3Mox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 08:44:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230303AbhC3MoY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 08:44:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94D82619A7;
        Tue, 30 Mar 2021 12:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617108264;
        bh=Cgba8HldB3p1zZnOmguZN9H7CCw3hn4+e9TzO2/HTCw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XqjgVkeihtvV0muU9cRH6UOfyOCOIad3+p70dAR0KpfjquoAv9Udl7usitJx6k+BL
         QjydYcgHavFRbcWpgbvPPrWkiV/HoPSK0Y5Al7Wgn8qeEE7Dz7897ny039C66QZuRc
         Aj/mq1osuVlfi5bYrw8gZ7w0/xKHRj1it7sjuQIQuPs/7Lf2GPQHSGtch0QCHfcRhH
         54sfzj/rL7F2gyyuPDAkX+EUBI3YuPHKKPDrOQzuj0iQ59qI4wMM4uxguudNDIGvnN
         U1eVEzquLKFCOh3sFFHAV1h8ykTy7BSJi3dHezZk9HYl0EguBcQW/0R42/h/WW3C0M
         1/q4jESgaIcAw==
Date:   Tue, 30 Mar 2021 13:44:18 +0100
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
Subject: Re: [PATCH 07/18] iommu/fsl_pamu: replace DOMAIN_ATTR_FSL_PAMU_STASH
 with a direct call
Message-ID: <20210330124418.GG5908@willie-the-truck>
References: <20210316153825.135976-1-hch@lst.de>
 <20210316153825.135976-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316153825.135976-8-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 04:38:13PM +0100, Christoph Hellwig wrote:
> Add a fsl_pamu_configure_l1_stash API that qman_portal can call directly
> instead of indirecting through the iommu attr API.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Li Yang <leoyang.li@nxp.com>
> ---
>  arch/powerpc/include/asm/fsl_pamu_stash.h | 12 +++---------
>  drivers/iommu/fsl_pamu_domain.c           | 16 +++-------------
>  drivers/iommu/fsl_pamu_domain.h           |  2 --
>  drivers/soc/fsl/qbman/qman_portal.c       | 18 +++---------------
>  include/linux/iommu.h                     |  1 -
>  5 files changed, 9 insertions(+), 40 deletions(-)

Heh, this thing is so over-engineered.

Acked-by: Will Deacon <will@kernel.org>

Will
