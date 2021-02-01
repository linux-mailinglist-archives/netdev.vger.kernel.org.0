Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28D730AE19
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 18:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbhBARib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 12:38:31 -0500
Received: from verein.lst.de ([213.95.11.211]:42328 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229981AbhBARiZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 12:38:25 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 63B1968AFE; Mon,  1 Feb 2021 18:37:44 +0100 (CET)
Date:   Mon, 1 Feb 2021 18:37:44 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Boris Pismenny <borisp@mellanox.com>
Cc:     dsahern@gmail.com, kuba@kernel.org, davem@davemloft.net,
        saeedm@nvidia.com, hch@lst.de, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com,
        smalin@marvell.com, boris.pismenny@gmail.com,
        linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        benishay@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: Re: [PATCH v3 net-next  07/21] nvme-tcp: Add DDP data-path
Message-ID: <20210201173744.GC12960@lst.de>
References: <20210201100509.27351-1-borisp@mellanox.com> <20210201100509.27351-8-borisp@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201100509.27351-8-borisp@mellanox.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given how much ddp code there is can you split it into a separate file?
