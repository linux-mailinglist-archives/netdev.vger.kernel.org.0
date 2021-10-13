Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAD442C4EA
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 17:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhJMPkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 11:40:21 -0400
Received: from mail-ua1-f43.google.com ([209.85.222.43]:38700 "EHLO
        mail-ua1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhJMPkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 11:40:20 -0400
Received: by mail-ua1-f43.google.com with SMTP id h19so5327628uax.5;
        Wed, 13 Oct 2021 08:38:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l17U/nka2OkSajssGDLJw20Bxljp4r8q0ycLklITrQY=;
        b=mfnSSMOwKoqrWvMfkSrLpGjH/L6vNyfnrV9WUi5gqTxdrtVHA6VYQD/ZSF/VeqSssk
         gcytXXBnDqxZ77fPrlvUar98Bf4TpAW5il+Behoo8U6MvTcLa08s0/K2+R0AlkeY2YWw
         hUsJ4MiWKx14wyksrqwNzfbYXtnawxWwLxgsmBA1CK5AuiEzw6N/hDc7nj5IaRkyqQiy
         NNlfCwwgPRlj8J10k0QEO5s30kk/bbaOBADp3CKMa1TJOK86NshRsGioMLHGPb6MvSBZ
         HjapAIXk9q7gnB69li0oFGk6BOCZQtv3FuiGs+052sEDANcPh85rGuDGqnyTQcs0tWXP
         hJUg==
X-Gm-Message-State: AOAM53066f0DHdJVplsobNk5jFfudjvcd5t1LREBYyFzQXjEhYM5BGYs
        FeE7XIeIlrFHUjQfnk7DNgSi2ZWeCGbdNqPfXzGMe8L4I6eeNg==
X-Google-Smtp-Source: ABdhPJw2Rr8lHJ8+2NgbvwjPXz5Zv6MvN+huaOXS/8KKef2X84kYutQm73pvfOZve6GwNRFDlOyTFLSRHw90yEeltIw=
X-Received: by 2002:ab0:2bd2:: with SMTP id s18mr10036764uar.78.1634139496435;
 Wed, 13 Oct 2021 08:38:16 -0700 (PDT)
MIME-Version: 1.0
References: <1539889562-21458-1-git-send-email-yuiko.oshino@microchip.com> <1539889562-21458-3-git-send-email-yuiko.oshino@microchip.com>
In-Reply-To: <1539889562-21458-3-git-send-email-yuiko.oshino@microchip.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 13 Oct 2021 17:38:05 +0200
Message-ID: <CAMuHMdX3xeSM3sd9UuURw5Vvh43=81XJd75Ug-4-mYLhw+oTRA@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 2/2] dt-bindings: net: add support for
 Microchip KSZ9131
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marco Felsch <m.felsch@pengutronix.de>, Markus.Niebel@tqs.de,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yuiko,

On Thu, Oct 18, 2018 at 8:16 PM Yuiko Oshino <yuiko.oshino@microchip.com> wrote:
> Add support for Microchip Technology KSZ9131 10/100/1000 Ethernet PHY
>
> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>

Thanks for your patch, which is commit 806700bab41e9297
("dt-bindings: net: add support for Microchip KSZ9131") in v4.20.

> --- a/Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
> +++ b/Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
> @@ -1,4 +1,4 @@
> -Micrel KSZ9021/KSZ9031 Gigabit Ethernet PHY
> +Micrel KSZ9021/KSZ9031/KSZ9131 Gigabit Ethernet PHY
>
>  Some boards require special tuning values, particularly when it comes
>  to clock delays. You can specify clock delay values in the PHY OF
> @@ -64,6 +64,32 @@ KSZ9031:
>          Attention: The link partner must be configurable as slave otherwise
>          no link will be established.
>
> +KSZ9131:
> +
> +  All skew control options are specified in picoseconds. The increment
> +  step is 100ps. Unlike KSZ9031, the values represent picoseccond delays.
> +  A negative value can be assigned as rxc-skew-psec = <(-100)>;.
> +
> +  Optional properties:
> +
> +    Range of the value -700 to 2400, default value 0:
> +
> +      - rxc-skew-psec : Skew control of RX clock pad
> +      - txc-skew-psec : Skew control of TX clock pad
> +
> +    Range of the value -700 to 800, default value 0:
> +
> +      - rxdv-skew-psec : Skew control of RX CTL pad
> +      - txen-skew-psec : Skew control of TX CTL pad
> +      - rxd0-skew-psec : Skew control of RX data 0 pad
> +      - rxd1-skew-psec : Skew control of RX data 1 pad
> +      - rxd2-skew-psec : Skew control of RX data 2 pad
> +      - rxd3-skew-psec : Skew control of RX data 3 pad
> +      - txd0-skew-psec : Skew control of TX data 0 pad
> +      - txd1-skew-psec : Skew control of TX data 1 pad
> +      - txd2-skew-psec : Skew control of TX data 2 pad
> +      - txd3-skew-psec : Skew control of TX data 3 pad

Shouldn't all these use "*-skew-ps" instead of "*-skew-psec", like all
other documented skew properties?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
