Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D27B5980F4
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 11:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242813AbiHRJjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 05:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiHRJjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 05:39:07 -0400
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596415B04A;
        Thu, 18 Aug 2022 02:39:06 -0700 (PDT)
Received: by mail-qv1-f46.google.com with SMTP id p4so806079qvr.5;
        Thu, 18 Aug 2022 02:39:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=yJaFIy2nGiUJbEANfPip7v6rB5kJDt4D1/AQTHyeqUY=;
        b=mNHK6FqR3WzelQfXQusSX5aprGLY8tPzMYb9LgNkbMQG0scVz/Jrm1MMQxSrcpxkqn
         Bg86Am7GHZK1yhN2wyxjbRr8cY3elgmBvmvPtCTzUf+fdfySSk6FFiNTp6NxL5aXTvlU
         VN2qBrjEJH0ACUq5uCQ8r0xhKnKht+J6sM8LPGf5gH1UQOUmqr9A9YY9NzziOlH9nv33
         QOkluF3u14+NGWAUudQfl9IvsYHhej3TVRMyZP5e+MjYHJSsgPqpBcxKgBLL3DstMzBq
         qouJPvOv9RQRyhOcGtqDT2KIEr+TOIxQcyo4EJQl8Ca3zh/i3wC4i2C069c5YeNfUIuh
         L8og==
X-Gm-Message-State: ACgBeo1zS2xiQFuPcjKCOPSS058DJWLC3cauKkJOh0NajWWRAZRkrMH7
        Adru5eCtnmSJhhqT086mAJZR23lt22hgxw==
X-Google-Smtp-Source: AA6agR6guGxFe2BvdM+E3ILwBccP8ha0FlncllTQBwXxwWpQgdgBjlno9RT5AAOQ9GbyQwmruPftcg==
X-Received: by 2002:ad4:5cae:0:b0:496:a988:ddc0 with SMTP id q14-20020ad45cae000000b00496a988ddc0mr1549683qvh.3.1660815545392;
        Thu, 18 Aug 2022 02:39:05 -0700 (PDT)
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com. [209.85.128.175])
        by smtp.gmail.com with ESMTPSA id x8-20020a05620a258800b006b9a89d408csm1099751qko.100.2022.08.18.02.39.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 02:39:04 -0700 (PDT)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-32a09b909f6so27160447b3.0;
        Thu, 18 Aug 2022 02:39:03 -0700 (PDT)
X-Received: by 2002:a25:250b:0:b0:68f:425b:3ee0 with SMTP id
 l11-20020a25250b000000b0068f425b3ee0mr2056784ybl.89.1660815543145; Thu, 18
 Aug 2022 02:39:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220710115248.190280-1-biju.das.jz@bp.renesas.com> <20220710115248.190280-3-biju.das.jz@bp.renesas.com>
In-Reply-To: <20220710115248.190280-3-biju.das.jz@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 18 Aug 2022 11:38:52 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVvh5n159TLVzosnHyjX3Hxadjky4DjpedSvezPZ=fRLQ@mail.gmail.com>
Message-ID: <CAMuHMdVvh5n159TLVzosnHyjX3Hxadjky4DjpedSvezPZ=fRLQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] dt-bindings: can: nxp,sja1000: Document RZ/N1{D,S} support
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
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

Hi Biju,

On Sun, Jul 10, 2022 at 1:53 PM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> Add CAN binding documentation for Renesas RZ/N1 SoC.
>
> The SJA1000 CAN controller on RZ/N1 SoC has some differences compared
> to others like it has no clock divider register (CDR) support and it has
> no HW loopback (HW doesn't see tx messages on rx), so introduced a new
> compatible 'renesas,rzn1-sja1000' to handle these differences.
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>

Thanks for your patch, which is now commit 4591c760b7975984
("dt-bindings: can: nxp,sja1000: Document RZ/N1{D,S} in v6.0-rc1.

> --- a/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
> +++ b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
> @@ -11,9 +11,15 @@ maintainers:
>
>  properties:
>    compatible:
> -    enum:
> -      - nxp,sja1000
> -      - technologic,sja1000
> +    oneOf:
> +      - enum:
> +          - nxp,sja1000
> +          - technologic,sja1000
> +      - items:
> +          - enum:
> +              - renesas,r9a06g032-sja1000 # RZ/N1D
> +              - renesas,r9a06g033-sja1000 # RZ/N1S
> +          - const: renesas,rzn1-sja1000 # RZ/N1
>
>    reg:
>      maxItems: 1
> @@ -21,6 +27,9 @@ properties:
>    interrupts:
>      maxItems: 1
>
> +  clocks:
> +    maxItems: 1
> +

Probably you want to add the power-domains property, and make it
required on RZ/N1.
This is not super-critical, as your driver patch uses explicit clock
handling anyway.

>    reg-io-width:
>      $ref: /schemas/types.yaml#/definitions/uint32
>      description: I/O register width (in bytes) implemented by this device


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
