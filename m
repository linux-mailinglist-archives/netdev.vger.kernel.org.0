Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298A432CE11
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 09:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235550AbhCDIEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 03:04:47 -0500
Received: from mail-vs1-f54.google.com ([209.85.217.54]:35662 "EHLO
        mail-vs1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235412AbhCDIEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 03:04:43 -0500
Received: by mail-vs1-f54.google.com with SMTP id t23so14110772vsk.2;
        Thu, 04 Mar 2021 00:04:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gyh15hLXJY8luaJoyps7zNtQ5xYbfTBae1EDPskk0tY=;
        b=c+xhXsM7VV8YVOjgEFJDLS9+X8NV4uxRezfxp/higy7OZTAXJeAAsTu9XfqM+O7niU
         5yAmz8OW2TFvx+4rWHZ+dU8mOpz7rLL+/1+q40pyfN0oPdbVKV9RDqxhhUmbmiwPXemA
         u23swIdxa9JwWG/Zzt/F5ZxeLHHcbdbhmYkXl20bXJ8rur83CmjijG42JfCUfIm34xIR
         MyNR43lr7wsArD2C7ZYrrWz4pv9cMU9qRrTuxo8w5EAN0JOKuhstylynmtr9jUByAQUY
         bn7QxafL9dteVIIcXZVT9V2WqRALwq9xoeSur1gCxNtRi9qwKB5L6nSpvZrmgn7P8Omq
         ux1A==
X-Gm-Message-State: AOAM532ERav7aRCMsyZvByWZMlM+fXxiwTrLOOtzTcBi+4YfdM3zXu4T
        t0p7eaZsiHJuZYGdbG1Rlse7rO1do1Yl7Ew1lMM=
X-Google-Smtp-Source: ABdhPJwKwy4nTB2d+akM3aUJwMmNLi0FUBrpc9QIWArpDCsq56qTu0caYn1tgT1HYHAYW7lEm8PrIabmxCwJbIWzH7g=
X-Received: by 2002:a67:f7c6:: with SMTP id a6mr1762136vsp.42.1614845042854;
 Thu, 04 Mar 2021 00:04:02 -0800 (PST)
MIME-Version: 1.0
References: <20210224115146.9131-1-aford173@gmail.com> <20210224115146.9131-5-aford173@gmail.com>
In-Reply-To: <20210224115146.9131-5-aford173@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 4 Mar 2021 09:03:51 +0100
Message-ID: <CAMuHMdW3SO7LemssHrGKkV0TUVNuT4oq1EfmJ-Js79=QBvNhqQ@mail.gmail.com>
Subject: Re: [PATCH V3 5/5] arm64: dts: renesas: beacon kits: Setup AVB refclk
To:     Adam Ford <aford173@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 12:52 PM Adam Ford <aford173@gmail.com> wrote:
> The AVB refererence clock assumes an external clock that runs

reference

> automatically.  Because the Versaclock is wired to provide the
> AVB refclock, the device tree needs to reference it in order for the
> driver to start the clock.
>
> Signed-off-by: Adam Ford <aford173@gmail.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-devel (with the typo fixed) once the DT
bindings have been accepted.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
