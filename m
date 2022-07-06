Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A82A567C53
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 05:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiGFDJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 23:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiGFDJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 23:09:34 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BB215FEB
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 20:09:33 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-10c0430e27dso8287955fac.4
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 20:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hfdpYpPYr5Sw3mkaogR1dD4RrcU3jm14Bt/5X4wxunU=;
        b=HCJQyz7CUOHrTldTsdMwCDVhTu+tR85KDgeMq41f1BAI2/WEQC2T7iGUD0Hd3h9bSG
         WfK2YoaN9vCZrSUZviDaCtaD2Ay4lWU5/FWRXriK5xoIgjdkWqzxDc3AKdM6VwFf4oXZ
         G6vwNP1zy4u+9m2SS6Va3xEw/tz9+oOhn8rziTYkA28sClNYu1hegkZvlwZw9n5c+pLc
         imz3PKQoPvl7IU0u2ci1wmLtIkxNHjbpuGh4vqjrkeGpuJFiy6W9waM5WMD0stC2ctoK
         LLjEZQB1MKlbMHByrHmVI0eZJUsJ3utUcnLzDSwSvFWRUHXXqPwjOty2R/IVQNFEpR/T
         31UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hfdpYpPYr5Sw3mkaogR1dD4RrcU3jm14Bt/5X4wxunU=;
        b=ab3lnFYWtJvC5A/lpSLS81GhPelozA3+3Yxvcv8z2i2SFOgLlendVwQNkgb96qGBSG
         UpfhARMklyc3U/Qpdq2NNw1aREnmgjlL48dGiGhs5X9+k7554JrMu4Hnl6FK1ah2YorW
         dhdyo+oTISsnLSGVZfymxzO/SJqnjuYen7JhD811KdnS8EohEPj2+ja/nDxBGo8DGl+p
         sH6iZAO8Nm/tp5Cn2bXolPwc5QAte4C3fHWkPQuztONAEpYN/hATR1B5zZfhXM3NK+cY
         gdm7IM4xYTuUW2WBiZel3ZkTCKCTnMJQ7Lm50d1el5tUXrdD0iryGNJlpnQjb0fioYEe
         33kg==
X-Gm-Message-State: AJIora/OVZcKu7dUIx3Tro9Pphlk1naRbDpEnPEBON70nU9ZI0s2B2ev
        b2xhkivfRuIhoIIaX2RM4hGhpkDRFzoWB5eEsQ0=
X-Google-Smtp-Source: AGRyM1tpD1/2qSFZvA3avMIdgOmdRLX1t209CzUWwmVMCKLsyG3J9azQOy4kCQUx1sKU5BVIcfYe2xZPIZ/LclDJYMc=
X-Received: by 2002:a05:6870:4625:b0:fe:4636:cf73 with SMTP id
 z37-20020a056870462500b000fe4636cf73mr22362725oao.278.1657076972947; Tue, 05
 Jul 2022 20:09:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220621202240.4182683-1-ssewook@gmail.com> <20220701154413.868096-1-ssewook@gmail.com>
 <CANn89iKLuTgp7QpWB7F7gp5_nNvdOXY_Zp9xmLJMpz2kpEaHDw@mail.gmail.com>
In-Reply-To: <CANn89iKLuTgp7QpWB7F7gp5_nNvdOXY_Zp9xmLJMpz2kpEaHDw@mail.gmail.com>
From:   =?UTF-8?B?7ISc7IS47Jqx?= <ssewook@gmail.com>
Date:   Wed, 6 Jul 2022 03:09:21 +0000
Message-ID: <CAM2q-nywFcsSusDviy+orpSYd1pidNWs82YQcmo_q=YfBuTthQ@mail.gmail.com>
Subject: Re: [PATCH v2] net-tcp: Find dst with sk's xfrm policy not ctl_sk
To:     Eric Dumazet <edumazet@google.com>
Cc:     Sewook Seo <sewookseo@google.com>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sehee Lee <seheele@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Eric.

