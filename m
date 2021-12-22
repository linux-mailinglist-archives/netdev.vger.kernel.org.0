Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD88A47D69F
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 19:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344652AbhLVSZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 13:25:22 -0500
Received: from mail-qt1-f173.google.com ([209.85.160.173]:44592 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235701AbhLVSZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 13:25:21 -0500
Received: by mail-qt1-f173.google.com with SMTP id a1so2699272qtx.11;
        Wed, 22 Dec 2021 10:25:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7jIsljGOfLEgX6Qd7ZUgKSrFEOjhGjv93uNRBe+l/KU=;
        b=Z1RXHyGpPTm4VGHwWE2lsxCwvHYFDdrdy64hbg4dKZ1t7nc9H96Gd6eJq+wDXdPx6f
         SJ5iqNzoQpDV0zoSBaam9KgGLs8iqb0KyNS3auIRPyDejxnEbDCXJQEEyMA5OKFuan1B
         zKGI7uZnI+Y/3KpTNr/nHKpT5hGLAAEXXtyy+1zBEoWKWtv7TfdzKoVn8u/9fINEaK+/
         YekkO/HRf32tXxCBpFqCXG1X2TSgdWf0snO+eSgqKB/IsXKHZDndX5e0MHO/7L8RDnre
         pmp3CQqyU1oN6FA4+yBEcv2gPiMraPwcS4CLNrlAq06H+FJVj/AVemwMkCiQoz86w22j
         l1qw==
X-Gm-Message-State: AOAM533TZm73Q3kwJ1bLWyHNRqAv+8PXTqFP7KhQn5wbjYVtCjP3aOtU
        eBG3iJmZ7FTy3EaVEbaVcXBhUiOO0p5c
X-Google-Smtp-Source: ABdhPJzP9vu+FURS7kwGn9ciPilYIt/6yn/YvWJ3RSqLWfpJrPB4dBwsTNgu5mKht3W0gOCVcNX4YQ==
X-Received: by 2002:ac8:5a84:: with SMTP id c4mr3106295qtc.565.1640197520513;
        Wed, 22 Dec 2021 10:25:20 -0800 (PST)
Received: from robh.at.kernel.org ([24.55.105.145])
        by smtp.gmail.com with ESMTPSA id az14sm2524096qkb.97.2021.12.22.10.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 10:25:20 -0800 (PST)
Received: (nullmailer pid 2458339 invoked by uid 1000);
        Wed, 22 Dec 2021 18:25:17 -0000
Date:   Wed, 22 Dec 2021 14:25:17 -0400
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Prabhakar <prabhakar.csengg@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, linux-clk@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        dmaengine@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>, netdev@vger.kernel.org,
        Stephen Boyd <sboyd@kernel.org>, linux-serial@vger.kernel.org,
        Biju Das <biju.das.jz@bp.renesas.com>,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Turquette <mturquette@baylibre.com>
Subject: Re: [PATCH 06/16] dt-bindings: serial: renesas,scif: Document RZ/V2L
 SoC
Message-ID: <YcNtjbXAEWjeFGVl@robh.at.kernel.org>
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20211221094717.16187-7-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221094717.16187-7-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Dec 2021 09:47:07 +0000, Lad Prabhakar wrote:
> From: Biju Das <biju.das.jz@bp.renesas.com>
> 
> Add SCIF binding documentation for Renesas RZ/V2L SoC. SCIF block on RZ/V2L
> is identical to one found on the RZ/G2L SoC. No driver changes are required
> as RZ/G2L compatible string "renesas,scif-r9a07g044" will be used as a
> fallback.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/serial/renesas,scif.yaml | 7 +++++++
>  1 file changed, 7 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
