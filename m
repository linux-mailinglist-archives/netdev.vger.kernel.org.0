Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3271D24A0CD
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 15:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728518AbgHSN5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 09:57:47 -0400
Received: from verein.lst.de ([213.95.11.211]:37922 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728160AbgHSN5p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 09:57:45 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9352F68BFE; Wed, 19 Aug 2020 15:57:39 +0200 (CEST)
Date:   Wed, 19 Aug 2020 15:57:38 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>, alsa-devel@alsa-project.org,
        linux-ia64@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        nouveau@lists.freedesktop.org, linux-nvme@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        linux-scsi@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Pawel Osciak <pawel@osciak.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "list@263.net:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH 05/28] media/v4l2: remove
 V4L2-FLAG-MEMORY-NON-CONSISTENT
Message-ID: <20200819135738.GB17098@lst.de>
References: <20200819065555.1802761-1-hch@lst.de> <20200819065555.1802761-6-hch@lst.de> <CAAFQd5COLxjydDYrfx47ht8tj-aNPiaVnC+WyQA7nvpW4gs=ww@mail.gmail.com> <62e4f4fc-c8a5-3ee8-c576-fe7178cb4356@arm.com> <CAAFQd5AcCTDguB2C9KyDiutXWoEvBL8tL7+a==Uo8vj_8CLOJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5AcCTDguB2C9KyDiutXWoEvBL8tL7+a==Uo8vj_8CLOJw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 02:49:01PM +0200, Tomasz Figa wrote:
> With the default config it doesn't, but with
> CONFIG_DMA_NONCOHERENT_CACHE_SYNC enabled it makes dma_pgprot() keep
> the pgprot value as is, without enforcing coherence attributes.

Which isn't selected on arm64, and that is for a good reason.

> AFAIK dma_cache_sync() isn't the only way to perform the cache
> synchronization.

Yes, it is the only documented way to do it.  And if you read the whole
series instead of screaming you'd see that it provides a proper way
to deal with non-coherent memory which will also work with arm64.
instead of screaming 

> By the way, as a videobuf2 reviewer, I'd appreciate being CC'd on any
> series related to the subsystem-facing DMA API changes, since
> videobuf2 is one of the biggest users of it.

The cc list is too long - I cc lists and key maintainers.  As a reviewer
should should watch your subsystems lists closely.
