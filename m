Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96F22B1837
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 10:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgKMJ1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 04:27:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:48644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbgKMJ1c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 04:27:32 -0500
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 066AD22250
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 09:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605259652;
        bh=OIM03Fej0Qv7ys4fG+OsO5oPdBvHvBk4pQGuvEDfeY4=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=nZ0r/kocNVEoHSptb4nNkyMSdwCC+Ve7UACrpO1YY63cnNC2l2vZ20RRRJ/ElEVfd
         aRUBNveb8zW5bSazIWL+KJWw32nw9VQ1t5qAA6oyxhgpoM6o20PJgwkE6Q7N/+PL45
         xmDOffz34cWzMZYunLOLJ7ymzhyokKCStC7A+3wI=
Received: by mail-oi1-f169.google.com with SMTP id c128so1399014oia.6
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 01:27:31 -0800 (PST)
X-Gm-Message-State: AOAM533fkL+uJFWnzHhpPeW03Oo/Po5C68DTanSqKtBeNZG+cFYnEDK+
        kThQsNKfRiybgoCzATzeBBuU1Est/Bv8VblTidd7kg==
X-Google-Smtp-Source: ABdhPJwUx3S73L9XUE7mVfp7hH73qWmdFgeySdKDNxGnovyGciPUTZWyy2UDCaldkGC4ad9qA374P5Lx1TFP8OSAbMk=
X-Received: by 2002:aca:3a04:: with SMTP id h4mr810472oia.42.1605259651226;
 Fri, 13 Nov 2020 01:27:31 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 13 Nov 2020 09:27:30 +0000
MIME-Version: 1.0
In-Reply-To: <20201113091116.1102450-1-steen.hegelund@microchip.com>
References: <20201113091116.1102450-1-steen.hegelund@microchip.com>
From:   Antoine Tenart <atenart@kernel.org>
Date:   Fri, 13 Nov 2020 09:27:30 +0000
X-Gmail-Original-Message-ID: <CADCXZ1wx_Uxp46hRDuQakzApPTRLKufyoH-tybyQ4m3nvV=w7A@mail.gmail.com>
Message-ID: <CADCXZ1wx_Uxp46hRDuQakzApPTRLKufyoH-tybyQ4m3nvV=w7A@mail.gmail.com>
Subject: Re: [PATCH net v2] net: phy: mscc: remove non-MACSec compatible phy
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Bryan Whitehead <Bryan.Whitehead@microchip.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        John Haechten <John.Haechten@microchip.com>,
        Netdev List <netdev@vger.kernel.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Steen Hegelund (2020-11-13 10:11:16)
> Selecting VSC8575 as a MACSec PHY was not correct
>
> The relevant datasheet can be found here:
>   - VSC8575: https://www.microchip.com/wwwproducts/en/VSC8575
>
> History:
> v1 -> v2:
>    - Corrected the sha in the "Fixes:" tag
>
> Fixes: 1bbe0ecc2a1a ("net: phy: mscc: macsec initialization")
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>

Reviewed-by: Antoine Tenart <atenart@kernel.org>

Small comment: you can put the commit history after the --- so it
doesn't end-up in the commit log (except when it's relevant, which isn't
the case here). I don't think that's a blocker though.

Thanks Steen!
Antoine

> ---
>  drivers/net/phy/mscc/mscc_macsec.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
> index 1d4c012194e9..72292bf6c51c 100644
> --- a/drivers/net/phy/mscc/mscc_macsec.c
> +++ b/drivers/net/phy/mscc/mscc_macsec.c
> @@ -981,7 +981,6 @@ int vsc8584_macsec_init(struct phy_device *phydev)
>
>         switch (phydev->phy_id & phydev->drv->phy_id_mask) {
>         case PHY_ID_VSC856X:
> -       case PHY_ID_VSC8575:
>         case PHY_ID_VSC8582:
>         case PHY_ID_VSC8584:
>                 INIT_LIST_HEAD(&vsc8531->macsec_flows);
> --
> 2.29.2
>
