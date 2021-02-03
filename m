Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6061130E357
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 20:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhBCTfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 14:35:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:8699 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229691AbhBCTfQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 14:35:16 -0500
IronPort-SDR: olQfeQKGKTDS0I0MToY+7CvkUsPIrhaSdPsF8+Ee0cKsbALtKsi7dl9gpW+rk161s3Ff8EHueQ
 f/mSs7nKJqpg==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="168212444"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="168212444"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 11:34:35 -0800
IronPort-SDR: KMYc5m6y1qew0epiy/aL3Gs0A0RnOPmZyGoUSc1qC0R7zLd9n01mIKjMMtvfqPTxjhuY/a8TX/
 wGgGG9RN5nvg==
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="371603427"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 11:34:34 -0800
Date:   Wed, 3 Feb 2021 11:34:34 -0800
From:   Ira Weiny <ira.weiny@intel.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Or Gerlitz <gerlitz.or@gmail.com>,
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
        Or Gerlitz <ogerlitz@nvidia.com>
Subject: Re: [PATCH v3 net-next 01/21] iov_iter: Introduce new procedures for
 copy to iter/pages
Message-ID: <20210203193434.GD3200985@iweiny-DESK2.sc.intel.com>
References: <20210201100509.27351-1-borisp@mellanox.com>
 <20210201100509.27351-2-borisp@mellanox.com>
 <20210201173548.GA12960@lst.de>
 <CAJ3xEMjLKoQe_OB_L+w2wwUGck74Gm6=GPA=CK73QpeFbXr7Bw@mail.gmail.com>
 <20210203165621.GB6691@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203165621.GB6691@lst.de>
User-Agent: Mutt/1.11.1 (2018-12-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 05:56:21PM +0100, Christoph Hellwig wrote:
> On Tue, Feb 02, 2021 at 08:00:51PM +0200, Or Gerlitz wrote:
> > will look into this, any idea for a more suitable location?
> 
> Maybe just a new file under lib/ for now?
> 
> > > Overly long line.  But we're also looking into generic helpers for
> > > this kind of things, not sure if they made it to linux-next in the
> > > meantime, but please check.
> > 
> > This is what I found in linux-next - note sure if you were referring to it
> > 
> > commit 11432a3cc061c39475295be533c3674c4f8a6d0b
> > Author: David Howells <dhowells@redhat.com>
> > 
> >     iov_iter: Add ITER_XARRAY
> 
> No, that's not it.  Ira, what is the status of the memcpy_{to,from}_page
> helpers?

Converting the entire kernel tree in one series has become unwieldy so I've
given up.

But I have a series to convert btrfs which I could release by the end of the
week.  That should be good enough to push the memcpy_*_page() support in.

I'm get it formatted and submitted,
Ira
