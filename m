Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B4634E7DD
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 14:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbhC3MtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 08:49:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231848AbhC3Msu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 08:48:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F1D46192C;
        Tue, 30 Mar 2021 12:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617108529;
        bh=CwVLHzAbIRGNmseGymZZt8ntYfUkMAx0Rqzxp8d9noQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pUD7C5DybyqHBKMsmQEivGH1hWwGa3N5OI6xd0qkt45xHAkRAjS5eAJuXzsJ2ZUeM
         1k8Lwt7u1XxXRUk+MdsVDvU1bcxY/2HJn97Ks1yj4DVG89JSTfQbMclWyrEVDHm0IO
         pEDTRRc99XbGsioMmRpeBMSqjSSQpm/HZwhe42CZnA6SwVo+4AtsPgEUQ1xNb2lmfl
         2FE8hJuJOxfsW78UaDpQTyuEZxpOndqdfZ+em1/Qt+6iZJJiqlsOtgOBqxNmZy8BZT
         14MeYEp9Teh87QbVXWBczJ7QWpGAx1XLwx0jiXFF/WOrHYVo4TBskmtFxafXnp9va5
         MiPidn4q2sDgg==
Date:   Tue, 30 Mar 2021 13:48:43 +0100
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
Subject: Re: [PATCH 09/18] iommu/fsl_pamu: merge handle_attach_device into
 fsl_pamu_attach_device
Message-ID: <20210330124843.GI5908@willie-the-truck>
References: <20210316153825.135976-1-hch@lst.de>
 <20210316153825.135976-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316153825.135976-10-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 04:38:15PM +0100, Christoph Hellwig wrote:
> No good reason to split this functionality over two functions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Li Yang <leoyang.li@nxp.com>
> ---
>  drivers/iommu/fsl_pamu_domain.c | 59 +++++++++++----------------------
>  1 file changed, 20 insertions(+), 39 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
