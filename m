Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9419A60D138
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 18:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbiJYQCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 12:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbiJYQCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 12:02:04 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B741A190444
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 09:02:03 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 46BD368C4E; Tue, 25 Oct 2022 18:02:00 +0200 (CEST)
Date:   Tue, 25 Oct 2022 18:01:59 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Aurelien Aptel <aaptel@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, smalin@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: Re: [PATCH v7 02/23] iov_iter: DDP copy to iter/pages
Message-ID: <20221025160159.GB26372@lst.de>
References: <20221025135958.6242-1-aaptel@nvidia.com> <20221025135958.6242-3-aaptel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025135958.6242-3-aaptel@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I don't think this is a good subject line.  What the patch does is
to skip the memcpy, so something about that in the subject.  You
can then explain the commit log why that is done.  And given that
the behavior isn't all that obvious I think a big fat comment in the
code would be very helpful in this case as well.
