Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7658343A7FF
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 01:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhJYXNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 19:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbhJYXNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 19:13:09 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD1AC061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 16:10:46 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id g10so5570207edj.1
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 16:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CA1hCrnNEiN9PjtWjq+0aUtpQWw3q7TaqrA02cqfYjs=;
        b=Huk3uO1M7/p4MQ3q/uX907upeFwM+rI9NyZlCxaSOhvKz4rd4ZpxJq6AGnCAr7LvC9
         w/vsAubbbhRXejYf9eHKz4YbA2g/JFlD3ix7NApnvFXPuL3n6GQDRNk82cfAoMSb+B0u
         3CZBfBIw83eJOd6Hm3P+NIy3Tp6MS0CPA07e4UUjXImxsViU5m6G5u9AVr1LT6JmDy7J
         7LRgHzCcsEJEvujI5u2evfT07JFCzvQ+Uel0vRUyQ4QEYvc1I8euPm0UnIsax2Wp/A6l
         rhZ1pwe5gTf/0venju04GWs40lV4tDjBd4ufvq43bV8g4DZ0SjAn0ECLt0yaeycoyREZ
         lFFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CA1hCrnNEiN9PjtWjq+0aUtpQWw3q7TaqrA02cqfYjs=;
        b=7kNF/M9rIM+Pbr3RxUj2u1J6bsCbmYtR3ygXx3OJy6ZYEJxVkAa1DtMua/2zvgxhSQ
         7RmGBZNnCBQS9O0QPkDqHyBspCgL1TZ+JZod3nCaF6T9Cou4nFNbLQMV4aXXTePsszjO
         a1TI/15h8tR8oMQEMq0Ew2x5DWhWi8lZqy59NqWdY7BOL4lI4A70IU+gPZSmlWcRU6FB
         +W353GvX8sKlPEZNTwJp+N8jYsBCfKQEqX8beYnG/U7BFB5zLE0HceVlCfyJsi3Jj7OP
         /JZKgQDEdR6uUOgR4L2Q6rDALFY05m/OH3CY9jzM/MKTJ2liyatyakadfVE0LwWmafFQ
         wZNA==
X-Gm-Message-State: AOAM5301bn7OnWnLr4Knd0R6m5ViJWeIIjZ20bSy+vbMCOklnT0Sbj6p
        lssXf9ZkInF74AIuSUNoey5ufPCetYVhvgyYkVtHpA==
X-Google-Smtp-Source: ABdhPJyMbHCRmwFjCAW9svQlMMloscreY71nsFL8SaaihXk1hcUJUg0OEjHXdoC/eH9PKK6VE9FO1vjLOsohqmaiIhU=
X-Received: by 2002:a17:907:1b25:: with SMTP id mp37mr26520445ejc.140.1635203443648;
 Mon, 25 Oct 2021 16:10:43 -0700 (PDT)
MIME-Version: 1.0
References: <20211025221342.806029-1-eric.dumazet@gmail.com> <20211025221342.806029-2-eric.dumazet@gmail.com>
In-Reply-To: <20211025221342.806029-2-eric.dumazet@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Mon, 25 Oct 2021 19:10:07 -0400
Message-ID: <CACSApvZnfWBYXObAUUnJacXX6Ny+p-HuKh6=1b_mwaA+bkF7dA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] tcp: rename sk_stream_alloc_skb
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 6:13 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> sk_stream_alloc_skb() is only used by TCP.
>
> Rename it to make this clear, and move its declaration
> to include/net/tcp.h
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

