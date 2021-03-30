Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1846734E70A
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 14:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhC3MEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 08:04:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229633AbhC3MEb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 08:04:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0CD06195B;
        Tue, 30 Mar 2021 12:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617105871;
        bh=6lm/PXN71Uir/6tazMMJc+s4JuYrI2y+JzG4+8YAJhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=toQXrnSU6/gZu+6PPauuicGLb94pd7n0XyLk8JnR+r5R5rWdj54O3RYy7OJvZL4ZY
         bPxVP2yvzMMPMyUjXZxD4XCBRh7f29x45knN6+nXtorlREyk/7vAgv9iUqmSh4TlS2
         vdsfHS+S/57xjYj2m3B+qviRK8SdN+qUPgYXpwI3f0mcadVAhUxMOsadYcv4eDmtcJ
         5UciMBlATzimYaHgy85EsBEoLrkxghxZx+4SPSMGbCcNHmMR9YmbXG57ovKw1sbrWR
         YSQbAWHgq61gFUNkL+lrjGPFPns4GrbiDAIse2dIZrcaJq2SMG6xACemPJOmutKdyt
         m+UBVbGX7BjqQ==
Date:   Tue, 30 Mar 2021 13:04:25 +0100
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
Subject: Re: [PATCH 01/18] iommu: remove the unused domain_window_disable
 method
Message-ID: <20210330120418.GA5864@willie-the-truck>
References: <20210316153825.135976-1-hch@lst.de>
 <20210316153825.135976-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316153825.135976-2-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 04:38:07PM +0100, Christoph Hellwig wrote:
> domain_window_disable is wired up by fsl_pamu, but never actually called.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Li Yang <leoyang.li@nxp.com>
> ---
>  drivers/iommu/fsl_pamu_domain.c | 48 ---------------------------------
>  include/linux/iommu.h           |  2 --
>  2 files changed, 50 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
