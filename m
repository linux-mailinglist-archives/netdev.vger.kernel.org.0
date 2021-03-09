Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B6B331DBD
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 04:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCID4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 22:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhCID4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 22:56:24 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F13C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 19:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=z2zRpvHdGq6Zae+MwlWjVQzZYmVxHSp6/4V8tw7v8FM=; b=J19e3Yn7vilwLEEd7vNIjFvAQK
        27npBEri/xif6wRHUjulE/gGzxLxfWvxPjqUU6t59UTs2jMT+sg/fh9s5H0owaKc+wQV+yKbztPJu
        wJaFPqCf7nPPD2Q+aYfsovAZjyqTs9UtKD4WeQ1BmhUlpI05oIgKstD6dELAoZkFWCFMcbuROJArG
        YbFLv0NRWhD7/h0qpegvbw7Q6/lfVLEYMDRoFH4WmNllZ0tE1Wae1MnNwsAsFoltKfjL+QTt1nVC+
        jRRqtP0dcfnGvg4ExvBcZ6vIktsG9+VY5CledUTfto7xAoI3eNuTntKA2BdrNlOdBrabhXzZtn3/k
        MxpUFPag==;
Received: from merlin.infradead.org ([2001:8b0:10b:1234::107])
        by desiato.infradead.org with esmtps (Exim 4.94 #2 (Red Hat Linux))
        id 1lJTTp-003iYc-Tj; Tue, 09 Mar 2021 03:56:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=z2zRpvHdGq6Zae+MwlWjVQzZYmVxHSp6/4V8tw7v8FM=; b=eDJjAkeWGMpVHOLN/0tWfKim7Q
        6wdgjMuGdS0V0cvEys86HDMTD7GVkC56AtyG21Fb1L1tR9BqS0tcmm9G8dGtIWIOWKEKBbYz8hm9M
        5/1peaw5k3ubiWjYKdscLSf3sY5GRpAMXGO56jW8uyTBXNgbXzHV7f/IM13XACkwreDO3aJqd39Os
        bhJsqrBRLqTxDINNjLEUf2JruK/5gTpO1pXKYOcxd6MQcthjZ6v0RUZvd+6mPKQK9ALRlonjER82A
        4PVR4HkWH6ytXcPpHmLlViK7OK4+5chfceJ9Tl5kaEPji2bXvEpPV6gJYrdUQIvMVSwaTvNwqJ4+l
        LPZvI5jw==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lJTTJ-000byl-T0; Tue, 09 Mar 2021 03:55:50 +0000
Subject: Re: [PATCH] net: ethernet: chelsio: inline_crypto: Mundane typos
 fixed throughout the file chcr_ktls.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, ayush.sawal@chelsio.com,
        vinay.yadav@chelsio.com, rohitm@chelsio.com, davem@davemloft.net,
        kuba@kernel.org, arnd@arndb.de, yuehaibing@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210306212028.3860-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <73477f4c-1ab5-965b-eb1a-e8b4f410d0d1@infradead.org>
Date:   Mon, 8 Mar 2021 19:55:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210306212028.3860-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/6/21 1:20 PM, Bhaskar Chowdhury wrote:
> 
> 
> Mundane typos fixes throughout the file.

          typo fixes
and in Subject:

> 
> s/establised/established/
> s/availbale/available/
> s/vaues/values/
> s/Incase/In case/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

with the above fixes:

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  .../ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c    | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
> index 1b7e8c91b541..6a9c6aa73eb4 100644
> --- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
> +++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
> @@ -677,7 +677,7 @@ static int chcr_ktls_cpl_act_open_rpl(struct adapter *adap,
>  	if (tx_info->pending_close) {
>  		spin_unlock(&tx_info->lock);
>  		if (!status) {
> -			/* it's a late success, tcb status is establised,
> +			/* it's a late success, tcb status is established,
>  			 * mark it close.
>  			 */
>  			chcr_ktls_mark_tcb_close(tx_info);
> @@ -935,7 +935,7 @@ chcr_ktls_get_tx_flits(u32 nr_frags, unsigned int key_ctx_len)
>  }
> 
>  /*
> - * chcr_ktls_check_tcp_options: To check if there is any TCP option availbale
> + * chcr_ktls_check_tcp_options: To check if there is any TCP option available
>   * other than timestamp.
>   * @skb - skb contains partial record..
>   * return: 1 / 0
> @@ -1120,7 +1120,7 @@ static int chcr_ktls_xmit_wr_complete(struct sk_buff *skb,
>  	}
> 
>  	if (unlikely(credits < ETHTXQ_STOP_THRES)) {
> -		/* Credits are below the threshold vaues, stop the queue after
> +		/* Credits are below the threshold values, stop the queue after
>  		 * injecting the Work Request for this packet.
>  		 */
>  		chcr_eth_txq_stop(q);
> @@ -2011,7 +2011,7 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
> 
>  	/* TCP segments can be in received either complete or partial.
>  	 * chcr_end_part_handler will handle cases if complete record or end
> -	 * part of the record is received. Incase of partial end part of record,
> +	 * part of the record is received. In case of partial end part of record,
>  	 * we will send the complete record again.
>  	 */
> 
> --


-- 
~Randy

