Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7B947D693
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 19:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344628AbhLVSYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 13:24:08 -0500
Received: from mail-qk1-f171.google.com ([209.85.222.171]:42647 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233546AbhLVSYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 13:24:06 -0500
Received: by mail-qk1-f171.google.com with SMTP id r139so2270856qke.9;
        Wed, 22 Dec 2021 10:24:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C7ZtVSYP9Yi6bYOvHnDby1s0qX4T7Lx5NG910re0wV4=;
        b=JhSi5lXRUIb+1Y3YXinfL0g9dLpP97ac7TsiYEq2XItJJ2ZGFL+7SuA8oHqtVs2K47
         VVbQaTG5e79eGl+6NkRHFRxyEQwAGhTtWxqtyNVBvPLhX7hszcS5idCrJJyC3Pw1BPQ1
         u7Lz0gWFgPUYXx2ILV7KfQKM/4NoXD6LSo/N8smkH8qcvSbC1uNWTUYlWAMjJ7zvvALI
         VHFxFkz47YphjeyCHRHQUUHuaG26l32K38jSzcZQW7nKo83XIHwD5cww6jgIJBvmCuNL
         ERsEJvYt/qW6jLvynKWTNjZb+bI8eEsA7j3eq4YS2pOkFgz5gOgo1xcxqs5nCopTdL2a
         aI0g==
X-Gm-Message-State: AOAM530d9WI/+raRQMpEiTmeq/iQDjkSVPKM5T3vZmkejjFNbzrvpmC1
        MBSqaDD/Ymz8scstwkTdqg==
X-Google-Smtp-Source: ABdhPJyOsdfN6kU2aibhnEvWH0JSWiE+HyhSOLfG3dLvmqe46WbQgPvL1JR44hWaSXHwK6/WvUrI6w==
X-Received: by 2002:a05:620a:4494:: with SMTP id x20mr2838909qkp.530.1640197445674;
        Wed, 22 Dec 2021 10:24:05 -0800 (PST)
Received: from robh.at.kernel.org ([24.55.105.145])
        by smtp.gmail.com with ESMTPSA id d17sm271232qtb.71.2021.12.22.10.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 10:24:05 -0800 (PST)
Received: (nullmailer pid 2456237 invoked by uid 1000);
        Wed, 22 Dec 2021 18:24:03 -0000
Date:   Wed, 22 Dec 2021 14:24:03 -0400
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Magnus Damm <magnus.damm@gmail.com>, linux-serial@vger.kernel.org,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vinod Koul <vkoul@kernel.org>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-gpio@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 03/16] dt-bindings: power: renesas,rzg2l-sysc: Document
 RZ/V2L SoC
Message-ID: <YcNtQ0MoOqAfulj1@robh.at.kernel.org>
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20211221094717.16187-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221094717.16187-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Dec 2021 09:47:04 +0000, Lad Prabhakar wrote:
> From: Biju Das <biju.das.jz@bp.renesas.com>
> 
> Add DT binding documentation for SYSC controller found on RZ/V2L SoC.
> SYSC controller found on the RZ/V2L SoC is almost identical to one found
> on the RZ/G2L SoC's only difference being that the RZ/V2L has an
> additional register to control the DRP-AI.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  .../devicetree/bindings/power/renesas,rzg2l-sysc.yaml      | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
