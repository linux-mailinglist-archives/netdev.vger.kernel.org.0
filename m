Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9567915F
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbfG2Qrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:47:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35768 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbfG2Qrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:47:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D72281266535A;
        Mon, 29 Jul 2019 09:47:42 -0700 (PDT)
Date:   Mon, 29 Jul 2019 09:47:42 -0700 (PDT)
Message-Id: <20190729.094742.1840605528000035808.davem@davemloft.net>
To:     baijiaju1990@gmail.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: sched: Fix a possible null-pointer dereference
 in dequeue_func()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190729082433.28981-1-baijiaju1990@gmail.com>
References: <20190729082433.28981-1-baijiaju1990@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 09:47:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>
Date: Mon, 29 Jul 2019 16:24:33 +0800

> In dequeue_func(), there is an if statement on line 74 to check whether
> skb is NULL:
>     if (skb)
> 
> When skb is NULL, it is used on line 77:
>     prefetch(&skb->end);
> 
> Thus, a possible null-pointer dereference may occur.
> 
> To fix this bug, skb->end is used when skb is not NULL.
> 
> This bug is found by a static analysis tool STCheck written by us.
> 
> Fixes: 76e3cc126bb2 ("codel: Controlled Delay AQM")
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Applied and queued up for -stable.
