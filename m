Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BB651B4D9
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 02:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbiEEA5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 20:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbiEEA5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 20:57:31 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EC421242
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 17:53:54 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id y2so5206920ybi.7
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 17:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=67zqG2lI7y3yS4MVq6lRFQvU82cZLzIAOEgcnxYYB2A=;
        b=jJ94Ku0STZL7Ot6SfqZYyg2d0um6Gis3Ki5VJnw/GYyJwGt0q3cDy7s6bhftCyIo3v
         r0Qbtjq8TSMUPzUaN6KQKQ6mt/efK5O+uOpnXPIiXtw+/iyugd13unMjHmY5cwX0hJsK
         Jy+i7PuZoR5LqVmBX5g4Fr14HLA0QQwjftSl9jqUSN5B0Ze0Xmrb1oddIoLnAw9SrSMA
         PbUONT5+IA3w5M6UQKhW8GdgVhongKSCdeTFTZXczKKSjAUFwq/8POpSStaqO0E3knEu
         qswRW+1Heu+uvrSlQP7L+bdQjLUYbZgNGWYe4+VyPSOe4eENwIBStJln45aP1ZnvQpAU
         Mz5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=67zqG2lI7y3yS4MVq6lRFQvU82cZLzIAOEgcnxYYB2A=;
        b=nonhW9+GiZo9mgMnz34sOUONEQvDB4Mqxd04z/JeJNjZfbC51kMhl5RjKQ5SJFvbqY
         zq3v4LcgnWT3csxNIvsyX1LXgfoFmK90hslo93IpUutDZeu/dmjoz0cfw6psBEpNSIth
         AyF3N4mXFb2EkHbnbK2HHkUVqq0EYmE18KP0nFgncKy6qWNtqeRY9NAKvn4IMxtVwu2g
         tNuxp9foY6m447WSgqWpt8dDEXsgrEsS+OZ/S2uI6hBR/nyTs6gNAyzxHMaFNXKysSzx
         +ybXRGH/iXuulben6zZe3Ug0GV3vRN9XwZS1d+mEt1ZgOjaxGnTxomPSxwIjPxgq4aXn
         EE4A==
X-Gm-Message-State: AOAM533zUWJ0UahnL480Qn0Dq7NHQVA8MmxoqFlPHO/em57aVNCMzsXQ
        LoOOQbNjQIRR+nzEnlQn4hOQNoxHh9KEQ8+GEDDk8g==
X-Google-Smtp-Source: ABdhPJwm1R03lLkSds3i82DMOUwQQK5JohDJgX3NPQJIj2oIU27FmA3geZ6qmION841n+XRSeJdol4q9F4eOsv6trVw=
X-Received: by 2002:a25:ba50:0:b0:649:b5b2:6fca with SMTP id
 z16-20020a25ba50000000b00649b5b26fcamr10427595ybj.55.1651712033206; Wed, 04
 May 2022 17:53:53 -0700 (PDT)
MIME-Version: 1.0
References: <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
 <165157801106.17866.6764782659491020080.git-patchwork-notify@kernel.org>
 <CANn89iLHihonbBUQWkd0mjJPUuYBLMVoLCsRswtXmGjU3NKL5w@mail.gmail.com>
 <CANn89iJ=LF0KhRXDiFcky7mqpVaiHdbc6RDacAdzseS=iwjr4Q@mail.gmail.com>
 <f6f9f21d-7cdd-682f-f958-5951aa180ec7@I-love.SAKURA.ne.jp>
 <CANn89iJOt9oC_sSmVhRx8fyyvJ2hWzYKcTfH1Rvbzpt5aP0qNA@mail.gmail.com>
 <bf5ce176-35e6-0a75-1ada-6bed071a6a75@I-love.SAKURA.ne.jp>
 <5f3feecc-65ad-af5f-0ecd-94b2605ab67e@I-love.SAKURA.ne.jp> <63dab11e-2aeb-5608-6dcb-6ebc3e98056e@I-love.SAKURA.ne.jp>
