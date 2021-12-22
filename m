Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8444347D680
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 19:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344609AbhLVSXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 13:23:03 -0500
Received: from mail-qt1-f170.google.com ([209.85.160.170]:42664 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233546AbhLVSXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 13:23:02 -0500
Received: by mail-qt1-f170.google.com with SMTP id z9so2703631qtj.9;
        Wed, 22 Dec 2021 10:23:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KqOjEtrlcE2ip2KNPDM68iXSHg0vzVwe/3kIipJRdCI=;
        b=jbkZBS63taR4UneAFi78H/g13Aqh6fiDEh984OBcSopQ4gO86lfdCOSiotDuOG6YxY
         mu3fggYZYew01/S65OTrGjSeyvr7V9KmKBuTZerX4oukWydVLKWFAklqPWJUjSiyML8O
         J7pk1DOFFU8GNX81Hlwidmp+SSeKjXiT4fmIZDJ7V2i8wMiWLjTq2Ii47V69bzG+Yfs0
         1NR4eVBY32T/CkWSQFRr8uOzgSc8dE8ywTmt/qTcf/jK990NjFI/xwUPCs3VPYePn/LR
         +J0IxK/62WQ26O6YewNKSx4G03pmrwVQIusevb1HkCoJja+oVURpqL7/ZuXfyrFvrJw7
         wnAQ==
X-Gm-Message-State: AOAM5314QAL6ny/vF94t26K8wSxOsI16qk2c77PEJVn2UoRk+d7xBRy7
        KDZOLvtmbcltseq6Pct4/w==
X-Google-Smtp-Source: ABdhPJwhdldAOeNhhd8xBPZD+NyLRSSFDtPT2FEkmDLQlGYrLmaAbziLLrYvwFiGSXfSFRZ5/DLD+g==
X-Received: by 2002:a05:622a:1654:: with SMTP id y20mr3116110qtj.374.1640197381440;
        Wed, 22 Dec 2021 10:23:01 -0800 (PST)
Received: from robh.at.kernel.org ([24.55.105.145])
        by smtp.gmail.com with ESMTPSA id c25sm2527272qkp.31.2021.12.22.10.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 10:23:00 -0800 (PST)
Received: (nullmailer pid 2454414 invoked by uid 1000);
        Wed, 22 Dec 2021 18:22:58 -0000
Date:   Wed, 22 Dec 2021 14:22:58 -0400
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        dmaengine@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-serial@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 01/16] dt-bindings: arm: renesas: Document Renesas RZ/V2L
 SoC
Message-ID: <YcNtAtVZgM+Z9i3X@robh.at.kernel.org>
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20211221094717.16187-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221094717.16187-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 09:47:02AM +0000, Lad Prabhakar wrote:
> From: Biju Das <biju.das.jz@bp.renesas.com>
> 
> Document Renesas RZ/V2L SoC.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/arm/renesas.yaml | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/renesas.yaml b/Documentation/devicetree/bindings/arm/renesas.yaml
> index 6a9350ee690b..55a5aec418ab 100644
> --- a/Documentation/devicetree/bindings/arm/renesas.yaml
> +++ b/Documentation/devicetree/bindings/arm/renesas.yaml
> @@ -421,6 +421,13 @@ properties:
>                - renesas,r9a07g044l2 # Dual Cortex-A55 RZ/G2L
>            - const: renesas,r9a07g044
>  
> +      - description: RZ/V2L (R9A07G054)
> +        items:
> +          - enum:
> +              - renesas,r9a07g054l1 # Single Cortex-A55 RZ/V2L
> +              - renesas,r9a07g054l2 # Dual Cortex-A55 RZ/V2L

I'd assume this is just a fuse difference and with cpu nodes you can 
distinguish how many cores.

> +          - const: renesas,r9a07g054
> +
>  additionalProperties: true
>  
>  ...
> -- 
> 2.17.1
> 
> 
