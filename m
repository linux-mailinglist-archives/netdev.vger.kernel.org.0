Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4E5280E13
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 09:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgJBHdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 03:33:04 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43574 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgJBHdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 03:33:04 -0400
Received: by mail-ot1-f65.google.com with SMTP id n61so510182ota.10;
        Fri, 02 Oct 2020 00:33:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i0BxTRWq9QLgI6hSEktstwE5J1XX/IGqSCCD9sxjccA=;
        b=WVPzS8oelpwW4VDC0lngLATEycaAGmW0KIiVLxScAp5QByl96+56spRfpCnc0EO+D+
         +1nUOr2UoiQm7ThDwMZ4PiWNXhVBQpatg/v5sSVsYW0CopSOWehmjra3qjBwy3sQw8Ar
         3kViwC9QfYR88V2yE21hspfq133i4nnr3BMFvbtIA3GY4bKYIcT1YuANMuKcIloKbj4S
         Wtl1J5aLN5aIMRtraDbXwO2254N/KeSs5WQ3jKruwS0EQOPG4AjUETbNK34LQe8x1I/C
         kRlmfZP6ME6ZPgB7lJLtFBXI6Rqp0v7fXVAYcB7ywdOpHMPpFjC/wJvTvo0W0RD8yblm
         cMTQ==
X-Gm-Message-State: AOAM532hgCWQg0IGzlbQKsY0rvM82fA0/nJOKK4dng7tLSXVmOn9b05v
        BOTztbdNCSVcSPxwzbVbbdNclEu6GiNND3vwelcj8p1s
X-Google-Smtp-Source: ABdhPJwACY0SABTWY3mw/HvFFTMe+4lu1BY2IUjRwb4M/xt4Kuvc6m3aL1GqaRSX6pAbToniQcn7gF8uX2+ivCXDufI=
X-Received: by 2002:a05:6830:1008:: with SMTP id a8mr737978otp.107.1601623983253;
 Fri, 02 Oct 2020 00:33:03 -0700 (PDT)
MIME-Version: 1.0
References: <20201002130237.42fe476e@canb.auug.org.au>
In-Reply-To: <20201002130237.42fe476e@canb.auug.org.au>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 2 Oct 2020 09:32:52 +0200
Message-ID: <CAMuHMdVouviP6mUmTd1b1uvkmZWYXinECOvOLr-y-z-7C46cdA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Marian-Cristian Rotariu 
        <marian-cristian.rotariu.rb@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On Fri, Oct 2, 2020 at 5:02 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Today's linux-next merge of the net-next tree got a conflict in:
>
>   Documentation/devicetree/bindings/net/renesas,ravb.txt
>
> between commit:
>
>   307eea32b202 ("dt-bindings: net: renesas,ravb: Add support for r8a774e1 SoC")
>
> from the net tree and commit:
>
>   d7adf6331189 ("dt-bindings: net: renesas,etheravb: Convert to json-schema")
>
> from the net-next tree.
>
> I fixed it up (I deleted the file and added the following patch) and
> can carry the fix as necessary. This is now fixed as far as linux-next
> is concerned, but any non trivial conflicts should be mentioned to your
> upstream maintainer when your tree is submitted for merging.  You may
> also want to consider cooperating with the maintainer of the conflicting
> tree to minimise any particularly complex conflicts.
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 2 Oct 2020 12:57:33 +1000
> Subject: [PATCH] fix up for "dt-bindings: net: renesas,ravb: Add support for r8a774e1 SoC"
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Thank you, that resolution looks good to me!

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

> --- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
> +++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
> @@ -31,6 +31,7 @@ properties:
>                - renesas,etheravb-r8a774a1     # RZ/G2M
>                - renesas,etheravb-r8a774b1     # RZ/G2N
>                - renesas,etheravb-r8a774c0     # RZ/G2E
> +              - renesas,etheravb-r8a774e1     # RZ/G2H
>                - renesas,etheravb-r8a7795      # R-Car H3
>                - renesas,etheravb-r8a7796      # R-Car M3-W
>                - renesas,etheravb-r8a77961     # R-Car M3-W+
> --
> 2.28.0

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
