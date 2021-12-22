Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B34C47D6D5
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 19:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344742AbhLVS2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 13:28:19 -0500
Received: from mail-qk1-f180.google.com ([209.85.222.180]:43810 "EHLO
        mail-qk1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236475AbhLVS2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 13:28:18 -0500
Received: by mail-qk1-f180.google.com with SMTP id f138so3148494qke.10;
        Wed, 22 Dec 2021 10:28:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BQVHinv4Cgd22h/GWeg09N0p9AK9353UAAMDL16H6IM=;
        b=pqUxQE3X0CtYNXz5C2fDZN9vaC7fdCsHa3AIL0uzThZG+AwMzk2/Fo0rdoK4ZtUEuM
         /n4jViGRF4qyaSNjkYIXG93IbHld2vaJe/o9Q7jnhocuF0tonG1tU0RLnoGbLoqvyiwj
         2Z3lkK0VW7mwMFqWH563qep4HobgHdXoeQ68vwlhE3m3nM6js8WUfZ+NSC+KCYp81nlm
         0yf0VvfN3nKSqt/y5Iwiv3WgHQ8jIgFR/tu8ejRS8UYXVF3ksWbH2c6aPU3VHPsPLzRQ
         CeRNg/VXyRdBT6ZUUc7oNQqnClEHfCfBoWJ1EqcTrtXTC1BgOiuo13RdrB1pg6+RIAr1
         crUA==
X-Gm-Message-State: AOAM530PY4R7UTPbYX7jNkwDmvH5GFYkI/cRXxrr/fyMpY9vImGXKchJ
        804/sLrs01oGuXy7hnMm/g==
X-Google-Smtp-Source: ABdhPJyTGIBihg0G/yVtVYX1Gz0fkM6asEfTlgU/B6KKvYzxPNc4S5SjaaGD5r8Uu2e3WnF02Fhg0w==
X-Received: by 2002:a37:94c2:: with SMTP id w185mr2854133qkd.666.1640197697351;
        Wed, 22 Dec 2021 10:28:17 -0800 (PST)
Received: from robh.at.kernel.org ([24.55.105.145])
        by smtp.gmail.com with ESMTPSA id y18sm2492143qtx.19.2021.12.22.10.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 10:28:16 -0800 (PST)
Received: (nullmailer pid 2463743 invoked by uid 1000);
        Wed, 22 Dec 2021 18:28:14 -0000
Date:   Wed, 22 Dec 2021 14:28:14 -0400
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     linux-serial@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-clk@vger.kernel.org, linux-gpio@vger.kernel.org,
        Michael Turquette <mturquette@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S. Miller" <davem@davemloft.net>,
        Vinod Koul <vkoul@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org, dmaengine@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 14/16] dt-bindings: net: renesas,etheravb: Document
 RZ/V2L SoC
Message-ID: <YcNuPnkXLBBjFRG0@robh.at.kernel.org>
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20211221094717.16187-15-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221094717.16187-15-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Dec 2021 09:47:15 +0000, Lad Prabhakar wrote:
> From: Biju Das <biju.das.jz@bp.renesas.com>
> 
> Document Gigabit Ethernet IP found on RZ/V2L SoC. Gigabit Ethernet
> Interface is identical to one found on the RZ/G2L SoC. No driver changes
> are required as generic compatible string "renesas,rzg2l-gbeth" will be
> used as a fallback.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/net/renesas,etheravb.yaml | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
