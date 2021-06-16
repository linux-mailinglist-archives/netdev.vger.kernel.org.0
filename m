Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A573A92EC
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhFPGn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 02:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231861AbhFPGnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 02:43:17 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4FBC06114E
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 23:40:58 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id q3so1855163iop.11
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 23:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LRJ/INZ0EuSbADJaSGFa5wVp/IdbgL/CW4Ip/7K3qL0=;
        b=sZw/C/yeCyRjkPpdn252mRKgEG9bE8o41QeYcTZ0LoxBFBi6dXQc0bXJRZOtOuT7+b
         qQynKZqaTxt1+BjrsYpy9DST1djZyhhyW8U3SfKOckKHUNPwA6pXU6UaijQBddbzo9G0
         pWzmLDpiJhICjt/um/yodE/vqjjMdsfsCWrgemQoeJ11Z6G9F94mSU9hB3Y6Qsg6W6ur
         yKHEj7UCAG+tMkkB4Ni0wfpwqrwzzLGmB26Qht+r3GC0FVt8mFcR56xYh3m9Qh1RkekK
         SnvJq576RI2dAhwZ/J64b650ognDEWM6sTvzLC0kFOGSKWkXsABEQ0FMIgRZQgSRwrvm
         KMkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LRJ/INZ0EuSbADJaSGFa5wVp/IdbgL/CW4Ip/7K3qL0=;
        b=WWwJrRptD4ytjz/iAl2yv6LCEN4WYgbXt59LfSshU2yttGP4QMNhBPjGrtLPb5o4vM
         fD5mh4EQOsSzQrGiSYf/5WMY45H+/A+OU5LWoQjZiJBQRgl8RF2VYpWkp21s6QivXX9a
         NiypOiMxaCXz3VB8AftDqd4wbHW1g4Ug/e3N2Liu+LXaTw+Bsl2WI0rJUIX9RQFNYiM+
         N9N2O3koOrdhldtcQl00PMY3PFrstzhMIJJDTJw+uEf2LrJhdjIxRALqTbo3/383O89Z
         zbExBy6y13PtnVWxnPSiePYrwyF2yQGjytXGhOV9NIsYZ6U3c6fPcRcX+bhytjOJrThA
         RNtA==
X-Gm-Message-State: AOAM530ETvqYCVU3cywtF1r45v0vQWeFVSfeH9pmKgC7hQFKeygT9Get
        O9Ud84maaYIyP5M6yU7aGV6LN+x6zFiv8C7pXPQ=
X-Google-Smtp-Source: ABdhPJzH8gbnSPvvbeTNwtxFMBU4Fa6SqO8NbjLmaYn6v1Tsofahuac6xhiFBbood63ERa564V4O+6svOtMWsDwFpPo=
X-Received: by 2002:a5d:85cf:: with SMTP id e15mr2477981ios.76.1623825658012;
 Tue, 15 Jun 2021 23:40:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210616060604.3639340-1-zenczykowski@gmail.com>
In-Reply-To: <20210616060604.3639340-1-zenczykowski@gmail.com>
From:   Jonathan Maxwell <jmaxwell37@gmail.com>
Date:   Wed, 16 Jun 2021 16:40:22 +1000
Message-ID: <CAGHK07B_cPZaNNkiCwM-t5B_wxe5tihuReUHcG8mM6fpSW2Cyg@mail.gmail.com>
Subject: Re: [PATCH] inet_diag: add support for tw_mark
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 4:06 PM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> From: Maciej =C5=BBenczykowski <maze@google.com>
>
> Timewait sockets have included mark since approx 4.18.
>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jon Maxwell <jmaxwell37@gmail.com>
> Fixes: 00483690552c ("tcp: Add mark for TIMEWAIT sockets")
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
> ---
>  net/ipv4/inet_diag.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
> index 93474b1bea4e..e65f4ef024a4 100644
> --- a/net/ipv4/inet_diag.c
> +++ b/net/ipv4/inet_diag.c
> @@ -416,7 +416,7 @@ EXPORT_SYMBOL_GPL(inet_sk_diag_fill);
>  static int inet_twsk_diag_fill(struct sock *sk,
>                                struct sk_buff *skb,
>                                struct netlink_callback *cb,
> -                              u16 nlmsg_flags)
> +                              u16 nlmsg_flags, bool net_admin)
>  {
>         struct inet_timewait_sock *tw =3D inet_twsk(sk);
>         struct inet_diag_msg *r;
> @@ -444,6 +444,12 @@ static int inet_twsk_diag_fill(struct sock *sk,
>         r->idiag_uid          =3D 0;
>         r->idiag_inode        =3D 0;
>
> +       if (net_admin && nla_put_u32(skb, INET_DIAG_MARK,
> +                                    tw->tw_mark)) {
> +               nlmsg_cancel(skb, nlh);
> +               return -EMSGSIZE;
> +       }
> +
>         nlmsg_end(skb, nlh);
>         return 0;
>  }
> @@ -494,7 +500,7 @@ static int sk_diag_fill(struct sock *sk, struct sk_bu=
ff *skb,
>                         u16 nlmsg_flags, bool net_admin)
>  {
>         if (sk->sk_state =3D=3D TCP_TIME_WAIT)
> -               return inet_twsk_diag_fill(sk, skb, cb, nlmsg_flags);
> +               return inet_twsk_diag_fill(sk, skb, cb, nlmsg_flags, net_=
admin);
>
>         if (sk->sk_state =3D=3D TCP_NEW_SYN_RECV)
>                 return inet_req_diag_fill(sk, skb, cb, nlmsg_flags, net_a=
dmin);
> @@ -801,6 +807,8 @@ int inet_diag_bc_sk(const struct nlattr *bc, struct s=
ock *sk)
>                 entry.mark =3D sk->sk_mark;
>         else if (sk->sk_state =3D=3D TCP_NEW_SYN_RECV)
>                 entry.mark =3D inet_rsk(inet_reqsk(sk))->ir_mark;
> +       else if (sk->sk_state =3D=3D TCP_TIME_WAIT)
> +               entry.mark =3D inet_twsk(sk)->tw_mark;
>         else
>                 entry.mark =3D 0;
>  #ifdef CONFIG_SOCK_CGROUP_DATA
> --
> 2.32.0.272.g935e593368-goog
>

Thanks for adding that to the inet_diag module.

Reviewed-by: Jon Maxwell <jmaxwell37@gmail.com>
