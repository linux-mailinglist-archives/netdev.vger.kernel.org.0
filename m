Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 476F7F6E98
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 07:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfKKGix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 01:38:53 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:46766 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbfKKGix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 01:38:53 -0500
Received: by mail-vs1-f67.google.com with SMTP id m6so8007683vsn.13
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 22:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p46hzvIcUjsAWpCCt2YN6Zzu/jAmNkdJVCvhuCVu7+8=;
        b=KULiXQBtodG2aavD8IkPh1eeB2oDKEPzMuHtVNVYsV0wpcv2OzBZgrrfMb7UwUAOZx
         2SHWFxHCuQ16ayudrPRpigEwCqvZoL4JQBVitW2SL382xu5ZcnAO8cUPcwTOoX4W2csC
         ZN0deRbr3cTzlTyVnwt8aPEU0uyyUdAami6o+ya827Ylkbuv558D9yZviiAYCylFgk/W
         R8aEJ502jHQ4euN2q8Adi9PrXUMSu9m+GwtKMc7C8liUD5HVJbeZCBrS7o+l6KuJg1B5
         PJh9vaerrRLhtbvmT+FFLkRi3PfJOjPGIyFqCmjm5dg+m2ND9wRQd2KIyWX1KpEDml3R
         F6hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p46hzvIcUjsAWpCCt2YN6Zzu/jAmNkdJVCvhuCVu7+8=;
        b=LnAwSu8e+aKXo/WfImOf/kxH59YrSyrVrQ/xsilJVLL8fLV+nVgw2j0qqdPuW4u/gw
         cKWfFAfxL8ReylJfvZ0bH6kya63j4eD/7wpGkTBq0z8IbEiQ4sA6frbcE3SFqAJ9kXO1
         DX4BnB4+kxP76y2TulNWe+/Rw9cF4ue7WLT3d1h5s1ntwbyOa0OaQMtKi0xMEBVxErrj
         igKpLyMYRRkirUmFra/jGvrSuEPDXrRH9hzTaePuz82EXJoC8BVB0i8g/IY8csUQdELI
         fQXiM3IEkDDqlA26sS1ixfpcke1C/I9VXmDV+1CUjk/BYpj44ejNzX4Bvx9OMoKeQNv3
         pFtw==
X-Gm-Message-State: APjAAAXqwGRMOWpZrk2PIxYcDnxbG7Iwq9ZXaqdwEhFTJD2q6HolUMBM
        A3HHdqZojdPQuyf7YXohI1zddXBsj4tJNWV4D8U=
X-Google-Smtp-Source: APXvYqw1nv034QnEk9C4LV07jujJWb7P561C2h7TYJIlYKS/q1Wvx8te8mBnwcKWexcZHsS6PtP1X+K84wAGhYfUUR4=
X-Received: by 2002:a67:f44b:: with SMTP id r11mr3122525vsn.23.1573454332039;
 Sun, 10 Nov 2019 22:38:52 -0800 (PST)
MIME-Version: 1.0
References: <20191108082059.22515-1-stid.smth@gmail.com> <20191111061722.GO13225@gauss3.secunet.de>
In-Reply-To: <20191111061722.GO13225@gauss3.secunet.de>
From:   Xiaodong Xu <stid.smth@gmail.com>
Date:   Sun, 10 Nov 2019 22:38:41 -0800
Message-ID: <CANEcBPQ5de-qpYRbYxoMKfwyvm3T=Ddfpn_z03bd40JaO9cDjA@mail.gmail.com>
Subject: Re: [PATCH] xfrm: release device reference for invalid state
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        chenborfc@163.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for reviewing the patch, Steffen. Please check my replies below.

On Sun, Nov 10, 2019 at 10:17 PM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> Please make sure to always Cc netdev@vger.kernel.org on networking
> patches.
>
> Aso, what is the difference between this patch and the one you sent
> before? Please add version numbers to your patches and describe the
> changes between the versions.
>
The main difference in the new version is that 'family' will not be
assigned (in which case x->outer_mode needs to be accessed, and I'm
not sure if x->outer_mode is still accessible when the state is
invalid) in an invalid state.
I'll update the version to my patch.

> On Fri, Nov 08, 2019 at 12:20:59AM -0800, Xiaodong Xu wrote:
> > An ESP packet could be decrypted in async mode if the input handler for
> > this packet returns -EINPROGRESS in xfrm_input(). At this moment the device
> > reference in skb is held. Later xfrm_input() will be invoked again to
> > resume the processing.
> > If the transform state is still valid it would continue to release the
> > device reference and there won't be a problem; however if the transform
> > state is not valid when async resumption happens, the packet will be
> > dropped while the device reference is still being held.
> > When the device is deleted for some reason and the reference to this
> > device is not properly released, the kernel will keep logging like:
> >
> > unregister_netdevice: waiting for ppp2 to become free. Usage count = 1
> >
> > The issue is observed when running IPsec traffic over a PPPoE device based
> > on a bridge interface. By terminating the PPPoE connection on the server
> > end for multiple times, the PPPoE device on the client side will eventually
> > get stuck on the above warning message.
> >
> > This patch will check the async mode first and continue to release device
> > reference in async resumption, before it is dropped due to invalid state.
> >
> > Fixes: 4ce3dbe397d7b ("xfrm: Fix xfrm_input() to verify state is valid when (encap_type < 0)")
> > Signed-off-by: Xiaodong Xu <stid.smth@gmail.com>
> > Reported-by: Bo Chen <chenborfc@163.com>
> > Tested-by: Bo Chen <chenborfc@163.com>
> > ---
> >  net/xfrm/xfrm_input.c | 30 +++++++++++++++++++++---------
> >  1 file changed, 21 insertions(+), 9 deletions(-)
> >
> > diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
> > index 9b599ed66d97..80c5af7cfec7 100644
> > --- a/net/xfrm/xfrm_input.c
> > +++ b/net/xfrm/xfrm_input.c
> > @@ -474,6 +474,13 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
> >       if (encap_type < 0) {
> >               x = xfrm_input_state(skb);
> >
> > +             /* An encap_type of -1 indicates async resumption. */
> > +             if (encap_type == -1) {
> > +                     async = 1;
> > +                     seq = XFRM_SKB_CB(skb)->seq.input.low;
> > +                     goto resume;
> > +             }
> > +
> >               if (unlikely(x->km.state != XFRM_STATE_VALID)) {
> >                       if (x->km.state == XFRM_STATE_ACQ)
> >                               XFRM_INC_STATS(net, LINUX_MIB_XFRMACQUIREERROR);
>
> Why not just dropping the reference here if the state became invalid
> after async resumption?
>
I was thinking about releasing the device reference immediately after
checking the state in the async resumption too. However it seems more
natural to me to simply jump to the 'resume' label in the async case.
Suppose there are more resources to be held before the async
resumption, we don't have to worry about that before dropping the
packet.
But if you prefer the other way I am OK with that too.

Regards,
Xiaodong
