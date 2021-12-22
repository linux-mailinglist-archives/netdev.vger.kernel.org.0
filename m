Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8264147D6B8
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 19:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344682AbhLVS07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 13:26:59 -0500
Received: from mail-qt1-f171.google.com ([209.85.160.171]:33698 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234920AbhLVS06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 13:26:58 -0500
Received: by mail-qt1-f171.google.com with SMTP id v4so112452qtk.0;
        Wed, 22 Dec 2021 10:26:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3a2LjwhpewoehatuA3kEXeaGo9msBA1g+3gZ+OUDNeA=;
        b=brE0ZDfwTBT9YWi05I+kzStRGkxMf6F8gZYSj9y9cURDVTm4yvBrpvEsu1rjfPQ5Gz
         i2QP2mmaDgqy9bO0yaNpFWhOBig227Dk5eaoARWoNGaZtgNJxhtAtpyDOlMgiy1LgnYB
         ipKoBrxSNq7X/ODa3M5kH1Df2q07vplR2x+Rp0d8fgJUeUmTLDcdGcJdhqifYjC+kq99
         Xd3tCLEh9hpHRGE/m2V5JzSvd5M4sPyd/qq8NfZbA6G7ksBGfMyVWwhx9CnCuk6pBK4C
         WGNDDNIgx/FQvp/lVo39uRcL0Jb4VwOVjx8hxP2oiQNQmqd/8eNe7+ZDW+CYPvMipej7
         hq0A==
X-Gm-Message-State: AOAM532Ok1LcH4lDjNhQmXjyX3UsJQQV6wWjO/vlvExvS45enGuL15ZJ
        HV/DUJ0M9RJx74Dme6FvtQ==
X-Google-Smtp-Source: ABdhPJyQEXxE56RzoXhgMAFJp9HyB6RPeIaj3vrwPcUXJr+4LvWPRAaRf9EGT/1L6Rc5ntGGZcaksA==
X-Received: by 2002:a05:622a:60a:: with SMTP id z10mr2220167qta.175.1640197617378;
        Wed, 22 Dec 2021 10:26:57 -0800 (PST)
Received: from robh.at.kernel.org ([24.55.105.145])
        by smtp.gmail.com with ESMTPSA id h2sm2569674qkn.136.2021.12.22.10.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 10:26:56 -0800 (PST)
Received: (nullmailer pid 2461233 invoked by uid 1000);
        Wed, 22 Dec 2021 18:26:54 -0000
Date:   Wed, 22 Dec 2021 14:26:54 -0400
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Linus Walleij <linus.walleij@linaro.org>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        linux-clk@vger.kernel.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vinod Koul <vkoul@kernel.org>, Stephen Boyd <sboyd@kernel.org>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        dmaengine@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        linux-renesas-soc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 09/16] dt-bindings: clock: renesas: Document RZ/V2L SoC
Message-ID: <YcNt7ubXxB2wTqVZ@robh.at.kernel.org>
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20211221094717.16187-10-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221094717.16187-10-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Dec 2021 09:47:10 +0000, Lad Prabhakar wrote:
> From: Biju Das <biju.das.jz@bp.renesas.com>
> 
> Document the device tree binding for the Renesas RZ/V2L SoC.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  .../bindings/clock/renesas,rzg2l-cpg.yaml          | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
