Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6FC48B1C9
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349852AbiAKQPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:15:41 -0500
Received: from mail-ua1-f52.google.com ([209.85.222.52]:46739 "EHLO
        mail-ua1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349873AbiAKQPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:15:35 -0500
Received: by mail-ua1-f52.google.com with SMTP id c36so30596479uae.13;
        Tue, 11 Jan 2022 08:15:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7z9xMv0QiQz5AATtylhKuNOpN7Zrf/MWbCMMy2DzpdQ=;
        b=gfvmvKt0ZWEGT09Q8xSX7fRM/wOCoGlKMGnWiqSm0ATKYF4t7tQPRGAdxbtcxSA53n
         hbc5Hg3ZerCMXsXjbJolHQADUHwHYIYFDrQQw+kgesvHa+RMfLyLTWxUXQBWRU3JbsDi
         Lp1jQ3DDOi+1zalx2N2wCIXH0uPNZ1rm1wqkP3iE2ZBPHvO5oxD5wmSew0MpOZAheYfU
         SQI9HvXt2MNKbg9eEv55X5Z7L/HQQSZ2DSCW6IZHUO051UAEq+Hqm3FQjSfOP07pY1OY
         VWheXzqxm+m9NmehgA7fStfDkI2AR/go808pB5E1fTQEOiuhwMXdx9WrK8OK0dcwFsrl
         AJ2g==
X-Gm-Message-State: AOAM5332cbOMKR+GEFZ9JtFcnsHEzfDiSBAiLilwKUTophrSOre994LV
        lvTnMNVL0kc4DVHQd2qAI4fmqqNEsj3PQA==
X-Google-Smtp-Source: ABdhPJxnJv+H8evrndDcLicau41H+y6Q5pH+YhWE11kY3dhsqJ9RzTnnLECNPBfytm6Ak+uvKZFE1w==
X-Received: by 2002:a05:6102:41a9:: with SMTP id cd41mr2514180vsb.81.1641917734102;
        Tue, 11 Jan 2022 08:15:34 -0800 (PST)
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com. [209.85.222.48])
        by smtp.gmail.com with ESMTPSA id t201sm3515366vkb.45.2022.01.11.08.15.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 08:15:33 -0800 (PST)
Received: by mail-ua1-f48.google.com with SMTP id i5so30650694uaq.10;
        Tue, 11 Jan 2022 08:15:32 -0800 (PST)
X-Received: by 2002:a05:6102:2329:: with SMTP id b9mr2453059vsa.5.1641917732566;
 Tue, 11 Jan 2022 08:15:32 -0800 (PST)
MIME-Version: 1.0
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20211221094717.16187-8-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20211221094717.16187-8-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 11 Jan 2022 17:15:21 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWXwgpTkVUZB6HotQNEcr7GuMfkd7ShS-jOqFwkiobzKQ@mail.gmail.com>
Message-ID: <CAMuHMdWXwgpTkVUZB6HotQNEcr7GuMfkd7ShS-jOqFwkiobzKQ@mail.gmail.com>
Subject: Re: [PATCH 07/16] dt-bindings: serial: renesas,sci: Document RZ/V2L SoC
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

On Tue, Dec 21, 2021 at 10:48 AM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> From: Biju Das <biju.das.jz@bp.renesas.com>
>
> Add SCI binding documentation for Renesas RZ/V2L SoC. No driver changes
> are required as generic compatible string "renesas,sci" will be used as
> a fallback.
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
