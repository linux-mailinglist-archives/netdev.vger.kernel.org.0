Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F091E0169
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 20:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387933AbgEXSOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 14:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387823AbgEXSOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 14:14:55 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5FEC061A0E
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 11:14:54 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id 4so15600181ilg.1
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 11:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=knRoLeUIqLg/Si1yu8wBCgp2c3s+wekXpjchWvvQ90I=;
        b=uROJY5aL0zIE+TxnW4O6Nb2rAK3jh4VN6X81kgw2wVn+KA2Sk24KoDBf7MwgGay8mH
         GUYDfvwCfHORzb0y9cgu3zk1LXn/lOFh3r2aVG4jOE6mCg7yYd6iW8mkK4VxO2CWViXU
         XxJr56617V6BKJIkKny+F53SFzOSqOQ+nar08EL+Bk84heTL4m9IqeEsxgVEn5CL68DK
         EkUwMvmFxPcxemMm92KLKk8EK5LZ/Qv1lXAgHCVD/gT6STdW2tUvSIPnCo8BH9LaFYjG
         ipowmBD0i/sg553QysNSVjVQwKpe57HuMlgEujaSidWszEM2BNfd+6wGT2RsGObO0xwh
         Rwfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=knRoLeUIqLg/Si1yu8wBCgp2c3s+wekXpjchWvvQ90I=;
        b=rjWRATJx4fPWdsCCEREcih2xqMDq1AP4bwu6aCf7lWmO8NBhKjs7ycJSJpJcaO2xl4
         n1YxYf7b0MolFrWEczY7Zbfn/qqGwJ5NDqHHVDz6Omip3WvHtyfubjp6Fpvujb5k96qa
         eAeYVoff7pP70uV79ms99KgC14MmShXn8VAUeEws+Jt4TUQFC2iFt0usiwu6cVQoTmnA
         K3QpU7ExwnaBBb0azanjAQYkSHtboD6HFrg0ko9khaRE6hLBTj/5XokMjh/0L+GHhk2r
         0a21A4i73pZwfxT5+6MsdRI1qgttzDS2g7O5bIy4W2fy5IcsxD7QFsm6BBrHzIn2uab6
         8VCA==
X-Gm-Message-State: AOAM532AMcn//uarTkZtHu1KeNzrAQ0tDdVxXrdoSYMibkJY1w2NfZon
        YZBlkkDYZEXqj2eWD+aa85WEArL4kDIYeSqi6APi+w==
X-Google-Smtp-Source: ABdhPJwovVLgjD20WubNIexJSVrLtg7yoXwTZNrSLoXjsWnSW3hgA6+/6E9xV3DPbRTC50FkAEpdoGzmfAm6EsDZTf8=
X-Received: by 2002:a05:6e02:788:: with SMTP id q8mr21623937ils.56.1590344093966;
 Sun, 24 May 2020 11:14:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200524180002.148619-1-edumazet@google.com>
In-Reply-To: <20200524180002.148619-1-edumazet@google.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Sun, 24 May 2020 11:14:41 -0700
Message-ID: <CANP3RGcV+AkktUwXbyiXWFTt15wXGZoR7vgdt-zOBfZ0irWEDw@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: allow traceroute -Mtcp for unpriv users
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 24, 2020 at 11:00 AM Eric Dumazet <edumazet@google.com> wrote:
>
> Unpriv users can use traceroute over plain UDP sockets, but not TCP ones.
>
> $ traceroute -Mtcp 8.8.8.8
> You do not have enough privileges to use this traceroute method.
>
> $ traceroute -n -Mudp 8.8.8.8
> traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
>  1  192.168.86.1  3.631 ms  3.512 ms  3.405 ms
>  2  10.1.10.1  4.183 ms  4.125 ms  4.072 ms
>  3  96.120.88.125  20.621 ms  19.462 ms  20.553 ms
>  4  96.110.177.65  24.271 ms  25.351 ms  25.250 ms
>  5  69.139.199.197  44.492 ms  43.075 ms  44.346 ms
>  6  68.86.143.93  27.969 ms  25.184 ms  25.092 ms
>  7  96.112.146.18  25.323 ms 96.112.146.22  25.583 ms 96.112.146.26  24.5=
02 ms
>  8  72.14.239.204  24.405 ms 74.125.37.224  16.326 ms  17.194 ms
>  9  209.85.251.9  18.154 ms 209.85.247.55  14.449 ms 209.85.251.9  26.296=
 ms^C
