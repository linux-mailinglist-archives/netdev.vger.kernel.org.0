Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C514941F156
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355069AbhJAPkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354702AbhJAPkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:40:01 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50403C06177E
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 08:38:16 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id e15so40352051lfr.10
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 08:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6A5eWZRYPq2y4phPK9+CWlezfURq0tv1a8DQf5ALkTk=;
        b=O+MJpMdT+wGtP+L8d5YpDRq5uey0ctUtAD658N0P3a/rrf3cCwvjwKblyMc8BrpLKc
         ZtlilAwX54jLce3m+AuzyBKpoBiblrSQtGPUanvdP+L3p/yGQp2/fR9Ras2oofTNACFE
         5klqHeXe3dXV/7bw9GItNLb6s54DmQnNtkZlsTQysNE9BID/KXYNZNjL+YVGN90n6A/j
         FVURrF/pCISPIYCn96pzNv/xglnMhTOvKtNak3d15JjtBnYG3QIHaPmm5C5qHkpQ3LKc
         dzaMpVaomTHMZBGbLM+1e5i7ZOzCSZ4xbY40bR+E5g5Fa1Kg+GMFgpzCVZ4oX0Ahic0v
         9p1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6A5eWZRYPq2y4phPK9+CWlezfURq0tv1a8DQf5ALkTk=;
        b=ex5tbP4LhyBvJZqsr1vqtMAM2O5zVxqR0CTAwWdCYbJQxHTzrwgL5qmm367gaj0IEx
         MaLW5lKH2n0l0UW2vwRaSLs2+ev42jd6QGDoQjzS2h2JmyQIcQrNcoe8I5mpTfjsk2S/
         MuTVThOIWJi9hqZqVKd0EckScBeg/YpaFoIjcUReb1E1vwpnQ7Nox8t5SYjiPokAkA2c
         i9XQ6xXoaGnKxOXW8oTBHWY/ps1x+mGWBXp2XTXF+a8iPcJ9sRbj4Bvq7yB170Gy/Rtq
         BHxH8CrQQVlvqPKcn1PAZgJqg3pWsl38wXQXDqkTmmpbGjBFe+2nyEtjiID2Od+5SBkY
         S/0w==
X-Gm-Message-State: AOAM531Qk32XI/Pt0/H9kwB0Utjw7ZusRweEfW5EtxNxScvQxi+uI3xy
        xCN8UgejB8BTz9OC6e//RHVcSxRSeQv49hDSaWGZcA==
X-Google-Smtp-Source: ABdhPJwoZz8ZbUHqp0gwTDx94pmhbFjVKS3zXTpbCPNRVrdBj9Exo6x5JROj2k8NVSQkldadAtO8LBiB11Huutsiuto=
X-Received: by 2002:a05:651c:213:: with SMTP id y19mr12199656ljn.273.1633102694548;
 Fri, 01 Oct 2021 08:38:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
 <20210920161136.2398632-9-Jerome.Pouiller@silabs.com> <CAPDyKFp2_41mScO=-Ev+kvYD5xjShQdLugU_2FTTmvzgCxmEWA@mail.gmail.com>
 <19731906.ZuIkq4dnIL@pc-42>
In-Reply-To: <19731906.ZuIkq4dnIL@pc-42>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri, 1 Oct 2021 17:37:38 +0200
Message-ID: <CAPDyKFpbZypaLVmE2J+rGzAXgdWp1koD8pRxBKo3kFK3NDTFWw@mail.gmail.com>
Subject: Re: [PATCH v7 08/24] wfx: add bus_sdio.c
To:     =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>
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

