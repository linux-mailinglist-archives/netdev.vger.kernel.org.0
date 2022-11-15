Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F81E629956
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 13:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238136AbiKOMyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 07:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238256AbiKOMyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 07:54:03 -0500
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F6BF08;
        Tue, 15 Nov 2022 04:54:01 -0800 (PST)
Received: by mail-qv1-f54.google.com with SMTP id c8so9675584qvn.10;
        Tue, 15 Nov 2022 04:54:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kNu7gqY5FuH+enfhy3h6rYwlDBJbYmHEghI0eWJOGto=;
        b=SljO9RvVBg2lSIB3MjXszVfqTGsBSgdblt1SPJRFIsmX4BJ3NFtxPc4tniJmU4Gwc6
         Pzwg9ObTnHnCTq6Q7+ZcCY2RhiVTA7ZR0smXq9UCarQgE83hoS2Xy33nuIR20jdFY7r3
         dUJf54jgyWZOzR7Oer/9QwrqESg8gt6bkrXw7IK8ckIikTKRyWfINFMU4i6GimHAE0nS
         P4p0SpIBtpt0IfX5y4WUPwKBN2+Qif9aFNTyebgg4hT515UdLlsRxsDWuH/u1H/88ZCV
         YzLal6T4v61hU9Y5HwHiklb+EgC4yMf0Kg8LX9MWSp4WyjeafHxslNLWACoXKm/7bCPV
         V8mg==
X-Gm-Message-State: ANoB5pnMHkRFzmNO1lQdP8K6d2+wDaalzlAZD3EbHxzobJlznJL5L80O
        Z01eTn8QrLCC0h5Ge/SvgwWt3Pf8AzR7TQ==
X-Google-Smtp-Source: AA0mqf4L4XoJkaz0N84B4fZlnMo61pNwhvn1OY1j1Ec4XjZkzokjSHMXByi/99Z50ECi0e+yxT20MA==
X-Received: by 2002:a0c:d807:0:b0:4be:a152:aca9 with SMTP id h7-20020a0cd807000000b004bea152aca9mr16460076qvj.102.1668516840765;
        Tue, 15 Nov 2022 04:54:00 -0800 (PST)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com. [209.85.219.182])
        by smtp.gmail.com with ESMTPSA id y20-20020a05620a25d400b006faa88ba2b5sm8247906qko.7.2022.11.15.04.54.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Nov 2022 04:54:00 -0800 (PST)
Received: by mail-yb1-f182.google.com with SMTP id b131so16355920yba.11;
        Tue, 15 Nov 2022 04:54:00 -0800 (PST)
X-Received: by 2002:a25:ba4c:0:b0:6dc:dc81:aaf4 with SMTP id
 z12-20020a25ba4c000000b006dcdc81aaf4mr15188013ybj.365.1668516840123; Tue, 15
 Nov 2022 04:54:00 -0800 (PST)
MIME-Version: 1.0
References: <20221115123811.1182922-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20221115123811.1182922-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 15 Nov 2022 13:53:48 +0100
X-Gmail-Original-Message-ID: <CAMuHMdV8r-QXi6KBsZs2SE8t34e8is05xwCrWqfTL3XP-mAGVA@mail.gmail.com>
Message-ID: <CAMuHMdV8r-QXi6KBsZs2SE8t34e8is05xwCrWqfTL3XP-mAGVA@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: can: renesas,rcar-canfd: Document RZ/Five SoC
To:     Prabhakar <prabhakar.csengg@gmail.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 1:51 PM Prabhakar <prabhakar.csengg@gmail.com> wrote:
> From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>
> The CANFD block on the RZ/Five SoC is identical to one found on the
> RZ/G2UL SoC. "renesas,r9a07g043-canfd" compatible string will be used
> on the RZ/Five SoC so to make this clear, update the comment to include
> RZ/Five SoC.
>
> No driver changes are required as generic compatible string
> "renesas,rzg2l-canfd" will be used as a fallback on RZ/Five SoC.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
