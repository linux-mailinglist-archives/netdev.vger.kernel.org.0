Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E026BD46A
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 23:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387798AbfIXVk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 17:40:58 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35391 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728516AbfIXVk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 17:40:58 -0400
Received: by mail-lj1-f196.google.com with SMTP id m7so3467021lji.2;
        Tue, 24 Sep 2019 14:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XLiq4XMb5jpJuPtXafRR0vUQWEgS1Nd2j0UWbBZvLBQ=;
        b=fxctM/TkIRYaNpPm4/5bKV6Wn4LhKOi+e0tf9ofeZAhiqlT1tWbcZVgFJG9t/04dS0
         U8HTWnksBs88olDZHxqdlsjRIdMvllD78Af1RFmpp9/mpFZD8zbcokoBu8U0a+duScW3
         KTQbZnW1vPBZTkCKXhbW1HmoBoSDxImowfYtxAdNkCBWKdxY9QGxLfN6wcz/iLS9SLGC
         +Ls0W5huwikvM+MQ2dMZffO1f510/E1U4wGzRmJr3po40y4OR0SAUgyId8mNbtm91w2i
         7ccKYMuYhgT1G1Vpu7QBniO8HjHmDyWJsPfd2iCgpQE+P565TQn25XArhlKpf3eKbb1t
         1Ahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XLiq4XMb5jpJuPtXafRR0vUQWEgS1Nd2j0UWbBZvLBQ=;
        b=QLtvat6xCjJUyzIFGE+VSPhn+pnq8PKsniVM1Q7L5aABO+xqTbq4NYnOYJvuu53/Zm
         cEQ2qMp6v9LyeI1FoXbQDmR7vKOmo3DzsDgaz1b6LzsIhT2vuUBD3XxifeIASKvEu/Tc
         vHyIyIEtqUbeAh9fYMjt1eLUdtO3nkQj1gTlU0VrGBN6TxekWawd5nGBadBiuL292j1L
         aJc9teCkdKGiVHxmQyOGz7C/Y8xfxS1MuVieb09ESvT9ImmqEhGtSkLcKyFCHT9H7AaQ
         CM//pM7X7Gq6B233p0lIw+98PddTYBAfkF3Vz8dRnzflQdV3gtZo6AwSVN7JtzAeveOc
         jRQQ==
X-Gm-Message-State: APjAAAV0II/p/CIq8CZLI2SFzk1vp4Zam+yZF0Ft/vdA4FvuZPetopHr
        +M1Orf5RHV8M455otlskCtofFDDTdxiNgkrd0Wg=
X-Google-Smtp-Source: APXvYqwvjObhZebZica4yLKpK98PNVQXKIHyyQIJ7qAdLf4eBIjf6sc5zJjL/1t+2QTDXnWtmkpH8UjQxNslor/jCgc=
X-Received: by 2002:a2e:1409:: with SMTP id u9mr3535129ljd.162.1569361255800;
 Tue, 24 Sep 2019 14:40:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190920194533.5886-1-christophe.jaillet@wanadoo.fr> <388f335a-a9ae-7230-1713-a1ecb682fecf@datenfreihafen.org>
In-Reply-To: <388f335a-a9ae-7230-1713-a1ecb682fecf@datenfreihafen.org>
From:   Xue Liu <liuxuenetmail@gmail.com>
Date:   Tue, 24 Sep 2019 23:40:21 +0200
Message-ID: <CAJuUDwtWJgo7PHJR4kBpQ9mGamTMEaPZBNOZcL3mWFwwZ-zOmw@mail.gmail.com>
Subject: Re: [PATCH] ieee802154: mcr20a: simplify a bit 'mcr20a_handle_rx_read_buf_complete()'
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "alex. aring" <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Sep 2019 at 13:52, Stefan Schmidt <stefan@datenfreihafen.org> wrote:
>
> Hello Xue.
>
> On 20.09.19 21:45, Christophe JAILLET wrote:
> > Use a 'skb_put_data()' variant instead of rewritting it.
> > The __skb_put_data variant is safe here. It is obvious that the skb can
> > not overflow. It has just been allocated a few lines above with the same
> > 'len'.
> >
> > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > ---
> >  drivers/net/ieee802154/mcr20a.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
> > index 17f2300e63ee..8dc04e2590b1 100644
> > --- a/drivers/net/ieee802154/mcr20a.c
> > +++ b/drivers/net/ieee802154/mcr20a.c
> > @@ -800,7 +800,7 @@ mcr20a_handle_rx_read_buf_complete(void *context)
> >       if (!skb)
> >               return;
> >
> > -     memcpy(skb_put(skb, len), lp->rx_buf, len);
> > +     __skb_put_data(skb, lp->rx_buf, len);
> >       ieee802154_rx_irqsafe(lp->hw, skb, lp->rx_lqi[0]);
> >
> >       print_hex_dump_debug("mcr20a rx: ", DUMP_PREFIX_OFFSET, 16, 1,
> >
>
> Could you please review and ACK this? If you are happy I will take it
> through my tree.
>
> regards
> Stefan Schmidt

Acked-by: Xue Liu <liuxuenetmail@gmail.com>

--
