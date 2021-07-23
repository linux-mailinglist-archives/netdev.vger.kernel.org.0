Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480C63D346B
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 08:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233835AbhGWF0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 01:26:01 -0400
Received: from verein.lst.de ([213.95.11.211]:37115 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233733AbhGWF0A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 01:26:00 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6DA4A67373; Fri, 23 Jul 2021 08:06:31 +0200 (CEST)
Date:   Fri, 23 Jul 2021 08:06:31 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Boris Pismenny <borisp@nvidia.com>
Cc:     dsahern@gmail.com, kuba@kernel.org, davem@davemloft.net,
        saeedm@nvidia.com, hch@lst.de, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com,
        smalin@marvell.com, boris.pismenny@gmail.com,
        linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        benishay@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        Boris Pismenny <borisp@mellanox.com>
Subject: Re: [PATCH v5 net-next 04/36] net/tls: expose get_netdev_for_sock
Message-ID: <20210723060631.GA32369@lst.de>
References: <20210722110325.371-1-borisp@nvidia.com> <20210722110325.371-5-borisp@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722110325.371-5-borisp@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 02:02:53PM +0300, Boris Pismenny wrote:
> From: Boris Pismenny <borisp@mellanox.com>
> 
> get_netdev_for_sock is a utility that is used to obtain
> the net_device structure from a connected socket.
> 
> Later patches will use this for nvme-tcp DDP and DDP DDGST offloads.
> 
> Signed-off-by: Boris Pismenny <borisp@mellanox.com>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>

I don't think this should be an inline.  Please move it to net/core/dev.c,
andd add an EXPORT_SYMBOL_GPL and a kerneldoc comment.
