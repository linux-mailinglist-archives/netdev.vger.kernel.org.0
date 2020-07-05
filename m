Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20BA5214E5C
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 20:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgGESET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 14:04:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbgGESET (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 14:04:19 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B16520708;
        Sun,  5 Jul 2020 18:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593972258;
        bh=1XAoZrtE6FWEVtc/LMKlS3FddW6mojZo4iCmWkNF/3g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bls+zQ2GBo4Ttn58ZYE3HcayL/yhVp3pqiChFEL4bMoxY3wyytC6BkxZW/rfWvJtD
         Jr47wZJep/myYe4SYHXApJjzp/JH4m37J9I4VD1zcp06kvxvVAYQMhmvYFKrwS5qGn
         RRuhkd0Mk6uj3lYiHJWVHqRv9Oot+ManFz1HcRb0=
Date:   Sun, 5 Jul 2020 21:04:15 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-next v1 1/4] rdma: update uapi headers
Message-ID: <20200705180415.GB207186@unreal>
References: <20200624104012.1450880-1-leon@kernel.org>
 <20200624104012.1450880-2-leon@kernel.org>
 <e91ebfe0-87aa-0dc4-7c2c-48004cc761c7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e91ebfe0-87aa-0dc4-7c2c-48004cc761c7@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 05, 2020 at 09:02:42AM -0600, David Ahern wrote:
> On 6/24/20 4:40 AM, Leon Romanovsky wrote:
> > diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
> > index ae5a77a1..fe127b88 100644
> > --- a/rdma/include/uapi/rdma/rdma_netlink.h
> > +++ b/rdma/include/uapi/rdma/rdma_netlink.h
> > @@ -287,6 +287,12 @@ enum rdma_nldev_command {
> >
> >  	RDMA_NLDEV_CMD_STAT_DEL,
> >
> > +	RDMA_NLDEV_CMD_RES_QP_GET_RAW, /* can dump */
> > +
> > +	RDMA_NLDEV_CMD_RES_CQ_GET_RAW, /* can dump */
> > +
> > +	RDMA_NLDEV_CMD_RES_MR_GET_RAW, /* can dump */
> > +
> >  	RDMA_NLDEV_NUM_OPS
> >  };
>
> you are inserting new commands in the middle which breaks existing users
> of this API.

RDMA_NLDEV_NUM_OPS is not a command, but enum item to help calculate array
size, exactly like devlink_command in include/uapi/linux/devlink.h.

Thanks

>
