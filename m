Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C28A3E4C34
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 20:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235138AbhHISfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 14:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbhHISfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 14:35:43 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F45DC0613D3;
        Mon,  9 Aug 2021 11:35:23 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id l18so22706365wrv.5;
        Mon, 09 Aug 2021 11:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2Ir2Ax+o/Wuz6SUvaDDaTxwddrsgDfZmzdHZ8wRYNcs=;
        b=gyjVKJ8jwTsJBwIbyWfPfETilrGuLzDpow4iU7Iy71UDg7XoGMBVKHrTlMkwGXA+47
         nim7s4LbAI554LSpauA3a4qwfPO+23IMK7Dm6jjPPNJz7yePtNmGpL6a2k13JDfx7Tdm
         GYktxGHc0YF9+SDXFCzx8tHZ2R1KmcHOvp5s6w9g+3YjPSDH/Gdt1gLzlXIT7VdiFg2m
         FQMNjzTMiXz1Vg5oT7pg61iTLNjJqqwyh3YjOMKE95YtzTOGujNOP+T40vIXUNSBGhGL
         n+VrldQqbnNZ0d4ZtX1etxhbWMspaV+oCgjQFscoAywpBgJk7s9jNPnek9rOG/JEH5Af
         hnlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2Ir2Ax+o/Wuz6SUvaDDaTxwddrsgDfZmzdHZ8wRYNcs=;
        b=OOjay2pxqkizQ3wNPiwjO/WTyi8SHh+XFyP0nVPz4JBVHMbaj1w5nGgvQi/UFs6CQw
         HkCZXMmMjtH3HEAfWlRiBrjcyXtvKhGBOX0KSjZR5AHfPS/wpyFWsVECWu0erOAUVcdG
         KncyhbW3mVwC9ln26rTZhYM6/iNjJlKpLLfU8EzkNMY/fMl/OwbGLuNt0h1J9msDawH7
         k++YIFiF/DAvAPSTUyJHwyl+jHMWq3Vg5u1Fwea8vFcm7OrIfOeYv7zMV1fL/a3nrsQn
         7hhgAj8CCaUh//xfQd9EOS3iQf5SqSI1cMo6L0+8cQCBSex3OCPghqI3eJ3SOIctogEp
         UGiw==
X-Gm-Message-State: AOAM5321zZiM34eOWjo6rnemnN/FdztRIPHSIinNx80T0jNOd7wGXOD4
        BxJyrsPGR/53bOxhAMpomvVL1D91CzPNwC83Rvo=
X-Google-Smtp-Source: ABdhPJxdxWTQHWuRFfmKnD4JmmhFpc36EKHfBmtJwp9UKt+MZw54AXidelEj8qO48WrlqfO0SGTuzVDRw24Ry3xoN7w=
X-Received: by 2002:adf:e806:: with SMTP id o6mr27225080wrm.307.1628534121630;
 Mon, 09 Aug 2021 11:35:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210807062106.2563-1-l4stpr0gr4m@gmail.com>
In-Reply-To: <20210807062106.2563-1-l4stpr0gr4m@gmail.com>
From:   Kangmin Park <l4stpr0gr4m@gmail.com>
Date:   Tue, 10 Aug 2021 03:35:10 +0900
Message-ID: <CAKW4uUx=cOu46E0QCdmg1Jq3WJ3w6ROo6oKZaXA=g6gdhdiDdg@mail.gmail.com>
Subject: Re: [PATCH] netfilter: remove duplicate code
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I checked the Changes Requested state in patchwork.
But I have not received any review mails.
I wonder if there is any problem.
I'm sorry if you just review a little late due to a busy schedule.

Kangmin Park

2021=EB=85=84 8=EC=9B=94 7=EC=9D=BC (=ED=86=A0) =EC=98=A4=ED=9B=84 3:21, Ka=
ngmin Park <l4stpr0gr4m@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> nf_nat_ipv4_fn() and nf_nat_ipv6_fn() call nf_nat_inet_fn().
> Those two functions are already contains routine that gets nf_conn
> object and checks the untrackable situation.
> So, the following code is duplicated.
>
> ```
> ct =3D nf_ct_get(skb, &ctinfo);
> if (!ct)
>         return NF_ACCEPT;
> ```
>
> Therefore, define a function __nf_nat_inet_fn() that has the same
> contents as the nf_nat_inet_fn() except for routine gets and checks
> the nf_conn object.
> Then, separate the nf_nat_inet_fn() into a routine that gets a
> nf_conn object and a routine that calls the __nf_nat_inet_fn().
>
> Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
> ---
>  include/net/netfilter/nf_nat.h |  5 +++++
>  net/netfilter/nf_nat_core.c    | 37 ++++++++++++++++++++++------------
>  net/netfilter/nf_nat_proto.c   |  4 ++--
>  3 files changed, 31 insertions(+), 15 deletions(-)
>
> diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_na=
t.h
> index 987111ae5240..a66f617c5054 100644
> --- a/include/net/netfilter/nf_nat.h
> +++ b/include/net/netfilter/nf_nat.h
> @@ -100,6 +100,11 @@ void nf_nat_ipv6_unregister_fn(struct net *net, cons=
t struct nf_hook_ops *ops);
>  int nf_nat_inet_register_fn(struct net *net, const struct nf_hook_ops *o=
ps);
>  void nf_nat_inet_unregister_fn(struct net *net, const struct nf_hook_ops=
 *ops);
