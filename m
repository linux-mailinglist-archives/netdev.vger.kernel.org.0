Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B6360D168
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 18:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbiJYQOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 12:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiJYQOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 12:14:47 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073F810DE
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 09:14:46 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id C08B168B05; Tue, 25 Oct 2022 18:14:42 +0200 (CEST)
Date:   Tue, 25 Oct 2022 18:14:42 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Aurelien Aptel <aaptel@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, smalin@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: Re: [PATCH v7 04/23] Revert "nvme-tcp: remove the unused
 queue_size member in nvme_tcp_queue"
Message-ID: <20221025161442.GD26372@lst.de>
References: <20221025135958.6242-1-aaptel@nvidia.com> <20221025135958.6242-5-aaptel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025135958.6242-5-aaptel@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 04:59:39PM +0300, Aurelien Aptel wrote:
> This reverts commit fb8745d040ef5b9080003325e56b91fefe1022bb.
> 
> The newly added NVMeTCP offload requires the field
> nvme_tcp_queue->queue_size in the patch
> "nvme-tcp: Add DDP offload control path" in nvme_tcp_offload_socket().
> The queue size is part of struct ulp_ddp_config
> parameters.

Please never do reverts if you just bring something back for an entirely
differenet reason.  And I think we need a really good justification of
why you have a code path that can get the queue struct and not the
controller, which really should not happen.
