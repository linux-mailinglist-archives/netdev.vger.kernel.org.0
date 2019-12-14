Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A95C11F0FA
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 09:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfLNIja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 03:39:30 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:41605 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfLNIja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 03:39:30 -0500
Received: from mail-qv1-f44.google.com ([209.85.219.44]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MPosX-1iKvB53SCJ-00MpDc for <netdev@vger.kernel.org>; Sat, 14 Dec 2019
 09:39:29 +0100
Received: by mail-qv1-f44.google.com with SMTP id b18so723810qvo.8
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 00:39:28 -0800 (PST)
X-Gm-Message-State: APjAAAVW4tcr73y22oB/Nnx6zC5f743bZLJaEFXX9/6coxni6G3Gy/Np
        8nRfeqdOccn3d0nhmpgzuyw9lW4QJzWUYNc+irU=
X-Google-Smtp-Source: APXvYqyfS1/mfARFQg0rppTJhHXbwINtXYkhKsUiY6q8clodI60txGJuLGC/K1YZEP2Zokfkpam7CJjVtj3QunD/HgE=
X-Received: by 2002:a0c:aca2:: with SMTP id m31mr17519530qvc.222.1576312767757;
 Sat, 14 Dec 2019 00:39:27 -0800 (PST)
MIME-Version: 1.0
References: <20191212171125.9933-1-olteanv@gmail.com> <20191213161021.6c96d8fe@cakuba.netronome.com>
In-Reply-To: <20191213161021.6c96d8fe@cakuba.netronome.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 14 Dec 2019 09:39:11 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3dkFQOxVxiGxVHXMLDwzn5SuoEvui_Fzhx7kYSF_LXKA@mail.gmail.com>
Message-ID: <CAK8P3a3dkFQOxVxiGxVHXMLDwzn5SuoEvui_Fzhx7kYSF_LXKA@mail.gmail.com>
Subject: Re: [PATCH] net: mscc: ocelot: hide MSCC_OCELOT_SWITCH and move
 outside NET_VENDOR_MICROSEMI
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mao Wenan <maowenan@huawei.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo lu <yangbo.lu@nxp.com>,
        Networking <netdev@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:j8nwSv2RR8LJ5tjI0E5cxwWEfxPjoUk5+SR2e9ttYW0zwdc77r0
 SUSMyYNDwJJWzhzf4QdXPF3RWdRDB+EJxniXmbWNECiAbTR/3rRjwiI4SHXIMPuUNvzlWkw
 PBlCVRJyWeMRc07IoDQtTpclu/92ARj3cuVG8C2ODguS/BmNj2mYLspxPuo5G7lpE2MzIat
 BZoUWgxFv4zN5X4/OQY0Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xj2HUlr8lcY=:bYaouYrLNQ854rzUxhWLke
 Fw4CrJxij3NXOo+R7vflrHC35l54/qA6rUx6qupRdtXsY4bycJUcyKtg5XcsMFkmNbYz98DHp
 uJlJGWBhT0Sf8NuQr240zj0iiieMMq0qkFaeZZTci+JLG/8YW6plIpS/DCo9oKuKaN7hkNh+Q
 xEZCtiIPUrDAQJqvIctdw8MFLtTXL+QrXrKoV2IZ6Pt9LyuiMO/0CQHMmgH19fbt3dAw7LPqq
 UHI8i4eZDSqHD2jUBfYZrlKIt07kxdpGalb9Ze1QRPJ3i7ybjup7XeoKHAep2vPtVYGHAvcBl
 p5x+zCyIKX9tmShUJ1dFNJ+WfJVuWlZOrm6Uy8HvCxNEWl5r/CBIqjLkE6oJuMkzrWUvhZKmW
 O/fmrjF7EcMLCH7t+Jke1b79vPIYftjTJkHnvnTfWDiqblNeOB3xYq6NVO94ujqNZx8l3u05q
 Gfm3Ktkuax1H2lraWEGeELIKUy4BigEnS2SxBO53QGuLdEtNWlGdfAJlXjskD3hSz5MXM06+z
 H4RRmHJSe1m+n5MnGNFg6SGmg4DfpWjSQVL3sU9WRqy2Pwb3r96ISIO33ZFnc3c8QtLdEncHV
 ezaTxq8WWh6SV5wUs40oyEDjCo8KotnZ4RqS3MiLyrsZbf29D0DjOmzrcHuIKdUhmZNhrrZwG
 TYge+g+htGToIjPh+OEQn5xdn6SgYst7Ut8qSJ1FTMx2lFXDU9zmUnaHzOtUZAV5dM2k3+KjL
 z2T1fQadzaXSrua95leAc89JhMOohdC+pSp151YfKzbMiBDdfkDY3YCpBwaRN3ySD3sLjQ9Jq
 AvVMoM7g4iXBmVdVR4BHDxRp+n2NuOyearyTlzfznjRX2FTc0LQdRfHuCltZ19Nw+5uCSFW21
 hxrPen9yrJQKTAORpzwA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 14, 2019 at 1:11 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
> On Thu, 12 Dec 2019 19:11:25 +0200, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>

> Mmm. Is that really the only choice? Wouldn't it be better to do
> something like:
>
> diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
> index 13fa11c30f68..991db8b94a9c 100644
> --- a/drivers/net/ethernet/mscc/Kconfig
> +++ b/drivers/net/ethernet/mscc/Kconfig
> @@ -10,7 +10,8 @@ config NET_VENDOR_MICROSEMI
>           the questions about Microsemi devices.
>
>  config MSCC_OCELOT_SWITCH
> -       bool
> +       tristate
> +       default (MSCC_OCELOT_SWITCH_OCELOT || NET_DSA_MSCC_FELIX)
>         depends on NET_SWITCHDEV
>         depends on HAS_IOMEM
>         select REGMAP_MMIO
>
> Presumably if user wants the end driver to be loadable module the
> library should default to a module?

Agreed, should be tristate.

The 'default' isn't necessary here, the 'select' does it all the same
and there only needs to be one of the two.

> > diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
> > index bcec0587cf61..13fa11c30f68 100644
> > --- a/drivers/net/ethernet/mscc/Kconfig
> > +++ b/drivers/net/ethernet/mscc/Kconfig
> > @@ -9,24 +9,29 @@ config NET_VENDOR_MICROSEMI
> >         kernel: saying N will just cause the configurator to skip all
> >         the questions about Microsemi devices.
> >
> > -if NET_VENDOR_MICROSEMI
> > -
> >  config MSCC_OCELOT_SWITCH
> > -     tristate "Ocelot switch driver"
> > +     bool
...
> >
> > +if NET_VENDOR_MICROSEMI
> >
> >  config MSCC_OCELOT_SWITCH_OCELOT
...
> > +     tristate "Ocelot switch driver for local management CPUs"
> > +     select MSCC_OCELOT_SWITCH
> >  endif # NET_VENDOR_MICROSEMI

The "if NET_VENDOR_MICROSEMI" must come directly after the
config NET_VENDOR_MICROSEMI, otherwise the indentation
in "make menuconfig" is wrong. So please move MSCC_OCELOT_SWITCH
after the "endif".

     Arnd
