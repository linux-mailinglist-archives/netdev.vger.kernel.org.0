Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04091CA4D3
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 09:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgEHHKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 03:10:33 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:32835 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgEHHKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 03:10:32 -0400
Received: by mail-ot1-f65.google.com with SMTP id j26so740922ots.0
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 00:10:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GOlMaUcUCIagIbGPkPB65+Xmsmk5MMCxY0mc+nB8v6I=;
        b=nl6bRcYqFUbHKfEGHLZGT2B+rzw0GEy+2zgextmGXzuFdUhfgalNV+oGDakiNl8ovR
         2xKZ4C2oCCf88nI7b/Ku2yHWTmBTBDj9RcnxDvKpGmtinTTZGjGjgDcEj2LSoC1pFa9a
         kGHOhQ5TeGKljUp0VbzSpn3aVEQfsWamsZ7jjRcFRU0hGaIe00mbeYWgjlJisXK+17pl
         I0Qosmr8NzSHtm9D0DR7a1o2+WZwyM1lpm5cU4Rxq2WexxKOtajxhjndnBD7YfSelksE
         bACnkBixseWuI6mnea2IHy1wAM2GLMlL/apd3ZpbPhGvFHj6xELDzYgfBeyUY34ycfOg
         V7Uw==
X-Gm-Message-State: AGi0Pub6kyAxhYIBQud0IwZE45guGnhtKmfmUEedaoQa70AbBDEL1rng
        pOTOLWIN/LVAfqpYVW7vwq3aDys4E7elp4TQZqzUuGpO
X-Google-Smtp-Source: APiQypLoRwk4xrJv1+DWP+dKcYHdmvI2adBZ9RZ2XhJqCuKSTOJxFhVFCsMf6fa2r++fxlEjLPWgg06pTBeGB3QS2kI=
X-Received: by 2002:a9d:7990:: with SMTP id h16mr977818otm.145.1588921831681;
 Fri, 08 May 2020 00:10:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200507114205.24621-1-geert+renesas@glider.be> <20200507.131727.907589220898369492.davem@davemloft.net>
In-Reply-To: <20200507.131727.907589220898369492.davem@davemloft.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 8 May 2020 09:10:20 +0200
Message-ID: <CAMuHMdWKp5X3VsiHHFxaVgenmx=M8ScP98Lqu+DoavWGJhowLQ@mail.gmail.com>
Subject: Re: [PATCH] via-rhine: Add platform dependencies
To:     David Miller <davem@davemloft.net>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Tony Prisk <linux@prisktech.co.nz>,
        Arnd Bergmann <arnd@arndb.de>, netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Thu, May 7, 2020 at 10:17 PM David Miller <davem@davemloft.net> wrote:
> From: Geert Uytterhoeven <geert+renesas@glider.be>
> Date: Thu,  7 May 2020 13:42:05 +0200
>
> > The VIA Rhine Ethernet interface is only present on PCI devices or
> > VIA/WonderMedia VT8500/WM85xx SoCs.  Add platform dependencies to the
> > VIA_RHINE config symbol, to avoid asking the user about it when
> > configuring a kernel without PCI or VT8500/WM85xx support.
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Applied to net-next.

Thank you!

> Although I hope that the COMPILE_TEST guard is not too loose and
> now we'll have randconfig build failures for some reason.

I only added a dependency line, and didn't replace the old one.

The "depends on PCI || (OF_IRQ && GENERIC_PCI_IOMAP)" is still there.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
