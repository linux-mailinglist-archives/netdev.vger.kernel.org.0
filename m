Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2936127EE5
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 16:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfLTPBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 10:01:32 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:46320 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727362AbfLTPBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 10:01:32 -0500
Received: by mail-oi1-f196.google.com with SMTP id p67so4610560oib.13;
        Fri, 20 Dec 2019 07:01:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+iJQh1B5KXxx5DhyusKnyQJixmTQKTrZ2Rj0CaEWDOQ=;
        b=Jhhhe0bADpO+zDdWsoOS0FQ92wou+1qHWGn4xQ9e0H+P19Foffdon215FeLrt5cIKS
         5FLT+bS1rIfyk40JXxUVXD9E1rZ9fcyaYo4tNKOtVZ6UarGXp0Hc4QLYsEaGyRgC7UJi
         hUglpC1CUwVhpUk65yoNL46yN4aOxMK4nXj3Hz5SzCfKQzOKFVk3tgdeBmm9LMMMxi0F
         LNfI2kgMh/HZhAj+6uhre8ezTV5y24Pjw29PDz4002GP74qUHyo6X4qUlEYQh77dpZaz
         5tBuZZA1NzBMb2NlK0EykCcjSF6Ea34Zvgjxl/cEa59SLpl8qNgooMAQOsITCLNxpEPQ
         Tocg==
X-Gm-Message-State: APjAAAU/FqDVg3uMegNZIT6MbEQR80ExtFwX6+E7xDKgmLkGOcdsRmsF
        ZnsE+yFMy8+FYdPwtZWLDo47WFfGN8n8Trin8pxbQpWs
X-Google-Smtp-Source: APXvYqwWJiewRz8Q9MAA6yfhGHK2rHY5vZ6rtov/p5xg5x7TBF8tOOvwQWl8evm8v0Pc3phtj7/JsDolMsD8M2faC1w=
X-Received: by 2002:aca:36c5:: with SMTP id d188mr4050927oia.54.1576854091491;
 Fri, 20 Dec 2019 07:01:31 -0800 (PST)
MIME-Version: 1.0
References: <1570717560-7431-1-git-send-email-fabrizio.castro@bp.renesas.com>
 <1570717560-7431-2-git-send-email-fabrizio.castro@bp.renesas.com>
 <20191014181016.GA1927@bogus> <TY1PR01MB17708F6646BD736C52A22BFCC0530@TY1PR01MB1770.jpnprd01.prod.outlook.com>
In-Reply-To: <TY1PR01MB17708F6646BD736C52A22BFCC0530@TY1PR01MB1770.jpnprd01.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 20 Dec 2019 16:01:20 +0100
Message-ID: <CAMuHMdV+1g9Oh9YPSsRQYO0=k8DYoaBhthY0HxSUVW9=L5jeFA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] dt-bindings: can: rcar_can: Add r8a774b1 support
To:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
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

On Wed, Dec 18, 2019 at 4:15 PM Fabrizio Castro
<fabrizio.castro@bp.renesas.com> wrote:
> Do you think you can take this patch?

Sure, queuing in renesas-dt-bindings-for-v5.6.

> > From: Rob Herring <robh@kernel.org>
> > Sent: 14 October 2019 19:10
> > Subject: Re: [PATCH net-next v2 1/3] dt-bindings: can: rcar_can: Add r8a774b1 support
> >
> > On Thu, 10 Oct 2019 15:25:58 +0100, Fabrizio Castro wrote:
> > > Document RZ/G2N (r8a774b1) SoC specific bindings.
> > >
> > > Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> > > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > ---
> > > v1->v2:
> > > * No change
> > >
> > >  Documentation/devicetree/bindings/net/can/rcar_can.txt | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > >
> >
> > Acked-by: Rob Herring <robh@kernel.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
