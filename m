Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2C568017B
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 22:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbjA2V0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 16:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjA2V0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 16:26:11 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082691259C;
        Sun, 29 Jan 2023 13:26:11 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id ll10so6583957qvb.6;
        Sun, 29 Jan 2023 13:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R+r5oWkcynWYgf6TrWUFBbgZPP925TAZRGhYeApXIos=;
        b=TODJo6tvZAiA3If5Qd5RPqZ3AfjHSEDACjuzxV9aGVNfNt/n2DG5rZP9fZTufoWxyO
         c3A9+ytFzygidz15K/tk7rEamQJnTB2FXMwUUmwf3o0P/qZeyaC+8r4PRyMAzvcCrSK9
         yHNH0+u0ugEtO74TdHq9jMRfmj18VlCU2u8dlXZRmWa0ibjpU8mxpZqzJO5a40Ns5ZgU
         yUxeYUqLdrXuWu4E2aAuLI+RdypfWL4Y0ohzuvlCWjWsrsR8a4qFKCljlff0x/Usfbq/
         kg+clBC0LxjiX8r+rnwea2N/K1MYily+d7L1DGgOzyyePj9i6nfmOylTR3VBF5lsI6uV
         Xs2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R+r5oWkcynWYgf6TrWUFBbgZPP925TAZRGhYeApXIos=;
        b=S9N0WmOle4Lgq4PEi5NU8+bqsZ/f0l4FInuk1wdQcbJU9mC/0lDZks3FGciNZ0D98b
         XdApPAh7ZXDrv4/Vo8Cg+Me2xEkDHphdlOf9gj0F7AveBDohNe3uouRI0MtH3Qeeyeod
         BK4ptJ07yR620rgjgErB+onxvki/lM4G13CzKIrStW+Ttx3VOm6c/iIyMHwSPqMsK+nX
         ayJkmJx9iEZk3O5ep8nJlyOGZ/LzdxZPDsnIZCdWcvpKhPpz3JqE+GmNHinaU5FnW1Rd
         mJfPf3OOGNYJs4BPE1thmhcPwUm3kIqVfwxxtDThuVAcgZYP9+UThpTfLz5NG1ARRfeW
         mdzQ==
X-Gm-Message-State: AO0yUKWhf+mKlyrdOZMa2yGy8In28y/UrWIHBL1jWsaMe5a9ZWP+/vqG
        zSqdYYQ/sDWjHUGY7ag6p7t4ekLJrbsqKPOwxeG5bdkOirY=
X-Google-Smtp-Source: AK7set/hDwAEIAnJPugzpkbNIMt6/2wCZgBGxHBdvkjSr0gEYM8NjutI4pzZ7M4BPGW2CVN4XbTn5+vgubNcChjm3mc=
X-Received: by 2002:a0c:fe07:0:b0:53b:c24d:d224 with SMTP id
 x7-20020a0cfe07000000b0053bc24dd224mr132949qvr.56.1675027570017; Sun, 29 Jan
 2023 13:26:10 -0800 (PST)
MIME-Version: 1.0
References: <20230129022615.379711-1-cphealy@gmail.com> <76e0aeea-2c15-528e-da21-4ad1f9281a13@gmail.com>
In-Reply-To: <76e0aeea-2c15-528e-da21-4ad1f9281a13@gmail.com>
From:   Chris Healy <cphealy@gmail.com>
Date:   Sun, 29 Jan 2023 13:25:59 -0800
Message-ID: <CAFXsbZo-dHvNyxLHLP2+55S=iTzDV3TUKb9=7O88yFRYW80HZw@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: phy: meson-gxl: Add generic dummy stubs for MMD
 register access
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     andrew@lunn.ch, linux@armlinux.org.uk, davem@davemloft.net,
        neil.armstrong@linaro.org, khilman@baylibre.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        jeremy.wang@amlogic.com, Chris Healy <healych@amazon.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 29, 2023 at 2:26 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 29.01.2023 03:26, Chris Healy wrote:
> > From: Chris Healy <healych@amazon.com>
> >
> Hi Chris,
>
> > The Meson G12A Internal PHY does not support standard IEEE MMD extended
> > register access, therefore add generic dummy stubs to fail the read and
> > write MMD calls. This is necessary to prevent the core PHY code from
> > erroneously believing that EEE is supported by this PHY even though this
> > PHY does not support EEE, as MMD register access returns all FFFFs.
> >
> > Signed-off-by: Chris Healy <healych@amazon.com>
> > ---
> >  drivers/net/phy/meson-gxl.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
> > index c49062ad72c6..5e41658b1e2f 100644
> > --- a/drivers/net/phy/meson-gxl.c
> > +++ b/drivers/net/phy/meson-gxl.c
> > @@ -271,6 +271,8 @@ static struct phy_driver meson_gxl_phy[] = {
> >               .handle_interrupt = meson_gxl_handle_interrupt,
> >               .suspend        = genphy_suspend,
> >               .resume         = genphy_resume,
> > +             .read_mmd       = genphy_read_mmd_unsupported,
> > +             .write_mmd      = genphy_write_mmd_unsupported,
> >       },
> >  };
> >
>
> thanks for catching this. The same issue we may have for the GXL-internal PHY.
> Did you check this?

I do not have HW with GXL-internal PHY so I cannot test it and don't
feel comfortable making the change for that PHY ID without someone
providing the necessary feedback.  If someone can confirm the same all
FFFFs with the MMD registers, I'd be happy to add the read/write MMD
callbacks for that PHY in v2.

>
> One result of the issue is the invalid ethtool --show-eee output given below.
> Therefore the patch should go to stable, please annotate it as [PATCH net].
>
> Fixes tag should be:
> 5c3407abb338 ("net: phy: meson-gxl: add g12a support")

Yep, looking at the ethtool --show-eee output is what got me looking
at this in the first place.  I was hoping to enable EEE... ;-)

I'll add the fixes tag in v2.

>
>
> EEE settings for eth0:
>         EEE status: enabled - active
>         Tx LPI: 1000000 (us)
>         Supported EEE link modes:  100baseT/Full
>                                    1000baseT/Full
>                                    10000baseT/Full
>                                    1000baseKX/Full
>                                    10000baseKX4/Full
>                                    10000baseKR/Full
>         Advertised EEE link modes:  100baseT/Full
>                                     1000baseT/Full
>                                     10000baseT/Full
>                                     1000baseKX/Full
>                                     10000baseKX4/Full
>                                     10000baseKR/Full
>         Link partner advertised EEE link modes:  100baseT/Full
>                                                  1000baseT/Full
>                                                  10000baseT/Full
>                                                  1000baseKX/Full
>                                                  10000baseKX4/Full
>                                                  10000baseKR/Full
>
