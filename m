Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9832259E22
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 20:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbgIASfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 14:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgIASfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 14:35:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80420C061244;
        Tue,  1 Sep 2020 11:35:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BFE3B1362DF13;
        Tue,  1 Sep 2020 11:18:18 -0700 (PDT)
Date:   Tue, 01 Sep 2020 11:34:45 -0700 (PDT)
Message-Id: <20200901.113445.1511774749622784918.davem@davemloft.net>
To:     linyunsheng@huawei.com
Cc:     eric.dumazet@gmail.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        john.fastabend@gmail.com
Subject: Re: [PATCH net-next] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2b60e7fd-a86a-89ab-2759-e7a83e0e28cd@huawei.com>
References: <1598921718-79505-1-git-send-email-linyunsheng@huawei.com>
        <2d93706f-3ba6-128b-738a-b063216eba6d@gmail.com>
        <2b60e7fd-a86a-89ab-2759-e7a83e0e28cd@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 01 Sep 2020 11:18:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>
Date: Tue, 1 Sep 2020 15:27:44 +0800

> On 2020/9/1 14:48, Eric Dumazet wrote:
>> We request Fixes: tag for fixes in networking land.
> 
> ok.
> 
> Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")

You should repost the patch with the Fixes: tag in order to add it, you
can't just mention it in this thread.

And the patch has to change anyways as you were also given other
feedback from Eric to address as well.

Thank you.
