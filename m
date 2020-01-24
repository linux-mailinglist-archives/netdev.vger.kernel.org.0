Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED99148AC7
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387631AbgAXO4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:56:50 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35801 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729567AbgAXO4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 09:56:49 -0500
Received: by mail-ed1-f65.google.com with SMTP id f8so2607172edv.2
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 06:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4TZu2SLRwYOVDFTF5A9WSketNDk6qLepVxiylB4rBMU=;
        b=Lj+AhIzSkBrKzKe2IKXSv7gZk3zMe1DnNkaFcR15m1elpHLJa7y9DWM1xmUfhVCWxw
         Iqn1OFyAkkL8ImOemkNHT2a2cvHgjK5dYLqwnyrbBAkWaxVlP/0aTxTBdYPebGlWATvA
         qqozbshktlzclkOa/YP7KVAkSnGS/IbWEJ6QSKdtI57y5f3u6fm1e4XB3qmBJL928Vou
         Mf9XlHJcXjfC5mmZmRHGR0xvbZa1Z7+SgOIJLl04NigR7/kP8e0h2DHPMdnPoqVr1SUb
         OPPGVlGGe8buAPlS7QqPyO6pBehDY2xTz11sGegFoTAquoslWdfNncCCvTZWoJjioak+
         wx2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4TZu2SLRwYOVDFTF5A9WSketNDk6qLepVxiylB4rBMU=;
        b=nHSZC0zuP5PpdxXS/IP6Iu/OFx80p0pBKMzPIB61St2iTGZGcC54AovclWu8Qvro+A
         XcZ0X+C99nif4svYVIO7DUUWl1xiT9TV+epsAuJZGr4iJiu2a3AoPyk9WDZDbG76TS31
         H/K/fdRhGWQG6eH+VGfOpcp81P0S9z7d+YVRFYhWdnqI+tHZWV8oIi32q6/wV59eL0pW
         9tNcKVrw7n6kOka6/S+/bBbFxmON6qIcIM5NGH4j99lIWTkvthnKs6kqOOgA5F/QEOTo
         uOO7xIRc70mS/wHactQMqeHEe57Z54wi6XZ0o9jpnwpRm23Kb/TPsUxGd3pHLmA7087f
         W9+g==
X-Gm-Message-State: APjAAAVWFRaOBZAmUvScIjseMO5YbJJgg+WETXXfMwFScTofwzcck5Qx
        ndNuzfPrY2PsXoWuP3kK+ayOz7gWvGpDMSqlIdyJJw==
X-Google-Smtp-Source: APXvYqxtliUkRpSzD/U/MCwPaslf9bqEjdGCkOTYNgQEY2eg0czWAcPHG/axqQkLq2LxJoJ3x+/aK31JlzrL9u7MBGc=
X-Received: by 2002:aa7:c2cb:: with SMTP id m11mr3071622edp.89.1579877807468;
 Fri, 24 Jan 2020 06:56:47 -0800 (PST)
MIME-Version: 1.0
References: <20200123232054.183436-1-lrizzo@google.com> <3a7e66da-7506-47a0-8733-8d48674176f9@iogearbox.net>
In-Reply-To: <3a7e66da-7506-47a0-8733-8d48674176f9@iogearbox.net>
From:   Luigi Rizzo <lrizzo@google.com>
Date:   Fri, 24 Jan 2020 06:56:36 -0800
Message-ID: <CAMOZA0+We6ZzWZWv6Azd6ah=xWWx4oy5ide=fJp0RxshXL2EQg@mail.gmail.com>
Subject: Re: [PATCH net-next] v2 net-xdp: netdev attribute to control
 xdpgeneric skb linearization
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 1:55 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 1/24/20 12:20 AM, Luigi Rizzo wrote:
> > Add a netdevice flag to control skb linearization in generic xdp mode.
> > Among the various mechanism to control the flag, the sysfs
> > interface seems sufficiently simple and self-contained.
> > The attribute can be modified through
> >       /sys/class/net/<DEVICE>/xdp_linearize
> > The default is 1 (on)
> >
> > On a kernel instrumented to grab timestamps around the linearization
> > code in netif_receive_generic_xdp, and heavy netperf traffic with 1500b
> > mtu, I see the following times (nanoseconds/pkt)
> >
> > The receiver generally sees larger packets so the difference is more
> > significant.
> >
> > ns/pkt                   RECEIVER                 SENDER
> >
> >                      p50     p90     p99       p50   p90    p99
> >
> > LINEARIZATION:    600ns  1090ns  4900ns     149ns 249ns  460ns
> > NO LINEARIZATION:  40ns    59ns    90ns      40ns  50ns  100ns
> >
> > Signed-off-by: Luigi Rizzo <lrizzo@google.com>
> > ---
> >   include/linux/netdevice.h |  3 ++-
> >   net/core/dev.c            |  5 +++--
> >   net/core/net-sysfs.c      | 15 +++++++++++++++
> >   3 files changed, 20 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 5ec3537fbdb1..b182f3cb0bf0 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -1959,7 +1959,8 @@ struct net_device {
> >
> >       struct netdev_rx_queue  *_rx;
> >       unsigned int            num_rx_queues;
> > -     unsigned int            real_num_rx_queues;
> > +     unsigned int            real_num_rx_queues:31;
> > +     unsigned int            xdp_linearize : 1;
> >
> >       struct bpf_prog __rcu   *xdp_prog;
> >       unsigned long           gro_flush_timeout;
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 4dcc1b390667..13a671e45b61 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -4484,8 +4484,8 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
> >        * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
> >        * native XDP provides, thus we need to do it here as well.
> >        */
> > -     if (skb_is_nonlinear(skb) ||
> > -         skb_headroom(skb) < XDP_PACKET_HEADROOM) {
> > +     if (skb->dev->xdp_linearize && (skb_is_nonlinear(skb) ||
> > +         skb_headroom(skb) < XDP_PACKET_HEADROOM)) {
> >               int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
> >               int troom = skb->tail + skb->data_len - skb->end;
>
> I still think in order for this knob to be generally useful, we would need to
> provide an equivalent of bpf_skb_pull_data() helper, which in generic XDP would then
> pull in more data from non-linear section, and in native XDP would be a "no-op" since
> the frame is already linear. Otherwise, as mentioned in previous thread, users would
> have no chance to examine headers if they are not pre-pulled by the driver.

I agree that eventually we should get there. But to be completely general,
we need to remain compatible with older programs that are not aware
of the  new mode of operation. I see three possible ways:
1. make the pullup transparent (triggered in the interpreter or bound
check emitted
  by the jit code);
2. provide a mechanism for programs to specify requirements at load time,
  (defaulting to "full packet, standard headroom").
3. provide a mechanism to identify older programs and always linearize
in those cases

If we have #2, we can actually live without the pullup helper, so that
seems to be a simpler
course of action.

This particular patch basically defers #2 to the operator.

cheers
luigi
