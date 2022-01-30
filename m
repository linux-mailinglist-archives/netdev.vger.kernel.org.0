Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EC94A39B6
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 22:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356402AbiA3VIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 16:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238044AbiA3VIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 16:08:06 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E149DC061714;
        Sun, 30 Jan 2022 13:08:05 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id v123so8865174wme.2;
        Sun, 30 Jan 2022 13:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jSB2+KdA08CJRNczrjoJ8pZQ5vaawPDsJZIPgzPy2i8=;
        b=GnMw7GVkeBGWRrNbOpYKcixXHZxlvb6KfHmVGsEBftYubJOuIb+q6NErghAgRhGWiY
         x87MQl8HPIsA/9HysUNG3iFhHiEzu0VvSiom7fvZvALmKWjiwjCn1E0OslHfJCjXo36F
         OM31tknrOq8xHvEqBBk7j+sJ+tjR9P4roneH9mCzIvpqcdG44qVLDN846xztEPda3Y7B
         qud85WgfuzGTRVKxnCUPxb/YDXdhRuNT7N9rid5zBchf79TCaM6bVT+NYbDFlqV44w2R
         h5TpN7pe9I925J0gYn55Ogs+VZa5uta6cpFe7Kiea327gxxETqcsDS1zWdfV/3PiW3lu
         3bNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jSB2+KdA08CJRNczrjoJ8pZQ5vaawPDsJZIPgzPy2i8=;
        b=ROMyQbRmFE/UxGa2NpCupCohvGKW08C3Lb61CZspSNxugUISMz1BlvUFlCrdDju4WI
         n69M0kBfG5V1l7sfewzs5Sf38V7wgUXS/+RdVpChD9tUPg1aNYTjqoAndXpBdSvEiK8d
         VGLFghU8WbhTwYY0QgAYcSwmNES4vf+eel2dSfDc5vXtNvuUqT0xieet6DYrVXXOeoAa
         KXRI6Y0++QvD4Ug0c4E4yER4bYEDea85dGSm4DJidz6PZuO9BgVp9LyLdxuU5/WNF518
         2dJtAT02tFJFbAV0EeY4Wa4F0WEdF1vkIRzCFCEG76vT3UAXfKZS/mCIFoRBhobJaQ6g
         2IKA==
X-Gm-Message-State: AOAM5303t5Pdr7jZCV5JBk1xLomKmZ4KFSu9NfmStNhm5JAt6ENsh1GV
        1PjcEcyuAoCS0HY13UTM8hMXPVbnbpq5cJ+iob4=
X-Google-Smtp-Source: ABdhPJw3fdcHy0yKxu3EOk90OfTBb1q0f0kUCgD/EWyn5ZYlWnKWSSNMbvIJemN6wyEBMI7rKokl4JDXLd6bOFifVP4=
X-Received: by 2002:a05:600c:26c6:: with SMTP id 6mr15790416wmv.54.1643576884148;
 Sun, 30 Jan 2022 13:08:04 -0800 (PST)
MIME-Version: 1.0
References: <20220128112002.1121320-1-miquel.raynal@bootlin.com> <20220128112002.1121320-2-miquel.raynal@bootlin.com>
In-Reply-To: <20220128112002.1121320-2-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 30 Jan 2022 16:07:53 -0500
Message-ID: <CAB_54W45Hht8OVLDhKTKkfORYUJ30oWBz2psxX2m8OB4foK=0Q@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 1/2] net: ieee802154: Move the IEEE 802.15.4
 Kconfig main entries
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I will do this review again because I messed up with other series.

On Fri, Jan 28, 2022 at 6:20 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> From: David Girault <david.girault@qorvo.com>
>
> It makes certainly more sense to have all the low-range wireless
> protocols such as Bluetooth, IEEE 802.11 (WiFi) and IEEE 802.15.4
> together, so let's move the main IEEE 802.15.4 stack Kconfig entry at a
> better location.
>
> As the softMAC layer has no meaning outside of the IEEE 802.15.4 stack
> and cannot be used without it, also move the mac802154 menu inside
> ieee802154/.
>

That's why there is a "depends on".

> Signed-off-by: David Girault <david.girault@qorvo.com>
> [miquel.raynal@bootlin.com: Isolate this change from a bigger commit and
> rewrite the commit message.]
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  net/Kconfig            | 3 +--
>  net/ieee802154/Kconfig | 1 +
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/Kconfig b/net/Kconfig
> index 8a1f9d0287de..a5e31078fd14 100644
> --- a/net/Kconfig
> +++ b/net/Kconfig
> @@ -228,8 +228,6 @@ source "net/x25/Kconfig"
>  source "net/lapb/Kconfig"
>  source "net/phonet/Kconfig"
>  source "net/6lowpan/Kconfig"
> -source "net/ieee802154/Kconfig"

I would argue here that IEEE 802.15.4 is no "network option". However
I was talking once about moving it, but people don't like to move
things there around.
In my opinion there is no formal place to "have all the low-range
wireless such as Bluetooth, IEEE 802.11 (WiFi) and IEEE 802.15.4
together". If you bring all subsystems together and put them into an
own menuentry this would look different.

If nobody else complains about moving Kconfig entries here around it
looks okay for me.

> -source "net/mac802154/Kconfig"
>  source "net/sched/Kconfig"
>  source "net/dcb/Kconfig"
>  source "net/dns_resolver/Kconfig"
> @@ -380,6 +378,7 @@ source "net/mac80211/Kconfig"
>
>  endif # WIRELESS
>
> +source "net/ieee802154/Kconfig"
>  source "net/rfkill/Kconfig"
>  source "net/9p/Kconfig"
>  source "net/caif/Kconfig"
> diff --git a/net/ieee802154/Kconfig b/net/ieee802154/Kconfig
> index 31aed75fe62d..7e4b1d49d445 100644
> --- a/net/ieee802154/Kconfig
> +++ b/net/ieee802154/Kconfig
> @@ -36,6 +36,7 @@ config IEEE802154_SOCKET
>           for 802.15.4 dataframes. Also RAW socket interface to build MAC
>           header from userspace.
>
> +source "net/mac802154/Kconfig"

The next person in a year will probably argue "but wireless do source
of wireless/mac80211 in net/Kconfig... so this is wrong".
To avoid this issue maybe we should take out the menuentry here and do
whatever wireless is doing without questioning it?

- Alex
