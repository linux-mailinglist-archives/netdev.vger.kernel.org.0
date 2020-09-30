Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04F727E07F
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 07:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbgI3FjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 01:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgI3FjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 01:39:16 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B679C061755;
        Tue, 29 Sep 2020 22:39:16 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id m5so619091lfp.7;
        Tue, 29 Sep 2020 22:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r6/0Ch+k5Ys1E3IXfQI20t3y10+qXJytvRGG7bTZJQo=;
        b=WQhC5GPzOi63cEdwhuuRS2V/6t6FhbwGZD+icnCQzTX5JiIIeS2NGQA1sY2jYNAYJh
         6yt5FygqqfQ9MCaaZ7YDJaNskKt/1DI2Soiau+RjF+53iQCdMk0FkvfdKCPcvPnRPoyh
         ET/PKwPd+kKfAYhF9mUKRS1df0IlHseezAhielfA21q0doB6useN46c6+f8yqpWApWIo
         v2hBAoHniHySz0W/2OrW6aFY7+jArVx5CWHrniVcc52LmTOBoJr3LF6OAF5HX2tiyar2
         oTb8XD4vFGDILlPb99DYLKXInkWdUkplvqAR3FLNDclxMc0V80FZgUdVKXGZqWhTpZKz
         F7Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r6/0Ch+k5Ys1E3IXfQI20t3y10+qXJytvRGG7bTZJQo=;
        b=CpIkclYo3Wj2pv/6H01BjXgUtJ+p/hRWyeXK1NurK1NM1icIs2h9RusvQbI832K8eI
         yBDbOMt3mmzenWjMyaBp+pwFt//VYrHXaLkAxmiLiyfXHCcM6S2M1t3U52dpih3gwjH5
         gXKPd8246Sqyr5fw6ClYWXDV2iQ8bGDcpWxj+x4UHrRw7E+bo2OI2Knh/xNbrVGsX785
         06fygn9XVbN/StC6nJDE1nOc1lWi0WmOgBxLSpDUTxlfuRnWukWNrpSbCO+cfnAC74un
         dG8LDFjbm59BzGGNbFRiEDZdoJe4Y0HTOpE97PiY1qR3+1xguNHyIuBswlQYfcitCUZf
         Ps0g==
X-Gm-Message-State: AOAM53312svOULShuelW6TbGyN1Xidhi3W8tgo0ahawv/4o2aL6+zFGB
        eDfxDS8CWiqA7UO8S4Hp8x2Em7axlTR7eR01q6E=
X-Google-Smtp-Source: ABdhPJy5q781z8R+pbwuVbr7RqRJq1qarIkOTOLHWY9XEx6YTihZ9UoCenRNIihnUD7X29n0nFBAMOwAnFA+6VCktEg=
X-Received: by 2002:ac2:44d3:: with SMTP id d19mr250407lfm.341.1601444354890;
 Tue, 29 Sep 2020 22:39:14 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LFD.2.23.451.2009271625160.35554@ja.home.ssi.bg>
 <20200928024938.97121-1-bigclouds@163.com> <alpine.LFD.2.23.451.2009300803110.6056@ja.home.ssi.bg>
In-Reply-To: <alpine.LFD.2.23.451.2009300803110.6056@ja.home.ssi.bg>
From:   yue longguang <yuelongguang@gmail.com>
Date:   Wed, 30 Sep 2020 13:39:04 +0800
Message-ID: <CAPaK2r_haEH1x2HQVBNqrHe-pRCA-2V-=Lvu1nmMOOW7ZeUqvQ@mail.gmail.com>
Subject: Re: [PATCH v5] ipvs: adjust the debug info in function set_tcp_state
To:     Julian Anastasov <ja@ssi.bg>
Cc:     "longguang.yue" <bigclouds@163.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:IPVS" <netdev@vger.kernel.org>,
        "open list:IPVS" <lvs-devel@vger.kernel.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's  done.


On Wed, Sep 30, 2020 at 1:08 PM Julian Anastasov <ja@ssi.bg> wrote:
>
>
>         Hello,
>
> On Mon, 28 Sep 2020, longguang.yue wrote:
>
> > Outputting client,virtual,dst addresses info when tcp state changes,
> > which makes the connection debug more clear
> >
> > Signed-off-by: longguang.yue <bigclouds@163.com>
>
>         OK, v5 can be used instead of fixing v4.
>
> Acked-by: Julian Anastasov <ja@ssi.bg>
>
> > ---
>     Changelogs:
>       v5: fix indentation
>       v4: fix checkpatch
>       v3: fix checkpatch
>       v2: IP_VS_DBG_BUF outputs src,virtual,dst of ip_vs_conn
>       v1: fix the inverse of src and dst address
>
>         longguang.yue, at this place after --- you can add info
> for changes between versions, eg:
> v5: fix indentation
>
>         Use this for other patches, so that we know what is
> changed between versions.
>
> >  net/netfilter/ipvs/ip_vs_proto_tcp.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> > index dc2e7da2742a..7da51390cea6 100644
> > --- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
> > +++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> > @@ -539,8 +539,8 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
> >       if (new_state != cp->state) {
> >               struct ip_vs_dest *dest = cp->dest;
> >
> > -             IP_VS_DBG_BUF(8, "%s %s [%c%c%c%c] %s:%d->"
> > -                           "%s:%d state: %s->%s conn->refcnt:%d\n",
> > +             IP_VS_DBG_BUF(8, "%s %s [%c%c%c%c] c:%s:%d v:%s:%d "
> > +                           "d:%s:%d state: %s->%s conn->refcnt:%d\n",
> >                             pd->pp->name,
> >                             ((state_off == TCP_DIR_OUTPUT) ?
> >                              "output " : "input "),
> > @@ -548,10 +548,12 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
> >                             th->fin ? 'F' : '.',
> >                             th->ack ? 'A' : '.',
> >                             th->rst ? 'R' : '.',
> > -                           IP_VS_DBG_ADDR(cp->daf, &cp->daddr),
> > -                           ntohs(cp->dport),
> >                             IP_VS_DBG_ADDR(cp->af, &cp->caddr),
> >                             ntohs(cp->cport),
> > +                           IP_VS_DBG_ADDR(cp->af, &cp->vaddr),
> > +                           ntohs(cp->vport),
> > +                           IP_VS_DBG_ADDR(cp->daf, &cp->daddr),
> > +                           ntohs(cp->dport),
> >                             tcp_state_name(cp->state),
> >                             tcp_state_name(new_state),
> >                             refcount_read(&cp->refcnt));
> > --
> > 2.20.1 (Apple Git-117)
>
> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>
>
