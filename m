Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4150239FE
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 16:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389174AbfETO2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 10:28:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730687AbfETO2b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 10:28:31 -0400
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E57182171F;
        Mon, 20 May 2019 14:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558362510;
        bh=wmAD45IGWBBMsRmkDmG5/lzUuaDtKFtcmsU1V2e8tDE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jcBUPYPK6wcrqjqb6oeb8t0r+alZcV7U5e8Q5+F4NlBY9BCAK/4KjNiBjA9DRuQ3M
         bkrx7yqMZK/qUBOmyIbMvHdqRCvI+ZB3/v6aEqYRKwTUaIL8H85GQFM/1rRZCL2x9s
         IGkb75H9BAN2uVf55Zx8P8fgwPFVYNRFSxT08IBE=
Received: by mail-qt1-f174.google.com with SMTP id f24so16474613qtk.11;
        Mon, 20 May 2019 07:28:29 -0700 (PDT)
X-Gm-Message-State: APjAAAXYQ8DWzIaAogcGDab1Wh6fkfrRaxP3zPfU6I/ErWuZNbNRnQia
        fUdl/ArIybcDZsp59E/9uTLC8U3IlFgHUPVOpw==
X-Google-Smtp-Source: APXvYqwGA7iA0DD783vQFcDaDzRSDolXbSmJr6F8dFu3Jo3eOeY5JQKjp+y92hdp8kJpm6q1NsA6KvUppdaj/MtYBaQ=
X-Received: by 2002:ac8:7688:: with SMTP id g8mr36294636qtr.224.1558362509134;
 Mon, 20 May 2019 07:28:29 -0700 (PDT)
MIME-Version: 1.0
References: <1557476567-17397-4-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-3-git-send-email-fugang.duan@nxp.com> <1557476567-17397-2-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-1-git-send-email-fugang.duan@nxp.com> <20190510112822.GT81826@meh.true.cz>
 <20190510113155.mvpuhe4yzxdaanei@flea> <20190511144444.GU81826@meh.true.cz>
 <547abcff-103a-13b8-f42a-c0bd1d910bbc@linaro.org> <20190513090700.GW81826@meh.true.cz>
 <8cee0086-7459-24c7-82f9-d559527df6e6@linaro.org> <20190513111612.GA21475@meh.true.cz>
In-Reply-To: <20190513111612.GA21475@meh.true.cz>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 20 May 2019 09:28:16 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+Jdz5voO9LU6=Pk6Azsv-wB7=cFjv46FODnxgm+rA4Xw@mail.gmail.com>
Message-ID: <CAL_Jsq+Jdz5voO9LU6=Pk6Azsv-wB7=cFjv46FODnxgm+rA4Xw@mail.gmail.com>
Subject: Re: NVMEM address DT post processing [Was: Re: [PATCH net 0/3] add
 property "nvmem_macaddr_swap" to swap macaddr bytes order]
To:     =?UTF-8?Q?Petr_=C5=A0tetiar?= <ynezz@true.cz>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Andy Duan <fugang.duan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "john@phrozen.org" <john@phrozen.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alban Bedel <albeu@free.fr>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 6:16 AM Petr =C5=A0tetiar <ynezz@true.cz> wrote:
>
> Srinivas Kandagatla <srinivas.kandagatla@linaro.org> [2019-05-13 11:06:48=
]:
>
> > On 13/05/2019 10:07, Petr =C5=A0tetiar wrote:
> > > Srinivas Kandagatla <srinivas.kandagatla@linaro.org> [2019-05-13 09:2=
5:55]:
> > >
> > > > My initial idea was to add compatible strings to the cell so that m=
ost of
> > > > the encoding information can be derived from it. For example if the=
 encoding
> > > > representing in your example is pretty standard or vendor specific =
we could
> > > > just do with a simple compatible like below:
> > >
> > > that vendor/compatible list would be quite long[1], there are hundred=
s of
> >
> > You are right just vendor list could be very long, but I was hoping tha=
t the
> > post-processing would fall in some categories which can be used in
> > compatible string.
> >
> > Irrespective of which we need to have some sort of compatible string to
> > enable nvmem core to know that there is some form of post processing to=
 be
> > done on the cells!. Without which there is a danger of continuing to ad=
ding
> > new properties to the cell bindings which have no relation to each othe=
r.
>
> makes sense, so something like this would be acceptable?

No. Don't try to put a data processing language into DT.

>
>  eth1_addr: eth-mac-addr@18a {
>      /* or rather linux,nvmem-post-process ? */
>      compatible =3D "openwrt,nvmem-post-process";
>      reg =3D <0x189 0x11>;
>      indices =3D < 0 2
>                  3 2
>                  6 2
>                  9 2
>                 12 2
>                 15 2>;
>      transform =3D "ascii";
>      increment =3D <1>;
>      increment-at =3D <5>;
>      result-swap;
>  };
>
>  &eth1 {
>      nvmem-cells =3D <&eth1_addr>;
>      nvmem-cell-names =3D "mac-address";
>  };
>
> > > was very compeling as it would kill two birds with one stone (fix out=
standing
> > > MTD/NVMEM OF clash as well[2]),
> >
> > Changes to nvmem dt bindings have been already rejected, for this more
> > discussion at: https://lore.kernel.org/patchwork/patch/936312/
>
> I know, I've re-read this thread several times, but it's still unclear to=
 me,
> how this should be approached in order to be accepted by you and by DT
> maintainers as well.
>
> Anyway, to sum it up, from your point of view, following is fine?
>
>  flash@0 {
>     partitions {
>         art: partition@ff0000 {
>             nvmem_dev: nvmem-cells {
>                 compatible =3D "nvmem-cells";

My suggestion would be to add a specific compatible here and that can
provide a driver or hooks to read and transform the data.

Rob

>                 eth1_addr: eth-mac-addr@189 {
>                     compatible =3D "openwrt,nvmem-post-process";
>                     reg =3D <0x189 0x6>;
>                     increment =3D <1>;
>                     increment-at =3D <5>;
>                     result-swap;
>                 };
>             };
>         };
>     };
>  };
>
>  &eth1 {
>     nvmem =3D <&nvmem_dev>;
>     nvmem-cells =3D <&eth1_addr>;
>     nvmem-cell-names =3D "mac-address";
>  };
>
> -- ynezz
