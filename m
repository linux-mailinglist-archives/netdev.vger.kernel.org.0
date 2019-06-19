Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3C54B815
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 14:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731703AbfFSMXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 08:23:35 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43198 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbfFSMXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 08:23:34 -0400
Received: by mail-qt1-f196.google.com with SMTP id w17so13152921qto.10;
        Wed, 19 Jun 2019 05:23:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QrX9o1dbIy2aZ5toQHumMIX6sMGzZ/T6xkwZyYDZz14=;
        b=ZH75fDzvgr+v351pzpuF1wJIiGNKCEkUhTepEs8Cqhf2jd9FDqo41i05rqFiKXA992
         qFTGU/iCJEG54ltzIArO9Zu0HRVoyNGqOxxhA6iunyxSYANAdMeL7HUFCtXFSzCWuniL
         wlu9c0XjafBUdKXJaa3Zjyeoz9d0sdnRn8ES8YDqDR7n6GK7O6fO9f1aNydFSw1tuYqS
         PRpN1Z1M6PvU8JGE6FgrE4YGxz0eB8TdaibiGhB/PzV/G0GOM6+2AwwgyKWP1c/dlhX1
         3EZy5YBz/O1L9RwZ914eJxoaN8u2C9A6lgQbveV1Ws5q6LJWeiYNIC3m3XzNKejZbzOC
         dvnA==
X-Gm-Message-State: APjAAAVygYy3jledueOgj3pYEuLAUeAEUs6/wtn/TG+6SLphvm/w4RAK
        qs2zAhlVbvYSXSdy/AAhy/YT/cq3WiyoRJD1JzI=
X-Google-Smtp-Source: APXvYqxcz8Ej40t9XcWhbMi4v3hKL5jyoIkAsv3W8QipVsdMt2GfYFsVX2pYCz87FZfPkpHzUHY9w66Ewxo5eLZoIvA=
X-Received: by 2002:aed:33a4:: with SMTP id v33mr70766520qtd.18.1560947013427;
 Wed, 19 Jun 2019 05:23:33 -0700 (PDT)
MIME-Version: 1.0
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
 <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
 <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
 <066e9b39f937586f0f922abf801351553ec2ba1d.camel@sipsolutions.net>
 <b3686626-e2d8-bc9c-6dd0-9ebb137715af@linaro.org> <b23a83c18055470c5308fcd1eed018056371fc1d.camel@sipsolutions.net>
 <CAK8P3a1FeUQR3pgoQxHoRK05JGORyR+TFATVQiijLWtFKTv6OQ@mail.gmail.com>
 <613cdfde488eb23d7207c7ba6258662702d04840.camel@sipsolutions.net>
 <CAK8P3a2onXpxiE4y9PzRwuPM2dh=h_BKz7Eb0=LLPgBbZoK1bQ@mail.gmail.com> <6c70950d0c78bc02a3d016918ec3929e@codeaurora.org>
In-Reply-To: <6c70950d0c78bc02a3d016918ec3929e@codeaurora.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 19 Jun 2019 14:23:16 +0200
Message-ID: <CAK8P3a3e+U85yHTeE4dHa4okLVHgBd8Kke9=FytzvMwz+wB0sQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Alex Elder <elder@linaro.org>, abhishek.esse@gmail.com,
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
        syadagir@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 11:15 PM Subash Abhinov Kasiviswanathan
<subashab@codeaurora.org> wrote:
>
> On 2019-06-18 14:55, Arnd Bergmann wrote:
> > On Tue, Jun 18, 2019 at 10:36 PM Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> >>
> >> On Tue, 2019-06-18 at 21:59 +0200, Arnd Bergmann wrote:
> >> >
> >> > From my understanding, the ioctl interface would create the lower
> >> > netdev after talking to the firmware, and then user space would use
> >> > the rmnet interface to create a matching upper-level device for that.
> >> > This is an artifact of the strong separation of ipa and rmnet in the
> >> > code.
> >>
> >> Huh. But if rmnet has muxing, and IPA supports that, why would you
> >> ever
> >> need multiple lower netdevs?
> >
> > From my reading of the code, there is always exactly a 1:1 relationship
> > between an rmnet netdev an an ipa netdev. rmnet does the encapsulation/
> > decapsulation of the qmap data and forwards it to the ipa netdev,
> > which then just passes data through between a hardware queue and
> > its netdevice.
> >
>
> There is a n:1 relationship between rmnet and IPA.
> rmnet does the de-muxing to multiple netdevs based on the mux id
> in the MAP header for RX packets and vice versa.

Oh, so you mean that even though IPA supports multiple channels
and multiple netdev instances for a physical device, all the
rmnet devices end up being thrown into a single channel in IPA?

What are the other channels for in IPA? I understand that there
is one channel for commands that is separate, while the others
are for network devices, but that seems to make no sense if
we only use a single channel for rmnet data.

> >> Yeah, but if you actually have a hardware queue per upper netdev then
> >> you don't really need this - you just stop the netdev queue when the
> >> hardware queue is full, and you have flow control automatically.
> >>
> >> So I really don't see any reason to have these messages going back and
> >> forth unless you plan to have multiple sessions muxed on a single
> >> hardware queue.
> >
>
> Hardware may flow control specific PDNs (rmnet interfaces) based on QoS
> -
> not necessarily only in case of hardware queue full.

Right, I guess that makes sense if everything ends up in a
single queue in IPA.

      Arnd
