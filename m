Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24ABB9F491
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 22:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730450AbfH0UyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 16:54:01 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:39864 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfH0UyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 16:54:01 -0400
Received: by mail-yw1-f67.google.com with SMTP id n11so44512ywn.6
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 13:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/jkk8uiXMCVp/OI+9yr+k1frQla42xhDW/B5r3l7RBo=;
        b=qJ5euXHujqlonC4GKXQP+dJkfdeqIWFibdyaUK9qOb+GJY3XMOug8KOX0mRADdhTOH
         nAMxXdLrI7GtdTzhVwgs4C0y4u2tSF6RTlD45Lq1OrjzJmI7wGqiw+WaL5SPMdPPfsWm
         XWdATswmqRLR5s+RSwpCPLdr79beoesiEDKkedxZ9ef7NCq6zgvW35UvV0jeEKMY1CFs
         2tb0HHq4JT7VzENB/X6VmxFykmI6VtxAxX8jzIRAiVSjaY61Mcm6vo2hIPzoKiWT3wDZ
         kame08e7Z/g5/7YlTVHfAxztPVqVOOs2KYenzGfY4YX0VhIY6vrhjmBt/SuoyPoeiGMY
         9NAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/jkk8uiXMCVp/OI+9yr+k1frQla42xhDW/B5r3l7RBo=;
        b=VtHA+E5OVsNXvw6hF+35/JWG2sv0+gvRZY/PSdeCf3XsdgUIi7wOJbPxMW4VIQq6wY
         8qO4FDAi/M3ocF0Z8xFkDuiQWWRU4908L1ciCtBVENoU7XXjqbEslsdpX6LrVOUOqFFt
         XjFaNOtRff2c5ORhYUmFA4Uz8MqRxOhz8aD1sA7rf0OXFxnERHsfF3FstxUcvL0zlmih
         jPoqQI/WYFzYHwd5h3kSOZS3W57QxDS9pml5jVh/0ufL215ayRhNfH4CYWjbueusLk0g
         F2ui/epgfEZk4i+IknapZJWK4R3gzARpULjRNvkO6zLaQvVbQXZuDf7AgCYQWu5Adq+E
         rfrA==
X-Gm-Message-State: APjAAAWsly+iPwlhMgb2A31cWAg7yE447bK0vHn9sB3O9eurwKQcuN2H
        XxiQd0RkUuOoBelznAv2ooLqRsAc
X-Google-Smtp-Source: APXvYqxglSV9yCs+mWPXxDiaV6hmnQNu+CceOaq+w3x0dpTMG14CDuu4hnZTrzcU7kxfxAlhnHzYEA==
X-Received: by 2002:a81:5644:: with SMTP id k65mr625676ywb.278.1566939239774;
        Tue, 27 Aug 2019 13:53:59 -0700 (PDT)
Received: from mail-yw1-f43.google.com (mail-yw1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id d9sm148722ywd.55.2019.08.27.13.53.58
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Aug 2019 13:53:59 -0700 (PDT)
Received: by mail-yw1-f43.google.com with SMTP id n11so44482ywn.6
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 13:53:58 -0700 (PDT)
X-Received: by 2002:a0d:c945:: with SMTP id l66mr615227ywd.291.1566939238383;
 Tue, 27 Aug 2019 13:53:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190827190933.227725-1-willemdebruijn.kernel@gmail.com> <CANn89iKwaar9fmgfoDTKebfRGHjR2K3gLeeJCr-bvturzgj3zQ@mail.gmail.com>
In-Reply-To: <CANn89iKwaar9fmgfoDTKebfRGHjR2K3gLeeJCr-bvturzgj3zQ@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 27 Aug 2019 16:53:22 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfK=xSMJvVNJB7DKdqwG_FAi2gLjbCvkXVqF99n71rRdg@mail.gmail.com>
Message-ID: <CA+FuTSfK=xSMJvVNJB7DKdqwG_FAi2gLjbCvkXVqF99n71rRdg@mail.gmail.com>
Subject: Re: [PATCH net] tcp: inherit timestamp on mtu probe
To:     Eric Dumazet <edumazet@google.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 4:07 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Aug 27, 2019 at 9:09 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > From: Willem de Bruijn <willemb@google.com>
> >
> > TCP associates tx timestamp requests with a byte in the bytestream.
> > If merging skbs in tcp_mtu_probe, migrate the tstamp request.
> >
> > Similar to MSG_EOR, do not allow moving a timestamp from any segment
> > in the probe but the last. This to avoid merging multiple timestamps.
> >
> > Tested with the packetdrill script at
> > https://github.com/wdebruij/packetdrill/commits/mtu_probe-1
> >
> > Link: http://patchwork.ozlabs.org/patch/1143278/#2232897
> > Fixes: 4ed2d765dfac ("net-timestamp: TCP timestamping")
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > ---
> >  net/ipv4/tcp_output.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > index 5c46bc4c7e8d..42abc9bd687a 100644
> > --- a/net/ipv4/tcp_output.c
> > +++ b/net/ipv4/tcp_output.c
> > @@ -2053,7 +2053,7 @@ static bool tcp_can_coalesce_send_queue_head(struct sock *sk, int len)
> >                 if (len <= skb->len)
> >                         break;
> >
> > -               if (unlikely(TCP_SKB_CB(skb)->eor))
> > +               if (unlikely(TCP_SKB_CB(skb)->eor) || tcp_has_tx_tstamp(skb))
> >                         return false;
> >
> >                 len -= skb->len;
> > @@ -2170,6 +2170,7 @@ static int tcp_mtu_probe(struct sock *sk)
> >                          * we need to propagate it to the new skb.
> >                          */
> >                         TCP_SKB_CB(nskb)->eor = TCP_SKB_CB(skb)->eor;
> > +                       tcp_skb_collapse_tstamp(nskb, skb);
>
> nit: maybe rename tcp_skb_collapse_tstamp() to tcp_skb_tstamp_copy()
> or something ?
>
> Its name came from the fact that it was only used from
> tcp_collapse_retrans(), but it will no
> longer be the case after your fix.

Sure, that's more descriptive.

One caveat, the function is exposed in a header, so it's a
bit more churn. If you don't mind that, I'll send the v2.
