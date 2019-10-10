Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C19B3D29E0
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 14:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387892AbfJJMqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 08:46:45 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:41397 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387801AbfJJMqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 08:46:45 -0400
Received: by mail-oi1-f196.google.com with SMTP id w65so4748960oiw.8;
        Thu, 10 Oct 2019 05:46:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KBn66BbTwmZUU2I9k2ufbx3Ra36HrnXvwheScStJ0QE=;
        b=JXtC0r3C4L9ICBChGPcuh2xdFbu+uO4rsckR5QWitNrkFsvVbMulR18p37ktMoprqi
         xJ+sGdWiMqEmtkTljTKjR6I4lqX6gC2yJfvCByYeCiZ4NqS9X82122F8aCwMs0+ML6dQ
         N5BtaS6/QHBTSnmI4mjnabqu/eq34wCMdfckFDyPVC9s7eCz4KSAHgg1KUSEUG9uHWe4
         Xmnspv4FrHAxOoROWn/x6z3lb2bA8LXAMoFEmBMAjI0yUM4DkC9JApaMD3H/zIJUL9OC
         HCHdC//HbETpBlb1GNpdixeoNfJUPQuGtsWH8Fyud4Hf3p6QGEUdH56l8EembqPsCXoq
         jcpA==
X-Gm-Message-State: APjAAAU5d8CLOMa48g4jKZSfEg23VvrEHWv/vcsWKvFgzV2ViMF8aELJ
        4FPG/hFa2erD1v0cqV6tmB+NUwNtsWSc0agzSVc=
X-Google-Smtp-Source: APXvYqw8mgz4KShDIMTVq66wDgob36QaVSEI9Z5S3L/3RMDk2QtBAHM49smvIMzPZ/LUfdYnBDR2vegq9wiIwn0La0w=
X-Received: by 2002:aca:882:: with SMTP id 124mr7330818oii.54.1570711604017;
 Thu, 10 Oct 2019 05:46:44 -0700 (PDT)
MIME-Version: 1.0
References: <1570711049-5691-1-git-send-email-fabrizio.castro@bp.renesas.com> <1570711049-5691-3-git-send-email-fabrizio.castro@bp.renesas.com>
In-Reply-To: <1570711049-5691-3-git-send-email-fabrizio.castro@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 10 Oct 2019 14:46:32 +0200
Message-ID: <CAMuHMdV5XUPSrgoDm62p0f_B1TtvhMyOX3NVho=QVqdesq31jg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] dt-bindings: can: rcar_canfd: document
 r8a774b1 support
To:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Fabrizio,

On Thu, Oct 10, 2019 at 2:37 PM Fabrizio Castro
<fabrizio.castro@bp.renesas.com> wrote:
> Document the support for rcar_canfd on R8A774B1 SoC devices.
>
> Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>

Thanks for your patch!

> --- a/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
> +++ b/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
> @@ -5,6 +5,7 @@ Required properties:
>  - compatible: Must contain one or more of the following:
>    - "renesas,rcar-gen3-canfd" for R-Car Gen3 and RZ/G2 compatible controllers.
>    - "renesas,r8a774a1-canfd" for R8A774A1 (RZ/G2M) compatible controller.
> +  - "renesas,r8a774b1-canfd" for R8A774B1 (RZ/G2N) compatible controller.
>    - "renesas,r8a774c0-canfd" for R8A774C0 (RZ/G2E) compatible controller.
>    - "renesas,r8a7795-canfd" for R8A7795 (R-Car H3) compatible controller.
>    - "renesas,r8a7796-canfd" for R8A7796 (R-Car M3-W) compatible controller.

The above looks good, but I think you forgot to add R8A774B1 to the
paragraph talking about the CAN FD clock below.
With that fixed:
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

While at it, the example in the bindings says the CANFD clock should be
configured to 40 MHz, which matches what is used in the various DTS files.
However, the Hardware User's Manual states it should be 80 MHz, except
for R-Car D3.
Is that correct?

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
