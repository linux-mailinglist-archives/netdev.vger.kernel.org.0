Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B0C494FB7
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 15:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243802AbiATOAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 09:00:55 -0500
Received: from verein.lst.de ([213.95.11.211]:44735 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234342AbiATOAz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 09:00:55 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6DCC668C4E; Thu, 20 Jan 2022 15:00:48 +0100 (CET)
Date:   Thu, 20 Jan 2022 15:00:47 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev
Subject: Re: Phyr Starter
Message-ID: <20220120140047.GB11223@lst.de>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org> <20220111004126.GJ2328285@nvidia.com> <Yd0IeK5s/E0fuWqn@casper.infradead.org> <20220111150142.GL2328285@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111150142.GL2328285@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 11:01:42AM -0400, Jason Gunthorpe wrote:
> Then we are we using get_user_phyr() at all if we are just storing it
> in a sg?

I think we need to stop calling the output of the phyr dma map
helper a sg.  Yes, a { dma_addr, len } tuple is scatter/gather I/O in its
purest form, but it will need a different name in Linux as the scatterlist
will have to stay around for a long time before all that mess is cleaned
up.
