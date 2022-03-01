Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298384C8633
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 09:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbiCAIRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 03:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233316AbiCAIRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 03:17:41 -0500
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BAB83031;
        Tue,  1 Mar 2022 00:17:00 -0800 (PST)
Received: by mail-vs1-f51.google.com with SMTP id g20so15700248vsb.9;
        Tue, 01 Mar 2022 00:17:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dXYHl0PObkcXtthmu/EYhU2xFq7l25BTUZ/mPLnw+sA=;
        b=HuSwu0ORNfnaPZQ4jBjHYDAHjh3pGts3F/I9S83ejZaAiaCh5XToRUP3+s/Wrbpk6A
         XBwoRV5dAlyuOLcbTCnpk4oagy5zYqzoyoPk7DOAa6wW8ZsuW+B8lXtJd14uFAkSf4VD
         nTn1EtKKh1iENje0zAxoUnvKcaR9GE6od++GxSPq4BCEUNYtgY5EHIoQy3TfSWNxgZYK
         qj5nz1HGcgQwZfE0kGA5A42bZFzXnGtPxfKxQBSjyVgwvHm30aYyxDTDJ+lpXKn1F5O4
         NIJx/fiuQ2VHF5uQCJVfbWC9cQyM44wkkFMW/Nj74wTVH1iDCm/j67GkaRX29BXew+oG
         xpLg==
X-Gm-Message-State: AOAM530rOAqUYAKIDluwSlVWbz19EXlh0lsDIVgyakSHm/4hNDN2ZChM
        u4dMlUGxccKSfmb/4OIrAIxHemn7GnqQ4g==
X-Google-Smtp-Source: ABdhPJwOnmS22BMtwaEoriYcL4mRAi8+oO25Bxyh2nJSr/GS+QKGG5N9WYZz8FAORHdVvJG/eOPDwQ==
X-Received: by 2002:a67:c282:0:b0:31b:e2cb:34ed with SMTP id k2-20020a67c282000000b0031be2cb34edmr9036672vsj.16.1646122619433;
        Tue, 01 Mar 2022 00:16:59 -0800 (PST)
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com. [209.85.221.173])
        by smtp.gmail.com with ESMTPSA id s18-20020a05612204d200b00332f05df61bsm1776243vkn.49.2022.03.01.00.16.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 00:16:59 -0800 (PST)
Received: by mail-vk1-f173.google.com with SMTP id bj24so6455245vkb.8;
        Tue, 01 Mar 2022 00:16:58 -0800 (PST)
X-Received: by 2002:a05:6122:114e:b0:32d:4662:65a8 with SMTP id
 p14-20020a056122114e00b0032d466265a8mr9528539vko.0.1646122618726; Tue, 01 Mar
 2022 00:16:58 -0800 (PST)
MIME-Version: 1.0
References: <20220227213250.23637-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20220227213250.23637-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 1 Mar 2022 09:16:47 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXy4H03=rQKtZG9qrV14XA9j_S21+kRXkHsP3GA+gY-OQ@mail.gmail.com>
Message-ID: <CAMuHMdXy4H03=rQKtZG9qrV14XA9j_S21+kRXkHsP3GA+gY-OQ@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: can: renesas,rcar-canfd: Document
 RZ/V2L SoC
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Prabhakar,

On Sun, Feb 27, 2022 at 10:33 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Document RZ/V2L CANFD bindings. RZ/V2L CANFD is identical to one found on
> the RZ/G2L SoC. No driver changes are required as generic compatible
> string "renesas,rzg2l-canfd" will be used as a fallback.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>

Thanks for your patch!

> --- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> +++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> @@ -33,6 +33,7 @@ properties:
>        - items:
>            - enum:
>                - renesas,r9a07g044-canfd    # RZ/G2{L,LC}
> +              - renesas,r9a07g054-canfd    # RZ/V2L
>            - const: renesas,rzg2l-canfd     # RZ/G2L family

The last comment looks a bit strange, unless you consider RZ/V2L to be
part of the RZ/G2L family, so perhaps drop it?

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
