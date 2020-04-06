Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC68119F7E6
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 16:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgDFOZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 10:25:54 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:45172 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728566AbgDFOZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 10:25:53 -0400
Received: by mail-yb1-f193.google.com with SMTP id g6so8837475ybh.12;
        Mon, 06 Apr 2020 07:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A1e6rv+wa9eMFQC7jl+vmCrZCOWGenHHnzuo3smwjuw=;
        b=tE9vpyVS7KlbS7n5s7IQvB+c8+LYwC1qwApksX7SlkwAIoNxUW8T542xoB/Iz77Efg
         TnI8nzo3yF4j2Tlr0DVvLCO39JTT7RZO0i2BTbkiib6KPaPfQAvobhpVVjJTXggs9ylO
         ilurunlvBz3i3FLC2VeyWrdcLUPyEmbwIN6Df/gCSqNe6ZQ2tRxhjeuZrLNhCDvT6di/
         X6+BhfjChoD0b9wLwjkJ7KMUfXBmacHEb9kfOJk2mfLPDlc/Nm+kPKT/eFjaGqobidKJ
         x2Fk7ZuMin1PnESrAM+751F6i6zqvmZbCoBL0qgrON/T1R2jCk3sS3cXJioktroJGPak
         9xkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A1e6rv+wa9eMFQC7jl+vmCrZCOWGenHHnzuo3smwjuw=;
        b=C6WpP4kbHkudzQjQVw2UpVVDsjzQsdVNtiBIqDV4tOh0gSFnCYLr7AgIw5cf4522fN
         MP10euBPCmBNxzhxN103Ax8maSl5kISkikeJfSLUA7wxu/GEbTxTMR0E6w4sJcdFyHge
         kKb2660IY4hJtgc7pNsfKflnBg2eV2kT7oHOwK9m2uxhSZuEW7PKogHXRsI0l0Wxeb5e
         DRZmTqlwYPNjkVTQzUlM4tIE86DWj82mIE5bo6J5wmCmNeHsUMQi4ueVk5qSwKCg15a3
         j/NbJLyJWA6W6pnua0UhJL7OKWJVhZttTgBLxNB1eu8u9p0riRMtgzdrFCbDKjP2W9vV
         4Bmg==
X-Gm-Message-State: AGi0Pua+EBMT5+RQ/mMS7bK1cRs3MnnPfPv7tKTBOn0Q+xo1dKQrLsUI
        zjvu6rUYVQ+VXNN7GmiMzwZAoO7ZXjbhwWGBf94=
X-Google-Smtp-Source: APiQypJdiJtl3+v04phKnoeqU7IKBw3R90X2oZ43U9OsiUnAuIQhErWZlpW/iqHtlo6P1LOEfMwcR/gv9WKreiRmt0U=
X-Received: by 2002:a25:da48:: with SMTP id n69mr35790780ybf.370.1586183152074;
 Mon, 06 Apr 2020 07:25:52 -0700 (PDT)
MIME-Version: 1.0
References: <1586175677-3061-1-git-send-email-sumit.garg@linaro.org>
 <87ftdgokao.fsf@tynnyri.adurom.net> <1e352e2130e19aec5aa5fc42db397ad50bb4ad05.camel@sipsolutions.net>
 <87r1x0zsgk.fsf@kamboji.qca.qualcomm.com> <a7e3e8cceff1301f5de5fb2c9aac62b372922b3e.camel@sipsolutions.net>
 <87imiczrwm.fsf@kamboji.qca.qualcomm.com> <ee168acb768d87776db2be4e978616f9187908d0.camel@sipsolutions.net>
 <CAFA6WYOjU_iDyAn5PMGe=usg-2sPtupSQEYwcomUcHZBAPnURA@mail.gmail.com>
 <87v9mcycbf.fsf@kamboji.qca.qualcomm.com> <CABPxzYKs3nj0AUX4L-j87Db8v3WnM4uGif9nRTGgx1m2HNN8Rg@mail.gmail.com>
 <35cadbaff1239378c955014f9ad491bc68dda028.camel@sipsolutions.net>
