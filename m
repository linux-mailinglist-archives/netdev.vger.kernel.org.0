Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B364F4820F6
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 01:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235309AbhLaASg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 19:18:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbhLaASg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 19:18:36 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BFCC061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 16:18:35 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id m15so22586594pgu.11
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 16:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zqdRAwqhgbtTUZHSUQRCwSaes34Cojc3zlrwAOEvrEM=;
        b=YcU61lq/fMTCZfLKfDPwoXhXA9jDf3eYgdyBJjYqy73rciZDIMqjQ9C/3Z53CP8kgo
         zCzrZEPCsGgIp12U04/JjEaI9z4t4h+m/kGNS5xWCwyXuztfcpkhA+qD3TdWQITjPzxS
         OCFFpotjUHwdGDcLFOtQZaeUlbpSC02yz95E6Vck7QFkarePqH3X2Wjh7/65gotAPKcG
         o0zi97E7jBaRHaxXQDZrq8FSI6NLTdh5GVK11ZNy59xLcOBb2i/4/KuvRTVIb0Cylf3u
         Y+cUVyBEnzJ0D2R4Rgzyl/Bs/MQYBfWpfeYFGYv8EKl8AmLANU0Vay5N5zQPJHKQpm3B
         +BJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zqdRAwqhgbtTUZHSUQRCwSaes34Cojc3zlrwAOEvrEM=;
        b=12OeEgoiaYXqPORPBBI23o7PfxIM8Aiv21NVjQ2Hy373486K5fRq1WD3yaPlCkULWq
         p/NfS35uJklt8tCtbgfWzHEP+GSYWW8VwmjOA66tu7tE6xNukqidw573TcC1Sy/Cephi
         wW6420bQBC2KNkeYWMIsPmfLTzuQu07qAuFgzB7ab8/G5DyUIlcAmZf1ZmL4AfJuB6WR
         5NMxYfRwM3X4BqkEuUx4ahMZxuJ0GYWfTg2LfuuTKUHwjJv7ky6QiAax/sENuW7yhBk5
         swhwjIYJ40nII4k7Da4iNqkvEoB8HPWpPonoDTEmkYVAv1Xs9uqGGjmgHWY/36yTNJyK
         CfeA==
X-Gm-Message-State: AOAM532y7G753Av9XkljXGjD/U3EzjWFMEGORb6IiTF5I08Y62WFP4Z3
        fnXUVa9vjmYAbvki8KECy09QzwbZLVc3GrLaTvQ=
X-Google-Smtp-Source: ABdhPJyC8DFYKfU3Mim7Hw5SHU216Id9wA87VxVyjyQ61rWn3vGRO1RIEimr8CTIzyg7TUhUqiZttALzbt10uXqisK8=
X-Received: by 2002:a63:461c:: with SMTP id t28mr29448062pga.547.1640909914730;
 Thu, 30 Dec 2021 16:18:34 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211218081425.18722-1-luizluca@gmail.com>
 <20211218081425.18722-13-luizluca@gmail.com> <c4f4aef5-aeb5-047b-d3e1-78e7b4c2c968@bang-olufsen.dk>
In-Reply-To: <c4f4aef5-aeb5-047b-d3e1-78e7b4c2c968@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Thu, 30 Dec 2021 21:18:23 -0300
Message-ID: <CAJq09z6mCrg58_RwygetF2hnWV0Kq5YMYWOg4sF3eLAASzqJTg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 12/13] net: dsa: realtek: rtl8365mb: add
 RTL8367S support
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -31,7 +31,10 @@ config NET_DSA_REALTEK_RTL8365MB
> >       depends on NET_DSA_REALTEK_SMI || NET_DSA_REALTEK_MDIO
> >       select NET_DSA_TAG_RTL8_4
> >       help
> > -       Select to enable support for Realtek RTL8365MB
> > +       Select to enable support for Realtek RTL8365MB-VC and RTL8367S. This subdriver
> > +       might also support RTL8363NB, RTL8363NB-VB, RTL8363SC, RTL8363SC-VB, RTL8364NB,
> > +       RTL8364NB-VB, RTL8366SC, RTL8367RB-VB, RTL8367SB, RTL8370MB, RTL8310SR
> > +       in the future.
>
> Not sure how useful this marketing is when I am configuring my kernel.
>

I'll clean it, mentioning only the supported drivers.

