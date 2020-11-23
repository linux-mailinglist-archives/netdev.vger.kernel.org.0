Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89AFB2C0C04
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729919AbgKWNhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729781AbgKWNhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 08:37:39 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D83BC0613CF
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 05:37:39 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id o25so19688771oie.5
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 05:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mltk67DXea7zsfQ6fqyLDZT0KhzJoiu2sHs7lYzBdPQ=;
        b=G3g3wD4zYiz1vznpVLO6PbSJSeyhlOPKP7QiicBq35IjwMRqT6Ne8BM4h0JHiBMkqt
         2rS42/GrDVNuwirM1p/FQ6VIidKtim3wcxC7jXuWLwK/JFQxuE+a1ySQE0zGt1wLCM92
         hDMhVTvLiBfOPBOF5KPHn9qHvz+buZhDsb2oVwAjp0EYvkcjsruNjpaUcYczbSXM5vAE
         Y0ixRp9wUknIAhTx1ozvRvdKFemxWydEFA2id9kf46/iPsXfMNB89HW2HayKgs4GvHVX
         GkCOfE3W0+jhN7nn3ZlOyz7jvl5B9Y7czCv05Wud7dIILgSWLbwf1S1H95PBjPchUOkN
         esEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mltk67DXea7zsfQ6fqyLDZT0KhzJoiu2sHs7lYzBdPQ=;
        b=s5OPyGrxUnzOjAIr6rSCGlGxX5CluGFbhqwQo2STq+RAb/nH2GaNOg7UK5CNM1kHAz
         oU6qHziGqJniXfZyTXI4QBK1Xlle8x+RMXj6GFDh1YUhQnel+zm6yCW3yBQQ53tHL62P
         9yLZpODfLJhCmgDOlHgJwz2FVTuPqnz9IBfBnTaoEozkx3fnBTsxOwMOJAKOXGiIl/wB
         Wsp7P8ixiOY/2I8+RbyY3t+dxWghB9D7UqF3H4MKcV4QLyUmXLBApQC93IhvTT9hILmE
         bXG7DASOm1LM/i5KDSAk8874jB7i6Jxlh2dWJwZwP1La8ou4nPFdLQfo0+fvEIyI8IH3
         sROA==
X-Gm-Message-State: AOAM530hrQC2HkSpecmdQ9Y77hNs26US2x+3ba9q+L6Mt3JjRKd1KDyr
        cilQycB0/RYre5TV8ePkuyj1cD0ak3SGrEfZutY=
X-Google-Smtp-Source: ABdhPJzn9XtlnbN2WI3KtjZT8J8qsVzar5TyCBtHMtrND/68YIx2PSXNe7E7kIssamgeXq6MHkAZHPeh61V+1r60ypM=
X-Received: by 2002:aca:7554:: with SMTP id q81mr15199484oic.89.1606138658514;
 Mon, 23 Nov 2020 05:37:38 -0800 (PST)
MIME-Version: 1.0
References: <20201123120531.724963-1-zyjzyj2000@gmail.com> <CAD=hENfysbUCNapfFZ6i0tOFo5Ge3QS+iQSt2ySBDb10zFdgwg@mail.gmail.com>
 <CAJ8uoz1TO7ULPDTK0ajyrjVFqB2REw=ncgT1c-NDhTciDeNfNg@mail.gmail.com>
In-Reply-To: <CAJ8uoz1TO7ULPDTK0ajyrjVFqB2REw=ncgT1c-NDhTciDeNfNg@mail.gmail.com>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Mon, 23 Nov 2020 21:37:27 +0800
Message-ID: <CAD=hENeHFSJOO=Kt060y0R29d4wn87ESdrqY6n6ACA--LkZEFA@mail.gmail.com>
Subject: Re: [PATCHv2 1/1] xdp: remove the function xsk_map_inc
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 8:19 PM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Mon, Nov 23, 2020 at 1:11 PM Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
> >
> > On Mon, Nov 23, 2020 at 8:05 PM <zyjzyj2000@gmail.com> wrote:
> > >
> > > From: Zhu Yanjun <zyjzyj2000@gmail.com>
> > >
> > > The function xsk_map_inc is a simple wrapper of bpf_map_inc and
> > > always returns zero. As such, replacing this function with bpf_map_inc
> > > and removing the test code.
> > >
> > > Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
> >
> >
> > > ---
> > >  net/xdp/xsk.c    |  1 -
> > >  net/xdp/xsk.h    |  1 -
> > >  net/xdp/xskmap.c | 13 +------------
> > >  3 files changed, 1 insertion(+), 14 deletions(-)
> > >
> > > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > > index cfbec3989a76..c1b8a888591c 100644
> > > --- a/net/xdp/xsk.c
> > > +++ b/net/xdp/xsk.c
> > > @@ -548,7 +548,6 @@ static struct xsk_map *xsk_get_map_list_entry(struct xdp_sock *xs,
> > >         node = list_first_entry_or_null(&xs->map_list, struct xsk_map_node,
> > >                                         node);
> > >         if (node) {
> > > -               WARN_ON(xsk_map_inc(node->map));
>
> This should be bpf_map_inc(&node->map->map); Think you forgot to
> convert this one.

In include/linux/bpf.h:
"
...
1213 void bpf_map_inc(struct bpf_map *map);
...
"

Zhu Yanjun
>
> > >                 map = node->map;
> > >                 *map_entry = node->map_entry;
> > >         }
> > > diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
> > > index b9e896cee5bb..0aad25c0e223 100644
> > > --- a/net/xdp/xsk.h
> > > +++ b/net/xdp/xsk.h
> > > @@ -41,7 +41,6 @@ static inline struct xdp_sock *xdp_sk(struct sock *sk)
> > >
> > >  void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
> > >                              struct xdp_sock **map_entry);
> > > -int xsk_map_inc(struct xsk_map *map);
> > >  void xsk_map_put(struct xsk_map *map);
> > >  void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id);
> > >  int xsk_reg_pool_at_qid(struct net_device *dev, struct xsk_buff_pool *pool,
> > > diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
> > > index 49da2b8ace8b..6b7e9a72b101 100644
> > > --- a/net/xdp/xskmap.c
> > > +++ b/net/xdp/xskmap.c
> > > @@ -11,12 +11,6 @@
> > >
> > >  #include "xsk.h"
> > >
> > > -int xsk_map_inc(struct xsk_map *map)
> > > -{
> > > -       bpf_map_inc(&map->map);
> > > -       return 0;
> > > -}
> >
> > Hi, Magnus
> >
> > The function xsk_map_inc is replaced with bpf_map_inc.
> >
> > Zhu Yanjun
> >
> > > -
> > >  void xsk_map_put(struct xsk_map *map)
> > >  {
> > >         bpf_map_put(&map->map);
> > > @@ -26,17 +20,12 @@ static struct xsk_map_node *xsk_map_node_alloc(struct xsk_map *map,
> > >                                                struct xdp_sock **map_entry)
> > >  {
> > >         struct xsk_map_node *node;
> > > -       int err;
> > >
> > >         node = kzalloc(sizeof(*node), GFP_ATOMIC | __GFP_NOWARN);
> > >         if (!node)
> > >                 return ERR_PTR(-ENOMEM);
> > >
> > > -       err = xsk_map_inc(map);
> > > -       if (err) {
> > > -               kfree(node);
> > > -               return ERR_PTR(err);
> > > -       }
> > > +       bpf_map_inc(&map->map);
> > >
> > >         node->map = map;
> > >         node->map_entry = map_entry;
> > > --
> > > 2.25.1
> > >
