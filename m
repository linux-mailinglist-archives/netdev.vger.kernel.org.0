Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2481E48E1A0
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 01:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238470AbiANAj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 19:39:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238465AbiANAj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 19:39:28 -0500
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D938C061574;
        Thu, 13 Jan 2022 16:39:28 -0800 (PST)
Received: by mail-ua1-x92f.google.com with SMTP id o1so14379417uap.4;
        Thu, 13 Jan 2022 16:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PHv6MSkP5VskTG0PwGalY8E+uOtxTwKQMcg1y1zQnE0=;
        b=M2N5fcqvm76kd7Fft1L81xesiEdFNqwW8FeXDz4tBKIipT4zL3mu48fcMa1Ab51PUy
         uNjYjWsNSEy6ZjG21AesRI7wxsIBghx0AOQecChQ/3EjjIHqVJEtKsVfCR5a9gm3HFI1
         dtQfr2EFERS2LKiGuQO+3C0a1HHKDBCCZ1p9nmA2JGJD92ZWZvSyBzktIA2mbRDUQTwG
         sft7tDWQHFFOb7NRGAiXnuIHHX4FCxQSOQWfFrSmr23dk9mmO9Euis5dP11XBxMWhOBl
         nFYR/IZLFa2O5PvvNMUWzE6XDMl/QDCbg+ZCq+hhvTg4OBUadwmHLHvkkCOGfJvSrR92
         Y2WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PHv6MSkP5VskTG0PwGalY8E+uOtxTwKQMcg1y1zQnE0=;
        b=l1GEmJyyWh1H50j3r7nVDN03deuXhlICLYFGdPi8RZXgsCpGMJgPhMKSMWKb3p0S3W
         Fe2GraCWtyK3IjpWVUB/lztXfLA3XBv7A49wlB4QnXw1sQLwHS3iFOvOS/t+6Q233X/B
         1PGL9pnuk9bSgMdY5/0rkg1jUI6o2uri70OGeDPYbpUJ7eOkkfizzn9Lv3xzFhiqstmg
         NYOzwP3Lx4lr1Ysgu/q3lX7yHYOtJbApN1n2clsRclaPkJKbk76YRaA2+HM9vkX5gqt0
         2tebljYEPDWvYQbAlDMPGzI+T6j7tYftGlDUuyzpKxOaB2ChvcLXNVpeSkZpQULLOzgL
         l+bg==
X-Gm-Message-State: AOAM530TW/JRoZkHM2/htMpxO0cINVH7muIjEuH8RyZxvPPRTPuCfibJ
        aiRhMDIyXK+PbgSLRb2yXWgjP6U48hy4q2Fn0LY=
X-Google-Smtp-Source: ABdhPJw9MLKLE5AGZ4zoqK+AOBs9pO+nw/NluwoF/M5a5v0Ejr487SRn+E3Vzp11i0r1SM0gX+kWCMFrV2ieEEGEZdY=
X-Received: by 2002:a05:6130:411:: with SMTP id ba17mr3994486uab.70.1642120767669;
 Thu, 13 Jan 2022 16:39:27 -0800 (PST)
MIME-Version: 1.0
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
 <20220112173312.764660-24-miquel.raynal@bootlin.com> <CAB_54W6bJ5oV1pTX03-xWaFohdyxrjy2WSa2kxp3rBzLqSo=UA@mail.gmail.com>
 <20220113181451.6aa5e60a@xps13> <CAB_54W7GzyQr05X3TUcPbAFPsvetAjX=vd3G9y9wQi+8msYGHQ@mail.gmail.com>
