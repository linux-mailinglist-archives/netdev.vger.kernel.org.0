Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E73D185E64
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 17:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgCOQJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 12:09:49 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:60843 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728310AbgCOQJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 12:09:48 -0400
Received: from [10.193.177.146] (balakrishna-l.asicdesigners.com [10.193.177.146] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02FG9PwS006951;
        Sun, 15 Mar 2020 09:09:26 -0700
Subject: Re: [PATCH net-next] chcr: remove set but not used variable 'status'
To:     YueHaibing <yuehaibing@huawei.com>, ayush.sawal@chelsio.com,
        vinay.yadav@chelsio.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20200314105120.20968-1-yuehaibing@huawei.com>
From:   rohit maheshwari <rohitm@chelsio.com>
Message-ID: <a3e5ad76-80c2-cef3-7de2-7495d2c15da5@chelsio.com>
Date:   Sun, 15 Mar 2020 21:39:24 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20200314105120.20968-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 14/03/20 4:21 PM, YueHaibing wrote:
> drivers/crypto/chelsio/chcr_ktls.c: In function chcr_ktls_cpl_set_tcb_rpl:
> drivers/crypto/chelsio/chcr_ktls.c:662:11: warning:
>   variable status set but not used [-Wunused-but-set-variable]
>
> commit 8a30923e1598 ("cxgb4/chcr: Save tx keys and handle HW response")
> involved this unused variable, remove it.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   drivers/crypto/chelsio/chcr_ktls.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
> index f0c3834eda4f..00099e793e63 100644
> --- a/drivers/crypto/chelsio/chcr_ktls.c
> +++ b/drivers/crypto/chelsio/chcr_ktls.c
> @@ -659,10 +659,9 @@ int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char *input)
>   	const struct cpl_set_tcb_rpl *p = (void *)input;
>   	struct chcr_ktls_info *tx_info = NULL;
>   	struct tid_info *t;
> -	u32 tid, status;
> +	u32 tid;
>   
>   	tid = GET_TID(p);
> -	status = p->status;
>   
>   	t = &adap->tids;
>   	tx_info = lookup_tid(t, tid);

Thanks for fixing it. Looks good to me.


