Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047CE30E074
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 18:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbhBCRDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 12:03:08 -0500
Received: from verein.lst.de ([213.95.11.211]:52278 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231651AbhBCQ5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 11:57:22 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id D16A468C7B; Wed,  3 Feb 2021 17:56:25 +0100 (CET)
Date:   Wed, 3 Feb 2021 17:56:21 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Boris Pismenny <borisp@mellanox.com>, smalin@marvell.com,
        Sagi Grimberg <sagi@grimberg.me>, yorayz@nvidia.com,
        boris.pismenny@gmail.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>,
        linux-nvme@lists.infradead.org, David Miller <davem@davemloft.net>,
        axboe@fb.com, Eric Dumazet <edumazet@google.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Ahern <dsahern@gmail.com>,
        Keith Busch <kbusch@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>, benishay@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v3 net-next 01/21] iov_iter: Introduce new procedures
 for copy to iter/pages
Message-ID: <20210203165621.GB6691@lst.de>
References: <20210201100509.27351-1-borisp@mellanox.com> <20210201100509.27351-2-borisp@mellanox.com> <20210201173548.GA12960@lst.de> <CAJ3xEMjLKoQe_OB_L+w2wwUGck74Gm6=GPA=CK73QpeFbXr7Bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ3xEMjLKoQe_OB_L+w2wwUGck74Gm6=GPA=CK73QpeFbXr7Bw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 08:00:51PM +0200, Or Gerlitz wrote:
> will look into this, any idea for a more suitable location?

Maybe just a new file under lib/ for now?

> > Overly long line.  But we're also looking into generic helpers for
> > this kind of things, not sure if they made it to linux-next in the
> > meantime, but please check.
> 
> This is what I found in linux-next - note sure if you were referring to it
> 
> commit 11432a3cc061c39475295be533c3674c4f8a6d0b
> Author: David Howells <dhowells@redhat.com>
> 
>     iov_iter: Add ITER_XARRAY

No, that's not it.  Ira, what is the status of the memcpy_{to,from}_page
helpers?
