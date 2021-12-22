Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62AF647D6CC
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 19:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344726AbhLVS2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 13:28:00 -0500
Received: from mail-qt1-f172.google.com ([209.85.160.172]:38489 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236475AbhLVS16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 13:27:58 -0500
Received: by mail-qt1-f172.google.com with SMTP id 8so2735714qtx.5;
        Wed, 22 Dec 2021 10:27:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mDnepFkvSa50s61pBBWTK6cNFoN10smpm+n7sfrBteo=;
        b=wTtftsqWHjE8xX85GVbq7Py/xeRNKwJCg6vNejCoOna+evHFlgFNhoFeINoG8J/HM1
         24NBkRr4APbo3cgRgMBOp0Wn9Am53HjmMjDpWG1Sxpaqb+htWy5Lb6LOPlqyXF/7ftzG
         NJIPt3fedtu5/DMHcHlYaEQjU4FpiPKXWTgFd2sUzI/XNtpf93NsH710TUUeTigoXiBV
         wR2s14g+B6TmQb49uxzmAaKyed/wtFxNji0HjHp5WgXQjNf2W1SBdJxw9VJ6a8wHYnFW
         jFPd1gbeyzo24sQqdCLHlYiJ+8Wud6DLzIiUjE+nJpTTXQNeScE96fFluPt59F8EKqK1
         MtVg==
X-Gm-Message-State: AOAM532F0A5juKIIlc2a59Cwyk+4O3rwj18yN0FPOCOM/063+buh74wM
        /BYUJqUmJLzAtSYsP2CoRrAOrO78h4jQ
X-Google-Smtp-Source: ABdhPJxMF0xSPhULQUy+z6id33zQ+sx0CrVo2mu+WLb+q6WxSA7pYYsogtJuA/ww60kXTk+PR06V5w==
X-Received: by 2002:aed:3044:: with SMTP id 62mr3069002qte.661.1640197677485;
        Wed, 22 Dec 2021 10:27:57 -0800 (PST)
Received: from robh.at.kernel.org ([24.55.105.145])
        by smtp.gmail.com with ESMTPSA id u17sm2493749qki.2.2021.12.22.10.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 10:27:56 -0800 (PST)
Received: (nullmailer pid 2463091 invoked by uid 1000);
        Wed, 22 Dec 2021 18:27:54 -0000
Date:   Wed, 22 Dec 2021 14:27:54 -0400
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-serial@vger.kernel.org, devicetree@vger.kernel.org,
        Michael Turquette <mturquette@baylibre.com>,
        linux-clk@vger.kernel.org, Prabhakar <prabhakar.csengg@gmail.com>,
        dmaengine@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-gpio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>
Subject: Re: [PATCH 13/16] dt-bindings: dma: rz-dmac: Document RZ/V2L SoC
Message-ID: <YcNuKp1kEGm4Ly4o@robh.at.kernel.org>
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20211221094717.16187-14-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221094717.16187-14-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Dec 2021 09:47:14 +0000, Lad Prabhakar wrote:
> From: Biju Das <biju.das.jz@bp.renesas.com>
> 
> Document RZ/V2L DMAC bindings. RZ/V2L DMAC is identical to one found on
> the RZ/G2L SoC. No driver changes are required as generic compatible
> string "renesas,rz-dmac" will be used as a fallback.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/dma/renesas,rz-dmac.yaml | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
