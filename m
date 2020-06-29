Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34EB20E2C6
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732172AbgF2VI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:08:28 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38415 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390229AbgF2VIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 17:08:25 -0400
Received: by mail-ed1-f65.google.com with SMTP id n2so5209653edr.5;
        Mon, 29 Jun 2020 14:08:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WVzOc0zshIAzur/W9UldDSamNUZIg6bYwU7gViF4xjM=;
        b=XUXYJW1YjmtF6PwxsLRs3RzxxVAxAPl7iKRiELCzxj0g2cn0itGuB0hAxZWMlVWLz9
         mB/GxGKY1TNMXWRU3RyUPszljbezvgimuF6zmQ0AUbEHJuhn5+x1GZYaLrRDElgjbSS7
         tr0XrGMtbul0eR19pifhTezdUkD5WSsa7vIzIGTgYm2mpC0vO3G70xoKufwmcU+2ps1k
         7xV+f1JuuXwcGNa+V4U00pMduOQX/3MwZ5Qe+fxzAnl5SjnNtYGamDSIL8apuZ/WdfZB
         FrgtdWnROwzVaJs8oBJco62GMCT7Gck1SN5QKUVSVVl1OdVPJVU/Ub29R1fKnBhFF6X0
         T9vw==
X-Gm-Message-State: AOAM531cBYxiOkNeTnLFpykwfPa4/2XJFJMFgqXxfIHsM/ztjxcTxXHk
        eAS3ol0jBFkx/OeDL/YUclE=
X-Google-Smtp-Source: ABdhPJz7uJ34zkR7UdIcDmO5eQD/05KE/U7ACuTf+SbkMdyaKDXIEt+RJAAp/9n0LB1FcwdSrdDevA==
X-Received: by 2002:aa7:d6cc:: with SMTP id x12mr11487518edr.354.1593464901568;
        Mon, 29 Jun 2020 14:08:21 -0700 (PDT)
Received: from kozik-lap ([194.230.155.195])
        by smtp.googlemail.com with ESMTPSA id q3sm736869eds.0.2020.06.29.14.08.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Jun 2020 14:08:20 -0700 (PDT)
Date:   Mon, 29 Jun 2020 23:08:17 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     corbet@lwn.net, aaro.koskinen@iki.fi, tony@atomide.com,
        linux@armlinux.org.uk, daniel@zonque.org, haojian.zhuang@gmail.com,
        robert.jarzmik@free.fr, kgene@kernel.org,
        dmitry.torokhov@gmail.com, lee.jones@linaro.org,
        wsa+renesas@sang-engineering.com, ulf.hansson@linaro.org,
        davem@davemloft.net, kuba@kernel.org, b.zolnierkie@samsung.com,
        j.neuschaefer@gmx.net, mchehab+samsung@kernel.org,
        gustavo@embeddedor.com, gregkh@linuxfoundation.org,
        yanaijie@huawei.com, daniel.vetter@ffwll.ch,
        rafael.j.wysocki@intel.com, Julia.Lawall@inria.fr,
        linus.walleij@linaro.org, viresh.kumar@linaro.org, arnd@arndb.de,
        jani.nikula@intel.com, yuehaibing@huawei.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] Remove handhelds.org links and email addresses
Message-ID: <20200629210817.GA32399@kozik-lap>
References: <20200629203121.7892-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200629203121.7892-1-grandmaster@al2klimov.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 10:31:21PM +0200, Alexander A. Klimov wrote:
> Rationale:
> https://lore.kernel.org/linux-doc/20200626110706.7b5d4a38@lwn.net/
> 
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
> ---
>  @Jon I thought about what I said and *no*, unfortunately I *can't* automate
>  the detection of such as easy as the HTTPSifying. As you maybe see below
>  cleaning up is even "harder".
> 
>  We have only 17 files and one domain here. Shall I split it up per subsystem
>  or can we let it as is?
> 
>  Documentation/arm/sa1100/assabet.rst           |  2 --
>  Documentation/arm/samsung-s3c24xx/h1940.rst    | 10 ----------
>  Documentation/arm/samsung-s3c24xx/overview.rst |  3 +--
>  Documentation/arm/samsung-s3c24xx/smdk2440.rst |  4 ----
>  arch/arm/mach-omap1/Kconfig                    |  4 +---
>  arch/arm/mach-pxa/h5000.c                      |  2 +-
>  arch/arm/mach-s3c24xx/mach-h1940.c             |  2 --
>  arch/arm/mach-s3c24xx/mach-n30.c               |  3 ---
>  arch/arm/mach-s3c24xx/mach-rx3715.c            |  2 --

For s3c24xx, I am fine taking it through docs tree:
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>

Otherwise, after splitting, I could take the s3c-24xx bits.

Best regards,
Krzysztof


>  drivers/input/keyboard/gpio_keys.c             |  2 +-
>  drivers/input/keyboard/jornada720_kbd.c        |  2 +-
>  drivers/input/touchscreen/jornada720_ts.c      |  2 +-
>  drivers/mfd/asic3.c                            |  2 +-
>  drivers/mmc/host/renesas_sdhi_core.c           |  2 +-
>  drivers/net/ethernet/dec/tulip/de4x5.c         |  1 -
>  drivers/video/fbdev/sa1100fb.c                 |  2 +-
>  include/linux/apm-emulation.h                  |  2 --
>  17 files changed, 9 insertions(+), 38 deletions(-)