> >   /* Chip-specific data and limits */
> >   #define RTL8365MB_CHIP_ID_8365MB_VC         0x6367
> > -#define RTL8365MB_LEARN_LIMIT_MAX_8365MB_VC  2112
>
> The learn limit actually seems to be chip-specific and not family
> specific, that's why I placed it here to begin with. For example,
> something called RTL8370B has a limit of 4160...
>

From Realtek rtl8367c driver:

typedef enum switch_chip_e
{
    CHIP_RTL8367C = 0,
    CHIP_RTL8370B,
    CHIP_RTL8364B,
    CHIP_RTL8363SC_VB,
    CHIP_END
}switch_chip_t;

and

    switch (data)
    {
        case 0x0276:
        case 0x0597:
        case 0x6367:
            *pSwitchChip = CHIP_RTL8367C;
            halCtrl = &rtl8367c_hal_Ctrl;
            break;
        case 0x0652:
        case 0x6368:
            *pSwitchChip = CHIP_RTL8370B;
            halCtrl = &rtl8370b_hal_Ctrl;
            break;
        case 0x0801:
        case 0x6511:
            if( (regValue & 0x00F0) == 0x0080)
            {
                *pSwitchChip = CHIP_RTL8363SC_VB;
                halCtrl = &rtl8363sc_vb_hal_Ctrl;
            }
            else
            {
                *pSwitchChip = CHIP_RTL8364B;
                halCtrl = &rtl8364b_hal_Ctrl;
            }
            break;
        default:
            return RT_ERR_FAILED;
    }

RTL8370B does not seem to be a real device, but another "(sub)family",
like RTL8367C. I can leave it as chip_version specific but the
RTL8365MB is, for now, about RTL8367C chips. I think it is better to
leave it as a family limit.

It would make sense to have it specific for each chip family if all
Realtek DSA drivers get merged into a single one.

> > +#define RTL8365MB_CHIP_VER_8365MB_VC         0x0040
> > +
> > +#define RTL8365MB_CHIP_ID_8367S                      0x6367
> > +#define RTL8365MB_CHIP_VER_8367S             0x00A0
> > +
> > +#define RTL8365MB_LEARN_LIMIT_MAX            2112
>
> But anyways, if you are going to make it family-specific rather than
> chip-specific, place it ...

OK

>
> >
> >   /* Family-specific data and limits */
>
> ... somewhere under here.
>
> >   #define RTL8365MB_PHYADDRMAX        7
> >   #define RTL8365MB_NUM_PHYREGS       32
> >   #define RTL8365MB_PHYREGMAX (RTL8365MB_NUM_PHYREGS - 1)
> > -#define RTL8365MB_MAX_NUM_PORTS  7
> > +// RTL8370MB and RTL8310SR, possibly suportable by this driver, have 10 ports
>
> C style comments :-)
>
> > +#define RTL8365MB_MAX_NUM_PORTS              10
>
> Did you mess up the indentation here? Also seems unrelated to RTL8367S
> support...

It looks like...

>
> >
> >   /* Chip identification registers */
> >   #define RTL8365MB_CHIP_ID_REG               0x1300
> > @@ -1964,9 +1970,22 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
> >
> >       switch (chip_id) {
> >       case RTL8365MB_CHIP_ID_8365MB_VC:
> > -             dev_info(priv->dev,
> > -                      "found an RTL8365MB-VC switch (ver=0x%04x)\n",
> > -                      chip_ver);
> > +             switch (chip_ver) {
> > +             case RTL8365MB_CHIP_VER_8365MB_VC:
> > +                     dev_info(priv->dev,
> > +                              "found an RTL8365MB-VC switch (ver=0x%04x)\n",
> > +                              chip_ver);
> > +                     break;
> > +             case RTL8365MB_CHIP_VER_8367S:
> > +                     dev_info(priv->dev,
> > +                              "found an RTL8367S switch (ver=0x%04x)\n",
> > +                              chip_ver);
> > +                     break;
> > +             default:
> > +                     dev_err(priv->dev, "unrecognized switch version (ver=0x%04x)",
> > +                             chip_ver);
> > +                     return -ENODEV;
> > +             }
> >
> >               priv->num_ports = RTL8365MB_MAX_NUM_PORTS;
> >
> > @@ -1974,7 +1993,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
> >               mb->chip_id = chip_id;
> >               mb->chip_ver = chip_ver;
> >               mb->port_mask = GENMASK(priv->num_ports - 1, 0);
> > -             mb->learn_limit_max = RTL8365MB_LEARN_LIMIT_MAX_8365MB_VC;
> > +             mb->learn_limit_max = RTL8365MB_LEARN_LIMIT_MAX;
> >               mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
> >               mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
> >
>
