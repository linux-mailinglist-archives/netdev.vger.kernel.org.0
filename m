Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B582D446D
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730434AbgLIOcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 09:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgLIOcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 09:32:53 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41130C0613CF;
        Wed,  9 Dec 2020 06:32:13 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id b10so262784ljp.6;
        Wed, 09 Dec 2020 06:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uY9PWBYEWa+L7/vef7H+7Msq9Ws/A/8yhidf9SuVVdo=;
        b=qMZhFx+vYT7MTu7dfjl6vuany45dJzHG96iXCLscxwpnVqlj9VsIwIr5gw4HK75Ikm
         CKxYwK2N5HQ+Q19Nkn2eo80hMntqN6paSvgjTnkqEw7pGMzraC74VOSN26PKkU3kIMo2
         J2iqWrhCpI+e7TqllxAYQFAwJh9biotY0WOEaMZn4QUIpGGl3HUs/q+pG+UeLmqTXWSu
         A/3yDJYshfeskOTrwjrVlCx/ArVjdG1gPxYZGCo2g2q4suxQAUSKAeN73RQuqoO4QNIN
         AcrwlhAGAMIbz4nw4dyOuQ8kHXuwMVs7Krl9yXh3ws5FUXdFx7fCvYpApTwmIhrkxp5Z
         Wfkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uY9PWBYEWa+L7/vef7H+7Msq9Ws/A/8yhidf9SuVVdo=;
        b=IodKotJ8DdAuFJ0vp6u1KwPLY7b+7o1kFM7X2MFA0982b6QExxdqcHFd1bqqLDuveO
         VqQsB7f3uvqKQL/Vt44A8lLqb/SZOkQkJ+oTfGDY2wRtOPKilynhm/CTgD9C7mi58Lx2
         EHHG1x4WQPIUuLWKKaINRqEDcXnfTyyZMn0bToIg9eadVeTwVbjJd6uy0HW2ZESxUnwa
         CljbuCKHsWFpU8TADQ6yQm544y+gw/sLN+7ZfAMHiqn7BkZGRxyivSgGmQArih7r9JVT
         HvgZ7yWV907airnvYrQymIX+/W9fFlFwTt3D1Kv892Xz5b4jU+tPuImEZwaKWxTpIvBc
         0wgA==
X-Gm-Message-State: AOAM533HJusMZUTVcTa/XnzIYkEmbyj7FQT/3rwnJSWPhKMYvnH12eTk
        lf75PCmn6oOqTsQNZpU8EY2EHRIeV+mkD0hrgW4=
X-Google-Smtp-Source: ABdhPJwYGPAAMc3y+Uru+VNdpcYQY2OzRg5fKVOCEp102kweHijm0h8UULlRwzlzBwxBSa0AZ5ZVGBGHuV6f578AZ68=
X-Received: by 2002:a05:651c:c7:: with SMTP id 7mr1217870ljr.116.1607524331683;
 Wed, 09 Dec 2020 06:32:11 -0800 (PST)
MIME-Version: 1.0
References: <20201209122051.26151-1-o.rempel@pengutronix.de>
In-Reply-To: <20201209122051.26151-1-o.rempel@pengutronix.de>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 9 Dec 2020 11:32:00 -0300
Message-ID: <CAOMZO5ChsXQk15o4aYf-mTmTVqhFTgKJUNbthnzGtWBhwj9zRw@mail.gmail.com>
Subject: Re: [PATCH v1] ARM: imx: mach-imx6ul: remove 14x14 EVK specific PHY fixup
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 9, 2020 at 9:21 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>
> Remove board specific PHY fixup introduced by commit:
>
> | 709bc0657fe6f9f5 ("ARM: imx6ul: add fec MAC refrence clock and phy fixup init")
>
> This fixup addresses boards with a specific configuration: a KSZ8081RNA
> PHY with attached clock source to XI (Pin 8) of the PHY equal to 50MHz.
>
> For the KSZ8081RND PHY, the meaning of the reg 0x1F bit 7 is different
> (compared to the KSZ8081RNA). A set bit means:
>
> - KSZ8081RNA: clock input to XI (Pin 8) is 50MHz for RMII
> - KSZ8081RND: clock input to XI (Pin 8) is 25MHz for RMII
>
> In other configurations, for example a KSZ8081RND PHY or a KSZ8081RNA
> with 25Mhz clock source, the PHY will glitch and stay in not recoverable
> state.
>
> It is not possible to detect the clock source frequency of the PHY. And
> it is not possible to automatically detect KSZ8081 PHY variant - both
> have same PHY ID. It is not possible to overwrite the fixup
> configuration by providing proper device tree description. The only way
> is to remove this fixup.
>
> If this patch breaks network functionality on your board, fix it by
> adding PHY node with following properties:
>
>         ethernet-phy@x {
>                 ...
>                 micrel,led-mode = <1>;
>                 clocks = <&clks IMX6UL_CLK_ENET_REF>;
>                 clock-names = "rmii-ref";
>                 ...
>         };
>
> The board which was referred in the initial patch is already fixed.
> See: arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Fabio Estevam <festevam@gmail.com>
