Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898EC31FEF1
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 19:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhBSSrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 13:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhBSSrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 13:47:08 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66B2C061574;
        Fri, 19 Feb 2021 10:46:28 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id p21so5286304pgl.12;
        Fri, 19 Feb 2021 10:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nWHPCx1HlElPMRx1oDR1l9790mNvIV2DGAOqGYGOIyo=;
        b=IOjUxI4WVWPy0sK9Ybj0Mw1L/HjF9gUV7E/74b1/Z134izzZALq2rBmvqYTbk5U4Kt
         2okrr0wyGguH5+1CCzhmOOLv29c+nLK8sl3ecCC/aETLEXtcAERCxrfv5LLUoiuC6m6h
         jOLaSOJYFoozoEOcUjAiRtAmUif/rODORzRaO2axF6SWMU3TdtwQhPFe2TRSeR1hyzOn
         HaV8EZNJCKgKJpv1A65oARmY9zzsp6baId1ZxDKonpon/Mbo5Chy6DEs9ax2clAME0Te
         Xr6CumGJMgbLP0lR8fkv5Go05ks4p1YSGDa73xmiKqu2sNqjtjziGmEUV2n1xO7hcmF/
         ZZqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nWHPCx1HlElPMRx1oDR1l9790mNvIV2DGAOqGYGOIyo=;
        b=kpwe4lxiaMwQl581BvzebP1POdycPDF5o4rYb/ReFbDFRAt5fMf4E0tf+uOYfINw8o
         JYfPCBuXoRunb1uOpvlKmuC5IUkIaliw10JYdV3fb3nL7mG4GeXRJN5/gr3lfcoLLCZn
         X8sArou4EPbh6sVzlsAsMmgJu8HWM9ox+HOVHC4deWSHyiar4fmNIy3v8NIwIu05t0hm
         ewelJ2sHdeWWKGpnmZzzcn8na9dzQxF2P0PT9hcIl4Bq5b7KPMjLnq8F00vBhYn5JcRk
         CmTizmA0iKDfKDAfuRHluLcgKWLX4hFZOQ+2T2EaGbasv00sWdd6a6+xVr7M32Kv1mS4
         jDqg==
X-Gm-Message-State: AOAM532OE0Avxi46MqzPk+aZjVw0jo0mus1bOLqPA/RRzsloL2xS0N3r
        e3yMHeyN49wiYgRp9WbFKEeThvVc9WdDQckU1JU=
X-Google-Smtp-Source: ABdhPJwB5tsJ6DQMLRTOAlnz5KC5Y9i+zXogiSgf5pKZ/g1Z/hN01oQ+MxFwbKTk+q4dsfRlvsbsX0ch9vHbW3PIqBI=
X-Received: by 2002:a63:3c4e:: with SMTP id i14mr9471710pgn.266.1613760388247;
 Fri, 19 Feb 2021 10:46:28 -0800 (PST)
MIME-Version: 1.0
References: <20210216064250.38331-1-xiyou.wangcong@gmail.com>
 <20210216064250.38331-2-xiyou.wangcong@gmail.com> <87im6n52zx.fsf@cloudflare.com>
In-Reply-To: <87im6n52zx.fsf@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 19 Feb 2021 10:46:17 -0800
Message-ID: <CAM_iQpVou5Ea5APSzpcQU9oyb0n39Wmo1zTqJfMjWSt-NvGO5A@mail.gmail.com>
Subject: Re: [Patch bpf-next v4 1/5] bpf: clean up sockmap related Kconfigs
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 19, 2021 at 10:25 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Tue, Feb 16, 2021 at 07:42 AM CET, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > As suggested by John, clean up sockmap related Kconfigs:
> >
> > Reduce the scope of CONFIG_BPF_STREAM_PARSER down to TCP stream
> > parser, to reflect its name.
> >
> > Make the rest sockmap code simply depend on CONFIG_BPF_SYSCALL.
> > And leave CONFIG_NET_SOCK_MSG untouched, as it is used by
> > non-sockmap cases.
> >
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
> > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
>
> Sorry for the delay. There's a lot happening here. Took me a while to
> dig through it.
>
> I have a couple of nit-picks, which easily can be addressed as
> follow-ups, and one comment.

No problem, it is not merged, so V5 is definitely not a problem.

>
> sock_map_prog_update and sk_psock_done_strp are only used in
> net/core/sock_map.c and can be static.

1. This seems to be unrelated to this patch? But I am still happy to
address it.

2. sk_psock_done_strp() is in skmsg.c, hence why it is non-static.
And I believe it fits in skmsg.c better than in sock_map.c, because
it operates on psock rather than sock_map itself.

So, I can make sock_map_prog_update() static in a separate patch
and carry it in V5.

>
> [...]
>
> > diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> > index bc7d2a586e18..b2c4865eb39b 100644
> > --- a/net/ipv4/tcp_bpf.c
> > +++ b/net/ipv4/tcp_bpf.c
> > @@ -229,7 +229,6 @@ int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
> >  }
> >  EXPORT_SYMBOL_GPL(tcp_bpf_sendmsg_redir);
> >
> > -#ifdef CONFIG_BPF_STREAM_PARSER
> >  static bool tcp_bpf_stream_read(const struct sock *sk)
> >  {
> >       struct sk_psock *psock;
> > @@ -561,8 +560,10 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
> >                                  struct proto *base)
> >  {
> >       prot[TCP_BPF_BASE]                      = *base;
> > +#if defined(CONFIG_BPF_SYSCALL)
> >       prot[TCP_BPF_BASE].unhash               = sock_map_unhash;
> >       prot[TCP_BPF_BASE].close                = sock_map_close;
> > +#endif
> >       prot[TCP_BPF_BASE].recvmsg              = tcp_bpf_recvmsg;
> >       prot[TCP_BPF_BASE].stream_memory_read   = tcp_bpf_stream_read;
> >
> > @@ -629,4 +630,3 @@ void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
> >       if (prot == &tcp_bpf_prots[family][TCP_BPF_BASE])
> >               newsk->sk_prot = sk->sk_prot_creator;
> >  }
> > -#endif /* CONFIG_BPF_STREAM_PARSER */
>
> net/core/sock_map.o now is built only when CONFIG_BPF_SYSCALL is set.
> While tcp_bpf_get_proto is only called from net/core/sock_map.o.
>
> Seems there is no sense in compiling tcp_bpf_get_proto, and everything
> it depends on which was enclosed by CONFIG_BPF_STREAM_PARSER check, when
> CONFIG_BPF_SYSCALL is unset.

I can try but I am definitely not sure whether kTLS is happy about
it, clearly kTLS at least uses __tcp_bpf_recvmsg() and
tcp_bpf_sendmsg_redir().

>
> > diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
> > index 7a94791efc1a..e635ccc175ca 100644
> > --- a/net/ipv4/udp_bpf.c
> > +++ b/net/ipv4/udp_bpf.c
> > @@ -18,8 +18,10 @@ static struct proto udp_bpf_prots[UDP_BPF_NUM_PROTS];
> >  static void udp_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
> >  {
> >       *prot        = *base;
> > +#if defined(CONFIG_BPF_SYSCALL)
> >       prot->unhash = sock_map_unhash;
> >       prot->close  = sock_map_close;
> > +#endif
> >  }
> >
> >  static void udp_bpf_check_v6_needs_rebuild(struct proto *ops)
>
> Same situation here but for udp_bpf_get_proto.

UDP is different, as kTLS certainly doesn't and won't use it. I think
udp_bpf.c can be just put under CONFIG_BPF_SYSCALL.

Thanks.
