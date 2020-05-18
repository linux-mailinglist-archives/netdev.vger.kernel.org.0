Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0201D79B1
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 15:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgERNXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 09:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgERNXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 09:23:42 -0400
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E42C061A0C;
        Mon, 18 May 2020 06:23:42 -0700 (PDT)
Received: by mail-oo1-xc41.google.com with SMTP id z6so2022339ooz.3;
        Mon, 18 May 2020 06:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DBlvsBNo07SGqI/EUYBm242mZ59YuGTGeckJLd8jOpQ=;
        b=cfcy4DgNDBCTvF7mVRHlNGMhkmacmQXoOEN7xHQW5RByJmQEOZPVAPyo9YID2+ksAi
         /afPVXSML+4G3Bw1Av627prEUHM1DSfL+K+x7/YDrloQUeRdA0RHZ/Ci8IiVSn06JvxM
         ERD+F7OU2G0aYA1jm533gAqjJDTSnLWqrFY36parhqgXEhiSPdgqNwQO5fR9KwIhBQHQ
         YOpKIOz6q+0B0PXG8v4Biq/vO8dKWXEzyeRa0Y9yjaxmh3OejiceK8lNmw23eVKaKsvC
         ADaynfCq4eIlVTdkVXFTZbxc33D8fvQN23K/LX+Sx2IBxLRkGYZGb+euiCHZkVjhZq4k
         d+hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DBlvsBNo07SGqI/EUYBm242mZ59YuGTGeckJLd8jOpQ=;
        b=C5iMQe4UU3Tl0hFeiOWzE/StQvqw3Kmh7p8HM5Kkzy1UvxF5PqWz/k7wu4t0rTyzPY
         CMxoOIf04UWyi68XYs7384GaZ0SDhpamcvEm3DUSeXvXTCSvz8TNuG2WP56smSCovt56
         LlqUTnVaR1pzC7u533b9RMNGOtMFC53EdchJ8tTGz+X8Pbu2B63z/wB6Cv4WQz4N0awh
         e3C0lzPdxyXf/MMSZrKtX8mlhLhCgq9UHG3OOHLqnr/cF6btir2AVvf5Fy+kZ9vA3HDe
         aSP9SRgTWbM0lo0Ff2J+4Hg9k2V29nC2ixYhyQC8MEPefYc472Q2J30Pjz+zm9EdrFRJ
         ynmw==
X-Gm-Message-State: AOAM5314CWzbmL/eFVDRRvDaCOQ05xk0e3fqsi6ObjmhfTL0TIsidPmZ
        51DtjthyxZJynOHhm/5qJ02cGYP78rQsUvYhoDE=
X-Google-Smtp-Source: ABdhPJxVcUiw42ooaQWea/4dYUB4KCyh0tbeqfXUZvqVqSB4YyCTuhyTbJeCJawG71KxJDG6Rdbo2qnrc9R3IY+DJW4=
X-Received: by 2002:a4a:b346:: with SMTP id n6mr12858795ooo.18.1589808222002;
 Mon, 18 May 2020 06:23:42 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-18-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <CAMuHMdVV+2HsgmBytCOFg4pri4XinT_SPWT_Ac6n7FMZN3dR3w@mail.gmail.com>
 <CA+V-a8tmG1LKYqbc7feGZQO2Tj5RCpNUHi9e19vPr+bED0KOyQ@mail.gmail.com> <9ab946d2-1076-ed92-0a48-9a95d798d291@cogentembedded.com>
In-Reply-To: <9ab946d2-1076-ed92-0a48-9a95d798d291@cogentembedded.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Mon, 18 May 2020 14:23:15 +0100
Message-ID: <CA+V-a8uuP9d6dNeRpn3O0_aOc15CqWoh0bbAfYze1_hn0dCh8g@mail.gmail.com>
Subject: Re: [PATCH 17/17] ARM: dts: r8a7742: Add RWDT node
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergei,

On Mon, May 18, 2020 at 2:17 PM Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
>
> Hello!
>
> On 18.05.2020 15:27, Lad, Prabhakar wrote:
>
> >>> Add a device node for the Watchdog Timer (RWDT) controller on the Renesas
> >>> RZ/G1H (r8a7742) SoC.
> >>>
> >>> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> >>> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> >>
> >> Thanks for your patch!
> >>
> >>> --- a/arch/arm/boot/dts/r8a7742.dtsi
> >>> +++ b/arch/arm/boot/dts/r8a7742.dtsi
> >>> @@ -201,6 +201,16 @@
> >>>                  #size-cells = <2>;
> >>>                  ranges;
> >>>
> >>> +               rwdt: watchdog@e6020000 {
> >>> +                       compatible = "renesas,r8a7742-wdt",
> >>> +                                    "renesas,rcar-gen2-wdt";
> >>> +                       reg = <0 0xe6020000 0 0x0c>;
> >>> +                       clocks = <&cpg CPG_MOD 402>;
> >>> +                       power-domains = <&sysc R8A7742_PD_ALWAYS_ON>;
> >>> +                       resets = <&cpg 402>;
> >>> +                       status = "disabled";
> >>
> >> Missing "interrupts" property.
> >>
> > "interrupts" property isn't used by rwdt driver  and can be dropped
> > from bindings file.
>
>     DT describes the hardware, not its driver's abilities.
>
Agreed will add, I had followed it on similar lines of r8a7743/44.

Cheers,
--Prabhakar
