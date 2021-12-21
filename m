Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A761047C19C
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 15:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238521AbhLUOgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 09:36:13 -0500
Received: from mail-qv1-f54.google.com ([209.85.219.54]:39554 "EHLO
        mail-qv1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234548AbhLUOgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 09:36:12 -0500
Received: by mail-qv1-f54.google.com with SMTP id g15so11243446qvi.6;
        Tue, 21 Dec 2021 06:36:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=DAgxIL5+LfBMOUij7dixBA2kzok+uhqjW0YOVP3FJ64=;
        b=iPqQbnlc5nFOllfSKi7vz2BQst5cYpXBWvcKH2KEQVbvvGNBfbr+wC0BXMaOBbw9Um
         UyMfW2guV3g5SFzi4Xf8nar2CaS3crpjp1IAAL2FrmF8xwLnkLJf2zWmPna5MELV7PHz
         +k3RCGkJFLhPc8wlQR4x6PV1EhNEiHrdiTvZVqhT4MVUNtxpnE1vXzfOarVFA+dPiCzO
         i7S7qLgTTGh27JYGlwvzSlJH7xghu5w7FGKHGuJg/EYubAwu5Hv2O8wC4pka/djP58Mx
         MpiEp9q9Vdopi3DLSDpOTJpIKwqmbrn77WJ7KQthDW5NZFZqKQgo37laEXnZ1zewMoC0
         KK/g==
X-Gm-Message-State: AOAM532vTVHO4fFFcIHdRgKp7fQgXmfW6zSPkvmefcyczcjVjfgxpT6A
        QOoZ4Mm9inVrPILzKNq7hA==
X-Google-Smtp-Source: ABdhPJylBXG4muz9ukCyJcRPgG5j/wh/YvvIRKT8d1OTxRKfi+lOHWdekpwKJ6hBomGZ8F/6CfNqsA==
X-Received: by 2002:a05:6214:76a:: with SMTP id f10mr2246866qvz.80.1640097371373;
        Tue, 21 Dec 2021 06:36:11 -0800 (PST)
Received: from robh.at.kernel.org ([24.55.105.145])
        by smtp.gmail.com with ESMTPSA id u7sm14864481qkp.17.2021.12.21.06.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 06:36:10 -0800 (PST)
Received: (nullmailer pid 1365872 invoked by uid 1000);
        Tue, 21 Dec 2021 14:36:08 -0000
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>, dmaengine@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-gpio@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-clk@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20211221094717.16187-12-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20211221094717.16187-12-prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: Re: [PATCH 11/16] dt-bindings: pinctrl: renesas: Document RZ/V2L pinctrl
Date:   Tue, 21 Dec 2021 10:36:08 -0400
Message-Id: <1640097368.261963.1365871.nullmailer@robh.at.kernel.org>
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

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/pinctrl/renesas,rzg2l-pinctrl.yaml:26:13: [warning] wrong indentation: expected 14 but found 12 (indentation)

dtschema/dtc warnings/errors:

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1571555

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

