Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1DD312C3A
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 09:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhBHIty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 03:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbhBHIqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 03:46:45 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75479C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 00:46:05 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id ew18so6594076qvb.4
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 00:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MYEXULtURBrYR5x4jaEphkF+fEYgGc713R9ljjEEWfQ=;
        b=1QNVjAUAPbLKJZ8L42QankHMbK2kcBvt2LKwHkGkfAj22roPKp2CUeKZxsq2SgwCsA
         0yXhpQRj3KBgn3D0978kqRa7UYufER6Ugv6o7+eM1tLckcX0faqvmQRHOqM60WPL4SYH
         yy2bt7BFisa0yozUGI7UpdjsaWhqNGP7qJgwf8cn4Q82k3L9/+FpHG1V2wdefmqCxLUh
         SE7T6FR4HlHMOJXRQmqfTfT2nTB6gbXNbcPNpOxHtJmTgMQV/0pj6MwCwpxU4TtPmIBN
         HW9gE5fAsQgdmhphkU34ACM6FVrcqWxPdLxQc1K/4oDl8kbVW/yhi5wVrRSjwoptCtKP
         ozTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MYEXULtURBrYR5x4jaEphkF+fEYgGc713R9ljjEEWfQ=;
        b=uTtFk19nutwnTe4UjUZDJjF8VRssebodFdf5dynQ7p/Az2IZb1Mz8naAnRo2SlMhp6
         kU/OKin59RF8dGlvsFoRZ7po8uDFIXxLjiqwDpMJ8JmalVC+mAc3oHxnUiT84b8xLqxZ
         Tp/mSHuaaiky3ecdWiNtb81Sri4OWHfSerOalLVyCyF8MgIKcfOthl0WrVUWCZGkffry
         QgsAql2oQse8JUqyjdhtVWm8WUWrdsQWw3vH988D/ESDhd5Ay/Yx/Gse+Cp/GPbfH3Ga
         epGTYbFGVBM3LwCaQ1xAGwWE21pwlTKC9jBGS3UXHscSV+JTR6KIGiU3qlxeEMiFZhOe
         jmaQ==
X-Gm-Message-State: AOAM533IsLkSS9afp0VpvzWRRiqX/Pd7rC4t0HPBbqgzr08Kx8eBdnDk
        aA98RwgCwoPilC1qHKCrhvqHkwzgPfz7Ex49rAHRFQ==
X-Google-Smtp-Source: ABdhPJyLRl8PhZLMvYcCFuW3xOiAmvkIoEb2z/kxI22tr8bZIjGLJViHsXaVMw15iVK6wQOMx3qmC2SyHXkY4So/pZ8=
X-Received: by 2002:ad4:44a9:: with SMTP id n9mr15189468qvt.10.1612773964428;
 Mon, 08 Feb 2021 00:46:04 -0800 (PST)
MIME-Version: 1.0
References: <1612773167-22490-1-git-send-email-stefanc@marvell.com> <1612773167-22490-4-git-send-email-stefanc@marvell.com>
In-Reply-To: <1612773167-22490-4-git-send-email-stefanc@marvell.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Mon, 8 Feb 2021 09:45:53 +0100
Message-ID: <CAPv3WKfjnkAt7=cb-_90n5xziQnkunyCxfu7LHQ-RE1W_fc9bg@mail.gmail.com>
Subject: Re: [PATCH v10 net-next 03/15] net: mvpp2: add CM3 SRAM memory map
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, nadavh@marvell.com,
        Yan Markman <ymarkman@marvell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>, atenart@kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        =?UTF-8?Q?Gr=C3=A9gory_Clement?= <gregory.clement@bootlin.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

pon., 8 lut 2021 o 09:33 <stefanc@marvell.com> napisa=C5=82(a):
>
> From: Stefan Chulski <stefanc@marvell.com>
>
> This patch adds CM3 memory map and CM3 read/write callbacks.

The read/write callbacks are not added in this patch, please correct
the commit message.

Best regards,
Marcin

>
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  1 +
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 26 +++++++++++++++++++=
+
>  2 files changed, 27 insertions(+)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/eth=
ernet/marvell/mvpp2/mvpp2.h
> index 6bd7e40..56e90ab 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> @@ -925,6 +925,7 @@ struct mvpp2 {
>         /* Shared registers' base addresses */
>         void __iomem *lms_base;
>         void __iomem *iface_base;
> +       void __iomem *cm3_base;
>
>         /* On PPv2.2, each "software thread" can access the base
>          * register through a separate address space, each 64 KB apart
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
> index a07cf60..eec3796 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -6846,6 +6846,27 @@ static int mvpp2_init(struct platform_device *pdev=
, struct mvpp2 *priv)
>         return 0;
>  }
>
> +static int mvpp2_get_sram(struct platform_device *pdev,
> +                         struct mvpp2 *priv)
> +{
> +       struct resource *res;
> +
> +       res =3D platform_get_resource(pdev, IORESOURCE_MEM, 2);
> +       if (!res) {
> +               if (has_acpi_companion(&pdev->dev))
> +                       dev_warn(&pdev->dev, "ACPI is too old, Flow contr=
ol not supported\n");
> +               else
> +                       dev_warn(&pdev->dev, "DT is too old, Flow control=
 not supported\n");
> +               return 0;
> +       }
> +
> +       priv->cm3_base =3D devm_ioremap_resource(&pdev->dev, res);
> +       if (IS_ERR(priv->cm3_base))
> +               return PTR_ERR(priv->cm3_base);
> +
> +       return 0;
> +}
> +
>  static int mvpp2_probe(struct platform_device *pdev)
>  {
>         const struct acpi_device_id *acpi_id;
> @@ -6902,6 +6923,11 @@ static int mvpp2_probe(struct platform_device *pde=
v)
>                 priv->iface_base =3D devm_ioremap_resource(&pdev->dev, re=
s);
>                 if (IS_ERR(priv->iface_base))
>                         return PTR_ERR(priv->iface_base);
> +
> +               /* Map CM3 SRAM */
> +               err =3D mvpp2_get_sram(pdev, priv);
> +               if (err)
> +                       dev_warn(&pdev->dev, "Fail to alloc CM3 SRAM\n");
>         }
>
>         if (priv->hw_version =3D=3D MVPP22 && dev_of_node(&pdev->dev)) {
> --
> 1.9.1
>
