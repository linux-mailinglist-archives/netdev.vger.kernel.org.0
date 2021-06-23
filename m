Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481503B183B
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 12:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhFWKwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 06:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbhFWKwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 06:52:35 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B71EC061574;
        Wed, 23 Jun 2021 03:50:17 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id j1so2098283wrn.9;
        Wed, 23 Jun 2021 03:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gjn1di6HalbtdDPj7xjodc9LBuJxIKbGX9nw7MeYzL0=;
        b=cfEjoG7xDHQ4233K1kwJD3wBkQNolaQH4xMl5Zs/tY+WkuohXopRctYjKDZ9A+9+jE
         h0+rNiO6l1iQs8nau4Y7u04rMJ9O7ggvXXMRKWaqb8H/rWJVR/OqGIdb4nCif8pkQsjm
         yy6B2kdASxcx1KR8aqispQaS/AptcF08TGxUX/dP56NLGNaNBV72u8uz9OP8SnSOPu74
         ukOhNhcMoxfiIrNgGSPQUlF9Kn8Uk2XTugmbMOzD4rB3ge1bInyKyI6wMRNKA5UcP/0N
         5Ydk9GSoWyqMcGDS72pGQWIHhBB+MjC2jgAI+ISyIevs1YDgv4jD/XwFIEdFRFSF5W+0
         USoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gjn1di6HalbtdDPj7xjodc9LBuJxIKbGX9nw7MeYzL0=;
        b=tTAu3bPHYRHfv91ZxYhUrOFRwbRuoUN7EoAZgT+Kx84ST/UGdaxnyCCsecpFGo6Z5+
         7F3XXmAcOpLHt0vE5+BHjS7WaeTpCe4koD4Ucsh6BRrLTyyjfwiJ39vBDd7ia60GXBJt
         ilMO5GJ1rVTElO3gpSREBSFTOXaYbKhyem80FM46MvepRuaw+ue+tG8Jx7DfdAS56OKQ
         G70PzYlNcZt3l82LL0f5MhJW+TnAtJ+laJPpYvMtSehUmGREOR8d5ELHPvqDunOyTnjU
         pOpFz/VCtFcTkxGzGj9q5dmhoBRUJYLG52qULdtuJkSLrGCzzbXn1/QY4ljnB4t3Njql
         DgPw==
X-Gm-Message-State: AOAM530QGhES+9yypQadbYigyijh0prPMSwS3DEacokURSe8X2/un6NW
        arsVpUl8bKKBFf/A07+Onic=
X-Google-Smtp-Source: ABdhPJwQRw/swdt/8Kto68UZAbcSOTTRbCqLzjJx/v21y6Wcr4hKGKh9w6XYtx7xZvnJWmpBkcUSug==
X-Received: by 2002:adf:f808:: with SMTP id s8mr10454948wrp.270.1624445415778;
        Wed, 23 Jun 2021 03:50:15 -0700 (PDT)
Received: from [192.168.98.98] (8.249.23.93.rev.sfr.net. [93.23.249.8])
        by smtp.gmail.com with ESMTPSA id h46sm2793354wrh.44.2021.06.23.03.50.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 03:50:15 -0700 (PDT)
Subject: Re: [PATCH] net: caif: add a return statement
To:     13145886936@163.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
References: <20210623013238.9204-1-13145886936@163.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <151e4f4b-d3e9-5d46-d17f-04346a203f0e@gmail.com>
Date:   Wed, 23 Jun 2021 12:50:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210623013238.9204-1-13145886936@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/21 3:32 AM, 13145886936@163.com wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> Return statement is needed in every condition in Int function.


??? Are you a bot ??

Is it a real patch. How was it tested ?

> Fixed some grammar issues.
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> ---
>  net/caif/caif_socket.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
> index 3ad0a1df6712..84a00b9cb0dc 100644
> --- a/net/caif/caif_socket.c
> +++ b/net/caif/caif_socket.c
> @@ -281,7 +281,7 @@ static int caif_seqpkt_recvmsg(struct socket *sock, struct msghdr *m,
>  	if (flags & MSG_OOB)
>  		goto read_error;
>  
> -	skb = skb_recv_datagram(sk, flags, 0 , &ret);
> +	skb = skb_recv_datagram(sk, flags, 0, &ret);
>  	if (!skb)
>  		goto read_error;
>  	copylen = skb->len;
> @@ -295,6 +295,7 @@ static int caif_seqpkt_recvmsg(struct socket *sock, struct msghdr *m,
>  		goto out_free;
>  
>  	ret = (flags & MSG_TRUNC) ? skb->len : copylen;
> +	return ret;

This is completely bogus.

>  out_free:
>  	skb_free_datagram(sk, skb);
>  	caif_check_flow_release(sk);
> @@ -615,7 +616,7 @@ static int caif_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>  
>  	while (sent < len) {
>  
> -		size = len-sent;
> +		size = len - sent;
>  
>  		if (size > cf_sk->maxframe)
>  			size = cf_sk->maxframe;
> @@ -815,8 +816,8 @@ static int caif_connect(struct socket *sock, struct sockaddr *uaddr,
>  	sock->state = SS_CONNECTING;
>  	sk->sk_state = CAIF_CONNECTING;
>  
> -	/* Check priority value comming from socket */
> -	/* if priority value is out of range it will be ajusted */
> +	/* Check priority value coming from socket */
> +	/* if priority value is out of range it will be adjusted */
>  	if (cf_sk->sk.sk_priority > CAIF_PRIO_MAX)
>  		cf_sk->conn_req.priority = CAIF_PRIO_MAX;
>  	else if (cf_sk->sk.sk_priority < CAIF_PRIO_MIN)
> 
