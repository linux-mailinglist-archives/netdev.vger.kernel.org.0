Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B629333802
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 09:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhCJI63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 03:58:29 -0500
Received: from verein.lst.de ([213.95.11.211]:35251 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232323AbhCJI6K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 03:58:10 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8BF2268BEB; Wed, 10 Mar 2021 09:58:06 +0100 (CET)
Date:   Wed, 10 Mar 2021 09:58:06 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Will Deacon <will@kernel.org>
Cc:     Rob Clark <robdclark@gmail.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>, Joerg Roedel <joro@8bytes.org>,
        Li Yang <leoyang.li@nxp.com>, kvm@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
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
Message-ID: <20210310085806.GB5928@lst.de>
References: <20210301084257.945454-1-hch@lst.de> <20210301084257.945454-17-hch@lst.de> <d567ad5c-5f89-effa-7260-88c6d86b4695@arm.com> <CAF6AEGtTs-=aO-Ntp0Qn6mYDSv4x0-q3y217QxU7kZ6H1b1fiQ@mail.gmail.com> <20210305100012.GB22536@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305100012.GB22536@willie-the-truck>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 05, 2021 at 10:00:12AM +0000, Will Deacon wrote:
> > But one thing I'm not sure about is whether
> > IO_PGTABLE_QUIRK_ARM_OUTER_WBWA is something that other devices
> > *should* be using as well, but just haven't gotten around to yet.
> 
> The intention is certainly that this would be a place to collate per-domain
> pgtable quirks, so I'd prefer not to tie that to the GPU.

So the overall consensus is to just keep this as-is for now?
