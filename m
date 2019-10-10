Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54818D29B2
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 14:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387756AbfJJMjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 08:39:46 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:36027 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733191AbfJJMjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 08:39:46 -0400
Received: by mail-oi1-f193.google.com with SMTP id k20so4746348oih.3;
        Thu, 10 Oct 2019 05:39:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=arKu8+1LbG7MDGBNwfTmuA7CC9g505hUgH6IFotM2/c=;
        b=ozzbx5KuOwxx9ymQfTA5dIfKSbLpTBH/1SWzQFOBtsthgF1REwaCG80ioBULdcrCNU
         HtxxY5oJC7BbZs1Mh9BM0HhSYTp5i7JHgnvHADbJZ9axOTRMl0j59caNWogA5SVphBda
         sGPB3iXPXA4vah/NssUt+M8q1tX58veWwLGKJtajauL98sjiprbx5OfKm5SolkBQr78n
         dSgzvv1w24ecw31A0ETigRMKXwbRSu8EX2ePufk6qaOeyIF9tpQV/YwkZwVqnwtW2uTb
         eKqKZfYtPq3U1Y+9JMDkKVUX6xv3aNQu4OcnUexZC1UyQm7uZnwuvH5CAXs8dbriVyGV
         tDkQ==
X-Gm-Message-State: APjAAAVYncBcl1XVU7jStUu/kfleVAOmqUpsWgFN5QuEnqiWkrrPWycB
        O/9xFykl1+aBlPtWhueeqjCePPMOzc0CVDpi7rE=
X-Google-Smtp-Source: APXvYqzLakd1QGm7NlmSwapT6TqYzAQXmi83jiIwGm36dogCfBtD/ZpLsuYI0+LM1pEbcYjGZ3PCR/ajFAp6sXXFXsQ=
X-Received: by 2002:aca:882:: with SMTP id 124mr7307124oii.54.1570711185364;
 Thu, 10 Oct 2019 05:39:45 -0700 (PDT)
MIME-Version: 1.0
References: <1570711049-5691-1-git-send-email-fabrizio.castro@bp.renesas.com> <1570711049-5691-2-git-send-email-fabrizio.castro@bp.renesas.com>
In-Reply-To: <1570711049-5691-2-git-send-email-fabrizio.castro@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 10 Oct 2019 14:39:34 +0200
Message-ID: <CAMuHMdXDoTVhrroTZJ0RW62BHf2atwzw4AJrc6YTp441i4aH4A@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] dt-bindings: can: rcar_can: Add r8a774b1 support
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

On Thu, Oct 10, 2019 at 2:37 PM Fabrizio Castro
<fabrizio.castro@bp.renesas.com> wrote:
> Document RZ/G2N (r8a774b1) SoC specific bindings.
>
> Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
