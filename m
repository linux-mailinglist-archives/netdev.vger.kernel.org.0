Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECA944A7AD
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 18:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbfFRQxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 12:53:09 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37435 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbfFRQxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 12:53:09 -0400
Received: by mail-pg1-f193.google.com with SMTP id n65so3551236pga.4
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 09:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=IqqtXsFGosoxNpPkm5wyCgfinoqyhByKBZjMuz4MB0I=;
        b=bg323twPxByid8peFGN7CaP7DYTzxD48CEFt6vzKFLuZr27ZPVeYR9aqapgK/NZyMX
         VwWDxuPluBaWMti4Db1jhMO8vU/6BpjUYDcDWPDqPIvC8V72JIX4y5qjBmafMOwLeDC+
         ex3OfhlOOmJs9zSa/1f/dp42YA8jMBbipGqeaijIyJMFO3zPZKzEYTlm6JJQaYMvayp0
         YcOwru57r9aSI06mvYdo4y0QlmqTtTz7ltIdOozdK1wEgu14p/fq2LSvG9qOBut3BD8o
         fU4dXkm9gaS6lKhpmdzsnMcIDNm+U2NyMlAqoMSX6bh2OonBDJ48eTnIkbyGgA+1Ugg+
         5hAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=IqqtXsFGosoxNpPkm5wyCgfinoqyhByKBZjMuz4MB0I=;
        b=Nk5RdqAwyLv8MfUYTriM5wjBv2w9+doKjKXAZDqZFFIyVs9a1AZBB0tcDmV0mRQa7M
         sCwN2CEslpij6ooRGRVD6nea62Oq6wf/aE9EuRaZjlFW7r4iHD3oqFsz+sKk1HsWcy4D
         yQUvFXkRVT3NMznAwUuPaoKE9YMJvyOltSp6z2xU1QGZVs1smXVQx81yJ+2XWPNqHAL7
         s/LOxyj2WQ6oF1S3TFl/lN8bQe16m+NeGfwVczZs2S36gTNolUMZZKbHr1EJWDsvr+03
         wq7weQRWUuc2pS4kYxMqFdTeXV2tznrwaqcz4iA2qZQWIDpIRYQTelfV4qI1kqZ9pDFM
         bPVA==
X-Gm-Message-State: APjAAAX7Dgf1iUdS3moHLfTc9dJSMLC4YKymnpHMaUKUIDn8b5rNIY2A
        Z+Q4mT55PHTX29dpbeKJ7nIDqw==
X-Google-Smtp-Source: APXvYqza2rYN7tr43Lk9Mo1yoxZIdHHve48RruCrOAFPMAW78pCSNW6feYT0xc+hh4kEhI6LzewVVA==
X-Received: by 2002:a63:4a1f:: with SMTP id x31mr3594318pga.150.1560876788415;
        Tue, 18 Jun 2019 09:53:08 -0700 (PDT)
Received: from localhost (c-71-197-186-152.hsd1.wa.comcast.net. [71.197.186.152])
        by smtp.googlemail.com with ESMTPSA id a11sm15966693pff.128.2019.06.18.09.53.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Jun 2019 09:53:07 -0700 (PDT)
From:   Kevin Hilman <khilman@baylibre.com>
To:     "kernelci.org bot" <bot@kernelci.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        tomeu.vizoso@collabora.com, guillaume.tucker@collabora.com,
        mgalka@collabora.com, broonie@kernel.org, matthew.hart@linaro.org,
        enric.balletbo@collabora.com
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "kernelci.org bot" <bot@kernelci.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: next/master boot bisection: next-20190617 on sun8i-h2-plus-orangepi-zero
In-Reply-To: <5d089fb6.1c69fb81.4f92.9134@mx.google.com>
References: <5d089fb6.1c69fb81.4f92.9134@mx.google.com>
Date:   Tue, 18 Jun 2019 09:53:07 -0700
Message-ID: <7hr27qdedo.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"kernelci.org bot" <bot@kernelci.org> writes:

> next/master boot bisection: next-20190617 on sun8i-h2-plus-orangepi-zero
>
> Summary:
>   Start:      a125097c8410 Add linux-next specific files for 20190617
>   Details:    https://kernelci.org/boot/id/5d07987659b51412add51503
>   Plain log:  https://storage.kernelci.org//next/master/next-20190617/arm/multi_v7_defconfig/gcc-8/lab-baylibre/boot-sun8i-h2-plus-orangepi-zero.txt
>   HTML log:   https://storage.kernelci.org//next/master/next-20190617/arm/multi_v7_defconfig/gcc-8/lab-baylibre/boot-sun8i-h2-plus-orangepi-zero.html
>   Result:     ce4ab73ab0c2 net: stmmac: drop the reset delays from struct stmmac_mdio_bus_data
>
> Checks:
>   revert:     PASS
>   verify:     PASS
>
> Parameters:
>   Tree:       next
>   URL:        git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>   Branch:     master
>   Target:     sun8i-h2-plus-orangepi-zero
>   CPU arch:   arm
>   Lab:        lab-baylibre
>   Compiler:   gcc-8
>   Config:     multi_v7_defconfig
>   Test suite: boot
>
> Breaking commit found:
>
> -------------------------------------------------------------------------------
> commit ce4ab73ab0c27c6a3853695aa8ec0f453c6329cd
> Author: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Date:   Sat Jun 15 12:09:31 2019 +0200
>
>     net: stmmac: drop the reset delays from struct stmmac_mdio_bus_data
>     
>     Only OF platforms use the reset delays and these delays are only read in
>     stmmac_mdio_reset(). Move them from struct stmmac_mdio_bus_data to a
>     stack variable inside stmmac_mdio_reset() because that's the only usage
>     of these delays.
>     
>     Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>

This seems to have broken on several sunxi SoCs, but also a MIPS SoC
(pistachio_marduk):

https://storage.kernelci.org/next/master/next-20190618/mips/pistachio_defconfig/gcc-8/lab-baylibre-seattle/boot-pistachio_marduk.html

Kevin
