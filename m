Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F4E69057A
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 11:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbjBIKpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 05:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjBIKpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 05:45:09 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD606A306
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 02:44:39 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id 184so1809850ybw.5
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 02:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4qUYzBh+htvaSXOzFbNonzhWIZMquhylnwgwaeahDZw=;
        b=uuZ/oXOru1y5UKbjewNxej2lUBZUjA/1ggGu58hEptHz0z4GXGOaT7FaMOglr+2wPj
         4/MsVJ6KLCikf3ZFZNyK0Gy12bs9MQqkPAtfTr75QUjILYQQ/DRnb2+a60m8owu7ZRy6
         STtBilq89ZUzNjAwwp8kE2q+7q6e6f5g/d+9CTEAorBMILiidfS6YQHMkfUk7LQYdTv/
         NI++1y0LwBY9js8Sr97WQfezP1Ee3hKFW9ffbD2Ed7rpzUZN3ALWW0F5B6y9hYsVO7uT
         0dDXJ4o+1R2iwk4/GIy5Xk4EtkzULEIoKVf/W3QINP0rEKMAOq0w8D/WStNV1a1neNO3
         Xjtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4qUYzBh+htvaSXOzFbNonzhWIZMquhylnwgwaeahDZw=;
        b=3XEk5JLwpmPL7QPodJgFdprPzYBejOD6/ibX0Wpp9oHM7KhC5sdvXRSDzz4rsEbBiy
         dbY7ZsZchCkVVFpENAJgNJjLW7j6art1jhszrtU+Vapzr4lcYf1MLV87Fpxd3sxu8Zpb
         Gg+1l31q3Sfqc8ePHCCNxDW61oFcWwHV3jAdSsofHpTEKCBnNb+cu71rnOzswebMqm52
         6WN2XZurqbkdZPCi7XQfmS0mxba4o3a1IXEjEeZbs0BQz099FYK2egfUJMsughuCKZjU
         8zRB+9K3rHp66dpd1EUTMpghKn3QQR/3wAbB/EuqUbUZJLQLHEB0GaZtBjhTkIEusL/1
         cNkw==
X-Gm-Message-State: AO0yUKVEL1PG6xqSQSkUBPZy6giQUDlxx7mRY/APBboeHAj8fzNPoJ01
        YRG7BQcvu25v8a5vI68rteDINWl7r/eI2yL8cYth9w==
X-Google-Smtp-Source: AK7set9d9VE2L5hryiHb25bGtGaGLrBq8cYlmsHU1RCuAZ6kpI7lLERRU7ZJG+pSow3smAjpy+w5g/+hxXK6eBZGKHY=
X-Received: by 2002:a25:d987:0:b0:893:76b2:9200 with SMTP id
 q129-20020a25d987000000b0089376b29200mr1091099ybg.584.1675939478849; Thu, 09
 Feb 2023 02:44:38 -0800 (PST)
MIME-Version: 1.0
References: <20230208173343.37582-1-andriy.shevchenko@linux.intel.com> <20230208173343.37582-19-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20230208173343.37582-19-andriy.shevchenko@linux.intel.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 9 Feb 2023 11:44:27 +0100
Message-ID: <CACRpkdbO85vArYXF1iY8Z1wXXFTs5rOffyzy2zWK=PgM+mGM_g@mail.gmail.com>
Subject: Re: [PATCH v4 18/18] gpiolib: Clean up headers
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
        Frank Rowand <frowand.list@gmail.com>
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

> There is a few things done:
> - include only the headers we are direct user of
> - when pointer is in use, provide a forward declaration
> - add missing headers
> - group generic headers and subsystem headers
> - sort each group alphabetically
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
