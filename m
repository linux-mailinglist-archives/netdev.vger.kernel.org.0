Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB8C35586E
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 17:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243616AbhDFPrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 11:47:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:34804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231660AbhDFPr3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 11:47:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26DFC613D2;
        Tue,  6 Apr 2021 15:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617724041;
        bh=DFaOWabX6uQJ7AB1bWPr2ONxe1vKEsQZrlZeDjFgyJE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iKTHjVScP3g8MRFsXhwXqxpDVchRxvLeFA1FG6RctDDEjc0dAh1cg3sZLnyyceOHO
         oqER5iZfkB5hdh7DkWmuuKWBbEX0ZWXXoIA//skgZKROsJOYxUDhcXJf+eaG93ZXpY
         XdbKq9QZoinEcjgCw7UnY7ecXPM98QDTYcfzbAyCH+3wInac01i3tGxyIjy0kZ97na
         4NNtT9TdH///1r36bSojvOWr+wb2umBUzundjPre9Z5Tg0jvFlQlG6nyDJrqCvInF8
         xPurIbVlvdd3LLVDbHDvR8BO8tfhCI3/1KPu4HUwbfBilzjC1QcAIZg3FL0N6C0SPR
         5e1GFjZBWOlcA==
Received: by mail-ej1-f47.google.com with SMTP id r9so187791ejj.3;
        Tue, 06 Apr 2021 08:47:21 -0700 (PDT)
X-Gm-Message-State: AOAM533e8aLndUiyTWTi8r3zFzKLpwATscQpSSEuwEuQ8V2MU0pNBbwg
        8jXEAdBzUydE/5a4bPMjfvkFVz9UBS09NrXYoQ==
X-Google-Smtp-Source: ABdhPJxSwuv5A1N5e6l0r3zr4OOt2uoKpaG87wBCP8goBoJPv9P4enuywxUM1fm+tIMiIDXlHvq+vFNKavllmgy4s60=
X-Received: by 2002:a17:907:629c:: with SMTP id nd28mr35315677ejc.267.1617724039596;
 Tue, 06 Apr 2021 08:47:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210406141819.1025864-1-dqfext@gmail.com> <20210406141819.1025864-2-dqfext@gmail.com>
In-Reply-To: <20210406141819.1025864-2-dqfext@gmail.com>
From:   Chun-Kuang Hu <chunkuang.hu@kernel.org>
Date:   Tue, 6 Apr 2021 23:47:08 +0800
X-Gmail-Original-Message-ID: <CAAOTY_8snSTcguhyB9PJBWydqNaWZL3V4zXiYULVp5n48fN24w@mail.gmail.com>
Message-ID: <CAAOTY_8snSTcguhyB9PJBWydqNaWZL3V4zXiYULVp5n48fN24w@mail.gmail.com>
Subject: Re: [RFC net-next 1/4] net: phy: add MediaTek PHY driver
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-staging@lists.linux.dev, DTML <devicetree@vger.kernel.org>,
        netdev@vger.kernel.org, Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Qingfang:

DENG Qingfang <dqfext@gmail.com> =E6=96=BC 2021=E5=B9=B44=E6=9C=886=E6=97=
=A5 =E9=80=B1=E4=BA=8C =E4=B8=8B=E5=8D=8810:19=E5=AF=AB=E9=81=93=EF=BC=9A
>
> Add support for MediaTek PHYs found in MT7530 and MT7531 switches.
> The initialization procedure is from the vendor driver, but due to lack
> of documentation, the function of some register values remains unknown.
>
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
>  drivers/net/phy/Kconfig    |   5 ++
>  drivers/net/phy/Makefile   |   1 +
>  drivers/net/phy/mediatek.c | 109 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 115 insertions(+)
>  create mode 100644 drivers/net/phy/mediatek.c
>
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index a615b3660b05..edd858cec9ec 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -207,6 +207,11 @@ config MARVELL_88X2222_PHY
>           Support for the Marvell 88X2222 Dual-port Multi-speed Ethernet
>           Transceiver.
>
> +config MEDIATEK_PHY

There are many Mediatek phy drivers in [1], so use a specific name.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/drivers/phy/mediatek?h=3Dv5.12-rc6

Regards,
Chun-Kuang.

> +       tristate "MediaTek PHYs"
> +       help
> +         Supports the MediaTek switch integrated PHYs.
> +
>  config MICREL_PHY
>         tristate "Micrel PHYs"
>         help