In-Reply-To: <63dab11e-2aeb-5608-6dcb-6ebc3e98056e@I-love.SAKURA.ne.jp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 4 May 2022 17:53:42 -0700
Message-ID: <CANn89iJk5Pc4kcamjkjLF1xcNkdKHh+HmcRcXnVcaU0cXd9Cfw@mail.gmail.com>
Subject: Re: [PATCH] net: rds: use maybe_get_net() when acquiring refcount on
 TCP sockets
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        patchwork-bot+netdevbpf@kernel.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-rdma <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 4, 2022 at 5:45 PM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> Eric Dumazet is reporting addition on 0 problem at rds_tcp_tune(), for
> delayed works queued in rds_wq might be invoked after a net namespace's
> refcount already reached 0.
>
> Since rds_tcp_exit_net() from cleanup_net() calls flush_workqueue(rds_wq),
> it is guaranteed that we can instead use maybe_get_net() from delayed work
> functions until rds_tcp_exit_net() returns.
>
> Note that I'm not convinced that all works which might access a net
> namespace are already queued in rds_wq by the moment rds_tcp_exit_net()
> calls flush_workqueue(rds_wq). If some race is there, rds_tcp_exit_net()
> will fail to wait for work functions, and kmem_cache_free() could be
> called from net_free() before maybe_get_net() is called from
> rds_tcp_tune().
>
> Reported-by: Eric Dumazet <edumazet@google.com>
> Fixes: 3a58f13a881ed351 ("net: rds: acquire refcount on TCP sockets")
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  net/rds/tcp.c         | 11 ++++++++---
>  net/rds/tcp.h         |  2 +-
>  net/rds/tcp_connect.c |  5 ++++-
>  net/rds/tcp_listen.c  |  5 ++++-
>  4 files changed, 17 insertions(+), 6 deletions(-)
>
> diff --git a/net/rds/tcp.c b/net/rds/tcp.c
> index 2f638f8b7b1e..8e26bcf02044 100644
> --- a/net/rds/tcp.c
> +++ b/net/rds/tcp.c
> @@ -487,11 +487,11 @@ struct rds_tcp_net {
>  /* All module specific customizations to the RDS-TCP socket should be done in
>   * rds_tcp_tune() and applied after socket creation.
>   */
> -void rds_tcp_tune(struct socket *sock)
> +bool rds_tcp_tune(struct socket *sock)
>  {
>         struct sock *sk = sock->sk;
>         struct net *net = sock_net(sk);
> -       struct rds_tcp_net *rtn = net_generic(net, rds_tcp_netid);
> +       struct rds_tcp_net *rtn;
>
>         tcp_sock_set_nodelay(sock->sk);
>         lock_sock(sk);
> @@ -499,10 +499,14 @@ void rds_tcp_tune(struct socket *sock)
>          * a process which created this net namespace terminated.
>          */
>         if (!sk->sk_net_refcnt) {
> +               if (!maybe_get_net(net)) {


> +                       release_sock(sk);
> +                       return false;
> +               }
>                 sk->sk_net_refcnt = 1;
> -               get_net_track(net, &sk->ns_tracker, GFP_KERNEL);

This could use:
                  netns_tracker_alloc(net, &sk->ns_tracker, GFP_KERNEL);

>                 sock_inuse_add(net, 1);
>         }
> +       rtn = net_generic(net, rds_tcp_netid);
>         if (rtn->sndbuf_size > 0) {
>                 sk->sk_sndbuf = rtn->sndbuf_size;
>                 sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
> @@ -512,6 +516,7 @@ void rds_tcp_tune(struct socket *sock)
>                 sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
>         }
>         release_sock(sk);
> +       return true;
>  }
>

Otherwise, patch looks good to me, thanks.
