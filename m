Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16C1690555
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 11:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjBIKoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 05:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjBIKni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 05:43:38 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D789E83E7
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 02:43:25 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id a1so1790073ybj.9
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 02:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O7bf9Uq485R2NtxZEe67divp+n6UAi9uTuUydnCWVSg=;
        b=GLwl7Q7S+sW3h6atJzFjD9AilOcYqsPpQ3N3GeZ/D1Q88eJFYLRx7SByx2MKR3Tbg6
         QubdUMrA1FyWuDBqNGk/KYgKHj88NCbcdHz0TdxzXQlWldCFmt+T88T3OTKYV4CWPws+
         UJNXxHkfOucmMuvDGUcoQO0SeUM/g0ki7Fy81zLeWxa8HJRrq0tPaCgVq8mtC+dl1KTG
         v1A/7RHpawAeO/VgRA2to2txj8hRpIw2aZGHWCGR5He7S8Yx5BD5smCOGAdYNCvajG6I
         Ri7bl0JjbLdIsGg97InNpJ8AnGnu5MYrxD0Ms9oC/qKIpgK736+hK9g4RDJvTDvM1KLX
         Z9KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O7bf9Uq485R2NtxZEe67divp+n6UAi9uTuUydnCWVSg=;
        b=iR0mssaGzl3g8q3F8/8drCj0Z4+XgIOb99wHbRoZypGSL2cy06EU40Ho3Btfc/aPHR
         uiRbEkGoogq87ki58aqFSmXSpDcZDS9ZNleSFEtKkJx+hB+8o9m7aGHuFosHsZtR4EQB
         ITIxDnORVfsx+43XLKJugOyM30zAjy+0qcIjzSkAOfJMoPgltJLycqkLVZcrMYWGYC5V
         PZZWHOALgudlIwjqwcyy1nysfiKXmm1+V9WXgVqnG1nNQCPQlJM+RxalaK23eAoZmaPj
         IDTxGnQESfbHaRFIiP1ycfvNqII+sRS01BFbPja1mas5MCCbK1OBkDvbs5P4jqSiNMSI
         IoFw==
X-Gm-Message-State: AO0yUKVw5jQuijmXWW+UBCCl19C2dgRDYfsG56njI6wGCNjGDU1I005t
        1fmODSyABRoScxXq1tlIqV4P+EkR9qZtXDIP91R/5w==
X-Google-Smtp-Source: AK7set+gn4TRcnw/Px4w/IuFAMVTVJyu4IvoJ/vrCRoCZs1e5OwtzAnC5LkZeezUkZu5vWtv8zRWrBwhSzP2jQpPPmI=
X-Received: by 2002:a5b:150:0:b0:88f:92ec:4292 with SMTP id
 c16-20020a5b0150000000b0088f92ec4292mr1180607ybp.460.1675939405127; Thu, 09
 Feb 2023 02:43:25 -0800 (PST)
MIME-Version: 1.0
References: <20230208173343.37582-1-andriy.shevchenko@linux.intel.com> <20230208173343.37582-13-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20230208173343.37582-13-andriy.shevchenko@linux.intel.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 9 Feb 2023 11:43:13 +0100
Message-ID: <CACRpkdaTvKhRi2_szWCPv+NrXAzsT7ROKv-OJDh5NgLJznDzCQ@mail.gmail.com>
Subject: Re: [PATCH v4 12/18] gpio: aggregator: Add missing header(s)
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        Devarsh Thakkar <devarsht@ti.com>,
        Michael Walle <michael@walle.cc>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dipen Patel <dipenp@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Lee Jones <lee@kernel.org>, linux-gpio@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, linux-arch@vger.kernel.org,
        devicetree@vger.kernel.org, Bartosz Golaszewski <brgl@bgdev.pl>,
        Jonathan Corbet <corbet@lwn.net>, Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Russell King <linux@armlinux.org.uk>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Keerthy <j-keerthy@ti.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>, Qiang Zhao <qiang.zhao@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 8, 2023 at 6:34 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:

> Do not imply that some of the generic headers may be always included.
> Instead, include explicitly what we are direct user of.
>
> While at it, drop unused linux/gpio.h and split out the GPIO group of
> headers.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
