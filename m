Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F30E818BB3F
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 16:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgCSPiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 11:38:16 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:41938 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727521AbgCSPiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 11:38:15 -0400
Received: by mail-ot1-f66.google.com with SMTP id s15so2796358otq.8
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 08:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=seCAy6xYY0ujQIsNH75m2599DrTdig4Y4u9evBOvPIA=;
        b=Xy4Hv9B1Q/8NsaVAgg5N3Z6vnoVUApM/gVfQN6OhHKjRA8QBEmOawruEKVCVz0LAkt
         CeJpe/zz4rUmz3J+2o4fdngDWigvxvl51Jn1Wq68BGK8s02vJJkjhxw/SrcJn/aVn83w
         DGUsdQ4R0giuJKSGh/IMUtDG7szQcVjT6SMV4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=seCAy6xYY0ujQIsNH75m2599DrTdig4Y4u9evBOvPIA=;
        b=kCARnEPVkfagRe8ZK6fZdZNRjb+w5zmq/hUSm8edZCHIOSy4eGoclhhjEFWCyIkPzY
         u7ROZchSLLFUpjtWe3VO5W6Gm7M1Dt8QbhKXaWHfSJvgqXBsPl+Du9JRhSLYHKuOW+Ug
         gkqn2HevM6+IRd1ucsM/hNJnRXZ9xqWnFLj7PpqD/i49oGrLCvKBlNZI6usUWPp7a3+f
         1moNxfFUL3CV3lxinu+ipNFO0suUEECGSdFWSpwX3CrLyAILq+5hgwEhPGOfnNL5DPMl
         GByG+dhnQU/M8GiS2nekcz7r8hF3SegJDc5y0PUmD+oOgLTWnQ8Rq7M6C68jf9mnrD0J
         S9XQ==
X-Gm-Message-State: ANhLgQ3XfIzxwr4MmRVrwRhHkNFsCkBqmb0ITYzCaAFcAzE+kqoJiuLw
        7a+yQ4gLaYl8bRxKZNtex0rkChv1ozv6Td90O6JB8A==
X-Google-Smtp-Source: ADFU+vub2oGGaZwK6dqB/jd4b8EpyH4/obAagvR+weJB1BPBkFBrFv81Vmk8W+ZBTFzEINX6QykYl8LH1mYocO4UqFc=
X-Received: by 2002:a9d:6310:: with SMTP id q16mr2598495otk.147.1584632293068;
 Thu, 19 Mar 2020 08:38:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200319124631.58432-1-yuehaibing@huawei.com>
In-Reply-To: <20200319124631.58432-1-yuehaibing@huawei.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Thu, 19 Mar 2020 15:38:00 +0000
Message-ID: <CACAyw9_B+qNYHPrDPfYszjOwJbiV92vehT7BA_NGuFtzkj0D0w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: tcp: Fix unused function warnings
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Mar 2020 at 12:47, YueHaibing <yuehaibing@huawei.com> wrote:
>
> If BPF_STREAM_PARSER is not set, gcc warns:
>
> net/ipv4/tcp_bpf.c:483:12: warning: 'tcp_bpf_sendpage' defined but not used [-Wunused-function]
> net/ipv4/tcp_bpf.c:395:12: warning: 'tcp_bpf_sendmsg' defined but not used [-Wunused-function]
> net/ipv4/tcp_bpf.c:13:13: warning: 'tcp_bpf_stream_read' defined but not used [-Wunused-function]
>
> Moves the unused functions into the #ifdef

Thanks for fixing this.

Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>


>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  net/ipv4/tcp_bpf.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index fe7b4fbc31c1..37c91f25cae3 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -10,19 +10,6 @@
>  #include <net/inet_common.h>
>  #include <net/tls.h>
>
> -static bool tcp_bpf_stream_read(const struct sock *sk)
> -{
> -       struct sk_psock *psock;
> -       bool empty = true;
> -
> -       rcu_read_lock();
> -       psock = sk_psock(sk);
> -       if (likely(psock))
> -               empty = list_empty(&psock->ingress_msg);
> -       rcu_read_unlock();
> -       return !empty;
> -}
> -
>  static int tcp_bpf_wait_data(struct sock *sk, struct sk_psock *psock,
>                              int flags, long timeo, int *err)
>  {
> @@ -298,6 +285,20 @@ int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
>  }
>  EXPORT_SYMBOL_GPL(tcp_bpf_sendmsg_redir);
>
> +#ifdef CONFIG_BPF_STREAM_PARSER
> +static bool tcp_bpf_stream_read(const struct sock *sk)
> +{
> +       struct sk_psock *psock;
> +       bool empty = true;
> +
> +       rcu_read_lock();
> +       psock = sk_psock(sk);
> +       if (likely(psock))
> +               empty = list_empty(&psock->ingress_msg);
> +       rcu_read_unlock();
> +       return !empty;
> +}
> +
>  static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
>                                 struct sk_msg *msg, int *copied, int flags)
>  {
> @@ -528,7 +529,6 @@ static int tcp_bpf_sendpage(struct sock *sk, struct page *page, int offset,
>         return copied ? copied : err;
>  }
>
> -#ifdef CONFIG_BPF_STREAM_PARSER
>  enum {
>         TCP_BPF_IPV4,
>         TCP_BPF_IPV6,
> --
> 2.17.1
>
>


--
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
