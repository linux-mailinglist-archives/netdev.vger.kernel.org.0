Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E04271F8BD
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 18:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfEOQgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 12:36:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726584AbfEOQga (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 12:36:30 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54BB72082E;
        Wed, 15 May 2019 16:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557938190;
        bh=fCWOmMbYwBQjYpMUOZu+jCfA4EruupzyVhAEZXgIrgA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vl4rPNMIsxH2DcxFK2owU3okuYZCpInKI99vk4sctLlCNg7BZhhHibDPCniiSF8RS
         ixCupc9hSrdnfljl/6k+yWflkSx3qFAFZHpzJhfqBdzBncW5+Kj9HVTHC1EH6vtKcV
         a0cGXjLOZAAKMxhb+r/GLYVh4DRkm1Efd7O513bQ=
Date:   Wed, 15 May 2019 19:36:26 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yuval Shaia <yuval.shaia@oracle.com>
Cc:     RDMA mailing list <linux-rdma@vger.kernel.org>,
        linux-netdev <netdev@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Doug Ledford <dledford@redhat.com>
Subject: Re: CFP: 4th RDMA Mini-Summit at LPC 2019
Message-ID: <20190515163626.GO5225@mtr-leonro.mtl.com>
References: <20190514122321.GH6425@mtr-leonro.mtl.com>
 <20190515153050.GB2356@lap1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515153050.GB2356@lap1>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 06:30:51PM +0300, Yuval Shaia wrote:
> On Tue, May 14, 2019 at 03:23:21PM +0300, Leon Romanovsky wrote:
> > This is a call for proposals for the 4th RDMA mini-summit at the Linux
> > Plumbers Conference in Lisbon, Portugal, which will be happening on
> > September 9-11h, 2019.
> >
> > We are looking for topics with focus on active audience discussions
> > and problem solving. The preferable topic is up to 30 minutes with
> > 3-5 slides maximum.
>
> Abstract: Expand the virtio portfolio with RDMA
>
> Description:
> Data center backends use more and more RDMA or RoCE devices and more and
> more software runs in virtualized environment.
> There is a need for a standard to enable RDMA/RoCE on Virtual Machines.
> Virtio is the optimal solution since is the de-facto para-virtualizaton
> technology and also because the Virtio specification allows Hardware
> Vendors to support Virtio protocol natively in order to achieve bare metal
> performance.
> This talk addresses challenges in defining the RDMA/RoCE Virtio
> Specification and a look forward on possible implementation techniques.

Yuval,

Who is going to implement it?

Thanks

>
> >
> > This year, the LPC will include netdev track too and it is
> > collocated with Kernel Summit, such timing makes an excellent
> > opportunity to drive cross-tree solutions.
> >
> > BTW, RDMA is not accepted yet as a track in LPC, but let's think
> > positive and start collect topics.
> >
> > Thanks
