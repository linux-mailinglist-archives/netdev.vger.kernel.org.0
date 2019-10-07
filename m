Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCDECDC9D
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 09:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfJGHyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 03:54:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbfJGHyN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 03:54:13 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58AD62133F;
        Mon,  7 Oct 2019 07:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570434853;
        bh=9YOtX4I/ANs5lGe3LFcwFOESe39eOkgj8iMoqlcF+18=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2A3gNbUSccEJ41EqYprROoxzZ6bTrI47DYRdbPbYsCQYZ9/HH82SZ4qFfBCG53Tg+
         Nepd/ZSNykUvNWOtl/ajpGBxZfeWbMOeFVviVH7UExQ8K/pUzFVJ2BqUNDFeYPGAgW
         cc1ebvt2YzulycTZtt+6F0yjDFH5Y0LwZCt6br8Q=
Date:   Mon, 7 Oct 2019 10:54:09 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 2/3] RDMA/mlx5: Add capability for max sge to
 get optimized performance
Message-ID: <20191007075409.GU5855@unreal>
References: <20191006155955.31445-1-leon@kernel.org>
 <20191006155955.31445-3-leon@kernel.org>
 <20191007071302.GA15034@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007071302.GA15034@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 12:13:02AM -0700, Christoph Hellwig wrote:
> On Sun, Oct 06, 2019 at 06:59:54PM +0300, Leon Romanovsky wrote:
> > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > index 4f671378dbfc..60fd98a9b7e8 100644
> > --- a/include/rdma/ib_verbs.h
> > +++ b/include/rdma/ib_verbs.h
> > @@ -445,6 +445,8 @@ struct ib_device_attr {
> >  	struct ib_tm_caps	tm_caps;
> >  	struct ib_cq_caps       cq_caps;
> >  	u64			max_dm_size;
> > +	/* Max entries for sgl for optimized performance per READ */
> > +	u32			max_sgl_rd;
>
> This either needs to go into what current is patch 3 or an entirely
> separate one.

I'll reshuffle.

Thanks
