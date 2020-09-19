Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46D5270D6A
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 13:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgISLGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 07:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgISLGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 07:06:01 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC9BC0613CE;
        Sat, 19 Sep 2020 04:06:01 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id x20so6369338ybs.8;
        Sat, 19 Sep 2020 04:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Ij7bvisAUQqcftsNPRluVmVo55tqxHkQBfHxZFcMOA=;
        b=QXuiXUNrQssc+AmgBVbKQxNzGo5tROj3AJ+f/1m3yJZ+Luju1U9BNROqgJmx9MMyOr
         mFI9BS8XS4gFSYurp2pr6oGgPub/q9VcS+OshZA3iZbg2bohf/ebHc/nXA1mwzy5q56X
         EJ7spOnvN8ZaSNZOBVjS67rmeCWoe9W6GpK+k557oP4dp1JTq6s0ze24blVvQEjbAN9v
         ACdaIWWlSZUiSxYi6gKKTjac1YBw5UnvzymtdfM5uOUiSJVGTHxabBHzD69AvtPgFRdX
         uWL3lhWMCciU41cU+AYOk5oi+kOP8koiqC0LihfXmFB8vMIDN4bZnwQSobAMvEprPPp9
         mjqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Ij7bvisAUQqcftsNPRluVmVo55tqxHkQBfHxZFcMOA=;
        b=bAutchs26Qxj17JlRTg8lkW8Dtwon6QVl0Cd5jjX5thgb7oNYgqEQLt9IvGz3u/xrn
         ylfMaJwGzIED5wMN9v9JW2WFGnfALQxI4zlE0uzh8jXN0K1vTjYG6iBd73ActWMNx+pD
         23j+Pp2b+lrRSfpRrKyjDVhEEe6Vu18qFrMd1F4qqtLu62gMxZlnhjcHhZ0bRPWH3x2X
         H47hl0avL4L+xeeiq7ohdHI07hJdY3KFwXzQkm86VTvewgeylYC4Ly+nTWvBfozlkoQ5
         tmpom4jhBnoO1UUh+aCGp7mcBRsvFYj2eHE5lvUQd1qenp1x8xDDIQPHBs1OFS13+IXG
         xp/Q==
X-Gm-Message-State: AOAM5310T4XO2CJt6xnz0sw9G6WpX548VeIGBLVERnoh8y0jv+keL2Gp
        9+ryTNttfj93MkZKyzCUHCn9YvforxRhJ0L6R6Y=
X-Google-Smtp-Source: ABdhPJxiabQbGSqQ3/I9bCoypnGYRh9dwnRNf8kkHTS7HlO2VXzvkXrzQAbnqylSkxUqAmX3P2x1QEczoNP6w8K1IAY=
X-Received: by 2002:a25:23cb:: with SMTP id j194mr47804126ybj.445.1600513559955;
 Sat, 19 Sep 2020 04:05:59 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-3-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com> <CA+V-a8vwhtTWjaoXkfMBjKx90WkcoejD5ryPkXnQNEbtgnJGXQ@mail.gmail.com>
In-Reply-To: <CA+V-a8vwhtTWjaoXkfMBjKx90WkcoejD5ryPkXnQNEbtgnJGXQ@mail.gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Sat, 19 Sep 2020 12:05:34 +0100
Message-ID: <CA+V-a8tzELW-F3GLqq+M3pKoYZwfsc28K-PVVQq-sxJN0pL73Q@mail.gmail.com>
Subject: Re: [PATCH 02/20] dt-bindings: thermal: rcar-gen3-thermal: Add
 r8a774e1 support
To:     Niklas <niklas.soderlund@ragnatech.se>,
        Zhang Rui <rui.zhang@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Magnus Damm <magnus.damm@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
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

Hi Niklas/Zhang/Daniel,

On Thu, Aug 27, 2020 at 5:52 PM Lad, Prabhakar
<prabhakar.csengg@gmail.com> wrote:
>
> Hi Zhang,Daniel,Amit,
>
> On Wed, Jul 15, 2020 at 12:09 PM Lad Prabhakar
> <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> >
> > Document RZ/G2H (R8A774E1) SoC bindings.
> >
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > ---
> >  Documentation/devicetree/bindings/thermal/rcar-gen3-thermal.yaml | 1 +
> >  1 file changed, 1 insertion(+)
> >
> Gentle ping.
>
Could either of please pick this patch.

Cheers,
Prabhakar
