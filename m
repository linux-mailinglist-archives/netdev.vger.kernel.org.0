Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC6437A80B
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 15:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhEKNt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 09:49:27 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2562 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhEKNtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 09:49:25 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FffM52MMPzwSNl;
        Tue, 11 May 2021 21:45:37 +0800 (CST)
Received: from [127.0.0.1] (10.174.177.72) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.498.0; Tue, 11 May 2021
 21:48:12 +0800
Subject: Re: [PATCH] net: forcedeth: Give bot handlers a helping hand
 understanding the code
To:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>
References: <20210511124330.891694-1-andrew@lunn.ch>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <e267c38d-5ddd-244a-d083-9dbe4ed9973c@huawei.com>
Date:   Tue, 11 May 2021 21:48:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20210511124330.891694-1-andrew@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.72]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/5/11 20:43, Andrew Lunn wrote:
> Bots handlers repeatedly fail to understand nv_update_linkspeed() and
> submit patches unoptimizing it for the human reader. Add a comment to
> try to prevent this in the future.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/ethernet/nvidia/forcedeth.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
> index 8724d6a9ed02..0822b28f3b6a 100644
> --- a/drivers/net/ethernet/nvidia/forcedeth.c
> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
> @@ -3475,6 +3475,9 @@ static int nv_update_linkspeed(struct net_device *dev)
>  		newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
>  		newdup = 0;
>  	} else {
> +		/* Default to the same as 10/Half if we cannot
> +		 * determine anything else.
> +		 */
I think it would be better to remove the if branch above and then add comments here.
Otherwise, it becomes more and more redundant.

>  		newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
>  		newdup = 0;
>  	}
> 

