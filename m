Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFB64AC5E
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 22:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731062AbfFRUzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 16:55:43 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40707 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730696AbfFRUzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 16:55:43 -0400
Received: by mail-qk1-f196.google.com with SMTP id c70so9510297qkg.7;
        Tue, 18 Jun 2019 13:55:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z9lpWmnxIWG+yn/Q8Kt9kwRJEp4w7nP1RsHOAevW2cM=;
        b=Lx9Lm9CcnfKktj4As+zPwaFTt0OTeUrHAf77gSVInDvmQltvUYWM3kQAEdI1Lqq7W7
         OQDotAMRlw26NGgIuudnjT+8LbOlXA+ru+sEaiyQLRx0JGfAAShJK59tKGq9VdeJk5x4
         zq8iDS2x85Fb8QdyGBMXYlR7N0lh9EOoc3n+5MSyVWtXs5dGuH6BLRuWQNgpAQIZm/gc
         77FJvxVtldaSQTzY3OPZslDGK0MZx471Sq2tvpUIv/UZ7qyw44E717BDpr0oVBHvP4Q4
         gF2rSqXsx+5383F41tcTRr2t2rwWW1zJH0xkGokB0+iPQyYQ0X2/zOrgxI7U4i6pD8NS
         RiAg==
X-Gm-Message-State: APjAAAXTg+BMEMuYycDGfCEsKcBMNRAJVt352Tls34f7k2xXrGWQp8X7
        5AZNRh79EcBpXvO6BcBSaHTzdqGsGWEzcEppbSM=
X-Google-Smtp-Source: APXvYqzMQnj8mooGUNvWO59G0b2ABKwAdRoB6ahNoB3XWyhRG2+Kc2tlKvSqhoNGKyDN+miPCnbs/N9GlnSM6tCUpFo=
X-Received: by 2002:a37:a4d3:: with SMTP id n202mr8318000qke.84.1560891341993;
 Tue, 18 Jun 2019 13:55:41 -0700 (PDT)
MIME-Version: 1.0
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
 <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
 <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
 <066e9b39f937586f0f922abf801351553ec2ba1d.camel@sipsolutions.net>
 <b3686626-e2d8-bc9c-6dd0-9ebb137715af@linaro.org> <b23a83c18055470c5308fcd1eed018056371fc1d.camel@sipsolutions.net>
 <CAK8P3a1FeUQR3pgoQxHoRK05JGORyR+TFATVQiijLWtFKTv6OQ@mail.gmail.com> <613cdfde488eb23d7207c7ba6258662702d04840.camel@sipsolutions.net>
In-Reply-To: <613cdfde488eb23d7207c7ba6258662702d04840.camel@sipsolutions.net>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 18 Jun 2019 22:55:23 +0200
Message-ID: <CAK8P3a2onXpxiE4y9PzRwuPM2dh=h_BKz7Eb0=LLPgBbZoK1bQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Alex Elder <elder@linaro.org>, abhishek.esse@gmail.com,
        Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        Dan Williams <dcbw@redhat.com>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        syadagir@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 10:36 PM Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Tue, 2019-06-18 at 21:59 +0200, Arnd Bergmann wrote:
> >
> > From my understanding, the ioctl interface would create the lower
> > netdev after talking to the firmware, and then user space would use
> > the rmnet interface to create a matching upper-level device for that.
> > This is an artifact of the strong separation of ipa and rmnet in the
> > code.
>
> Huh. But if rmnet has muxing, and IPA supports that, why would you ever
> need multiple lower netdevs?

From my reading of the code, there is always exactly a 1:1 relationship
between an rmnet netdev an an ipa netdev. rmnet does the encapsulation/
decapsulation of the qmap data and forwards it to the ipa netdev,
which then just passes data through between a hardware queue and
its netdevice.

[side note: on top of that, rmnet also does "aggregation", which may
 be a confusing term that only means transferring multiple frames
 at once]

> > ipa definitely has multiple hardware queues, and the Alex'
> > driver does implement  the data path on those, just not the
> > configuration to enable them.
>
> OK, but perhaps you don't actually have enough to use one for each
> session?

I'm lacking the terminology here, but what I understood was that
the netdev and queue again map to a session.

> > Guessing once more, I suspect the the XON/XOFF flow control
> > was a workaround for the fact that rmnet and ipa have separate
> > queues. The hardware channel on IPA may fill up, but user space
> > talks to rmnet and still add more frames to it because it doesn't
> > know IPA is busy.
> >
> > Another possible explanation would be that this is actually
> > forwarding state from the base station to tell the driver to
> > stop sending data over the air.
>
> Yeah, but if you actually have a hardware queue per upper netdev then
> you don't really need this - you just stop the netdev queue when the
> hardware queue is full, and you have flow control automatically.
>
> So I really don't see any reason to have these messages going back and
> forth unless you plan to have multiple sessions muxed on a single
> hardware queue.

Sure, I definitely understand what you mean, and I agree that would
be the right way to do it. All I said is that this is not how it was done
in rmnet (this was again my main concern about the rmnet design
after I learned it was required for ipa) ;-)

     Arnd
