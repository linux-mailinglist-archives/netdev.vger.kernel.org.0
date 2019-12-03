Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCB8110589
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 20:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfLCTy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 14:54:27 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52014 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbfLCTy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 14:54:26 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3A27E1510CBEF;
        Tue,  3 Dec 2019 11:54:26 -0800 (PST)
Date:   Tue, 03 Dec 2019 11:54:25 -0800 (PST)
Message-Id: <20191203.115425.1700524898044563095.davem@davemloft.net>
To:     dust.li@linux.alibaba.com
Cc:     xiyou.wangcong@gmail.com, jhs@mojatatu.com, jiri@resnulli.us,
        john.fastabend@gmail.com, tonylu@linux.alibaba.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: sched: fix dump qlen for sch_mq/sch_mqprio
 with NOLOCK subqueues
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191203031740.41506-1-dust.li@linux.alibaba.com>
References: <20191203031740.41506-1-dust.li@linux.alibaba.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Dec 2019 11:54:26 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dust Li <dust.li@linux.alibaba.com>
Date: Tue,  3 Dec 2019 11:17:40 +0800

>  sch->q.len hasn't been set if the subqueue is a NOLOCK qdisc
>  in mq_dump() and mqprio_dump().
> 
> Fixes: ce679e8df7ed ("net: sched: add support for TCQ_F_NOLOCK subqueues to sch_mqprio")
> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>

Applied and queued up for -stable, thank you.
