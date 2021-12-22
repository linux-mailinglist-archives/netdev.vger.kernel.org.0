Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4421747D6A7
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 19:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344664AbhLVSZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 13:25:42 -0500
Received: from mail-qt1-f178.google.com ([209.85.160.178]:41779 "EHLO
        mail-qt1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235701AbhLVSZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 13:25:40 -0500
Received: by mail-qt1-f178.google.com with SMTP id v22so2723158qtx.8;
        Wed, 22 Dec 2021 10:25:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8xiIQCPd6qHmq1Vvz5oH+OCR1hRyuSPl43ZOlHp4Ays=;
        b=Qz8ZlnfU5mGuAwisLzqsXDpt/N2b7pIXjwxpRvdxH14r+WZY/oMsWEonZgAVf5SnNS
         ApcM8YojfTChYdRtryl/dLmYgEJ6QGVoj1+81Vhwzc28ZaxyNKKiZ3MtrL/3Jk6YX8BK
         S0DvtT3Dtbyt8chl1toBSYWNUPB7DP5/Ej3ihmXDuOY1HnDRnuIbX6dLQ+Ylj7654eiX
         YJ9tQnPG1vi+H3wGT+65Y0J/f97hXHwOD6JhxoEag3Ui1CRsiICqfiTR2jhBEzJba8Xu
         QlwTEA8K+gqf1O5bsaKit1SZJHCDGr1M5/v2A+OM6KnnoHX+PA4s1sdoqf7qzKfdGfyS
         A5hA==
X-Gm-Message-State: AOAM5304aZHkr2ystdTIR572rIrDzVJiIStwAgzujFHh4plEaJKdcQbG
        2NUM4+c+KJlA9RnyUHXh9A==
X-Google-Smtp-Source: ABdhPJwyzRKDji8nNRgvqdnyRoyqJ5tqJ82foqUlq9ClPgCs7a/70R729Bqv95CF7M7OHb9Sic+Qjg==
X-Received: by 2002:a05:622a:1755:: with SMTP id l21mr3192313qtk.539.1640197539531;
        Wed, 22 Dec 2021 10:25:39 -0800 (PST)
Received: from robh.at.kernel.org ([24.55.105.145])
        by smtp.gmail.com with ESMTPSA id br13sm2558184qkb.10.2021.12.22.10.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 10:25:39 -0800 (PST)
Received: (nullmailer pid 2458963 invoked by uid 1000);
        Wed, 22 Dec 2021 18:25:36 -0000
Date:   Wed, 22 Dec 2021 14:25:36 -0400
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        linux-gpio@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Stephen Boyd <sboyd@kernel.org>, devicetree@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Turquette <mturquette@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>, dmaengine@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, linux-clk@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 07/16] dt-bindings: serial: renesas,sci: Document RZ/V2L
 SoC
Message-ID: <YcNtoISH79d9NkE1@robh.at.kernel.org>
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20211221094717.16187-8-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221094717.16187-8-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Dec 2021 09:47:08 +0000, Lad Prabhakar wrote:
> From: Biju Das <biju.das.jz@bp.renesas.com>
> 
> Add SCI binding documentation for Renesas RZ/V2L SoC. No driver changes
> are required as generic compatible string "renesas,sci" will be used as
> a fallback.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/serial/renesas,sci.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