On Thu, 30 Sept 2021 at 18:51, J=C3=A9r=C3=B4me Pouiller
<jerome.pouiller@silabs.com> wrote:
>
> Hello Ulf,
>
> On Thursday 30 September 2021 12:07:55 CEST Ulf Hansson wrote:
> > On Mon, 20 Sept 2021 at 18:12, Jerome Pouiller
> > <Jerome.Pouiller@silabs.com> wrote:
> > >
> > > From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
> > >
> > > Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
> > > ---
> > >  drivers/net/wireless/silabs/wfx/bus_sdio.c | 261 +++++++++++++++++++=
++
> > >  1 file changed, 261 insertions(+)
> > >  create mode 100644 drivers/net/wireless/silabs/wfx/bus_sdio.c
> > >
> > > diff --git a/drivers/net/wireless/silabs/wfx/bus_sdio.c b/drivers/net=
/wireless/silabs/wfx/bus_sdio.c
> >
> > [...]
> >
> > > +
> > > +static int wfx_sdio_probe(struct sdio_func *func,
> > > +                         const struct sdio_device_id *id)
> > > +{
> > > +       struct device_node *np =3D func->dev.of_node;
> > > +       struct wfx_sdio_priv *bus;
> > > +       int ret;
> > > +
> > > +       if (func->num !=3D 1) {
> > > +               dev_err(&func->dev, "SDIO function number is %d while=
 it should always be 1 (unsupported chip?)\n",
> > > +                       func->num);
> > > +               return -ENODEV;
> > > +       }
> > > +
> > > +       bus =3D devm_kzalloc(&func->dev, sizeof(*bus), GFP_KERNEL);
> > > +       if (!bus)
> > > +               return -ENOMEM;
> > > +
> > > +       if (!np || !of_match_node(wfx_sdio_of_match, np)) {
> > > +               dev_warn(&func->dev, "no compatible device found in D=
T\n");
> > > +               return -ENODEV;
> > > +       }
> > > +
> > > +       bus->func =3D func;
> > > +       bus->of_irq =3D irq_of_parse_and_map(np, 0);
> > > +       sdio_set_drvdata(func, bus);
> > > +       func->card->quirks |=3D MMC_QUIRK_LENIENT_FN0 |
> > > +                             MMC_QUIRK_BLKSZ_FOR_BYTE_MODE |
> > > +                             MMC_QUIRK_BROKEN_BYTE_MODE_512;
> >
> > I would rather see that you add an SDIO_FIXUP for the SDIO card, to
> > the sdio_fixup_methods[], in drivers/mmc/core/quirks.h, instead of
> > this.
>
> In the current patch, these quirks are applied only if the device appears
> in the device tree (see the condition above). If I implement them in
> drivers/mmc/core/quirks.h they will be applied as soon as the device is
> detected. Is it what we want?
>
> Note: we already have had a discussion about the strange VID/PID declared
> by this device:
>   https://www.spinics.net/lists/netdev/msg692577.html

Please, see my other reply to Pali.

>
>
> [...]
> > > +
> > > +static const struct sdio_device_id wfx_sdio_ids[] =3D {
> > > +       { SDIO_DEVICE(SDIO_VENDOR_ID_SILABS, SDIO_DEVICE_ID_SILABS_WF=
200) },
> > > +       { },
> > > +};
> > > +MODULE_DEVICE_TABLE(sdio, wfx_sdio_ids);
> > > +
> > > +struct sdio_driver wfx_sdio_driver =3D {
> > > +       .name =3D "wfx-sdio",
> > > +       .id_table =3D wfx_sdio_ids,
> > > +       .probe =3D wfx_sdio_probe,
> > > +       .remove =3D wfx_sdio_remove,
> > > +       .drv =3D {
> > > +               .owner =3D THIS_MODULE,
> > > +               .of_match_table =3D wfx_sdio_of_match,
> >
> > Is there no power management? Or do you intend to add that on top?
>
> It seems we already have had this discussion:
>
>   https://lore.kernel.org/netdev/CAPDyKFqJf=3DvUqpQg3suDCadKrFTkQWFTY_qp=
=3D+yDK=3D_Lu9gJGg@mail.gmail.com/#r
>
> In this thread, Kalle said:
> > Many mac80211 drivers do so that the device is powered off during
> > interface down (ifconfig wlan0 down), and as mac80211 does interface
> > down automatically during suspend, suspend then works without extra
> > handlers.

Yeah, it's been a while since I looked at this, thanks for the pointer.

[...]

Kind regards
Uffe
