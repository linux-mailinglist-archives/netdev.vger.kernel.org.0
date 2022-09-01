Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224695A9481
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 12:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbiIAK0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 06:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbiIAKZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 06:25:48 -0400
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791459F75A;
        Thu,  1 Sep 2022 03:25:42 -0700 (PDT)
Received: by mail-qt1-f178.google.com with SMTP id w28so12998529qtc.7;
        Thu, 01 Sep 2022 03:25:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=jQiwC2wtAwOaQD0hPRp2nlHKTvtSxYoVlYqx7E4G0+s=;
        b=sVJbv02cHu/phK05kLcIKg4I8etuzfFSG4AM+LaNh6NwpZs5ggmdCKvyEn3F2ftlEe
         S486K92bt8PGjO4YMiSZKv5w33xioDt9fB8B6U+NYRJI3h50tcm7ezUT9cJtT7R02Tjf
         qk/ALhacDEm04OtaEyl7ItZ2zT3fZSE7lXiuSV5wZ6p60OSvwWbOdgjxxH5dQLfzUr2h
         AegwkGDlFNMA3j9mBZ57l4Payoz2cDQ0DcgCvTDaia1r4rbBTtue+eixJUy3NWTnCGCp
         dA2hSGPIol2Ff3ujyByVuZEPl7mBl66PeMIKROEqQ1evw1A2C1n/S+psa0RVVi+yfePN
         2T6Q==
X-Gm-Message-State: ACgBeo0EYBOswqeTTPmrrEd/Tm6S8PhQHxgYdQ0qllgfd6H57hXklJ/b
        abq8vgNMb0WL22fop6pr7KlWJMcwtv/AyA==
X-Google-Smtp-Source: AA6agR61boqv9R5GwxiSEbbbDiM7VdzQSGWRU8MnGks8DhasC46hZJmDN75uK7FdsIMuw+IzSjdDRA==
X-Received: by 2002:a05:622a:2c4:b0:343:7f18:c2ab with SMTP id a4-20020a05622a02c400b003437f18c2abmr22347052qtx.641.1662027941508;
        Thu, 01 Sep 2022 03:25:41 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id az20-20020a05620a171400b006bb41ac3b6bsm11672157qkb.113.2022.09.01.03.25.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 03:25:41 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id 21so7949618ybl.6;
        Thu, 01 Sep 2022 03:25:40 -0700 (PDT)
X-Received: by 2002:a25:778d:0:b0:696:4bb6:9aaa with SMTP id
 s135-20020a25778d000000b006964bb69aaamr18315096ybc.380.1662027940511; Thu, 01
 Sep 2022 03:25:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220830164518.1381632-1-biju.das.jz@bp.renesas.com>
 <20220830164518.1381632-2-biju.das.jz@bp.renesas.com> <23539312-caaa-78f0-cd6c-899a826f9947@linaro.org>
 <OS0PR01MB592292E8BE619470F4C621A186799@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <1ef5dbd4-806f-ac1d-0ad5-0f8359a560de@linaro.org>
In-Reply-To: <1ef5dbd4-806f-ac1d-0ad5-0f8359a560de@linaro.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 1 Sep 2022 12:25:29 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWWUQvsHV4TCLd+4reMpc4nTc8Hjor5gQa2DopOrRaEjw@mail.gmail.com>
Message-ID: <CAMuHMdWWUQvsHV4TCLd+4reMpc4nTc8Hjor5gQa2DopOrRaEjw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] dt-bindings: can: nxp,sja1000: Document RZ/N1
 power-domains support
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
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

On Tue, Aug 30, 2022 at 9:03 PM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
> On 30/08/2022 20:47, Biju Das wrote:
> >> Subject: Re: [PATCH v3 1/3] dt-bindings: can: nxp,sja1000: Document
> >> RZ/N1 power-domains support
> >>
> >> On 30/08/2022 19:45, Biju Das wrote:
> >>> Document RZ/N1 power-domains support. Also update the example with
> >>> power-domains property.
> >>>
> >>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> >>> ---
> >>> v3:
> >>>  * Documented power-domains support.
> >>
> >> You made them required, so it would be nice to see reason in such
> >> change. The commit msg says only what you did, but not why you did it.
> >
> > It is simple. As you see from [1] and [2] power-domains are enabled by default in RZ/N1 SoC.
> > So there is nothing prevent us to document this property for all IP's present in
> > RZ/N1 SoC.
>
> Any explanation I expect to see in commit msg.
>
> Anyway you referred to Linux drivers, which is not actually a reason.
> What if some device is not in a power domain?

DT describes hardware, not software policy.

"power domains" are a property of the hardware.
I.e. this device (like most other devices on the SoC) is power-managed
through the system-controller.

Whether software does that by explicitly managing the clocks, or by
having a PM Domains driver is a software detail.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
