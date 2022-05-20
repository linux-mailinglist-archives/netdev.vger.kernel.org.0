Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0016B52E7FF
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 10:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347307AbiETIsX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 20 May 2022 04:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245470AbiETIsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 04:48:21 -0400
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A593BBC6FD;
        Fri, 20 May 2022 01:48:20 -0700 (PDT)
Received: by mail-qk1-f169.google.com with SMTP id m1so6452848qkn.10;
        Fri, 20 May 2022 01:48:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JWWW8GaGp7Bfgc3aX0E1QG9mqMLN8epseaMJO1I0gvs=;
        b=Wt2+mMTjs0ln7OwJIsUFv2f6CKK6e8JKuj1hb7PM8Aa/2JzgsjoioMxKAivYhEwanN
         tgmziw6asF7tre5vzVNcEFXJ0QTIoVuEezgKRj7glP1ssfVXZDO/n1akBKtuEafGXmsu
         9HBsUVi++waSVGnjIenfcGEpBbSCVKFaRCSGACJoIPie5fx7+qmmck3CRZkFC7Uk4y/0
         K+BmoZG6PhM4Lfbsqgxw7XdmhRqVk6RHNjU/VSc7XBnOxORdrekvnp+1pR3eiebjGyf7
         H1ayOFEI+EuhJv8nOEV38ECxny1JAKaX5ufnCRzaX9I5P26K+OCqoREU9y5YCf0M+PQd
         zhPQ==
X-Gm-Message-State: AOAM530B7xoeoEITdf+Oi3d2IUZmTywjgVY/+uoZre0HWFKMqyV3oU/M
        U2bWw6tle8lfJ0vlZejNzGMVVgl21n+oNw==
X-Google-Smtp-Source: ABdhPJzCZYpkvWsWVhCZcDC/KQ3OosVm4vkjIkhnnYhqQg31JSpJTE2v030b7145puFRr8QP7FBgoQ==
X-Received: by 2002:a05:620a:2e2:b0:6a3:5662:e499 with SMTP id a2-20020a05620a02e200b006a35662e499mr60398qko.361.1653036499462;
        Fri, 20 May 2022 01:48:19 -0700 (PDT)
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com. [209.85.128.173])
        by smtp.gmail.com with ESMTPSA id d200-20020a3768d1000000b006a351e0eacdsm254588qkc.95.2022.05.20.01.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 01:48:18 -0700 (PDT)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-2fed823dd32so79944057b3.12;
        Fri, 20 May 2022 01:48:18 -0700 (PDT)
X-Received: by 2002:a0d:f002:0:b0:2fe:cfba:d597 with SMTP id
 z2-20020a0df002000000b002fecfbad597mr8716166ywe.502.1653036498056; Fri, 20
 May 2022 01:48:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220519153107.696864-1-clement.leger@bootlin.com>
 <20220519153107.696864-12-clement.leger@bootlin.com> <CAMuHMdUJpNSyX0qK64+W1G6P1S-78mb_+D0-w3kHOFY3VVkANQ@mail.gmail.com>
 <20220520101332.0905739f@fixe.home> <CAMuHMdXTrZnGVt44hg5QUvuS5cZABmRncgNYtatkmk8VcH7gew@mail.gmail.com>
 <20220520103152.48f7b178@fixe.home>
In-Reply-To: <20220520103152.48f7b178@fixe.home>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 20 May 2022 10:48:05 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUXasnd+RQUvN09ZUEEPLJzLcpgPrXuqadfsfsY+RsZPg@mail.gmail.com>
Message-ID: <CAMuHMdUXasnd+RQUvN09ZUEEPLJzLcpgPrXuqadfsfsY+RsZPg@mail.gmail.com>
Subject: Re: [PATCH net-next v5 11/13] ARM: dts: r9a06g032: describe GMAC2
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=C3=A8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clément,

