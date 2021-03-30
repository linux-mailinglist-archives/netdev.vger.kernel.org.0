Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2D734E801
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 14:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhC3Mya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 08:54:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230303AbhC3MyE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 08:54:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBEC161955;
        Tue, 30 Mar 2021 12:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617108844;
        bh=MUsAReQl36x7SR3EX7iZh5BEyF4eEO7patp68iu3zYw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RvhuDRnnjbhKmZxor1XvWHCMInipWXvRtxAnhtWSHyskQigqXOQJZBpmkmtBZyI42
         Hzk9YR+zXiAqh+GqCuQsV/e9VwUlbbLL2WBWuGxyEgIjksxNm4QjWpE80+c+eJgjxa
         CDgfI0Go46YGTQMxgFvBCCBuNUOdQ5A9e4RX4fJZrV2JQkPw15LXMK/zAx+kh0z7vL
         kyRwRMIu/q/vE1ATdrsCa4384znPHm83guJWxqP2Cv0dXtUc4fw5FRdDw0Q8vG1MD6
         rhCut5ZrQW9EjJtIgqABXSUdPcCMBGGg98+FfQp3aOd/QWoqSzA6/B7VI2jDOm1MH1
         7esynnh6eCt1Q==
Date:   Tue, 30 Mar 2021 13:53:58 +0100
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
Subject: Re: [PATCH 10/18] iommu/fsl_pamu: enable the liodn when attaching a
 device
Message-ID: <20210330125358.GJ5908@willie-the-truck>
References: <20210316153825.135976-1-hch@lst.de>
 <20210316153825.135976-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316153825.135976-11-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 04:38:16PM +0100, Christoph Hellwig wrote:
> Instead of a separate call to enable all devices from the list, just
> enablde the liodn one the device is attached to the iommu domain.

(typos: "enablde" and "one" probably needs to be "once"?)

> This also remove the DOMAIN_ATTR_FSL_PAMU_ENABLE iommu_attr.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Li Yang <leoyang.li@nxp.com>
> ---
>  drivers/iommu/fsl_pamu_domain.c     | 47 ++---------------------------
>  drivers/iommu/fsl_pamu_domain.h     | 10 ------
>  drivers/soc/fsl/qbman/qman_portal.c | 11 -------
>  include/linux/iommu.h               |  1 -
>  4 files changed, 3 insertions(+), 66 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
