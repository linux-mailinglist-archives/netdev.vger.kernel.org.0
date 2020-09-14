Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78CF268D26
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 16:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgINOKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 10:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgINNqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 09:46:35 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19562C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 06:46:35 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id s12so18792594wrw.11
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 06:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Myxlrhq6tIFxA4Nh2uL/6CwxbwuCmikm8oNowbCl16Q=;
        b=ZvX37A07qoDcB1hqg/qWFDixTfj5NRKxYb9tnL5R0RVtRxIq0ng5bNnemplrIimFgT
         I+t97qSDwpCHfsEE4ReXxUPR/Y0DSQN2e3Qq8IC0la7oTcSbmFd1gb7HqEpctc2iz5Yf
         8JdVRK9orMpfFRgMSwMJN7PLh3qHwJihz+4wDKnHsamMcU7G/E76TCeVzHDj5eMz4DLF
         GfdFSUKfsTbc+WpFLksk4RwcQnJ+4z+sNeWjSRuXE6H88hqGPnKiZZYwnxqUNxg1yBod
         0yPLJuGa68+wKsRfK5sJz8GEIasaBF4BusY5e9AkwYdLw3lxi7ROYa4ptnkcE8/h6Y83
         dTPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Myxlrhq6tIFxA4Nh2uL/6CwxbwuCmikm8oNowbCl16Q=;
        b=WYqYDUDM5SFgJPqjYL/okBX+DpI+di67CLpcZWAQ+aiPdFxVxaI7yRMaUpudUELqVf
         x2q40TFqfVs1rS5LtzybOFb1WdHSgWNHWf5TuFwezAPntl8HhYAIXMZHyQeGYcERSdAX
         +QWPZXecV1QZkQ1KsDm0ojarL7ibEquEBdHWxi+9/2JiVAoCvsTTRC+1IEsh1pYAkcQ4
         iggFXK/iGRF2IH+zo75iPDzC50W+6UcIGXoUwF3YiQvxcRFN/sHuA7y93NJFJd9Vex/v
         mAt7OJ/6gZ14qk2xnpDhpEm/HFULZ0u1HmADlrAaerUING6LQXSZI13xFQporNEwHhI2
         63HQ==
X-Gm-Message-State: AOAM531JwhzvkZ+LlBBZmlkkdInFRxENCFn4vQSyWbkB5r/4uJ02hiCD
        RS62cEwY1snLN1vIwBhVI1wbuX3bKzQxo4r5sYMW+w==
X-Google-Smtp-Source: ABdhPJwESeilhjsIRBn3QsfWD629yZ4iVbO/Sk+D+A0xjNgg3LheiAHGskYdI3XiXiqh66ROiSxRur8ixa/JjB6Qb5E=
X-Received: by 2002:a5d:4c4c:: with SMTP id n12mr2906618wrt.162.1600091193516;
 Mon, 14 Sep 2020 06:46:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200914102027.3746717-1-edumazet@google.com>
In-Reply-To: <20200914102027.3746717-1-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Mon, 14 Sep 2020 09:45:57 -0400
Message-ID: <CACSApvY-5AOmkOmkevBSbo01p78KVMxWKifXB=D_=J9+aemxRA@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: remove SOCK_QUEUE_SHRUNK
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 6:20 AM Eric Dumazet <edumazet@google.com> wrote:
>
> SOCK_QUEUE_SHRUNK is currently used by TCP as a temporary state
> that remembers if some room has been made in the rtx queue
> by an incoming ACK packet.
>
> This is later used from tcp_check_space() before
> considering to send EPOLLOUT.
>
> Problem is: If we receive SACK packets, and no packet
> is removed from RTX queue, we can send fresh packets, thus
> moving them from write queue to rtx queue and eventually
> empty the write queue.
>
> This stall can happen if TCP_NOTSENT_LOWAT is used.
>
> With this fix, we no longer risk stalling sends while holes
> are repaired, and we can fully use socket sndbuf.
>
> This also removes a cache line dirtying for typical RPC
> workloads.
>
> Fixes: c9bee3b7fdec ("tcp: TCP_NOTSENT_LOWAT socket option")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Thank you for fixing this bug!


