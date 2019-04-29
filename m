Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F282FEA3F
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 20:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbfD2Sii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 14:38:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728186AbfD2Sii (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 14:38:38 -0400
Received: from localhost (unknown [77.138.135.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 279222087B;
        Mon, 29 Apr 2019 18:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556563117;
        bh=YtyMoIio0Y8qDBelaQi1GvmmL4E9B7eCqFW6Uyjmb/s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vv1DQeSsrIqaFUIsLjLuZf9SklgFunYyQ8tFnxh9uNwKeb1YJnm57BAO0VYQjMxnk
         hVckvYcEzfO1Yt1Dyun6Ox6ERXYMx/k/MLAwP+lsGnllXs4O4wT6irLz/3h+aTkHD6
         V6QM/tWhT2JazTyKTjVKWsdugt2BYY7wy3Hf5DXk=
Date:   Mon, 29 Apr 2019 21:38:32 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next v2 07/17] IB/mlx5: Support set qp counter
Message-ID: <20190429183832.GA6705@mtr-leonro.mtl.com>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-8-leon@kernel.org>
 <ecdb1a67243d50854af74fb95271cc63e9b6c508.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecdb1a67243d50854af74fb95271cc63e9b6c508.camel@mellanox.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 06:22:03PM +0000, Saeed Mahameed wrote:
> On Mon, 2019-04-29 at 11:34 +0300, Leon Romanovsky wrote:
> > From: Mark Zhang <markz@mellanox.com>
> >
> > Support bind a qp with counter. If counter is null then bind the qp
> > to
> > the default counter. Different QP state has different operation:
> > - RESET: Set the counter field so that it will take effective
> >   during RST2INIT change;
> > - RTS: Issue an RTS2RTS change to update the QP counter;
> > - Other: Set the counter field and mark the counter_pending flag,
> >   when QP is moved to RTS state and this flag is set, then issue
> >   an RTS2RTS modification to update the counter.
> >
> > Signed-off-by: Mark Zhang <markz@mellanox.com>
> > Reviewed-by: Majd Dibbiny <majd@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  drivers/infiniband/hw/mlx5/mlx5_ib.h |  6 +++
> >  drivers/infiniband/hw/mlx5/qp.c      | 76
> > +++++++++++++++++++++++++++-
> >  include/linux/mlx5/qp.h              |  1 +
>
> I don't see any reason why this patch should go to mlx5-next branch.
> Just because you have one liner in include/linux/mlx5/qp.h, is not
> enough reason.
>

I'm changing target automatically based on get_maintainer.pl output.

If "$GET_MAINTAINER --email --nol --nos --nosubsystem --noroles $_file | grep Saeed -c"
returns Saeed, it means that such patch has all potential to create merge conflict.

Thanks
