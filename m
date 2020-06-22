Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2183E204175
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 22:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730812AbgFVUKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 16:10:02 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:43516 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730802AbgFVUJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 16:09:55 -0400
Received: by mail-oi1-f194.google.com with SMTP id j189so16756559oih.10;
        Mon, 22 Jun 2020 13:09:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OiePC4i/uqD+1c3W+5eApnEHXPxElxi4Y3ejQe4iWbM=;
        b=SOcV7Ek+XJl/Z5MySWcz+Gj4FJ4CjEth1z+Y0TMrw7vjGuYTBqQwcplHBnyF87avJR
         OfclI33KAc+s8FcncurRU61LFwPiwQw/PNApMExA7FMDpwEqAXYEZP0rR9+whHH9wyz5
         vQCTgH+H6z+i9los66XxsC7URxfvwXtbN07FCMWSENuU9D9Z819t2UZ+WAYFUfYSEKXz
         DogsY4ayz1DE2rbWmpJmR3miatx2JqncNJUt03ypP8OSFreKueTPOZXE5mJjDLq7JPrU
         m9d8jw5G6UGeyZoZ03GIGdVLUyx2j8k4mU0e9Ezl+BBPtm+L5TlvPzAZC6Vvaz9zyImt
         Vs+g==
X-Gm-Message-State: AOAM533r80KqgqVw/21t7oNCbdoCo7EKIax9LEPSRsWb9IQ8OtjRRNel
        +drmHRSAE3/lhpCQLpIFoLTKbEiCorrfKyqGHEm46onF
X-Google-Smtp-Source: ABdhPJwm8jCWTZ8wTPreeBQUXPLsl6F4YxPDq2wFJCIfu8r7ux3hmF4g5TPzSR2txESMgnjTGIt4VHqMIsRVL+CEsfw=
X-Received: by 2002:aca:1a19:: with SMTP id a25mr13968777oia.54.1592856594434;
 Mon, 22 Jun 2020 13:09:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200621081710.10245-1-geert+renesas@glider.be> <8d90ef9a-32d3-659f-f808-5d62d1d7ac6d@cogentembedded.com>
In-Reply-To: <8d90ef9a-32d3-659f-f808-5d62d1d7ac6d@cogentembedded.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 22 Jun 2020 22:09:43 +0200
Message-ID: <CAMuHMdXN1o9iG+CM-S5DaikkD_W7zyYAwRpZbEE39EY8PjWHLw@mail.gmail.com>
Subject: Re: [PATCH/RFC] dt-bindings: net: renesas,etheravb: Convert to json-schema
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergei,

On Mon, Jun 22, 2020 at 10:04 PM Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> On 06/21/2020 11:17 AM, Geert Uytterhoeven wrote:
> > Convert the Renesas Ethernet AVB (EthernetAVB-IF) Device Tree binding
> > documentation to json-schema.
> >
> > Add missing properties.
> > Update the example to match reality.
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
>    As I'm only seeing the formatting issues, here's my:
>
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

Thank you!

> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
> > @@ -0,0 +1,269 @@
> [...]
> > +maintainers:
> > +  - Sergei Shtylyov <sergei.shtylyov@gmail.com>
>
>    Thank you! :-)

You're (very) welcome ;-)

>
> > +
> > +properties:
> > +  compatible:
> > +    oneOf:
> > +      - items:
> > +          - enum:
> > +              - renesas,etheravb-r8a7742      # RZ/G1H
> > +              - renesas,etheravb-r8a7743      # RZ/G1M
> > +              - renesas,etheravb-r8a7744      # RZ/G1N
> > +              - renesas,etheravb-r8a7745      # RZ/G1E
> > +              - renesas,etheravb-r8a77470     # RZ/G1C
> > +              - renesas,etheravb-r8a7790      # R-Car H2
> > +              - renesas,etheravb-r8a7791      # R-Car M2-W
> > +              - renesas,etheravb-r8a7792      # R-Car V2H
> > +              - renesas,etheravb-r8a7793      # R-Car M2-N
> > +              - renesas,etheravb-r8a7794      # R-Car E2
>
>    Hm, overindented starting with "- items:"?

I believe this is consistent with e.g. commit 9f60a65bc5e6cd88
("dt-bindings: Clean-up schema indentation formatting").

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
