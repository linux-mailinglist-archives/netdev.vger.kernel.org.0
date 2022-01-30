Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783854A32DF
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 01:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353592AbiA3Abm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 19:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353587AbiA3Abl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 19:31:41 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B0BC06173B
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 16:31:41 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id i10so29509015ybt.10
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 16:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pme32IFXRNHgrXZ/dj8GMepH+ska0RwjBdlk1fihJ0A=;
        b=IltbbM1EQZqZOXk2OvOAxzFGYEGyIcXl0ze+Gd6uqe80Yl441IZCeUTU/rBTVpvJCF
         KIXazu/IDMXkGcjo+FKTks/BRGXeuUCz+25eZD77PYKVmNBrXCcKb0UzTzGfGIS5/KsK
         GJkAMdZSlu0tseCMyhAia/aB9i9WbvlP6lz9vmkAXtTeiWyunPOWGvGmz7UdePwIeZ/M
         j4FN8lMJFu3P7EO8CWdKag9uzRC/ATVhyyZH3h479vSUSTqoYAGTiuh9r0CQJOHD10sh
         Gh79f795EdnRlH6dlo4y4XRQkyUhWw8rJGLgOmWVdJRpEeoczaVsi0x2jBDHXgveJpES
         viCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pme32IFXRNHgrXZ/dj8GMepH+ska0RwjBdlk1fihJ0A=;
        b=sSd8vt/nKjtpt1HbnSnMo+LWrj5CGbORhmc7TblWd4t5PXUj2rHF62bMmy54PjoO8f
         qgPVoy3IQ8HxKBf+C4hdfXmqjProA7L6WY5SWrcJpzskcshmdGfOPP9AE1sncBDA62j+
         aAa1PMcAFeSsl4ZjchtHNX6ESPKjlfROzZLScUozV+nUCiPGPha9rJ/Zt8+KoS6rbuT1
         Xchf6zOaSqMxSRkTwFwYYubUB9jvVKqhoznSxx1cjX7cOEbug/y+lJrAR29ndr/xxclk
         PpjSteE7SMjkYhkkuNbgzJAFBy5DHul398tQpTSSGoJC+uT21BkuwF7F4ubpHaKe93kc
         V8Bg==
X-Gm-Message-State: AOAM531jun4TuaAW3rajV7J5BwgbbfbR+7TfGwYMN0TIGeR+Cr1vw8vB
        J+5Z85HJHqN6QIO0hnKtXNy9YeoruT31JzldWjUOkA==
X-Google-Smtp-Source: ABdhPJzxAbrXaVgDQ08MBW1JI8bn63pnojvyZBxce+CBlsONQJOt0o6ierYk3+5NsIeuVr0qUpocfIe0c5ve35EnJKw=
X-Received: by 2002:a25:cfc6:: with SMTP id f189mr21205071ybg.322.1643502700641;
 Sat, 29 Jan 2022 16:31:40 -0800 (PST)
MIME-Version: 1.0
References: <20220129220221.2823127-1-colin.foster@in-advantage.com> <20220129220221.2823127-3-colin.foster@in-advantage.com>
In-Reply-To: <20220129220221.2823127-3-colin.foster@in-advantage.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 30 Jan 2022 01:31:29 +0100
Message-ID: <CACRpkdbXD0cA07zPQtVH1_hdc-aLq5ktm1DpUW=dB-i+B5dacw@mail.gmail.com>
Subject: Re: [RFC v6 net-next 2/9] pinctrl: microchip-sgpio: allow sgpio
 driver to be used as a module
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 29, 2022 at 11:02 PM Colin Foster
<colin.foster@in-advantage.com> wrote:

> As the commit message suggests, this simply adds the ability to select
> SGPIO pinctrl as a module. This becomes more practical when the SGPIO
> hardware exists on an external chip, controlled indirectly by I2C or SPI.
> This commit enables that level of control.
>
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
