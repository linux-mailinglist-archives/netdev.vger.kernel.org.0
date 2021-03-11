Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C879336DC7
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 09:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbhCKI0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 03:26:18 -0500
Received: from verein.lst.de ([213.95.11.211]:39850 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231351AbhCKI0P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 03:26:15 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id F3A2D68BEB; Thu, 11 Mar 2021 09:26:09 +0100 (CET)
Date:   Thu, 11 Mar 2021 09:26:09 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Christoph Hellwig <hch@lst.de>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        freedreno@lists.freedesktop.org, kvm@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 14/17] iommu: remove DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE
Message-ID: <20210311082609.GA6990@lst.de>
References: <20210301084257.945454-1-hch@lst.de> <20210301084257.945454-15-hch@lst.de> <1658805c-ed28-b650-7385-a56fab3383e3@arm.com> <20210310091501.GC5928@lst.de> <20210310092533.GA6819@lst.de> <fdacf87a-be14-c92c-4084-1d1dd4fc7766@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdacf87a-be14-c92c-4084-1d1dd4fc7766@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 06:39:57PM +0000, Robin Murphy wrote:
>> Actually... Just mirroring the iommu_dma_strict value into
>> struct iommu_domain should solve all of that with very little
>> boilerplate code.
>
> Yes, my initial thought was to directly replace the attribute with a
> common flag at iommu_domain level, but since in all cases the behaviour
> is effectively global rather than actually per-domain, it seemed
> reasonable to take it a step further. This passes compile-testing for
> arm64 and x86, what do you think?

It seems to miss a few bits, and also generally seems to be not actually
apply to recent mainline or something like it due to different empty
lines in a few places.

Let me know what you think of the version here:

http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/iommu-cleanup

I'll happily switch the patch to you as the author if you're fine with
that as well.