In-Reply-To: <CAB_54W7GzyQr05X3TUcPbAFPsvetAjX=vd3G9y9wQi+8msYGHQ@mail.gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Thu, 13 Jan 2022 19:39:16 -0500
Message-ID: <CAB_54W4OGFabfXoTWU-3D_F3fSRNQn-bzthXoBDJ-ZBWUfos0Q@mail.gmail.com>
Subject: Re: [wpan-next v2 23/27] net: mac802154: Add support for active scans
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 13 Jan 2022 at 19:30, Alexander Aring <alex.aring@gmail.com> wrote:
>
> Hi,
>
> On Thu, 13 Jan 2022 at 12:14, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alexander,
> >
> > alex.aring@gmail.com wrote on Wed, 12 Jan 2022 18:16:11 -0500:
> >
> > > Hi,
> > >
> > > On Wed, 12 Jan 2022 at 12:34, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > ...
> > > > +static int mac802154_scan_send_beacon_req_locked(struct ieee802154_local *local)
> > > > +{
> > > > +       struct sk_buff *skb;
> > > > +       int ret;
> > > > +
> > > > +       lockdep_assert_held(&local->scan_lock);
> > > > +
> > > > +       skb = alloc_skb(IEEE802154_BEACON_REQ_SKB_SZ, GFP_KERNEL);
> > > > +       if (!skb)
> > > > +               return -ENOBUFS;
> > > > +
> > > > +       ret = ieee802154_beacon_req_push(skb, &local->beacon_req);
> > > > +       if (ret) {
> > > > +               kfree_skb(skb);
> > > > +               return ret;
> > > > +       }
> > > > +
> > > > +       return drv_xmit_async(local, skb);
> > >
> > > I think you need to implement a sync transmit handling here.
> >
> > True.
> >
> > > And what
> > > I mean is not using dryv_xmit_sync() (It is a long story and should
> > > not be used, it's just that the driver is allowed to call bus api
> > > functions which can sleep).
> >
> > Understood.
> >
>
> I think we should care about drivers which use drv_xmit_sync() or we
> disable scan operations for them... so the actual transmit function
> should prefer async but use sync if it's not implemented. I am not a
> fan of this inside the core, if some driver really want to workaround
> their bus system because it's simpler to use or whatever they should
> do that inside the driver and not let the core queue it for them in
> the right context. There are reasons why xmit_do is in softirq
> context.
>
> > > We don't have such a function yet (but I
> > > think it can be implemented), you should wait until the transmission
> > > is done. If we don't wait we fill framebuffers on the hardware while
> > > the hardware is transmitting the framebuffer which is... bad.
> >
> > Do you already have something in mind?
> >
> > If I focus on the scan operation, it could be that we consider the
> > queue empty, then we put this transfer, wait for completion and
> > continue. But this only work for places where we know we have full
> > control over what is transmitted (eg. during a scan) and not for all
> > transfers. Would this fit your idea?
> >
> > Or do you want something more generic with some kind of an
> > internal queue where we have the knowledge of what has been queued and
> > a token to link with every xmit_done call that is made?
> >
> > I'm open to suggestions.
> >
>
> That we currently allow only one skb at one time (because ?all?
> supported hardware doesn't have multiple tx framebuffers) this makes
> everything for now pretty simple.
>
> Don't let the queue run empty, the queue here is controlled by the
> qdsic (I suppose and I hope we are talking about the same queue) we
> already stop the queue which stops further skb to transmit to the
> hardware but there can be one ongoing which we need to wait for. I
> said in a previous mail a wait_for_completion()/complete() works here,
> but I think now that could be problematic because scan-op ->
> wait_for_completion() and complete() can run parallel in different
> contexts. I think we need to do that over a waitqueue and a
> wait_event(). Maybe you can track somehow with an atomic counter how
> many transmissions are currently ongoing (should be never higher than
> one currently). However the atomic counter will be future proofed when
> we support filling up more than one framebuffer. So the condition for
> wait_event() would be atomic_test(phy->ongoing_txs) - or something
> like that. Increment in transmit path and decrement in xmit_done path,
> if it hits zero wake_up() the queue so the condition will be checked
> again.
>

I am sorry, the wait_event() will fix the issue after calling
stop_queue() to be sure there are no ongoing transmissions. Now we
need to have some idea about how to implement the synchronous transmit
function. We have the function (drv_xmit_async, or something higher
level to take care of sync as well) to transmit a skb and the complete
handler is xmit_complete(). As I mentioned we allow only one skb for
one time... Somehow we need to have a wait here and a per phy
wait_for_completion()/complete() will in this case work. Even if there
is hardware outside which has more transmit buffers, we probably would
send one skb at one for slowpath (having full control of
transmissions) anyway.

- Alex
