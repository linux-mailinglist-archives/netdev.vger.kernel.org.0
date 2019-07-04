Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 578485FCDD
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 20:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfGDSWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 14:22:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbfGDSWu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 14:22:50 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A46521670;
        Thu,  4 Jul 2019 18:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562264569;
        bh=SlEyAm7VBEuRnkfs/zAbeLnxmIBqyN8hc8EsAmhR/kQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QtkxO0rDSvzfb8fD7hZT8raX2Zo3uVJwigKAlw+Q+RZPTCt5VHMSlF9geuZc4yvlU
         +SuIYn8vmfuK0gq4meCRZCXx+g9obYTVifCVdTU45In7yiup0wWvXsAwF9bMydohvg
         ll7gtrKymlW9mkvuh8at+ILHEJjFdcICnCX9xD8E=
Date:   Thu, 4 Jul 2019 21:22:26 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v5 11/17] RDMA/netlink: Implement counter
 dumpit calback
Message-ID: <20190704182226.GH7212@mtr-leonro.mtl.com>
References: <20190702100246.17382-1-leon@kernel.org>
 <20190702100246.17382-12-leon@kernel.org>
 <20190704180716.GA2583@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704180716.GA2583@ziepe.ca>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 03:07:16PM -0300, Jason Gunthorpe wrote:
> On Tue, Jul 02, 2019 at 01:02:40PM +0300, Leon Romanovsky wrote:
> > diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
> > index 0cb47d23fd86..22c5bc7a82dd 100644
> > +++ b/include/uapi/rdma/rdma_netlink.h
> > @@ -283,6 +283,8 @@ enum rdma_nldev_command {
> >
> >  	RDMA_NLDEV_CMD_STAT_SET,
> >
> > +	RDMA_NLDEV_CMD_STAT_GET, /* can dump */
> > +
> >  	RDMA_NLDEV_NUM_OPS
> >  };
> >
> > @@ -496,7 +498,13 @@ enum rdma_nldev_attr {
> >  	RDMA_NLDEV_ATTR_STAT_MODE,		/* u32 */
> >  	RDMA_NLDEV_ATTR_STAT_RES,		/* u32 */
> >  	RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK,	/* u32 */
> > -
> > +	RDMA_NLDEV_ATTR_STAT_COUNTER,		/* nested table */
> > +	RDMA_NLDEV_ATTR_STAT_COUNTER_ENTRY,	/* nested table */
> > +	RDMA_NLDEV_ATTR_STAT_COUNTER_ID,	/* u32 */
> > +	RDMA_NLDEV_ATTR_STAT_HWCOUNTERS,	/* nested table */
> > +	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY,	/* nested table */
> > +	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME,	/* string */
> > +	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_VALUE,	/* u64 */
> >  	/*
> >  	 * Information about a chardev.
> >  	 * CHARDEV_TYPE is the name of the chardev ABI (ie uverbs, umad, etc)
>
> This is in the wrong place, needs to be at the end.

Yes, it is rebase error.

Thanks

>
> Jason
