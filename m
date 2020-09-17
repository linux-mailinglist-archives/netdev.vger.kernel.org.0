Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E674926D0D7
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 03:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgIQBvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 21:51:06 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:42354 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726072AbgIQBvF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 21:51:05 -0400
X-Greylist: delayed 950 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 21:51:04 EDT
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CAED83E5D1A9CAA3CECC;
        Thu, 17 Sep 2020 09:35:11 +0800 (CST)
Received: from [10.174.179.108] (10.174.179.108) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Thu, 17 Sep 2020 09:35:07 +0800
Subject: Re: [PATCH -next] net/sched: Remove unused function
 qdisc_queue_drop_head()
To:     <davem@davemloft.net>, <kuba@kernel.org>
References: <20200916141611.43524-1-yuehaibing@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <5b7b6ff1-19ea-33b6-87b7-2cee6db8157d@huawei.com>
Date:   Thu, 17 Sep 2020 09:35:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20200916141611.43524-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pls drop this duplicate.

On 2020/9/16 22:16, YueHaibing wrote:
> It is not used since commit a09ceb0e0814 ("sched: remove qdisc->drop")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  include/net/sch_generic.h | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index d60e7c39d60c..6c762457122f 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -1047,12 +1047,6 @@ static inline unsigned int __qdisc_queue_drop_head(struct Qdisc *sch,
>  	return 0;
>  }
>  
> -static inline unsigned int qdisc_queue_drop_head(struct Qdisc *sch,
> -						 struct sk_buff **to_free)
> -{
> -	return __qdisc_queue_drop_head(sch, &sch->q, to_free);
> -}
> -
>  static inline struct sk_buff *qdisc_peek_head(struct Qdisc *sch)
>  {
>  	const struct qdisc_skb_head *qh = &sch->q;
> 
