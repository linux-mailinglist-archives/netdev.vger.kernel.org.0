Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9EE82E962B
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 14:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbhADNix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 08:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbhADNiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 08:38:52 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5910DC061574;
        Mon,  4 Jan 2021 05:38:12 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id k4so25995947ybp.6;
        Mon, 04 Jan 2021 05:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qpRCgkYiJRW1zoLfP+z+PbbYsKmRvUnyDb3fnDcUbxg=;
        b=EtTC+EseNPWQLbbGnMKGiTYVWmr6GrHlxGoQW/Vvnt82VshXAirGEKUO1DP1H1cuud
         zumPC64ENwDpU6KPY6y7wZdkPk2MYPPGTuhSMdMZh0seEZcfErdfGCK5Tk9pJe1ngLgh
         GT2LNQVr/uOfrhacZDELGu+qZGVVOGiz0WZJ4LMzeFRsGFrmh9vOUiPUqkqYbx4J6A50
         0oNJQZJJuohizTHMtYGkjFkvFN+Fx/PlVAinxTbTj1PFT1FPf+mf+sqvD88avkmHX0w3
         6S4p3ttVrcWqkTdQjizmfFg9bKpqtuFtu7A2kyfG0MvLX4pTAaLQsS4hJ5dj39QXU91P
         vrCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qpRCgkYiJRW1zoLfP+z+PbbYsKmRvUnyDb3fnDcUbxg=;
        b=o0qDW4jgbLPgRA0c3d70gCzPHTg8mBzxJUg1z7bo+ao9invwNvAIlh7oKtQxmEOMda
         oaRNn1BlUoNMp5d3GozpotpO2Zv0Tq1UPFCh+9VrPVhT4Tm6TxgH/7lJdBVE1T3ruk0p
         MTnl784daMNAjQ0JSk+oRJ7SmIV1ibbWjL1gAHc/QB13+fXnqsvHsXLyPMxlX2UlpcR6
         6Ix4YAhsvAdDEr7fVKEka+FdM38xExQalBoHV9XaaYsRee86VXC3tnq1CnZShu8C94Zj
         x0gVLxLP01/yLvSqBtLrXSbsQO9JwcixHGrSF74oPPXDNHwpWwdnbQPchaJfiZatqW2w
         d0SA==
X-Gm-Message-State: AOAM53255nvGZVaPdjqt0YsTKsuOurprTKcG0IG04m9p2mYX2TEflSrD
        f2LsRWZm2lEnR0kDdDs2Yks07mQ/MGIv8wCSUeE=
X-Google-Smtp-Source: ABdhPJzybu+uVIT4FvFH8WDb6xwNtcsCHfIhCfYXnHgU7wDGy3SssXPVcjn1basAf7q4BSauxVsxliVPOm0Z9F3BqMQ=
X-Received: by 2002:a25:94b:: with SMTP id u11mr108114685ybm.518.1609767491262;
 Mon, 04 Jan 2021 05:38:11 -0800 (PST)
MIME-Version: 1.0
References: <20201231155957.31165-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <CAMuHMdX2ruikh4voRrHPmi=ti+eHVxXh6N05s1XH6+r5MeeqQw@mail.gmail.com>
In-Reply-To: <CAMuHMdX2ruikh4voRrHPmi=ti+eHVxXh6N05s1XH6+r5MeeqQw@mail.gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Mon, 4 Jan 2021 13:37:45 +0000
Message-ID: <CA+V-a8uzTWqOGxMVi+ZJwNWRfj9ANxzAqEhLaQLoDiVcwwCUWQ@mail.gmail.com>
Subject: Re: [PATCH] can: rcar: Update help description for CAN_RCAR_CANFD config
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

Thank you for the review.

On Mon, Jan 4, 2021 at 10:51 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Prabhakar,
>
> On Thu, Dec 31, 2020 at 5:00 PM Lad Prabhakar
> <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> > The rcar_canfd driver supports R-Car Gen3 and RZ/G2 SoC's, update the
> > description to reflect this.
> >
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> > --- a/drivers/net/can/rcar/Kconfig
> > +++ b/drivers/net/can/rcar/Kconfig
> > @@ -10,13 +10,13 @@ config CAN_RCAR
> >           be called rcar_can.
> >
> >  config CAN_RCAR_CANFD
> > -       tristate "Renesas R-Car CAN FD controller"
> > +       tristate "Renesas R-Car Gen3 and RZ/G2 CAN FD controller"
> >         depends on ARCH_RENESAS || ARM
>
> Not introduced by this patch, but the "|| ARM" looks strange to me.
> Is this meant for compile-testing? Doesn't the driver compile on all
> platforms (it does on m68k), so "|| COMPILE_TEST" is not appropriate?
> Is the CAN FD controller present on some Renesas arm32 SoCs (but
> not yet supported by this driver)?
>
Good catch. "|| ARM" was probably copied from CAN_RCAR config and I
can confirm CAN-FD controller doesn't exist on R-Car Gen2 and RZ/G2
32bit SoC's (but with a bit of google search RZ/A2M supports CAN-FD I
am not sure if its the same controller tough), but said that there
shouldn't be any harm in replacing  "|| ARM" with "|| COMPILE_TEST"
for both CAN_RCAR_CAN{FD}. What are your thoughts?

Cheers,
Prabhakar



> >         help
> >           Say Y here if you want to use CAN FD controller found on
> > -         Renesas R-Car SoCs. The driver puts the controller in CAN FD only
> > -         mode, which can interoperate with CAN2.0 nodes but does not support
> > -         dedicated CAN 2.0 mode.
> > +         Renesas R-Car Gen3 and RZ/G2 SoCs. The driver puts the
> > +         controller in CAN FD only mode, which can interoperate with
> > +         CAN2.0 nodes but does not support dedicated CAN 2.0 mode.
> >
> >           To compile this driver as a module, choose M here: the module will
> >           be called rcar_canfd.
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
