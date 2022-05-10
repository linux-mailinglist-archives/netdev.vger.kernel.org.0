Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7E1520B91
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 04:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234647AbiEJDAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 23:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiEJDAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 23:00:08 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AC0179092;
        Mon,  9 May 2022 19:56:12 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id p18so18363226edr.7;
        Mon, 09 May 2022 19:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jxQ4FfNifoAJnZ9RmrNs5f5NM/VT87rpdDF11Jk1btA=;
        b=SIoRNBBruUGqvs1gFylAGuQkpK43TNtybVWSF7483tLUz8XioL7cLwS6mWSdNif4Zl
         yejzbF09bGelUNpFCzxixRshQf/uzmkyxlfCZvjeLamGQmHU0Q3d+opBLK+gKS4xAs20
         jsI15Y3sgjWwvSP33vRuKK2KVsruIu+TDuHtgalnAMsgUOr5YKLKzVxiu1Vua32lKgIC
         FQxU8Tf4Hy5FpwlZTbLCtVShnNA/LDfBA950XwR3dXRo90sC28amqEoq/LFtm6KwAawz
         o38cKjw0EEerDpWthWTlbTHEcXoUNrohxAzXn2Dr3+VCz6o//Po7D/c0ytcMWK8fN/6E
         1JVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jxQ4FfNifoAJnZ9RmrNs5f5NM/VT87rpdDF11Jk1btA=;
        b=xtAeunBzKz4cLMi7uyLeF8n7BikeOcrtUi/XXKrNGANoKMkPYYgSMjwHKINYdl/6B4
         MMDgucahMq6rsKEk6jhdRlR2VxmTOkE/yr+mF1Ip/pGE/hdtfANTw2r/uPFeFt/g3ZPs
         uWR06crA0jwb3kuM8f5Qs6RhiwzHtZjVUcS2ktQXDQZkIwcaoW3CdwViguXHK9kqRpj6
         2KksQsvIjbRtcmI0Z5eTurNyfqESJzTn++NGFVAxif7wsiYhv0CE1zVEpJRb7fr5guCC
         6uhSGjkx4umOJ5cL2UTk8tlK89PJFVScZ12kVkS3NCRykdNbGR+oMx3nqrtT04VjoMj8
         ayOA==
X-Gm-Message-State: AOAM530341f0yDE9EaAbwDO/M9Q77alEqFkzVcYBvJCE8048eQ022MaV
        2NGL4tzJtg+LHovSXppWyXFQGbIu2m1ZrnQttmQ=
X-Google-Smtp-Source: ABdhPJwwHna8gv/y3VblXwcs6HxkUVCt3J+24Nkru1QGmlBwI8NbhBJjNhhh5sfy1uEWmTb35kbjxHOkM6S/PTqBx/U=
X-Received: by 2002:a05:6402:3326:b0:426:4883:60a with SMTP id
 e38-20020a056402332600b004264883060amr20183055eda.310.1652151370936; Mon, 09
 May 2022 19:56:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220509122213.19508-1-imagedong@tencent.com> <cb8eaad0-83c5-a150-d830-e078682ba18b@ssi.bg>
In-Reply-To: <cb8eaad0-83c5-a150-d830-e078682ba18b@ssi.bg>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Tue, 10 May 2022 10:55:59 +0800
Message-ID: <CADxym3YH_76+5g29QF4Xp4gXJz5bwdQXD_gXv3esAVTgNGkXyg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ipvs: random start for RR scheduler
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev <netdev@vger.kernel.org>, lvs-devel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 2:17 AM Julian Anastasov <ja@ssi.bg> wrote:
>
>
>         Hello,
>
> On Mon, 9 May 2022, menglong8.dong@gmail.com wrote:
>
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > For now, the start of the RR scheduler is in the order of dest
> > service added, it will result in imbalance if the load balance
>
>         ...order of added destinations,...
>
> > is done in client side and long connect is used.
>
>         ..."long connections are used". Is this a case where
> small number of connections are used? And the two connections
> relatively overload the real servers?
>
> > For example, we have client1, client2, ..., client5 and real service
> > service1, service2, service3. All clients have the same ipvs config,
> > and each of them will create 2 long TCP connect to the virtual
> > service. Therefore, all the clients will connect to service1 and
> > service2, leaving service3 free.
>
>         You mean, there are many IPVS directors with same
> config and each director gets 2 connections? Third connection
> will get real server #3, right ? Also, are the clients local
> to the director?
>
> > Fix this by randomize the start of dest service to RR scheduler when
>
>         ..."randomizing the starting destination when"
>

Nice description :/

> > IP_VS_SVC_F_SCHED_RR_RANDOM is set.
> >
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> >  include/uapi/linux/ip_vs.h    |  2 ++
> >  net/netfilter/ipvs/ip_vs_rr.c | 25 ++++++++++++++++++++++++-
> >  2 files changed, 26 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/ip_vs.h b/include/uapi/linux/ip_vs.h
> > index 4102ddcb4e14..7f74bafd3211 100644
> > --- a/include/uapi/linux/ip_vs.h
> > +++ b/include/uapi/linux/ip_vs.h
> > @@ -28,6 +28,8 @@
> >  #define IP_VS_SVC_F_SCHED_SH_FALLBACK        IP_VS_SVC_F_SCHED1 /* SH fallback */
> >  #define IP_VS_SVC_F_SCHED_SH_PORT    IP_VS_SVC_F_SCHED2 /* SH use port */
> >
> > +#define IP_VS_SVC_F_SCHED_RR_RANDOM  IP_VS_SVC_F_SCHED1 /* random start */
> > +
> >  /*
> >   *      Destination Server Flags
> >   */
> > diff --git a/net/netfilter/ipvs/ip_vs_rr.c b/net/netfilter/ipvs/ip_vs_rr.c
> > index 38495c6f6c7c..e309d97bdd08 100644
> > --- a/net/netfilter/ipvs/ip_vs_rr.c
> > +++ b/net/netfilter/ipvs/ip_vs_rr.c
> > @@ -22,13 +22,36 @@
> >
> >  #include <net/ip_vs.h>
> >
> > +static void ip_vs_rr_random_start(struct ip_vs_service *svc)
> > +{
> > +     struct list_head *cur;
> > +     u32 start;
> > +
> > +     if (!(svc->flags | IP_VS_SVC_F_SCHED_RR_RANDOM) ||
>
>         | -> &
>
> > +         svc->num_dests <= 1)
> > +             return;
> > +
> > +     spin_lock_bh(&svc->sched_lock);
> > +     start = get_random_u32() % svc->num_dests;
>
>         May be prandom is more appropriate for non-crypto purposes.
> Also, not sure if it is a good idea to limit the number of steps,
> eg. to 128...
>
>         start = prandom_u32_max(min(svc->num_dests, 128U));
>

Yeah, prandom_u32_max is a good choice, I'll use it instead.

>         or just use
>
>         start = prandom_u32_max(svc->num_dests);
>
>         Also, this line can be before the spin_lock_bh.
>
> > +     cur = &svc->destinations;
>
>         cur = svc->sched_data;
>
>         ... and to start from current svc->sched_data because
> we are called for every added dest. Better to jump 0..127 steps
> ahead, to avoid delay with long lists?
>

I'm a little afraid that the 'steps' may make the starting dest not
absolutely random, in terms of probability. For example, we have
256 services, and will the services in the middle have more chances
to be chosen as the start? It's just a feeling, I'm not good at
Probability :/

The delay that ip_vs_wrr_gcd_weight() caused is much more than
this case, so maybe the delay here can be ignored?

Thanks!
Menglong Dong
