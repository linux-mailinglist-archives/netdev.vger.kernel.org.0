Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0492CE626
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 16:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbfJGOzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 10:55:21 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41613 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbfJGOzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 10:55:21 -0400
Received: by mail-lf1-f65.google.com with SMTP id r2so9489004lfn.8;
        Mon, 07 Oct 2019 07:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oKQe8PW7xJsxkuN7cYHlHAyycnltqq5WzMyDlYxJAao=;
        b=KCbv97tb6Hoh+UXuWKIUqilZW7r/lPn2+CWJfseZOOnUoC8QIPALjQLyuNIqXZHsmh
         HwsTk9x4Sdbf/IKiQVm6WfCgWLrqpfn4ZR4CH9iFtso8DJD2+S/v7b3ZjiNWG/F5dkAW
         nRBoHuP/CK0mFGQ21n+aVegUI1Tse1t2q6Yf0qpKGgz45aMPJTtzqEvp4mYvfLTSwNSn
         j5kR90O4aCU1cJc5uICbDFGBJ6WvJGvFDkI4KDzgAyBgFvCrsyXiE0if7jUVgk2nzvT5
         f0sXT2AO6Gci1607rq7Q0NDDCvuHsVYtStfCc46EZzwD9EEatEgaxEe14LROGNNUMvug
         Z3ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oKQe8PW7xJsxkuN7cYHlHAyycnltqq5WzMyDlYxJAao=;
        b=s9q1wE+ZDpq3DbDiLN2FbwjSZdr7A5/IufP8qL75Xg2B7WGQm7ugfpA9XTA+D/VHVS
         Nz1klnU0D+NyYGeIyrsXfqN4O93M+5fV6dZAV83pE+44ta1sjFcJJR/H8IYGxyE0cQ+Y
         STwBlAlri+iRXSezzqetsfkFZ2sJvk5j1h3EqpxnsCxfGtFIwRdApWWvJDyov+0Xmcx8
         tGSfVSElq80OVaTNRU7ke32O4LpW3tPgdkQHUuc4C16kiOfZDEaDfvKJXl4nyPh/44h8
         exqBOQtEKejD3Tc45vZs07AvWlq5sOAb2YZisOdryQ29ng5Eprsug/AvWap/1Ard+O2n
         A6Hw==
X-Gm-Message-State: APjAAAWEALeQpAjM/DIifugwrJ8a4qo/zVFNE9hV3DOQfyBKUbfH1z+6
        Nf6HnySGegt2E9lkJJseKIaLrMqCNDbRIQg7CK8=
X-Google-Smtp-Source: APXvYqxMeyuL3TPfkmpATSvEkF+Vpcsni2k5agi3aTnnPNW/tlMsFs2IEPjetUBcG/k204KKg7Mn9S20Ld9yM/f8ybA=
X-Received: by 2002:ac2:59c2:: with SMTP id x2mr15598267lfn.125.1570460118637;
 Mon, 07 Oct 2019 07:55:18 -0700 (PDT)
MIME-Version: 1.0
References: <20191006184515.23048-1-jcfaracco@gmail.com> <20191006184515.23048-2-jcfaracco@gmail.com>
 <52efa170-722c-334d-627e-30931fba7a7e@linux.ibm.com>
In-Reply-To: <52efa170-722c-334d-627e-30931fba7a7e@linux.ibm.com>
From:   Julio Faracco <jcfaracco@gmail.com>
Date:   Mon, 7 Oct 2019 11:55:06 -0300
Message-ID: <CAENf94JY_ScDs+hW9EMMmYamTQ8bkLfavYZJdgCmk-59N3dCtQ@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 1/2] drivers: net: virtio_net: Add tx_timeout
 stats field
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, davem@davemloft.net,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Daiane Mendes <dnmendes76@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em seg, 7 de out de 2019 =C3=A0s 11:15, Julian Wiedmann <jwi@linux.ibm.com>=
 escreveu:
>
> On 06.10.19 20:45, jcfaracco@gmail.com wrote:
> > From: Julio Faracco <jcfaracco@gmail.com>
> >
> > For debug purpose of TX timeout events, a tx_timeout entry was added to
> > monitor this special case: when dev_watchdog identifies a tx_timeout an=
d
> > throw an exception. We can both consider this event as an error, but
> > driver should report as a tx_timeout statistic.
> >
>
> Hi Julio,
> dev_watchdog() updates txq->trans_timeout, why isn't that sufficient?

Hi Julian,
Good catch! This case (this patch) it would be useful only for ethtool stat=
s.
This is not so relevant as the method implementation itself.
But, on the other hand, I think it should be relevant if we split into
tx_timeout per queue.
Anyway, suggestions are welcome.

>
>
> > Signed-off-by: Julio Faracco <jcfaracco@gmail.com>
> > Signed-off-by: Daiane Mendes <dnmendes76@gmail.com>
> > Cc: Jason Wang <jasowang@redhat.com>
> > ---
> >  drivers/net/virtio_net.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 4f3de0ac8b0b..27f9b212c9f5 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -75,6 +75,7 @@ struct virtnet_sq_stats {
> >       u64 xdp_tx;
> >       u64 xdp_tx_drops;
> >       u64 kicks;
> > +     u64 tx_timeouts;
> >  };
> >
> >  struct virtnet_rq_stats {
> > @@ -98,6 +99,7 @@ static const struct virtnet_stat_desc virtnet_sq_stat=
s_desc[] =3D {
> >       { "xdp_tx",             VIRTNET_SQ_STAT(xdp_tx) },
> >       { "xdp_tx_drops",       VIRTNET_SQ_STAT(xdp_tx_drops) },
> >       { "kicks",              VIRTNET_SQ_STAT(kicks) },
> > +     { "tx_timeouts",        VIRTNET_SQ_STAT(tx_timeouts) },
> >  };
> >
> >  static const struct virtnet_stat_desc virtnet_rq_stats_desc[] =3D {
> > @@ -1721,7 +1723,7 @@ static void virtnet_stats(struct net_device *dev,
> >       int i;
> >
> >       for (i =3D 0; i < vi->max_queue_pairs; i++) {
> > -             u64 tpackets, tbytes, rpackets, rbytes, rdrops;
> > +             u64 tpackets, tbytes, terrors, rpackets, rbytes, rdrops;
> >               struct receive_queue *rq =3D &vi->rq[i];
> >               struct send_queue *sq =3D &vi->sq[i];
> >
> > @@ -1729,6 +1731,7 @@ static void virtnet_stats(struct net_device *dev,
> >                       start =3D u64_stats_fetch_begin_irq(&sq->stats.sy=
ncp);
> >                       tpackets =3D sq->stats.packets;
> >                       tbytes   =3D sq->stats.bytes;
> > +                     terrors  =3D sq->stats.tx_timeouts;
> >               } while (u64_stats_fetch_retry_irq(&sq->stats.syncp, star=
t));
> >
> >               do {
> > @@ -1743,6 +1746,7 @@ static void virtnet_stats(struct net_device *dev,
> >               tot->rx_bytes   +=3D rbytes;
> >               tot->tx_bytes   +=3D tbytes;
> >               tot->rx_dropped +=3D rdrops;
> > +             tot->tx_errors  +=3D terrors;
> >       }
> >
> >       tot->tx_dropped =3D dev->stats.tx_dropped;
> >
>
