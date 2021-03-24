Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBB9347E61
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 18:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236630AbhCXRAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 13:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234343AbhCXRAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 13:00:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9708C061763;
        Wed, 24 Mar 2021 10:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=+uk2xeABGkHiooQn7k65Uy5rAnQd1BMsBmMwXXODHko=; b=Q70qjq1z1RpzBbSxwCkI9JmcEF
        eDirFRu4VBM91928vtLLM0Y8fVQ6EZysxPpa+Xa/MPKwIjgYaOte5wR9aTFFQhy62vr898CrFyYux
        KKZADXXNQDP2tGOKcA9465oharQGzN0YCi11/dWdOba0wBx6/94q2GpzgVU9TU7L6u8HZb/nVN90I
        vfcZhSFF8Q1nOTSbQfvnnXz2GWk0PiMmfgOZb6hza3DaB1/i2k0CXsliaxC5f8DFBHs1gWWkLZWjb
        hahdVBe4lBzqGDyRnKQUZk2DBURw8KVtaKkFvWiFzOEUMtKAfEYxxI/JJ/YRJZf8Osvl8GyT8Rvuu
        LA1ycgfw==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lP6qG-00BbkN-FK; Wed, 24 Mar 2021 16:59:32 +0000
Subject: Re: [PATCH net-next] net/tls: Fix a typo in tls_device.c
To:     Wang Hai <wanghai38@huawei.com>, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210324061622.8665-1-wanghai38@huawei.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <b32aa177-5829-be9b-88ec-c1c1b333a6e4@infradead.org>
Date:   Wed, 24 Mar 2021 09:58:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210324061622.8665-1-wanghai38@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/21 11:16 PM, Wang Hai wrote:
> s/beggining/beginning/
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  net/tls/tls_device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index f7fb7d2c1de1..89a5d4fad0a2 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -601,7 +601,7 @@ struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
>  	if (!info ||
>  	    before(seq, info->end_seq - info->len)) {
>  		/* if retransmit_hint is irrelevant start
> -		 * from the beggining of the list
> +		 * from the beginning of the list
>  		 */
>  		info = list_first_entry_or_null(&context->records_list,
>  						struct tls_record_info, list);
> 


-- 
~Randy

