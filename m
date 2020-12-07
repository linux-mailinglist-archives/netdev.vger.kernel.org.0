Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448D22D1E4B
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 00:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728136AbgLGXXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 18:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgLGXXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 18:23:08 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51985C06179C
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 15:22:28 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id n14so15109697iom.10
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 15:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mpGB1/8AVKPq3hh+n4JbsFdSfQ1lwRZqp/eVcJoHahA=;
        b=sNOyL59eyFCk84goKJJfuXDuDZ7YcQrrMj6w+AzPJeMoBq0cyIQN1qiLA07AmJ4L08
         gj68AMNYvSWcpAvaRI07bL6zS4Ab3LNusSfnITqXRN7momC4nABYAjsuXlJ8IXZCttB6
         9NZG0LL1RN+1MHHj36UqOnIZhg/2dSnGK9fJi0oznh1IjI93+5/mSkKI/FvybVMVNrK5
         qyilVWjlin3VV/DkGV39Vf4+aFs3ZsCTkRnU5lmQxduf2l8QMv2xhZP8qhAWxZIE9n/i
         0DY+++zG4AxL+uDZPDYyH2D6oJHgxdc17dvg5pTsEgseBWAsLdrfcsUKq8aMkk9sgkQB
         49Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mpGB1/8AVKPq3hh+n4JbsFdSfQ1lwRZqp/eVcJoHahA=;
        b=ULnh82BgmgR8YX3CN8bVSA1ePkN3JB1Mg6pBUWZE9Brr0Obxjre7xtzeq9AIKBKVc9
         7hXRAQtzT6GNrV9CVtBKHLHbOQDAoGn9/R3jwUKO9653z2XCPxXThD4z+QM0UySQ3ZoX
         LQiG+OeZH2UyW3NiHZ4kf4qZwn9SzCjS6hT/HG4kbsjQRNs6Z2VJLCmaIvNXqjO/r81z
         uNGPrneDBVkUBAZyozSAQJl1Z306vP0lYG2mF0X++acBVpjF2/WHpsKfOiq3cAUT3EIx
         DEcD9kxbtiiyTyr1aInbPo0RSOpAekNIhCF5A1rZLBxXn36mjRzEIh7jjwItWj5N1NzK
         Z+Rw==
X-Gm-Message-State: AOAM531jUpQDlR2ncncWYqEjVdgjxcuW/2r4Z5+Fv7ncrmBJLyYmjBBp
        AeikayJt8thaWiTbc+eFgVLshNCUq2XTVdH83zT+eA==
X-Google-Smtp-Source: ABdhPJxBZKFIeVwbilX8bjrtxRdi9GCy59v6VJd57LOaOs0ONZUwrNvki5DTDL68osgIeqUVp10qvqLMWGbjpIwIPs8=
X-Received: by 2002:a6b:d61a:: with SMTP id w26mr21827570ioa.117.1607383347254;
 Mon, 07 Dec 2020 15:22:27 -0800 (PST)
MIME-Version: 1.0
References: <20201204180622.14285-1-abuehaze@amazon.com> <44E3AA29-F033-4B8E-A1BC-E38824B5B1E3@amazon.com>
 <CANn89iJgJQfOeNr9aZHb+_Vozgd9v4S87Kf4iV=mKhuPDGLkEg@mail.gmail.com>
 <3F02FF08-EDA6-4DFD-8D93-479A5B05E25A@amazon.com> <CANn89iL_5QFGQLzxxLyqfNMGiV2wF4CbkY==x5Sh5vqKOTgFtw@mail.gmail.com>
 <781BA871-5D3D-4C89-9629-81345CC41C5C@amazon.com> <CANn89iK1G-YMWo07uByfUwrrK8QPvQPeFrRG1vJhB_OhJo7v2A@mail.gmail.com>
 <CADVnQymROUn6jQdPKxNr_Uc3KMqjX4t0M6=HC6rDxmZzZVv0=Q@mail.gmail.com>
 <CANn89iJyw+EYiXLz_mYQQxdqnZn=vhmj9fj=0Qz0doyzZCsMnQ@mail.gmail.com> <4235A2E1-A685-43DE-B513-C9163DE434CB@amazon.com>
In-Reply-To: <4235A2E1-A685-43DE-B513-C9163DE434CB@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 8 Dec 2020 00:22:15 +0100
Message-ID: <CANn89iL48fnjMQ=rt7oGRC_cejhuwfvcyy5JcUs=k5Cet+-Vwg@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: optimise receiver buffer autotuning
 initialisation for high latency connections
To:     "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "ycheng@google.com" <ycheng@google.com>,
        "weiwan@google.com" <weiwan@google.com>,
        "Strohman, Andy" <astroh@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 9:09 PM Mohamed Abuelfotoh, Hazem
