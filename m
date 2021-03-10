Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A83333AC9
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 11:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbhCJK4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 05:56:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:45820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229948AbhCJKz6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 05:55:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0375464FBA;
        Wed, 10 Mar 2021 10:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615373758;
        bh=l5F4mRFTlCcuvK65v3+ubAAIjsEOKjTToYBZnVrSV8Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Snrq3o6NQfFy8T13bWkjeS0t+DUxWxLJ7ItwwsFvYQUN059elyy12JfOlinrWY9b9
         HZXz58NlMVNMAanXaV4jMPtH+wZ63zpj4onuFCjkYAw0y6Itf99qSovicg/AvxjLlu
         dC1gGgjIjClyM+tZEQc82j0YPmrepv2haKqVn9pXRXBSHMvhcAemlq17an5DZjsRLD
         GavAs3RvhjKvztQsc6QzDP7siwQGDfGWNWfSNCMIjao9k51gQwMEycEcBk2+iaZ2FD
         GfnBGnq0Lliwgyj+ZV+DmU7+2pHmPC7dDWTA6KQMdLwYszXdvPO5XE4k7J4bo7MxuP
         Ok+UecEar6NwQ==
Date:   Wed, 10 Mar 2021 10:55:51 +0000
From:   Will Deacon <will@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Rob Clark <robdclark@gmail.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>, Li Yang <leoyang.li@nxp.com>,
        kvm@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        virtualization@lists.linux-foundation.org,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <iommu@lists.linux-foundation.org>,
        netdev@vger.kernel.org,
        freedreno <freedreno@lists.freedesktop.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Subject: Re: [Freedreno] [PATCH 16/17] iommu: remove
 DOMAIN_ATTR_IO_PGTABLE_CFG
Message-ID: <20210310105550.GA29270@willie-the-truck>
References: <20210301084257.945454-1-hch@lst.de>
 <20210301084257.945454-17-hch@lst.de>
 <d567ad5c-5f89-effa-7260-88c6d86b4695@arm.com>
 <CAF6AEGtTs-=aO-Ntp0Qn6mYDSv4x0-q3y217QxU7kZ6H1b1fiQ@mail.gmail.com>
 <20210305100012.GB22536@willie-the-truck>
 <20210310085806.GB5928@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310085806.GB5928@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 09:58:06AM +0100, Christoph Hellwig wrote:
> On Fri, Mar 05, 2021 at 10:00:12AM +0000, Will Deacon wrote:
> > > But one thing I'm not sure about is whether
> > > IO_PGTABLE_QUIRK_ARM_OUTER_WBWA is something that other devices
> > > *should* be using as well, but just haven't gotten around to yet.
> > 
> > The intention is certainly that this would be a place to collate per-domain
> > pgtable quirks, so I'd prefer not to tie that to the GPU.
> 
> So the overall consensus is to just keep this as-is for now?

Yes, please. If it doesn't see wider adoption then we can revisit it.

Will
