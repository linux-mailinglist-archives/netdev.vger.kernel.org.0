Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87582D8273
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 23:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407057AbgLKWyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 17:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407043AbgLKWyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 17:54:40 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A77BC0613D3
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 14:54:00 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id a6so8796629wmc.2
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 14:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kHtjDDH7GvTHo4bSQkbyfDs6WmHuTRZuUmLBj4I09mM=;
        b=ZOYpIIJhdkjIiQrCDklbAJoCGhqr2KCzTSQCU7kEVzQ2UEt0EEFBiz6tWBA4FGQQxV
         zjLKwy1NJpfNzHOQ9525bmhx6NUFRRLkgJBxTvN9eOVo2OJ/5a7mvmpstAVjteuGu2TT
         MKbbWwhIWHog9cQIiXzuei0HHyPDdARN994uPx0h4nQKujNwwlqM28TD7I4wbqC+pQPe
         J3YFcJimPtUDOzfug20srnJ0J7LWGyqxGtOv9VUFOwQ5bs04TalKW4xynLxZjwuC2MiK
         1L2HFvrimunl74Eo77FPdWNYpZo8phU+MlexnX4QMczOi0Gaym3eS5gnfvHCEo4BTJWt
         C5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kHtjDDH7GvTHo4bSQkbyfDs6WmHuTRZuUmLBj4I09mM=;
        b=Vjv3MkPI/kWd/rN7wal1gAprEHqYKz/mKJy6vbdgIswczl9bObI+XTtgpQNQE/cVd6
         eh1LA/vt7FIWUNL7Q5WZaYC+YvbXMN8iIjPI98aMoD/nd6F3cnh6lBJc2F3WgQuRR6ME
         bdyXTS+z2obc7wlQL0mvKofg3YIOMHjEvWrXC1Vfeiepj0xSYcu9GlL9bdnvkkNERF4E
         BNMbcinrnkJqHOO1LGy/m3mRWj9tUszsX3FbrNwthoVUxBgHW+qilc67qVq16nrI1uCj
         lYCjWsT8XmGQC4sTrvcmnhDoROCDrnDJANZLC/Z4wUqKI4GNOR80yP+dDnzmGDUnMiIW
         0OBQ==
X-Gm-Message-State: AOAM533TqKwVvOMA0HI42fF8BWr8CJaksnnHwyBhIEC7xE1rbBVA5CZi
        7GalizMGKdoU5wXVC+MhI6ItO1PgAWSshr+nMr3ihA==
X-Google-Smtp-Source: ABdhPJzmfhavlPB8w3bW91z4SUiuhRHo2kLdkst0HwLbm60FEwGaRoPhGOycsEHCfnGNhZfEe8bGK3l2A3oqsr+8a6k=
X-Received: by 2002:a1c:40c:: with SMTP id 12mr15508379wme.40.1607727238734;
 Fri, 11 Dec 2020 14:53:58 -0800 (PST)
MIME-Version: 1.0
References: <160765171921.6905.7897898635812579754.stgit@localhost.localdomain>
 <CANn89iJ5HnJYv6eWb1jm6rK173DFkp2GRnfvi9vnYwXZPzE4LQ@mail.gmail.com>
 <CAKgT0Uf_q=FgMHd9_wq5Bx8rCC-kS0Qz563rE9dL2hpQ6Evppg@mail.gmail.com>
 <CANn89iJUT6aWm75ZpU_Ggmuqbb+cbLSGj0Bxysu9_wXRgNS8MQ@mail.gmail.com>
 <CAKgT0Uecuh3mcGRpDAZzzbnQtOusc++H4SXAv2Scd297Ha5AYQ@mail.gmail.com>
 <CANn89iKfqKpXgCv_Z4iSt5RpjxYUvkYSoZKF3FZs+Jgev3aDgw@mail.gmail.com> <CAKgT0Uc6gVOL5VWpsD54WiAvop9WQEudNsJNh9=Fr9PunJevWw@mail.gmail.com>