Thanks for your review.

 if (IS_ENABLED(CONFIG_XFRM) && sk->sk_policy[XFRM_POLICY_OUT])
 --> This causes a compile error when CONFIG_XFRM is disabled.
ldd: /usr/bin/ld: No such file or directory
net/ipv4/ip_output.c:1739:37: error: no member named 'sk_policy' in
'struct sock'
        if (IS_ENABLED(CONFIG_XFRM) && sk->sk_policy[XFRM_POLICY_OUT])
I think we need to use preprocessor directives at here.
Is there any reason to use #if than #ifdef?  Then I will modify it to use #=
if.
    #if IS_ENABLED(CONFIG_XFRM) or #if defined(CONFIG_XFRM)

The reason I added the condition only for the state 'TCP_SYN_SENT' is
that I just intended to limit
the scope of the patch to the issue scenario(RST packet following
challenge ACK is not ESP encapsulated)
so that we can have at least a difference as before.
I also agree with you about using sk_fullsock() instead of SYN_SENT
check. will update the patch soon.

Thanks.
Sewook.


2022=EB=85=84 7=EC=9B=94 5=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 9:04, Er=
ic Dumazet <edumazet@google.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On Fri, Jul 1, 2022 at 5:45 PM Sewook Seo <ssewook@gmail.com> wrote:
> >
> > From: sewookseo <sewookseo@google.com>
> >
> > If we set XFRM security policy by calling setsockopt with option
> > IPV6_XFRM_POLICY, the policy will be stored in 'sock_policy' in 'sock'
> > struct. However tcp_v6_send_response doesn't look up dst_entry with the
> > actual socket but looks up with tcp control socket. This may cause a
> > problem that a RST packet is sent without ESP encryption & peer's TCP
> > socket can't receive it.
> > This patch will make the function look up dest_entry with actual socket=
,
> > if the socket has XFRM policy(sock_policy), so that the TCP response
> > packet via this function can be encrypted, & aligned on the encrypted
> > TCP socket.
> >
> > Tested: We encountered this problem when a TCP socket which is encrypte=
d
> > in ESP transport mode encryption, receives challenge ACK at SYN_SENT
> > state. After receiving challenge ACK, TCP needs to send RST to
> > establish the socket at next SYN try. But the RST was not encrypted &
> > peer TCP socket still remains on ESTABLISHED state.
> > So we verified this with test step as below.
> > [Test step]
> > 1. Making a TCP state mismatch between client(IDLE) & server(ESTABLISHE=
D).
> > 2. Client tries a new connection on the same TCP ports(src & dst).
> > 3. Server will return challenge ACK instead of SYN,ACK.
> > 4. Client will send RST to server to clear the SOCKET.
> > 5. Client will retransmit SYN to server on the same TCP ports.
> > [Expected result]
> > The TCP connection should be established.
> >
> > Effort: net-tcp
> > Cc: Maciej =C5=BBenczykowski <maze@google.com>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Steffen Klassert <steffen.klassert@secunet.com>
> > Cc: Sehee Lee <seheele@google.com>
> > Signed-off-by: Sewook Seo <sewookseo@google.com>
> > ---
> > Changelog since v1:
> > - Remove unnecessary null check of sk at ip_output.c
> >   Narrow down patch scope: sending RST at SYN_SENT state
> >   Remove unnecessay condition to call xfrm_sk_free_policy()
> >   Verified at KASAN build
> >
> >  net/ipv4/ip_output.c | 7 ++++++-
> >  net/ipv4/tcp_ipv4.c  | 5 +++++
> >  net/ipv6/tcp_ipv6.c  | 7 ++++++-
> >  3 files changed, 17 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> > index 00b4bf26fd93..1da430c8fee2 100644
> > --- a/net/ipv4/ip_output.c
> > +++ b/net/ipv4/ip_output.c
> > @@ -1704,7 +1704,12 @@ void ip_send_unicast_reply(struct sock *sk, stru=
ct sk_buff *skb,
> >                            tcp_hdr(skb)->source, tcp_hdr(skb)->dest,
> >                            arg->uid);
> >         security_skb_classify_flow(skb, flowi4_to_flowi_common(&fl4));
> > -       rt =3D ip_route_output_key(net, &fl4);
>
> Please avoid these #ifdef ?
>
> You probably can write something like
>
>      if (IS_ENABLED(CONFIG_XFRM) && sk->sk_policy[XFRM_POLICY_OUT])
>          rt =3D ip_route_output_flow(net, &fl4, sk);
>     else
>           rt =3D ip_route_output_key(net, &fl4);
>
> > +#ifdef CONFIG_XFRM
> > +       if (sk->sk_policy[XFRM_POLICY_OUT])
> > +               rt =3D ip_route_output_flow(net, &fl4, sk);
> > +       else
> > +#endif
> > +               rt =3D ip_route_output_key(net, &fl4);
> >         if (IS_ERR(rt))
> >                 return;
> >
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index fda811a5251f..459669f9e13f 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -819,6 +819,10 @@ static void tcp_v4_send_reset(const struct sock *s=
k, struct sk_buff *skb)
> >                 ctl_sk->sk_priority =3D (sk->sk_state =3D=3D TCP_TIME_W=
AIT) ?
> >                                    inet_twsk(sk)->tw_priority : sk->sk_=
priority;
> >                 transmit_time =3D tcp_transmit_time(sk);
> > +#ifdef CONFIG_XFRM
> > +               if (sk->sk_policy[XFRM_POLICY_OUT] && sk->sk_state =3D=
=3D TCP_SYN_SENT)
> > +                       xfrm_sk_clone_policy(ctl_sk, sk);
> > +#endif
> >         }
> >         ip_send_unicast_reply(ctl_sk,
> >                               skb, &TCP_SKB_CB(skb)->header.h4.opt,
> > @@ -827,6 +831,7 @@ static void tcp_v4_send_reset(const struct sock *sk=
, struct sk_buff *skb)
> >                               transmit_time);
> >
> >         ctl_sk->sk_mark =3D 0;
> > +       xfrm_sk_free_policy(ctl_sk);
> >         sock_net_set(ctl_sk, &init_net);
> >         __TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
> >         __TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
> > diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> > index c72448ba6dc9..453452f87a7c 100644
> > --- a/net/ipv6/tcp_ipv6.c
> > +++ b/net/ipv6/tcp_ipv6.c
> > @@ -952,7 +952,12 @@ static void tcp_v6_send_response(const struct sock=
 *sk, struct sk_buff *skb, u32
> >          * Underlying function will use this to retrieve the network
> >          * namespace
> >          */
> > -       dst =3D ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NUL=
L);
> > +#ifdef CONFIG_XFRM
> > +       if (sk && sk->sk_policy[XFRM_POLICY_OUT] && sk->sk_state =3D=3D=
 TCP_SYN_SENT && rst)
>
>
> Why not using sk_fullsock(sk)  instead of 'sk->sk_state =3D=3D TCP_SYN_SE=
NT' ?
>
> sk_fullsock() is really telling us if we can use sk as a full socket,
> and this is all we need to know when reviewing this code.
>
> > +               dst =3D ip6_dst_lookup_flow(net, sk, &fl6, NULL);  /* G=
et dst with sk's XFRM policy */
> > +       else
> > +#endif
> > +               dst =3D ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &=
fl6, NULL);
> >         if (!IS_ERR(dst)) {
> >                 skb_dst_set(buff, dst);
> >                 ip6_xmit(ctl_sk, buff, &fl6, fl6.flowi6_mark, NULL,
> > --
> > 2.37.0.rc0.161.g10f37bed90-goog
> >
