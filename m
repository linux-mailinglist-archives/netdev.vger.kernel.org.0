Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C472DDD5D
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 04:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732733AbgLRDe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 22:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732715AbgLRDe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 22:34:56 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78D9C0617A7
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 19:34:15 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id g24so444311qtq.12
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 19:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IDx9TaTlrtlIy3LwyY3v6JTSWWKD8mwpXaG0JjxaS24=;
        b=SlMzwF0y6pOpcqPiZCbUWErI2aJ4Qec2sOSWj1qThCJmeTCYXwmNW1SFma2DLd1cGu
         f3X90sAphnaOMPe74Xo4CZ1HKqkZcVz0vOm7R4rsp2dagpU7Q9E3YzX3Xx8bYUxjVrWy
         YxLvJxt/KVgiTZzKN9M/a5oW1BJK3y6/xD+x0EmHQzRFkB8cu802/c3uaepNFVYHfRX2
         UotS8HmyySy66MOMexpg5TqubSpwd+ErS/ICJppgEAMixpTRcoKzgaT3WAzMvXue21tZ
         eqCsElsHkUYH9F946WjnnJpNPrUQUQJBWJqjGHNGWGV792v9GOkr0mft2VoTxGVBch75
         neMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IDx9TaTlrtlIy3LwyY3v6JTSWWKD8mwpXaG0JjxaS24=;
        b=MmFFD8AL/uSMR8e4OfUevtkmfFkdVsUtcqoR0wpMPKfCd5sPbX/EKlkzFEYcFO7IP3
         KjoedBVPP+YPmE8/Eg1c6MIxBGPiINpvPBf0z14j3o6OztlPxE8V/cYqAVrrHJbn2ZRA
         /M9S9BRSIQqASYHPgVPIRYcrDeJurPGDsUlxK+VmMIoAFfdhgzJ4RYICM20qcA7hpKE3
         SYxEwiUh/hhUuSsJjWJVfy66lYkkvedD5lrs/WpUxqp+8W34yMyb+oyoF0exzZExHd5w
         gAY0D6WtNjifg9joFEwLMtPhKw5xBo5yOD4BfE+UsWw060aRW4bSxLoODAAogPpMvK1V
         CJRA==
X-Gm-Message-State: AOAM530Ki/urDUTf38zKtps7ZLqNmvOtoVDxGLBFIIpqk4gxZO6v1cS4
        h6J8vDmQL+eR4GPYRzhSSQnlzQp1m56Fq/pW8ZevHA==
X-Google-Smtp-Source: ABdhPJwZtCEoVgZKzc5N0KEbf32ptMfnyARzBYf+ZL81LWijXKO96aKnogXClrO8QrPsrwnDkTyOFsSD5GhOjtHB0BM=
X-Received: by 2002:a05:622a:18d:: with SMTP id s13mr2121237qtw.306.1608262455132;
 Thu, 17 Dec 2020 19:34:15 -0800 (PST)
MIME-Version: 1.0
References: <1608208648-13710-1-git-send-email-stefanc@marvell.com>
In-Reply-To: <1608208648-13710-1-git-send-email-stefanc@marvell.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Fri, 18 Dec 2020 04:34:03 +0100
Message-ID: <CAPv3WKd-=ywD4E6VBgMmkrpEtEHDXjK0ix-cJc1UKnUHAPk_BQ@mail.gmail.com>
Subject: Re: [PATCH net v3] net: mvpp2: Fix GoP port 3 Networking Complex
 Control configurations
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, nadavh@marvell.com,
        Yan Markman <ymarkman@marvell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

czw., 17 gru 2020 o 13:40 <stefanc@marvell.com> napisa=C5=82(a):
>
> From: Stefan Chulski <stefanc@marvell.com>
>
> During GoP port 2 Networking Complex Control mode of operation configurat=
ions,
> also GoP port 3 mode of operation was wrongly set.
> Patch removes these configurations.
> GENCONF_CTRL0_PORTX naming also fixed.
>
> Cc: stable@vger.kernel.org
> Fixes: f84bf386f395 ("net: mvpp2: initialize the GoP")
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> ---
>
> Changes in v3:
> - Added cc stable@vger.kernel.org
> Changes in v2:
> - Added Fixes tag.
>
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 6 +++---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 8 ++++----
>  2 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/eth=
ernet/marvell/mvpp2/mvpp2.h
> index 6bd7e40..39c4e5c 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> @@ -651,9 +651,9 @@
>  #define     GENCONF_PORT_CTRL1_EN(p)                   BIT(p)
>  #define     GENCONF_PORT_CTRL1_RESET(p)                        (BIT(p) <=
< 28)
>  #define GENCONF_CTRL0                                  0x1120
> -#define     GENCONF_CTRL0_PORT0_RGMII                  BIT(0)
> -#define     GENCONF_CTRL0_PORT1_RGMII_MII              BIT(1)
> -#define     GENCONF_CTRL0_PORT1_RGMII                  BIT(2)
> +#define     GENCONF_CTRL0_PORT2_RGMII                  BIT(0)
> +#define     GENCONF_CTRL0_PORT3_RGMII_MII              BIT(1)
> +#define     GENCONF_CTRL0_PORT3_RGMII                  BIT(2)
>
>  /* Various constants */
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
> index d64dc12..d2b0506 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -1231,9 +1231,9 @@ static void mvpp22_gop_init_rgmii(struct mvpp2_port=
 *port)
>
>         regmap_read(priv->sysctrl_base, GENCONF_CTRL0, &val);
>         if (port->gop_id =3D=3D 2)
> -               val |=3D GENCONF_CTRL0_PORT0_RGMII | GENCONF_CTRL0_PORT1_=
RGMII;
> +               val |=3D GENCONF_CTRL0_PORT2_RGMII;
>         else if (port->gop_id =3D=3D 3)
> -               val |=3D GENCONF_CTRL0_PORT1_RGMII_MII;
> +               val |=3D GENCONF_CTRL0_PORT3_RGMII_MII;
>         regmap_write(priv->sysctrl_base, GENCONF_CTRL0, val);
>  }
>
> @@ -1250,9 +1250,9 @@ static void mvpp22_gop_init_sgmii(struct mvpp2_port=
 *port)
>         if (port->gop_id > 1) {
>                 regmap_read(priv->sysctrl_base, GENCONF_CTRL0, &val);
>                 if (port->gop_id =3D=3D 2)
> -                       val &=3D ~GENCONF_CTRL0_PORT0_RGMII;
> +                       val &=3D ~GENCONF_CTRL0_PORT2_RGMII;
>                 else if (port->gop_id =3D=3D 3)
> -                       val &=3D ~GENCONF_CTRL0_PORT1_RGMII_MII;
> +                       val &=3D ~GENCONF_CTRL0_PORT3_RGMII_MII;
>                 regmap_write(priv->sysctrl_base, GENCONF_CTRL0, val);
>         }
>  }
> --

I tested the patch and LGTM.

Acked-by: Marcin Wojtas <mw@semihalf.com>

Thanks,
Marcin