>
> +unsigned int
> +__nf_nat_inet_fn(void *priv, struct sk_buff *skb,
> +                const struct nf_hook_state *state, struct nf_conn *ct,
> +                enum ip_conntrack_info ctinfo);
> +
>  unsigned int
>  nf_nat_inet_fn(void *priv, struct sk_buff *skb,
>                const struct nf_hook_state *state);
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index 7de595ead06a..98ebba2c0f6d 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -682,25 +682,15 @@ unsigned int nf_nat_packet(struct nf_conn *ct,
>  }
>  EXPORT_SYMBOL_GPL(nf_nat_packet);
>
>  unsigned int
> -nf_nat_inet_fn(void *priv, struct sk_buff *skb,
> -              const struct nf_hook_state *state)
> +__nf_nat_inet_fn(void *priv, struct sk_buff *skb,
> +                const struct nf_hook_state *state, struct nf_conn *ct,
> +                enum ip_conntrack_info ctinfo)
>  {
> -       struct nf_conn *ct;
> -       enum ip_conntrack_info ctinfo;
>         struct nf_conn_nat *nat;
>         /* maniptype =3D=3D SRC for postrouting. */
>         enum nf_nat_manip_type maniptype =3D HOOK2MANIP(state->hook);
>
> -       ct =3D nf_ct_get(skb, &ctinfo);
> -       /* Can't track?  It's not due to stress, or conntrack would
> -        * have dropped it.  Hence it's the user's responsibilty to
> -        * packet filter it out, or implement conntrack/NAT for that
> -        * protocol. 8) --RR
> -        */
> -       if (!ct)
> -               return NF_ACCEPT;
> -
>         nat =3D nfct_nat(ct);
>
>         switch (ctinfo) {
> @@ -755,6 +745,26 @@ nf_nat_inet_fn(void *priv, struct sk_buff *skb,
>         nf_ct_kill_acct(ct, ctinfo, skb);
>         return NF_DROP;
>  }
> +EXPORT_SYMBOL_GPL(__nf_nat_inet_fn);
> +
> +unsigned int
> +nf_nat_inet_fn(void *priv, struct sk_buff *skb,
> +              const struct nf_hook_state *state)
> +{
> +       struct nf_conn *ct;
> +       enum ip_conntrack_info ctinfo;
> +
> +       ct =3D nf_ct_get(skb, &ctinfo);
> +       /* Can't track?  It's not due to stress, or conntrack would
> +        * have dropped it.  Hence it's the user's responsibilty to
> +        * packet filter it out, or implement conntrack/NAT for that
> +        * protocol. 8) --RR
> +        */
> +       if (!ct)
> +               return NF_ACCEPT;
> +
> +       return __nf_nat_inet_fn(priv, skb, state, ct, ctinfo);
> +}
>  EXPORT_SYMBOL_GPL(nf_nat_inet_fn);
>
>  struct nf_nat_proto_clean {
> diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
> index 48cc60084d28..897859730078 100644
> --- a/net/netfilter/nf_nat_proto.c
> +++ b/net/netfilter/nf_nat_proto.c
> @@ -642,7 +642,7 @@ nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
>                 }
>         }
>
> -       return nf_nat_inet_fn(priv, skb, state);
> +       return __nf_nat_inet_fn(priv, skb, state, ct, ctinfo);
>  }
>
>  static unsigned int
> @@ -934,7 +934,7 @@ nf_nat_ipv6_fn(void *priv, struct sk_buff *skb,
>                 }
>         }
>
> -       return nf_nat_inet_fn(priv, skb, state);
> +       return __nf_nat_inet_fn(priv, skb, state, ct, ctinfo);
>  }
>
>  static unsigned int
> --
> 2.26.2
>
