Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C961C6323C0
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiKUNdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiKUNd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:33:27 -0500
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0168784822;
        Mon, 21 Nov 2022 05:33:26 -0800 (PST)
Received: by mail-qk1-f175.google.com with SMTP id p18so7956362qkg.2;
        Mon, 21 Nov 2022 05:33:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W52hjy2XgXbLvoau/TZhYUdh0mFs9ky77EejBWrKJL0=;
        b=MKBAflyqCUHtzPOOQZ6ifQuwGDxrXiqLha4B6jgtDirrkjwDpkFryHuD6F/dt8H0QI
         /OIxYrlqSHJDdf035z2Khhf6Kryhq1gElZdNzSmWIBxdcJErG0ksH8kPf2cpKnjiGIly
         jDZA5W2gtjqmoIEHcAdhqOYFTh1/kn8BF7eeKJcFk2VjJkIWVC5Ad5PmSNuuBGrnERyp
         c80M43ypsnc9Em3IJzqGakMQC8lGEP87p4FVat1CCYUeyIGWTts6Q2ROcXfUuxpSE3AA
         5Xqf4HHD5kcwg6YwWXUrJ1/eZxMVpT2w3M5TLvlivG1HOyJ8IFsM6fXzmDinFTgUttcU
         Uqhg==
X-Gm-Message-State: ANoB5plLQ5A+/+zT5/m1BgTpcb1kqSljtoUhzcMqioQs+/IM6aYOCLxV
        8maqDHR5KaxgAEMGSgB6hUqsAxwHQez/9g==
X-Google-Smtp-Source: AA0mqf5ztepVbKEErbeHzkEO/g8ATeu0M6TG2+WT51QBKFlvCWQFw94PLJ5lwReFzcLN831JtiNw6w==
X-Received: by 2002:a05:620a:993:b0:6fa:172:c37d with SMTP id x19-20020a05620a099300b006fa0172c37dmr16277536qkx.92.1669037604910;
        Mon, 21 Nov 2022 05:33:24 -0800 (PST)
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com. [209.85.128.182])
        by smtp.gmail.com with ESMTPSA id l21-20020a37f915000000b006fa7b5ea2d1sm8239937qkj.125.2022.11.21.05.33.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 05:33:23 -0800 (PST)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-36cbcda2157so113000447b3.11;
        Mon, 21 Nov 2022 05:33:23 -0800 (PST)
X-Received: by 2002:a81:4f4c:0:b0:357:66a5:bb25 with SMTP id
 d73-20020a814f4c000000b0035766a5bb25mr17212924ywb.383.1669037603130; Mon, 21
 Nov 2022 05:33:23 -0800 (PST)
MIME-Version: 1.0
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org> <20221121110615.97962-8-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221121110615.97962-8-krzysztof.kozlowski@linaro.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 21 Nov 2022 14:33:11 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUtT3=F-3XLb604VUvKxNQBWK1y0rMnMn0kASKjQGw=3g@mail.gmail.com>
Message-ID: <CAMuHMdUtT3=F-3XLb604VUvKxNQBWK1y0rMnMn0kASKjQGw=3g@mail.gmail.com>
Subject: Re: [PATCH v2 7/9] dt-bindings: drop redundant part of title (beginning)
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-watchdog@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Viresh Kumar <vireshk@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 12:09 PM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
> The Devicetree bindings document does not have to say in the title that
> it is a "Devicetree binding", but instead just describe the hardware.
>
> Drop beginning "Devicetree bindings" in various forms:
>
>   find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
>     -exec sed -i -e 's/^title: [dD]evice[ -]\?[tT]ree [bB]indings\? for \([tT]he \)\?\(.*\)$/title: \u\2/' {} \;
>
>   find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
>     -exec sed -i -e 's/^title: [bB]indings\? for \([tT]he \)\?\(.*\)$/title: \u\2/' {} \;
>
>   find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
>     -exec sed -i -e 's/^title: [dD][tT] [bB]indings\? for \([tT]he \)\?\(.*\)$/title: \u\2/' {} \;
>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

>  .../devicetree/bindings/interrupt-controller/renesas,irqc.yaml  | 2 +-

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
