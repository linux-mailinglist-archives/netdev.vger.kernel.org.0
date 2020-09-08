Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05C12611B0
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 14:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbgIHLiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 07:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729726AbgIHL1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 07:27:24 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E88BC061573;
        Tue,  8 Sep 2020 04:27:24 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id w186so9817453pgb.8;
        Tue, 08 Sep 2020 04:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cNJiQKqHXl3ggB9gGPvJiEIlNs0EsVy+KN+3KvCkwEU=;
        b=BUXYT5RHI+HUP8HnCHtAN6P1ciD15/HRohJqCiUqRSdYTr0DygENXAcOXXNpeEAojD
         qlxYEdApMKcWYf2tKEnIFrjpqUIFTJQTAep6mNJFid2UZHLNDRFBboUt55zwL26Y3JQB
         HRt17SPwFnvP6w22HD0+E11txvpDngX4Pxdk3izcZrzZ3qrH06tjVbNayKIwVZkQmEGC
         E05HffwerN44agqMkRtUBYtDADLHBQJiReLYOWAamztj/PFBmSYHfRceB7iR7wRqzn2W
         6zTW2H2n8t/aAL/uJ4pygNySoJW8xFn1FYkJqRx3vrFLiLl5dZcNLGsJTyy71TEoZBoR
         xBig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cNJiQKqHXl3ggB9gGPvJiEIlNs0EsVy+KN+3KvCkwEU=;
        b=EdbjEtmWlg2RIt8j5gckemDJ4cVnkuN4KkQ+QdUwXTQVsfybooQgvBj6JGnsRuXUv2
         0Y9ydnTE5uNPExKR88zmY3YePwVmZYQgrIjO2+IWcVKaDVRu8JJIvhix6WsjUY04po92
         QU34fj/ROyfySbYMYxjQADqpu6nnw+5MY2qh28EydukVPPuoDexj2C0Rh8wPvqlr9zOt
         lEp+ZZ/TUJaRigkOPMhvF078bunYYKqr5/xw0xzGYKlB7kajMQVpJOSGtXLzscLzuyR8
         AgAjdBEj6X44T3aYiT91iz4PaWPbYAAnJTguy752eZ6qwQ2IRX7Zg4GFZU6TQxJOKAE/
         2nHA==
X-Gm-Message-State: AOAM530NcuiXGO5HUk1tOdLpZd5B1gKiLikRhh4gS0gbi4mu2/Opqf3r
        RZMjVEwuVtzokAGi/IVHginJNetHj8Pj0lrKqRw=
X-Google-Smtp-Source: ABdhPJzzc1klIcCXlVU0nr/4aY+iDqUFyN7Lkl/liw19bGK80Iep5eMlAXkUmFpxvJvldQTQkpu9g/NssTR+16PUCMw=
X-Received: by 2002:a62:cfc5:0:b029:13e:d13d:a083 with SMTP id
 b188-20020a62cfc50000b029013ed13da083mr695254pfg.26.1599564443620; Tue, 08
 Sep 2020 04:27:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200906031827.16819-1-xie.he.0141@gmail.com> <CA+FuTSfOeMB7Wv1t12VCTOqPYcTLq2WKdG4AJUO=gxotVRZiQw@mail.gmail.com>
 <CAJht_EO13aYPXBV7sEgOTuUhuHFTFFfdg7NBN2cEKAo6LK0DMQ@mail.gmail.com> <CA+FuTSdK6qgKwgie5Bqof8V5FR__dx-HgHUcDS5sgTQmH9B9uQ@mail.gmail.com>
In-Reply-To: <CA+FuTSdK6qgKwgie5Bqof8V5FR__dx-HgHUcDS5sgTQmH9B9uQ@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 8 Sep 2020 04:27:12 -0700
Message-ID: <CAJht_ENHmL322bS4BnarXLW+GjOC4ioQ8MMtnsqwOhF_gee5Yw@mail.gmail.com>
Subject: Re: [PATCH net] net/packet: Fix a comment about hard_header_len and
 headroom allocation
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Ogness <john.ogness@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Or Cohen <orcohen@paloaltonetworks.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 1:56 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> > > >  /*
> > > >     Assumptions:
> > > > -   - if device has no dev->hard_header routine, it adds and removes ll header
> > > > -     inside itself. In this case ll header is invisible outside of device,
> > > > -     but higher levels still should reserve dev->hard_header_len.
> > > > -     Some devices are enough clever to reallocate skb, when header
> > > > -     will not fit to reserved space (tunnel), another ones are silly
> > > > -     (PPP).
> > > > +   - If the device has no dev->header_ops, there is no LL header visible
> > > > +     outside of the device. In this case, its hard_header_len should be 0.
> > >
> > > Such a constraint is more robustly captured with a compile time
> > > BUILD_BUG_ON check. Please do add a comment that summarizes why the
> > > invariant holds.
> >
> > I'm not sure how to do this. I guess both header_ops and
> > hard_header_len are assigned at runtime. (Right?) I guess we are not
> > able to check this at compile-time.
>
> header_ops should be compile constant, and most devices use
> struct initializers for hard_header_len, but of course you're right.
>
> Perhaps a WARN_ON_ONCE, then.

OK. Thank you for your suggestion! Actually I was not aware of these
macros. So thank you for introducing them to me! I'll surely add this
warning.

> > > More about the older comment, but if reusing: it's not entirely clear
> > > to me what "outside of the device" means. The upper layers that
> > > receive data from the device and send data to it, including
> > > packet_snd, I suppose? Not the lower layers, clearly. Maybe that can
> > > be more specific.
> >
> > Yes, right. If a header is visible "outside of the device", it means
> > the header is exposed to upper layers via "header_ops". If a header is
> > not visible "outside of the device" and is only used "internally", it
> > means the header is not exposed to upper layers via "header_ops".
> > Maybe we can change it to "outside of the device driver"? We can
> > borrow the idea of encapsulation in object-oriented programming - some
> > things that happen inside a software component should not be visible
> > outside of that software component.
>
> How about "above"? If sketched as a network stack diagram, the code
> paths and devices below the (possibly tunnel) device do see packets
> with link layer header.

OK. I understand what you mean now. We need to make it clear that the
header is only invisible to upper layers but not to "lower layers"
that the device may rely on.

I'm thinking about a way to clearly phrase this. "Above the device"
might be confusing to people. Do you think this is good: "invisible to
upper-layer code including the code in af_packet.c"? Or simply
"invisible to upper-layer code"? Or just "invisible to upper layers"?
(I don't like the last one because I feel according to the network
stack diagram "upper layers" should already and always not care about
the LL header.)
