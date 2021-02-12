Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0366931A6BA
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 22:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhBLVT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 16:19:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231759AbhBLVTv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 16:19:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1360D64E05;
        Fri, 12 Feb 2021 21:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613164750;
        bh=K5O919IwqNBN7z7OB3lXUXGZBaYgdDXdKQa0F1xVsck=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=l58u2CB4L9HTmUWSiS2d/ybmnkRc73qvdkYFiCYwxstrFV7esRnY0OR6I4eZtPPXr
         /ZBPRnhUt+XRvVQ+ouBWmkKWUSaNiLlGiS8PkV5dypjCrcn/UX6FV9rJ43uOhH/w8B
         jVwaSl13Tzmi6arn1GYq6i4xwQuDAihDRDNjpsr/F37KlkuFwMHxqBdr+Ees8jLAaE
         ti1ELSgtydKneC+IPI2Hu+NhQJCuc96KwY5RrqotHM41ni+iF71ZgmZWT7r71zgapx
         LCQGX0UpdbRvl2gU9J3mufwTOc3FQg31f3ZTDqBq4U53J0Fwh9hF9x07T4iYF102sa
         2WKWHdW05pRPQ==
Message-ID: <53a97eb379af167c0221408a07c9bddc6624027d.camel@kernel.org>
Subject: Re: [PATCH rdma-next 0/2] Real time/free running timestamp support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org
Date:   Fri, 12 Feb 2021 13:19:09 -0800
In-Reply-To: <20210212211408.GA1860468@nvidia.com>
References: <20210209131107.698833-1-leon@kernel.org>
         <20210212181056.GB1737478@nvidia.com>
         <5d4731e2394049ca66012f82e1645bdec51aca78.camel@kernel.org>
         <20210212211408.GA1860468@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-02-12 at 17:14 -0400, Jason Gunthorpe wrote:
> On Fri, Feb 12, 2021 at 01:09:20PM -0800, Saeed Mahameed wrote:
> > On Fri, 2021-02-12 at 14:10 -0400, Jason Gunthorpe wrote:
> > > On Tue, Feb 09, 2021 at 03:11:05PM +0200, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > Add an extra timestamp format for mlx5_ib device.
> > > > 
> > > > Thanks
> > > > 
> > > > Aharon Landau (2):
> > > >   net/mlx5: Add new timestamp mode bits
> > > >   RDMA/mlx5: Fail QP creation if the device can not support the
> > > > CQE
> > > > TS
> > > > 
> > > >  drivers/infiniband/hw/mlx5/qp.c | 104
> > > > +++++++++++++++++++++++++++++---
> > > >  include/linux/mlx5/mlx5_ifc.h   |  54 +++++++++++++++--
> > > >  2 files changed, 145 insertions(+), 13 deletions(-)
> > > 
> > > Since this is a rdma series, and we are at the end of the cycle,
> > > I
> > > took the IFC file directly to the rdma tree instead of through
> > > the
> > > shared branch.
> > > 
> > > Applied to for-next, thanks
> > > 
> > 
> > mmm, i was planing to resubmit this patch with the netdev real time
> > support series, since the uplink representor is getting delayed, I
> > thought I could submit the real time stuff today. can you wait on
> > the
> > ifc patch, i will re-send it today if you will, but it must go
> > through
> > the shared branch
> 
> Friday of rc7 is a bit late to be sending new patches for the first
> time, isn't it??

I know, uplink representor last minute mess !

> 
> But sure, if you update the shared branch right now I'll fix up
> rdma.git
> 

I can't put it in the shared brach without review, i will post it to
the netdev/rdma lists for two days at least for review and feedback.

Not critical though, this can wait for next rc1.. if you want to
proceed with what you already did.

Thanks



