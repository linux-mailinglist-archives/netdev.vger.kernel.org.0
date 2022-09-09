Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC54A5B34B5
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 11:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiIIJ63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 05:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiIIJ6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 05:58:16 -0400
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD79312D1A8;
        Fri,  9 Sep 2022 02:58:15 -0700 (PDT)
Received: by mail-qt1-f178.google.com with SMTP id z18so849168qts.7;
        Fri, 09 Sep 2022 02:58:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=hWCebKRgDhaHhUfpkk42XMQuZuZ9gpE4kq9orZDy92E=;
        b=Q4BKoC4m4vBbtZwBDAjsxYTj/9n4dUPFJk3gsUo3d2bv+sb3Ff5s0ihRutTTh8W/MY
         jSXXpbYfccx319z/bJc30LDZjtu85cKEVIN51Yqttk7KzfbMzHJ8/OZYwOTlkKuUDjoC
         OfN/lF2lmvF+vfKyy2/7Uv9QZ8/V1FZYF2trhmm7271/23U5TTvqPYl6KqBGTlAi/rgt
         JPKSR7KLjGoBeMwY68C5gAB8jCfZuaQzMNeg7CF6n313tubTTsRtJ4t8JEd0MvROWlJV
         JxEmiTyf0QgQqYggU48/N73EoZDxZiZ9LCTHuSpIAJRUALCuaa6bXOyiYetYYW06wkMX
         ieoA==
X-Gm-Message-State: ACgBeo0z0zuONFAYLzklVRWJdFXEAtfXqjZU0S6sXGXbiyTVVb3rjGqf
        UlHauU4DP6iNzDaARvi/6e3Oay02UTzLng==
X-Google-Smtp-Source: AA6agR5hivwoGz4hivzSo3WanXgE8KkGNnmEKw59fsrl0JszPsDvN8KCAvql3HGAe2Hgq2Q9vmEDSQ==
X-Received: by 2002:ac8:7f47:0:b0:344:8d2b:14a9 with SMTP id g7-20020ac87f47000000b003448d2b14a9mr11623752qtk.442.1662717494530;
        Fri, 09 Sep 2022 02:58:14 -0700 (PDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id m21-20020a05620a291500b006cbe10f2992sm34397qkp.135.2022.09.09.02.58.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 02:58:14 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id 130so1888590ybw.8;
        Fri, 09 Sep 2022 02:58:13 -0700 (PDT)
X-Received: by 2002:a25:8247:0:b0:6a9:443a:cc0b with SMTP id
 d7-20020a258247000000b006a9443acc0bmr11239427ybn.89.1662717493485; Fri, 09
 Sep 2022 02:58:13 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1662714607.git.geert+renesas@glider.be> <5355709e0744680d792d1e57e43441cb0b7b7611.1662714607.git.geert+renesas@glider.be>
 <d670b3b1-8347-7131-6bed-4c946645c883@linaro.org>
In-Reply-To: <d670b3b1-8347-7131-6bed-4c946645c883@linaro.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 9 Sep 2022 11:58:01 +0200
X-Gmail-Original-Message-ID: <CAMuHMdW63AVJ1eoAiVCAiemjH4MG3=mLakU4+MUvA_jepsjyvg@mail.gmail.com>
Message-ID: <CAMuHMdW63AVJ1eoAiVCAiemjH4MG3=mLakU4+MUvA_jepsjyvg@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: net: renesas,etheravb: R-Car V3U is
 R-Car Gen4
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

On Fri, Sep 9, 2022 at 11:24 AM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
> On 09/09/2022 11:13, Geert Uytterhoeven wrote:
> > Despite the name, R-Car V3U is the first member of the R-Car Gen4
> > family.  Hence move its compatible value to the R-Car Gen4 section.
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

> > --- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
> > +++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
> > @@ -40,9 +40,13 @@ properties:
> >                - renesas,etheravb-r8a77980     # R-Car V3H
> >                - renesas,etheravb-r8a77990     # R-Car E3
> >                - renesas,etheravb-r8a77995     # R-Car D3
> > -              - renesas,etheravb-r8a779a0     # R-Car V3U
> >            - const: renesas,etheravb-rcar-gen3 # R-Car Gen3 and RZ/G2
> >
> > +      - items:
> > +          - enum:
> > +              - renesas,etheravb-r8a779a0     # R-Car V3U
> > +          - const: renesas,etheravb-rcar-gen4 # R-Car Gen4
> > +
>
> Don't you need changes in allOf:if:then section?

No, as there is no logic involving renesas,etheravb-rcar-gen3.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
