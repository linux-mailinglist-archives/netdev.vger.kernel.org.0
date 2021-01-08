Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC71D2EF3C4
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 15:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbhAHOMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 09:12:53 -0500
Received: from mail-oi1-f177.google.com ([209.85.167.177]:38848 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbhAHOMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 09:12:52 -0500
Received: by mail-oi1-f177.google.com with SMTP id x13so11442412oic.5;
        Fri, 08 Jan 2021 06:12:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wIuJZZvb0gzZkSS4B0eLCyXExMgaXIe5iJbAbqQLb5w=;
        b=limr+0RxlP/aCLqANfhJnqKMwyLk3aMgSnz1M1NoyxsaW0O/GuHmsN4ZOuLFGCDdwv
         AIVS8vyR85MrnwdWEbbnBnqd4lVjmdSI7Ho7YacVn45YZmc/ZF9NH4o6MMs1uUsogZd8
         LIBxLusquv1CPMfVDtRPSUV/+JUR5t4nQchKFX8Zh+nkweIdGwg1wWLjFXrMzgAmfGGD
         sPUerNat2P4OZwqmijmBqosC3hMMBbZQe5CkImuiKMEnCqyTXzUkpIlaDCiQOhonRCJx
         +Lk7TpxNQheJuSRj7IHJLyUqF2sudFE8p9fU5YUkrUkWiKiMrFEv/pDA3CR8jtsgZjPq
         DwDw==
X-Gm-Message-State: AOAM533oxhmRYoAg3H/tHPF3sQuJOMno1GfnAK5n6fkSW2pF3LgNCtJ1
        3XSiFya4acueZGi9AVxKAhQAGGp3ffsyC4/tWjY=
X-Google-Smtp-Source: ABdhPJyemCjOC5dvpA4+jMsIA0V0xTUIe/Wk8kgEjN4sB5bYCpAmxwjdD7IQ/WgXE542apoi59gaN+8T5vt4YF4Ccig=
X-Received: by 2002:aca:3cc5:: with SMTP id j188mr2459213oia.54.1610115130954;
 Fri, 08 Jan 2021 06:12:10 -0800 (PST)
MIME-Version: 1.0
References: <20201228213121.2331449-1-aford173@gmail.com>
In-Reply-To: <20201228213121.2331449-1-aford173@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 8 Jan 2021 15:11:59 +0100
Message-ID: <CAMuHMdWE7FS-BLjT0sXupPX+V7XOTjN8ZKnRmShNEOx0i9DCGQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] dt-bindings: net: renesas,etheravb: Add additional clocks
To:     Adam Ford <aford173@gmail.com>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 10:32 PM Adam Ford <aford173@gmail.com> wrote:
> The AVB driver assumes there is an external clock, but it could
> be driven by an external clock.  In order to enable a programmable
> clock, it needs to be added to the clocks list and enabled in the
> driver.  Since there currently only one clock, there is no
> clock-names list either.
>
> Update bindings to add the additional optional clock, and explicitly
> name both of them.
>
> Signed-off-by: Adam Ford <aford173@gmail.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
