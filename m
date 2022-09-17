Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E80A5BB786
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 11:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiIQJXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 05:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiIQJXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 05:23:18 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C064932074;
        Sat, 17 Sep 2022 02:23:17 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id i203-20020a1c3bd4000000b003b3df9a5ecbso1300171wma.1;
        Sat, 17 Sep 2022 02:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=eMgMi20s6HCEICQPLX6qjfIcg3vLE+hwPAnzNnSezw0=;
        b=eqCT3SLLeBQXp9K/CnmvA2nLzOh40xhinNoziHTrCcHqBRIFhwFraumOgQv5ovDWza
         WI8rohKkHh1B3opEt6jhbJuk14bMjJ0b8NsruJ9RZ0KIDRG1PuhmifNgUwK2uho+QrcV
         ifB1FjYE0ApP9yNNnx7bSwI4xbNf5wcy5D1woMwG1rPtRth86VCbEx1M0NS53I1PvJ8/
         XdrvJ+7/3rfxnCTE1MsMqdDEk19QRtBU3Hmi4ERQrptD2WPDG3xYdIaKA/tRrCMYT3qo
         sKWf2NArqkNjQEGAv8o5vFnGvlvGTN4tKaJP5NGJRS+Uc36DpfMTDwyARMc4IhgdN1A2
         e9HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=eMgMi20s6HCEICQPLX6qjfIcg3vLE+hwPAnzNnSezw0=;
        b=tP/1fH9M7BHyfrQ2kHdtlyRwtrv1LwnTBT/Rwk2nVN//kSsBag5LMVNi9ItuPSdJl+
         MKcxkiup4xU/vNTV6sfSA3Ja1qwqXdpNKsXA4yEZlAdbzwigHSTFoaVIsddoaq3d9yUB
         SKRN8QrCMqgTxbVAq/Rfh1GH1kb5s5EELq/WoE6R8C7xIxAzaGZmTJoQd4HPF3Bpe3xn
         jOhz2WN0TvhkHMRj/2HLXMVdWaYtT89Dw8OdxnXGzt39eIKE346A7x9cngwbFXktSp1Y
         a74S8CzvzWqKUNCBREmjsOVFWRUmC2tSQkoTIjEEkIkal58mOlSKuyEql5z7BYfIzURx
         BwKw==
X-Gm-Message-State: ACrzQf3D/CITzHEaj6IbudXznec+vxHCPONZJTaCfx57o5r7fvmGJfzT
        bmPcCKLVm0PenIzftoT19l9iPMz2F4SouA==
X-Google-Smtp-Source: AMsMyM6xTP0vCSsEkNZoaF80Ng38E/dK4Qy8hXxDPpH0bj3gLdNxRjqtZ/EpB0mQ5PN+4tzrLDbRGQ==
X-Received: by 2002:a05:600c:34c6:b0:3b4:9643:e46d with SMTP id d6-20020a05600c34c600b003b49643e46dmr6173737wmq.9.1663406596208;
        Sat, 17 Sep 2022 02:23:16 -0700 (PDT)
Received: from [10.128.133.254] ([185.205.229.29])
        by smtp.gmail.com with ESMTPSA id y9-20020a05600c20c900b003a541d893desm5190901wmm.38.2022.09.17.02.23.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Sep 2022 02:23:15 -0700 (PDT)
Message-ID: <5f4059ca-cec6-e44a-ac61-b9c034b1be77@gmail.com>
Date:   Sat, 17 Sep 2022 10:22:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 5/5] io_uring/notif: let userspace know how effective the
 zero copy usage was
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        axboe@kernel.dk
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <cover.1663363798.git.metze@samba.org>
 <76cdd53f618e2793e1ec298c837bb17c3b9f12ee.1663363798.git.metze@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <76cdd53f618e2793e1ec298c837bb17c3b9f12ee.1663363798.git.metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/22 22:36, Stefan Metzmacher wrote:
> The 2nd cqe for IORING_OP_SEND_ZC has IORING_CQE_F_NOTIF set in cqe->flags
> and it will now have the number of successful completed
> io_uring_tx_zerocopy_callback() callbacks in the lower 31-bits
> of cqe->res, the high bit (0x80000000) is set when
> io_uring_tx_zerocopy_callback() was called with success=false.

It has a couple of problems, and because that "simplify uapi"
patch is transitional it doesn't go well with what I'm queuing
for 6.1, let's hold it for a while.


> If cqe->res is still 0, zero copy wasn't used at all.
> 
> These values give userspace a change to adjust its strategy
> choosing IORING_OP_SEND_ZC or IORING_OP_SEND. And it's a bit
> richer than just a simple SO_EE_CODE_ZEROCOPY_COPIED indication.
> 
> Fixes: b48c312be05e8 ("io_uring/net: simplify zerocopy send user API")
> Fixes: eb315a7d1396b ("tcp: support externally provided ubufs")
> Fixes: 1fd3ae8c906c0 ("ipv6/udp: support externally provided ubufs")
> Fixes: c445f31b3cfaa ("ipv4/udp: support externally provided ubufs")
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: io-uring@vger.kernel.org
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> ---
>   io_uring/notif.c      | 18 ++++++++++++++++++
>   net/ipv4/ip_output.c  |  3 ++-
>   net/ipv4/tcp.c        |  2 ++
>   net/ipv6/ip6_output.c |  3 ++-
>   4 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/notif.c b/io_uring/notif.c
> index e37c6569d82e..b07d2a049931 100644
> --- a/io_uring/notif.c
> +++ b/io_uring/notif.c
> @@ -28,7 +28,24 @@ static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
>   	struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
>   	struct io_kiocb *notif = cmd_to_io_kiocb(nd);
>   
> +	uarg->zerocopy = uarg->zerocopy & success;
> +
> +	if (success && notif->cqe.res < S32_MAX)
> +		notif->cqe.res++;
> +
>   	if (refcount_dec_and_test(&uarg->refcnt)) {
> +		/*
> +		 * If we hit at least one case that
> +		 * was not able to use zero copy,
> +		 * we set the high bit 0x80000000
> +		 * so that notif->cqe.res < 0, means it was
> +		 * as least copied once.
> +		 *
> +		 * The other 31 bits are the success count.
> +		 */
> +		if (!uarg->zerocopy)
> +			notif->cqe.res |= S32_MIN;
> +
>   		notif->io_task_work.func = __io_notif_complete_tw;
>   		io_req_task_work_add(notif);
>   	}
> @@ -53,6 +70,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
>   
>   	nd = io_notif_to_data(notif);
>   	nd->account_pages = 0;
> +	nd->uarg.zerocopy = 1;
>   	nd->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
>   	nd->uarg.callback = io_uring_tx_zerocopy_callback;
>   	refcount_set(&nd->uarg.refcnt, 1);
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index d7bd1daf022b..4bdea7a4b2f7 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -1032,7 +1032,8 @@ static int __ip_append_data(struct sock *sk,
>   				paged = true;
>   				zc = true;
>   				uarg = msg->msg_ubuf;
> -			}
> +			} else
> +				msg->msg_ubuf->zerocopy = 0;
>   		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
>   			uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
>   			if (!uarg)
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 970e9a2cca4a..27a22d470741 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1231,6 +1231,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>   			uarg = msg->msg_ubuf;
>   			net_zcopy_get(uarg);
>   			zc = sk->sk_route_caps & NETIF_F_SG;
> +			if (!zc)
> +				uarg->zerocopy = 0;
>   		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
>   			uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
>   			if (!uarg) {
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index f152e51242cb..d85036e91cf7 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -1556,7 +1556,8 @@ static int __ip6_append_data(struct sock *sk,
>   				paged = true;
>   				zc = true;
>   				uarg = msg->msg_ubuf;
> -			}
> +			} else
> +				msg->msg_ubuf->zerocopy = 0;
>   		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
>   			uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
>   			if (!uarg)

-- 
Pavel Begunkov
