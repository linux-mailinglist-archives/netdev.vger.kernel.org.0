Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDA35A04E0
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 01:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiHXXzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 19:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiHXXzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 19:55:38 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7611E1E3D2;
        Wed, 24 Aug 2022 16:55:36 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id ay12so9462757wmb.1;
        Wed, 24 Aug 2022 16:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=dcgF3LnmeUcM1Y7tskFom2uB5o4kgAeWvQCK2CFA1vo=;
        b=czxN68lIxa3XcuYRU2TvtkSKBcZ/HYUFnwfZ/GSWsZsAnFu0g/5jqPUi3OQYDtf9fK
         7VPdUCz076weBuRSr99LNSSHpOz7uF7+HtSX2xi+UxETJpwyqVJyCbIq7bR+aBYLmX+u
         kPtTY8g3o9QnFHHrYiWBo6eSt2MSn7dCaaTUH06x8botIMSPO4yHg0X+YT5zStpTKOBq
         8iEjCgszlKv19Gxrd1kbsPk4Dz8h2oIUD6T3pHj9kHNPkzyakUHoEVH0AZRmESIVXavO
         4ESmNgllwFP35AR2yrsDTalTNb+nnoJF3Lyxi/Y6Lz1J4qJ5mpWywDH0R+bFn4e8klRl
         lgYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=dcgF3LnmeUcM1Y7tskFom2uB5o4kgAeWvQCK2CFA1vo=;
        b=E2+oXoM8XNf0Xwh9D7WswiumfunCrOUNKcWVGr3XaYRHY1wGmpoAP2pL5TifYUTU8r
         g+iEU9rGwKhfy/cVaUAAB1YepyeWVlG1+2NY4en2Sv/G4YA9BtkF/cMdgGwgAViac+Tz
         ctXsUsIoWxvlJCdCvcE7Tk6yFXcLfpWCHPUmG3g1O5RYb2eeUujItyL6JmSjEQQRXWZP
         LZSdLKdMOUge0/P2frUyOgJ1GQrHHCtgbuuYtuAYTxSYKRvZ9hjL0UzlPw8WI1WZ7qk6
         UaiF4scAhqIbLJR+WM5ALSIfn8/Ls/PvT0vl3v5DYW53vmevboug2p6L62A2hNjBPxux
         qg9A==
X-Gm-Message-State: ACgBeo2+RYb5QdRZ8IiYvDtqOCMdqTsBG4PkYt/8Lkedd1M/ZA0SAc5i
        ESbq9ZTD9GA9gqWzZtxcPBVuQliRbLKCMU5HuJk=
X-Google-Smtp-Source: AA6agR78X2b/GPqnCJ+Nf989PNTNgQipJIebu56rJs6O/C5XuSGhkYFWxdX8r3cZSIbaS+bLb8GRkjPHKJNa2oYtTdQ=
X-Received: by 2002:a05:600c:430c:b0:3a6:26e:88e8 with SMTP id
 p12-20020a05600c430c00b003a6026e88e8mr568942wme.48.1661385334869; Wed, 24 Aug
 2022 16:55:34 -0700 (PDT)
MIME-Version: 1.0
References: <117aa7ded81af97c7440a9bfdcdf287de095c44f.camel@sipsolutions.net> <87lerdmd2g.fsf@intel.com>
In-Reply-To: <87lerdmd2g.fsf@intel.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Wed, 24 Aug 2022 16:55:23 -0700
Message-ID: <CAA93jw5BiqemeLrb4oDSrJQCrS1HEia7_y1syEfmqh-Fauah5w@mail.gmail.com>
Subject: Re: taprio vs. wireless/mac80211
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Avi Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 24, 2022 at 4:36 PM Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Hi Johannes,
>
> Johannes Berg <johannes@sipsolutions.net> writes:
>
> > Hi,
> >
> > We're exploring the use of taprio with wireless/mac80211, and in
> > mac80211 today (**) we don't have multiple queues (any more) since all
> > the queuing actually happens in FQ/Codel inside mac80211. We also set
> > IFF_NO_QUEUE, but that of course only really affects the default qdisc,
> > not the fact that you could use it or not.

