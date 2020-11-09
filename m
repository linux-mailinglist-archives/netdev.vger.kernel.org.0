Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315772AB88A
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 13:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbgKIMqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 07:46:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:48646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727311AbgKIMp7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 07:45:59 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F147E20659;
        Mon,  9 Nov 2020 12:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604925958;
        bh=XGv29gtnKEeD+MqLt6Z0oRnSXCeM5E2a/egTV6CQId8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I1dYxZdpMejwJkwo9vR9NrfBKl3MzlQL1sEAIkSo3hXBHGcGx9cXupWTwWqvdUGhh
         j2QkK+oq8GcqqucEj7+bGHrJsDV+xaQ6N0/1y8NG0P8uC10jEF8Q0K8+5kcKdG/tNw
         AAHml90l9mRbjI6wdTR4agGd03aWEaMG4Lu0JMbA=
Date:   Mon, 9 Nov 2020 13:46:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     stable@vger.kernel.org, vpai@akamai.com,
        Joakim.Tjernlund@infinera.com, xiyou.wangcong@gmail.com,
        johunt@akamai.com, jhs@mojatatu.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        john.fastabend@gmail.com, eric.dumazet@gmail.com, dsahern@gmail.com
Subject: Re: [PATCH stable] net: sch_generic: fix the missing new qdisc
 assignment bug
Message-ID: <20201109124658.GC1834954@kroah.com>
References: <1604373938-211588-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604373938-211588-1-git-send-email-linyunsheng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 11:25:38AM +0800, Yunsheng Lin wrote:
> commit 2fb541c862c9 ("net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc")
> 
> When the above upstream commit is backported to stable kernel,
> one assignment is missing, which causes two problems reported
> by Joakim and Vishwanath, see [1] and [2].
> 
> So add the assignment back to fix it.
> 
> 1. https://www.spinics.net/lists/netdev/msg693916.html
> 2. https://www.spinics.net/lists/netdev/msg695131.html
> 
> Fixes: 749cc0b0c7f3 ("net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc")
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  net/sched/sch_generic.c | 3 +++
>  1 file changed, 3 insertions(+)

What kernel tree(s) does this need to be backported to?

thanks,

greg k-h
