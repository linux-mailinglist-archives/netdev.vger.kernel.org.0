Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEFAA55E80F
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347555AbiF1PbO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Jun 2022 11:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347536AbiF1PbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 11:31:12 -0400
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CC8114;
        Tue, 28 Jun 2022 08:31:12 -0700 (PDT)
Received: by mail-qk1-f177.google.com with SMTP id z7so9947381qko.8;
        Tue, 28 Jun 2022 08:31:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GTEcnfVpaXRtDZ3sKdJuR57NXUAIRBOjbbKldIE7oQI=;
        b=VlLODzr7bvLaHmO9EAq4fZ6Pq0R57fdaQeAmQQk8VMC2ORgmZYssVhAiyhTq6OgmAI
         2L4Eew3FjmEtrjWoNynz+wtFwiL0yasrxiawSfy/71Rg5Js6NkmisE/JTTbmRkpaUsON
         MfpupgbXmRZKTlQtNJQeJds8+XVUs/ThWiJe7ZlwL4kH/2TBubl7IP7U9hcssBTSqb8T
         CAJPLVszf154d0tljB0z4pqusR42BX/f4KQK4Ugnpyw9R0tZXUfBRba5gdDi4gEf6GeX
         vfcXYSOG96q5TadgBgIiaBIOIDVT9Jtzxlyr2AZX/Gj0Pvo3q9zt6A0BUvZ2ov+mfBfL
         vzhw==
X-Gm-Message-State: AJIora/5I8ejvGgJPkb518zgAAJkgKHHt/rsSFhZG/IH7tREWdIshk0U
        UOg5quEPcrb6LEalHutl+txVVqnCcvNfoQ==
X-Google-Smtp-Source: AGRyM1ukYmhMukrW6cwz6/kCUmaKDypWU+YfY1+ade2atCLk1MMwzE/vdd6Bd8Ejonj1zmJ44fLWyg==
X-Received: by 2002:a05:620a:480e:b0:6ae:ed43:474e with SMTP id eb14-20020a05620a480e00b006aeed43474emr11905283qkb.218.1656430270783;
        Tue, 28 Jun 2022 08:31:10 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id l28-20020ac84cdc000000b00304f98ad3c1sm8921327qtv.29.2022.06.28.08.31.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 08:31:10 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id l11so22779886ybu.13;
        Tue, 28 Jun 2022 08:31:09 -0700 (PDT)
X-Received: by 2002:a5b:6c1:0:b0:669:a7c3:4c33 with SMTP id
 r1-20020a5b06c1000000b00669a7c34c33mr20267530ybq.543.1656430268998; Tue, 28
 Jun 2022 08:31:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220624144001.95518-1-clement.leger@bootlin.com> <20220624144001.95518-14-clement.leger@bootlin.com>
In-Reply-To: <20220624144001.95518-14-clement.leger@bootlin.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 28 Jun 2022 17:30:57 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVQnjq=fn0AHrhQNjW+ZgsW-HrsYbf8gWP1iVSUOA00DQ@mail.gmail.com>
Message-ID: <CAMuHMdVQnjq=fn0AHrhQNjW+ZgsW-HrsYbf8gWP1iVSUOA00DQ@mail.gmail.com>
Subject: Re: [PATCH net-next v9 13/16] ARM: dts: r9a06g032: describe GMAC2
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

On Fri, Jun 24, 2022 at 4:42 PM Clément Léger <clement.leger@bootlin.com> wrote:
> RZ/N1 SoC includes two MAC named GMACx that are compatible with the
> "snps,dwmac" driver. GMAC1 is connected directly to the MII converter
> port 1. GMAC2 however can be used as the MAC for the switch CPU
> management port or can be muxed to be connected directly to the MII
> converter port 2. This commit add description for the GMAC2 which will
> be used by the switch description.
>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-devel for v5.20.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