>
> We can easily support traceroute over TCP, by queueing an error message
> into socket error queue.
>
> Note that applications need to set IP_RECVERR/IPV6_RECVERR option to
> enable this feature, and that the error message is only queued
> while in SYN_SNT state.
>
> socket(AF_INET6, SOCK_STREAM, IPPROTO_IP) =3D 3
> setsockopt(3, SOL_IPV6, IPV6_RECVERR, [1], 4) =3D 0
> setsockopt(3, SOL_SOCKET, SO_TIMESTAMP_OLD, [1], 4) =3D 0
> setsockopt(3, SOL_IPV6, IPV6_UNICAST_HOPS, [5], 4) =3D 0
> connect(3, {sa_family=3DAF_INET6, sin6_port=3Dhtons(8787), sin6_flowinfo=
=3Dhtonl(0),
>         inet_pton(AF_INET6, "2002:a05:6608:297::", &sin6_addr), sin6_scop=
e_id=3D0}, 28) =3D -1 EHOSTUNREACH (No route to host)
> recvmsg(3, {msg_name=3D{sa_family=3DAF_INET6, sin6_port=3Dhtons(8787), si=
n6_flowinfo=3Dhtonl(0),
>         inet_pton(AF_INET6, "2002:a05:6608:297::", &sin6_addr), sin6_scop=
e_id=3D0},
>         msg_namelen=3D1024->28, msg_iov=3D[{iov_base=3D"`\r\337\320\0004\=
6\1&\7\370\260\200\231\16\27\0\0\0\0\0\0\0\0 \2\n\5f\10\2\227"..., iov_len=
=3D1024}],
>         msg_iovlen=3D1, msg_control=3D[{cmsg_len=3D32, cmsg_level=3DSOL_S=
OCKET, cmsg_type=3DSO_TIMESTAMP_OLD, cmsg_data=3D{tv_sec=3D1590340680, tv_u=
sec=3D272424}},
>                                    {cmsg_len=3D60, cmsg_level=3DSOL_IPV6,=
 cmsg_type=3DIPV6_RECVERR}],
>         msg_controllen=3D96, msg_flags=3DMSG_ERRQUEUE}, MSG_ERRQUEUE) =3D=
 144
>
> Suggested-by: Maciej =C5=BBenczykowski <maze@google.com
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Willem de Bruijn <willemb@google.com>
> ---
>  net/ipv4/tcp_ipv4.c | 2 ++
>  net/ipv6/tcp_ipv6.c | 2 ++
>  2 files changed, 4 insertions(+)
>
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 6c05f1ceb538cbb9981835440163485de2ccf716..900c6d154cbcf04fb09d71f14=
45d0723bcf3c409 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -573,6 +573,8 @@ int tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
>                 if (fastopen && !fastopen->sk)
>                         break;
>
> +               ip_icmp_error(sk, skb, err, th->dest, info, (u8 *)th);
> +
>                 if (!sock_owned_by_user(sk)) {
>                         sk->sk_err =3D err;
>
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 413b3425ac66bd758bb83562efa955f277da90a5..01a6f5111a77b4397038bf4d4=
0cc09a94e57408c 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -463,6 +463,8 @@ static int tcp_v6_err(struct sk_buff *skb, struct ine=
t6_skb_parm *opt,
>                 if (fastopen && !fastopen->sk)
>                         break;
>
> +               ipv6_icmp_error(sk, skb, err, th->dest, ntohl(info), (u8 =
*)th);
> +
>                 if (!sock_owned_by_user(sk)) {
>                         sk->sk_err =3D err;
>                         sk->sk_error_report(sk);                /* Wake p=
eople up to see the error (see connect in sock.c) */
> --
> 2.27.0.rc0.183.gde8f92d652-goog

Thanks!  I was not expecting it to be this easy...

Reviewed-by: Maciej =C5=BBenczykowski <maze@google.com>
