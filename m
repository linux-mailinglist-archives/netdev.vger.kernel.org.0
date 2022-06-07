Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0B253F9A3
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 11:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239502AbiFGJ2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 05:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238703AbiFGJ2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 05:28:08 -0400
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244D232ED8;
        Tue,  7 Jun 2022 02:28:07 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id f34so30149476ybj.6;
        Tue, 07 Jun 2022 02:28:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mWYG/OGx6qetK0o2X6cVpouqKkNTEyLC/VGAA/7a2xw=;
        b=qSq0kChIebsX8LymnhlHYmTq+zhSO7BlOcpm3cQ9yQomxGkCwkg8QYbWyuO93hFkEr
         Y9tBBlBQVshiRA7Xa9ik+I+I1LCB9+gbegjTRXuZQGlKHpdDZz8BG51yrzMzMWDqe3Xo
         rRpLdFYxwB8SocfSbB3+6HAqyKexwgmJTAuK7vaX/rHNJOptEXvdCRfid9Y9JONVeP+S
         W95mZ16bIh9OC1yBzFvpROfzPVmeK3xD7VP2E8PCDJsdVMSenbA29BdUTVef3Htk7FNK
         DS2EQWp0z4tzG/Zvz8djHX9EnAZ8HYp00cM4zrYkcl1CVAKvz4sum95Jg5UmzOosRQk2
         1gNg==
X-Gm-Message-State: AOAM531OKTj/iU1hiVZLE/NrR65QlpSI88kva/xjWAfKBWmiRcYwmIKL
        5K0AABcYuwgzJ02uZtEXW+mhsVmsm1tqKB/ZAhs=
X-Google-Smtp-Source: ABdhPJyoR/WcIKYYbkEhsAq3MjNuXqggp+vdWXu8vVqTpHO5SSoGZVe7EbrdzXL6H7XPrcdc4ZVtfC5yPSQsA4TAWeQ=
X-Received: by 2002:a25:ad58:0:b0:65c:e3e5:e813 with SMTP id
 l24-20020a25ad58000000b0065ce3e5e813mr28546395ybe.151.1654594086359; Tue, 07
 Jun 2022 02:28:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220604163000.211077-1-mailhol.vincent@wanadoo.fr> <20220604163000.211077-5-mailhol.vincent@wanadoo.fr>
 <CAMuHMdXkq7+yvD=ju-LY14yOPkiiHwL6H+9G-4KgX=GJjX=h9g@mail.gmail.com>
In-Reply-To: <CAMuHMdXkq7+yvD=ju-LY14yOPkiiHwL6H+9G-4KgX=GJjX=h9g@mail.gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 7 Jun 2022 18:27:55 +0900
Message-ID: <CAMZ6RqLEEHOZjrMH+-GLC--jjfOaWYOPLf+PpefHwy=cLpWTYg@mail.gmail.com>
Subject: Re: [PATCH v5 4/7] can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

On Tue. 7 Jun 2022 at 17:43, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Hi Vincent,
>
> On Sun, Jun 5, 2022 at 12:25 AM Vincent Mailhol
> <mailhol.vincent@wanadoo.fr> wrote:
> > Only a few drivers rely on the CAN rx offload framework (as of the
> > writing of this patch, only four: flexcan, m_can, mcp251xfd and
> > ti_hecc). Give the option to the user to deselect this features during
> > compilation.
>
> Thanks for your patch!

Thank you too, happy to see the warm feedback from all of you.

> > The drivers relying on CAN rx offload are in different sub
> > folders. All of these drivers get tagged with "select CAN_RX_OFFLOAD"
> > so that the option is automatically enabled whenever one of those
> > driver is chosen.

The "select CAN_RX_OFFLOAD" is to make it dummy proof for the user who
will deselect CAN_RX_OFFLOAD can still see the menu entries for all
drivers. I think it is better than a "depends on" which would hide the
rx offload devices.

> Great! But...
>
> >
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>
> > --- a/drivers/net/can/Kconfig
> > +++ b/drivers/net/can/Kconfig
> > @@ -102,6 +102,20 @@ config CAN_CALC_BITTIMING
> >
> >           If unsure, say Y.
> >
> > +config CAN_RX_OFFLOAD
> > +       bool "CAN RX offload"
> > +       default y
>
> ... then why does this default to "y"?
>
> > +       help
> > +         Framework to offload the controller's RX FIFO during one
> > +         interrupt. The CAN frames of the FIFO are read and put into a skb
> > +         queue during that interrupt and transmitted afterwards in a NAPI
> > +         context.
> > +
> > +         The additional features selected by this option will be added to the
> > +         can-dev module.
> > +
> > +         If unsure, say Y.
>
> ... and do you suggest to enable this?

Several reasons. First, *before* this series, the help menu for
"Platform CAN drivers with Netlink support" (old CAN_DEV) had the
"default y" and said: "if unsure, say Y." CAN_RX_OFFLOAD was part of
it so, I am just maintaining the status quo.

Second, and regardless of the above, I really think that it makes
sense to have everything built in can-dev.ko by default. If someone
does a binary release of can-dev.ko in which the rx offload is
deactivated, end users would get really confused.

Having a can-dev module stripped down is an expert setting. The
average user which does not need CAN can deselect CONFIG_CAN and be
happy. The average hobbyist who wants to do some CAN hacking will
activate CONFIG_CAN and will automatically have the prerequisites in
can-dev for any type of device drivers (after that just need to select
the actual device drivers). The advanced user who actually read all
the help menus will know that he should rather keep those to "yes"
throughout the "if unsure, say Y" comment. Finally, the experts can
fine tune their configuration by deselecting the pieces they did not
wish for.

Honestly, I am totally happy to have the "default y" tag, the "if
unsure, say Y" comment and the "select CAN_RX_OFFLOAD" all together.

Unless I am violating some kind of best practices, I prefer to keep it
as-is. Hope this makes sense.


Yours sincerely,
Vincent Mailhol
