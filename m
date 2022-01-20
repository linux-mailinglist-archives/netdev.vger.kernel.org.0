Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A159F495176
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 16:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346219AbiATP3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 10:29:09 -0500
Received: from verein.lst.de ([213.95.11.211]:45088 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232746AbiATP3H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 10:29:07 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0BD2C68BEB; Thu, 20 Jan 2022 16:28:59 +0100 (CET)
Date:   Thu, 20 Jan 2022 16:28:58 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-kernel@vger.kernel.org,
        Joao Martins <joao.m.martins@oracle.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev
Subject: Re: Phyr Starter
Message-ID: <20220120152858.GA13263@lst.de>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org> <20220111004126.GJ2328285@nvidia.com> <20220120135602.GA11223@lst.de> <20220120152736.GB383746@dhcp-10-100-145-180.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120152736.GB383746@dhcp-10-100-145-180.wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 07:27:36AM -0800, Keith Busch wrote:
> It doesn't look like IOMMU page sizes are exported, or even necessarily
> consistently sized on at least one arch (power).

At the DMA API layer dma_get_merge_boundary is the API for it.
