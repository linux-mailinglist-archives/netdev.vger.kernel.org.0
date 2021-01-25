Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215483049E7
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732198AbhAZFUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:20:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730355AbhAYPpi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 10:45:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3C192224C;
        Mon, 25 Jan 2021 15:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611587096;
        bh=NpbOL0QAy2B+v2obTlYdRHqEBTB+JvqMn4xl7op6tQk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nhVwK8YAdvdKoEPF2JktD7o2Kqm/pYYHEesrR/2aKWKgwr7rSdyvQRSFeHsqdW8/C
         sWUPIulZ+zahhyz6yyZ9ThlEo4HuJ4D0KpYU+8KEeZ1hrLnPDHEq/RDKk0qnL8zhnu
         rPCeg6RbLnar0PQbA2AN9IX60Pd6gO7BDYvCyi5wIgRnRWM2QFFOViRw/OuMuIZnaI
         CMUFaYcPOr/b2Q7CU1kOgJfYXXtaCqIlDJnJ6cHz+dhHbWsyXWDyPHiTDXIaE+lG6Y
         FYmFxsBBhh8uiFIg8PfY0pW110lc9hg7rwP5LHxvVp0mWUs2c25hMzlgU8dA/rdXZ7
         /CtWoWgEYwPig==
Received: by mail-ej1-f54.google.com with SMTP id by1so18497535ejc.0;
        Mon, 25 Jan 2021 07:04:55 -0800 (PST)
X-Gm-Message-State: AOAM533CV9GGZkdeWiMq5JQX1ODc9xU/xxek9E1nOBBzzsX7SAx7uLAP
        7S9DIUUdu9yldLwDEu1wSypqmJmlz7BvLLd+RJw=
X-Google-Smtp-Source: ABdhPJzojfz9zKZgZqlkUtTNjng/1jRATIl36jwsa/Jt/SJvnlIGM8ns0P8MPSjplQ4Nzdq74KQFPv1BPhXYQKoWZDo=
X-Received: by 2002:a17:906:2898:: with SMTP id o24mr618828ejd.215.1611587094202;
 Mon, 25 Jan 2021 07:04:54 -0800 (PST)
MIME-Version: 1.0
References: <20210125113654.2408057-1-arnd@kernel.org> <CAJKOXPfteJ3Jia4Qd9DabjxcOtax3uDgi1fSbz4_+cHsJ1prQQ@mail.gmail.com>
 <CAK8P3a0apBUbck9Z3UMKfwSJw8a-UbbXLTLUvSyOKEwTgPLjqg@mail.gmail.com>
 <CAJKOXPc6LWnqiyO9WgxUZPo-vitNcQQr2oDoyD44P2YTSJ7j=g@mail.gmail.com> <CAK8P3a1NEbZtXVA0Z4P3K97L9waBp7nkCWOkdYjR3+7FUF0P0Q@mail.gmail.com>
In-Reply-To: <CAK8P3a1NEbZtXVA0Z4P3K97L9waBp7nkCWOkdYjR3+7FUF0P0Q@mail.gmail.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Mon, 25 Jan 2021 16:04:42 +0100
X-Gmail-Original-Message-ID: <CAJKOXPdWouEFtCp_iG+py1JcyrEU2Fj98jBAPTKZXQXCDQE54A@mail.gmail.com>
Message-ID: <CAJKOXPdWouEFtCp_iG+py1JcyrEU2Fj98jBAPTKZXQXCDQE54A@mail.gmail.com>
Subject: Re: [PATCH] ath9k: fix build error with LEDS_CLASS=m
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Flavio Suligoi <f.suligoi@asem.it>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 at 15:38, Arnd Bergmann <arnd@kernel.org> wrote:
>
> On Mon, Jan 25, 2021 at 2:27 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > On Mon, 25 Jan 2021 at 14:09, Arnd Bergmann <arnd@kernel.org> wrote:
> > > On Mon, Jan 25, 2021 at 12:40 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > > > On Mon, 25 Jan 2021 at 12:36, Arnd Bergmann <arnd@kernel.org> wrote:
> > > > But we do not want to have this dependency (selecting MAC80211_LEDS).
> > > > I fixed this problem here:
> > > > https://lore.kernel.org/lkml/20201227143034.1134829-1-krzk@kernel.org/
> > > > Maybe let's take this approach?
> > >
> > > Generally speaking, I don't like to have a device driver specific Kconfig
> > > setting 'select' a subsystem', for two reasons:
> > >
> > > - you suddenly get asked for tons of new LED specific options when
> > >   enabling seemingly benign options
> > >
> > > - Mixing 'depends on' and 'select' leads to bugs with circular
> > >   dependencies that usually require turning some other 'select'
> > >   into 'depends on'.
> > >
> > > The problem with LEDS_CLASS in particular is that there is a mix of drivers
> > > using one vs the other roughly 50:50.
> >
> > Yes, you are right, I also don't like it. However it was like this
> > before my commit so I am not introducing a new issue. The point is
> > that in your choice the MAC80211_LEDS will be selected if LEDS_CLASS
> > is present, which is exactly what I was trying to fix/remove. My WiFi
> > dongle does not have a LED and it causes a periodic (every second)
> > event. However I still have LEDS_CLASS for other LEDS in the system.
>
> What is the effect of this lost event every second? If it causes some
> runtime warning or other problem, then neither of our fixes would
> solve it completely, because someone with a distro kernel would
> see the same issue when they have the symbol enabled but no
> physical LED in the device.

I meant that having MAC80211_LEDS selected causes the ath9k driver to
toggle on/off the WiFi LED. Every second, regardless whether it's
doing something or not. In my setup, I have problems with a WiFi
dongle somehow crashing (WiFi disappears, nothing comes from the
dongle... maybe it's Atheros FW, maybe some HW problem) and I found
this LED on/off slightly increases the chances of this dongle-crash.
That was the actual reason behind my commits.

Second reason is that I don't want to send USB commands every second
when the device is idle. It unnecessarily consumes power on my
low-power device.

Of course another solution is to just disable the trigger via sysfs
LED API. It would also work but my patch allows entire code to be
compiled-out (which was conditional in ath9k already).

Therefore the patch I sent allows the ath9k LED option to be fully
choosable. Someone wants every-second-LED-blink, sure, enable
ATH9K_LEDS and you have it. Someone wants to reduce the kernel size,
don't enable ATH9K_LEDS.

Best regards,
Krzysztof
