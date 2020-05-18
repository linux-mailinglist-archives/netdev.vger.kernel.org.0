Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D6B1D77AC
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgERLrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:47:40 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45592 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbgERLre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:47:34 -0400
Received: by mail-ot1-f66.google.com with SMTP id c3so7715825otr.12;
        Mon, 18 May 2020 04:47:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qir9cbaQHXVGA1/iOYKuzF6odjOmx8lAyNZpRQv2tdQ=;
        b=pac8S5O9hfO9GzSPea8N30VEeh5U4p2whwuRjCjRtsIPxO5HjxrQlQ/6QA8cdAOCDs
         wv7rhviq+OGfOVGtvKz1HXHBjvbnAvbadjKPw6Sz6/tI7zg4nmpSfZ34szbo7yqAQnnj
         BNmQgVfgje4RdWhoSOvIuBDa1nc/VowFE+T470OIz9NXaoVB8ZQQu5wy/OSMkPN9zqFE
         +eQy7vC/r4Tqr1ixxgkunmfdZ/zs2gyD919/2MeX3hFmHNSs5bUQk02eDcFswC1Zwart
         vPYR3Ks9AAhpi99XL/LGkck8WAvr2NZocYcvnhxNW+5QFEyq2eIRdJlZWPH+Xq3/yAyg
         w/8w==
X-Gm-Message-State: AOAM5321tk2W51TXs1rnixEh84mRQdX7kUzO4waTfD9IrrOIi4u6CEil
        vXsj5z9paRgePJq+6GrAfUQN8O8A7e/lc8+Momc=
X-Google-Smtp-Source: ABdhPJz2O4DBISUCLAR/kMEi9tuaM6RkZ5fY65PyWK3fsl2Xw8Rol1/2G9QYKQWCwWde1YPgoARYOiu95keFbjPun1E=
X-Received: by 2002:a9d:564:: with SMTP id 91mr11986786otw.250.1589802453218;
 Mon, 18 May 2020 04:47:33 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-18-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1589555337-5498-18-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 18 May 2020 13:47:19 +0200
Message-ID: <CAMuHMdVV+2HsgmBytCOFg4pri4XinT_SPWT_Ac6n7FMZN3dR3w@mail.gmail.com>
Subject: Re: [PATCH 17/17] ARM: dts: r8a7742: Add RWDT node
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

Hi Prabhakar,

On Fri, May 15, 2020 at 5:10 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Add a device node for the Watchdog Timer (RWDT) controller on the Renesas
> RZ/G1H (r8a7742) SoC.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>

Thanks for your patch!

> --- a/arch/arm/boot/dts/r8a7742.dtsi
> +++ b/arch/arm/boot/dts/r8a7742.dtsi
> @@ -201,6 +201,16 @@
>                 #size-cells = <2>;
>                 ranges;
>
> +               rwdt: watchdog@e6020000 {
> +                       compatible = "renesas,r8a7742-wdt",
> +                                    "renesas,rcar-gen2-wdt";
> +                       reg = <0 0xe6020000 0 0x0c>;
> +                       clocks = <&cpg CPG_MOD 402>;
> +                       power-domains = <&sysc R8A7742_PD_ALWAYS_ON>;
> +                       resets = <&cpg 402>;
> +                       status = "disabled";

Missing "interrupts" property.

> +               };
> +
>                 gpio0: gpio@e6050000 {
>                         compatible = "renesas,gpio-r8a7742",
>                                      "renesas,rcar-gen2-gpio";

The rest looks fine, so with the above fixed:
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
