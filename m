Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4719212AD1
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 19:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgGBRHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 13:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbgGBRHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 13:07:01 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636A5C08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 10:07:01 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id o4so14142996ybp.0
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 10:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/zN88Zjt9yUp4BKxSZW+ZVGy1MTXJkHiEvFbfKr7048=;
        b=r2HchOaP9NOE/pWXab3qagoBoK71Ihb1cQ2bbNyMs3Uiep4KuheK5FB6FMaIWOMt7e
         pYzw/q3rquxiSaPNAZeQ9t9eceEIhM9whlR6/+g5dMex8HBL6tCfkrg+ndNfhsBt763c
         cFL24L2pvp3UjXSu8nR1AQ6bBIndGFGy7m1qkyUlfmu6dqCkJi+BR3Q1ALW1JlBOK9CL
         sWLjDpOBuB2ZAg8HRyxrSeRT1pr83Xc7ygKvWdkjOLyg9qC393X86nky2LYwjdmnAjrE
         nYTENJ5TXcdENJl2HiB2UfzBqEGLsD8sh1MgkB0Gw+cW+awEu1XlsP85vPuwXw+ppC1V
         jAJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/zN88Zjt9yUp4BKxSZW+ZVGy1MTXJkHiEvFbfKr7048=;
        b=MhzvrogaG6vDA6Ou32oEQzGZvhClbOVE8c22YHp/ZoutWVomlXK9H9pgk2j0sAVeQP
         xzbK9VkYIQPEkbki5HjLXyisHP6Tp38N6miuda5Af8mTizu2oOBg3mt6Z7JhGDM27l02
         m+ptcVCtw5ZhYqm4l7SBYYa4zT9eyxUvSNuPb0vFf8BFzyPWjKsvednSvKT1YQRXL1BZ
         9W+QUOALR43g6TWjhWRmy5qtKal9PfgUAz/5q49CbNy+MD9TBIZnKzE33tsq+lmGabLw
         ciDd5WVpMgUT+aIe8HBs6exXGlwZxxfST6ISKwwX5BdXo6szQ5QfR98/z3Cg/+NgUF89
         P4kg==
X-Gm-Message-State: AOAM531WBXQHzh9GZBpl4MKA6xNfQlCOOoRk1se6lNJQdmOrWAp8nkIw
        AE3Ql5HHpHmm05+joIa3YjQMtsujEOFwyNkDe5tcRg==
X-Google-Smtp-Source: ABdhPJzg7nTxe20FlveIMCyIlxpSXSrgsGulhwZlwGM0tTAYR/iKm3bO4sBI8pVfLKdyTRr6XuaKMNB52Zf3F85B6kI=
X-Received: by 2002:a25:ec0d:: with SMTP id j13mr48535871ybh.364.1593709620257;
 Thu, 02 Jul 2020 10:07:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200702013933.4157053-1-edumazet@google.com> <708841049.20220.1593700143737.JavaMail.zimbra@efficios.com>
In-Reply-To: <708841049.20220.1593700143737.JavaMail.zimbra@efficios.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 2 Jul 2020 10:06:48 -0700
Message-ID: <CANn89iLp9tOW7E2pK_cJAQ838uKTiSXaL=QiQeS-zj0DzVBJng@mail.gmail.com>
Subject: Re: [PATCH net] tcp: md5: allow changing MD5 keys in all socket states
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 7:29 AM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> ----- On Jul 1, 2020, at 9:39 PM, Eric Dumazet edumazet@google.com wrote:
>
> > This essentially reverts commit 721230326891 ("tcp: md5: reject TCP_MD5SIG
> > or TCP_MD5SIG_EXT on established sockets")
> >
> > Mathieu reported that many vendors BGP implementations can
> > actually switch TCP MD5 on established flows.
> >
> > Quoting Mathieu :
> >   Here is a list of a few network vendors along with their behavior
> >   with respect to TCP MD5:
> >
> >   - Cisco: Allows for password to be changed, but within the hold-down
> >     timer (~180 seconds).
> >   - Juniper: When password is initially set on active connection it will
> >     reset, but after that any subsequent password changes no network
> >     resets.
> >   - Nokia: No notes on if they flap the tcp connection or not.
> >   - Ericsson/RedBack: Allows for 2 password (old/new) to co-exist until
> >     both sides are ok with new passwords.
> >   - Meta-Switch: Expects the password to be set before a connection is
> >     attempted, but no further info on whether they reset the TCP
> >     connection on a change.
> >   - Avaya: Disable the neighbor, then set password, then re-enable.
> >   - Zebos: Would normally allow the change when socket connected.
> >
> > We can revert my prior change because commit 9424e2e7ad93 ("tcp: md5: fix
> > potential
> > overestimation of TCP option space") removed the leak of 4 kernel bytes to
> > the wire that was the main reason for my patch.
>
> Hi Eric,
>
> This is excellent news! Thanks for looking into it.
>
> As this revert re-enables all ABI scenarios previously supported, I suspect
> this means knowing whether transitions of live TCP sockets from no-md5 to
> enabled-md5 is often used in practice is now irrelevant ?

I can only answer this question for two linux peers. They should
behave correctly,
although lack of SACK might cause slowdown in lossy environments.

In any case, we revert to a prior situation, so if anything is broken,
we will need more details,
like a packet capture.


>
> Thanks,
>
> Mathieu
>
>
> >
> > While doing my investigations, I found a bug when a MD5 key is changed, leading
> > to these commits that stable teams want to consider before backporting this
> > revert :
> >
> > Commit 6a2febec338d ("tcp: md5: add missing memory barriers in
> > tcp_md5_do_add()/tcp_md5_hash_key()")
> > Commit e6ced831ef11 ("tcp: md5: refine tcp_md5_do_add()/tcp_md5_hash_key()
> > barriers")
> >
> > Fixes: 721230326891 "tcp: md5: reject TCP_MD5SIG or TCP_MD5SIG_EXT on
> > established sockets"
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > ---
> > net/ipv4/tcp.c | 5 +----
> > 1 file changed, 1 insertion(+), 4 deletions(-)
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index
> > c33f7c6aff8eea81d374644cd251bd2b96292651..861fbd84c9cf58af4126c80a27925cd6f70f300d
> > 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -3246,10 +3246,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
> > #ifdef CONFIG_TCP_MD5SIG
> >       case TCP_MD5SIG:
> >       case TCP_MD5SIG_EXT:
> > -             if ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN))
> > -                     err = tp->af_specific->md5_parse(sk, optname, optval, optlen);
> > -             else
> > -                     err = -EINVAL;
> > +             err = tp->af_specific->md5_parse(sk, optname, optval, optlen);
> >               break;
> > #endif
> >       case TCP_USER_TIMEOUT:
> > --
> > 2.27.0.212.ge8ba1cc988-goog
>
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com