> ---
>  include/net/sock.h    |  2 --
>  net/ipv4/tcp_input.c  | 23 +++++++----------------
>  net/ipv4/tcp_output.c |  1 -
>  3 files changed, 7 insertions(+), 19 deletions(-)
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 7dd3051551fbad3f432c969e16c04ff7f63bbe26..eaa5cac5e8368bf1c18e221fffa321d692579bad 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -845,7 +845,6 @@ enum sock_flags {
>         SOCK_RCVTSTAMP, /* %SO_TIMESTAMP setting */
>         SOCK_RCVTSTAMPNS, /* %SO_TIMESTAMPNS setting */
>         SOCK_LOCALROUTE, /* route locally only, %SO_DONTROUTE setting */
> -       SOCK_QUEUE_SHRUNK, /* write queue has been shrunk recently */
>         SOCK_MEMALLOC, /* VM depends on this socket for swapping */
>         SOCK_TIMESTAMPING_RX_SOFTWARE,  /* %SOF_TIMESTAMPING_RX_SOFTWARE */
>         SOCK_FASYNC, /* fasync() active */
> @@ -1526,7 +1525,6 @@ static inline void sk_mem_uncharge(struct sock *sk, int size)
>  DECLARE_STATIC_KEY_FALSE(tcp_tx_skb_cache_key);
>  static inline void sk_wmem_free_skb(struct sock *sk, struct sk_buff *skb)
>  {
> -       sock_set_flag(sk, SOCK_QUEUE_SHRUNK);
>         sk_wmem_queued_add(sk, -skb->truesize);
>         sk_mem_uncharge(sk, skb->truesize);
>         if (static_branch_unlikely(&tcp_tx_skb_cache_key) &&
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 3658ad84f0c6252658dd5174eae31dcde4b34942..50834e7f958eec178ea144e8d438c98f2cff9014 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -5332,12 +5332,6 @@ static bool tcp_should_expand_sndbuf(const struct sock *sk)
>         return true;
>  }
>
> -/* When incoming ACK allowed to free some skb from write_queue,
> - * we remember this event in flag SOCK_QUEUE_SHRUNK and wake up socket
> - * on the exit from tcp input handler.
> - *
> - * PROBLEM: sndbuf expansion does not work well with largesend.
> - */
>  static void tcp_new_space(struct sock *sk)
>  {
>         struct tcp_sock *tp = tcp_sk(sk);
> @@ -5352,16 +5346,13 @@ static void tcp_new_space(struct sock *sk)
>
>  static void tcp_check_space(struct sock *sk)
>  {
> -       if (sock_flag(sk, SOCK_QUEUE_SHRUNK)) {
> -               sock_reset_flag(sk, SOCK_QUEUE_SHRUNK);
> -               /* pairs with tcp_poll() */
> -               smp_mb();
> -               if (sk->sk_socket &&
> -                   test_bit(SOCK_NOSPACE, &sk->sk_socket->flags)) {
> -                       tcp_new_space(sk);
> -                       if (!test_bit(SOCK_NOSPACE, &sk->sk_socket->flags))
> -                               tcp_chrono_stop(sk, TCP_CHRONO_SNDBUF_LIMITED);
> -               }
> +       /* pairs with tcp_poll() */
> +       smp_mb();
> +       if (sk->sk_socket &&
> +           test_bit(SOCK_NOSPACE, &sk->sk_socket->flags)) {
> +               tcp_new_space(sk);
> +               if (!test_bit(SOCK_NOSPACE, &sk->sk_socket->flags))
> +                       tcp_chrono_stop(sk, TCP_CHRONO_SNDBUF_LIMITED);
>         }
>  }
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index ab79d36ed07fc6918035ab3f9ebdb3ce6b7767c8..386978dcd318d84af486d0d1a5bb1786f4a493cf 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -1682,7 +1682,6 @@ int tcp_trim_head(struct sock *sk, struct sk_buff *skb, u32 len)
>                 skb->truesize      -= delta_truesize;
>                 sk_wmem_queued_add(sk, -delta_truesize);
>                 sk_mem_uncharge(sk, delta_truesize);
> -               sock_set_flag(sk, SOCK_QUEUE_SHRUNK);
>         }
>
>         /* Any change of skb->len requires recalculation of tso factor. */
> --
> 2.28.0.618.gf4bc123cb7-goog
>
