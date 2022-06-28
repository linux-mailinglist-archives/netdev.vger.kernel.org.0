Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83E955E7EA
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346747AbiF1OfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346391AbiF1OfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:35:14 -0400
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BD52B269;
        Tue, 28 Jun 2022 07:35:13 -0700 (PDT)
Received: by mail-io1-f51.google.com with SMTP id z191so13014363iof.6;
        Tue, 28 Jun 2022 07:35:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0ai+gw7dGip6YcbkUuUo39LuNyFuf2jm5c7GJoByszg=;
        b=RqJ2U3vuqX8tm+w1uYTnCgx4xp4LcqdC2t+76Gp+tx0DKXkL1mLgal3AsuwlmAxCaC
         hLfwvLz6ZbgKL8iDg6ghneeUX4RfdsiDyhP5M81FTtNnCHahgxVyO9mD/M3aYGsrPnCr
         7HhRfPzfC3+2zo5ODU0bMrX9s/ly3y6VacGuGsYEi9fNTeboUQp2ySvYXfFNv2qBinNw
         qfx3m/GiOCdRU7dxGnbSVZJHLgga7sc4RSfwY8owNYz2jsiSdc6WzHVYLcermA0smWvL
         r4tyaYlMzo22z60LEmxLExH5SjMv6sOcjoiq0lQBF3/Zy+UDJQzE8hZHnQtfltXrxulN
         GVPQ==
X-Gm-Message-State: AJIora8IPfehywgPDcsB3ok+swXLEaqrKHNMevIgGTLZ585obk2IqKNf
        q+u/sqfi2pE8XR3EryHXuw==
X-Google-Smtp-Source: AGRyM1uKaqEB6vi1TLsmVLeRCfzFwSm/gBg4hNAbNlJKnO7zeOdgTczQg6XOqflcDWWq3b597qBNPQ==
X-Received: by 2002:a05:6638:24cb:b0:33c:943f:7df3 with SMTP id y11-20020a05663824cb00b0033c943f7df3mr7423389jat.207.1656426913150;
        Tue, 28 Jun 2022 07:35:13 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id s21-20020a6bdc15000000b0067533ab9404sm3349883ioc.16.2022.06.28.07.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 07:35:12 -0700 (PDT)
Received: (nullmailer pid 422356 invoked by uid 1000);
        Tue, 28 Jun 2022 14:35:10 -0000
Date:   Tue, 28 Jun 2022 08:35:10 -0600
From:   Rob Herring <robh@kernel.org>
To:     Abel Vesa <abel.vesa@nxp.com>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        NXP Linux Team <linux-imx@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Fabio Estevam <festevam@gmail.com>,
        linux-phy@lists.infradead.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 12/12] dt-bindings: arm: freescale: scu-pd: Add
 i.MX8DXL compatible string
Message-ID: <20220628143510.GA422324-robh@kernel.org>
References: <20220607111625.1845393-1-abel.vesa@nxp.com>
 <20220607111625.1845393-13-abel.vesa@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607111625.1845393-13-abel.vesa@nxp.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 07 Jun 2022 14:16:25 +0300, Abel Vesa wrote:
> Add i.MX8DXL compatible string to the scu-pd bindings.
> 
> Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
> ---
>  Documentation/devicetree/bindings/arm/freescale/fsl,scu-pd.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
