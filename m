Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E007B207397
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 14:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390838AbgFXMmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 08:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389211AbgFXMmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 08:42:51 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E2CC061573;
        Wed, 24 Jun 2020 05:42:51 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id y10so2329071eje.1;
        Wed, 24 Jun 2020 05:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Ml8IEXnxlcphMCeOPuUacNA9+fRNhaDcQOn9VWlYsY=;
        b=kcOujtdCj9nWIxDRg7YAh1GMY7/Edl5qEITr+WMixYypg2DMLokLE6LUnHGdVKXTiG
         aYxnA18xegXnzogLI1H6Xm+JjDN4Rdc+4jmPsJGWscMmdmncmAzzCleiIfh/x1235Yg6
         DIbYcOE5EBoMEwxkIUjmhw5jQ1yOpyJt58zt7DbtD8laWvpTXBfzvzqR5BX6+7uSf6GZ
         GGQckWFsREkJTepmLP86YFsAxC4r4AnRBBVwJwBj1r43QuPEg/0FJsdZdu8q6GmAa4KK
         biipx2ksfx8k/Y0e/EiVdE9Dci/q4vEOJYMF3B1WCEfMK16bU8mCQaCJZDhY93tHVMUD
         d51Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Ml8IEXnxlcphMCeOPuUacNA9+fRNhaDcQOn9VWlYsY=;
        b=SGukTzAaNJ28UVU2JpNtyQfi7lLnN15UfG+JVDY7F4DZ4uBSPCPhUvGtTNCxKT3N5w
         uWW1MYlCL13ISyfoSXLZRgGJ0cPqJSZ1SD4zVs+3ZzJtiMV5YAAdMBW17h4vblaKxJk4
         yTZ4zTDO3uDgN7pHwy8CjsrzbPMjNMZENLRN+sKlZ0LNaIW/EesdCI5YG5zDJUKpqYWM
         aOBZ+k7KUiLHI8BX9J6lAFHYGTp5xBSWjGxy1bK/STPqpcjWTJMseGeNuLBj1i7Gpa5l
         lhmuK/ot6tW3ELev8foNkqIBP1I2/MucYBWwr2pO2cBJArvLQXlAs9ZDKe2Apbkr5BCy
         Gb5A==
X-Gm-Message-State: AOAM531jYekHIQoD2vMaPYBqKSjklbVWZQB7xBX7QGLL089BUHJ2jSIk
        VxhaUMBynvuGdomiMAHxLJrdacF4/2de5hRnrTXVJQ==
X-Google-Smtp-Source: ABdhPJyjIokjbdiL94vFu34yuvT5zlrneEHEcaS9NagGBi5uR4r7zEn0+ZucO+th0nUUaL5SIH6RUpYDF5nOCxzUWBE=
X-Received: by 2002:a17:906:492:: with SMTP id f18mr14945035eja.279.1593002569588;
 Wed, 24 Jun 2020 05:42:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200624124013.3210537-1-olteanv@gmail.com>
In-Reply-To: <20200624124013.3210537-1-olteanv@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 24 Jun 2020 15:42:38 +0300
Message-ID: <CA+h21hrnYCDGH035AKssimEMy67k+2VzyirprPSyhrkjuMUFkw@mail.gmail.com>
Subject: Re: [PATCH stable-5.4.y] Revert "dpaa_eth: fix usage as DSA master,
 try 3"
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>
Cc:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        fido_max@inbox.ru, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Jun 2020 at 15:40, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> This reverts commit b145710b69388aa4034d32b4a937f18f66b5538e.

Sorry, this sha1sum is wrong, I forgot to update it from 4.19. I'll send a v2.

>
> The patch is not wrong, but the Fixes: tag is. It should have been:
>
>         Fixes: 060ad66f9795 ("dpaa_eth: change DMA device")
>
> which means that it's fixing a commit which was introduced in:
>
> git tag --contains 060ad66f97954
> v5.5
>
> which then means it should have not been backported to linux-5.4.y,
> where things _were_ working and now they're not.
>
> Reported-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index 6683409fbd4a..4b21ae27a9fd 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -2796,7 +2796,7 @@ static int dpaa_eth_probe(struct platform_device *pdev)
>         }
>
>         /* Do this here, so we can be verbose early */
> -       SET_NETDEV_DEV(net_dev, dev->parent);
> +       SET_NETDEV_DEV(net_dev, dev);
>         dev_set_drvdata(dev, net_dev);
>
>         priv = netdev_priv(net_dev);
> --
> 2.25.1
>
