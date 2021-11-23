Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6F945A115
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 12:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbhKWLO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 06:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234718AbhKWLOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 06:14:55 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2CEC061574;
        Tue, 23 Nov 2021 03:11:47 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id a24so14685459qvb.5;
        Tue, 23 Nov 2021 03:11:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5646wwBInYNMdZ1KYLyZxiMXzq1owplKbisIOeQaj3o=;
        b=cnx/g0gnribIFUmCVFhfDbMTADMTw8O5RpSP1ZZs7Knn66fjudG197eA8RTvhbEitQ
         hHB3mdeFJy7rCztN3uv8eGdn4ON6YRGZF9fwvA/rUn4WvdxWoETDlk0wYaJGG/bnjqmX
         M8pWG3MzKiVogoe3PmmJujpIC4NH/WSPUr+tdq57komaqTof1fmhEctlwGNeG2vYSgOm
         ql9gu7sciWqPBCu8VxZaXi0Pj3B/i/5UFSVHAxJaYxr2uZAt5KZz0CxY7S9k33AxQ/HL
         Y5NJxiG8B4S6UgsVZ5ShO2U6hYKykRON+VzY1EsSFPWLUs8PqNqCgKV3gcRWkZwK1C7i
         gKOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5646wwBInYNMdZ1KYLyZxiMXzq1owplKbisIOeQaj3o=;
        b=BtmWR3b0RX+wYPGRtFCpBUKkzCLyINywk5+FF+4Wh+Qo0lNwetRM0vE+HfYIPDGbtV
         SApn6BBdTzmBC3FxfF1bZucvjryauJRhCCol8Pn+gqiajz4OgWal0x8Cz+1sA05tvICJ
         zjuT30vL0Q81TQP2mOyb06aA55mhOcC+NnweJlCIi0dXmreQVz+IHOwTRcDpiyLPLIL6
         Q+CiEnPXeWC0ohxVV5VlcyLDPmm2uJfkEn4qrJ148BOFUeZUsfF4LCAuXlszLZzZA8py
         UVV9u6xbt5MnurguLiSNA1bRN/C+yGbiM9nfOyJ0qMmu3vVA6cCQaF/02vNQTMt2gVHZ
         xmMw==
X-Gm-Message-State: AOAM530vhmsg6iSrpWEAxpeFBbFSfByIIRBal9XxE9KaXssa4bd59oZz
        qzWxSt6Do8mfMynyzxyrecp9YuhkvyIJM/tZh/a+xzuAFTujiDj+
X-Google-Smtp-Source: ABdhPJx2KIjN/UORFUzMEf0TUYNGjh410BdTRralqzGW+3F4Pd1wmp1h4LC04ouzxMPWQJQDgGxDYAJpTsBqXggXBd4=
X-Received: by 2002:ad4:5f88:: with SMTP id jp8mr4739668qvb.57.1637665907031;
 Tue, 23 Nov 2021 03:11:47 -0800 (PST)
