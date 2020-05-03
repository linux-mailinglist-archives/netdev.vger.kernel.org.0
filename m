Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDD71C3031
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 00:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgECWvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 18:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726661AbgECWvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 18:51:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49618C061A0E
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 15:51:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 53DFD1211C988;
        Sun,  3 May 2020 15:51:40 -0700 (PDT)
Date:   Sun, 03 May 2020 15:51:35 -0700 (PDT)
Message-Id: <20200503.155135.1534936083449625462.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 0/5] net_sched: sch_fq: round of optimizations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200503025422.219257-1-edumazet@google.com>
References: <20200503025422.219257-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 03 May 2020 15:51:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sat,  2 May 2020 19:54:17 -0700

> This series is focused on better layout of struct fq_flow to
> reduce number of cache line misses in fq_enqueue() and dequeue operations.
> 
> Eric Dumazet (5):
>   net_sched: sch_fq: avoid touching f->next from fq_gc()
>   net_sched: sch_fq: change fq_flow size/layout
>   net_sched: sch_fq: use bulk freeing in fq_gc()
>   net_sched: sch_fq: do not call fq_peek() twice per packet
>   net_sched: sch_fq: perform a prefetch() earlier

Series applied, thanks Eric.