<abuehaze@amazon.com> wrote:
>
>     >I want to state again that using 536 bytes as a magic value makes no
>     sense to me.
>
>  >autotuning might be delayed by one RTT, this does not match numbers
>  >given by Mohamed (flows stuck in low speed)
>
>   >autotuning is an heuristic, and because it has one RTT latency, it is
>    >crucial to get proper initial rcvmem values.
>
>    >People using MTU=3D9000 should know they have to tune tcp_rmem[1]
>    >accordingly, especially when using drivers consuming one page per
>    >+incoming MSS.
>
>
>
> The magic number would be 10*rcv_mss=3D5360 not 536 and in my opinion it'=
s a big amount of data to be sent in security attack so if we are talking a=
bout DDos attack triggering Autotuning at 5360 bytes I'd say he will also b=
e able to trigger it sending 64KB but I totally agree that it would be easi=
er with lower rcvq_space.space, it's always a tradeoff between security and=
 performance.



>
> Other options would be to either consider the configured MTU in the rcv_w=
nd calculation or probably check the MTU before calculating the initial rcv=
space. We have to make sure that initial receive space is lower than initia=
l receive window so Autotuning would work regardless the configured MTU on =
the receiver and only people using Jumbo frames will be paying the price if=
 we agreed that it's expected for Jumbo frame users to have machines with m=
ore memory,  I'd say something as below should work:
>
> void tcp_init_buffer_space(struct sock *sk)
> {
>         int tcp_app_win =3D sock_net(sk)->ipv4.sysctl_tcp_app_win;
>         struct inet_connection_sock *icsk =3D inet_csk(sk);
>         struct tcp_sock *tp =3D tcp_sk(sk);
>         int maxwin;
>
>         if (!(sk->sk_userlocks & SOCK_SNDBUF_LOCK))
>                 tcp_sndbuf_expand(sk);
>         if(tp->advmss < 6000)
>                 tp->rcvq_space.space =3D min_t(u32, tp->rcv_wnd, TCP_INIT=
_CWND * tp->advmss);

This is just another hack, based on 'magic' numbers.

>         else
>                 tp->rcvq_space.space =3D min_t(u32, tp->rcv_wnd, TCP_INIT=
_CWND * icsk->icsk_ack.rcv_mss);
>         tcp_mstamp_refresh(tp);
>         tp->rcvq_space.time =3D tp->tcp_mstamp;
>         tp->rcvq_space.seq =3D tp->copied_seq;
>
>
>
> I don't think that we should rely on Admins manually tuning this tcp_rmem=
[1] with Jumbo frame in use also Linux users shouldn't expect performance d=
egradation after kernel upgrade. although [1] is the only public reporting =
of this issue, I am pretty sure we will see more users reporting this with =
Linux Main distributions moving to kernel 5.4 as stable version. In Summary=
 we should come up with something either the proposed patch or something el=
se to avoid admins doing the manual job.
>



Default MTU is 1500, not 9000.

I hinted in my very first reply to you that MTU  9000 is not easy and
needs tuning. We could argue and try to make this less of a pain in
future kernel (net-next)

<quote>Also worth noting that if you set MTU to 9000 (instead of
standard 1500), you probably need to tweak a few sysctls.
</quote>

I think I have asked you multiple times to test appropriate
tcp_rmem[1] settings...

I gave the reason why tcp_rmem[1] set to 131072 is not good for MTU
9000, I will prefer a solution that involves no kernel patch, no
backports, just a matter of educating sysadmins, for increased TCP
performance,
especially when really using 9000 MTU...

Your patch would change the behavior of TCP stack for standard
MTU=3D1500 flows which are yet the majority. This is very risky.

Anyway. _if_ we really wanted to change the kernel, ( keeping stupid
tcp_rmem[1] value ) :

In the tp->rcvq_space.space =3D min_t(u32, tp->rcv_wnd, TCP_INIT_CWND *
tp->advmss);  formula, really the bug is in the tp->rcv_wnd term, not
the second one.

This is buggy, because tcp_init_buffer_space() ends up with
tp->window_clamp smaller than tp->rcv_wnd, so tcp_grow_window() is not
able to change tp->rcv_ssthresh

The only mechanism allowing to change tp->window_clamp later would be
DRS, so we better use the proper limit when initializing
tp->rcvq_space.space

This issue disappears if tcp_rmem[1] is slightly above 131072, because
then the following is not needed.

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 9e8a6c1aa0190cc248b3b99b073a4c6e45884cf5..81b5d9375860ae583e08045fb25=
b089c456c60ab
100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -534,6 +534,7 @@ static void tcp_init_buffer_space(struct sock *sk)

        tp->rcv_ssthresh =3D min(tp->rcv_ssthresh, tp->window_clamp);
        tp->snd_cwnd_stamp =3D tcp_jiffies32;
+       tp->rcvq_space.space =3D min(tp->rcv_ssthresh, tp->rcvq_space.space=
);
 }

 /* 4. Recalculate window clamp after socket hit its memory bounds. */
