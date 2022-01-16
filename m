Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCAE48FE3A
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 18:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235923AbiAPRr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 12:47:57 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:33736 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231224AbiAPRr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 12:47:57 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V1xwBmp_1642355274;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V1xwBmp_1642355274)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 17 Jan 2022 01:47:54 +0800
Date:   Mon, 17 Jan 2022 01:47:53 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/6] net/smc: Spread workload over multiple
 cores
Message-ID: <YeRaSdg8TcNJsGBB@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220114054852.38058-1-tonylu@linux.alibaba.com>
 <YePesYRnrKCh1vFy@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YePesYRnrKCh1vFy@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 16, 2022 at 11:00:33AM +0200, Leon Romanovsky wrote:
> On Fri, Jan 14, 2022 at 01:48:46PM +0800, Tony Lu wrote:
> > <snip>
> > 
> > These patches are still improving, I am very glad to hear your advice.
> 
> Please CC RDMA mailing list next time.

I will do it in the next patch.
 
> Why didn't you use already existed APIs in drivers/infiniband/core/cq.c?
> ib_cq_pool_get() will do most if not all of your open-coded CQ spreading
> logic.

Thanks for your advice. I have looked into this API about shared CQ
pool. It should suit for this scene after my brief test. I will replace
the logic of least-used CQ to this CQ pool API in the next patch.

Thank you.
Tony Lu