In-Reply-To: <35cadbaff1239378c955014f9ad491bc68dda028.camel@sipsolutions.net>
From:   Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date:   Mon, 6 Apr 2020 19:55:40 +0530
Message-ID: <CABPxzY++YMBPTV4quAkYvEAMfULjMXLkVfNzwocwubno5HO2Bw@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix race in ieee80211_register_hw()
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Matthias=2DPeter_Sch=C3=B6pfer?= 
        <matthias.schoepfer@ithinx.io>,
        "Berg Philipp (HAU-EDS)" <Philipp.Berg@liebherr.com>,
        "Weitner Michael (HAU-EDS)" <Michael.Weitner@liebherr.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 6, 2020 at 7:31 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Mon, 2020-04-06 at 19:25 +0530, Krishna Chaitanya wrote:
> > On Mon, Apr 6, 2020 at 6:57 PM Kalle Valo <kvalo@codeaurora.org> wrote:
> > > Sumit Garg <sumit.garg@linaro.org> writes:
> > >
> > > > On Mon, 6 Apr 2020 at 18:38, Johannes Berg <johannes@sipsolutions.net> wrote:
> > > > > On Mon, 2020-04-06 at 16:04 +0300, Kalle Valo wrote:
> > > > > > Johannes Berg <johannes@sipsolutions.net> writes:
> > > > > >
> > > > > > > On Mon, 2020-04-06 at 15:52 +0300, Kalle Valo wrote:
> > > > > > > > Johannes Berg <johannes@sipsolutions.net> writes:
> > > > > > > >
> > > > > > > > > On Mon, 2020-04-06 at 15:44 +0300, Kalle Valo wrote:
> > > > > > > > > > >     user-space  ieee80211_register_hw()  RX IRQ
> > > > > > > > > > >     +++++++++++++++++++++++++++++++++++++++++++++
> > > > > > > > > > >        |                    |             |
> > > > > > > > > > >        |<---wlan0---wiphy_register()      |
> > > > > > > > > > >        |----start wlan0---->|             |
> > > > > > > > > > >        |                    |<---IRQ---(RX packet)
> > > > > > > > > > >        |              Kernel crash        |
> > > > > > > > > > >        |              due to unallocated  |
> > > > > > > > > > >        |              workqueue.          |
> > > > > > > > >
> > > > > > > > > [snip]
> > > > > > > > >
> > > > > > > > > > I have understood that no frames should be received until mac80211 calls
> > > > > > > > > > struct ieee80211_ops::start:
> > > > > > > > > >
> > > > > > > > > >  * @start: Called before the first netdevice attached to the hardware
> > > > > > > > > >  *         is enabled. This should turn on the hardware and must turn on
> > > > > > > > > >  *         frame reception (for possibly enabled monitor interfaces.)
> > > > > > > > >
> > > > > > > > > True, but I think he's saying that you can actually add and configure an
> > > > > > > > > interface as soon as the wiphy is registered?
> > > > > > > >
> > > > > > > > With '<---IRQ---(RX packet)' I assumed wcn36xx is delivering a frame to
> > > > > > > > mac80211 using ieee80211_rx(), but of course I'm just guessing here.
> > > > > > >
> > > > > > > Yeah, but that could be legitimate?
> > > > > >
> > > > > > Ah, I misunderstood then. The way I have understood is that no rx frames
> > > > > > should be delivered (= calling ieee80211_rx()_ before start() is called,
> > > > > > but if that's not the case please ignore me :)
> > > > >
> > > > > No no, that _is_ the case. But I think the "start wlan0" could end up
> > > > > calling it?
>
> > I am still confused, without ieee80211_if_add how can the userspace
> > bring up the interface?
>
> It can add its own interface. Maybe that won't be 'wlan0' but something
> else?
>
> like
>
> iw phy0 interface add wlan0 type station
> ip link set wlan0 up
Ah okay, got it, thanks. Very narrow window though :-) as the
alloc_ordered_workqueue
doesn't need RTNL and there is a long way to go to do if_add() from
user and setup
the driver for interrupts. Again depends on the driver though, it
should properly handle
pending ieee80211_register_hw() with start().
