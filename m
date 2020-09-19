Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA20270D53
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 13:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgISLBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 07:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgISLBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 07:01:17 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A6AC0613CE;
        Sat, 19 Sep 2020 04:01:17 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id x10so6326062ybj.13;
        Sat, 19 Sep 2020 04:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PO3ThUtOVECE6Q7sO1RBPWOv+G93A2kL7ZhufPrHkuo=;
        b=rRTicOn6uKvO0Q5NRBuHBVx6FxKfY7hEgQtIbzY3x6UYuOrb2Peo0UFHYCGlf/r+o1
         at/14EQZm7qKFaOiNfBvlAgmIS8HWRWjuh5z9HSsymdZOhQ5Q/8oABfzbZELpbV41QmE
         ClKU7z2/FBp09wt6oOYIDsoTDzQS9V0eKKl8KvrMqs+Fb1tw0G/l6ycrd3aQYYvAjuzb
         4+cLSeqHLYH9fgqIWcwnZjySMk75YP5qxUdX02imO2QIZlkdLfaSC3ZKPRE4+mPBx2d7
         plhWw5ET45prLGod34H2ntCWPgLptyNquZW3noPWTwQZvZSWtaudQ/5be8fxVjLB3FjS
         aXxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PO3ThUtOVECE6Q7sO1RBPWOv+G93A2kL7ZhufPrHkuo=;
        b=sTyAMJXjCPyvrhf9DneITbC/odCZSgR7blSrYcTbtPThdJgV1POBHVz+bVGeprD3G5
         6vi20qsrYQ/AJ5om29/B1mVB8pfHCK2M6J3ykIF/vyy1a/y9GWaiwPR/kRFKgm+tI1u0
         8d98CKXNzhkzl3ilkYtQzoax4/UtAbmdJ7UHiHnipQd+uDR7a+PAcSZcdRsSEiDsyeE4
         dSAh/8CjTFyJs4f8aPmXTpYYB9nwq2FFLYtz6HLz/HhfkWVp7lbU4628jDt1PAAGKsda
         WtBlfPHW6TCHh/7hiQvwLeRBBHxRD8Ot2PRRInzP3r41CpjHFByre2Db8tx/hysn2ki6
         j9yA==
X-Gm-Message-State: AOAM532/trJcjGOZ2HzsAnklLqTl9bjfFs1KtM8WHbnWAQbgaUaA+uWa
        Gq/IBnBxaSzy7VCTv3rTksKRwX1/MMksotoXw+c=
X-Google-Smtp-Source: ABdhPJzo70CnNJoUYFT34JFmXjApv0JyI2qiop7m6rWoJcx1lPHa85dPKOpjEN/OYR7HLI29WvVkYTBlMPL1X0iMLgQ=
X-Received: by 2002:a25:6849:: with SMTP id d70mr27831050ybc.395.1600513276955;
 Sat, 19 Sep 2020 04:01:16 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-6-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com> <CA+V-a8sBF2ak+dYd9g=Tf_2Kwz_Om2mpK=z+KzGQQG4qJM-+zA@mail.gmail.com>
In-Reply-To: <CA+V-a8sBF2ak+dYd9g=Tf_2Kwz_Om2mpK=z+KzGQQG4qJM-+zA@mail.gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Sat, 19 Sep 2020 12:00:51 +0100
Message-ID: <CA+V-a8tcuxiDBZ0WYgrMrPjnse7On1LWiJngznZMiSOQAqT9Ag@mail.gmail.com>
Subject: Re: [PATCH 05/20] dt-bindings: timer: renesas,cmt: Document r8a774e1
 CMT support
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Niklas <niklas.soderlund@ragnatech.se>,
        Zhang Rui <rui.zhang@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Magnus Damm <magnus.damm@gmail.com>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel and Thomas,

On Thu, Aug 27, 2020 at 6:00 PM Lad, Prabhakar
<prabhakar.csengg@gmail.com> wrote:
>
> Hi Daniel and Thomas,
>
> On Wed, Jul 15, 2020 at 12:09 PM Lad Prabhakar
> <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> >
> > Document SoC specific bindings for RZ/G2H (r8a774e1) SoC.
> >
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > ---
> >  Documentation/devicetree/bindings/timer/renesas,cmt.yaml | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> Gentle ping.
>
Could you please pick this patch.

Cheers,
Prabhakar