MIME-Version: 1.0
References: <20211122101622.50572-1-kuniyu@amazon.co.jp> <20211122101622.50572-2-kuniyu@amazon.co.jp>
In-Reply-To: <20211122101622.50572-2-kuniyu@amazon.co.jp>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 23 Nov 2021 19:11:11 +0800
Message-ID: <CALOAHbBrmj=M_Jurg779zBN8eqiMZNqfVfRKa9XggH7f9Y+sgw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] dccp/tcp: Remove an unused argument in inet_csk_listen_start().
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>, dccp@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 6:17 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> The commit 1295e2cf3065 ("inet: minor optimization for backlog setting in
> listen(2)") added change so that sk_max_ack_backlog is initialised earlier
> in inet_dccp_listen() and inet_listen().  Since then, we no longer use
> backlog in inet_csk_listen_start(), so let's remove it.
>
> Fixes: 1295e2cf3065 ("inet: minor optimization for backlog setting in listen(2)")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

Thanks for the fix.
Acked-by: Yafang Shao <laoar.shao@gmail.com>

> ---
>  include/net/inet_connection_sock.h                          | 2 +-
>  net/dccp/proto.c                                            | 6 +++---
>  net/ipv4/af_inet.c                                          | 2 +-
>  net/ipv4/inet_connection_sock.c                             | 2 +-
>  tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c | 2 +-
>  5 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> index fa6a87246a7b..4ad47d9f9d27 100644
> --- a/include/net/inet_connection_sock.h
> +++ b/include/net/inet_connection_sock.h
> @@ -304,7 +304,7 @@ static inline __poll_t inet_csk_listen_poll(const struct sock *sk)
>                         (EPOLLIN | EPOLLRDNORM) : 0;
>  }
>
> -int inet_csk_listen_start(struct sock *sk, int backlog);
> +int inet_csk_listen_start(struct sock *sk);
>  void inet_csk_listen_stop(struct sock *sk);
>
>  void inet_csk_addr2sockaddr(struct sock *sk, struct sockaddr *uaddr);
> diff --git a/net/dccp/proto.c b/net/dccp/proto.c
> index fc44dadc778b..55b8f958cdd2 100644
> --- a/net/dccp/proto.c
> +++ b/net/dccp/proto.c
> @@ -238,7 +238,7 @@ void dccp_destroy_sock(struct sock *sk)
>
>  EXPORT_SYMBOL_GPL(dccp_destroy_sock);
>
> -static inline int dccp_listen_start(struct sock *sk, int backlog)
> +static inline int dccp_listen_start(struct sock *sk)
>  {
>         struct dccp_sock *dp = dccp_sk(sk);
>
> @@ -246,7 +246,7 @@ static inline int dccp_listen_start(struct sock *sk, int backlog)
>         /* do not start to listen if feature negotiation setup fails */
>         if (dccp_feat_finalise_settings(dp))
>                 return -EPROTO;
> -       return inet_csk_listen_start(sk, backlog);
> +       return inet_csk_listen_start(sk);
>  }
>
>  static inline int dccp_need_reset(int state)
> @@ -935,7 +935,7 @@ int inet_dccp_listen(struct socket *sock, int backlog)
>                  * FIXME: here it probably should be sk->sk_prot->listen_start
>                  * see tcp_listen_start
>                  */
> -               err = dccp_listen_start(sk, backlog);
> +               err = dccp_listen_start(sk);
>                 if (err)
>                         goto out;
>         }
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index c66b0563a267..aa8d15b1e2a4 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -225,7 +225,7 @@ int inet_listen(struct socket *sock, int backlog)
>                         tcp_fastopen_init_key_once(sock_net(sk));
>                 }
>
> -               err = inet_csk_listen_start(sk, backlog);
> +               err = inet_csk_listen_start(sk);
>                 if (err)
>                         goto out;
>                 tcp_call_bpf(sk, BPF_SOCK_OPS_TCP_LISTEN_CB, 0, NULL);
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index f7fea3a7c5e6..23da67a3fc06 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -1035,7 +1035,7 @@ void inet_csk_prepare_forced_close(struct sock *sk)
>  }
>  EXPORT_SYMBOL(inet_csk_prepare_forced_close);
>
> -int inet_csk_listen_start(struct sock *sk, int backlog)
> +int inet_csk_listen_start(struct sock *sk)
>  {
>         struct inet_connection_sock *icsk = inet_csk(sk);
>         struct inet_sock *inet = inet_sk(sk);
> diff --git a/tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c b/tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c
> index 8e94e5c080aa..6dc1f28fc4b6 100644
> --- a/tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c
> +++ b/tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c
> @@ -68,7 +68,7 @@ static void set_task_info(struct sock *sk)
>  }
>
>  SEC("fentry/inet_csk_listen_start")
> -int BPF_PROG(trace_inet_csk_listen_start, struct sock *sk, int backlog)
> +int BPF_PROG(trace_inet_csk_listen_start, struct sock *sk)
>  {
>         set_task_info(sk);
>
> --
> 2.30.2
>


-- 
Thanks
Yafang
