Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072BD62CCD2
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 22:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238095AbiKPViZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 16:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238401AbiKPViG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 16:38:06 -0500
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870B91F60A;
        Wed, 16 Nov 2022 13:37:55 -0800 (PST)
Received: by mail-oo1-f48.google.com with SMTP id t15-20020a4a96cf000000b0049f7e18db0dso12688ooi.10;
        Wed, 16 Nov 2022 13:37:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pcSskvio5vyYIl+GbeA90w9BhN/hk5+54+lGyz4M6zo=;
        b=qmIgq7eJhLfpn/8FttttHgLXBLmxB+DU0wh9/yDWQYW4O0+LBMPRVj0qP75gIMZVcE
         vj1+5nugRSeS7RHOMw/+19yYfPmttJszUYltgwZwe0Aj/apvsnU7NphaJDue3fjP/ACr
         VebQtGjAyyO/913wx+St5IrVZLErYS+MOP1jCMbghGNSbG/0nc9DYyjkim3rz9cAy2E5
         Q0I3P1kFmZZbXJelimGFD8CYWJbFy7PjP97UxInahP80FWbiET2TtYWkRK0pj/wgW8lt
         fYVbGw0q/ZSyvG14TeLYd0ekyR1MZp1cCZL7BhnFzRXlG7MXiylgPCGk/4TBEd+yRMtm
         HhaQ==
X-Gm-Message-State: ANoB5pkuA2HarBt/H8OTrAojaM2S4/B3h4r63AxrJDFwra/GMrGrPmoI
        SOErDP2WkCOOS+Yh75ic3w==
X-Google-Smtp-Source: AA0mqf4o4wE40C9VeOV1wdtN2y07KalDoSG7F0C8WnXwbmNqBYH/mIxFmgbgsZBfDcMvobOpZNGCEw==
X-Received: by 2002:a4a:ee06:0:b0:49f:87d0:ef5c with SMTP id bd6-20020a4aee06000000b0049f87d0ef5cmr57989oob.96.1668634674696;
        Wed, 16 Nov 2022 13:37:54 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id c64-20020a9d27c6000000b00655ca9a109bsm6983866otb.36.2022.11.16.13.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 13:37:54 -0800 (PST)
Received: (nullmailer pid 1016467 invoked by uid 1000);
        Wed, 16 Nov 2022 21:37:56 -0000
Date:   Wed, 16 Nov 2022 15:37:56 -0600
From:   Rob Herring <robh@kernel.org>
To:     Prabhakar <prabhakar.csengg@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        linux-can@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] dt-bindings: can: renesas,rcar-canfd: Document RZ/Five
 SoC
Message-ID: <166863467572.1016411.8935801189903331443.robh@kernel.org>
References: <20221115123811.1182922-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115123811.1182922-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, 15 Nov 2022 12:38:11 +0000, Prabhakar wrote:
> From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> 
> The CANFD block on the RZ/Five SoC is identical to one found on the
> RZ/G2UL SoC. "renesas,r9a07g043-canfd" compatible string will be used
> on the RZ/Five SoC so to make this clear, update the comment to include
> RZ/Five SoC.
> 
> No driver changes are required as generic compatible string
> "renesas,rzg2l-canfd" will be used as a fallback on RZ/Five SoC.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  .../devicetree/bindings/net/can/renesas,rcar-canfd.yaml         | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
