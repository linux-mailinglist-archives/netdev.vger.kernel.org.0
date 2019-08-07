Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE9F085333
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 20:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389386AbfHGSrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 14:47:03 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:44021 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389382AbfHGSrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 14:47:03 -0400
Received: by mail-yb1-f195.google.com with SMTP id o82so927599ybg.10
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 11:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TSvcbL9MFdLemA/L6TxyFcB+835LxwVopQXYfElxn3o=;
        b=OmrSaCEy/hJ1AroKw3rROhKVEktF82iuT5ktrrH20LoZHKQx2zYKJf1q6aIvcWZcBp
         VHyZIGHfbMgpyldo9DIPtR8+Nco6nKGcJmNFIvYIV9oy6M7kao0UwBBqOrl5jrLVSSl4
         S+cnHFWBttSw4aoyZtpXBbLJ5WllYKu3tm2I5zAe0dn6Rhm/IlHZ2QqMUXAmvDR0L1H2
         NxPtmAk+GRIk40bNU0suljtcrm8ZAGTAczxQziaGe5gMOMGknYehB8+mBpGGv7eulHEl
         TUYOquOGljtDXnC+SfLm0FEHWNOY35bMT7IY3bBHaHUE3d6qS4VRu0vZzKu+DJD/D8Xg
         aA4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TSvcbL9MFdLemA/L6TxyFcB+835LxwVopQXYfElxn3o=;
        b=EZkr2F+FLC6A1KL557XbjmgP8TYL2/K8Mtmp8AWiUDEIhnrQFUBjWyeuGRrfi3Kcq0
         0HmyJYE13uRtqPBK+2iDFFppTPhhnBukHdX1Ky8Yzl7FQZhtu/Z0DPtos/r9XoL7yDjn
         o1iXGWcqGtcEHoAGJl8fjN60s9FuD5en14B65AkMHEwZfvrulaLyMJcpKNMU+F+RagmW
         dvKTRuThCEEgBwUF4ANALHtib+9xRF67aZIjG3ElNZPT6P/HIvqN5fouOf3Du2vDVYOw
         KyO8EM58VDCPte2zPngliqWmJsyAE7pABJtkh1sLgmujlIFDN4Kr/Tgyeb15jfvkcRrY
         CIBA==
X-Gm-Message-State: APjAAAWdugJpa1IrXHNMHFcf/v0QaY+eVnKkREFn9dkKw71S+jRY5lSq
        FGNRptCqS9Y5ntnU3cnHLAjO/BWt
X-Google-Smtp-Source: APXvYqzDcefUiA4/l6fs/Kbg5rzpNJl/HLf3eR3HQjq/KUwNjQ2Z8I3UDW22elmjyQRAHekBfCVoMA==
X-Received: by 2002:a5b:405:: with SMTP id m5mr6917880ybp.200.1565203621297;
        Wed, 07 Aug 2019 11:47:01 -0700 (PDT)
Received: from mail-yw1-f42.google.com (mail-yw1-f42.google.com. [209.85.161.42])
        by smtp.gmail.com with ESMTPSA id v12sm20596654ywv.15.2019.08.07.11.47.00
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 11:47:00 -0700 (PDT)
Received: by mail-yw1-f42.google.com with SMTP id i138so32830206ywg.8
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 11:47:00 -0700 (PDT)
X-Received: by 2002:a81:3945:: with SMTP id g66mr3633122ywa.368.1565203619612;
 Wed, 07 Aug 2019 11:46:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190807060612.19397-1-jakub.kicinski@netronome.com>
 <CA+FuTScYkHho4hqrGf9q6=4iao-f2P2s258rjtQTCgn+nF-CYg@mail.gmail.com> <20190807110042.690cf50a@cakuba.netronome.com>