In-Reply-To: <CAKgT0Uc6gVOL5VWpsD54WiAvop9WQEudNsJNh9=Fr9PunJevWw@mail.gmail.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Fri, 11 Dec 2020 14:53:21 -0800
Message-ID: <CAK6E8=cbxpKH1hoeV5MuO_DdrbMSPvo+97UM3FT57-4Y7PuTiA@mail.gmail.com>
Subject: Re: [net PATCH] tcp: Mark fastopen SYN packet as lost when receiving ICMP_TOOBIG/ICMP_FRAG_NEEDED
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        kernel-team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 1:51 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, Dec 11, 2020 at 11:18 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Fri, Dec 11, 2020 at 6:15 PM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > On Fri, Dec 11, 2020 at 8:22 AM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > On Fri, Dec 11, 2020 at 5:03 PM Alexander Duyck
> > > > <alexander.duyck@gmail.com> wrote:
> > > >
> > > > > That's fine. I can target this for net-next. I had just selected net
> > > > > since I had considered it a fix, but I suppose it could be considered
> > > > > a behavioral change.
> > > >
> > > > We are very late in the 5.10 cycle, and we never handled ICMP in this
> > > > state, so net-next is definitely better.
> > > >
> > > > Note that RFC 7413 states in 4.1.3 :
> > > >
> > > >  The client MUST cache cookies from servers for later Fast Open
> > > >    connections.  For a multihomed client, the cookies are dependent on
> > > >    the client and server IP addresses.  Hence, the client should cache
> > > >    at most one (most recently received) cookie per client and server IP
> > > >    address pair.
> > > >
> > > >    When caching cookies, we recommend that the client also cache the
> > > >    Maximum Segment Size (MSS) advertised by the server.  The client can
> > > >    cache the MSS advertised by the server in order to determine the
> > > >    maximum amount of data that the client can fit in the SYN packet in
> > > >    subsequent TFO connections.  Caching the server MSS is useful
> > > >    because, with Fast Open, a client sends data in the SYN packet before
> > > >    the server announces its MSS in the SYN-ACK packet.  If the client
> > > >    sends more data in the SYN packet than the server will accept, this
> > > >    will likely require the client to retransmit some or all of the data.
> > > >    Hence, caching the server MSS can enhance performance.
> > > >
> > > >    Without a cached server MSS, the amount of data in the SYN packet is
> > > >    limited to the default MSS of 536 bytes for IPv4 [RFC1122] and 1220
> > > >    bytes for IPv6 [RFC2460].  Even if the client complies with this
> > > >    limit when sending the SYN, it is known that an IPv4 receiver
> > > >    advertising an MSS less than 536 bytes can receive a segment larger
> > > >    than it is expecting.
> > > >
> > > >    If the cached MSS is larger than the typical size (1460 bytes for
> > > >    IPv4 or 1440 bytes for IPv6), then the excess data in the SYN packet
> > > >    may cause problems that offset the performance benefit of Fast Open.
> > > >    For example, the unusually large SYN may trigger IP fragmentation and
> > > >    may confuse firewalls or middleboxes, causing SYN retransmission and
> > > >    other side effects.  Therefore, the client MAY limit the cached MSS
> > > >    to 1460 bytes for IPv4 or 1440 for IPv6.
> > > >
> > > >
> > > > Relying on ICMP is fragile, since they can be filtered in some way.
> > >
> > > In this case I am not relying on the ICMP, but thought that since I
> > > have it I should make use of it. WIthout the ICMP we would still just
> > > be waiting on the retransmit timer.
> > >
> > > The problem case has a v6-in-v6 tunnel between the client and the
> > > endpoint so both ends assume an MTU 1500 and advertise a 1440 MSS
> > > which works fine until they actually go to send a large packet between
> > > the two. At that point the tunnel is triggering an ICMP_TOOBIG and the
> > > endpoint is stalling since the MSS is dropped to 1400, but the SYN and
> > > data payload were already smaller than that so no retransmits are
> > > being triggered. This results in TFO being 1s slower than non-TFO
> > > because of the failure to trigger the retransmit for the frame that
> > > violated the PMTU. The patch is meant to get the two back into
> > > comparable times.
> >
> > Okay... Have you studied why tcp_v4_mtu_reduced() (and IPv6 equivalent)
> > code does not yet handle the retransmit in TCP_SYN_SENT state ?
>
> The problem lies in tcp_simple_retransmit(). Specifically the loop at
> the start of the function goes to check the retransmit queue to see if
> there are any packets larger than MSS and finds none since we don't
> place the SYN w/ data in there and instead have a separate SYN and
> data packet.
>
> I'm debating if I should take an alternative approach and modify the
> loop at the start of tcp_simple_transmit to add a check for a SYN
> packet, tp->syn_data being set, and then comparing the next frame
> length + MAX_TCP_HEADER_OPTIONS versus mss.
Thanks for bringing up this tricky issue. The root cause seems to be
the special arrangement of storing SYN-data as one-(pure)-SYN and one
non-SYN data segment. Given tcp_simple_transmit probably is not called
frequently, your alternative approach sounds more appealing to me.

Replacing that strange syn|data arrangement for TFO has been on my
wish list for a long time... Ideally it's better to just store the
SYN+data and just carve out the SYN for retransmit.
