Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9F141D73A
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 12:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349677AbhI3KKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 06:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349640AbhI3KKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 06:10:15 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09DBC06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 03:08:32 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id i4so23186694lfv.4
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 03:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mwTJIBSdS6R0C6OOzQhsYG/CA9Av8xCuOU1iydIZfq8=;
        b=ivZCT+RSpG5Lr3g/DnUUf9qNfJjNYEBDbk0sXckN3US/d3v73YYcN23q0gW1WEDlCF
         4QdzhSNaM0Lm9mjqyKiP/SvHhFGovDkoONIkjO6jEXsrqXkeuyGKcdG2dAh8vfVEmSRj
         nke3WD52VbQKrXvU5FjyYTgmtUKEHPvQpiBan+Leef4aA7HQdSVd7xVwJ67rmFFTYmIt
         zE+4gHgh7oa4RgNQvVReezvOaMgOIT+2CvBjbFAVrMr2Ej5UazkPfRl0orjBYUB0/MF5
         4C2cUNV52DHLyVT8sMkGmEiMl7PP1Efg+OV9kaU8DlpmA6RXnUJOzKC55Om6qfkezQHS
         mQgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mwTJIBSdS6R0C6OOzQhsYG/CA9Av8xCuOU1iydIZfq8=;
        b=QRMRmGrBM/rPRPLqzBQbc2UT1Xc0ZnJM1wmREKOUiMs72X+ffDZ2NjPZ4BVL6PQMKo
         4NCxs7Fswa1Ioj5uqOP6tte8bUg57goUcYDoaTk7iinoRWh2+dH6zqt21lc1Nh+I8gZL
         CNfuYn3wQhCnm60BiyLz0uBzpzUMJ6GLlQh3Dc/ay+/zNaaOAKEhGr+8eJ0Wjcw3AduO
         wmBsgwdsR0d2XxVpi2JnbuI4z31fLuz603NojE0aUk9MNqyibKxU4FV7RizVl/K6nPsZ
         PDDEVhUcoYSWC1MYVpKhpZ3mph2dy78qtsHkjhC+VA2NRFmknIOhht3Fd0GLwMbDTpog
         nkvA==
X-Gm-Message-State: AOAM532jHqFJSSDoyJwt77xWMXIzzuFWQ6eQdF1qV+nEN/rReODtpaWo
        mr8HToSF3iE8b7TxBpslhB60ilQ3G9Ltx05fEKlDIQ==
X-Google-Smtp-Source: ABdhPJxp5GhGqokFxVNBLzc5wAxYntlHon3eHPcHlnoTTXeNni+3NFATmwx155GBOUerq63XPBnIf991pZVt2hJfQIM=
X-Received: by 2002:a2e:898c:: with SMTP id c12mr5105509lji.16.1632996511275;
 Thu, 30 Sep 2021 03:08:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com> <20210920161136.2398632-9-Jerome.Pouiller@silabs.com>
In-Reply-To: <20210920161136.2398632-9-Jerome.Pouiller@silabs.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 30 Sep 2021 12:07:55 +0200
Message-ID: <CAPDyKFp2_41mScO=-Ev+kvYD5xjShQdLugU_2FTTmvzgCxmEWA@mail.gmail.com>
Subject: Re: [PATCH v7 08/24] wfx: add bus_sdio.c
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Sept 2021 at 18:12, Jerome Pouiller
<Jerome.Pouiller@silabs.com> wrote:
>
> From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>
> Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/net/wireless/silabs/wfx/bus_sdio.c | 261 +++++++++++++++++++++
>  1 file changed, 261 insertions(+)
>  create mode 100644 drivers/net/wireless/silabs/wfx/bus_sdio.c
>
> diff --git a/drivers/net/wireless/silabs/wfx/bus_sdio.c b/drivers/net/wir=
eless/silabs/wfx/bus_sdio.c

[...]

> +
> +static int wfx_sdio_probe(struct sdio_func *func,
> +                         const struct sdio_device_id *id)
> +{
> +       struct device_node *np =3D func->dev.of_node;
> +       struct wfx_sdio_priv *bus;
> +       int ret;
> +
> +       if (func->num !=3D 1) {
> +               dev_err(&func->dev, "SDIO function number is %d while it =
should always be 1 (unsupported chip?)\n",
> +                       func->num);
> +               return -ENODEV;
> +       }
> +
> +       bus =3D devm_kzalloc(&func->dev, sizeof(*bus), GFP_KERNEL);
> +       if (!bus)
> +               return -ENOMEM;
> +
> +       if (!np || !of_match_node(wfx_sdio_of_match, np)) {
> +               dev_warn(&func->dev, "no compatible device found in DT\n"=
);
> +               return -ENODEV;
> +       }
> +
> +       bus->func =3D func;
> +       bus->of_irq =3D irq_of_parse_and_map(np, 0);
> +       sdio_set_drvdata(func, bus);
> +       func->card->quirks |=3D MMC_QUIRK_LENIENT_FN0 |
> +                             MMC_QUIRK_BLKSZ_FOR_BYTE_MODE |
> +                             MMC_QUIRK_BROKEN_BYTE_MODE_512;

I would rather see that you add an SDIO_FIXUP for the SDIO card, to
the sdio_fixup_methods[], in drivers/mmc/core/quirks.h, instead of
this.

> +
> +       sdio_claim_host(func);
> +       ret =3D sdio_enable_func(func);
> +       /* Block of 64 bytes is more efficient than 512B for frame sizes =
< 4k */
> +       sdio_set_block_size(func, 64);
> +       sdio_release_host(func);
> +       if (ret)
> +               return ret;
> +
> +       bus->core =3D wfx_init_common(&func->dev, &wfx_sdio_pdata,
> +                                   &wfx_sdio_hwbus_ops, bus);
> +       if (!bus->core) {
> +               ret =3D -EIO;
> +               goto sdio_release;
> +       }
> +
> +       ret =3D wfx_probe(bus->core);
> +       if (ret)
> +               goto sdio_release;
> +
> +       return 0;
> +
> +sdio_release:
> +       sdio_claim_host(func);
> +       sdio_disable_func(func);
> +       sdio_release_host(func);
> +       return ret;
> +}
> +
> +static void wfx_sdio_remove(struct sdio_func *func)
> +{
> +       struct wfx_sdio_priv *bus =3D sdio_get_drvdata(func);
> +
> +       wfx_release(bus->core);
> +       sdio_claim_host(func);
> +       sdio_disable_func(func);
> +       sdio_release_host(func);
> +}
> +
> +static const struct sdio_device_id wfx_sdio_ids[] =3D {
> +       { SDIO_DEVICE(SDIO_VENDOR_ID_SILABS, SDIO_DEVICE_ID_SILABS_WF200)=
 },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(sdio, wfx_sdio_ids);
> +
> +struct sdio_driver wfx_sdio_driver =3D {
> +       .name =3D "wfx-sdio",
> +       .id_table =3D wfx_sdio_ids,
> +       .probe =3D wfx_sdio_probe,
> +       .remove =3D wfx_sdio_remove,
> +       .drv =3D {
> +               .owner =3D THIS_MODULE,
> +               .of_match_table =3D wfx_sdio_of_match,

Is there no power management? Or do you intend to add that on top?

> +       }
> +};
> --
> 2.33.0
>

Kind regards
Uffe
