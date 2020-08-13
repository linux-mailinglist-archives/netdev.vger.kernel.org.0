Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9211E243565
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 09:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgHMHvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 03:51:11 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38760 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgHMHvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 03:51:09 -0400
Received: by mail-ot1-f65.google.com with SMTP id q9so4110499oth.5;
        Thu, 13 Aug 2020 00:51:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eU62SrftExeZEPFtSlHLsBRzbUkLx1KNOgZc6VKFeBQ=;
        b=RKVY0mqqakUrEXk4TORV8A5/ZSMY0dexhKfXyaOKBp8tYT6+lN9tMY1gCu59dMSnI/
         6Av5sXCLtCtfska6KBUfoUvPLN8QSlHGcwX+BKv8ZNWhNtirhMGElzBnWp56J7vtBCeA
         RTsTm+tpM0JqO6hs1Zx9oL0KiDPnHu2wr8nXIFBaGz9jqMUEyZCYMyj21d8ckpZmX8IH
         sIyh51oPoVvqSR3qDoGMDZJhbXuz4s9KHdaT9j4oPeIaqxws0OL9u53GcL8uZhE7hrov
         ikjJM0LMxR/OG4BC9tZAySXGXWwQpPbcG9j3oyJJCCrBhecUJhWEIB5ZPymwSBlP+imO
         EXuw==
X-Gm-Message-State: AOAM531KpbVTNZA6DQGhlLakjE36ZGk11NQSWXrXhgb2m/BrbDAUDZAN
        GTNNlK5/qceLxjH+paJhJQLuqYhFPre+GsLWPoc=
X-Google-Smtp-Source: ABdhPJzAAKS8g3t/W5mSJd2Vboc2FEvoNvVXoru7u4kNP7jabPCwVCki2JjTk/fEfMzVv8QAFC24k07bLAU2LYhSK+k=
X-Received: by 2002:a05:6830:1b79:: with SMTP id d25mr2990956ote.107.1597305067462;
 Thu, 13 Aug 2020 00:51:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200812203618.2656699-1-robh@kernel.org>
In-Reply-To: <20200812203618.2656699-1-robh@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 13 Aug 2020 09:50:55 +0200
Message-ID: <CAMuHMdVXvSRF-G_TYu4P+Bqa2FZJWsUCyzqFur3Rb-tBExfbsw@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: Whitespace clean-ups in schema files
To:     Rob Herring <robh@kernel.org>
Cc:     "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-hwmon@vger.kernel.org,
        linux-rtc@vger.kernel.org,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-iio@vger.kernel.org,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "open list:REMOTE PROCESSOR (REMOTEPROC) SUBSYSTEM" 
        <linux-remoteproc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-clk <linux-clk@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Wed, Aug 12, 2020 at 10:36 PM Rob Herring <robh@kernel.org> wrote:
> Clean-up incorrect indentation, extra spaces, long lines, and missing
> EOF newline in schema files. Most of the clean-ups are for list
> indentation which should always be 2 spaces more than the preceding
> keyword.
>
> Found with yamllint (which I plan to integrate into the checks).

> Signed-off-by: Rob Herring <robh@kernel.org>

Thanks for your patch!

> --- a/Documentation/devicetree/bindings/clock/renesas,cpg-clocks.yaml
> +++ b/Documentation/devicetree/bindings/clock/renesas,cpg-clocks.yaml
> @@ -24,9 +24,9 @@ properties:
>        - const: renesas,r8a7778-cpg-clocks # R-Car M1
>        - const: renesas,r8a7779-cpg-clocks # R-Car H1
>        - items:
> -        - enum:
> -            - renesas,r7s72100-cpg-clocks # RZ/A1H
> -        - const: renesas,rz-cpg-clocks    # RZ/A1
> +          - enum:
> +              - renesas,r7s72100-cpg-clocks # RZ/A1H
> +          - const: renesas,rz-cpg-clocks    # RZ/A1

This change breaks alignment of the comments at the end of each line.

>        - const: renesas,sh73a0-cpg-clocks  # SH-Mobile AG5

(I only checked the files I care about)

If you don't update commit  e0fe7fc6f2ca0781 ("dt-bindings: Whitespace
clean-ups in schema files"), I can send a patch after v5.9-rc1.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
