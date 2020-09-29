Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C097027BAC1
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 04:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgI2CQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 22:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgI2CQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 22:16:04 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831FEC061755;
        Mon, 28 Sep 2020 19:16:03 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id u8so3674543lff.1;
        Mon, 28 Sep 2020 19:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DjSQ9+lJ+KOY1QhLkpVLHaBOWFdrcLty+nw0yJV/I8Q=;
        b=DZhXDdSMQJIGkkVrGwyQS/lGggQc5c3pvIXYhO/IPdOhvQbCY+2marDi29JbT2EsKu
         yFJZHGwHAVox4UH2X2grKfs/9aOk7V/MQYOMlAVwDCWEpTT8Qha5YjjpVgtFX53/PEGY
         65Om4LcgoWwGsOtjri619XxiMgldZC+WAQbaE4XCJGF4B/aYF5sN/P8/WmgfSf/c7qpk
         ERrZXQr2wol0jNmvtQHOYFSkFNz9E+4/LOeAlnNMiJegctoKTYOPSyrXui3T+YsoclU7
         lt41N1uZG4PGWEuTqnJ+PVaEvxOLrfMMBQWL0FYkCsJ4ifddfSz3PTgiT0JA1uKXZ4To
         Ab+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DjSQ9+lJ+KOY1QhLkpVLHaBOWFdrcLty+nw0yJV/I8Q=;
        b=VFlNgeEvacsTG23U2JdwY36hVbWYK1FF5S7vqzOUYvjQDrCpGWVBGzEHnN91tQ0Khs
         AcDbDX6rMyQDhDSIC4TYPxDcfYQ/90Hsc4B4BHlAZpwMfbbPUcgT/+2KiIMye6X1x7H3
         FlSwQ+/oi68/q8mPr4m5wQ0i8U/f4Yo761mXtxhEgEyfWBQ5XYU6OtX79/jzFJpTB7oc
         QMYm55OZPgw8tDUqbbWqnzc784N5REESAhv/Gaw+pKJAsEYrjB5XvusWhpkPJA0aN0NH
         kaKL0iuWzeycecd/Y2BGxg2FCW+D96fIOVrFfjvF1NJ0fjgrwlUd5P5U1at9N4sAT8Ei
         bSpw==
X-Gm-Message-State: AOAM531sligha/B7hk65AQ6OGUN5jKp1Q/lAi8RwMvTC71z5HNMNuNm9
        iFcyXy4qWsnvLhlBpoz0LJzx1jR2aKs7TJpb/XE=
X-Google-Smtp-Source: ABdhPJzqPVHpxv1ABhfMES4dUiXbyCk4RTPwO8HCUtEr/JaIgCt6w4BXYPRcNnSoFkQntb43JJE/GzPGH6BacmE9YvY=
X-Received: by 2002:ac2:5594:: with SMTP id v20mr402181lfg.344.1601345760502;
 Mon, 28 Sep 2020 19:16:00 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LFD.2.23.451.2009271625160.35554@ja.home.ssi.bg> <20200928024938.97121-1-bigclouds@163.com>
In-Reply-To: <20200928024938.97121-1-bigclouds@163.com>
From:   yue longguang <yuelongguang@gmail.com>
Date:   Tue, 29 Sep 2020 10:15:49 +0800
Message-ID: <CAPaK2r8DnR_dcZ8E9w0mvDbK2KiWCt+JswO=-tqvbWb2RibaYw@mail.gmail.com>
Subject: Re: [PATCH v5] ipvs: adjust the debug info in function set_tcp_state
To:     Julian Anastasov <ja@ssi.bg>, "longguang.yue" <bigclouds@163.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Simon Horman <horms@verge.net.au>
Cc:     Wensong Zhang <wensong@linux-vs.org>,
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

I sincerely apologize for the trouble which takes up much of your
time. If the last patch does not work , would you please fix it?
thanks

On Mon, Sep 28, 2020 at 10:51 AM longguang.yue <bigclouds@163.com> wrote:
>
> Outputting client,virtual,dst addresses info when tcp state changes,
> which makes the connection debug more clear
>
> Signed-off-by: longguang.yue <bigclouds@163.com>
> ---
>  net/netfilter/ipvs/ip_vs_proto_tcp.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> index dc2e7da2742a..7da51390cea6 100644
> --- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
> +++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> @@ -539,8 +539,8 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
>         if (new_state != cp->state) {
>                 struct ip_vs_dest *dest = cp->dest;
>
> -               IP_VS_DBG_BUF(8, "%s %s [%c%c%c%c] %s:%d->"
> -                             "%s:%d state: %s->%s conn->refcnt:%d\n",
> +               IP_VS_DBG_BUF(8, "%s %s [%c%c%c%c] c:%s:%d v:%s:%d "
> +                             "d:%s:%d state: %s->%s conn->refcnt:%d\n",
>                               pd->pp->name,
>                               ((state_off == TCP_DIR_OUTPUT) ?
>                                "output " : "input "),
> @@ -548,10 +548,12 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
>                               th->fin ? 'F' : '.',
>                               th->ack ? 'A' : '.',
>                               th->rst ? 'R' : '.',
> -                             IP_VS_DBG_ADDR(cp->daf, &cp->daddr),
> -                             ntohs(cp->dport),
>                               IP_VS_DBG_ADDR(cp->af, &cp->caddr),
>                               ntohs(cp->cport),
> +                             IP_VS_DBG_ADDR(cp->af, &cp->vaddr),
> +                             ntohs(cp->vport),
> +                             IP_VS_DBG_ADDR(cp->daf, &cp->daddr),
> +                             ntohs(cp->dport),
>                               tcp_state_name(cp->state),
>                               tcp_state_name(new_state),
>                               refcount_read(&cp->refcnt));
> --
> 2.20.1 (Apple Git-117)
>