It would be good if more people understood the packet aggregation
problem deeply,
and lost 8 minutes of their life to this.

https://www.youtube.com/watch?v=3DRb-UnHDw02o&t=3D1745s

Theoretically, in wifi 7, something like single packet taprio-like
scheduling across "DU"s
might become feasible.

> > In mac80211 thus we never back-pressure against the qdiscs, which is wh=
y
> > we basically selected a single queue. Also, there's nothing else we do
> > about the queue other than immediately pull a packet from it if
> > available, so it'd basically pure overhead to have real queues there.
> >
> > In a sense, given that we cannot back-pressure against the queues, it
> > feels a bit wrong to even have multiple queues. We also don't benefit i=
n
> > any way from splitting data structures onto multiple CPUs or something
> > since we put it all into the same FQ/Codel anyway.
> >
> >
> > Now, in order to use taprio, you're more or less assuming that you have
> > multiple (equivalent) queues, as far as I can tell.

802.11e's notion of four hardware queues could possibly be utilized
more effectively.

Or you could program those hw queues differently from the default.

> >
> > Obviously we can trivially expose multiple equivalent queues from
> > mac80211, but it feels somewhat wrong if that's just to make taprio be
> > able to do something?
> >
> > Also how many should we have, there's more code to run so in many cases
> > you probably don't want more than one, but if you want to use taprio yo=
u
> > need at least two, but who says that's good enough, you might want more
> > classes:
> >
> >         /* taprio imposes that traffic classes map 1:n to tx queues */
> >         if (qopt->num_tc > dev->num_tx_queues) {
> >                 NL_SET_ERR_MSG(extack, "Number of traffic classes is
> > greater than number of HW queues");
> >                 return -EINVAL;
> >         }
> >
> >
> > The way taprio is done almost feels like maybe it shouldn't even care
> > about the number of queues since taprio_dequeue_soft() anyway only
> > queries the sub-qdiscs? I mean, it's scheduling traffic, if you over-
> > subscribe and send more than the link can handle, you've already lost
> > anyway, no?
> >
> > (But then Avi pointed out that the sub qdiscs are initialized per HW
> > queue, so this doesn't really hold either ...)
> >
> >
> > Anyone have recommendations what we should do?
>
> I will need to sleep on this, but at first glance, it seems you are
> showing a limitation of taprio.
>
> Removing that limitation seems possible, but it would add a bit of
> complexity (but not much it seems) to the code, let me write down what I
> am thinking:
>
>  0. right now I can trust that there are more queues than traffic
>  classes, and using the netdev prio->tc->queue map, I can do the
>  scheduling almost entirely on queues. I have to remove this assumption.
>
>  1. with that assumption removed, it means that I can have more traffic
>  classes than queues, and so I have to be able to handle multiple
>  traffic classes mapped to a single queue, i.e. one child qdisc per TC
>  vs. one child per queue that we have today. Enqueueing each packet to
>  the right child qdisc is easy. Dequeueing also is also very similar to
>  what taprio does right now.
>
>  2. it would be great if I knew the context in which each ->dequeue() is
>  called, specifically which queue the ->dequeue() is for, it would
>  reduce the number of children that I would have to check.
>
> After writing this, I got the impression that it's feasible. Anyway,
> will think a bit more about it.
>
> (2) I don't think is possible right now, but I think we can go on
> without it, and leave it as a future optimization.
>
> Does it make sense? Did I understand the problem you are having right?
>
>
> Cheers,
> --
> Vinicius



--=20
FQ World Domination pending: https://blog.cerowrt.org/post/state_of_fq_code=
l/
Dave T=C3=A4ht CEO, TekLibre, LLC
