Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9276D303420
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731585AbhAZFRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:17:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:37744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729948AbhAYPfv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 10:35:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B407F230FF;
        Mon, 25 Jan 2021 15:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611588155;
        bh=FVztG+NxYtVZq+jPplpedE8ZSN7U5DWNfbBcmiJa+x0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BHMMvxaEgds7zuzg+e5b/4YNKyNAXRKR1qSOW1yKjIN2s/gvPKq/he3wvXrJAE9ZK
         QniUHY9YwZTT+6lle7wx//3eYEv2rV2KmIsE6yAvcLOKuErCopxAniWvcM93MAgWek
         SWcGkPZlBlztuco++06NiyyL0sIXnbxu+OVpf3knoqBrPPrBDUDPJLFjb6mnuhGtR4
         dMdZSMabG1xgN3ByW5aeA89rB+JTp3mRWF9yAHK2cMSpFMOMQ6KpTD5ZtgMbEgOJcl
         7h+d0ZoDJ3gluJQUR4DfOExVWmKyr1DCK1xv3O8bl43c3fvOVgE6UEdpFBrJxPVFjI
         /E1F4/XcCCjvg==
Received: by mail-oi1-f179.google.com with SMTP id k25so990456oik.13;
        Mon, 25 Jan 2021 07:22:35 -0800 (PST)
X-Gm-Message-State: AOAM530u5VSBiS6DAi/rnLhG2VOyvnJ7Ng/iFYssZ3gP98Nzq9RW+Jch
        zz7z+xWhk8QAsh9mzU135qUWV4n/tjgpbp/w14w=
X-Google-Smtp-Source: ABdhPJwFkwSM5HAigI7b/5HTex8RMIkP8MlT9k9NMmaZalYKyVlkCz9AWRlbT3owTxeRzCWUHQAUlb8j9egSmH+WUXc=
X-Received: by 2002:aca:e103:: with SMTP id y3mr425239oig.11.1611588154937;
 Mon, 25 Jan 2021 07:22:34 -0800 (PST)
MIME-Version: 1.0
References: <20210125113654.2408057-1-arnd@kernel.org> <CAJKOXPfteJ3Jia4Qd9DabjxcOtax3uDgi1fSbz4_+cHsJ1prQQ@mail.gmail.com>
 <CAK8P3a0apBUbck9Z3UMKfwSJw8a-UbbXLTLUvSyOKEwTgPLjqg@mail.gmail.com>
 <CAJKOXPc6LWnqiyO9WgxUZPo-vitNcQQr2oDoyD44P2YTSJ7j=g@mail.gmail.com>
 <CAK8P3a1NEbZtXVA0Z4P3K97L9waBp7nkCWOkdYjR3+7FUF0P0Q@mail.gmail.com> <CAJKOXPdWouEFtCp_iG+py1JcyrEU2Fj98jBAPTKZXQXCDQE54A@mail.gmail.com>
In-Reply-To: <CAJKOXPdWouEFtCp_iG+py1JcyrEU2Fj98jBAPTKZXQXCDQE54A@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 25 Jan 2021 16:22:18 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3ygYTEwjLbFuArdfNF1-yydVjtS2NZDAURKjOJGAxkAQ@mail.gmail.com>
Message-ID: <CAK8P3a3ygYTEwjLbFuArdfNF1-yydVjtS2NZDAURKjOJGAxkAQ@mail.gmail.com>
Subject: Re: [PATCH] ath9k: fix build error with LEDS_CLASS=m
To:     Krzysztof Kozlowski <krzk@kernel.org>
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

On Mon, Jan 25, 2021 at 4:04 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
> On Mon, 25 Jan 2021 at 15:38, Arnd Bergmann <arnd@kernel.org> wrote:
> > On Mon, Jan 25, 2021 at 2:27 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> I meant that having MAC80211_LEDS selected causes the ath9k driver to
> toggle on/off the WiFi LED. Every second, regardless whether it's
> doing something or not. In my setup, I have problems with a WiFi
> dongle somehow crashing (WiFi disappears, nothing comes from the
> dongle... maybe it's Atheros FW, maybe some HW problem) and I found
> this LED on/off slightly increases the chances of this dongle-crash.
> That was the actual reason behind my commits.
>
> Second reason is that I don't want to send USB commands every second
> when the device is idle. It unnecessarily consumes power on my
> low-power device.

Ok, I see.

> Of course another solution is to just disable the trigger via sysfs
> LED API. It would also work but my patch allows entire code to be
> compiled-out (which was conditional in ath9k already).
>
> Therefore the patch I sent allows the ath9k LED option to be fully
> choosable. Someone wants every-second-LED-blink, sure, enable
> ATH9K_LEDS and you have it. Someone wants to reduce the kernel size,
> don't enable ATH9K_LEDS.

Originally, I think this is what CONFIG_MAC80211_LEDS was meant
for, but it seems that this is not actually practical, since this also
gets selected by half of the drivers using it, while the other half have
a dependency on it. Out of the ones that select it, some in turn
select LEDS_CLASS, while some depend on it.

I think this needs a larger-scale cleanup for consistency between
(at least) all the wireless drivers using LEDs. Either your patch
or mine should get applied in the meantime, and I don't care much
which one in this case, as we still have the remaining inconsistency.

        Arnd
