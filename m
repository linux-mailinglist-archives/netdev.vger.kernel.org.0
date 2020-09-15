Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B2D269E88
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 08:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgIOGce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 02:32:34 -0400
Received: from verein.lst.de ([213.95.11.211]:46552 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbgIOGcb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 02:32:31 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 10D806736F; Tue, 15 Sep 2020 08:32:25 +0200 (CEST)
Date:   Tue, 15 Sep 2020 08:32:24 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
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
Subject: Re: [PATCH 11/17] sgiseeq: convert to dma_alloc_noncoherent
Message-ID: <20200915063224.GB19113@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914151358.GQ6583@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 04:13:58PM +0100, Matthew Wilcox wrote:
> On Mon, Sep 14, 2020 at 04:44:27PM +0200, Christoph Hellwig wrote:
> >  drivers/net/ethernet/i825xx/lasi_82596.c |  25 ++---
> >  drivers/net/ethernet/i825xx/lib82596.c   | 114 ++++++++++++++---------
> >  drivers/net/ethernet/i825xx/sni_82596.c  |   4 -
> >  drivers/net/ethernet/seeq/sgiseeq.c      |  28 ++++--
> >  drivers/scsi/53c700.c                    |   9 +-
> >  5 files changed, 103 insertions(+), 77 deletions(-)
> 
> I think your patch slicing-and-dicing went wrong here ;-(

Pretty much..  Fixed up for the next version.
