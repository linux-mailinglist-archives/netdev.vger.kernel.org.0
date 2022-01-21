Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5641D496158
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 15:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381249AbiAUOo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 09:44:58 -0500
Received: from mail-ua1-f52.google.com ([209.85.222.52]:42881 "EHLO
        mail-ua1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381221AbiAUOof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 09:44:35 -0500
Received: by mail-ua1-f52.google.com with SMTP id p1so17216741uap.9;
        Fri, 21 Jan 2022 06:44:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ppj7k8YHsUrV0tlUN9ez99ZMN7NUmBnCHri5xyNPwoM=;
        b=TzSNQa6dDG9WSLZ9P65dZESdUTf3LYLAnCPBDADehkW3hgVcKolC8XUkUavjv26L98
         WRCG5dBUxot42F1NjTZNXf9ThhzCJEE2ukcgRCnscIWc/p8/feacuv6sp5GEsl27t+X7
         3DJ/Z53H//CpJCZWTl7VIyRV5XqS8IdH5uGmrbUbcJoXacvw+V9dpOXTVbNk9xSNP9zh
         jswG/5Ob52DAhUT5HZp5uHaFUKL7xe05I4yrMmSKP9IqOks4eTUlLtt7aJ4DWjOtMkyb
         ifDbrH3UlWvNTGiKWdc1WvM+q7vwBhXCrr8HTcYtfIcDqgTkYHQFeWJhjx1JhwlMBcNr
         6emA==
X-Gm-Message-State: AOAM531bHvUne+/oiPiEUabzpVMTBqaXB47+7Oj01jgDOw1MgQN6V5gb
        //Puo9KO8fdBUWwXGzYgEOAKSGz9tf5kYQ==
X-Google-Smtp-Source: ABdhPJysj5cPqxJm7v6v3yT5ZoM/WM6NwNVpeR1/1Fp5BIrsYMs/edBZ72TyqoBseEKYQSSYEktt6A==
X-Received: by 2002:a67:cb0d:: with SMTP id b13mr1829843vsl.81.1642776274130;
        Fri, 21 Jan 2022 06:44:34 -0800 (PST)
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com. [209.85.222.53])
        by smtp.gmail.com with ESMTPSA id u8sm1394624uaa.12.2022.01.21.06.44.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jan 2022 06:44:33 -0800 (PST)
Received: by mail-ua1-f53.google.com with SMTP id n15so15750215uaq.5;
        Fri, 21 Jan 2022 06:44:33 -0800 (PST)
X-Received: by 2002:a67:e905:: with SMTP id c5mr1898280vso.68.1642776273194;
 Fri, 21 Jan 2022 06:44:33 -0800 (PST)
MIME-Version: 1.0
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20211221094717.16187-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20211221094717.16187-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 21 Jan 2022 15:44:22 +0100
X-Gmail-Original-Message-ID: <CAMuHMdV=EsFH6QsbdT-4fhXKNCoTMru3MmEt62ui2Qe2GokLzg@mail.gmail.com>
Message-ID: <CAMuHMdV=EsFH6QsbdT-4fhXKNCoTMru3MmEt62ui2Qe2GokLzg@mail.gmail.com>
Subject: Re: [PATCH 02/16] dt-bindings: arm: renesas: Document SMARC EVK
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 10:47 AM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> From: Biju Das <biju.das.jz@bp.renesas.com>
>
> Document Renesas SMARC EVK board which is based on RZ/V2L (R9A07G054)
> SoC. The SMARC EVK consists of RZ/V2L SoM module and SMARC carrier board,
> the SoM module sits on top of the carrier board.
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-devel for v5.18, merged with the previous
patch.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
