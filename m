Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2364231479
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 23:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbgG1VOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 17:14:32 -0400
Received: from verein.lst.de ([213.95.11.211]:50006 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729363AbgG1VOc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 17:14:32 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 90DCB68C4E; Tue, 28 Jul 2020 23:14:27 +0200 (CEST)
Date:   Tue, 28 Jul 2020 23:14:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>,
        netdev@vger.kernel.org, kernel-team@fb.com, robin.murphy@arm.com,
        akpm@linux-foundation.org, davem@davemloft.net, kuba@kernel.org,
        willemb@google.com, edumazet@google.com,
        steffen.klassert@secunet.com, saeedm@mellanox.com,
        maximmi@mellanox.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, borisp@mellanox.com, david@redhat.com
Subject: Re: [RFC PATCH v2 21/21] netgpu/nvidia: add Nvidia plugin for
 netgpu
Message-ID: <20200728211427.GA22919@lst.de>
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com> <20200727052846.4070247-22-jonathan.lemon@gmail.com> <20200727073509.GB3917@lst.de> <20200727170003.clx5ytf7vn2emhvl@bsd-mbp.dhcp.thefacebook.com> <20200727182424.GA10178@lst.de> <20200728014812.izihmnon3khzyr32@bsd-mbp.dhcp.thefacebook.com> <20200728181904.GA138520@nvidia.com> <20200728210116.56potw45eyptmlc7@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728210116.56potw45eyptmlc7@bsd-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 02:01:16PM -0700, Jonathan Lemon wrote:
> For /this/ patch [21], this is quite true.  I'm forced to use the nv_p2p
> API if I want to use the hardware that I have.  What's being overlooked
> is that the host mem driver does not do this, nor would another GPU
> if it used p2p_dma.  I'm just providing get_page, put_page, get_dma.

No, that is not overlooked.   What you overlooked is that your design
is bogus.  We don't do pointless plugings for something where there
is exactly one way to do, which is done in common infrastructure.

> 
> 
> > Any approach done in tree, where we can actually modify the GPU
> > driver, would do sane things like have the GPU driver itself create
> > the MEMORY_DEVICE_PCI_P2PDMA pages, use the P2P DMA API framework, use
> > dmabuf for the cross-driver attachment, etc, etc.
> 
> So why doesn't Nvidia implement the above in the driver?
> Actually a serious question, not trolling here.

No one knows, and most importantly it simply does not matter at all.

If you actually want to be productive contributor and not just troll
(as it absoutely seems) you'd just stop talking about a out of tree
driver that can't actually be distributed together with the kernel.

And better forget everything you ever knew about it, because it not
only is irrelevant but actually harmful.
