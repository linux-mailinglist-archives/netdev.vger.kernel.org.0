Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD014689617
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 11:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbjBCKaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 05:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbjBCKaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 05:30:01 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70272113F2;
        Fri,  3 Feb 2023 02:29:17 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id c2so4912265qtw.5;
        Fri, 03 Feb 2023 02:29:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OONFnhP6I7zS1Y45r5yPBZWg15dDNXvDl8f/Zu5HTcU=;
        b=Wp23sLXNjAl0bxpO8bSwKoLWp94GH/+zDoeayrEvKX1eTQYMuEIfgZtAzpyiC8V/w3
         ZDOd6uUAEHXCTLp7XkFQ2mcMOx+KnIqqK3vQqAcpw+E78ss+cj8eWglD9zyRB0CBc6sT
         Q9dXxU12rI5V6b/Z1u4J9kEj5ResUSl0Q0xAG6F7Y0aQ4AbrIABQiqiAeKQU6XjuLBn1
         T+kkZRme/8bip+OGa1IWt1/hjRNOKnhOt8Ntw3Jf78bv8Z0PsqSQfP8zAy0tWHaXJVJx
         5KVYnMfsKVCGDn//a3yHJ0axYYI0bQWYXeoQYAmnP86y5wBPNtB0jFxSlQa3cj3Jv3Ok
         LmjQ==
X-Gm-Message-State: AO0yUKVdmdQwLCRH8f+Pd3QI36j1SwGcRGNmqOOz3mP5feSESim9wIEY
        ubvRbA68/cl6kr36tqTzlQtyPVo9BKh2WA==
X-Google-Smtp-Source: AK7set+5y6WlzlnaaWHFL9VgmZh50b+SAvZ7gYg/TkeZ8tI9v1LmT2BnSF8v/TPWEX0O72SNJgZC/A==
X-Received: by 2002:a05:622a:14ca:b0:3b8:1d89:e01b with SMTP id u10-20020a05622a14ca00b003b81d89e01bmr18325326qtx.23.1675420095800;
        Fri, 03 Feb 2023 02:28:15 -0800 (PST)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id dt23-20020a05620a479700b0071a49ac0e05sm1489828qkb.111.2023.02.03.02.28.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 02:28:15 -0800 (PST)
Received: by mail-yb1-f180.google.com with SMTP id a1so5675459ybj.9;
        Fri, 03 Feb 2023 02:28:15 -0800 (PST)
X-Received: by 2002:a25:820a:0:b0:7d5:b884:3617 with SMTP id
 q10-20020a25820a000000b007d5b8843617mr1035225ybk.380.1675420094927; Fri, 03
 Feb 2023 02:28:14 -0800 (PST)
MIME-Version: 1.0
References: <20230203101624.474611-1-tudor.ambarus@linaro.org>
In-Reply-To: <20230203101624.474611-1-tudor.ambarus@linaro.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 3 Feb 2023 11:28:03 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVeDbTGLBAk5QWGQGf=o6g25t341FjGTmNsHw0_sDOceg@mail.gmail.com>
Message-ID: <CAMuHMdVeDbTGLBAk5QWGQGf=o6g25t341FjGTmNsHw0_sDOceg@mail.gmail.com>
Subject: Re: [PATCH] tree-wide: trivial: s/ a SPI/ an SPI/
To:     Tudor Ambarus <tudor.ambarus@linaro.org>
Cc:     trivial@kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-gpio@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-mips@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-wireless@vger.kernel.org, chrome-platform@lists.linux.dev,
        linux-rtc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-usb@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tudor,

On Fri, Feb 3, 2023 at 11:17 AM Tudor Ambarus <tudor.ambarus@linaro.org> wrote:
> The deciding factor for when a/an should be used is the sound
> that begins the word which follows these indefinite articles,
> rather than the letter which does. Use "an SPI" (SPI begins
> with the consonant letter S, but the S is pronounced with its
> letter name, "es.").

While I agree with your pronunciation, I believe the SPI maintainer
(which you forgot to CC) pronounces it in James Bond-style, i.e. rhymes
with "spy" ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
