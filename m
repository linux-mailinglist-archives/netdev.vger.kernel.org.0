Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD05B28476B
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 09:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgJFHhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 03:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgJFHhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 03:37:23 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4699BC061755;
        Tue,  6 Oct 2020 00:37:23 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id h9so8336246ybm.4;
        Tue, 06 Oct 2020 00:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/rpeFQkYljEUQNuTkq/Bj2u7+/dyH0xezKDk13QHrgs=;
        b=I67uwF8vGMVRz59yBBMrVkpGNZTXp4IgrRIJat4txQOiEint3X7+0frmO1+OP2xuWW
         dy6A3KrEdkNdLr/DfTotYvumHXgSwK2/woqDxNF68WeIgGxhplRIW7dew+npYnCSKKh0
         q3h7uIwal8cfV5ESVkmi9ioZPp34tGb++/15qwdH8wSL5PIYv3eWqjVEEIdkW15TR4+e
         1U5wra92LcbHDEDcFSqRNeknx0uqzrkKYZC2dsKQeP9tkUZSFZrr4OC75giOsALjchSM
         cS1xhflpWwksi5AvYe59QvVVKayZ4e9K64wtDa9w8upG1hm6/gVNje+O16L/6Vvf8ydl
         c8PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/rpeFQkYljEUQNuTkq/Bj2u7+/dyH0xezKDk13QHrgs=;
        b=GkC5i21vj8C6qOSZX2Bym2ax6pVJusoUzSICxndhbgPV5Qfb2c397d1SUvGoZKxEtf
         cWXS0BAbN+V59zK7M6Lws7VoGWCJLamIRBwvxnpHPVaGDllVrHymnpI/aiF9LcSdZfSI
         lZGtQ7AovUsY/DCIW0TUgsvx60QS7xU3ju57QSV7xVNp+GwvPo7MRtw4eTEpAbZ32vIc
         vaXYr6xdyaGjRud+IwTOq5oDaCbehA5WUmtCmQIvzYo7pj5bw3eSHtsfJWeNL+GEOgLy
         r+DLGHNyjrYzKqe2bcA+Dfw9Nu2tF3aP2s5WSWxzWpK+gxnfKK/IjC1zhfkQuysboRxs
         nwww==
X-Gm-Message-State: AOAM533iXAX4KON8G8isB2jE4LljMnI3928oM10ldWQDLlFMaONpo4JU
        QzruJAyk5ZeDBEhphP0FMb6JW0Lct3jCbaFwOqg=
X-Google-Smtp-Source: ABdhPJwfLgnSYcRLFdadsRTIRNtTVSAEW78ZUxbTkRbnbV/agJqAH9pErSId1/aBoVObNOb6KwW1Tf2hFeBRMZcyA9w=
X-Received: by 2002:a25:e811:: with SMTP id k17mr4717314ybd.401.1601969842337;
 Tue, 06 Oct 2020 00:37:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200816190732.6905-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20200816190732.6905-3-prabhakar.mahadev-lad.rj@bp.renesas.com> <20200825022102.GA3808062@bogus>
In-Reply-To: <20200825022102.GA3808062@bogus>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Tue, 6 Oct 2020 08:36:56 +0100
Message-ID: <CA+V-a8tFqsWE+vhF4R3-Ce0MjamPkWdwYSm8pAVN9AXSUq4d=g@mail.gmail.com>
Subject: Re: [PATCH 2/3] dt-bindings: can: rcar_can: Add r8a7742 support
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Rob Herring <robh@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-can@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Tue, Aug 25, 2020 at 3:21 AM Rob Herring <robh@kernel.org> wrote:
>
> On Sun, 16 Aug 2020 20:07:31 +0100, Lad Prabhakar wrote:
> > Document RZ/G1H (r8a7742) SoC specific bindings. The R8A7742 CAN module
> > is identical to R-Car Gen2 family.
> >
> > No driver change is needed due to the fallback compatible value
> > "renesas,rcar-gen2-can".
> >
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > Reviewed-by: Chris Paterson <Chris.Paterson2@renesas.com>
> > ---
> >  Documentation/devicetree/bindings/net/can/rcar_can.txt | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
>
> Acked-by: Rob Herring <robh@kernel.org>
>
Could you please pick up this patch. It has been acked by the
maintainers. Let me know if you want me to RESEND this patch.

Cheers,
Prabhakar
