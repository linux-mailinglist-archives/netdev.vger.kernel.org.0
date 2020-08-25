Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00346250EE9
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 04:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgHYCVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 22:21:09 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40758 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbgHYCVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 22:21:07 -0400
Received: by mail-io1-f66.google.com with SMTP id q132so471131iod.7;
        Mon, 24 Aug 2020 19:21:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rg7Bsd6p+mIyfsdifHuWk+4yWTHBPMjJ9LRnbA1nMVw=;
        b=hHrM6wxP1vqP17b9vm5/ERu53XsAoH4t1NXupNTGhGlZIb+W3pbpWqN2uKVLtObtqP
         tP/UYgG8wJO3Ic8PtNzAFkfC/c3210EYyE/ztissMVZeMGtJ4DM3ZNn66F0mmcnrwPms
         zkypyCApFAJK5QXhEKuO0aWVJmCwDYN8nnhM2izfV/aFVW75HKtDD3B3BB6LtaPLJbDV
         HtyGxAkDhhJqJyDkpCAaN9Hr03SNFGDHxpfMhyuzjI+VEJeGVNVFh3CejHo8oNYR8RsQ
         qYjg7/vBil35x+diXI3vFWm2pOGhCF7Bnh4YoImrIdZsYEotop2I90lXZNmbT5gn6JGY
         u1oQ==
X-Gm-Message-State: AOAM53180JKe/SjT4MkyhUsDjMDXjBVPBjtRyS0RtwOl8rlR5Yxk6mZD
        3NpSOUfiQuGNBm/blGY4/w==
X-Google-Smtp-Source: ABdhPJwbSqh1z12wlvJULaLb/vP4/4rRUIPZFoP7kgCBcEhrK9NvGe+E689vQgXG7sj5IG0hXXN7uQ==
X-Received: by 2002:a6b:d811:: with SMTP id y17mr7359240iob.199.1598322066291;
        Mon, 24 Aug 2020 19:21:06 -0700 (PDT)
Received: from xps15 ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id u68sm3268099ioe.18.2020.08.24.19.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 19:21:05 -0700 (PDT)
Received: (nullmailer pid 3808092 invoked by uid 1000);
        Tue, 25 Aug 2020 02:21:02 -0000
Date:   Mon, 24 Aug 2020 20:21:02 -0600
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Magnus Damm <magnus.damm@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-gpio@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH 2/3] dt-bindings: can: rcar_can: Add r8a7742 support
Message-ID: <20200825022102.GA3808062@bogus>
References: <20200816190732.6905-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20200816190732.6905-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200816190732.6905-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 16 Aug 2020 20:07:31 +0100, Lad Prabhakar wrote:
> Document RZ/G1H (r8a7742) SoC specific bindings. The R8A7742 CAN module
> is identical to R-Car Gen2 family.
> 
> No driver change is needed due to the fallback compatible value
> "renesas,rcar-gen2-can".
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Chris Paterson <Chris.Paterson2@renesas.com>
> ---
>  Documentation/devicetree/bindings/net/can/rcar_can.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
