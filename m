Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAFE34E834
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 15:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhC3NA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 09:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232081AbhC3NAZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 09:00:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6723461959;
        Tue, 30 Mar 2021 13:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617109224;
        bh=m3TvkxvqPC7Tpakpaq16UQpVjJGrx5gC57aV7gCm8GE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q+OSrGSvrWc7WYths8Js73WEMx795hdLZQgMXoL3dU2M1loRm7gpXJPstw5r96wE+
         MHERTkZdUmMqt0s1BPvMPCPEFoJZkJamnTKDq4K4rys4fqbm/nejUkGZhZ84T7bvZv
         Ler6sSRcp45AsVGHeW+zKyc/iZ0K+xWrwbiiAvOv9AdkdKTu7n28KdSWcWg3TCBiwH
         efhhakrMIGdlWHG5y8cLowYyjKPeJvPwVS1ZDVu/G3v2OfwKusR9D1kPYvmwIyRcwB
         RPVE1raY7AUORsYfBkgmuAg8ie5APSgAugC4iRu1nKmYUKDnrH6tc0xtIdlm9sb2o9
         UNwLXhfk0L68Q==
Date:   Tue, 30 Mar 2021 14:00:19 +0100
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
Subject: Re: [PATCH 13/18] iommu: remove DOMAIN_ATTR_GEOMETRY
Message-ID: <20210330130019.GM5908@willie-the-truck>
References: <20210316153825.135976-1-hch@lst.de>
 <20210316153825.135976-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316153825.135976-14-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 04:38:19PM +0100, Christoph Hellwig wrote:
> The geometry information can be trivially queried from the iommu_domain
> struture.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Li Yang <leoyang.li@nxp.com>
> ---
>  drivers/iommu/iommu.c           | 20 +++-----------------
>  drivers/vfio/vfio_iommu_type1.c | 26 ++++++++++++--------------
>  drivers/vhost/vdpa.c            | 10 +++-------
>  include/linux/iommu.h           |  1 -
>  4 files changed, 18 insertions(+), 39 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
