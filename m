Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1837F11982E
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730249AbfLJVh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:37:27 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39351 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727617AbfLJVh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 16:37:26 -0500
Received: by mail-ed1-f68.google.com with SMTP id v16so17354550edy.6;
        Tue, 10 Dec 2019 13:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DAqvBJfhNAOGF5MpGJ9HATnJQKl2CCNr6kYiDBl2DG4=;
        b=nJ2RcBVGN5w/cHHhwNlitZ++xYkfcmWBQPzUx0q1WklcNfOFp4iBI8qLiaQgdH0xKz
         VV0EES6LBWUqF5FsJv9B59d101Zskd2vjgXt+oASmPKcjX6ieRviRII079K5POvSNsqU
         XqMMtkg68O4ohkJli8naxOPj8DFN6u+Lr+w9TnJrGXG+hgh7StBs7mvTCHaE98V/sLVK
         7QqXcG3gywf/GtysF5T82g1xKztJA6yHwT4JeQyv9b2WfPt8SgUI54b2dfENvJEQa2iL
         yIYsSlCtCOE43IfxR5tBuYIVYQVDyU3cnXkjmypLHVjxqisEyQrQAo9x/eaNvOWadIrr
         UXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DAqvBJfhNAOGF5MpGJ9HATnJQKl2CCNr6kYiDBl2DG4=;
        b=G1SYksLvtR6FjhMHtYWLKcv57kSj2nuUeZleoYsTQUCwHcHn+4grxiLxVao806ogg6
         4Bv59mGMDi37QrQQxlkxBWWvu5BP9mJEPvHAK6h9LSU9eYTDAZiXBdJTba2u2TSyAzBp
         FDTMc5jUOdqvAHAXqrUunXVWCMuZ5LW6ozi8xKNnG28qeSJxxwH25vRSsYCgp9bXcHjD
         5cNxbvydl9N+lqBF/kMxPooekAxS+bHqq0whmVvSJdtz/KxxQk2OoHZm9SId2umyCLjK
         e76skuJj2OdwM5IqvVVwGo8PfW2B1FywKOFum+qcw1Gg5FnJYChkAqqTB0FVz75tj9xJ
         alqg==
X-Gm-Message-State: APjAAAV+yQJ9HaAAi1gBTVMGq2IQ41sCpzQC4GyabaaZpKAUqN+VqaLr
        rAILl8h0i4xJf6tGo1Gh33aMsAJQ/KpOuwSjprU=
X-Google-Smtp-Source: APXvYqxP8zj+d8UiYiYWLKUnX3/3yCG8sjv94TZFtkAfGBo9bO/cvbEXCYctDTnSBQi/mvtJEPNbH7RdQoDcHjWsaG0=
X-Received: by 2002:a17:906:3052:: with SMTP id d18mr6270011ejd.86.1576013844298;
 Tue, 10 Dec 2019 13:37:24 -0800 (PST)
MIME-Version: 1.0
References: <20191210203710.2987983-1-arnd@arndb.de>
In-Reply-To: <20191210203710.2987983-1-arnd@arndb.de>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 10 Dec 2019 23:37:13 +0200
Message-ID: <CA+h21hrJ45J2N4DD=pAtE8vN6hCjUYUq5vz17pY-7=TpkA51rA@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: ocelot: add NET_VENDOR_MICROSEMI dependency
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On Tue, 10 Dec 2019 at 22:37, Arnd Bergmann <arnd@arndb.de> wrote:
>
> Selecting MSCC_OCELOT_SWITCH is not possible when NET_VENDOR_MICROSEMI
> is disabled:
>
> WARNING: unmet direct dependencies detected for MSCC_OCELOT_SWITCH
>   Depends on [n]: NETDEVICES [=y] && ETHERNET [=n] && NET_VENDOR_MICROSEMI [=n] && NET_SWITCHDEV [=y] && HAS_IOMEM [=y]
>   Selected by [m]:
>   - NET_DSA_MSCC_FELIX [=m] && NETDEVICES [=y] && HAVE_NET_DSA [=y] && NET_DSA [=y] && PCI [=y]
>
> Add a Kconfig dependency on NET_VENDOR_MICROSEMI, which also implies
> CONFIG_NETDEVICES.
>
> Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

This has been submitted before, here [0].

It isn't wrong, but in principle I agree with David that it is strange
to put a "depends" relationship between a driver in drivers/net/dsa
and the Kconfig vendor umbrella from drivers/net/ethernet/mscc ("why
would the user care/need to enable NET_VENDOR_MICROSEMI to see the DSA
driver" is a valid point to me). This is mainly because I don't
understand the point of CONFIG_NET_VENDOR_* options, they're a bit
tribalistic to my ears.

Nonetheless, alternatives may be:
- Move MSCC_OCELOT_SWITCH core option outside of the
NET_VENDOR_MICROSEMI umbrella, and make it invisible to menuconfig,
just selectable from the 2 driver instances (MSCC_OCELOT_SWITCH_OCELOT
and NET_DSA_MSCC_FELIX). MSCC_OCELOT_SWITCH has no reason to be
selectable by the user anyway.
- Remove NET_VENDOR_MICROSEMI altogether. There is a single driver
under drivers/net/ethernet/mscc and it's already causing problems,
it's ridiculous.
- Leave it as it is. I genuinely ask: if the build system tells you
that the build dependencies are not met, does it matter if it compiles
or not?

[0]: https://www.spinics.net/lists/netdev/msg614325.html

Regards,
-Vladimir
