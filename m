Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BECC3148AE0
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 16:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388128AbgAXPFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 10:05:04 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44213 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387432AbgAXPFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 10:05:03 -0500
Received: by mail-ed1-f66.google.com with SMTP id bx28so2581460edb.11
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 07:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w/FhJxGgaFV+qQRXwKyWClg+6DX1t7PErintQbMkPTE=;
        b=ITuH2JVg25jJFBIWxbd4DZ9wxh+U/VXvXAOjcQrWbTyhBtgRk7QWo0WY+5iilpSbCg
         G762pLa5GqZ7GNC+Wex+2QmNPSh4iueqFJCjIl+LtUMGZZb99mQy9zidclRUsTld/v9u
         T1yLNyH8kG/ekx4GJxDysz/VcfFbJ1zM/9RkStGOBuvf0DwwcJxGcWk3Ewoj5ervbU6y
         VcMn6wi7+zvFte4FB8m2/uMENurMfvogBvqOYvD7Z9HxqQ0mpnU5DATZHmrJ/K2EqM2v
         inpy9QOMZ0HqpcVLtDW8VpmZemlYh+ZVgTxD2rj5nmiVrVvmM+t8sNZZujaGMhMrDG/Y
         lqYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w/FhJxGgaFV+qQRXwKyWClg+6DX1t7PErintQbMkPTE=;
        b=k3FeYJZcmDJTFkAUVtN9KIcOJqD1wHBt/bBjGqFT8e390z5/chTkTAWx4embayosz+
         3N7fd/JSItcE+chkQWmO0oyaY5iIs9z8lvR9GPTijxoJWnanPc6+2F6HujhUaKciH+c5
         Bvib1eUJVKEqgP9rloNIPove8QaQsskjNUm8s5QTKr3/PK/GhS71z59yYgpiXD7vR/JZ
         NaH77lK+AnwBUsLRJQL5Pa3diWpYwhT7JYXSp12kZnTTG+F4cqU8PLJvyI6LpVhUTPHT
         wlQfQGDSjGltUV5wp4j1Kju2sG6Us6e9xUrviiiEy3Urue6x891uKHjADhz7jaXj621j
         0Azg==
X-Gm-Message-State: APjAAAUVEGAPs6zuqxC26HUQXftVaubHjdwrXUCaULxeyiCDGH8y9eC9
        gSz+QGA/uy4vR3YXApHM3lCxH32xQ6HmhC7qHKKBWA==
X-Google-Smtp-Source: APXvYqyN7GQb+MoTAr3/7AxxEw7g1HePA4G7XkPvsJ2rFpsS/3UDeX+v6QMSGcuIlkO7XdlV9LhuMPOxhphMRRXd+Yo=
X-Received: by 2002:a05:6402:1694:: with SMTP id a20mr2854841edv.211.1579878301239;
 Fri, 24 Jan 2020 07:05:01 -0800 (PST)
MIME-Version: 1.0
References: <20200123232054.183436-1-lrizzo@google.com> <3a7e66da-7506-47a0-8733-8d48674176f9@iogearbox.net>
 <20200124065244.4cafef68@cakuba>
In-Reply-To: <20200124065244.4cafef68@cakuba>
From:   Luigi Rizzo <lrizzo@google.com>
Date:   Fri, 24 Jan 2020 07:04:50 -0800
Message-ID: <CAMOZA0+R6GK1GGCb=mij7uffso5K_Db5wkWq-URwCsTYoqkxEg@mail.gmail.com>
Subject: Re: [PATCH net-next] v2 net-xdp: netdev attribute to control
 xdpgeneric skb linearization
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 6:52 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 24 Jan 2020 10:55:19 +0100, Daniel Borkmann wrote:
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 4dcc1b390667..13a671e45b61 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -4484,8 +4484,8 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
> > >      * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
> > >      * native XDP provides, thus we need to do it here as well.
> > >      */
> > > -   if (skb_is_nonlinear(skb) ||
> > > -       skb_headroom(skb) < XDP_PACKET_HEADROOM) {
> > > +   if (skb->dev->xdp_linearize && (skb_is_nonlinear(skb) ||
> > > +       skb_headroom(skb) < XDP_PACKET_HEADROOM)) {
> > >             int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
> > >             int troom = skb->tail + skb->data_len - skb->end;
> >
> > I still think in order for this knob to be generally useful, we would need to
> > provide an equivalent of bpf_skb_pull_data() helper, which in generic XDP would then
> > pull in more data from non-linear section, and in native XDP would be a "no-op" since
> > the frame is already linear. Otherwise, as mentioned in previous thread, users would
> > have no chance to examine headers if they are not pre-pulled by the driver.
>
> Which takes us to the point of the ongoing work to allow multi-buffer
> frames in native mode. Sorry if this was already mentioned but this
> seems like the other side of the same coin, once we have multi-buffer
> semantics in native mode we can likely just replicate them for skbs, no?

Yes I am aware of that discussion (I posted links to it in some of the
previous messages).
My understanding is that there is no satisfactory solution, and the one effort
I am aware of seems to be "only pass the header".

My feeling is also that by implementing full multi-buffer support we end up
replicating the expensive part of the skb (dmasync, sg handling etc.),
at which point the benefits of a custom solution are largely gone.

cheers
luigi
