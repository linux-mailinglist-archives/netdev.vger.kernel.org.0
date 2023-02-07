Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7EA68E23A
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 21:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjBGUxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 15:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBGUxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 15:53:16 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E253B652;
        Tue,  7 Feb 2023 12:53:15 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id c13so4137518ejz.1;
        Tue, 07 Feb 2023 12:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YfKELKMAnQFkkEbZHEYEZttNxlmjlMVEh0XNdBoEsjw=;
        b=e1mwDgXaY5E6n859Lh8E/kA9NZHYyP0k8s2hCe1rVhBqfHpVx2nL0YTe0MZ/wz2muP
         sYRVk2PWCxOlDfKJiEYlUoBZl1Ac9dgZlGQUxRRsfo+TJ4hBpI5bJ6GGFt/iv7yZpRuV
         QJwv/W3L55N3/gC0OcYRYriT9MeJNabif8VtIjcuEG+Uk72Ib/UpIy3A4Wl21UycyGeV
         khphF77pzIvpuuNw3it4HAM5Bhbv+J+/cXG7jY1bIIVSkuk0pymjT4CR2+CXdZ7aILGi
         +dV8eymgVbI7VDVjM4FRnhr/cX1PTT27Ux51VwSTwf6Ea8dAeAkQ/9jIrMwF1hoVs8mR
         tT/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YfKELKMAnQFkkEbZHEYEZttNxlmjlMVEh0XNdBoEsjw=;
        b=Il/dbBq2ROQMePEn958QJ/AYzTSyxoFhLxtHhGZZERGNALdM2WOn9Qva81c5+PYOG5
         zxK5Bh7qX+GWT4Y0hTTlQDub/L6ThCFATuDLvO25vnYGqPDPG9Jpmr9V6BkTHga5NZO9
         InsjahmordlUkbT/4PEIAbyAMZ3fv/yK553eA5R69Qpl6XI5aDXgY1WhSpdcwqkxiEDq
         rzi6mxGaPKLTh/z5Uz1x/kRBe++Icrwt61JUsBbxLEk3YF2WlnJp65DoddC8PpNNEP21
         KLDugsz6D//7O+BQx8xkW2XQaLKGW9AsdJ/xr2cizqD5e6QUVS6/EbVFL09sGmyvb9U6
         kYAQ==
X-Gm-Message-State: AO0yUKUQvHUScV233RfBdtvmquU9qt8+2z4/+C+D6avkJL0INX65jnxH
        Ts4dTXAJ0z9xLwlxo/d/yKY=
X-Google-Smtp-Source: AK7set8gSzfFyLFzaRMOX6lLIPCjFSzze6dgA1JenhwCC1vYAs7beQOSSrNlWqOlog2SIUGPkEcD0g==
X-Received: by 2002:a17:906:bc54:b0:8aa:d923:faf0 with SMTP id s20-20020a170906bc5400b008aad923faf0mr104030ejv.10.1675803193728;
        Tue, 07 Feb 2023 12:53:13 -0800 (PST)
Received: from localhost ([2001:b07:5d37:537d:cd23:cd6e:ae14:44fe])
        by smtp.gmail.com with ESMTPSA id g4-20020a170906348400b007add62dafbasm7323912ejb.157.2023.02.07.12.53.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 12:53:13 -0800 (PST)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 07 Feb 2023 20:53:09 +0000
Message-Id: <CQCMNHG923N3.3991UZTUP9WFA@vincent-arch>
From:   "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
To:     "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Bartosz Golaszewski" <bartosz.golaszewski@linaro.org>,
        "Tony Lindgren" <tony@atomide.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "Christophe Leroy" <christophe.leroy@csgroup.eu>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "Devarsh Thakkar" <devarsht@ti.com>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "Stefan Schmidt" <stefan@datenfreihafen.org>,
        "Miquel Raynal" <miquel.raynal@bootlin.com>,
        <linux-gpio@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-doc-tw-discuss@lists.sourceforge.net>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-m68k@lists.linux-m68k.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-sh@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-wpan@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <linux-arch@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Cc:     "Bartosz Golaszewski" <brgl@bgdev.pl>,
        "Jonathan Corbet" <corbet@lwn.net>, "Alex Shi" <alexs@kernel.org>,
        "Yanteng Si" <siyanteng@loongson.cn>,
        "Hu Haowen" <src.res@email.cn>,
        "Russell King" <linux@armlinux.org.uk>,
        "Aaro Koskinen" <aaro.koskinen@iki.fi>,
        "Janusz Krzysztofik" <jmkrzyszt@gmail.com>,
        "Andrew Lunn" <andrew@lunn.ch>,
        "Sebastian Hesselbarth" <sebastian.hesselbarth@gmail.com>,
        "Gregory Clement" <gregory.clement@bootlin.com>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        "Nicholas Piggin" <npiggin@gmail.com>,
        "Yoshinori Sato" <ysato@users.sourceforge.jp>,
        "Rich Felker" <dalias@libc.org>,
        "Mun Yew Tham" <mun.yew.tham@intel.com>,
        "Keerthy" <j-keerthy@ti.com>,
        "Mika Westerberg" <mika.westerberg@linux.intel.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "Alexander Aring" <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Arend van Spriel" <aspriel@gmail.com>,
        "Franky Lin" <franky.lin@broadcom.com>,
        "Hante Meuleman" <hante.meuleman@broadcom.com>,
        "Kalle Valo" <kvalo@kernel.org>, "Qiang Zhao" <qiang.zhao@nxp.com>,
        "Li Yang" <leoyang.li@nxp.com>, "Lee Jones" <lee@kernel.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Frank Rowand" <frowand.list@gmail.com>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>
Subject: Re: [PATCH v3 01/12] gpiolib: remove empty asm/gpio.h files
References: <20230207142952.51844-1-andriy.shevchenko@linux.intel.com>
 <20230207142952.51844-2-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20230207142952.51844-2-andriy.shevchenko@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Arnd Bergmann <arnd@arndb.de>
>
> The arm and sh versions of this file are identical to the generic
> versions and can just be removed.
>
> The drivers that actually use the sh3 specific version also include
> cpu/gpio.h directly, with the exception of magicpanelr2, which is
> easily fixed. This leaves coldfire as the only gpio driver
> that needs something custom for gpiolib.
>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
