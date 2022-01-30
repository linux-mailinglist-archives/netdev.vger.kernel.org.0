Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E604A396E
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 21:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243305AbiA3Uth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 15:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356321AbiA3UrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 15:47:24 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D4BC061748;
        Sun, 30 Jan 2022 12:47:18 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id m14so21344672wrg.12;
        Sun, 30 Jan 2022 12:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dpgE9PsJaTlazsakgq+wcKIDpyYOGepVxcJ/37+D8gU=;
        b=WfLEjCAPGuv0pA9yQLbNIobOPGoyi71BNQUxHqt4c0yGLHfAQ2Jofc3yJSfS1f4HqL
         S7ZsWc07vUdJ479Zmt9OR7MLHswNbsIfm7dhW4KhMgOigCWup6fn8QzyOmpFpAp68ZKU
         oOfjxGawRM6f5Za0sa3KIyTC7v/67cdKH/67pJWTwyOHjt26GgQLZAoR1FJjUZWbQvSg
         2YyXN96Cs8vNzzjZbvPSZsBANeXcqZu6119CA5hPnEpftiKe0pS+K+fbT7m7Ea39kOfX
         oF3y4YB9hb1FIDbZZlwlpWSCP25+FyzZq2TojSXLXGVborNV/nNxsV+Ocob8JgsfID26
         Gs4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dpgE9PsJaTlazsakgq+wcKIDpyYOGepVxcJ/37+D8gU=;
        b=LZRiN5MgQe1dB0ZaM6cMThB2+oSdGy8nIWxZrnWclFYeIGemOu5SDaQugrFZMqMOCL
         W/xk1M8sqdnDMBcSHjFRcfLIVQ9t0RPWa1jHnRab92CB/FmC6bb8LWkW8S7CA5FHhy6j
         xFLPlXWxzMFHyU+CkJNus7MqTEJmkMD9Mw5N+EvW82A5I6Bu939D3gYEXXPe4pBt1zPP
         R01rztsU5vaa1+GRlXf92dE6IV298oi3Jyj+CviP//JvUWSz7R7JACEEd1FzobnsBjcO
         J0mAQ+BwsxqcdS7jqVyaW8zSTuuhKZlSwx8RU/9XzRjCQzjiOQCNxmqs36O1afAjl/4D
         AlHQ==
X-Gm-Message-State: AOAM532vuar2DittrlNMCmVvUpJbhzUy/LS8x2VEWo5i0Mnr+KgDzRyj
        WsX8r6LiLL+hxWtffco1ygqPy/M2ZzA+QHGBU46feFe0
X-Google-Smtp-Source: ABdhPJy45eQgSyEUf6aQctCiiBhnloxDTtbStubRkGocw2qZXyOEHqCfPkAwOGbWjNJH9nHcFRpGni/Rz5WvwHJf4/s=
X-Received: by 2002:a5d:47c2:: with SMTP id o2mr14979508wrc.81.1643575636658;
 Sun, 30 Jan 2022 12:47:16 -0800 (PST)
MIME-Version: 1.0
References: <20220128112002.1121320-1-miquel.raynal@bootlin.com> <20220128112002.1121320-2-miquel.raynal@bootlin.com>
In-Reply-To: <20220128112002.1121320-2-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 30 Jan 2022 15:47:05 -0500
Message-ID: <CAB_54W6Lc4P8WXR81311qH2XdDd2tjG1yEXo+UEXFcMX=q_Q5Q@mail.gmail.com>
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
> -source "net/mac802154/Kconfig"
>  source "net/sched/Kconfig"
>  source "net/dcb/Kconfig"
>  source "net/dns_resolver/Kconfig"
> @@ -380,6 +378,7 @@ source "net/mac80211/Kconfig"
>
>  endif # WIRELESS
>
> +source "net/ieee802154/Kconfig"

I would argue here that IEEE 802.15.4 is no "network option". However
I was talking once about moving it, but people don't like to move
things there around.
In my opinion there is no formal place to "have all the low-range
wireless such as Bluetooth, IEEE 802.11 (WiFi) and IEEE 802.15.4
together". If you bring all subsystems together and put them into an
own menuentry this would look different.

You forgot to move mac802154 as well here, even though it's changed in
the following patch.

If nobody else complains about moving Kconfig entries here around it
looks okay for me.

- Alex
