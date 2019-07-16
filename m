Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDC396A9C4
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 15:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387649AbfGPNjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 09:39:02 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2271 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728137AbfGPNjC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 09:39:02 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0E492C9C31D5B450C74A;
        Tue, 16 Jul 2019 21:39:00 +0800 (CST)
Received: from [127.0.0.1] (10.133.213.239) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Tue, 16 Jul 2019
 21:38:55 +0800
Subject: Re: [PATCH] libertas_tf: Use correct channel range in lbtf_geo_init
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <lkundrak@v3.sk>,
        <derosier@cal-sierra.com>
References: <20190716132534.11256-1-yuehaibing@huawei.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <8f63c6d6-26fd-1a00-ea22-43938e79f3d2@huawei.com>
Date:   Tue, 16 Jul 2019 21:38:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20190716132534.11256-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pls ignore this, sorry

On 2019/7/16 21:25, YueHaibing wrote:
> It seems we should use 'range' instead of 'priv->range'
> in lbtf_geo_init(), because 'range' is the corret one
> related to current regioncode.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 691cdb49388b ("libertas_tf: command helper functions for libertas_tf")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/wireless/marvell/libertas_tf/cmd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/marvell/libertas_tf/cmd.c b/drivers/net/wireless/marvell/libertas_tf/cmd.c
> index 1eacca0..a333172 100644
> --- a/drivers/net/wireless/marvell/libertas_tf/cmd.c
> +++ b/drivers/net/wireless/marvell/libertas_tf/cmd.c
> @@ -65,7 +65,7 @@ static void lbtf_geo_init(struct lbtf_private *priv)
>  			break;
>  		}
>  
> -	for (ch = priv->range.start; ch < priv->range.end; ch++)
> +	for (ch = range.start; ch < range.end; ch++)
>  		priv->channels[CHAN_TO_IDX(ch)].flags = 0;
>  }
>  
> 