> ---
>  include/net/sock.h    |  3 ---
>  include/net/tcp.h     |  2 ++
>  net/ipv4/tcp.c        | 12 ++++++------
>  net/ipv4/tcp_output.c | 10 +++++-----
>  4 files changed, 13 insertions(+), 14 deletions(-)
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index b76be30674efc88434ed45d46b9c4600261b6271..ff4e62aa62e51a68d086e9e2b8429cba5731be00 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -2422,9 +2422,6 @@ static inline void sk_stream_moderate_sndbuf(struct sock *sk)
>         WRITE_ONCE(sk->sk_sndbuf, max_t(u32, val, SOCK_MIN_SNDBUF));
>  }
>
> -struct sk_buff *sk_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
> -                                   bool force_schedule);
> -
>  /**
>   * sk_page_frag - return an appropriate page_frag
>   * @sk: socket
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index d62467a0094fe016ee2f5d9581631e1425e8f201..701587af685296a6b2372fee7b3e94f998c3bbe8 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -337,6 +337,8 @@ void tcp_twsk_destructor(struct sock *sk);
>  ssize_t tcp_splice_read(struct socket *sk, loff_t *ppos,
>                         struct pipe_inode_info *pipe, size_t len,
>                         unsigned int flags);
> +struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
> +                                    bool force_schedule);
>
>  void tcp_enter_quickack_mode(struct sock *sk, unsigned int max_quickacks);
>  static inline void tcp_dec_quickack_mode(struct sock *sk,
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index c2d9830136d298a27abc12a5633bf77d1224759c..68dd580dba3d0e04412466868135c49225a4a33b 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -856,8 +856,8 @@ ssize_t tcp_splice_read(struct socket *sock, loff_t *ppos,
>  }
>  EXPORT_SYMBOL(tcp_splice_read);
>
> -struct sk_buff *sk_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
> -                                   bool force_schedule)
> +struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
> +                                    bool force_schedule)
>  {
>         struct sk_buff *skb;
>
> @@ -960,8 +960,8 @@ static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
>                 if (!sk_stream_memory_free(sk))
>                         return NULL;
>
> -               skb = sk_stream_alloc_skb(sk, 0, sk->sk_allocation,
> -                                         tcp_rtx_and_write_queues_empty(sk));
> +               skb = tcp_stream_alloc_skb(sk, 0, sk->sk_allocation,
> +                                          tcp_rtx_and_write_queues_empty(sk));
>                 if (!skb)
>                         return NULL;
>
> @@ -1289,8 +1289,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>                                         goto restart;
>                         }
>                         first_skb = tcp_rtx_and_write_queues_empty(sk);
> -                       skb = sk_stream_alloc_skb(sk, 0, sk->sk_allocation,
> -                                                 first_skb);
> +                       skb = tcp_stream_alloc_skb(sk, 0, sk->sk_allocation,
> +                                                  first_skb);
>                         if (!skb)
>                                 goto wait_for_space;
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 3a01e5593a171d8e8978c11c9880eb9314feeda9..c0c55a8be8f79857e176714f240fddcb0580fa6b 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -1564,7 +1564,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
>                 return -ENOMEM;
>
>         /* Get a new skb... force flag on. */
> -       buff = sk_stream_alloc_skb(sk, nsize, gfp, true);
> +       buff = tcp_stream_alloc_skb(sk, nsize, gfp, true);
>         if (!buff)
>                 return -ENOMEM; /* We'll just try again later. */
>         skb_copy_decrypted(buff, skb);
> @@ -2121,7 +2121,7 @@ static int tso_fragment(struct sock *sk, struct sk_buff *skb, unsigned int len,
>                 return tcp_fragment(sk, TCP_FRAG_IN_WRITE_QUEUE,
>                                     skb, len, mss_now, gfp);
>
> -       buff = sk_stream_alloc_skb(sk, 0, gfp, true);
> +       buff = tcp_stream_alloc_skb(sk, 0, gfp, true);
>         if (unlikely(!buff))
>                 return -ENOMEM;
>         skb_copy_decrypted(buff, skb);
> @@ -2388,7 +2388,7 @@ static int tcp_mtu_probe(struct sock *sk)
>                 return -1;
>
>         /* We're allowed to probe.  Build it now. */
> -       nskb = sk_stream_alloc_skb(sk, probe_size, GFP_ATOMIC, false);
> +       nskb = tcp_stream_alloc_skb(sk, probe_size, GFP_ATOMIC, false);
>         if (!nskb)
>                 return -1;
>         sk_wmem_queued_add(sk, nskb->truesize);
> @@ -3754,7 +3754,7 @@ static int tcp_send_syn_data(struct sock *sk, struct sk_buff *syn)
>         /* limit to order-0 allocations */
>         space = min_t(size_t, space, SKB_MAX_HEAD(MAX_TCP_HEADER));
>
> -       syn_data = sk_stream_alloc_skb(sk, space, sk->sk_allocation, false);
> +       syn_data = tcp_stream_alloc_skb(sk, space, sk->sk_allocation, false);
>         if (!syn_data)
>                 goto fallback;
>         syn_data->ip_summed = CHECKSUM_PARTIAL;
> @@ -3835,7 +3835,7 @@ int tcp_connect(struct sock *sk)
>                 return 0;
>         }
>
> -       buff = sk_stream_alloc_skb(sk, 0, sk->sk_allocation, true);
> +       buff = tcp_stream_alloc_skb(sk, 0, sk->sk_allocation, true);
>         if (unlikely(!buff))
>                 return -ENOBUFS;
>
> --
> 2.33.0.1079.g6e70778dc9-goog
>
