Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3436D5652D1
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 12:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbiGDK42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 06:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233689AbiGDK4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 06:56:23 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3064DDA1;
        Mon,  4 Jul 2022 03:56:21 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id e40so11231926eda.2;
        Mon, 04 Jul 2022 03:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yLNLTQJBz4K88aihRO/hyNY3I/0qFhkE7Lhod8FKE3c=;
        b=XX9JttmfJ0/zIulSmshOxmiYWgz963+s6cj2I3vDXDUT9CcC2gZu5LK2P8F/KpTJMm
         cIrCdbEKy+nFds6CN2c0mIGN7IKuZZEyVIPI2T8V8L+U3DLixL6l5zIKtIylXc9A2yVI
         IEabH0KVA3GsVUNWzqex0dFzvpN1Spt3IISxDa482tRRd/NC1PFpvE2k+OF7zq5kkiMK
         wbvFD4ZvpFY+4B+Sw73vGfy9Bls5+2QwkEWJRI79jl606fCfU1BgRaVEXZ973Ncy8MN4
         lUjv4onkb0iGKNmyTduzvLTQesZXhvlFBgs2zA3tV1+hgKZ+qHujlcnzmsaNuBWWC54G
         xgiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yLNLTQJBz4K88aihRO/hyNY3I/0qFhkE7Lhod8FKE3c=;
        b=Hc7FQY0bsVOjsOwOSlDMmBvaaubBD5pcTKSaMTyZNs3n4cgkXzyaHC/doi3k/Wg06v
         Y0S0bCnGJLnhEHmbhBz36SuHH0A5RJu3pK04Qe8KeBa2WzbvpvsxWYMjvd1gt7CFDFyV
         m52011S+9HFxlmpLZAw/iakdayqtokLlX3xsyB6EiuYA/PBLRyci+Q5IU7NnRektGqts
         67Wfo7ue4Gv89UE9SBMwWvcmAxt5zArZNSDV3RUL/RPem6F6iwbaVnByatVZ3zH+3gKF
         GFPXzspnLQYg9rsU7JwNVywrEOvPQ2Gebf9dwmIscuD0yLPnrfAk8k1wx0AZia16/UJh
         wuIw==
X-Gm-Message-State: AJIora+hb/VwUv+FQBE3PFcP9sgOs15m3+tJMjy9hdFP0/uTw6UwoQLl
        ApC7Ql2F7getk1WDdKK6Ol8OB65Vw3iRr27Aiq0=
X-Google-Smtp-Source: AGRyM1vLTWZbM65JclBW/D3ypExCkNB9vaIsK0IRrxdPcg72SmG7E09xNtFjfQQZKcQd68bq/rpP1K/5NiOlUjezuik=
X-Received: by 2002:aa7:d685:0:b0:435:7910:f110 with SMTP id
 d5-20020aa7d685000000b004357910f110mr37267629edr.247.1656932179663; Mon, 04
 Jul 2022 03:56:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220704105307.552247-1-colin.i.king@gmail.com>
In-Reply-To: <20220704105307.552247-1-colin.i.king@gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 4 Jul 2022 12:56:08 +0200
Message-ID: <CAFBinCB-dTQRMOQm1mac7gOaxj97FK-fAa-Lgz4i+erW0-PEtg@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: Fix spelling mistakes in documentation yaml
 files "is is" -> "is"
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-amlogic@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 4, 2022 at 12:53 PM Colin Ian King <colin.i.king@gmail.com> wrote:
>
> There are several occurrances of duplicated words "is" on the documentation
I think there's a typo in "occurrences".

> yaml files. Fix these.
>
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  Documentation/devicetree/bindings/arm/arm,vexpress-juno.yaml   | 2 +-
>  Documentation/devicetree/bindings/mfd/ti,lp87524-q1.yaml       | 2 +-
>  Documentation/devicetree/bindings/mfd/ti,lp87561-q1.yaml       | 2 +-
>  Documentation/devicetree/bindings/mfd/ti,lp87565-q1.yaml       | 2 +-
>  Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml | 2 +-
For amlogic,meson-dwmac.yaml:
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
