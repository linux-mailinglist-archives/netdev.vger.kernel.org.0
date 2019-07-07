Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2C261448
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 09:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfGGHvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 03:51:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727127AbfGGHvS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jul 2019 03:51:18 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B561120830;
        Sun,  7 Jul 2019 07:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562485877;
        bh=MkFR8RV5YSB5lbsuftqEMB5Iaf41XwbnOZ5e5z6SXkA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f5J7fbYjaaiF09er5ffvZLboz7jE2edj995ipAnY08wUjeLNaXIMbfvxKUBZcGTfH
         LhO69fgT0ZbmUDDujDPBKG5AMFLq8wUxL4yCLtCc64kQ8sXaCVg1PjYoDQFDfJzn8A
         bscfpmwDbP8TeKmGuuSmuH+LaSLcN16QZMdQITsg=
Date:   Sun, 7 Jul 2019 10:51:14 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/2] DEVX VHCA tunnel support
Message-ID: <20190707075114.GB7034@mtr-leonro.mtl.com>
References: <20190701181402.25286-1-leon@kernel.org>
 <20190705174007.GA7787@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705174007.GA7787@ziepe.ca>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 05, 2019 at 02:40:07PM -0300, Jason Gunthorpe wrote:
> On Mon, Jul 01, 2019 at 09:14:00PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Hi,
> >
> > Those two patches introduce VHCA tunnel mechanism to DEVX interface
> > needed for Bluefield SOC. See extensive commit messages for more
> > information.
> >
> > Thanks
> >
> > Max Gurtovoy (2):
> >   net/mlx5: Introduce VHCA tunnel device capability
> >   IB/mlx5: Implement VHCA tunnel mechanism in DEVX
> >
> >  drivers/infiniband/hw/mlx5/devx.c | 24 ++++++++++++++++++++----
> >  include/linux/mlx5/mlx5_ifc.h     | 10 ++++++++--
> >  2 files changed, 28 insertions(+), 6 deletions(-)
>
> This looks Ok can you apply the mlx5-next patch please

1dd7382b1bb6 net/mlx5: Introduce VHCA tunnel device capability

Thanks

>
> Thanks,
> Jason
>
