Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38101422794
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbhJENR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:17:26 -0400
Received: from mail-vs1-f53.google.com ([209.85.217.53]:37502 "EHLO
        mail-vs1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234209AbhJENRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 09:17:24 -0400
Received: by mail-vs1-f53.google.com with SMTP id f2so22724219vsj.4;
        Tue, 05 Oct 2021 06:15:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OSk13JmDOAD3APp29HqxG5dZ8D802ycSa4BBBThK2Lo=;
        b=7CBYfCOcSzuH4Dy3TjMBjvqdLsoWFKmF9lZffQNGenXv5ofOW8JUkWpmfLrvUJH+Cz
         tmVmzJVsf2TV8o43yUHQz5ix3N23NMP/pHjFilLk5zgYJ7+nnAcrTUub3znGIUtx5jqh
         1lkTZfSpn410uSdwIt0ZuXhbOjElTFEXg4VWcnI+gPonUig8BuhDGgGqILvT9FyM9EtH
         a+pxmL6ouEBDTS0/4xjHfeXuXFRKVvRtWTik+h7YSwFphrUoUpw/1ScjNB+oPDKIO2yk
         qNVotBX6ZOrbADXkFE8vprnNKID8xdc/X5mdnbZPP9+Yv1DQBRGYos87lnVtI7MF+qyu
         MwyQ==
X-Gm-Message-State: AOAM533jQxZ+/3xU01I5eU1S1c3CVlpMCBy5GCfUnx3+sYB6SYw+TyNF
        kAMXvrRRArvzU4FzLkGL41WepRuNUsLGukYuZsc=
X-Google-Smtp-Source: ABdhPJz6nnMbR+9+89nKxvJ7lKJrX7FwjNnkjIF7wUUvPVZ51A91F+WKUqXWRpll3Ph9agb50Myz4aeCp41nnDp1jcg=
X-Received: by 2002:a67:f147:: with SMTP id t7mr18249873vsm.41.1633439733265;
 Tue, 05 Oct 2021 06:15:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210924153113.10046-1-uli+renesas@fpond.eu> <20210924153113.10046-3-uli+renesas@fpond.eu>
In-Reply-To: <20210924153113.10046-3-uli+renesas@fpond.eu>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 5 Oct 2021 15:15:17 +0200
Message-ID: <CAMuHMdUo_96409P30O8_RAp12w322mxsTiZBHgYdAOGjEdC+EQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] dt-bindings: can: renesas,rcar-canfd: Document
 r8a779a0 support
To:     Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfram Sang <wsa@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Uli,

On Fri, Sep 24, 2021 at 5:34 PM Ulrich Hecht <uli+renesas@fpond.eu> wrote:
> Document support for rcar_canfd on R8A779A0 (V3U) SoCs.
>
> Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>

Thanks for your patch!

> --- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> +++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> @@ -28,6 +28,7 @@ properties:
>                - renesas,r8a77980-canfd     # R-Car V3H
>                - renesas,r8a77990-canfd     # R-Car E3
>                - renesas,r8a77995-canfd     # R-Car D3
> +              - renesas,r8a779a0-canfd     # R-Car V3U

As CAN-FD on R-Car V3U differs from the other R-Car Gen3 SoCs,
it should receive its own oneOf entry.

>            - const: renesas,rcar-gen3-canfd # R-Car Gen3 and RZ/G2
>
>        - items:

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
