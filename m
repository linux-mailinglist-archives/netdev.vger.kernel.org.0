Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0730330D6FD
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 11:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbhBCKDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 05:03:21 -0500
Received: from verein.lst.de ([213.95.11.211]:50394 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233090AbhBCKDT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 05:03:19 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2102E6736F; Wed,  3 Feb 2021 11:02:35 +0100 (CET)
Date:   Wed, 3 Feb 2021 11:02:34 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Or Gerlitz <gerlitz.or@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, axboe@fb.com,
        Boris Pismenny <borisp@mellanox.com>, smalin@marvell.com,
        yorayz@nvidia.com, boris.pismenny@gmail.com,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>,
        linux-nvme@lists.infradead.org, David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>, benishay@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>,
        Or Gerlitz <ogerlitz@nvidia.com>
Subject: Re: [PATCH v3 net-next 07/21] nvme-tcp: Add DDP data-path
Message-ID: <20210203100234.GA9050@lst.de>
References: <20210201100509.27351-1-borisp@mellanox.com> <20210201100509.27351-8-borisp@mellanox.com> <20210201173744.GC12960@lst.de> <CAJ3xEMhninJE5zw7=QFL4gBVkH=1tAmQHyq7tKMqcSJ_KkDsWQ@mail.gmail.com> <80074375-2d37-d9b9-afbe-1f3d1db4a41f@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80074375-2d37-d9b9-afbe-1f3d1db4a41f@grimberg.me>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 12:56:35AM -0800, Sagi Grimberg wrote:
>
>>> Given how much ddp code there is can you split it into a separate file?
>>
>> mmm, do we need to check the preferences or get to a consensus among
>> the maintainers for that one?
>
> Not sure if moving it would be better here. Given that the ddp code is
> working directly on nvme-tcp structs we'll need a new shared header
> file..
>
> Its possible to do, but I'm not sure the end result will be better..

In the end its your code base.  But I hate having all this offload
cruft all over the place.  Just saying no to offloads might be an even
better position, though.
