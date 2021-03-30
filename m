Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C442634E868
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 15:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhC3NGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 09:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232169AbhC3NFx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 09:05:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9376C619C7;
        Tue, 30 Mar 2021 13:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617109553;
        bh=9DMOAy0WF/TXjALvJ8cxeKA4ftJYf/NNqPLbi+DnD68=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ASq3k8Nq/tvCuQ2EmFyEMaSv7t7NeIApY9eI7x9ee+vSZV/QpfSPyj4afiU/w/YeA
         V6T+ShFu6z2IUCDRNQ5m2kI8xpNcjbpAZt7wh1Hoef8T0oxlu6hh9L/d/mfulZ1C25
         aJP3lB5UTHltpSOc3b20Y5nFKnkgQr6MzMzUL42CpuN89rPVZfrbrXFVd/iN0moIwb
         4Yh8HJjmloXXxeWDqJdJoIHBvugrH2WjPBifz2Y5tDyWWy+l5Cv1lueJ8YoDy4u18r
         eKOzHPNwfXiotj2ibhvmC+6DxLpk2ngR797aZOhmV45MM2MizHt0h9oBwa887iRPan
         0tJ7tm6PImUDw==
Date:   Tue, 30 Mar 2021 14:05:47 +0100
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
Subject: Re: [PATCH 15/18] iommu: remove iommu_set_cmd_line_dma_api and
 iommu_cmd_line_dma_api
Message-ID: <20210330130546.GO5908@willie-the-truck>
References: <20210316153825.135976-1-hch@lst.de>
 <20210316153825.135976-16-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316153825.135976-16-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 04:38:21PM +0100, Christoph Hellwig wrote:
> Don't obsfucate the trivial bit flag check.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/iommu/iommu.c | 23 +++++------------------
>  1 file changed, 5 insertions(+), 18 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
