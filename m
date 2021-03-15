Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4CD33AD8F
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 09:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbhCOIeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 04:34:08 -0400
Received: from verein.lst.de ([213.95.11.211]:52825 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229648AbhCOIdv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 04:33:51 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D619068C4E; Mon, 15 Mar 2021 09:33:47 +0100 (CET)
Date:   Mon, 15 Mar 2021 09:33:47 +0100
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
Message-ID: <20210315083347.GA28445@lst.de>
References: <20210301084257.945454-1-hch@lst.de> <20210301084257.945454-15-hch@lst.de> <1658805c-ed28-b650-7385-a56fab3383e3@arm.com> <20210310091501.GC5928@lst.de> <20210310092533.GA6819@lst.de> <fdacf87a-be14-c92c-4084-1d1dd4fc7766@arm.com> <20210311082609.GA6990@lst.de> <dff8eb80-8f74-972b-17e9-496c1fc0396f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dff8eb80-8f74-972b-17e9-496c1fc0396f@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 04:18:24PM +0000, Robin Murphy wrote:
>> Let me know what you think of the version here:
>>
>> http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/iommu-cleanup
>>
>> I'll happily switch the patch to you as the author if you're fine with
>> that as well.
>
> I still have reservations about removing the attribute API entirely and 
> pretending that io_pgtable_cfg is anything other than a SoC-specific 
> private interface,

I think a private inteface would make more sense.  For now I've just
condensed it down to a generic set of quirk bits and dropped the
attrs structure, which seems like an ok middle ground for now.  That
being said I wonder why that quirk isn't simply set in the device
tree?

> but the reworked patch on its own looks reasonable to 
> me, thanks! (I wasn't too convinced about the iommu_cmd_line wrappers 
> either...) Just iommu_get_dma_strict() needs an export since the SMMU 
> drivers can be modular - I consciously didn't add that myself since I was 
> mistakenly thinking only iommu-dma would call it.

Fixed.  Can I get your signoff for the patch?  Then I'll switch it to
over to being attributed to you.
