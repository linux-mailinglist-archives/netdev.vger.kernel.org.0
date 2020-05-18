Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877EE1D765C
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgERLNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:13:20 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:38528 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgERLNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:13:19 -0400
Received: by mail-ot1-f68.google.com with SMTP id w22so7683895otp.5;
        Mon, 18 May 2020 04:13:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pR1cgKO8rpCf/7AlmTREELkczgYUosKtpXfrAtbkObM=;
        b=YqG56V49Bv69ICEnhFwSBTFUMFjqPl97uPbIc5FBHA3YykwgzKEfTtzOw3qXHjj+lH
         EeTe7Y+WZAMDx3tMYWdmRTpH0CoXxXOr0pEnyKOOziVH5hbZZISTNf2vipREkyTM71ev
         HuTosVuCcEiz0mMYiSDdjqHX8YWo0BRqzWTYko+SNnU0LxHezabwDKmVtg7DNd5GSJj7
         i//Gadedd15SKaH3IeJmCRcLLPi4Ip+AY3gvh+LwK8v8V1P045xFGsRI72NOPWgz9/bN
         uoZ8qQdNBwCUsDcueUla5UJ0fmsZtaUQHmcjjZhrVWTQMv6lCQaz/ytSZCIq5RENkorG
         ruEw==
X-Gm-Message-State: AOAM5314/I/v+1TQMANxnDrKXs2FUtZ1dVuuF3vSRYSAmSy5OYn3TrZY
        jGaEY4DZ7+GoshKJb4ra355GcRlyG0nGQwk00QM=
X-Google-Smtp-Source: ABdhPJwRrYq4SFa2PkXCkouuudLXM04hVkXibjgJLxfqq5xK2wIlnVt4nFW4BOiciwsS6hKoNryVVo1hafLabc2sBmU=
X-Received: by 2002:a9d:7e92:: with SMTP id m18mr11590288otp.145.1589800398609;
 Mon, 18 May 2020 04:13:18 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-9-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1589555337-5498-9-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 18 May 2020 13:13:07 +0200
Message-ID: <CAMuHMdUTnVyOY5=cA1U_bVrQGrfcMxpoVxy-t1xFqya5mV6KKA@mail.gmail.com>
Subject: Re: [PATCH 08/17] dt-bindings: ata: renesas,rcar-sata: Add r8a7742 support
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 5:10 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Document SATA support for the RZ/G1H, which is compatible with
> R-Car Gen2 SoC family.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
