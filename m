Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B8556038D
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbiF2OrC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Jun 2022 10:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbiF2OrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:47:00 -0400
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D18393FF;
        Wed, 29 Jun 2022 07:46:56 -0700 (PDT)
Received: by mail-qv1-f51.google.com with SMTP id cu16so25103772qvb.7;
        Wed, 29 Jun 2022 07:46:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lKCBOPrNloihbU1g4ZnMBHTpej5sTMCTVYThSbP4lGw=;
        b=PC9JlThrQbhHwBPk3Jk/H01Pd55bdgWM9LeD1fOerfZnQjy8QGLmxt0VG2gnXssOQ3
         UqFCnukA0M8DopB7/TCiEut1cY9iP8RHv3Xdsauem8gxdYYayr4JUQc5FFJHCvcd9FGz
         MtWHU5O7cjdzcCLKSqKpfumoVfjMFfN/iIiyrcMTWulhp6kTsLEm+dSRRVDoOfLUpSYo
         ngpPWV6D2F6xR2meZNth82sH5GZVJ4KN0T6B0sbIgnWeomzAtqQXqoJEJ6wEv1aAPWLm
         KZoTpLmuR1QGL0KY+Wk0EW//U85ETRlJjDTAPyqBkX9Ox5U/1+/o2PAITNSxPmb08DEu
         nekA==
X-Gm-Message-State: AJIora94A2cMyQHNkyhkFqzoQ2OLVIKbhf4LShp09pQOHbBh4Y+RLakQ
        Wx/YHM4akISLrtWMA0drCOSfIJV+Aa8VZA==
X-Google-Smtp-Source: AGRyM1s43fyMd0KroXgg5HnVsInZDjNj+GDeg4cPT5ArtF4/b6kiLgOBt5DArEfzUzFfIT2YhLze0g==
X-Received: by 2002:a05:622a:54b:b0:305:31e4:51fa with SMTP id m11-20020a05622a054b00b0030531e451famr2792548qtx.165.1656514015770;
        Wed, 29 Jun 2022 07:46:55 -0700 (PDT)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id b20-20020ae9eb14000000b006aee8580a37sm12975109qkg.10.2022.06.29.07.46.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 07:46:55 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id x184so25629142ybg.12;
        Wed, 29 Jun 2022 07:46:55 -0700 (PDT)
X-Received: by 2002:a81:3a81:0:b0:317:7dcf:81d4 with SMTP id
 h123-20020a813a81000000b003177dcf81d4mr4187413ywa.47.1656513525966; Wed, 29
 Jun 2022 07:38:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220624144001.95518-1-clement.leger@bootlin.com> <20220624144001.95518-5-clement.leger@bootlin.com>
In-Reply-To: <20220624144001.95518-5-clement.leger@bootlin.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 29 Jun 2022 16:38:33 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXw2zuu-Q30VDF16_sLFO8eU1u8HrbxkYnKyCHK6d41hw@mail.gmail.com>
Message-ID: <CAMuHMdXw2zuu-Q30VDF16_sLFO8eU1u8HrbxkYnKyCHK6d41hw@mail.gmail.com>
Subject: Re: [PATCH net-next v9 04/16] dt-bindings: net: pcs: add bindings for
 Renesas RZ/N1 MII converter
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
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
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
        netdev <netdev@vger.kernel.org>, Rob Herring <robh@kernel.org>
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

On Fri, Jun 24, 2022 at 4:41 PM Clément Léger <clement.leger@bootlin.com> wrote:
> This MII converter can be found on the RZ/N1 processor family. The MII
> converter ports are declared as subnodes which are then referenced by
> users of the PCS driver such as the switch.
>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  .../bindings/net/pcs/renesas,rzn1-miic.yaml   | 171 ++++++++++++++++++
>  include/dt-bindings/net/pcs-rzn1-miic.h       |  33 ++++
>  2 files changed, 204 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml
>  create mode 100644 include/dt-bindings/net/pcs-rzn1-miic.h

As the DT binding definitions are shared by driver and DT sources,
I have queued this patch in renesas-devel for v5.20, too.
Ideally, it should have been applied to a shared immutable branch.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