On Fri, May 20, 2022 at 10:33 AM Clément Léger
<clement.leger@bootlin.com> wrote:
> Le Fri, 20 May 2022 10:25:37 +0200,
> Geert Uytterhoeven <geert@linux-m68k.org> a écrit :
> > On Fri, May 20, 2022 at 10:14 AM Clément Léger
> > <clement.leger@bootlin.com> wrote:
> > > Le Fri, 20 May 2022 09:18:58 +0200,
> > > Geert Uytterhoeven <geert@linux-m68k.org> a écrit :
> > > > On Thu, May 19, 2022 at 5:32 PM Clément Léger <clement.leger@bootlin.com> wrote:
> > > > > RZ/N1 SoC includes two MAC named GMACx that are compatible with the
> > > > > "snps,dwmac" driver. GMAC1 is connected directly to the MII converter
> > > > > port 1. GMAC2 however can be used as the MAC for the switch CPU
> > > > > management port or can be muxed to be connected directly to the MII
> > > > > converter port 2. This commit add description for the GMAC2 which will
> > > > > be used by the switch description.
> > > > >
> > > > > Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> >
> > > > > --- a/arch/arm/boot/dts/r9a06g032.dtsi
> > > > > +++ b/arch/arm/boot/dts/r9a06g032.dtsi
> > > > > @@ -200,6 +200,23 @@ nand_controller: nand-controller@40102000 {
> > > > >                         status = "disabled";
> > > > >                 };
> > > > >
> > > > > +               gmac2: ethernet@44002000 {
> > > > > +                       compatible = "snps,dwmac";
> > > >
> > > > Does this need an SoC-specific compatible value?
> > >
> > > Indeed, it might be useful to introduce a specific SoC compatible since
> > > in a near future, there might be some specific support for that gmac.
> > > Here is an overview of the gmac connection on the SoC:
> > >
> > >                                           ┌─────────┐   ┌──────────┐
> > >                                           │         │   │          │
> > >                                           │  GMAC2  │   │  GMAC1   │
> > >                                           │         │   │          │
> > >                                           └───┬─────┘   └─────┬────┘
> > >                                               │               │
> > >                                               │               │
> > >                                               │               │
> > >                                          ┌────▼──────┐        │
> > >                                          │           │        │
> > >             ┌────────────────────────────┤  SWITCH   │        │
> > >             │                            │           │        │
> > >             │          ┌─────────────────┴─┬────┬────┘        │
> > >             │          │            ┌──────┘    │             │
> > >             │          │            │           │             │
> > >        ┌────▼──────────▼────────────▼───────────▼─────────────▼────┐
> > >        │                      MII Converter                        │
> > >        │                                                           │
> > >        │                                                           │
> > >        │ port 1      port 2       port 3      port 4       port 5  │
> > >        └───────────────────────────────────────────────────────────┘
> > >
> > > As you can see, the GMAC1 is directly connected to MIIC converter and
> > > thus will need a "pcs-handle" property to point on the MII converter
> > > port whereas the GMAC2 is directly connected to the switch in GMII.
> > >
> > > Is "renesas,r9a06g032-gmac2", "renesas,rzn1-switch-gmac2" looks ok
> > > for you for this one ?
> >
> > Why "switch" in the family-specific value, but not in the SoC-specific
> > value?
>
> That's a typo, switch should be removed.

OK.

> > Are GMAC1 and GMAC2 really different, or are they identical, and is
> > the only difference in the wiring, which can be detected at run-time
> > using this "pcs-handle" property? If they're identical, they should
> > use the same compatible value.
>
> They are actually identical except the requirement for a "pcs-handle"
> for gmac1. I thought about using different compatible to enforce this by
> making it "required" with the "renesas,r9a06g032-gmac1" compatible but
> not the "renesas,r9a06g032-gmac2" one. If it's ok for you to let it
> optional and use a single compatible, I'm ok with that !

OK to make it optional. Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
