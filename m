Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F763D3457
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 07:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbhGWFP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 01:15:57 -0400
Received: from verein.lst.de ([213.95.11.211]:37050 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231949AbhGWFP5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 01:15:57 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5BFFE68AFE; Fri, 23 Jul 2021 07:56:27 +0200 (CEST)
Date:   Fri, 23 Jul 2021 07:56:26 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Boris Pismenny <borisp@nvidia.com>
Cc:     dsahern@gmail.com, kuba@kernel.org, davem@davemloft.net,
        saeedm@nvidia.com, hch@lst.de, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com,
        smalin@marvell.com, boris.pismenny@gmail.com,
        linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        benishay@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        Boris Pismenny <borisp@mellanox.com>
Subject: Re: [PATCH v5 net-next 00/36] nvme-tcp receive and tarnsmit
 offloads
Message-ID: <20210723055626.GA32126@lst.de>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 02:02:49PM +0300, Boris Pismenny wrote:
> From: Boris Pismenny <borisp@mellanox.com>
> 
> Changes since v4:
> =========================================

Explaining what the series does should go before the changelog.

> * Add transmit offload patches

But to be honest, the previous one was already mostly unreviewable,
but this is now far beyond this.   Please try to get anything that
is generally useful first in smaller series and the come back with
a somewhat reviewable series.  That also means that at least for the
code I care about (nvme) the patches should be grouped together,
and actually provide meaningful functionality in each patch.  Right
now even trying to understand what you add to the nvme code requires
me to jump all over a gigantic series.