In-Reply-To: <20190807110042.690cf50a@cakuba.netronome.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 7 Aug 2019 14:46:23 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeR1QqAZVTLQ-mJ8iHi+h+ghbrGyT6TWATTecQSbQP6sA@mail.gmail.com>
Message-ID: <CA+FuTSeR1QqAZVTLQ-mJ8iHi+h+ghbrGyT6TWATTecQSbQP6sA@mail.gmail.com>
Subject: Re: [PATCH net v2] net/tls: prevent skb_orphan() from leaking TLS
 plain text with offload
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 7, 2019 at 2:01 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Wed, 7 Aug 2019 12:59:00 -0400, Willem de Bruijn wrote:
> > On Wed, Aug 7, 2019 at 2:06 AM Jakub Kicinski wrote:
> > > diff --git a/net/core/sock.c b/net/core/sock.c
> > > index d57b0cc995a0..0f9619b0892f 100644
> > > --- a/net/core/sock.c
> > > +++ b/net/core/sock.c
> > > @@ -1992,6 +1992,20 @@ void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
> > >  }
> > >  EXPORT_SYMBOL(skb_set_owner_w);
> > >
> > > +static bool can_skb_orphan_partial(const struct sk_buff *skb)
> > > +{
> > > +#ifdef CONFIG_TLS_DEVICE
> > > +       /* Drivers depend on in-order delivery for crypto offload,
> > > +        * partial orphan breaks out-of-order-OK logic.
> > > +        */
> > > +       if (skb->decrypted)
> > > +               return false;
> > > +#endif
> > > +       return (IS_ENABLED(CONFIG_INET) &&
> > > +               skb->destructor == tcp_wfree) ||
> >
> > Please add parentheses around IS_ENABLED(CONFIG_INET) &&
> > skb->destructor == tcp_wfree
>
> Mm.. there are parenthesis around them, maybe I'm being slow,
> could you show me how?

I mean

    return (skb->destructor == sock_wfree ||
               (IS_ENABLED(CONFIG_INET) && skb->destructor == tcp_wfree))

In other words, (a || (b && c)) instead of (a || b && c). Though the
existing code also eschews the extra parentheses.

> > I was also surprised that this works when tcp_wfree is not defined if
> > !CONFIG_INET. But apparently it does (at -O2?) :)
>
> I was surprised to but in essence it should work the same as
>
>         if (IS_ENABLED(CONFIG_xyz))
>                 call_some_xyz_code();
>
> from compiler's perspective, and we do that a lot. Perhaps kbuild
> bot will prove us wrong :)
>
> > > @@ -984,6 +984,9 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
> > >                         if (!skb)
> > >                                 goto wait_for_memory;
> > >
> > > +#ifdef CONFIG_TLS_DEVICE
> > > +                       skb->decrypted = !!(flags & MSG_SENDPAGE_DECRYPTED);
> > > +#endif
> >
> > Nothing is stopping userspace from passing this new flag. In send
> > (tcp_sendmsg_locked) it is ignored. But can it reach do_tcp_sendpages
> > through tcp_bpf_sendmsg?
>
> Ah, I think you're right, thanks for checking that :( I don't entirely
> follow how 0608c69c9a80 ("bpf: sk_msg, sock{map|hash} redirect through
> ULP") is safe then.
>
> One option would be to clear the flags kernel would previously ignore
> in tcp_bpf_sendmsg(). But I feel like we should just go back to marking
> the socket, since we don't need the per-message flexibility of a flag.
>
> WDYT?

I don't feel strongly either way. Passing flags from send through
tcp_bpf_sendmsg is probably unintentional, so should probably be
addressed anyway? Then this is a bit simpler.

> > >                         skb_entail(sk, skb);
> > >                         copy = size_goal;
> > >                 }
> > > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > > index 6e4afc48d7bb..979520e46e33 100644
> > > --- a/net/ipv4/tcp_output.c
> > > +++ b/net/ipv4/tcp_output.c
> > > @@ -1320,6 +1320,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
> > >         buff = sk_stream_alloc_skb(sk, nsize, gfp, true);
> > >         if (!buff)
> > >                 return -ENOMEM; /* We'll just try again later. */
> > > +       skb_copy_decrypted(buff, skb);
> >
> > This code has to copy timestamps, tx_flags, zerocopy state and now
> > this in three locations. Eventually we'll want a single helper for all
> > of them..
>
> Ack, should I take an action on that for net-next or was it a
> note-to-self? :)

Note-to-self :)

As a matter of fact, your patch showed me that we actually miss the
tstamp case in tcp_mtu_probe..
