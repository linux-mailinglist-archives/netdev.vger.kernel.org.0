Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D9D5897AE
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 08:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbiHDGNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 02:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbiHDGNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 02:13:43 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B40561126
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 23:13:42 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id h13so4746371wrf.6
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 23:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5DNAHZ4FOgOD72+NWdm/eD/+nzcJcctj/0E3tLe5nlg=;
        b=KmVEbf5FJ2Jm3DRYDHP8rYgF99B6dCgJ0BpGiPyqJGeFHUGoN9NJMYa4UxwpzTcrVn
         PwclBXiGewzWlOFfxFi7DNYE15KTwDusoVvOgs/2G1XGl0Otjb3aDZiwJf5pbbwx/IWz
         FmE8crWWPBtP5KuWlCPoMKHOd8bbRREWIZoc6WQ0eu9AVJMHW3OGaas2D+qQnnLBqFzw
         0YSv0ACZrLt/j4LsBmHJB2SVkoV7MfW5U/fsbOrHk4nrWIWkAIM2cdrBXbYuIHkI3fj2
         Nx0/PJfv2DvfwAzBp1h8Twd7iRWXLXBC/rJIdG4GVO1gbGEH3xSBrmYXdgiRLMefA858
         TRUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5DNAHZ4FOgOD72+NWdm/eD/+nzcJcctj/0E3tLe5nlg=;
        b=cLZrCYYeN94hZmvZxkF6CyoSPCq8KbEVTh9Xzo9D0SBTSGMdBZsJlKM43UNfldnkKp
         YghxXp0hg1VvuP2WxsDnhFOew5t6u6F4NCAyVW+OUteoPlcjfCpcq81zspleqv7tILVd
         I3D5pPk3Hj9+NGuC5NaYSIUYi3khV83ZJk64RpxXHjDRcp/Ymkw6blmlWxXoDyl0zMQ0
         x/PCRO45hn3ah4inOxjOqkFHwkNHq7eW4UP179BbXVnGY+FxjJlKm1D7SIsWTCjqUviK
         UL7Oo26vQhkdF2RAFagpOw1tPPsdbhda5UoPt1r3h1llHu2QGQYGtg1UynU7hm6qvzrZ
         5Wcg==
X-Gm-Message-State: ACgBeo0B5j3GgkQNZJwdmPfPMmGIrxooPFlPgOMPKeXva0uLkr45wSeZ
        3hQusOITzXgnjcsbqjGcX7YEibJ2sCE=
X-Google-Smtp-Source: AA6agR5nqvsmSLWEZNAH9+iNDYFhfPY7/Q4Jnwnoq48OI+VxrcDl7D2/lr4A50soW8Ypk2XrDigNBA==
X-Received: by 2002:adf:de05:0:b0:220:6c9e:5fd9 with SMTP id b5-20020adfde05000000b002206c9e5fd9mr259617wrm.260.1659593620735;
        Wed, 03 Aug 2022 23:13:40 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id z5-20020adfe545000000b0021e50971147sm57614wrm.44.2022.08.03.23.13.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 23:13:40 -0700 (PDT)
Message-ID: <9dccb71f-e9a2-81f3-28bc-c170719a5f49@gmail.com>
Date:   Thu, 4 Aug 2022 09:13:37 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v3 7/7] tls: rx: do not use the standard
 strparser
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Ran Rozenstein <ranro@nvidia.com>,
        "gal@nvidia.com" <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20220722235033.2594446-1-kuba@kernel.org>
 <20220722235033.2594446-8-kuba@kernel.org>
 <84406eec-289b-edde-759a-cf0b2c39c150@gmail.com>
 <20220803182432.363b0c04@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220803182432.363b0c04@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/4/2022 4:24 AM, Jakub Kicinski wrote:
> On Tue, 2 Aug 2022 17:54:01 +0300 Tariq Toukan wrote:
>>    [  407.589886] RIP: 0010:tls_device_decrypted+0x7a/0x2e0
> 
> Sorry, got distracted yesterday. This?

I also had issues yesterday with the decode script.
For some reason, it didn't work for me.
Probably a missing env variable, or a kernel config.

...
? tls_rx_rec_wait (tls_sw.c:?)
tls_rx_one_record (tls_sw.c:?)
tls_sw_recvmsg (??:?)
? __wait_for_common (build_utility.c:?)
? usleep_range_state (??:?)
inet6_recvmsg (??:?)
____sys_recvmsg (socket.c:?)
? _copy_from_user (??:?)
? iovec_from_user (??:?)
___sys_recvmsg (socket.c:?)
WARNING! Modules path isn't set, but is needed to parse this symbol
? post_static_params+0x15c/0x320 mlx5_core
WARNING! Modules path isn't set, but is needed to parse this symbol
? mlx5e_ktls_add_rx+0x3d1/0x5d0 mlx5_core
WARNING! Modules path isn't set, but is needed to parse this symbol
? mlx5e_ktls_add_rx+0x45d/0x5d0 mlx5_core
...

> 
> --->8--------------------
> tls: rx: device: bound the frag walk
> 
> We can't do skb_walk_frags() on the input skbs, because
> the input skbs is really just a pointer to the tcp read
> queue. We need to bound the "is decrypted" check by the
> amount of data in the message.
> 
> Note that the walk in tls_device_reencrypt() is after a
> CoW so the skb there is safe to walk. Actually in the
> current implementation it can't have frags at all, but
> whatever, maybe one day it will.
> 
> Reported-by: Tariq Toukan <tariqt@nvidia.com>
> Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   net/tls/tls_device.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index e3e6cf75aa03..6ed41474bdf8 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -984,11 +984,17 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx)
>   	int is_decrypted = skb->decrypted;
>   	int is_encrypted = !is_decrypted;
>   	struct sk_buff *skb_iter;
> +	int left;
>   
> +	left = rxm->full_len - skb->len;
>   	/* Check if all the data is decrypted already */
> -	skb_walk_frags(skb, skb_iter) {
> +	skb_iter = skb_shinfo(skb)->frag_list;
> +	while (skb_iter && left > 0) {
>   		is_decrypted &= skb_iter->decrypted;
>   		is_encrypted &= !skb_iter->decrypted;
> +
> +		left -= skb_iter->len;
> +		skb_iter = skb_iter->next;
>   	}
>   
>   	trace_tls_device_decrypted(sk, tcp_sk(sk)->copied_seq - rxm->full_len,

Thanks!
Testing it. I'll update.
