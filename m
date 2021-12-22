Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988FE47D6C5
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 19:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344711AbhLVS1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 13:27:51 -0500
Received: from mail-qv1-f51.google.com ([209.85.219.51]:37860 "EHLO
        mail-qv1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236475AbhLVS1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 13:27:49 -0500
Received: by mail-qv1-f51.google.com with SMTP id fo11so3095556qvb.4;
        Wed, 22 Dec 2021 10:27:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8K+1yJthQxBoLvpMU8RxZl0gzfNGnCafcGzge08Vl/E=;
        b=KNRejISlDduebK+kV7ylUDzaYk44+G8lgPjKtEZw116hWKX8FeiUf0izkbx3Oj+qgG
         qVD4h3+flmoNLfvNr8XG1qHccmwuEQTXN3n6S3nW/dhsqg7Op8YobSgdlKwlX6DV825n
         sKjPel7l+9Nc01ziYDP43iMStehSXT6qGFFcx/P1yHUDakjt1Kl7Kp/qWcY73lprFsQ0
         2HHpZEzRSKMWitlYYXmoB/bqvyZZDew08gv5esmHfSyIZ/VZwgHkAvQ2TqxEQF9yXCQW
         tMI7vAqLk9wOHSGcW2iL7dUy+i+IoS2KFS/n0ceqhSZxSrbv3NVTyGi8GCj2+DzX+y49
         pIJQ==
X-Gm-Message-State: AOAM531AdlGPr7wY5S1uk/i/CVYXKkmdVdFggnKxOBlA5bov2clbukvU
        /Y2kAQzsvviXQL8Fw4U6xw==
X-Google-Smtp-Source: ABdhPJy/f6UDJcqheeX3Wp6d7KXyV3s1h+mRgU/uNf9xJBcs+OwblOr2J61bsFp4jbg6KCypJKZAyg==
X-Received: by 2002:ad4:5bc3:: with SMTP id t3mr3508199qvt.47.1640197668674;
        Wed, 22 Dec 2021 10:27:48 -0800 (PST)
Received: from robh.at.kernel.org ([24.55.105.145])
        by smtp.gmail.com with ESMTPSA id i6sm2634208qkn.26.2021.12.22.10.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 10:27:48 -0800 (PST)
Received: (nullmailer pid 2462762 invoked by uid 1000);
        Wed, 22 Dec 2021 18:27:45 -0000
Date:   Wed, 22 Dec 2021 14:27:45 -0400
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     dmaengine@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-serial@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        netdev@vger.kernel.org,
        Michael Turquette <mturquette@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-gpio@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-clk@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Stephen Boyd <sboyd@kernel.org>
Subject: Re: [PATCH 11/16] dt-bindings: pinctrl: renesas: Document RZ/V2L
 pinctrl
Message-ID: <YcNuIdH+M/SE+UZQ@robh.at.kernel.org>
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20211221094717.16187-12-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221094717.16187-12-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Dec 2021 09:47:12 +0000, Lad Prabhakar wrote:
> From: Biju Das <biju.das.jz@bp.renesas.com>
> 
> Document Renesas RZ/V2L pinctrl bindings. The RZ/V2L is package- and
> pin-compatible with the RZ/G2L. No driver changes are required as RZ/G2L
> compatible string "renesas,r9a07g044-pinctrl" will be used as a fallback.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  .../bindings/pinctrl/renesas,rzg2l-pinctrl.yaml   | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 

With the indentation fixed:

Acked-by: Rob Herring <robh@kernel.org>
