Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B4127418B
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 13:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgIVLuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 07:50:01 -0400
Received: from elvis.franken.de ([193.175.24.41]:51264 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbgIVLto (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 07:49:44 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1kKfxr-000822-04; Tue, 22 Sep 2020 12:56:03 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 1F9C4C0FFF; Tue, 22 Sep 2020 10:50:49 +0200 (CEST)
Date:   Tue, 22 Sep 2020 10:50:49 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 11/18] lib82596: convert to dma_alloc_noncoherent
Message-ID: <20200922085049.GE8477@alpha.franken.de>
References: <20200915155122.1768241-1-hch@lst.de>
 <20200915155122.1768241-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915155122.1768241-12-hch@lst.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 05:51:15PM +0200, Christoph Hellwig wrote:
> Use the new non-coherent DMA API including proper ownership transfers.
> This includes moving the DMA helpers to lib82596 based of an ifdef to
> avoid include order problems.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/net/ethernet/i825xx/lasi_82596.c |  25 ++---
>  drivers/net/ethernet/i825xx/lib82596.c   | 114 ++++++++++++++---------
>  drivers/net/ethernet/i825xx/sni_82596.c  |   4 -
>  3 files changed, 80 insertions(+), 63 deletions(-)

Tested-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de> (SNI part)

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
