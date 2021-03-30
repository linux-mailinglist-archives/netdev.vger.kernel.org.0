Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B990C34E734
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 14:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhC3MLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 08:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231838AbhC3MK4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 08:10:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB48A61989;
        Tue, 30 Mar 2021 12:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617106256;
        bh=x9ekBX8ubp5TbQCSOWJz4iBqTKfUoj1TbGKvNKFHBCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V6AwhAf1QgHJ9X1lDR7o2HkHOdHkt3V8vAvvWfz2AHqpyY2l/Fep/z6lg9kDQbauC
         4y1XZlSQfHxkf5nJp7n5VKoSDsRpRIvd7Q6K6T95XjE1o61jNca8OXezTBC5axyzuh
         IT3g9JXwM1vLMOLl3yOYj0aMGjfEXTlmIQtAF1IbGF0fPyxLKJtpZY5UsEQWkilqqL
         SGdhmOricP9XMO5hJycrVsxTgSV8ERQtWAgJsZ1LV7210oSFaZQl7d6atPYq+EP12r
         93GDdaLCudVDSgkEgkxYlhKl24qbesurPj6XXgDMZa+OVe889sGvMT7cy4P/XVi4Mb
         eXvJGcyvHpaGw==
Date:   Tue, 30 Mar 2021 13:10:50 +0100
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
Subject: Re: [PATCH 02/18] iommu/fsl_pamu: remove fsl_pamu_get_domain_attr
Message-ID: <20210330121050.GB5908@willie-the-truck>
References: <20210316153825.135976-1-hch@lst.de>
 <20210316153825.135976-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316153825.135976-3-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 04:38:08PM +0100, Christoph Hellwig wrote:
> None of the values returned by this function are ever queried.  Also
> remove the DOMAIN_ATTR_FSL_PAMUV1 enum value that is not otherwise used.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Li Yang <leoyang.li@nxp.com>
> ---
>  drivers/iommu/fsl_pamu_domain.c | 30 ------------------------------
>  include/linux/iommu.h           |  4 ----
>  2 files changed, 34 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
