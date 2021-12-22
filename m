Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E16447D670
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 19:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344584AbhLVSUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 13:20:55 -0500
Received: from mail-qt1-f174.google.com ([209.85.160.174]:42948 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233546AbhLVSUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 13:20:54 -0500
Received: by mail-qt1-f174.google.com with SMTP id z9so2698045qtj.9;
        Wed, 22 Dec 2021 10:20:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XRcKcj+cA5XUzfaaLDrt+fgsCeFBFXEbRB10f73PiyY=;
        b=HpQkxD8PFEW1pXKzrcbAq4JNa/CYjCzCyVbK/FeoAPuu+lI2G4CORO39HWa77WlXJ5
         KuQV0zWDfTz55rXrNGljIuVnqgH8ppTXTxjNqIjTr5am9uOTaQJjGXen45Eq4nLvixUV
         JCpEBsaNaDyWif/zPbdJN8GQVYzahE9kSDGThS9e0PtPTmMTtHcUEp8mHUkJw4yn9NQg
         76+RHoo/j0DcPhnVkLToNa542R5AapmPdzs7JsBtDajybkjRXeFEXEjCNSYkSoMQvgU8
         Q+kQEkAWsq/EKUzVcgMEMi7ZRWITpz0/1ZF38hFNRREoBfKEjU/g8866AWZAeLx8YnET
         e/mQ==
X-Gm-Message-State: AOAM530+CgEbBBEvJ2AO2riZMibE5SLLHYm+A/i/T0MFsU8//gjvSZ/R
        tmeZkF+BvX1CI73hnXYnTg==
X-Google-Smtp-Source: ABdhPJzBkXsa+9kAJPWbu/0STBGBkUvlqE6y6OnQfmhaZwkNESHTX36Exuu8bQZ3A42RH4J1RtvjSA==
X-Received: by 2002:a05:622a:43:: with SMTP id y3mr3143240qtw.575.1640197252979;
        Wed, 22 Dec 2021 10:20:52 -0800 (PST)
Received: from robh.at.kernel.org ([24.55.105.145])
        by smtp.gmail.com with ESMTPSA id t3sm2256640qtc.7.2021.12.22.10.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 10:20:52 -0800 (PST)
Received: (nullmailer pid 2451021 invoked by uid 1000);
        Wed, 22 Dec 2021 18:20:50 -0000
Date:   Wed, 22 Dec 2021 14:20:50 -0400
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     linux-clk@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Turquette <mturquette@baylibre.com>,
        linux-serial@vger.kernel.org, netdev@vger.kernel.org,
        Stephen Boyd <sboyd@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jakub Kicinski <kuba@kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 01/16] dt-bindings: arm: renesas: Document Renesas RZ/V2L
 SoC
Message-ID: <YcNsggkexM75uxni@robh.at.kernel.org>
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20211221094717.16187-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221094717.16187-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Dec 2021 09:47:02 +0000, Lad Prabhakar wrote:
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

Acked-by: Rob Herring <robh@kernel.org>
