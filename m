Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28ABF3D33E1
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 07:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhGWEWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 00:22:31 -0400
Received: from verein.lst.de ([213.95.11.211]:36897 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229447AbhGWEWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 00:22:31 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3D30D67373; Fri, 23 Jul 2021 07:03:02 +0200 (CEST)
Date:   Fri, 23 Jul 2021 07:03:02 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Boris Pismenny <borispismenny@gmail.com>
Cc:     Boris Pismenny <borisp@nvidia.com>, dsahern@gmail.com,
        kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com, smalin@marvell.com,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Boris Pismenny <borisp@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: Re: [PATCH v5 net-next 02/36] iov_iter: DDP copy to iter/pages
Message-ID: <20210723050302.GA30841@lst.de>
References: <20210722110325.371-1-borisp@nvidia.com> <20210722110325.371-3-borisp@nvidia.com> <YPlzHTnoxDinpOsP@infradead.org> <6f7f96dc-f1e6-99d9-6ab4-920126615302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f7f96dc-f1e6-99d9-6ab4-920126615302@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 11:23:38PM +0300, Boris Pismenny wrote:
> This routine, like other changes in this file, replicates the logic in
> memcpy_to_page. The only difference is that "ddp" avoids copies when the
> copy source and destinations buffers are one and the same.

Now why can't we just make that change to the generic routine?

If we can't, why do they not have a saner name documenting what they
actually do?
