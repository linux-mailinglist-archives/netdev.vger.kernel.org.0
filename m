Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54B947D68A
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 19:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344616AbhLVSXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 13:23:50 -0500
Received: from mail-qk1-f172.google.com ([209.85.222.172]:43799 "EHLO
        mail-qk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233546AbhLVSXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 13:23:48 -0500
Received: by mail-qk1-f172.google.com with SMTP id f138so3136366qke.10;
        Wed, 22 Dec 2021 10:23:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yKFaIS6TjzN3rlXcKN5uMc4d1SR0S606OYE9wIg5FuU=;
        b=wAoT2zFy0Zn2j+cbEzcsZEZnNFIFiMdhrRHYtbyA3LFgOg+Yq2qZZorfiCDEH0NZfu
         F72Qyd/hV7LXsm5HkPsXkClGI8l0BIoOhSEbR+hWVlEjfUhu7myNDMDSyj/A1aFQizV0
         H9/LFyPOPYkiYHfM4eNi6QhbmIh18eii/3T2/WiA5IUOpuEvU6pfAKEuNUWgtmPSI4eQ
         +Hm3fv5P0FJpc5gIVqaZ9hjK3f+fLROsp5s/FAiX/lHZJKAieE0TcHejRrmeSlhZl3P3
         v85GlwgQhksPDYxzMt75U7jjgT98Pb7ozrA8VsqEy4RS0zAX85bvBfFFuKSmF0GwP4yd
         eIXA==
X-Gm-Message-State: AOAM533rS/h9ohbo+MIXoTLp60uYPBU+7ZCyNEolPAKadEumYAIi01gL
        v73SnPud12QmvXPFgyeADQ==
X-Google-Smtp-Source: ABdhPJzJG8KHvY/v8X+NaxfEi8kqtwVY0PZcfM2FNh1Gozxa53ykDgJlGteNe/ih+ZCCspNB3Nverw==
X-Received: by 2002:a05:620a:4082:: with SMTP id f2mr2880871qko.590.1640197427092;
        Wed, 22 Dec 2021 10:23:47 -0800 (PST)
Received: from robh.at.kernel.org ([24.55.105.145])
        by smtp.gmail.com with ESMTPSA id n129sm2215305qkn.64.2021.12.22.10.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 10:23:46 -0800 (PST)
Received: (nullmailer pid 2455575 invoked by uid 1000);
        Wed, 22 Dec 2021 18:23:44 -0000
Date:   Wed, 22 Dec 2021 14:23:44 -0400
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
Subject: Re: [PATCH 02/16] dt-bindings: arm: renesas: Document SMARC EVK
Message-ID: <YcNtMMNKHIgGFZ+V@robh.at.kernel.org>
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20211221094717.16187-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221094717.16187-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 09:47:03AM +0000, Lad Prabhakar wrote:
> From: Biju Das <biju.das.jz@bp.renesas.com>
> 
> Document Renesas SMARC EVK board which is based on RZ/V2L (R9A07G054)
> SoC. The SMARC EVK consists of RZ/V2L SoM module and SMARC carrier board,
> the SoM module sits on top of the carrier board.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/arm/renesas.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/renesas.yaml b/Documentation/devicetree/bindings/arm/renesas.yaml
> index 55a5aec418ab..fa435d6fda77 100644
> --- a/Documentation/devicetree/bindings/arm/renesas.yaml
> +++ b/Documentation/devicetree/bindings/arm/renesas.yaml
> @@ -423,6 +423,8 @@ properties:
>  
>        - description: RZ/V2L (R9A07G054)
>          items:
> +          - enum:
> +              - renesas,smarc-evk # SMARC EVK

This and patch 1 should be combined. Changing the number of compatible 
entries doesn't make sense.

>            - enum:
>                - renesas,r9a07g054l1 # Single Cortex-A55 RZ/V2L
>                - renesas,r9a07g054l2 # Dual Cortex-A55 RZ/V2L
> -- 
> 2.17.1
> 
> 
