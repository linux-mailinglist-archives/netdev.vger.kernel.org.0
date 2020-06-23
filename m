Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7088120548C
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 16:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732787AbgFWO1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 10:27:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732737AbgFWO1b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 10:27:31 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4700C2073E;
        Tue, 23 Jun 2020 14:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592922450;
        bh=cKE8GGN8F2Bic02isSz2R/jPclxbyJspW4PZYEsBCFM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T+Ua5k9tSnuu7lGXD+jjcvLChOdZYLQ4nKF+FuM9DtVmykfdaT33m29d+WI8DtjKV
         2jjKB1eyjYfz7kt8jubTownqHwowXyi3LgODuPneoklTw/iiHZELWPO07fPYs74cBw
         QKO6ORlfWeOo1rKAHW7QAWxry8mHQI4CQMn7OwBg=
Date:   Tue, 23 Jun 2020 17:27:27 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lijun Ou <oulijun@huawei.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Weihang Li <liweihang@huawei.com>,
        "Wei Hu(Xavier)" <huwei87@hisilicon.com>
Subject: Re: [PATCH rdma-next v3 00/11] RAW format dumps through RDMAtool
Message-ID: <20200623142727.GB184720@unreal>
References: <20200623113043.1228482-1-leon@kernel.org>
 <20200623141957.GG2874652@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623141957.GG2874652@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 11:19:57AM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 23, 2020 at 02:30:32PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Changelog:
> > v3:
> >  * Rewrote query interface in patch "RDMA: Add support to dump resource
> >    tracker in RAW format"
> > v2:
> > https://lore.kernel.org/linux-rdma/20200616104006.2425549-1-leon@kernel.org
> >  * Converted to specific nldev ops for RAW.
> >  * Rebased on top of v5.8-rc1.
> > v1:
> > https://lore.kernel.org/linux-rdma/20200527135408.480878-1-leon@kernel.org
> >  * Maor dropped controversial change to dummy interface.
> > v0:
> > https://lore.kernel.org/linux-rdma/20200513095034.208385-1-leon@kernel.org
> >
> >
> > Hi,
> >
> > The following series adds support to get the RDMA resource data in RAW
> > format. The main motivation for doing this is to enable vendors to return
> > the entire QP/CQ/MR data without a need from the vendor to set each
> > field separately.
> >
> > Thanks
> >
> >
> > Maor Gottlieb (11):
> >   net/mlx5: Export resource dump interface
> >   net/mlx5: Add support in query QP, CQ and MKEY segments
>
> It looks OK can you apply these too the shared branch?

Thanks, applied.

608ca553c9a2 net/mlx5: Add support in query QP, CQ and MKEY segments
d63cc24933c7 net/mlx5: Export resource dump interface

>
> Thanks,
> Jason
